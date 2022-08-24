Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2AF59F479
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 09:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiHXHjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiHXHji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 03:39:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EA77B7AE
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 00:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661326777; x=1692862777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qhBGSt7dxiSGK7xX0XidEdahmmcPNTSIHdrpmk63opY=;
  b=Yn+2lGoJYynBvgCRlyYiED24YOiRtpzymQ+HbkKdzeN5w93ChuEMXT9a
   UOK5esXdBAY0KK+vNwkOpQQBoaAA5jPChOkxeWHnZK8JK9eD7Vvm4UjNR
   1QqzZ1dvywrFQNYPSrz9cY8pFkOjfBSmgc4uKpK89A2Q+9lb3SUg9czR7
   y1VYdNJtoessIUDYsXGwUbr02IW9D2ZL4Q4IFbGQxM1zZkcwTCHx6aK7s
   2hpelyIqA3A/mxsu1tkclOda/c/Y3m/I77O9OMt4edCThwYyts4RD3iZO
   Sa/PnnLaR5TFf8JIoZZOt57VokrM0M7icgeFzUs/cgbDORRk6BrNx5a+S
   g==;
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="110458671"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2022 00:39:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 24 Aug 2022 00:39:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 24 Aug 2022 00:39:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3mQGE2cBVShpShbPk2nGCnl6z+3PwKd7Lk/VyDSK9j3e4mEO94AlCIrOEe9a5RLGm9uzXfi+iCMZT3NQUXUuaVSudMg0pJ4bTcBs5rf0qvIXOiaZnS48mPn4tNBc/wPX36CTF9f8wCsmRtcZOJ7Xs8QAotMEfcy1ablDPUSKd0c9j3qTi2/UYSmhI10YTZNUZPnYRtGKWT/UsIFBhuDljP902BkemsnlJTysUTFgg1IGGQ4/XmlCyEmDLUW6Z4fYOujPCX1vuVQlVbv/A9ayalWFI9n3P97HFi26a7larKB4aObah4Xqd28iPgYPIp4o2qcXc5UGnbWyVa9rdYe+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhBGSt7dxiSGK7xX0XidEdahmmcPNTSIHdrpmk63opY=;
 b=KHa+RDLaJDoZskriWrEJ2XCUjHIE2TavN41STqedEs+kNOtN92x5073sbZRvOKBe7NEOcCLoXBYXDuJE91Z2SW1VEHJiyxnOiYMIVtGFzHxLsR+gzzJmCf+7F8T/Xpr8K/pU3mHMMu2z/ZVGWGgNVrcoWIWwrpgp91FZFe5i38eGq6r9uAvc4C0kEeBb2sD6A4f++MErI5gYnffOALZ7lJezhgl0aXAGUdmiMabYX+Ksz0nvAsQXcSmJKxOPSGl+DUQojGwMaz/HhOTZf3UXGGXPhIHsB4vcYXjhfhZ2MG+UX4UfuFTovL9lZkZGs4YJY72W5qKVo19zIET84zV2BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhBGSt7dxiSGK7xX0XidEdahmmcPNTSIHdrpmk63opY=;
 b=tEzSm+TUqsqBnShjsT5uzr3PgK2a2Dwoyh4+ID3h/19k8EC7rYf5kix0milEQiIkDlSBQyGqdkQaZWaZahjBmjxbpevGP3KnDwebp99TGOsDbcwilXwMWu2v5rPtqIwUED3L4PFzAsKXdcBPG0Cl2aAv8F+kTvLPNjEhAANWua0=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DM6PR11MB4596.namprd11.prod.outlook.com (2603:10b6:5:2a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Wed, 24 Aug
 2022 07:39:25 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814%4]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 07:39:25 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEA
