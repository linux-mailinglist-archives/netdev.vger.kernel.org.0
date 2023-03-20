Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B839E6C08B6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCTBrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCTBrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:47:22 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4A0C147;
        Sun, 19 Mar 2023 18:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrXXeAl3FVv2HnEUi+GHFM4m0MZV4fxB3iinbsWi9yXzSqynI4IAdeYqEF+8eXs6drD/iH1nFeTCv/Jq6fM3NrPHAJ53lYVQPwDPAnx/9irN9v9POFRQfOKNYpWVaWR6XnTU3G8akAC5O0YOg5NeEIoEtPsadbxZAFMO4FUKTNv472jla7PHf0HqFRUtVPFB1F4VEIsPKcZ/v+Hl0OSLasOfgYnFRsGTHZ3/+MGTvupCjcQQPaevJk7ur0VUPLbwQ+x4ypBo2nsGueVEebN0De5k45rUxJNm5O8dQmu9//mqHNcYWAafDU/JK/HM7Z5MYXyoNKL3mfyaBrvQqsNg9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bo7YwmBrS2t0OXmQ25ulZyHREbI3QrnowWcVaqsrFts=;
 b=FG8VFqjAxxo63E6VoiZyRJ7erxYRNXzJ5KEe2EIxPJ1qxIbMFhG59Z7K4ywCZLYtqgjraq25VqoZ1fudlYwyeobNsSKexFlVJvBznqklHhoTiJT0IkVqDHCJvcNnUvZ+L9qYNWwSf/5f7noAf2sah17ApCZlOXSpfoqJbrmAMuGUS7/0cm8JrLEdofPMihCNo7mFQhDF8aN1xV/oAhFintX4CU+yl5z2gfbXbOezekMhmSewqcTw1uRrl2cJ/iy65Cm67ndTDOPe9oXzLwqw9hVpGwrz0DtQzHOaAp14dBbBRbIEf0JmBzoPqnEUKZdWE55OdV/24D4G7Kt1FWUmUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bo7YwmBrS2t0OXmQ25ulZyHREbI3QrnowWcVaqsrFts=;
 b=V2cOPaHzTzcOYitG5nSmjo5qSrB91KmJfZ49PtoiAs3yMXq5BYMQlC27mDfujYZjoakJEF/8V0VH02096vRex1IvCrqkIcaBbFNM/KLrXIYgi+n1F2AXtGlF4kZhZurE3sLUN7IcU2hzk3HfOPDD15LmTF9wzrEA/lafiT2VRzY=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by MN2PR21MB1485.namprd21.prod.outlook.com (2603:10b6:208:205::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.2; Mon, 20 Mar
 2023 01:47:14 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787%7]) with mapi id 15.20.6254.000; Mon, 20 Mar 2023
 01:47:18 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Topic: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Index: AQHZWqm9UOpmxqzZvUOZ7L83A2HDza8CtAUAgAAu18A=
Date:   Mon, 20 Mar 2023 01:47:18 +0000
Message-ID: <PH7PR21MB31162F5F9E5C8C146760AF10CA809@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
 <20230319224642.GA239003@electric-eye.fr.zoreil.com>
