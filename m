Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A5A599883
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347969AbiHSJJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347014AbiHSJJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:09:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EDCF14C9
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660900185; x=1692436185;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=92TUd0IXQInj0JuDElv3CA5YrHpE18A48w9fez0e3ug=;
  b=jQ2JeeHOtlowMhHc5s4C8f8y5Bpr3nJuzQ7y+kVYsHyF6LPwAtCA2SGp
   YGbAUp77SCe+7lU21mPkkX4H6z03OO8bPqgEU+YLwZo3nVuoM5L6v6Zt6
   gbNuflVKJZvoQjIP/OQQfaFTvoIJPUx7G7W3maDjci2IEW5XvC1Y58hRR
   AOpb55dt2crzCJ209oXA3Mz1srUCgrHkvYduBYb3hVWVRsMcPuV4ULrCQ
   BA5hO6uv/QC9f6CwDkSKtKaJPylqzSN5p1rp46jCFTvOPWU8HDJgK18eK
   aIwT/DvpOFoVfBxZ+bucKoyHV4qoBoOcIq2P8kcBqYn/oiEZJxwX72WRK
   g==;
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="170005727"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2022 02:09:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 19 Aug 2022 02:09:43 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 19 Aug 2022 02:09:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdyPzNcw2qifg/81NeK+Q2jK5sReIa3ovyJUax34tlbsS7m9glgqhDFbzX70I57trS5QsgropHL1HrkoCJW3dzUUoPx5CQOozNhTiSi50kQBUN1lq3BvfXc34zkBYp5mHbzsB079oIJKivPr5V9qC619Wmcr+Ru0UmfpGTwti7AK0VLkaNvfzmnj0a0OMd6E5BhRJBSnYFVVDNGPbjdwiNqVbD5typfkiBbHmIHREb1kUh9Zem9D6wjPpeWO/a2tGyDFjqkDD540mLYUJY5txQMjlY/bHQevC88xYWlI69Pl7HEYZmZb3npZmbjRigQFv0nkZn38nrrnw/AwPhCNrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fq8EafoP3B82MabTu0h8ZjF6bZ1gV19npFODXwBGxms=;
 b=CP/Wvm52CxM75+ZYBHV/tKpiDvKOTZbWBP5627u9Ad04R16Bw4m+xkUgGB16fRQoSpYxRLl0R6SjyN3EfpFusbhV0H1J9/vCbM2Z8BwdrCuBp/TnYbh6Fy9ljHls80snTeMkMu1Y+ABWedQbBd8AcDfaqloJoKn7A7U1fulpc3uJl0s0f1x023lycOewFdXtnNyxCbqrmDiKYqH/Xa2rNljpXNHMOQQNXPssuwAZZQ+xprve9lcQ7+WgOeJLIk6uWtDSbFTgthrtxhBEeekHS9IptdaArDEytxyq/DgrrMoRYZTTiGve+p8P1QDPq3cvJMNikVD8ZPlPV8bRNoC0dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fq8EafoP3B82MabTu0h8ZjF6bZ1gV19npFODXwBGxms=;
 b=DWy9jV5GZDDKqH+nRwjbDEWWml037KCQgvytWRoeZHxqplpgB5w8BKoSvGReeQMGYQ8OKgnKn6KtHnw6Mr4JtJd8rYiO68bUwgMGtlNstOJXYV1uSMlTHc3Q9h/MtU/ubG24vk1o2ZZrKDpimoNHHIvEs2hhDQB5LzqEOIS9ztg=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DM4PR11MB6504.namprd11.prod.outlook.com (2603:10b6:8:8d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.28; Fri, 19 Aug 2022 09:09:38 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814%3]) with mapi id 15.20.5546.018; Fri, 19 Aug 2022
 09:09:38 +0000
