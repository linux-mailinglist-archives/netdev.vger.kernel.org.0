Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5605B57257F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbiGLTQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbiGLTQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:16:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE81C106969;
        Tue, 12 Jul 2022 11:54:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbUAC1GIO1WXIvCYqsWB+GjIlY+Isib/dIy1KSiN1FIrXRXwF+fJUSwS7CVrffTz0y1Bbsup0JvbZAzFVN1kn1YFVLbfRchVHzxP7F1CDXnjs6ky5GOMt9An35oqosuV/L2nhdTFFwjl27TvO849g1e9viX08N75D65l3VlLcDkufb6gRlbxZvj2s77cjUTlB5JoAjyrfimfyK5wRHBEJJ2SmdBxxZN6jZ9yUU3L5pxI+iGTavyqLqSggysWjDVTHvuhVHBzGDeemgmUNmu07ZluKP49U8BplKtq1fiJLio1XN6UDfWei+7pZStz5WJn6lUhKkHd1+2wjXW5NpgZAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kER0im7m780k84WYx9qYS54Tc3/AYmbjrYXdZUgmA5w=;
 b=Yvrcsz8cBfISMDUeleJN7HM6+i971gJ/jn4ZbPOKcQ/LgQKVYP4r6Vysv4qQdGfDTNBDPAmyRuoWiZD0PbG6d5Xj93cPCYsKw4Vxp6VMLwCZb7IY1Y4Mgbex+eRxuZpiC7ZeUq2Z1YurLRayMVQJkqfw4rLMdnFc3SEicOutNugSh9d8th2ImZ0PjFrb1Z/EwpExeH4GHb5C3T4m1aLoKZ4o1bJyWrUOCMNAWRHOpTNROw9VRx20r4DnsyCep4cz7pEAsHvP1x7bEzcnlBwjnaTY5zdOEn+FUMF4R6vFGOqjk3gcYEKdp7SWLCaDkutz1TBiiJGrxxLgBI4EB46O7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kER0im7m780k84WYx9qYS54Tc3/AYmbjrYXdZUgmA5w=;
 b=V/d9hhX43j+QZg7xUOC4u2hJGb7tAAc2phzFBSHm9inng1XxEcX7tsWtdI5Y3UKcwk/C2C5I1Os/zg68C90dmOr6ErulyFfpHV2Kb4poIUNGo+CQyAhuU1UxUPSMOqN70ceEs/and9YHsp+xAUVXvGcRxYr8JjT4xhPEsu4yAWY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DS7PR21MB3572.namprd21.prod.outlook.com (2603:10b6:8:93::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.3; Tue, 12 Jul
 2022 18:54:47 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9%6]) with mapi id 15.20.5458.004; Tue, 12 Jul 2022
 18:54:47 +0000
From:   Long Li <longli@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 07/12] net: mana: Export Work Queue functions for use
 by RDMA driver
Thread-Topic: [Patch v4 07/12] net: mana: Export Work Queue functions for use
 by RDMA driver