In-Reply-To: <20230319224642.GA239003@electric-eye.fr.zoreil.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=75a14797-22ab-4eb1-a67b-9981a3734ddb;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-20T01:34:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|MN2PR21MB1485:EE_
x-ms-office365-filtering-correlation-id: e594837e-4bfb-462c-8ad5-08db28e509e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jXW+tR6BYl10jH3OGRJbfKLsbZYa6I0ai3m19bj9Vc4eMYVPqrGRc5ZNVLpWXHSFkglcnc9BFSUCmz2iBBrJv+s9mEpfNVGZdXZwXHE4d9dq5SuX7Vw687XGGhZwa4eCeGoG4fukgj4OxUzvskitMAJwFa5B8JX5G6B2HDqMVUbJCKDnnJe9BdwT2jFqC6F1Zb3EgsTSGXcOPheLv5w1jsc4wjFN908O++pedrNeiUyXi0Lb4STAWsot0zE5IOqIFbkFeuk+HTFmZahLRcf1A8ByVFaz6KEZAgmYh6Tb63HbxAAMGb+DpEL60UxQmzGME/JoB6BhQgQ269/tOKpntjX+2YC2EN3xBzpKkoUDNFCNLPw+bYKiP7quUJBjR2Z2EabKLj7v6vgCB5HRKb8t/Sl/AtUZLOAOedZ8XSkF/A9tmWfgYh/zhifnXIFSv0sDCAWBsOIxVmvLXAYWUmM9Qn1Mv2linIZR261k4ViTKyFRlpm8Hjehram9rbD1YjNnmLNaQvSfB1D0ZGQPJyonA8+COstxr5UTrz33c/57eGtuDErk8REn4jf4SblorQyG+hZO7GMvqODJqJ0G+gxo4JBLmZyIdtcFvUZBdesFkvI/b5iMhxGJZvMCJlo7EWhQwcCxQ/OnInqlb4uaahR51loQKEFjafU9jS9Y+fqaldc7hAKPKP3H8Pkw67N2xJGEi1msOq0IFle9jtN9x2vCD3MjBYJAO9d1tpICCq9Yxge9tmUjpmkgolPriJIJZ66g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(478600001)(316002)(10290500003)(53546011)(9686003)(26005)(6506007)(71200400001)(7696005)(54906003)(966005)(66946007)(66446008)(66556008)(66476007)(8676002)(64756008)(76116006)(186003)(6916009)(4326008)(83380400001)(41300700001)(52536014)(8936002)(7416002)(5660300002)(2906002)(122000001)(55016003)(38100700002)(86362001)(82950400001)(82960400001)(8990500004)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WsuIPjz8GHRUYGjY8/D8sdF9+WAtvklc2cCU9ImrHWEGrB0TZhj/G67fYou4?=
 =?us-ascii?Q?g8GRidJur29WCW6jYtJ+iW/ude0tVAmS8iN1ghTg0mYPusAN5WVQO9eGMBA+?=
 =?us-ascii?Q?bDyNypMmAO2k+Xa2q0wiXAGxcfFAflkOQI11Qe0cuUFbpY4y6PW3fwsSDtRS?=
 =?us-ascii?Q?5H/AEeoyMcoMcgnK9O3JKI2C0MzAq8PeNYE86W5FHTVCk1gMHfjMavXKQblh?=
 =?us-ascii?Q?xSO0MhOoNVfs9kU1iRwc4z6VeC5knfpwbR5zd4G2kmOd2wFHqHI14YIVuL96?=
 =?us-ascii?Q?ZROpJciU/v36adyUyXCV9nKwyc6ocJetRU7nljZDn5GyaiV38I2Syvf+a6QY?=
 =?us-ascii?Q?DjrSvOncsvX9yluaAhDogvgYs5/03u+few/Ofva5FFA8w/SdrQUEhNeVgKua?=
 =?us-ascii?Q?SOA96fQGJgetBn7CJgbIaoWlsok0SCTsuZ2B4YAw+AFr/gxYM9X26T+opSi8?=
 =?us-ascii?Q?lvSjrv3N2pA60SP6RmcKzoJ/xPWDCjLZepzDp5CmgVrmEUtYgiF7wSXq8TQj?=
 =?us-ascii?Q?l3EznT0VY9GqlG5/ahCA03a/kgz0cIDBZXjzY8FyRCAE04VMvlyFvGFsZxoS?=
 =?us-ascii?Q?C0dE/HaFTlxZi5fm816IHU4e5FGAVns72Lfye4zoA8Ye6KXZdlA3m3NDHgN1?=
 =?us-ascii?Q?AktM+uzN0rRyT9Qhita0HNg1VgHC+BxEwtjKl+u++oGoKiSSmUBtuKUzubrl?=
 =?us-ascii?Q?K7Db2StLAe4iRen3FiFlVszVmKK5AhIkXjYmT+0fyIykrMb8TP+oSY73y7Ja?=
 =?us-ascii?Q?QbQMs3aI7HHMPwI1+uVO2y69NvJ621RB5A5jgSFeCsIhfA7s1LUEIL4izGZC?=
 =?us-ascii?Q?eOVpqwhfiD0fcxIxW6p8PMuedZ+mDzKyEF4iI+Ey/Ob8h053WkJ6BKrnhx6j?=
 =?us-ascii?Q?0F0Jz0xVlAbcfLCy8+fuelSNzX1mB067SuvcKYiWxCrYv18cfXAau2L7n8Xu?=
 =?us-ascii?Q?nvgWzNqLQSvYqTeGrkm1Kyg0cH7VQa9afSbIu7etBsrDDd0OKVMCRqaSOCDa?=
 =?us-ascii?Q?VKS+qlNoI827U54EewQAmP7zGWItwFakpY57vMUYnIWQcS9XGHYOBuUNLDwX?=
 =?us-ascii?Q?N2ZNGbxl+yeDkN8+P2pMDo0IcDqyZBcjTjXeZhoYYW3rmzetv4UFz9O+oJsq?=
 =?us-ascii?Q?eB/8QmFs3hm5FG2/yyeMl2ULzfXUIfUxlxgj1L6tnf032qg18zeMce56fWrq?=
 =?us-ascii?Q?6FhAEqK8D8HWvepTzO3L/I/1ii8AFvCxGJQLB22o+HaejwBmJn1AndI0/M1z?=
 =?us-ascii?Q?7Ju0ZXrGxy1zK0J0hg8VWaOmzG7inEzO/QMSbcBF4q8ua+++xaP9MxFpI2dB?=
 =?us-ascii?Q?6m948rc4+2aPBvzniNlP+bOwln3VKdJ0LWH/J9KESV98e14HqZpVF6qsI6Gg?=
 =?us-ascii?Q?DgeMJ7Y3mFxWGnXaRSdQGZjXHt4xkZy+mHX1BVkDImiqaSFn2DXGoIbW4jIs?=
 =?us-ascii?Q?IcZy6Mqr6CQPjUGK/GGkZRwod63VBaTwLIZbET8DEVE7GYoI5+b2kzU5CvbW?=
 =?us-ascii?Q?oyas3FmIiJ05VpP0rTuiMbMDntDwPvDzZ1TYGQ3Nsqwiivs5uT+GsnkdzmHC?=
 =?us-ascii?Q?298Fw7/KrHZTCKnpJhbzuGTnFKzgjNtePwJHEWif?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e594837e-4bfb-462c-8ad5-08db28e509e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 01:47:18.1078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ge07HCJCKQdXxOgnTcgI88+2LjKaEH7EJoXOo/r6aDsEVwgMNIEMgyLCmuFw99LxF9rYokdpSEls4M6Q0uXhNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1485
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Francois Romieu <romieu@fr.zoreil.com>
> Sent: Sunday, March 19, 2023 6:47 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; leon@kernel.org; Long Li
> <longli@microsoft.com>; ssengar@linux.microsoft.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] net: mana: Add support for jumbo frame
>=20
> [Some people who received this message don't often get email from
> romieu@fr.zoreil.com. Learn why this is important at
> https://aka.ms/LearnAboutSenderIdentification ]
>=20
> Haiyang Zhang <haiyangz@microsoft.com> :
> [...]
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > index 492474b4d8aa..07738b7e85f2 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > @@ -427,6 +427,34 @@ static u16 mana_select_queue(struct net_device
> *ndev, struct sk_buff *skb,
> >       return txq;
> >  }
> >
> > +static int mana_change_mtu(struct net_device *ndev, int new_mtu)
> > +{
> > +     unsigned int old_mtu =3D ndev->mtu;
> > +     int err, err2;
> > +
> > +     err =3D mana_detach(ndev, false);
> > +     if (err) {
> > +             netdev_err(ndev, "mana_detach failed: %d\n", err);
> > +             return err;
> > +     }
> > +
> > +     ndev->mtu =3D new_mtu;
> > +
> > +     err =3D mana_attach(ndev);
> > +     if (!err)
> > +             return 0;
> > +
> > +     netdev_err(ndev, "mana_attach failed: %d\n", err);
> > +
> > +     /* Try to roll it back to the old configuration. */
> > +     ndev->mtu =3D old_mtu;
> > +     err2 =3D mana_attach(ndev);
> > +     if (err2)
> > +             netdev_err(ndev, "mana re-attach failed: %d\n", err2);
> > +
> > +     return err;
> > +}
>=20
> I do not see where the driver could depend on the MTU. Even if it fails,
> a single call to mana_change_mtu should thus never wreck the old working
> state/configuration.
>=20
> Stated differently, the detach/attach implementation is simple but
> it makes the driver less reliable than it could be.
>=20
> No ?

No, it doesn't make the driver less reliable. To safely remove and realloca=
te=20
DMA buffers with different size, we have to stop the traffic. So, mana_deta=
ch()=20
is called. We also call mana_detach() in mana_close(). So the process in=20
mana_change_mtu() is no more risky than ifdown/ifup of the NIC.=20

In some rare cases, if the system memory is running really low, the bigger=
=20
buffer allocation may fail, so we re-try with the previous MTU. I don't exp=
ect=20
it to fail again. But we still check & log the error code for completeness =
and=20
debugging.

Thanks,
- Haiyang