From:   <Daniel.Machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <vladimir.oltean@nxp.com>, <thomas.petazzoni@bootlin.com>,
        <Allan.Nielsen@microchip.com>, <maxime.chevallier@bootlin.com>,
        <nikolay@nvidia.com>, <roopa@nvidia.com>
Subject: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNA==
Date:   Fri, 19 Aug 2022 09:09:38 +0000
Message-ID: <Yv9VO1DYAxNduw6A@DEN-LT-70577>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aea7a1f-fb33-4e54-888b-08da81c28af4
x-ms-traffictypediagnostic: DM4PR11MB6504:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUUa+TNv+v7n5O/jJ8sIhFcPX3d5Bbfa+BcZ+ncTioZIZ5ULdq5j5uwXRm4VvYDuOEkf/gmusUauKbUdUnCJnTHKn8C2MGuoScBuvCBdv6YxIYodROoH39u3J4Zuldr4nZi/yfOvLP/kqz5tONSulpAz9mpwDhLnHxwQA52H9M5LbgnXaeFcdjarS3BI2zpWqGoGJTwf7aSYrFLO7JPsEt+D+yIjYvRz10DfaCauPoYnfmwuMRvFRek69VeySYzscZ70qgr6Hx2o1+BkvI7SNHDg7wjBF4XFQMrFrjtyocY1N/bVUFKmeENbi4tZdBxYWxwEGeHXwh001KAo2epkwNOkrCmzCl7YJfK8YXf4jddORl7SHv1U4PWLtH2Kttwd5igLCHdld3VRtqAU/hKE1IXdXjwr8J97lSN1geGWkDZWrbPlp9gPTG76oF0gzgC8lSJjwZUogBlzTunHTb5n0mtqRD3yUOf0ySuZi6H6RJIemrwOW3nkPemTZqFpKcCvr3+5ijAA3MCVbT5zzZdDmlBz13oyqu9LZXaWkJrgOzRqrmWVxTJ61iIzre4728GuJPu+/HbREKYkZvRbIRN1CmL3GDpxisFhYhZUqlQg3jBift7xqnSVIh5nL4qniYdqR456EzfXRo2bgYEKLULc3fsMLqd6M8zpsyJmIsvQWTvZL2+PQtDd5M0bzRyx9XJ/cPsh/xLZ49VXqY/3Qk2At6RTN3/01C+MeC05KhDwkk+w/FjdZNz0INOQV92kQ3apRX3Mn5vcxeRFrV2TnT2/32S0JFxw3k0tTG4+a3SA5YPdqla7geNh7IILqGQbWs0LNCXeIUYbWarLesvEy0rN7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(376002)(366004)(396003)(136003)(478600001)(2906002)(9686003)(186003)(26005)(6512007)(41300700001)(6506007)(122000001)(966005)(71200400001)(6486002)(8936002)(86362001)(64756008)(76116006)(6916009)(8676002)(33716001)(38100700002)(66446008)(66946007)(4326008)(5660300002)(66476007)(316002)(66556008)(38070700005)(54906003)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h9rnhC8v5OMg1JObhl5Jw7Oz+ZxouOEx90iDaGSV0KTH0WCr71y9XpIhEbNX?=
 =?us-ascii?Q?9ZfvzfCBPlDpGYDFMaXbX3xgxiXxYJIV7YzzxiBMIL14PmzpIS/FuZoPl/E7?=
 =?us-ascii?Q?FzPg03aL5grHaKudxStMFi9CQrRBkfJf01tzFckW1aBRNo4aWUaReB8IGYZI?=
 =?us-ascii?Q?NgLz+do+687tOUD4sta35lqGH+b5tSLYti0Klg6GlfQE17pK1WcGwQNSgf97?=
 =?us-ascii?Q?f1EcUz6h2kevX/+O/ltzQTZqFcrdKXQByh09mdC6OwVdWVAhJ5XuKosUzFJm?=
 =?us-ascii?Q?rSuvLpbLQkeOE5YMYMqxt9d7MClDHSIlaoZE9M8fxoNAhz1PlCBWMy3zCJEg?=
 =?us-ascii?Q?FN/K6Ayn2PSY6tLgZy+UuXsOBq4LUI6frWnaRINn1tJB/QxZNepN0lj1gm98?=
 =?us-ascii?Q?EuFmOdIwFJUaUADMeunaBagyrARaeZHcCw2iXLixp8cx75L8kK33mio27AUx?=
 =?us-ascii?Q?I1qnRPy4LcHcemKZ2XJT5seJ/ZxpB+2U+4IV1/v5n0y3F0AMqmVZ7OrOQ41J?=
 =?us-ascii?Q?wGA0Rf9gH5SLqoGImMD6DqpsByjihWw5SdmlSr3nkxzOzUZkfcFIc52aBG+f?=
 =?us-ascii?Q?xpuzkTmOzUEk3aEDICOwN/X5klMAE5Dg+f2/f+RXS3YHq1Zm7Rkzt32ikEkK?=
 =?us-ascii?Q?um53aP7nTGcr0v5HA9nEZLd+rG49tuf4Mq6dADYswwPGTfBo40II9ubFDv3P?=
 =?us-ascii?Q?5HFM7J/+Aoyn5EnHMkxwl74ghf6X3o4+Fq/tpcHBGYSbCKLTWgoAxXGDvXRI?=
 =?us-ascii?Q?S/SFjNYeIdtTi7QVqs1bzywAG8fZy8oHm48XRKetXgAQiMzCxlW8fqa0zJkO?=
 =?us-ascii?Q?45TOv7UGHaeaZOASoSLdEgYHHjCFIcZOQw1a2k4OcAZpRw/S7X5wU9Ytl1Z2?=
 =?us-ascii?Q?3oi/DplHnXL0dl+yxN7Wfb2MNW0KubUoTeQT4a3xNKQMRY1KZe4R3TnXRfB4?=
 =?us-ascii?Q?C3kn/qp9JWZBF7mBZT1lufe4tODV00HeVk38BMlf2pPEt343enhYSdydxU6k?=
 =?us-ascii?Q?ZiUOOVKqnny/0gbyrqTEwBlUpwahhGiKHST0shpfZVnrDHCsYknzUyJE74Vk?=
 =?us-ascii?Q?usQMD75sqpv6zzPfT4mjfbxvArV3Wh9RAQpneD2ZfF7/t/GvCqHAVUrDHLn0?=
 =?us-ascii?Q?uMoAqqxcJxcGQbqOv6s9UDTdiZsA8wW6NuVd05UrI1IFnCki9IJ80wcbla/h?=
 =?us-ascii?Q?+8XwBHfy7OVXYvJ9n9Yp0yGJY18UZaKRkS7B0ONuwRAYpbftVzxQA+DUexkf?=
 =?us-ascii?Q?UTfm6+WKF9dYKDho81HOd9xOL1qn4QU8wItW7gjH3RhR13khEdLFBN2wxHdt?=
 =?us-ascii?Q?pYB2VvhVujUFUabIcV3AW7TvB7Kc+T1GhDo0ZNBCg0F35QEVDcjqMel/Vw6A?=
 =?us-ascii?Q?3EKPiNfIts+dNvMF4Yo3sld/HU3ulb50qEnzIUu53RgVN4KNVctxnY3X534i?=
 =?us-ascii?Q?fBqeyQ29LdSTm4C0C2tcp3DO3wBiE4nwX4lUFHjVZwdLULx41bi/1JGkXVwI?=
 =?us-ascii?Q?idOFbugUfI2TNvQVxbgp9OupjrZDkgnbWOy/blngLodpfSvKQn7Uk2LZx2/M?=
 =?us-ascii?Q?3Mo7mT3FrEhwUuZMoLxVp5ic7A4oT0ijvtF2a4yDbAUQaEUgrjon+mMdtsKw?=
 =?us-ascii?Q?zqfg6TqQxO8HN4v04mG3ZcQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <57DBB598E2B4F14DAF9A793B746750E9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aea7a1f-fb33-4e54-888b-08da81c28af4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 09:09:38.1110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WTCRcnvb+Hj/CoOU8L9672JzMSikg7qsHGynCji1BjJQR1ZHiMsH/c4T23/bjTuipEW34UuH/n/DRmT2MNS7sjmG4r4y6pevFMnMK98C7jY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6504
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

