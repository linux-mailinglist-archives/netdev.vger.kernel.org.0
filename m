Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4679266AD1E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjANRq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjANRq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:46:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0418F93DF
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:46:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7p5kX3Wf0ez338n5ooawoNUJBh/mWZ7COPXq7hkcc5PIuNyibdXBH9KSi2yRawN9i8S5M6rPV2HJUwADy/uj/MNWhW80DXK9+TBQAvRBp3Z8kyZ4osfGtXWl9HfMNluqfCui72123HIRDVwDX0GIUBOqZgptvvETgGA7gKnhmaUpIym4RxaVo3MIyYvpr9jB1cHmec25PUopAuhcDJeckvx7wM8yjQUjJRy5mZDFEbA08a5QFHyMexzVv/HjPcEfYJCOJVKthBuq9LloTDT37Lxcp39QO2uMLioxorUbhB8S+wSpRS0XXDz3Ecs+D2Dn+uXHQqUr3JHNCyCkPMOog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HucRTOacQKZIfftBnGub/pbpmterjMrBWkSuUOvSI0E=;
 b=aHLNmsHzjmBfK1TcILOFP27gYsWc3gqG9PAQvaJnpGNKItYQqBLzaEn5kmPBHspTHMH6Ncron07+CngidorSd5315xKFdZRWcxMhc6lhyug6lbU/rVzpBVbgkddk/MMvRIpdsj5gJEcO/AOgTabBQwWTr/EMHMIKDgVXzzVUr75gbaMKffdcwqGMy82/LcUDmeN2tjMV5ogJ344ZH2ZcI1qi0n3YYP5bNoV4FNGBq6NQku9b+WmFQppIh0v1L0ESA99w45Xj5PSXcILsX3nIh0qSAt6+cRt0j93cAjz8H3tc8LChDN9u5zWyDXfVffbD1c86avOitwB5WiWdf0QKjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HucRTOacQKZIfftBnGub/pbpmterjMrBWkSuUOvSI0E=;
 b=Jbz5yar0CLObow/8rDxj/zMPTQpkf4oiHsPpDi6HR+AAUkwAgQVQQ4rG1hDh5cBTLX3GD5LH3WcLmI/7CjZ1e9CZcsm4B6p2JzkvVBvsU2g0PApGF6NRvAUZ8Drv4W5ujY1mIw+OGo2IYNebYfOzbBA8H3wF6p12LKYa8CBS3xGN2cEAsasStUim9e4JCCCBRYyX/XHCVRWh5hlz9JTgkyxrZAn1O6pn5UhNQeFBfz7BJqHeNeXbYErc/lZvBLHMg9g/YBQcuLqQVA7zmP5Md+TlYYFHzq7YcDB8EkjTXMFRuVjpy/7oLas0jdK6G7yjHn+t28PW1cV5bYm+yQKxSw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CH0PR12MB5172.namprd12.prod.outlook.com (2603:10b6:610:bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Sat, 14 Jan
 2023 17:46:25 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0%5]) with mapi id 15.20.5986.023; Sat, 14 Jan 2023
 17:46:25 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH net-next 0/2] Small packet processing handling changes
