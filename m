Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF805A00CF
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiHXRzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240272AbiHXRzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:55:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D2D1C10A
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661363746; x=1692899746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=38hE1VsTJlZaBXQAaiE5daS0u9/fOYndh6qagmn6ehY=;
  b=gL+1WIAlh3/+8I2RQODfmK4cW+5E9kOZ3Q4Ivx0/n2OW/aEsmSmCgDmb
   GI7u1UAP/dxCG0qD/SMtkXi7v2mwn4XQg6lQJztrG3gEL3qOWt75AWFyP
   e9hFwxrDnDzXyDdCN6bwWYnPFlDqa8Whxs39td/cZBS/3ukHiwP3ewPMe
   tz1fHA3gd+xtu6+o8+878Aj5Ohove+wVBPcIdqX4jYfdMNaJ5neTQNArf
   2NFLR0KtWgFMhyaoNr2N6UVqFal/8p2f+12S6TFa28YPdIdcD4TnX4bTG
   DbfQQ0bqCnFprlvuxWVbpQY2ZTaf26bCxvujI/VT+3yP6MJT1fEdRXb1K
   g==;
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="177606108"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2022 10:55:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 24 Aug 2022 10:55:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 24 Aug 2022 10:55:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwwPKiMx5pfR4pXUJf2curoLe3gK25eROSDIP6Irw18whT0xShd3O89jUpAUaZuePlxQzE3jkRptpbN3G39LETH85+inCEQ5gVHc3tbYOoN4axpZslpOKPgaj/k6ebeSMz7xdtCSQWw80RFs9zrrK/5eD485arwdFHYxamgK6JNEtE0ipmKMqI1EdUygCUS3kd1AUkJOUnfueDdcEmFk0mFfXK3lcRh0oaHKsTBo/AV9FxZMIXSgyS+a8x8ShowXVZQNQ2aV8+m39MEBTm/bhO4OmkIAXaBEk1a0gndTF4V0LOJM75fVHdKd6ydKZbpTuZxC3qv3FspafkIBq8PVIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXfKLGV9ZVEr92ujmtJhDWwL671tSlV7IPpqWHKTnBs=;
 b=GDDC/Gu9yFWtjrBs9n8qZ+yAlTPKCUyXl6nTIIFNZ8zkkK59BoJQQ4g1bj8/H1uYkmGERVgOn+v0cWfwgHB8E3B6KJCZVoEPR8PTLdEUvHsMgX+ZBqACorGvVJ0bRs/4hgCrsDloHiXahKm8CcT1HoG2y40p61a6px6jY7Nt7S+w1VlMRBhtrh6mnc+YMmz0KSXJkRy5o6Ub3vjJgZeAUay1YlmfOavVrjzZJi3nkPvO5obpu4NkbcPBVszAGXOjdslAVX8DHzT9NGO7d9DCbThAiuEYYhuwN4fObDfNgjeXwe/TFKPeE4YiTGGqjF8tQOC1v/UQGGpQ11WqW2LQhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXfKLGV9ZVEr92ujmtJhDWwL671tSlV7IPpqWHKTnBs=;
 b=kcm1MYJtWNBUuA5HH9XOpEgcOKWvWCyFntlg1YBuBCZZW9ELT/zD7TfIWDNeGe7wDM/zPc/o0KpryJUQS3paGFwwQVT6Y9NiUWe3cMDrZHPudwb0AKXC4F3uhGKcpnfEe13q7Xa1RJn1jEAVKWUU/kgx5gPk0qO11Rr2hdxHIL0=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by PH7PR11MB6546.namprd11.prod.outlook.com (2603:10b6:510:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:55:38 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814%4]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 17:55:38 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAA==