I am posting this thread in continuation of:

https://lore.kernel.org/netdev/20220415173718.494f5fdb@fedora/

and as a new starting point for further discussion of offloading PCP-based
queue classification into the classification tables of a switch.

Today, we use a proprietary tool to configure the internal switch tables fo=
r
PCP/DEI and DSCP based queue classification [1]. We are, however, looking f=
or
an upstream solution.

More specifically we want an upstream solution which allows projects like D=
ENT
and others with similar purpose to implement the ieee802-dot1q-bridge.yang =
[2].
As a first step we would like to focus on the priority maps of the "Priorit=
y
Code Point Decoding Table" and "Priority Code Point Enconding table" of the
802.1Q-2018 standard. These tables are well defined and maps well to the
hardware.

The purpose is not to create a new kernel interface which looks like what I=
EEE
defines - but rather to do the needed plumbing to allow user-space tools to
implement an interface like this.

In essence we need an upstream solution that initially supports:

 - Per-port mapping of PCP/DEI to QoS class. For both ingress and egress.

 - Per-port default priority for frames which are not VLAN tagged.

 - Per-port configuration of "trust" to signal if the VLAN-prio shall be us=
ed,
   or if port default priority shall be used.

In the old thread, Maxime has compiled a list of ways we can possibly offlo=
ad
the queue classification. However none of them is a good match for our purp=
ose,
for the following reasons:

 - tc-flower / tc-skbedit: The filter and action scheme maps poorly to hard=
