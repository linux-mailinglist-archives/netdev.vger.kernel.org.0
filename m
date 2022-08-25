Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D815A0F14
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbiHYLbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbiHYLbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:31:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94F25A8B3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661427079; x=1692963079;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6nW8NLAFugSkqtg3/c3cDsKpMjRJQL/DDgU0ZvAJwVg=;
  b=HDNR7P6mIpshk2j7YB/IqhOIoioN0nNa1cO7t3i345Xu1KhoVwgRuJik
   bFovn9zUk/62xHOMfsrWAkLdL77bK1jHg7PqJOqipJmyQLoW+J1y+aIFU
   tt8MOj2c95q7tVbWTWtP6hbu+DerCEpPeBw2hosPFN+MASHBPVadvOE2v
   pMKRuKPIn4NlxBRP67yQkyTbFt5z8dn9SmP6E5fi2KsLOImiDmSKN10QY
   sN4jVZW/xOAeVi6X+IJp4XoCEGgdcyzveahfWy5pjoS/H72oVy3GSmByz
   4/ayiczrbXJKifReVH2wIEA+gELFycb60ixyiOq5+cZg1h8+BOpU9yC7u
   g==;
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="177833446"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2022 04:31:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 25 Aug 2022 04:31:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 25 Aug 2022 04:31:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+H/5VPymwhtaj4qQfINSaoXXakr034wXEXMIQpv87dKfTooumPPFOacED44WM6RC/r+gY2WFypny5dvC/k77ZVIfXLCJ+t/KKJH2ceC24mWeIVOkfEmgo3J7K8on+TDnAcieSnaaEO84X0mtR6o8YUxIVBFfAwXD6zgv9v8tiIEeoarE5Ohaa0kQ7pFjDhhpSdSbBWzxg7uvpLm2sl9eXHKG1ioPDtqPsC49g+tEuFLUYMrKbLdU59L6JAyTKDlntxw2HEEndU1uN4aWj581E/W5RxMED7x7IpzIUDxAA5uEFxDJBjexGcuM7JeKGZ88UrGolHXGMZXWGtsc+tPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kK+XumsWOLZkUNQKUqPSZLScxmtxz5XV0uGpQu2ZULQ=;
 b=RwvQZ6oUb3hw907lEcqCquTZIVP8zsUIhwDjD8uFCu292XEtocEnb+oVmi+UKjfWFq+t6Dljs9PXj8mcSNo47qQt++RFeL/uHMU8EaIi4OvSiEBstZSMq1jA4YzECRME4EcrKu8tBgPC9t4yS9ROiZSZnzWwYlYT8fA9E4PxED6e1PbtMJUnda3o3iQvqDDQ5cvKWhDS6qRfqPZoOTF2K+eYTDLTuWI/EaqMryM2k3P6Psn8P+ZbZtepKFgsaGxOQJ28GaN/Br+Vb4dabx1bjPaH6Oqh+tZM60mClvsBPUwz1m+/BXAidNgRqrwugjxzONrR9wCXGI6kRhJvdgSrsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kK+XumsWOLZkUNQKUqPSZLScxmtxz5XV0uGpQu2ZULQ=;
 b=MoIV80aHBpcpofm0t1lupolYWyaGmL9hEDx+4+hO9ZPbSwsOQacVX0xXpmMTmj2aKoCcjCzYUiY6Cb0qny5MrdrFa3b3z49yvqykyG3/F1GSjUkLfsirFWqncFxmWlIF+vADV9dMlfqgG9BanxC9Uj7/TpbEes5fzujyhilbgoI=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by CY4PR11MB1670.namprd11.prod.outlook.com (2603:10b6:910:e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 11:31:12 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 11:31:12 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAIAAGesAgAENAoA=
Date:   Thu, 25 Aug 2022 11:31:12 +0000
Message-ID: <Ywdff/6c3nRMRHDb@DEN-LT-70577>
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577> <87k06xjplj.fsf@nvidia.com>
In-Reply-To: <87k06xjplj.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 908e698a-e3dc-441a-910f-08da868d5053
x-ms-traffictypediagnostic: CY4PR11MB1670:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 176+EFPf0sJYp+fxAGXBXSj/gp/c1dwtMgCQb0Ci7iSezNqCceYzDKZYthsyeoesApva6YXb/aQKM1nWpSJHQkXNKkrFz6Y4ixVDKzlTnyHpsHPEQ8FctGc1wtXR09h2BIgl103/9+rBVkCyMAhPn35+egO/UnQ9eFZ+CsboiiiM286q7e2MErkLb5wEhmNNg5wb3k3BlUgZom46oeQ/W5n+ndAspt6t9TsjE9Yh8lvrWCyYbQ/XAZC3e5/rnMEybAFUF7K2hvIMrRTcGCrV+0F1jHWYGbnUIPkyROxyn8PC7r8Hwi2iXAOfhK4/LsyYO6+HNoyNmIlM2sudrepBR2UiUi7yjCwNz2qMF2dOQpbcp2XzgIGbqedcBerdIRCkA1ln55Dd/nu6/n8nTA8jB+EnZdEwJAt3E0hCMjB0VGgw2tn7vHNWaioFbeb0mkWG6JY8Taif89RZiEse02rn22Gf6lyD/3w3v92asgtWBA5iHbPWmc4AgmYXFd6UHHlcnByvUfpeZ/d+tL2YqzK1pra0nCF2uIc14OA8jC9PDJ25D0cfhVSHpiaH6aFEXUFFXRcHAdijli4abCCHMFH1tRewF+QKNO8i/82SXUURvz/wLjJP2/AwVarCw04zL78w3VIYW9zi9axVapupe+ZVI3WDLkeAy2hgYCatMvcDvunH0tT+R3Ulx3WR0uPYuDXmTx02bv0GlN35K2oohpDW0zfnAwkvrZlmkx/BEK5hcRlDDmF7ZHucElH1Y0vffibyIO/tEtn0MJe/hNXCqsgxRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(376002)(39860400002)(346002)(396003)(366004)(54906003)(6916009)(76116006)(4326008)(8676002)(66946007)(66476007)(66446008)(64756008)(91956017)(316002)(6486002)(41300700001)(86362001)(478600001)(5660300002)(38070700005)(8936002)(66556008)(122000001)(6506007)(83380400001)(33716001)(2906002)(38100700002)(6512007)(9686003)(71200400001)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IPB1PAbJf/Kvvb5vsjoF7nompSrHqzMfsgYULzEi3/i+x8YYFQHMzUOBz/qB?=
 =?us-ascii?Q?Qs273FZzDrvzfNfmabTkQZbjQbcVu3z95hszek5UW5FYEcDYWBOCynnVLERi?=
 =?us-ascii?Q?npkHWyyskkmInZJk0fh/Ln4pQo9GZlNd57aD+d5nCWOeJLaeqoDr19JungGL?=
 =?us-ascii?Q?OMb5QOhLaa1vo/o5R9LJOoytlbeBltB26OSbqzi1qRfMCsymJtxvTfLXdS3E?=
 =?us-ascii?Q?IKzFZ7v4sez3S3voJSz+hIwEFN2qZ+agQsMBEcS0yOa3QCt8KaZFupe0DhFP?=
 =?us-ascii?Q?ntSq2yWUhqOgc8Y/xOE2DEu6pi8biXNdI3AT2rzrH/I/DlQzZlWhPtE0Ft9C?=
 =?us-ascii?Q?oWCFNg63khJyVjiuwkl2OolJLJNF2872njkcElinUYQIzOdzZq0qWMCYCiel?=
 =?us-ascii?Q?qqYLPiowN86UIjdESUa8azoC8THJEYFzHxCT9tDlA3njHMaNUiNtorvp5Cva?=
 =?us-ascii?Q?V261ZeAChWMhPUuafIWQZg02j7vB2xIZZOH2JNdpzPNOHJBvUazWcOAH5RnK?=
 =?us-ascii?Q?As6iCwhd3vpYNbS8FxHq9LRKhtFJIL2adT3OkajPI3O5h+g4cc7+8Ln1dzEQ?=
 =?us-ascii?Q?NuZUIdVjyVUPmkf03masBTPoTw/8/PBYNAfzAaQmGK4FZdlAufnCcsQQW2uC?=
 =?us-ascii?Q?BRmsAMS7DxEcJ4aWoUci7FPbZ7tI8gKxsVfIQMne3Rhu/RIJbxIMTg4tt2kI?=
 =?us-ascii?Q?srsh39Iu5i+j9grgvTFnTiEMkdqyzse2+/8ollsrWGWgk1B5DsoOsvOVuuAG?=
 =?us-ascii?Q?G1LZEulZhaT/KUqkucQT4VrerqO9ji+UghpGirVuHy9GgpJd+wYhm7gsNQNs?=
 =?us-ascii?Q?vo+0G3kwFARAOkyWuWPROTBNAJJo8G5ZaADxhg+83o1tl486KyoeRvqQSq56?=
 =?us-ascii?Q?MBKH1L5jOahcchHm4UMwGzTdvz1kjnLJtd3XBvE1Y2uYw3Y2z4/KUIpHkcEE?=
 =?us-ascii?Q?FXbiMTQiMFjCw62EZIy6MFWshveMwP3jDXTwOndy97gJ3kqI2/SoheT46tHe?=
 =?us-ascii?Q?QqpZW4//5gHpyCXpzedP5am0yWfH7WQy3a1e3GmxPhGUQE/xb/rj652G0NP7?=
 =?us-ascii?Q?jkl2tGCkAZSZZSM/oP3d1SkO+3hztLOymIKDltZduof9B14lhUtzQr7jCKjz?=
 =?us-ascii?Q?qsQFDyqP8UC1ejDy0CKFBG8SBxJngv4/tdr+wSzFAmxYpTuRQdkZ5ETwwIq/?=
 =?us-ascii?Q?CgwGjibgunAyHjEoIEcODzZHdNsQjMk12CfXehmdzePbDkGUWGz31fMzJUb1?=
 =?us-ascii?Q?141FUUEimWc+8Xjgu3WSNH22tdGZyLWMejq0oUH5+HOF7FAXLsHnj4wpZkNQ?=
 =?us-ascii?Q?6/0nmAR2Xwn7Lz8RgugBAf41SVvCSy76j2z7bbqGfRy1lIP++Pr1K5mE2LRu?=
 =?us-ascii?Q?fztcIe8vfMHxuhdzHmf3KEEuYLv2DZ3mu/B4pF1aNalhIYXnb7i2hGgaQADR?=
 =?us-ascii?Q?Sx9Rjnp8P54NnjLzUVs5xonmdKvo6W4/VlTr817Ge+Et/lBuJileomSYAf1m?=
 =?us-ascii?Q?1G9UVs53PdIDts1r3PF22rCiNbxifkyg/+TRV7jQj9Qz8ZORZajK1lzUSLni?=
 =?us-ascii?Q?FXBUSEHyc8JZh2fc4azLDQ22G12PMr7o9JNuGE2zHaUxAoGPL1p80SQu+HPc?=
 =?us-ascii?Q?2W5eIsO3PvbZIM2aPvmkwi8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E2E698C79D2274484B7055B5CD694FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908e698a-e3dc-441a-910f-08da868d5053
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 11:31:12.2354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NfhyIvw6OXuCNrQK1ZqFM8B3r+MH0AlnyGYljBpAWEe/YviTDiZCsX9sqL0l7FCeuKtsKbf8cF377X53TaxZ8lcm9WX73etB5lSzGR2HnLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1670
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It was merely a concern of not changing too much on something that is
> > already standard. Maybe I dont quite see how the APP interface can be
> > extended to accomodate for: pcp/dei, ingress/egress and trust. Lets
> > try to break it down:
> >
> >   - pcp/dei:
> >         this *could* be expressed in app->protocol and map 1:1 to the
> >         pcp table entrise, so that 8*dei+pcp:priority. If I want to map
> >         pcp 3, with dei 1 to priority 2, it would be encoded 11:2.
>=20
> Yep. In particular something like {sel=3D255, pid=3D11, prio=3D2}.
>=20
> iproute2 "dcb" would obviously grow brains to let you configure this
> stuff semantically, so e.g.:
>=20
> # dcb app replace dev X pcp-prio 3:3 3de:2 2:2 2de:1
>=20
> >   - ingress/egress:
> >         I guess we need a selector for each? I notice that the mellanox
> >         driver uses the dcb_ieee_getapp_prio_dscp_mask_map and
> >         dcb_ieee_getapp_dscp_prio_mask_map for priority map and priorit=
y
> >         rewrite map, but these seems to be the same for both ingress an=
d
> >         egress to me?
>=20
> Ha, I was only thinking about prioritization, not about rewrite at all.
>=20
> Yeah, mlxsw uses APP rules for rewrite as well. The logic is that if the
> network behind port X uses DSCP value D to express priority P, then
> packets with priority P leaving that port should have DSCP value of D.
> Of course it doesn't work too well, because there are 8 priorities, but
> 64 DSCP values. So mlxsw arbitrarily chooses the highest DSCP value.
>=20
> The situation is similar with PCP, where there are 16 PCP+DEI
> combinations, but only 8 priorities.
>=20
> So having a way to configure rewrite would be good. But then we are very
> firmly in the extension territory. This would basically need a separate
> APP-like object.
>=20
> > So far only subtle changes. Now how do you see trust going in. Can you
> > elaborate a little on the policy selector you mentioned?
>=20
> Sure. In my mind the policy is a array that describes the order in which
> APP rules are applied. "default" is implicitly last.
>=20
> So "trust DSCP" has a policy of just [DSCP]. "Trust PCP" of [PCP].
> "Trust DSCP, then PCP" of [DSCP, PCP]. "Trust port" (i.e. just default)
> is simply []. Etc.
>=20
> Individual drivers validate whether their device can implement the
> policy.
>=20
> I expect most devices to really just support the DSCP and PCP parts, but
> this is flexible in allowing more general configuration in devices that
> allow it.
>=20
> ABI-wise it is tempting to reuse APP to assign priority to selectors in
> the same way that it currently assigns priority to field values:
>=20
> # dcb app replace dev X sel-prio dscp:2 pcp:1
>=20
> But that feels like a hack. It will probably be better to have a
> dedicated object for this:
>=20
> # dcb app-policy set dev X sel-order dscp pcp
>=20
> This can be sliced in different ways that we can bikeshed to death
> later. Does the above basically address your request?

Yes, thanks for elaborating - I follow you now. Also, I agree that this=20
could fit into APP.

I will prepare some patches for this soon and make sure to cc you.=20
Initially I would like to add support for:

  - pcp/dei-prio mapping for ingress only. If things look good, we
    can add support for rewrite later. Any objections to this?

  - Support for trust ordering as a new dedicated object.

/ Daniel

