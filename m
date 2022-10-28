Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052F0610E81
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJ1Kc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJ1KcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:32:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79C7275C0
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:32:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdM9HM0+9frm3M7+XsypYgS1NuL5lQFJkUcvCrvn+Xv4EiHtPxFg4HmY1GTM7aHSG/5GsPV/+vywWAZznO4bOtZLK9N6F7iP6S2cGHSSKGhrfcGiZDhlnP9beb1Nazas/G7TETjVca2Sk9+01oOoEPMHi0BjFrmWmi85ol+VfrQVWAwXbjrL083JtuCxwtvbO7Xt8cYbTXBBd4gL1uXmr6vLe7P0CTh6EAVcQ9wNUE3ubbsWNFxARGrlC720brbf4HteLnG131yQpCq9fzxQNQYI6th31o2JQMqntUjVJDoONguL+Nopvk6ZqcRNg6LZ+tNzgzT6aA+qWvSOFsmnJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uzpee5VSDsVgWDhAnEAqRMuodltIVnIjP4vVzkRMLhQ=;
 b=IVKcGgevzoY8b5PWYHI4Cq2djpUWvHsC8N0CtBDF75vSJwH8CaunvovnipRkzZvf2tLSGW8Xgyo8u0SeJ6MVpcWZzic1UUmb97zC0z47PLUKtZonUQukWQuO6GJeEim470/wHmZyGnmTlvPRm06F18UEQowdTpnFdFLn3kz+sWmE7vxJ4q0siHZkftCSBBnVgxMjEh4DHeEwwZ/lCiMkZV6uNlr4UOesMMxXyNMEkACntrFN9jQqI1yLfQsms6Bo/Q3RYP7GpRVEwA1HsTPoiTSrDmvS4SI4KI2ZQccMFhU2KTnkUQSf5hs/m+aojWpoZh4bMJ0f/q9dmvLAAJUAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uzpee5VSDsVgWDhAnEAqRMuodltIVnIjP4vVzkRMLhQ=;
 b=aQ9dOjapUXmlcN9uBSS/WdmWAOCh/OE9b+x/ossvNgLBn1v5cwDSWwuNKtBjB3swGDyAwA8VlF3JSptevABdRi4Cxqv0OCLS1pjufPJlK90xyTRgKgxKNg3jFnuArmcOfk+24BRdNYyGP4qroX8VTvqKIRV66NTw6SU+WI/rc91R/4PAQANU7fQJ5sBaLM+I3KbgjOPGSUbFaZDZOjIoeZT9SNe9zwWwaA6c0AA24x4RGHQ7ITGPRiaA70XS6syma0S/VpNhbhxLT8bHaLq8I+VAUTF6dZnVVmMe3MCQIcx5eXU9+7FmcthPPq2n9OGeThA+P8nSUILYEFQsQg74cg==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by PH7PR12MB5760.namprd12.prod.outlook.com (2603:10b6:510:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 10:32:23 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7%7]) with mapi id 15.20.5723.029; Fri, 28 Oct 2022
 10:32:23 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Aurelien Aptel <aaptel@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v7 01/23] net: Introduce direct data placement tcp offload
