Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF64E57127C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiGLGu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiGLGuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:50:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAE323BDC
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:50:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2SOBm/jk5CDkT9HA4zptD9LJS0FteJVWNxTAjXKzcA/uuvVM8M+TpXyM3oKz3CHy8+5SQ7wVtpwyeD0s/kg6lu1MVHxAB3vSDZcEU+CZ7EMXyCYuvjgroI3B4gUSZQBh2q4DotcUexkGNN8CBtIGJmT/70l0abvxvw3MYfR9DWT4pRwwW5zPKwUDGjUfCpnw4qx555hPZ7Q+5CxDOODyPIc9KCXH8A8taMfn8a1ouzswYj8LITfYm6hsvslTx0qAjRrCuoFVzqz6ZlYJmhnDuwJOSURy1mbIvQi7Z21QuFqNQImEWHreR7YlZJtZDmLrLA/47YVH77oMoPEKTqUiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9Ylx37thllPMnhdYKZ1Frew02SGllg83yMjeNTwCRk=;
 b=QT8Gzy26jhHOQTiQntyIOaYc7HM4irHAPG2qH/f7CR4H8iHwAK07zZ6tUEP/7HU0f2kvQ74J8Ovg+yRSIThlFhyVOjkDoFrydLb6AyyTmAT2jzyqT2ljf55Tu2LjcWg/W8dczuf4q8lxiWJ0nkKM6jkPg25Ybs5auY8vkFJmkJoxijPg6dHFgUNhPiH+UoMIM/+jdB5pfnVQmjfKq1YzDjXenRs+8R5cVt+ec446upkBmPpNMPt6OpKJ+G2sXZxw4RA8Ccj4PjJ+Y1Q9G0CMGmIx5yhk3Dzhbo71dPmIycinVQCQvA1eWyfhlJQgKpNSFSFWtL9VnturG5eChdhzvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9Ylx37thllPMnhdYKZ1Frew02SGllg83yMjeNTwCRk=;
 b=ZX+Qhkih45UBUEvP6p45n2iGuCByqfxtnZLx16oVZ7Ik52jpjVYsAIrsLDy/bRBRODslSK5RNmq8Qw9yzWZOVIhn37Lw/7YiNy6mFhrXsEyoat8ae0lhc7Ay9UVBxJHJfxEm7TzOZ2RDM7BNJWI5kMYlSnF04iH96tA5quyTFgL9bryI4Eyd8KmuyX32b9AAywDr0REW5W3ZciGqUpWSA1QwT6oOFEpIbmtbjioC8e2QrVWv2cE5RSqeYLW+zykcQy7yNlR4UoxRT411hmLHcjaO8IJjgjH+ya0SwphJRnEi/S6lL0XrBV6Lk8XnOhmySFCQq6dyYvypfZyTSJ0+tg==
Received: from PH0PR12MB5449.namprd12.prod.outlook.com (2603:10b6:510:e7::24)
 by BYAPR12MB4709.namprd12.prod.outlook.com (2603:10b6:a03:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Tue, 12 Jul
 2022 06:50:53 +0000
Received: from PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::f15d:45d1:4f02:5b52]) by PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::f15d:45d1:4f02:5b52%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 06:50:52 +0000
From:   Lior Nahmanson <liorna@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
Subject: RE: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Thread-Topic: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Thread-Index: AQHYfxeLrA1D4yQ9x0eLs4ha9L+iN61O7o2AgAAm9ACACrctoIAAfs2AgCAspAA=
Date:   Tue, 12 Jul 2022 06:50:52 +0000
Message-ID: <PH0PR12MB54490D24F44759ACDABC950FBF869@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
        <20220613111942.12726-3-liorna@nvidia.com>
        <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
        <20220614091438.3d0665d9@kernel.org>
        <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
 <20220621122641.3cba3d38@kernel.org>