Thread-Topic: [PATCH net-next 0/2] Small packet processing handling changes
Thread-Index: AQHZJ5+KRYcxJ9e3z06xRfKK0riMPa6eMJKA
Date:   Sat, 14 Jan 2023 17:46:25 +0000
Message-ID: <PH0PR12MB54814E482B05FCB4CE24D7CBDCC39@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230113223619.162405-1-parav@nvidia.com>
In-Reply-To: <20230113223619.162405-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CH0PR12MB5172:EE_
x-ms-office365-filtering-correlation-id: 8d86244f-b26d-40d3-8843-08daf65741ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kh/ilFCq4hGgcx6pQSzTdRj2NHP3XndSOP5tTa+ozYnrQ0ihkwX1TCRahChfEXv9XD5TORNEaPhQDLDduaRKd+gvwWj+1Schf+ILrvyoyP33feRAtZITknjw+Nt+8fHyebDfc/PmpGsEuUiDa/sGCuxHvKOJ+miLW9tnfIxpl1AammrB0RRFhoEUXMZqYe/WFE+eTszAFatJT2WCmLsfMqwNTavUEydUrSE2LblYaIUVjResYKaf7+OdTAe+u99dctYiqb0VcrNc0SpainridMEYMlh99ex1PfC2XlCyZc5HHwEZDV02ctXwU+LSl4asOxQ/MNVaxGUpCj8F2pGltUuc1R32GXRMTuuW/gIvF5c0A7Q3P5q2l9LLYEuxPKzjqbUtrR0rSYUeOedqQ+wqHVLbnEL6GLAYpi7fxAjig1Drzn8J6/iT+A0dWMBWLwSc4QlmbZC8hJ6BrxANygiLttpY8TFc31sOJ88y9koe3QF6MHEsVTx1wA+x1s7aic7m8kong3ypvEm+Dz1oYUuJO4lPpo9GEEvTvOr5naNVNn6s3ONVhZc2QET+84nCddI+3E9k5Cwi7FzlyosmLjVirSADRvIyeh+WotLPODHslkwEqGPUGQZCUOLcFTbxb0k/Nry5Bic15X1K6l33xbzUJNu0YwY5eQaSJIDJsxPl2wIbCwTPrSC71rbTpWJkFadAcGI+aaNrnKH7R3Wui1uf1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(6506007)(2906002)(122000001)(76116006)(5660300002)(52536014)(4744005)(8936002)(8676002)(4326008)(64756008)(66446008)(38100700002)(9686003)(478600001)(41300700001)(38070700005)(33656002)(186003)(66946007)(66476007)(7696005)(55016003)(71200400001)(66556008)(86362001)(54906003)(316002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ywVwOAM+q+8i938UFd/WIYy2kipLsAWTlXLI5ZrG/I8OjpdssGrWzajEtJCy?=
 =?us-ascii?Q?m021UWl1SioD97J9P6meT0Seisx/c2fYZjvYMZMGwM7sePw0NDCNf5ZVcInu?=
 =?us-ascii?Q?nXATdHZi+rpt291QgBUmfVzomuMUqgIgs806xZz7tg8Mdxdl4iVtR6ythXSh?=
 =?us-ascii?Q?PeVhQ38Fj4R3t1eadc0Xg8FB/xuokKcOgH8dhXQpWmvoq38hsiTAMZ3LXA5y?=
 =?us-ascii?Q?pYGx4kBgc5G9qIRWhhFrtHMf9XryVYYjBQbW74qKdLIzTNTh3VzVC847Nz2q?=
 =?us-ascii?Q?ShBHNTpLsZVtOTW9oj5oMsk6Ico8kjFAvbQu53Ag/Haw5Q3VVmWVg4XCzB0e?=
 =?us-ascii?Q?dS+KZcSQu8gtxcNEzQ2UyLr8wB/iai3tYG6xkCW0WVr81+hiDohWkGnE9KdQ?=
 =?us-ascii?Q?hxItFAnXOM8JYm2Oi+MCNexK/jGNYP5D+vEeYClHkEW7/NTmWtGq+QsWxoX6?=
 =?us-ascii?Q?HHz2Oxp1jeCb4ZMScu/ZbsFl/pb41+8T1V9UtS1PyrZEFb7Nxx1XD/jcebEv?=
 =?us-ascii?Q?+iC3GzTQbZvC5ZDcgxoQlvOk5EGp1eI+NZPP92RvV/aF9EttDy8baQLoBViH?=
 =?us-ascii?Q?FqgPZswDrg6zK8Ko73UWKXe7VHgIfzJa3zfxulARqlBFNIuV3vyV5OgXdM9L?=
 =?us-ascii?Q?EIz3yFQYU+ZscG9QezxZfZyG5RRwfCoq3RxjnwwveKS8Fc1TldG/QIKowul1?=
 =?us-ascii?Q?DzWD08nb3tETHF1xAB/qWSi5Jzf7Hu5qfxqT5vBNdGReLf07MoAOYyDGqRc9?=
 =?us-ascii?Q?xdZUG2f6NA/qbxocZ8fqMDr/i4SPBenMOJtaxEeqJaRAYk+danoj1DR0UGUN?=
 =?us-ascii?Q?EZzEJoeeEsrNeuUJvggzE6jcvH0OdnMZlerI/CMHf+D4Xsx3q/hRVwXEeIah?=
 =?us-ascii?Q?4IZS/+Enr6phyGn0C4TeUOOHgVt+fSf7+1N2VtxPL8W/NlnqSB6u803XbtPp?=
 =?us-ascii?Q?OfTvqvV8NlF5PIbKIMdbyv/DadKfoRsuZE6G5AWuUoZ5fp8kXa/kj4MPAGcc?=
 =?us-ascii?Q?QiUnm2zD9XJLtJ40LYlerlD1mrJ51ZCLjHMdwfYjkYVFrRWuTuu5sXN5EWc+?=
 =?us-ascii?Q?godrLCmH8q4dDuEyltWj2EEJdI6vOAFo+qfb95mIaUzPKxS3/ohY36A+049I?=
 =?us-ascii?Q?wrCfKGF72eo8YtdXy+ACwGefThFBuk8HBM/bN3i7ZniHMC3xozvlViNpBcQQ?=
 =?us-ascii?Q?qVPoorVUZFd+CxHlDbElObRH8J/+IAv+XgaNzJ1OJbYvr7Rt1O9c1wYZHeX+?=
 =?us-ascii?Q?dQnovTYJCjcLeRpwQ3GT4mWyhtG0MnhLJM1DggFRL2x2ExCl2rk9TScVoJNX?=
 =?us-ascii?Q?p+KPrEr7r5Nu5I0cd/4gwCT7XQOqY0yJxvjXeUleiMUj2mzlbf3RegWE6NG+?=
 =?us-ascii?Q?wHnzN7hdOKpm6PxO92sCd+HkFYt1gsPl5cQCBkH2Xw4J6mb+79TLXfAJagfO?=
 =?us-ascii?Q?znVmpXwE6uPp0IPxxP3jMYTgKiW0C7+q5o/O+xVh6/ICs56b4vy/ch0wRlFb?=
 =?us-ascii?Q?5RSTgbvrdvNV9OwVXakYeUBfPFC7YJ74Xbl0keMiNAsaeFTsm9j1yE4ceZWq?=
 =?us-ascii?Q?ezqD92t1i2Z291r0F9KtmqtdwsWGV6kuSXv/9z+M4PXu1fTCHGxLLFSDr8ns?=
 =?us-ascii?Q?VJRyNes7MNBsOV10SiAnVE8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d86244f-b26d-40d3-8843-08daf65741ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2023 17:46:25.2257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cdu7gqeehsnlsqd5VPEP00ZVrfMNYsFh4FIPiN+asM6XUxseTzZc+PsUNG5Jxy7ISsR1Z+QyGu/edmsURSCoRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5172
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

> From: Parav Pandit <parav@nvidia.com>
> Sent: Friday, January 13, 2023 5:36 PM
>=20
> Hi,
>=20
> These two changes improve the small packet handling.
>=20
> Patch summary:
> patch-1 fixes the length check by considering Ethernet 60B frame size
> patch-2 avoids code duplication by reuses existing buffer free helper
>=20
> Please review.
>=20
> Parav Pandit (2):
>   virtio_net: Fix short frame length check
>   virtio_net: Reuse buffer free function
>=20
Please drop this series.
I will drop first patch as it was wrong.
Will send 2nd patch as v2 which was reviewed.