ware
   and would require one hardware-table entry per rule. Even less of a matc=
h
   when DEI is also considered. These tools are well suited for advanced
   classification, and not so much for basic per-port classification.

 - ip-link: The ingress and egress maps of ip-link is per-linux-vlan interf=
ace;
   we need per-port mapping. Not possible to map both PCP and DEI.

 - dcb-app: Not possible to map PCP/DEI (only DSCP).

We have been looking around the kernel to snoop what other switch driver
developers do, to configure basic per-port PCP/DEI based queue classificati=
on,
and have not been able to find anything useful, in the standard kernel
interfaces.  It seems like people use their own out-of-tree tools to config=
ure
this (like mlnx_qos from Mellanox [3]).

Finally, we would appreciate any input to this, as we are looking for an
upstream solution that can be accepted by the community. Hopefully we can
arrive at some consensus on whether this is a feature that can be of genera=
l
use by developers, and furthermore, in which part of the kernel it should
reside:

 - ethtool: add new setting to configure the pcp tables (seems like a good
   candidate to us).

 - ip-link: add support for per-port-interface ingress and egress mapping o=
f
   pcp/dei

 - dcb-*: as an extension or new command to the dcb utilities. The pcp tabl=
es
   seems to be in line with what dcb-app does with the application priority
   table.

 - somewhere else

In summary:

 - We would like feedback from the community on the suggested implemenation=
 of
   the ieee-802.1Q Priority Code Point encoding an decoding tables.

 - And if we can agree that such a solution could and should be implemented=
;
   where should the implemenation go?

 - Also, should the solution be supported in the sw-bridge as well.

Thank you,
Best regards,

Daniel

[1] https://github.com/microchip-ung/qos-utils
[2] https://github.com/YangModels/yang/blob/main/standard/ieee/published/80=
2.1/ieee802-dot1q-bridge.yang
[3] https://github.com/Mellanox/mlnx-tools/blob/master/ofed_scripts/utils/m=
lnx_qos=