In-Reply-To: <20220621122641.3cba3d38@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5759d3dc-4ec2-454d-35ec-08da63d2dced
x-ms-traffictypediagnostic: BYAPR12MB4709:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ulrsCp7yM2jS1U1oOrdtqHj7G6Axadsk2EoMTe7BYeirrWMMMJiZPC2uxhUmFlo1m5nFLb+51ylMpBWQR9URABS72x5hBnschGTqF3I+CoNISGEe807iakiRFRb+13ukKAWad3MbyFUs+1MKEfURgjFzDj40Uf86Sv0OFXZsh5HMEwy+DNux2LOrzgRyFX57G4DJPtZimAy971YcxTB9jhExk2oqK9iVaYhVLy4P23Obt/b1pGJ1Kmv5ca89Z0p2JyBlo1FTCbjiqpEFp8v4U5zePQJkkfSTjY75RjRMBq8IC/KH88BvzQOK/vbAd0SbyybwHA9tmIpkY3XV31gJg5kD4eDrG9cy7nFRtg2gAH7D2IdIP3gIu8fispv669LSj6Q7N4JLUIB/aKapU04Pl4UZe/jUoC6JRNYUwn1Y3bdb7L9OdMi9qewg3EWpCcgGNznosrEx+2N6XiT4oRVSGnksYZQiJu3nyuS1kKPqPAvBvEy2+t21eQUxkLX6upiflSR1m09yGo4rc9EehhCni4k9qyTPB166cj7b/wHzjUYUsWV/uAnevnMbJqpyT/VzzBQtk+3mwr1H/I0QQwIQtgpRzoRmIBvdRsS5L+vp5jCqrNoIvXkyGJHwQfZZWcfyugBlW54XnhY6fi8rAfGK4aKp4b1ewyHQ95oelZaNebG84XDPu6wSIwx62u8eUyq+Jt3RLKziXpz3msVH3YiHHvo4gQ4VJ4yt4exfAoU744hMZm2LBGbwMBEyKWi9N9pem4HQ7wFqWCToS2mYjqj+Hw+C7iqTB1Zj+NNCkYQwmDOE8VpzfY4zQkXqvS6UVpii
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5449.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(76116006)(6506007)(9686003)(86362001)(6916009)(8676002)(186003)(4326008)(7696005)(66946007)(71200400001)(2906002)(478600001)(107886003)(41300700001)(26005)(66446008)(54906003)(64756008)(66476007)(66556008)(38070700005)(316002)(38100700002)(122000001)(5660300002)(52536014)(33656002)(8936002)(55016003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MRtuUBTY5e1vZY9HzXuXBDtCwgwiEom9VeZFlRGre+23uucRzGswOJCbbg+k?=
 =?us-ascii?Q?0DXF7lFnwAoL3rConH4Plts9Lscu9y/grQDGr7TZeuf8HTaTnB9IhHfA0a9D?=
 =?us-ascii?Q?/MbvyPFfVYcQTiRiuvPqnHVXO5HqmkL8rl2XZpgPNL2YjpLDHafRNBKNSt90?=
 =?us-ascii?Q?p7iD31YW3vQ8pHWhsfjdlS76rAPS+rDerM1VaaGUPxvmLzc5e2/l0T+wdrCG?=
 =?us-ascii?Q?wg+3Odp61QSThaqeb5K63UFTUDzomw6jBD8VaPOzxkz08XZxuBBXuqAZzo1C?=
 =?us-ascii?Q?xv4fyUjm8Wjd1D60w5xouijppYUIdozgQZwX4QcePCsC+E3BFjCLSdtIlzeq?=
 =?us-ascii?Q?sEuyHKui8cYrXypjBHWCxS9GSqA/JM9CCOmOhcYVZtVEtpFwSShPQUYizSJh?=
 =?us-ascii?Q?zJ8kPYoK2tmmlrPn7Yn1O02Oh3mTvxHKVV0UbbnOs9nVpljIUrOZbDmBKDdm?=
 =?us-ascii?Q?p9xfxwofZjIEh6+sPjoEXAAHV0jXy/WyzZ+m0mhAyBsKFIqFJYMHV93sIEGi?=
 =?us-ascii?Q?xITOst39/1I7GyzosD0lhBwu3nWU/mAMGQDa2DRvEGW9Sdph0CjE3CGnsZrj?=
 =?us-ascii?Q?TcJx7bTyQ8m5IkubFuTbBwfb2rdqMss6yHSdPxIg3UOm/wQzt3xpyL/cn4cx?=
 =?us-ascii?Q?dNVl7FVOssKpwDwymmJ5ZT2n0jXG2fp76Ji9Q5uf4+6mdTFYXR80ULlD2vO1?=
 =?us-ascii?Q?FVBaU+YLwwsxAMFmW6nxiScFccCjXJxsvpJY6WImg+ymI1Ra3zgL9I+T4W1o?=
 =?us-ascii?Q?fFcD47+/00FjDVKNy969/zLblLaI+NHCGLl/12tMmEbk0OJMBNLAZu2R4NqH?=
 =?us-ascii?Q?wgkaCfjMfD4E0WmitMW8W/ho+689BieGvR6tsJEy69p3X6iEPF/jvAtE/aEK?=
 =?us-ascii?Q?LYkzeI4sYniW9eyMl1LLOVhNqgvDG5HI44rG7CyinAEm5Q7G5FPoCZKsWUpu?=
 =?us-ascii?Q?bfFtvIMhAOfR7UWzLc1aPvqeqPcuCv/SdlNVW7q9r/0+LeIFgjO60W63R1Ix?=
 =?us-ascii?Q?lvYN5A1noN/Ge06V50aHFeS/P16IWW5GqfJ3qc9jviKej+mUMc6QG3WLdC0g?=
 =?us-ascii?Q?FPuESTzq5L3MKAElL2Sr8lfbSWxZGLtaXilA0L63pnZRzyOJgJ3fH4vXActe?=
 =?us-ascii?Q?qRRSIXycG54UgVKQ1GaQVx+43NvWXfrIVkCMVtf7u3EVMpikdSheFOmThQDB?=
 =?us-ascii?Q?z7Ygs/MlcTXhN7Pgp05ea6/SEe7SfpKhD9wWXLBgBdSqUOhIrXc5fUn6kyiB?=
 =?us-ascii?Q?a/BN8t0hmXqSQ04OuDcRUv4lMUQrz+SoY/pRqHyiceHfJ6NorWhyb75jaa0i?=
 =?us-ascii?Q?hLVB/ERW17ubJfJZFqd11V+xPEfNPYjgMfBTkCQ8MNNvNa8ONAqpe5ihYL5i?=
 =?us-ascii?Q?zB0o9eJCj+0KXLj5zUIQJKWA1rwBNeNgSkdsxn1IHpcx7qNF9+sq/zTQf9bI?=
 =?us-ascii?Q?BMBOo3G7eV/cvnTWcfMPSa7PDa1a/wmxnE5QvOyVrLaQ4cnQTRNZ4Hkzm0gV?=
 =?us-ascii?Q?X1nQcu+oMSoQVehmupxEz0s4ag1bBEAAOrDBvAuXvc3H90H7ABY01T9uQIwT?=
 =?us-ascii?Q?CYqtRvlrJWMKGoCRpivJJGoRKBx91Hd6vbQ9e2Lv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5449.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5759d3dc-4ec2-454d-35ec-08da63d2dced
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 06:50:52.7005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KIXsfVp9tyJW/PDLjuy3xnHL0fJzQhMUeC1QBJGJvKx6Mm9kr1C3zyM1YWrVigrIlpRR8twfklGoOg0LFdjN8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4709
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > On Tue, 21 Jun 2022 12:39:23 +0000 Lior Nahmanson wrote:
> > > Shooting from the hip a little bit, but macsec being a tightly bound
> > > L2 upper maybe metadata dst is a workable solution for carrying the
> > > sci and offload status between upper and lower? The range of values
> > > should be well known and limited.
> >
> > Under the assumption that by skb_metadata you meant metadata_dst,
>=20
> Can you show me in my email where I said skb_metadata?
>=20
> > I think there are few reasons why i think is better to use skb extensio=
ns:
> >
> > 1. Unlike skb extension, the metadata_dst deallaction is handled direct=
ly by
> the allocator.
> > Since the sci and offloaded fields are shared between the MACsec
> > driver and the offload driver (in our case mlx5 driver), for Rx, the
> > metadata_dst allocation is done in the mlx5 driver, while the deallocti=
on
> should be done in the MACsec driver.
> > This is undesired behavior.
>=20
> You allocate metadata skb once and then attach it to the skbs.
>=20
> > 2. medadata_dst is attached to the skb using skb_dst_set(), which set t=
he
> slow_gro bit.
> > So there is no gain regarding slow_gro flow.
> >
> > 3. metadata_dst allocation require much more memory than needed for
> > MACsec use case (mainly because struct dst_entry which seems redundant
> for this case).

i considered the usage of skb_metadata_dst, however i still think
that skb_ext will fit more to MACsec offload implementation for the followi=
ng reasons:
1. for Rx, each skb can have a different SCI and offloaded values which man=
date allocation
    of metadata_dst for each skb which contradicts the desired usage for sk=
b_metadata_dst where
    it's allocated once and a refcnt held whenever used.
2. skb_ext method is used in a similar IPsec offload implementation which i=
n the future could make it easier
    to refactor this section to unify all crypto offloads skb_ext usage.

apologize for the late respond.