Thread-Topic: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Thread-Index: AQHY6HobywKcS3CUh0e9rdSVQmztBq4ftFCAgAENjtCAABwdgIACt6KA
Date:   Fri, 28 Oct 2022 10:32:22 +0000
Message-ID: <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221026092449.5f839b36@kernel.org>
In-Reply-To: <20221026092449.5f839b36@kernel.org>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|PH7PR12MB5760:EE_
x-ms-office365-filtering-correlation-id: b6412c2e-d744-4755-c35e-08dab8cfb31b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A7xy3YQgCOLnO0H8q4CkSTSi5eQsdFgOI+SbQ7pItaVg4PNTBktNBIRbvlIkwDP90ByXGgPsfXc9Mxgz8a8FWhLWsNceNiakdnFA8Xo1ara0qjwEuGHoKJF/nQwZO1aLvyxyE1NnKzjdJJhparysP6DfY+PGTnQcqhoeRevCXX8jxOkRQnHA0Nu7WljM5CVzkDzFCQAlffCnyeKF16xJNnItE+qsbbme1REZuILRbAgzpKYHB0xjkHyC9DEEDSD0yYVn74nBvYpl+d14i22aySK6jaSX3gUkU1c3Mrn6/9bvTTzMmJP1E8wN2kWuA66nqHoOiZ/mU4s3Kds3iwRtMmMoupcZfXNdi2z7S/AKJEilRtjWpC6Zfpw5395p4TWQaa9/j2RLWwq0p7MTEeURxInRet/rj5jphh9ZdomalGMRHrwAiU/aamfKHlevbPIIhTxoogEUgPiUjzcWcPipiAdJYgx1H8HKkOpAdtR0/K3RU9rfHFGBuWnjsSELxmdgWtLK7hf3Pdzb534RJHwIcV0sbF75XTOzthyl6r6o+P0VD34r/Mem/kKpri+pnZy6HYsgnQK55HcTT4OX2j8OFb0qrTK4pIH55nVeXrcpFa+LnDHasrQf/rAOYhnAJ7cD/eS+107hKST3sPa0gX+lo93JdESZRiHiA0eyHp2qfj9pAZGz1+Mgu8/ac/eYWA52JjNUgAgS3ncK8MD2tFE0pr+Dt4yLxQD81UZE+cz8sYhMH/WZyqz/QdMdRSA8Izy+coUVWW54wAwXbM1RcvzCew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(7696005)(33656002)(86362001)(38070700005)(38100700002)(122000001)(83380400001)(186003)(6506007)(9686003)(26005)(478600001)(2906002)(7416002)(5660300002)(52536014)(66556008)(8936002)(41300700001)(54906003)(64756008)(66446008)(8676002)(4326008)(76116006)(55016003)(66946007)(66476007)(316002)(6916009)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z7sOov7PmNr50qgG9yc6IWNJfjDOOUja63JureRHy0Dq/FfYriORCIt/FP39?=
 =?us-ascii?Q?Z8rA5MwqRvgOusVyEUxpNIiyUwgrWZblQHnXr/uvipoLlgzCCBpMBC0YL5gW?=
 =?us-ascii?Q?8sq/pOWq+mva58G7Froa05g5wOXtLrb723RSoy+ie26afczNdrJABIY4u+N7?=
 =?us-ascii?Q?ZMkNZ24tvqcIKXVW7Z8vMcukZwqQixf4kkdvj0VL5GwKewLLrao6NER78Ws1?=
 =?us-ascii?Q?ApZ0/LufmJaHNehkpTSVWnJZU7Kk6IbfLJh4soV1XYnSI3lzBU0a64mx/Oej?=
 =?us-ascii?Q?oCRkXmMEAYXsyb4mrKIKZgR7ADagUcsf5sA3feCjQ2zfutMV31iFG13ux9WB?=
 =?us-ascii?Q?b9iig9rRH5uh50Kf9RdQR8tN9KC/IYNjG3Vf2VNsnYIlh5D1Cy0UGPNdirxy?=
 =?us-ascii?Q?lJBYy5Z3DazzU/us2MYqfS1c0ocRJ5qe9jvaz9gFTphCS4tpylI5beEfQzV1?=
 =?us-ascii?Q?85RCdKVGVJLtwGf83B0CuIECzJcWQeeoiwyHyRMIWK8rDXaNbKphoOdosLti?=
 =?us-ascii?Q?CtBrXJz+9MA+2fPfPiTEidAeI2xqx9sBreFI/opmvRdlQy654v/shg8FHWi7?=
 =?us-ascii?Q?qNmNzQWpXQnPGp3scuDiZxXJ0pLwzDvnM2GF+DG7TR0fhmucNvCV/BIfmoeS?=
 =?us-ascii?Q?qJyiW667Wztqer7aoIHmkGyVCgEXiDlBQvAD9VB36PNe0FKNqFlNO42j8KoY?=
 =?us-ascii?Q?M0xKRKWYMQxI5NQtreTOVNIGFo8NwL89i2dpPAKAwgx2V8IEW1zldl8+h/PI?=
 =?us-ascii?Q?2HaxFDqQOlswz0F6PrzPcB0P6g2FXdZKYiwcS7fReRdwMCLCNH81LBrMqxbi?=
 =?us-ascii?Q?7aqFz2fzAeAG10vbcaT8ilk6lXC27tgpNb294QhG94UivAHsEv21p2Y+VeNz?=
 =?us-ascii?Q?meLWaL7n3skxToACv1uLNSzaPTWca3ojlfz1JIRDltYYgAsDMrIRZhOd8G0b?=
 =?us-ascii?Q?+rJbyUtdnkeFWO6yj5FoYVBnNWFFlqn7EwCpurInYiVpuU9G/V90P3wZqLtC?=
 =?us-ascii?Q?gPjWJ+bddkPi988w78RpBuOhfrA4E8eBf1K/Q0CbP8es9Xcmp0JpGdqvk4Xr?=
 =?us-ascii?Q?5ixEbfH3ekEIbF5D10QzogrJTQsXi6Jvjq9eO2+OorBshhzwwWkuATmBoBdT?=
 =?us-ascii?Q?rfnsUAzYOhboDzbWbtmg8bXqQm8lCNrpFWVxj3RpjnHiTRJ1fpSn+Qq4Geqi?=
 =?us-ascii?Q?LyvllK000WIQ5wxZaYM+otHo5n37e2H+l9uaZM0mGbM4kYZz54FTsljoVJ8f?=
 =?us-ascii?Q?ixPN4fcQiyy9dSeY/7ZLOm+9w3w+gL4GlwurYeCq2Mfnb6Z+j+YQl7CPxPgJ?=
 =?us-ascii?Q?pyOo6YGP8Qe3PK/EstrGS29TN4adtAkOrMa4DArqYp99Y8rAYN6QnTjBgmpB?=
 =?us-ascii?Q?1GF0vd+U3mfaAlVN4qhLIIwjRUk8EDKUkS0aWbKvcLT7eDeCd/yWiNMWzaOX?=
 =?us-ascii?Q?WrkDN6ptiG9mUEFWpMjNN1sS+rISQ4j8T7VceC7+yp67ETVoLnYoX7mkeWOh?=
 =?us-ascii?Q?MT+sW0X7xQ+YGKqLg/ib3k/W/x2FbJmU21nTwhWrRFhxSPBFMOYUA8AYgqSH?=
 =?us-ascii?Q?xxR6IedrVtx17xTBsy87ACN3QIENEs8IUT29B0KN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6412c2e-d744-4755-c35e-08dab8cfb31b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 10:32:22.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /xZx98o1TOlN9C6DBzqzf0s34WuxtQZjjNA9U837iIRW3zuFVZ7laXfA9ZKqP41zWzNwhpUvLe8XFMCQlVU2CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5760
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Wed, 26 Oct 2022 at 17:24, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 26 Oct 2022 15:01:42 +0000 Shai Malin wrote:
> > > > @@ -14,7 +14,7 @@ typedef u64 netdev_features_t;
> > > >  enum {
> > > >       NETIF_F_SG_BIT,                 /* Scatter/gather IO. */
> > > >       NETIF_F_IP_CSUM_BIT,            /* Can checksum TCP/UDP over
> IPv4. */
> > > > -     __UNUSED_NETIF_F_1,
> > > > +     NETIF_F_HW_ULP_DDP_BIT,         /* ULP direct data placement
> offload */
> > >
> > > Why do you need a feature bit if there is a whole caps / limit queryi=
ng
> > > mechanism?
> >
> > The caps are used for the HW device to publish the supported
> > capabilities/limitation, while the feature bit is used for the DDP
> > enablement "per net-device".
> >
> > Disabling will be required in case that another feature which is
> > mutually exclusive to the DDP is needed (as an example in the mlx case,
> > CQE compress which is controlled from ethtool).
>=20
> It's a big enough feature to add a genetlink or at least a ethtool
> command to control. If you add more L5 protos presumably you'll want
> to control disable / enable separately for them. Also it'd be cleaner
> to expose the full capabilities and report stats via a dedicated API.
> Feature bits are not a good fix for complex control-pathy features.

With our existing design, we are supporting a bundle of DDP + CRC offload.
We don't see the value of letting the user control it individually.

The capabilities bits were added in order to allow future devices which=20
supported only one of the capabilities to plug into the infrastructure=20
or to allow additional capabilities/protocols.
We could expose the caps via ethtool as regular netdev features, it would=20
make everything simpler and cleaner, but the problem is that features have=
=20
run out of bits (all 64 are taken, and we understand the challenge with=20
changing that).

We could add a new ethtool command, but on the kernel side it would be=20
quite redundant as we would essentially re-implement feature flag processin=
g=20
(comparing string of features names and enabling bits).

What do you think?

>=20
> > > It's somewhat unclear to me why we add ops to struct net_device,
> > > rather than to ops.. can you explain?
> >
> > We were trying to follow the TLS design which is similar.
>=20
> Ack, TLS should really move as well, IMHO, but that's a separate convo.
>=20
> > Can you please clarify what do you mean by "rather than to ops.."?
>=20
> Add the ulp_dpp_ops pointer to struct net_device_ops rather than struct
> net_device.

Sure, will be fixed in v8.