Date:   Wed, 24 Aug 2022 17:55:38 +0000
Message-ID: <YwZoGJXgx/t/Qxam@DEN-LT-70577>
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
In-Reply-To: <87pmgpki9v.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eba799a8-b5d0-454e-55ab-08da85f9da5a
x-ms-traffictypediagnostic: PH7PR11MB6546:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t01EVNQstBxymF+m7A2xmbHvpHTs4B/xL9NI7NjUqqjg0U0xFpDnA+qFQWBOEz71Ji2PqSlVPrWmnoemv/5y2ydtHpbS9geZUmo7OuMAqKGOY5JirIj3sp6YLvPxIHcVm3Su1z1gbFJqhbqO7E1K1VCTrpJr/lFTAg/WZI2qZONgaFzqzuokvr8udyfFQUbtpg9KwBSTkg7a0A42xiar2hJctb+ReFe/xQ7DB0MOGRPgItImh1tQv5gsaXZIZzlBbUIGxcfpS9D8W5yGbgWZ/7s9tmAwjThHwEnTN+NrI9vo+Bg1rF6F0KnzuuZC1bY0KHMf0a0edXUQ13G10WWT/WIXh/S+CadhrMrsqIG/NqorHQeeIGiE2OMPCUi2LEGvCpLNvapSkMCWG3hz5x6y7SVgPzRyGfjbVGAn2fDweMGqDwu2ElmyGxdEpS0bug5SyUq8oBohehUmAbfmVsnz2aKe+iTo2/L/+b0o4TaQEgnnCIjmKRZMkuls3NB6X++Yu727dZah8x8zMYN9DZQfoLCPmVHz9g47flwPjwiCw0ispQMaBT4nrrHmQzuTvW/FL0/KdI62KEGQ4eCl/wh4odMJptlDvw+xoa6QNNnFY2xBFTygCx0KkP67D7qBdlvFjJ5Z/7CDe73JPs79gUparlmysvbAeZTCKz/eF+22vxwXKXFFDCyJ8Q49JlRP/1BVBwd159o+6ZwAHF0saBsb5BykQKaCZKVRAwNMasziT6c8FcIO8q7F35oSn+0VK8AF5O6qdrHIeIgC81UL7zEhaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(136003)(366004)(376002)(396003)(6506007)(54906003)(2906002)(122000001)(6916009)(26005)(38070700005)(9686003)(6512007)(316002)(66946007)(6486002)(66556008)(478600001)(71200400001)(5660300002)(83380400001)(186003)(66476007)(41300700001)(66446008)(33716001)(8676002)(64756008)(4326008)(76116006)(91956017)(86362001)(8936002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R2ogAwZRNjIWKNDzDAcP8bMsuFf10KVw6i3f5NLwOt1nCFlcZe2hoi2MnZSA?=
 =?us-ascii?Q?ZIUpHNYFkybg7TZbNMxXZP67/JZ7/87B0Izx44WoIPWaCM8as9aD7JL+sb/m?=
 =?us-ascii?Q?q2sQFqRPTPOIeL3C3hCA2ISZubCeI9lltmeqvz1I3lkUlcXtSTdUu4Uw/wQL?=
 =?us-ascii?Q?4H0Ll5dAbJ5dHo3j4SFS6B8XppG85gSLluypyLk40R/7jQAcqnxYKn8pMziz?=
 =?us-ascii?Q?li4lI4vlFZSimvCSODRzKwhmROYgvaZX0Eab97Qrr03qkgEE4mmtCxwEd144?=
 =?us-ascii?Q?pJh9iDS5WpGJABjvJ/s7uxOnSgym27qEion0zwKVWtQMfGbncRyF4wJ1Qy9l?=
 =?us-ascii?Q?mD5H3YzrTMClsXOewHyO474EQQ/EcZQ70cw5JDCCm+zEaXS0tUpxBDm+Hb8F?=
 =?us-ascii?Q?cjOLWT/ZtBg2SJ9ejwj/0tcB6A/RyrjquREdKrKweJNQB1UkVpZZq/mBtW1P?=
 =?us-ascii?Q?rYixYoEqnymsoSW/bsiswOOw1gl6sKtkEF+M2RHjK2E3MjNaLLYlk+d3IAo5?=
 =?us-ascii?Q?wgw0zrvvrGmZLkK5xHP7JH+u1Pv/WNHU3KcSNuwUHoIgFS8Nm1n2+0+rRyX1?=
 =?us-ascii?Q?9fzOYNntaNDykFIpoEl56AIMvxdzQqNajWnZ5vf7N1Ns3aBH9F+C/9iiuKpI?=
 =?us-ascii?Q?m3tPEHhqEdJtvhXsAQrFq3wpnZRLtwp+OucUlbrUCep6wuNzpHlOsyaeZJLS?=
 =?us-ascii?Q?QMJqqgQcuU040/STlEvHgEaoV/kE/ta81rkrGM08+nCRqxJzAmyG/cYy6oes?=
 =?us-ascii?Q?MH915ydkYeqdGorHRhYACyIBmfCLBZJIq+hVPHJA8tRxqRBAm1ANL7dfkUGO?=
 =?us-ascii?Q?17OpipnV8XbSLaYzjqK2Vzw2pibh18P/jh6bCMCMv2EHkbmQnPjnXtp6bgFg?=
 =?us-ascii?Q?puBNVjZeZ4ExVi4slKA7iA9EYGE3jHEz4QWLk3I/mXud77xwNZ7oQCJbSlnP?=
 =?us-ascii?Q?IQUaeY/Aofu+u0siLQG3wlTkDDKsCD88rr97NJyS5WHCSamkBeyTv3JpuFs0?=
 =?us-ascii?Q?fz+0ca/Hj5RKBOBDR8vH1OWKY8jJChoMtgA6G1yW11zS4r2RB8iHGDVKZJ8G?=
 =?us-ascii?Q?xFVWEQu0/1EnEqiJX6/Fft9zb5XuWfQ8E1ExDXndsHoJcR365cGPZrmjho/v?=
 =?us-ascii?Q?6ax8ajwKg4Uwcs0Y2FVetuIDkov4U/fDc8nLSM5eGdKsi8ZDn3R7tizH84F1?=
 =?us-ascii?Q?NW4VJUpzt1R53VxRKdt4kpntV7tN9T3tC1Z8CCg0KgZsSssweCoSmHW6cUut?=
 =?us-ascii?Q?SCiuweTRlAHdgsQIuc9P4ZtiiwGI4jlON4nDnasefa/9lhOBbvTMkU9/uowK?=
 =?us-ascii?Q?VqpYvFLY+lKCLGmHyBo69GqmXbWhfUrXDkNYSr9yiJm/wYcxPsxHrfMgp50B?=
 =?us-ascii?Q?GHEg210XSUHAFPOajh2ClZ75pC2QotFkgc+eUbZq1vCC2ppMCq9/VJ4sOA9o?=
 =?us-ascii?Q?kHpE1s6aZ8K4uq0r5dbEUN4NmNnlT+9tea7rORtKeMTwB/ToeSAjll/UU6r6?=
 =?us-ascii?Q?TNL/vvDsu3kdveQSocEb6kvkW6LvTvNm1Xd5VRU48QxxTaHbKlIAC6EUxtFd?=
 =?us-ascii?Q?rk89y9WiveHaJsCsyMOkZCgzKxPZyxk8t56MjQ85cpcXi5CJcfD9i0tzyhk7?=
 =?us-ascii?Q?CcLNOJI2X7mY8irGv8SxM2k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BABD619EDE0FA343A8B9ED5E43936E6B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba799a8-b5d0-454e-55ab-08da85f9da5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 17:55:38.2738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rWnEiqNXQCPZ0BzFGlDx1JLF0WK5SXqzCNn/xZWoHgV7ctLbDZSXVrNSLd15k4NsJQfbx7PNEcG7mM1JUHPALoSmV1doJNIAzNRD23kwSrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6546
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> How do the pcp-prio rules work with the APP rules? There's the dscp-pr=
io
> >> sparse table, then there will be the pcp-prio (sparse?) table, what
> >> happens if a packet arrives that has both headers? In Spectrum switche=
s,
> >> DSCP takes precedence, but that may not be universal.
> >
> > In lan966x and sparx5 switches, dscp also takes precendence over pcp, i=
n
> > default mode. Wrt. trust: DSCP mapping can be enabled/disabled and trus=
ted
> > per-dscp-value. PCP mapping can be enabled/disabled, but not trusted
> > per-pcp-value. If DSCP mapping is enabled, and the DSCP value is truste=
d,
> > then DSCP mapping is used, otherwise PCP (if tagged).
>=20
> Nice, so you can actually implement the sparsity of dscp-prio map. And
> since PCP is always second in order, you can backfill any unspecified
> PCP values from the default priority, or 0, and it will be semantically
> the same.
>=20
> >> It looks like adding "PCP" to APP would make the integration easiest.
> >> Maybe we could use an out-of-band sel value for the selector, say 256,
> >> to likely avoid incompatible standardization?
> >>
> >> Then the trust level can be an array of selectors that shows how the
> >> rules should be applied. E.g. [TCPUDP, DSCP, PCP]. Some of these
> >> configurations are not supported by the HW and will be bounced by the
> >> driver.
> >
> > We also need to consider the DEI bit. And also whether the mapping is f=
or
> > ingress or egress.
>=20
> Yeah, I keep saying pcp-prio, but actually what I mean is (pcp,
> dei)-prio. The standard likewise talks about DEI always in connection to
> priority, I believe, nobody prioritizes on DEI alone.
>=20
> > This suddenly becomes quite an intrusive addition to an already standar=
dized
> > APP interface.
>=20
> The 802.1q DCB has APP selector at three bits. Even if the standard
> decides to get more bits somewhere, it seems unlikely that they would
> add very many, because how many different fields does one need to
> prioritize on? So I would feel safe using a large value internally in
> Linux. But yeah, it's a concern.
>=20
> > As I hinted earlier, we could also add an entirely new PCP interface
> > (like with maxrate), this will give us a bit more flexibility and will
> > not crash with anything. This approach will not give is trust for DSCP,
> > but maybe we can disregard this and go with a PCP solution initially?
>=20
> I would like to have a line of sight to how things will be done. Not
> everything needs to be implemented at once, but we have to understand
> how to get there when we need to. At least for issues that we can
> already foresee now, such as the DSCP / PCP / default ordering.
>=20
> Adding the PCP rules as a new APP selector, and then expressing the
> ordering as a "selector policy" or whatever, IMHO takes care of this
> nicely.
>=20
> But OK, let's talk about the "flexibility" bit that you mention: what
> does this approach make difficult or impossible?

It was merely a concern of not changing too much on something that is
already standard. Maybe I dont quite see how the APP interface can be
extended to accomodate for: pcp/dei, ingress/egress and trust. Lets
try to break it down:

  - pcp/dei:=20
        this *could* be expressed in app->protocol and map 1:1 to the=20
        pcp table entrise, so that 8*dei+pcp:priority. If I want to map=20
        pcp 3, with dei 1 to priority 2, it would be encoded 11:2.

  - ingress/egress:
        I guess we need a selector for each? I notice that the mellanox
        driver uses the dcb_ieee_getapp_prio_dscp_mask_map and
        dcb_ieee_getapp_dscp_prio_mask_map for priority map and priority
        rewrite map, but these seems to be the same for both ingress and
        egress to me?

So far only subtle changes. Now how do you see trust going in. Can you
elaborate a little on the policy selector you mentioned?

/ Daniel
           =20