Date:   Wed, 24 Aug 2022 07:39:25 +0000
Message-ID: <YwXXqB64QLDuKObh@DEN-LT-70577>
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
In-Reply-To: <87v8qklbly.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09bcd63a-f89c-4c6c-c0b9-08da85a3c4c3
x-ms-traffictypediagnostic: DM6PR11MB4596:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vhA7tiBQOwKONKna89f/IbvwTcZW5OlPglnjXmeNvD+CycjDx/OfG/sAcFFel4kA0ExuYIcPrsIp3GWFXGi/2w8jOzzLxlBNpgbUEfRHTR7hOnzHVEeLf4EkA6rWHJNPsoYWxGSz05mLQkDim7FtGhUf1t2wzZuoz79hbe7yD9iobnR4iJ6NuK7JykzZXX94RYNbPsCdaIbtuz/RLKzwwoYDB0RhpsxcwOXeL1ECA4S0cb/3mb1s6EXXr/hZTw34Ii9bopar+TpPlmcLc6g1bNFLsiRSIgRu6GM1e9BZn7tdLj9W9hdwjJKQTiN4Pw+LlhX4u/xRYHzrbc65gLazC7i28Kt75z4JQFxaaItA4vNJkdJtoZFzbU+Uz2ThVoA9XuhXAdb5TlFUvpxBEN33DMYI7endOGP0VgcJsLrdk3crGK37RDb3t2ZG2mxyQGSa+SUWU8XxzF4238Ha0VnB04wAubb2hJpw9gk8NRCwvgCE60hrj/kAiuXYDJLHZaXLRnZn4UClvZlx0hsk9q2/lQGabn788g9lPUFMyQHJDjGVhddhUgRcDeLngCBcbhyyszmumz8xoOv1wNHjbS5jT4JR8NzxMFTijUnMB9EkYE3lbfEcUStED9s3midKTJlVs48+8qRw4PEYepv9tnm1kaeMVUsJiIj2Ipx9bWRmT4XTMAhtpU9R5M5FbXQXbyRL+Ws7VRbd0bLwFvQ4K+pYDd3nkbsN3nvXOH/Mh5PG5mhtW3nETnd++sIeoLw17HHjaiGJpz7SDkntWQeA2UsHVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(366004)(376002)(136003)(396003)(41300700001)(6512007)(6506007)(26005)(86362001)(38070700005)(83380400001)(186003)(6486002)(9686003)(478600001)(71200400001)(33716001)(66556008)(316002)(66946007)(76116006)(64756008)(4326008)(8676002)(91956017)(66446008)(66476007)(54906003)(6916009)(122000001)(38100700002)(5660300002)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i8+xnELwCz+3VeY5E6Qqo4HcZWhBDcfwiBszPsGB2lewd3aE0xPWq3xyPY8O?=
 =?us-ascii?Q?w2UHFxrWjgb/i3pxBmfPjMkXBsHSMAmpfCvg95Nln1O6NmqLAsemK7GtawlH?=
 =?us-ascii?Q?FxDXkyaHGOGpOFKSRRE9kBZ830w15jwTwlR7SAyg0wObhvVXSxgUQkM9iz/l?=
 =?us-ascii?Q?z4SnwI++YYZQapjg3i1ca3YsQF3N+yihqLRUg5FpStpNP19RqSnvtcWRmXMd?=
 =?us-ascii?Q?EeJOVuTdGXluLPJTZVfXm5FCCgpXVvQx0N7hbkDmf4VsKTeRw3l5/QXCOeoF?=
 =?us-ascii?Q?rzSRj5wl6XhbefT2nZCpLLfZrUZ3pQMHU04Kd1GIblsFUGV2azfGGnP7LNik?=
 =?us-ascii?Q?6Et3WxfeFE8mdFutFAC9iKHEAconBQ1QyQ8CWYwlkPJN56AO5SVCTL+nCF4I?=
 =?us-ascii?Q?gQki8OXfreqnw4PWInbMHamzuPQAvU4s3E+WxS72bx0hDaosn/BZSXUFXp/l?=
 =?us-ascii?Q?PlQ1eZQJ+1r0ddjrsU14md5q9cJRX4EePjuqq0jlDnKXp6V+WtL2xc3zszIM?=
 =?us-ascii?Q?Nbgyw6H92J6OqU+N9tfL5OlGls735ndSdBrrCWe5oEGH8DeGCqPDHSNOmguE?=
 =?us-ascii?Q?FKFeXxfVjeOypOBHAfKIc866pIaPEFVnUd/wZn/iY50JpOwB53QuQbMEDjET?=
 =?us-ascii?Q?24IxycGlN/u/7GxFP215oG7BgPlkBIYRBPyPdRGrJe64CJmYsWhH2a+9c7h7?=
 =?us-ascii?Q?9iiLBLYxxWwicn7fVHWqFgZHrQWIUfMHoJ1mirIpkCiMVttn/Gq8MgbzxnSm?=
 =?us-ascii?Q?th4TLLa2WFgPR6WdlycRk1SwPEaiidRMHy+ziQzAS8jV8Dm0SpoyywEoRm/J?=
 =?us-ascii?Q?JXre+nZMfeARiKUnp02FAkUstQzaiDZT80M0YU+MGTXG1Yv9NcbGtI1x74+V?=
 =?us-ascii?Q?kpsY9weY41zwqs9kA3/fezlLjfiD6kglb06X/RRfhl+hwyBOrv5EtLxuDUMP?=
 =?us-ascii?Q?hgFN3lDJDEkYRTegIfgKnnPNAeb2h83wPRCotWj4QDbaUxnVn1TuVRpvNL1l?=
 =?us-ascii?Q?x4ixY4oveAs6zhL6RW3UXjh1sIJlxhk4JdUu7T+Q05bQSGzVD/bO+GNiB27d?=
 =?us-ascii?Q?8RhR6gGYaK8uJQRq/HO3Z9uiYDmK9Wh+cQw1MaB2W4VMjZ2B+ZSA51vCdN1p?=
 =?us-ascii?Q?Z7Jeo5jdtkS11wYydbObnRCUMn51IMj1js2x35UHC+65PHEiSKl2qT3e3wAZ?=
 =?us-ascii?Q?dkgu9qRqD/TJt36aWMulMriv5cWFOeyUjP6Gil/xUzLyZtVwZ85kdu2jLpTu?=
 =?us-ascii?Q?9ShHOMOzrpOsoncCdLF+wAaTFGQFY+3v63ROUQ4j96LlMsSQw7zsE+iwW2V3?=
 =?us-ascii?Q?VkCIg5OZ992rrDdWwaizKwUCZudaaFoVi4xvzP+iFjvqIn2pntk0814ugpRq?=
 =?us-ascii?Q?1ibyqa8h7BKhgXq1Kufh35gNpGwiz8lxOpGJNiUGZXQo2Fs/pDTEoDYC7yb5?=
 =?us-ascii?Q?H81rUDnkiXR4/Pft1bfP69wT5AeonmylmV0AGi72x2NBkQ8/0PeGqaXBzerR?=
 =?us-ascii?Q?0BlW4wbeeGhcZU7ZDsbpN9NL4AFe8Aq+42s6iknMAEmebWxWdkbzkP8v80NU?=
 =?us-ascii?Q?mVQ0yMBwVomNzWW0lNiDk0La4KVy+/MmlpZ0dB0zI8UTzbtFuNAG2wxgX8gd?=
 =?us-ascii?Q?l6WC7Vta1uMgW0XlV583G/Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B58E0D66D72B84F92E7C094D2D34EEB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09bcd63a-f89c-4c6c-c0b9-08da85a3c4c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 07:39:25.3204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uWxlgyJiE/2uaaQ0OVUIoqaC3OIVwWf5W+CVuQSaql1brDPiBYm4Rg60M3jFbyTvjQmBbAQn1TaaW5ewwYNQSb3HRx/3qRJVq99CqumCCBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4596
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> How do the pcp-prio rules work with the APP rules? There's the dscp-prio
> sparse table, then there will be the pcp-prio (sparse?) table, what
> happens if a packet arrives that has both headers? In Spectrum switches,
> DSCP takes precedence, but that may not be universal.

