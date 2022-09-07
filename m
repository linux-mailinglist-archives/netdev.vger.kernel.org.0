Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D645B0D86
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIGTy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIGTy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:54:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82C52DFF
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:54:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFCJLbhU9/XId8koS7B/z3f4exs1vAGzyUQhpv4TCq+X0L0hkL32gCt8k899s9E9PLxUlOEqm+R0B7S1uaJ8REwKvu50F4ppqDLQA7Jy37cCCTZvcvwZgAqksb8wEbTcveS5YqN41RNZuPFnO1w6aNLZke6EfaewytwF/t/K3yWIiL/gu64kpxP00eTOvW8PpYsDYSeBmm9QsW8J04HK3Zx0Id+EF/MTIzorkphBZ5ug6PReU+EL6JYUn/imfpRdMzB5UipHWNkGgLBz5e8I7h5kGPL5W07drqRrHiq3MTb4KUUxeZRXsJKdX7tlDDk3Q1rgaekgsAKcCrESndoakw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sg7ooydtuuwmh9Z1DvxX4xivEXkREppQgv1tlvXJSKk=;
 b=kjKOj7QQfIKjwLXzBi/8uA/vZMmds0Pe9teoPlw0GdL/EVTUFl19Ovnn+WHx2ay49Wl97qTcvA4E+uyh2IOf2tAtohHGBS5zsypocgZosVVkEsVi38PMZFCrS38Glb6F9rXXB1IuOq4PlVUBznG0iVRrlvnQnMrqeuSCEW3SKuH2Qa2PGlddkuDFGHuPOWnJfvWYVylkQin+eBWVu9WvpSHBP4Lx99KKg29LDdLQXXm9sL3KkDfZJ42+3Nv+Rqij/aDRjyAUEMElJNENhLqcneSFJcqMi32RquzFoBY8I14+T1kxunWB1j7GIuGYF9bit3tVt3F33uzMtAaiBi8Zsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sg7ooydtuuwmh9Z1DvxX4xivEXkREppQgv1tlvXJSKk=;
 b=C6aBrfDmN+9lZQ+iIwljM4jhdvRDVZuGoP6nN0bhT5o4fWsZQG23N6O0E0lrWTpJ4deue9bltaM2RE28KBzVxdxlyDwn1D+yqaciPOzHnEECpb5BjpCtehwdy4sNEDiwyjrH3Vs3WgJSfkP4yU3zrCnry361GYEB6Wu7rvWKeHy3uETc2+Jeq28SXd/FKP5zomhszWfYhqPe+D3kcar1q0YZxef74vxQuxTjyXE7FjdGlWdurxLmVIGNAQLsBWu+R1CYy0gX8lC8AYP1bB/kPTKXXDV/vbohvOoGwApHJ38k1OiZR20mRqQj0+jS0OIcL3gTm9C0FpnNarH63/zoBQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN9PR12MB5305.namprd12.prod.outlook.com (2603:10b6:408:102::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 19:54:55 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 19:54:55 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: RE: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Topic: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Index: AQHYwpEbqLdY6RByfkyoSMo8wpA6EK3TsrMAgABG8oCAAA3LAIAAADnAgAACroCAABYGQIAAJjCAgAALaACAAAQwAIAAAFDQgAADKICAAACIkIAAAuAAgAAAdACAAAPoMA==
Date:   Wed, 7 Sep 2022 19:54:55 +0000
Message-ID: <PH0PR12MB5481E1300D107A08A6493B1ADC419@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907153425-mutt-send-email-mst@kernel.org>
 <20220907153727-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220907153727-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|BN9PR12MB5305:EE_
x-ms-office365-filtering-correlation-id: a3e9ef7c-57f3-4ebe-a786-08da910ad5fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5GuhxJRz0x8WYKfB4i4LSlwbgTArccy9ZHTixxDt+TddSdIuvTWsuAVLTZQdqVwKkB9mY+n3GUlIiprqZ+D+tvIJ29gxZXFq6GcQSt5fH883+Vc2YZIZeiodEvb4dUanvE2pe9B/ZaHPbudNXXtjBhMxrnVaJrg9cIhEKTMl6m2J+98LVD2q0eMfYj1oPhdZSzIQbf+r4h2Bc9rfYLuNSztwbvjGXRchudsrG6BN4cjALaVfMYbT92+B9DyhqvqdH0nfn8BBUuRP5I1s2NysoGA1tPPUxDMS/73RkNGnrK2oCvJy3tYr00Q1W1SM6PQlUrx5/PuXI6iKZ9j8urBuEcJoh2tKbHtuAOzO6nDkNjFqvNoJTLXVYwCDhYaH3/EEciAdjihqfp8iSXpuzwsE72FRZXaAc3XJfRTi/+zSkNyYq99+6hrKue10Hh3Ahn+qfzmptAOTfNyipCHuEMH6bH5i0WEp26dju+19PbW25PnT7fKUH9MsKD1ROh2ULYhkL7gK3S9/eytLIYwb9q1sRU7gwRgNwgkezExTP1zWaEbNF+NhQajNpFn4i06QxB2a7jgzw3///mh11mZsJ7SwSmL23pM9Fpt4/F/oE5wg948gVfbBM2fwpzata3rS0TJ6AY7hfaJjEJ8rvtQCeBqOeHoQpjhH0AerO6jTBVEEGU13LvC98fIb3qI873+gC86TJhyiG1T3E/po7u8x7MqaI+dXgz52sHfd79vwA1Y2j1twUIrVSYjbaCDLzugAjbwyFe9VfoFhUifgm3P1tff0dQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(6506007)(186003)(41300700001)(55016003)(558084003)(71200400001)(478600001)(9686003)(26005)(38070700005)(38100700002)(7696005)(122000001)(86362001)(5660300002)(54906003)(316002)(33656002)(4326008)(8676002)(2906002)(8936002)(52536014)(66946007)(66476007)(66446008)(64756008)(66556008)(76116006)(6916009)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UFVc6v1LW6sGW8b4cEgK2Ruf0UJ17A/w3Ua+acW079NWxUOzEjPhZgMk5hYV?=
 =?us-ascii?Q?WUYICDS8LsFX5NB7ovSl0Uj1mYzOrY6IQv5TlLJORr5mKTRazzekVE5boVpa?=
 =?us-ascii?Q?QpbiU9zt6DQJSRMC6HbVQOR/9z3ysxQZXNfcJhPQEjNJbF22w45AFFTrww8/?=
 =?us-ascii?Q?8efObc0BRbL3CmEXTjZYDUMnVnJcXQW23kXBjmFX/rar6NRSO8Cr5bpvFf4c?=
 =?us-ascii?Q?+aOjGKviqQO+JW2Nt0FZ14pYzY4EvQY/5jxGXcnfU1PqsUO5QTEniTTdQT4H?=
 =?us-ascii?Q?5Vxffj3IyDNAAEOkTLRGIWcmAwYUATeMXtd6Yl12q+jGc/bdfp67C3laEcEW?=
 =?us-ascii?Q?fQVs9cQFav5CrMmg+H6OX7rTT2GPNPHVpnessNTpRQZ0xyuOXGjKuaxHAL0i?=
 =?us-ascii?Q?AOENCfnV9iHMsKG3sqW4X+CTaP1I+E5LF5ziUhmelKZ8mmjTQn9mXp3XVm9c?=
 =?us-ascii?Q?4JgplMshWyYzaTU/SIIzB5t4N1GzgCC4U80CTt2lrzxfY9cLN3c96sXmprv6?=
 =?us-ascii?Q?UEc3RdbDerk8lRXjd6LdHznqoDcOZyuMV4OnLKf3tEvuNHPEM9MBhD5R70Sw?=
 =?us-ascii?Q?GPd33rwcdhr2GaUtzgVZNc35MColoT5nLF5Nje/xu4WuaR0XAlSfXbHOTIax?=
 =?us-ascii?Q?kEAED3nJ7kdkSsbMG5cYqanumD970KNnnivRYsuOxUoPEy86TcPKhwXikR6J?=
 =?us-ascii?Q?Jaa4/TRwkEmf87SWl9kkCS0g04MWpP/2eJFrzCWmDCe/j0O5by7pCgB/Rsw8?=
 =?us-ascii?Q?Q9jK67/WNLHYkNh8N8+BNQmqFwDJe/GKRj9+hpJ6mq2pIJq0i/i3IxXqWHN2?=
 =?us-ascii?Q?6wFFFgVSdksNI++SGq7JKqgGQM9yQ1zyMXcMx8oFAUzmLlyuOtpd6urdFOQ4?=
 =?us-ascii?Q?WSIQj0vjyZQHNtzLQvpQ1wqZCFFn1EOnBmgm69YFAerU9lqBmdM6Lxh2/UFq?=
 =?us-ascii?Q?sd+E0Jw63PeUDPE0wtrR0MOUAUBkMeArUrs6XXMHpC6DrmuUlV0Li+QlCuvb?=
 =?us-ascii?Q?ZK4iDKWhwZLOYV0qqHYG+nDvsE6JIMpb1SEfvNegBjU4QEVohrAsJBTvhElk?=
 =?us-ascii?Q?SooEXUCXxYf3hzMenRdDgXmdOg+WB82+za++XS6irUxqBeY9K1KhL2FJnu7W?=
 =?us-ascii?Q?HBssq2zsN3xntK1Xkvcv/tMYx2659t1RJk3s5fhFyHcC+eqTVQCplcv8wL6W?=
 =?us-ascii?Q?SZAm7oC7kttJuVdum9HOpnMM6kSsPh+I5BRb3OiOjaHkEis/tLREeK6/S3d0?=
 =?us-ascii?Q?+MrHa7vv0BcYyKCo/aquUIVTc7iIzV0Uh3a4iYcdxve/2akV46S5iv1QfQFM?=
 =?us-ascii?Q?l1YHQnoL8OSm1LLQmPc1WcVzaFe6FvWCnOFCT2BtmOxVM9kUB4foAUVVP1Au?=
 =?us-ascii?Q?P5y0r+9xvS0NPhyoX+CYJtrEFjPFAP5imTXUKfgwGKDx6FrYCOqPsn5nucIM?=
 =?us-ascii?Q?Y5gDfbWpEFv9ZT26sGift5b0ecnT7Auvha4hGQYm4laUlPhX514/S0yJPcXa?=
 =?us-ascii?Q?gYvIDLMS9gRZNPf/CY/pCgcop3Fw7EMqHhujlunCFeazBtl1Td7/Nh+1C5AN?=
 =?us-ascii?Q?a0OcoaAYmrisP8HLazs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e9ef7c-57f3-4ebe-a786-08da910ad5fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 19:54:55.1683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lrWrkL7I8dh+PaVOHO8KYUuIrsvzroewQ6zcO68F8JTQcYRqk3tTKEaUhXXsQuhMY3M6EIht7oGC/bD0bkmHow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5305
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Wednesday, September 7, 2022 3:38 PM
>=20
> and if possible a larger ring. 1k?

What do you expect to see here for which test report should be added to com=
mit log?
What is special about 1k vs 512, 128 and 2k? is 1K default for some configu=
ration?