Thread-Index: AQHYgSXaUwnRtTr0nEGROPSux9XDFa14iZ6AgAK1plA=
Date:   Tue, 12 Jul 2022 18:54:47 +0000
Message-ID: <PH7PR21MB3263AA690CF2D713ACD7CC9ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-8-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB1327F4D818A94D4D1C588F09BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB1327F4D818A94D4D1C588F09BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=93e21afa-271d-4db5-9c72-e1e55af0e033;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-10T01:39:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70d89a38-c5a5-4f3a-a663-08da6437fe06
x-ms-traffictypediagnostic: DS7PR21MB3572:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kt66NPApAoj9DaYncQyPossBLdHD2+116e9Q6aF3ektZAr9b6/6SFvJz3zQg3wydw+mInpvUl8P/IADDMgB/M98ryYjpaDhScXhwiGrbWTc3W88vzSyviqeV3WWrcRhDNOLhKny4T6OEP6GxiTxx0h4A3xz7YIvUyeifY9ibQ9MP77iIYaoGf/ayUwqr3hPue8/DaGGEJPrSb+2bhlakWsfhJKtN+z2W4ooKF8axwvSBAV/ZQ+hqNszmzj8O8ggvhQ8n4ZqtptlZw9v7iT7KzQCRsL5CG0Lo7HvbcdVx6jIMnGZeApoIGESy1VLzn06RpBhipylUY391Tl3mw2HPGK80Cc4GqIl1zejwfHNTCV+ApZajGnc55ymBaQ4PRLbemBqELGtcBMQEL+ExmrK/EaoZIT8F4oH5UfKmOFPH1ptKzvjvXtsJOa/6r6Ff10IxpR5YfIL4GsyYrL2rKeXd8Z2MfcR7ndi/Y1bMATwTps+ewGDJ6thT0aqp5qtj6lizjVcF23RU4T0l6xhU1PhyFussiFWaox8xLmGzLPaMbOXMWLGjs23xSM1GacDXKwctM5p3Mi8nqW69ANTtbAHg5swd1YA5AgqpB7bQ62J643OE19ulS5j9iFiUiIBqbTNd291DPsK1+f/xp1IPNCW8YZU5AEy8/rgXSWNOx+sqSbY8AptXMfTf8ewG6GFJmU3xBYopevXWrEa3YkuxVAypNoanPnGljje4yQJEqnpFbjGcJYTM3TFmDJtRU/XTbJSF1L34zZzNDYQ+x94IZoh/nXeyP2okIqZXMlPAc/5pSn3mVkc73VOvCIo6Qb5PcYN2KW68UbXzt+IkWPkswhbUHo4lMquuEQ078x5SB+IbVTgtj9Dyucg4A00IfoHyOb5W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199009)(38070700005)(66946007)(2906002)(921005)(6506007)(38100700002)(82960400001)(41300700001)(478600001)(76116006)(122000001)(82950400001)(316002)(7696005)(86362001)(71200400001)(110136005)(8990500004)(8676002)(55016003)(7416002)(4326008)(5660300002)(4744005)(83380400001)(9686003)(66446008)(66556008)(26005)(66476007)(33656002)(6636002)(10290500003)(64756008)(186003)(52536014)(8936002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JoIFDn3LAo9NnGhXGjTMluRHc6T9qBnYTjpds1Y+CQe+FwGVYP4PxubOJce3?=
 =?us-ascii?Q?UU4j1sDlIKvrGanyQIn3/q4a9RAy1g4QI7QZEsFMQiA8YZmE9DRmiXQXG2f+?=
 =?us-ascii?Q?trvRHvNcaGZZJPTYM/8+7zeJFbqMBgvRumg9y8sU89pB34kK9BWZ8p0WvEUg?=
 =?us-ascii?Q?kmYQpMv0w9TbYbe/tgRRIKLLLp+2sjjBVvmR6osTiXWAjvRFb1z4cSRe6gCD?=
 =?us-ascii?Q?cmzm7/Mpcan0BqR6VArLmK5QSQ8wYdhV55yWju5U6DfMBruaEHHeyI722PxR?=
 =?us-ascii?Q?cgKa4+FLBWSlsLloB+QVgq1n0fcl+iNZXADOBId8wfiX4RYZKhy8x3KRJ9Q3?=
 =?us-ascii?Q?5jn8iksKw9SqWxsJvQxSpcemX70xJMPnr6fpLW0/5rRQMYZ7A7e/zRl7C3RJ?=
 =?us-ascii?Q?YVHuM9cr4sIUYAdiFU4qDlwz/55XPZ8bGF/S+06F7jD4LvVl9QhmdwXRFKEP?=
 =?us-ascii?Q?IHVtO/v+Fv6AUl7frEG/4/ezWmOWXQZcvHBuIVosnIztK6xdC89CPCf2VREx?=
 =?us-ascii?Q?reSq9LcUO6b/jW1JYGNcXIH64a87kQ0otNnqJIeydBl98zvneqY5DputfHS/?=
 =?us-ascii?Q?xruyI/RXk6g0PKIGRCrQP/D/KInl5MaBHlVmiq3Ic+XktYIj5RGKevXaLdsH?=
 =?us-ascii?Q?ki7rjntbhtONT/E+g6dtjMPB21hfaj7YTy+WT/oPT5C+k0r9EfjoCr2y88O2?=
 =?us-ascii?Q?07OprTCtwsQtQl+g4pWcyz5Wa+HW04Gug36Z8YUK0uzyLKVZEX/559830x8H?=
 =?us-ascii?Q?x1QTygRE8o/+CajPvXKFMsAkR7qu0zxoDhx/f+n0NxTsGqIwNHZuj/2vzUHx?=
 =?us-ascii?Q?gQDr43Hfuzd+qcb/iKGTqLJU3JcVAS5SAO+LDUT7fKS4401AVbV9K1I/RqXP?=
 =?us-ascii?Q?kGXWlXkatKQ8bC9rpGPME1m4lvAABWwYQUG4MaStBXCpVC80kwkx/npugBvM?=
 =?us-ascii?Q?HTQsLYx0OksDKzOA8gcTlb1hseTknl8yRrMfIEm4JPQ1LFLhrxrIvlZTVEhY?=
 =?us-ascii?Q?WOgsEKPSr1xHydGtJkf8XJR0Jx0CNpPtZb0LGcYggiC4Ln5SO1PjhxFGCU/8?=
 =?us-ascii?Q?cgmWFARfvayWKV5qTfHwLku4JMnUf3ixVK+Y/NvCZbmyd09lfw69nI7eDXlq?=
 =?us-ascii?Q?hG1VZTmLlA7AJOa1OXEp/H7AjJZdRSKTRkxIaF2jNlS1kId63TtDdngAj2EZ?=
 =?us-ascii?Q?FL1z9yKi0AOnL3txgzADNtPCHGO21KZQsSqjGlnDHijrL0he4osk1WOggsry?=
 =?us-ascii?Q?OZV4q48eFbKmdLPWz44iVx4Enpqj8hdE8+68jYBjXa7eS9EVnZTOTbIHDFo0?=
 =?us-ascii?Q?g+NbAEZqFLpU4oFEGhzdHcuRjPEUzjdQ0L81ANcn9NGrYnzbn8w02EbP2Kvq?=
 =?us-ascii?Q?RxfqG+Leb5KRHmi4E5xLtP4y0Obr03AyKK+9IfmVyU9NaXNJj32UtwbpYaCY?=
 =?us-ascii?Q?xRLNdffD839x/hp00TQVxf5Fru3iM4V/AW6AkoVKGB7BBdw+do9YsEVIgsz9?=
 =?us-ascii?Q?3ix7PutyVF9DBLkEiuuOFw9irL6gjmcKXGdU/ealKrqqg2UAI6KrSxbeRHYw?=
 =?us-ascii?Q?e/RRw/7nEM2qhOd0lSZYukac+lHpThKvvpM5NpJQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d89a38-c5a5-4f3a-a663-08da6437fe06
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 18:54:47.3549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7lhiKpoSNvDRvNxhgUSLcpQYLb+0zsuJRdAfab7JAqRT5h3iyOuIszCpY4sBjfuCT0wanDgOVrFsJkYPUAiqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3572
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [Patch v4 07/12] net: mana: Export Work Queue functions for =
use
> by RDMA driver
>=20
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Wednesday, June 15, 2022 7:07 PM @@ -125,6 +125,7 @@ int
> > mana_gd_send_request(struct gdma_context *gc,
> > u32 req_len, const void *req,
> >
> >  	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);  }
> > +EXPORT_SYMBOL(mana_gd_send_request);
> Can we use EXPORT_SYMBOL_GPL?
>=20
> > @@ -715,9 +715,10 @@ static int mana_create_wq_obj(struct
> > mana_port_context *apc,
> >  out:
> >  	return err;
> >  }
> > +EXPORT_SYMBOL_GPL(mana_create_wq_obj);
>=20

Will fix this in v5.

> Well, here we use EXPORT_SYMBOL_GPL. If there is a rule to decide which o=
ne
> should be used, please add a comment.
>=20
> In general, the patch looks good to me.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