In lan966x and sparx5 switches, dscp also takes precendence over pcp, in
default mode. Wrt. trust: DSCP mapping can be enabled/disabled and trusted
per-dscp-value. PCP mapping can be enabled/disabled, but not trusted
per-pcp-value. If DSCP mapping is enabled, and the DSCP value is trusted,
then DSCP mapping is used, otherwise PCP (if tagged).

>=20
> It looks like adding "PCP" to APP would make the integration easiest.
> Maybe we could use an out-of-band sel value for the selector, say 256,
> to likely avoid incompatible standardization?
>=20
> Then the trust level can be an array of selectors that shows how the
> rules should be applied. E.g. [TCPUDP, DSCP, PCP]. Some of these
> configurations are not supported by the HW and will be bounced by the
> driver.

We also need to consider the DEI bit. And also whether the mapping is for
ingress or egress.

This suddenly becomes quite an intrusive addition to an already standardize=
d
APP interface.

As I hinted earlier, we could also add an entirely new PCP interface=20
(like with maxrate), this will give us a bit more flexibility and will=20
not crash with anything. This approach will not give is trust for DSCP,=20
but maybe we can disregard this and go with a PCP solution initially?

>=20
> (Am I missing something in the standard? It doesn't seem to deal with
> how the APP rules are actually applied at all.)

No, this part is somewhat vague.

>=20
>=20
> Another issue: DCB APP is a sparse table. There's a question of what
> should happen for the e.g. DSCP values that don't have an APP entry.
> Logically I think they should "fall through" to other APP rules as per
> the selector array.
>=20
> Thing is, ASICs probably don't support this "fall-through" feature. So I
> don't know what to do with this. Kinda brings back some of that TC
> complexity, where you need to add all the rules, otherwise the HW can't
> be compatibly configured.

True. Let this be a PCP mapping that is inteded for the hw datapath only.=
