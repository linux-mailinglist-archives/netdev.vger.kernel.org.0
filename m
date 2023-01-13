Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7793669D5E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjAMQOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjAMQOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:14:18 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE30687BF;
        Fri, 13 Jan 2023 08:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673626120; x=1705162120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NPozt2nkDd+9x0kuKtIx0DKfl0yues7ncYUuUCWKRK0=;
  b=jrp/mbDh/gHm/rwWuwXRRrools3xw+r4RngxfxsJNR+JAFKVM08zOB8Y
   EXqwNWMr9AE9gkZndpw6HeCMSmXhTgepquBlMs3KdphZAEAOcuxiUt5+q
   xA079ASANAEtDx9Uz4u49AWUMcJJ/yg988hQ4Hel/6vOMLci2zSRvpAKT
   B8BbdthCFY7glakR546B04E7YTwZz/monrXgI4+wuLMZJYn9r6d6IQy2a
   a9kXlInJ6wQbxeR+Lb8iMS5cyvKAr06K4KgzuGmnA2/EX0EbK4/cX6iUC
   h2DZoKDYssllQ0ktKNd4kbxfTrTQsgMt5CXuIHEvX8g8tShA+PEVrCW9a
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,214,1669046400"; 
   d="scan'208";a="332753846"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2023 00:08:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkDMPL6s7G8iXr+vLPSl+5rn/nOCZxsQu+8XlD2iWyFEbVfCAXAZdrSuz7KhYpqEvU6SuEP88egPL4KLXstV1gDzbsbkNZJPMcIPepgPww4/OUb140cHIN+RhaIZVoQB0yZNFjrYvcWtnO/ySm3Kdew4wMFhT4kI7ECQ11VHJJblkiQ/m5c0KMTdING/1BEIRifHR1zCAnmI3ubhuyTXsx1ZZq+qnLg/90NVG+NYSGx7njB21jqWQxMXKoD928v0IACnAXDp5YZp+0ILQjWQxKHl3Dq4rCM0/deDL/l+zafiUVBoUYmx3Rmw8NAFMpkeXbUdO9l2WakbSIW6u/EJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5+ikoyClv1LHbzyyv487jTLCHvj0B9cY2or6L55lsQ=;
 b=SUF1lDO25UwiPPrD6SJrUvHXm8iMDdIducJG5gnphAoHqIhYblV5ZXNtNpAViILxN0XYsVXPmsxEdRw5S+aRHr0oAonSAw6/pNgGUSkJVRRcxDh3SE476M1MkOEhZa6j8e0Hg0x3+5V30wAiXaRZ/xazX4RtkyDYojqTC5CQ+7cAY69/Bc0NobRK32Dq/HFHd7pW0n1OjtfDQ4aZOzySGZftFC1la7P2PeTU3fafTmpoxjDbE7b8q/PQTwn/YyvQpjXnMUokmwpm6DBfipgKqIOCX8UbfDO8zkfsyQ8EvxWd2JycJFp4Efkhos5oofzzOjtzIaKX/PbyGBrmfuP+Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5+ikoyClv1LHbzyyv487jTLCHvj0B9cY2or6L55lsQ=;
 b=PzmdN4GVnU1llINC++YZKcY1t6+kjeOHAIfmTuUAyHG/Wh42+JW4akrfel1yahh1yT9LlKc31pnGPYMi0B/dMBE8Kf3IBLY6E9w/qA8bZJ2M5dsTM3y7mpbz2JooizCu/IwKI+/DNQz79tMqyBCV4oA6G/p7pVqwdkcWQ5q/DSo=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SN6PR04MB5054.namprd04.prod.outlook.com (2603:10b6:805:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 16:08:22 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 16:08:22 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Siddhesh Poyarekar <siddhesh@gotplt.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: linux-next - bnxt buffer overflow in strnlen
Thread-Topic: linux-next - bnxt buffer overflow in strnlen
Thread-Index: AQHZJ2lCUJqUxstXRUGtYPCc7p47dg==
Date:   Fri, 13 Jan 2023 16:08:21 +0000
Message-ID: <Y8GB9DMtcSP/8e/i@x1-carbon>
References: <20220920192202.190793-1-keescook@chromium.org>
 <20220920192202.190793-5-keescook@chromium.org> <Y8F/1w1AZTvLglFX@x1-carbon>
In-Reply-To: <Y8F/1w1AZTvLglFX@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SN6PR04MB5054:EE_
x-ms-office365-filtering-correlation-id: a8936a0f-b8cc-48a8-01d6-08daf580648a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0XKgBYmyClCpPfHx8ZBOaIDFrElsdXCtalCPfYF/kgqQVprneTxC0SJoLDfgecZeph8+nzCHinKbC/bwZhmaASFkkYkelt7GRNDkd/qUkXWqQYw1SZwWMm0BfzhoD6rF7TQJmgDTz4Ja4mGYSjxn7lzU3XrV9/kEvdJU+VOIGr5Yf4UBZsQTfhiGNY3JeKmJEpFrjlfeviFtUPUfkzt4CAQSbt/Q6Cobg1Lct01ePFJCSZk6i/aYvvr38aKGXr0l7sGNuIew2t/YA7hKlC5+USUUy3pNQVYsfhdUrCxoRTC7S5HToOXrV75qOwBTujMd2LqgCjASmcOrcYZUViBm/2NIm1bEEri2JJLUN/7cAXwa2zQAoESZVH3WuGNUM//c/Q6vLySTUKtNpV14Kxe84cNSFOJIa8fna8oMKtlnryYou+kCJDhN68xNw72KZzui+BkwkiYXOyi45+TchOe2PeIvEQff/knJilyCG4lVMbz2bYLa1XoSSk5rplXbTY/6hw3Rjwy3r6KYB+mEBpeq/rxedUWHhTzTWzGHdwIIivs1xz6GSUDnRlTnXhmwzefdAgYjOD6sXCXebkhaCPVEEgBQqyW3YOKEDEEeT6qc3S6JRuNy0ZYkTG9teaberjAeFMHYOLRvAw5Y9qJ+dE+6apILRH8ykyr0uvdCm8v94+f3r5ayk70TSuU4OSPAA2/kOl+2/brG2MW0pqg28Q95PA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199015)(76116006)(83380400001)(4326008)(6916009)(64756008)(66446008)(8676002)(66476007)(66946007)(38070700005)(91956017)(66556008)(41300700001)(33716001)(82960400001)(86362001)(71200400001)(6512007)(478600001)(45080400002)(316002)(6486002)(122000001)(186003)(6506007)(54906003)(38100700002)(5660300002)(9686003)(8936002)(26005)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?28R72zoUpyT+WfXLnBV2VVBOgiS4UdlvkTTx3kmnud3gcPG4tiFMMa70qOAW?=
 =?us-ascii?Q?PfpE4UmV87o18fwRjEPDI7y53H9MW+Ao9NJOr1z+nHzhIldL4dkJ5A0WBeYe?=
 =?us-ascii?Q?A7itn4ealQM/QoNIa/rXX+xEdOVULZGW/JknRTk/kxgharEQWOEBr/MRWEVc?=
 =?us-ascii?Q?atl/DgGwrrbEOEv2lDSavJnpcFjgiCSvwjtTPouYbi9PXPa8icJuR9ZTyQ99?=
 =?us-ascii?Q?0keDPYJov40aoa/nloDj+AiYHVjUmLOGK/qzYnn3YBJm0FpxWHUEiqiMzOE4?=
 =?us-ascii?Q?WErqUY+icaSGHHGVPoQgr3N3S0O1C3zTbsS5Acrr5jYWq6A35MmNfRE4yk9d?=
 =?us-ascii?Q?qOQbxvJ4kmgkbDndgecCr8HcS0n6P/Fki+SwQktezSV6uP6Twg1eKIXWpeI6?=
 =?us-ascii?Q?vxrync1h8DyRykMFtVEnZ3qvuSNN0KC10DKREAWQWws+OP+2L6FS55r1Kfif?=
 =?us-ascii?Q?RZZBYrcMPjzxFbVQNHbl6/6VuBhM+Vp2OlI3V0w/e2gVCG79J79TG/4X8cL9?=
 =?us-ascii?Q?wGVwYWeb18UaDnAmL6TOzxS287bkbdKIpjAvWIRh025mx26Zide3TzC1I4s1?=
 =?us-ascii?Q?WvQTDarHabE427siiu0ucK89R1JvGrjkQbW2/1AlYG2qHclv1i/lb6hAigJC?=
 =?us-ascii?Q?iFajqzTCP1zn0MuhBiHN3gjoRZ2oa5VU1AUJf1LVGktIcIbSWftO+Qz/QVoS?=
 =?us-ascii?Q?YMQu6snf7HIt9hg5eXDG3cnHr1nh5Ae54jfjVSJosPUBHSuIIiT37KZrgN86?=
 =?us-ascii?Q?rx/fNkoaIYnw6PF9OBM38wtNMefPwAYMzG1DlmvNA1s58E1/RimBBaYa389W?=
 =?us-ascii?Q?FCH9O4OGP87L2ygdZ21wW+fzm7y9Xg4S9fv0WvjCwTag3AxI2rrchkB+IlVF?=
 =?us-ascii?Q?p095AXkJlGW2qoE9LkdnU8OkyKMha4hU+nbwnFtKHMxenclq9kRGnfd0GzRI?=
 =?us-ascii?Q?Q4gFyLkV1gxPd3ZAdP4FrqAGKdyZKok+aQkNxHD3ngq05cWbOD6m9S0R1laM?=
 =?us-ascii?Q?KaQDZOp83VTqlv/DXASkQEFqWbsgkRIKceBJX5dr8X49+Y9tEaIr5DBLD2QZ?=
 =?us-ascii?Q?Rc3raBixXDpBzU2U5sJSfoT0bifC8umBQDdHyDpu6CbEJLqwHI6UdveTiPD2?=
 =?us-ascii?Q?Ie48VpKEaZm8Dbtvtoauqs2crg60oBzNxKBZxmf7LUaZrXLVTVc54ofYUW94?=
 =?us-ascii?Q?wSO23t/rDlfKYQQP6BYBmuiDdtTcEzLiA5AZ6Wby6zdbm2FKSeBI65WopzPL?=
 =?us-ascii?Q?J7T4ULDUTk+jqZ4itPo0tFwuc8bNiydR3/B/AvanzV8nkj9j3Vf+QUkJ3lrH?=
 =?us-ascii?Q?ctCpk8/93KOlhJcwAJe/tYThFzKy+701pMbrNT0xsh0D8eZNL73nxgIQDW7C?=
 =?us-ascii?Q?F/ygQIEQF8rVxMJkCfTD4M0JulolYVuqtlUu6klBiyM0TMGzAx6Q0SZwxUJP?=
 =?us-ascii?Q?1PGCJt74WMot0Fp1edOUquhGk0H0QuXPs8kklK9xSzvHqKjDDgvAfdsSnVna?=
 =?us-ascii?Q?nODJBJWPW2e3I006QEU0DGb2gP/znGrUirfx5FPu2i0KTIma9QLzUtzsWVnU?=
 =?us-ascii?Q?FFRieuH2VxMoMH7i+bf4s9GYzBTrJ1O3GetBHdVHhoyP99xymusxETGGXtRn?=
 =?us-ascii?Q?6A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C9DDF30AD033CC40B65B42862D3001FC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?/74TWzJcKArVW5AihgLhUPAnLjcp7lOHBKLpMWu2xnm10xLXduK+ae6SyuA0?=
 =?us-ascii?Q?jzprF7WbcnyDPAC0Ddg4mgh0HasBeFdVOubwcyDR7xH/AuwGg98S1aDRayOa?=
 =?us-ascii?Q?deLr1KrDUTJXfbVlCnpyTEBFbF7zIVg2uhKEFU61AOa0FAsDXsffbPvROLgO?=
 =?us-ascii?Q?vwmTqwIIvhFAn4WAljjKUvU+VPKWy8pno24vsfnxhFUkdZHIsiUOq3npjHAA?=
 =?us-ascii?Q?Lx4ZjBG030GN00v2kwDtulFmBVfo6hnD3MmgCJ+jRnkGkF7efRbNtf2BVIoT?=
 =?us-ascii?Q?aWSdep2Fc6xBjI5sNVCj8sssyBgtaxQ8bad2Lb5BsG29Ni+z3+Fkr7dmPcgA?=
 =?us-ascii?Q?knIZk/AlOzNvemDH9LS73E1O9o9GXD/k3t/BnviC5vObaZ+JyjqKybXStj7/?=
 =?us-ascii?Q?faiXeaLhaqrjwLXv+7CBeNkySU+Qy21KsPmTo6/pJB30LFWZhN/bOezrSCYh?=
 =?us-ascii?Q?6XySiTMSSx59MU19zsouCTvTmZnXNuPUmRkPQtsLsFW5ExU4GCZxMV2lTpa8?=
 =?us-ascii?Q?Qhqcx2jBz2atGTDdBFuersox0yVkKfRQTt+0QKdwpYRKVyWLwWJSo2Goy1Cm?=
 =?us-ascii?Q?DKQesqg12kT/I7IKej2IgiraPoxboECgZh7xnTXENcEXZTPkndqNnMgZSPLD?=
 =?us-ascii?Q?3hcQxuk0Otfq52PU7jF2iVWpSj9RUKc7mHkzXCa+DOGSkX5UvvHwR8FejKKh?=
 =?us-ascii?Q?jrPiGvAbXpjpcf6+LD7abeYVlr3TbkoMDmPFzcidT7fCAO//5vWR/Mpvce+b?=
 =?us-ascii?Q?3/D7veK981n52lbD5Fv3HYqHrBXXtClT0Uskn1s18pkktuLBfhjMUW7R10Vp?=
 =?us-ascii?Q?/lDNcf+leoJyqRiGdtBq5/5itl61wMZeuK9uAQRBEg9R2DZcN0qEND6o2nFs?=
 =?us-ascii?Q?yFrnmfAeNc9FKRQ1KjyGbS7r7CTxzL36LjR/PFX1U5j5zw/7adb8ym0v2KQ0?=
 =?us-ascii?Q?/kEeKjwg+OXLPPr0wwOBSWtkwdkWN5k77X8CVNoIIvxL6qFjjhXXYRZAgP6R?=
 =?us-ascii?Q?gA75F38ZY/Z+jxmizuJdcS80LMpvgceLrXutyMdEUIfxIH7nB217x5xJEwx3?=
 =?us-ascii?Q?Cj8rtYs9Pno/nzs9RDQ7BtOTX90QpQ=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8936a0f-b8cc-48a8-01d6-08daf580648a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 16:08:21.7262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YPX955k+Trzm1KSVV1G4ukQErdrCrFOZ6//Ydl2GtIUHEITU2Cu0qI3B1gtvUzngeiTBEgJkuVLEIXLK/JFuvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5054
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 04:59:19PM +0100, Niklas Cassel wrote:
> On Tue, Sep 20, 2022 at 12:22:02PM -0700, Kees Cook wrote:
> > Since the commits starting with c37495d6254c ("slab: add __alloc_size
> > attributes for better bounds checking"), the compilers have runtime
> > allocation size hints available in some places. This was immediately
> > available to CONFIG_UBSAN_BOUNDS, but CONFIG_FORTIFY_SOURCE needed
> > updating to explicitly make use the hints via the associated
> > __builtin_dynamic_object_size() helper. Detect and use the builtin when
> > it is available, increasing the accuracy of the mitigation. When runtim=
e
> > sizes are not available, __builtin_dynamic_object_size() falls back to
> > __builtin_object_size(), leaving the existing bounds checking unchanged=
.
> >=20
> > Additionally update the VMALLOC_LINEAR_OVERFLOW LKDTM test to make the
> > hint invisible, otherwise the architectural defense is not exercised
> > (the buffer overflow is detected in the memset() rather than when it
> > crosses the edge of the allocation).
> >=20
> > Cc: Miguel Ojeda <ojeda@kernel.org>
> > Cc: Siddhesh Poyarekar <siddhesh@gotplt.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Nathan Chancellor <nathan@kernel.org>
> > Cc: Tom Rix <trix@redhat.com>
> > Cc: linux-hardening@vger.kernel.org
> > Cc: llvm@lists.linux.dev
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
>=20
> Hello Kees,
>=20
> Unfortunately, this commit introduces a crash in the bnxt
> ethernet driver when booting linux-next.
>=20
> I haven't looked at the code in the bnxt ethernet driver,
> I simply know that machine boots fine on v6.2.0-rc3,
> but fails to boot with linux-next.
>=20
> So I started an automatic git bisect, which returned:
> 439a1bcac648 ("fortify: Use __builtin_dynamic_object_size() when availabl=
e")
>=20
> $ grep CC_VERSION .config
> CONFIG_CC_VERSION_TEXT=3D"gcc (GCC) 12.2.1 20221121 (Red Hat 12.2.1-4)"
> CONFIG_GCC_VERSION=3D120201
>=20
> $ grep FORTIFY .config
> CONFIG_ARCH_HAS_FORTIFY_SOURCE=3Dy
> CONFIG_FORTIFY_SOURCE=3Dy
>=20
>=20
> dmesg output:
>=20
> <0>[   10.805253] detected buffer overflow in strnlen
> <4>[   10.810683] ------------[ cut here ]------------
> <2>[   10.816035] kernel BUG at lib/string_helpers.c:1027!
> <4>[   10.821753] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> <4>[   10.822737] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 6.2.0-rc3-nex=
t-20230112+ #4
> <4>[   10.834787] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS =
2.4 04/14/2022
> <4>[   10.839875] RIP: 0010:fortify_panic+0xf/0x11
> <4>[   10.844962] Code: e0 e8 da 83 0a ff e9 31 45 6d ff 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 48 89 fe 48 c7 c7 78 69 d6 9f e8 01 ea fc f=
f <0f> 0b 48 8b 4c 24 18 48 8b 54 24 10 4c 8d 44 24 25 48 c7 c7 b6 69
> <4>[   10.865321] RSP: 0018:ffffb547c005bb98 EFLAGS: 00010246
> <4>[   10.870406] RAX: 0000000000000023 RBX: ffff94f0582bc400 RCX: 000000=
0000000000
> <4>[   10.880584] RDX: 0000000000000001 RSI: 00000000ffffdfff RDI: 000000=
00ffffffff
> <4>[   10.885672] RBP: ffff94f0582bc424 R08: 0000000000000000 R09: ffffb5=
47c005ba60
> <4>[   10.895849] R10: 0000000000000003 R11: ffffffffa0182448 R12: 696c66=
666f282074
> <4>[   10.900937] R13: 736574206b636162 R14: 0000000000000001 R15: ffff94=
f0545f8b40
> <4>[   10.911113] FS:  0000000000000000(0000) GS:ffff950f07380000(0000) k=
nlGS:0000000000000000
> <4>[   10.916201] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[   10.926382] CR2: 0000000000000000 CR3: 000000204c05a000 CR4: 000000=
0000350ee0
> <4>[   10.931470] Call Trace:
> <6>[   10.936317] ata9: SATA link down (SStatus 0 SControl 300)
> <4>[   10.936745]  <TASK>
> <4>[   10.936745]  bnxt_ethtool_init.cold+0x18/0x18
> <4>[   10.936745]  ? dma_pool_free+0x14d/0x160
> <6>[   10.942591] ata10: SATA link down (SStatus 0 SControl 300)
> <4>[   10.942663]  bnxt_fw_init_one_p2+0x18d/0x5e0
> <6>[   10.949046] ata4: SATA link down (SStatus 0 SControl 300)
> <4>[   10.949841]  bnxt_init_one+0x401/0xf10
> <6>[   10.958451] ata6: SATA link down (SStatus 0 SControl 300)
> <4>[   10.958854]  local_pci_probe+0x41/0x80
> <6>[   10.968114] ata3: SATA link down (SStatus 0 SControl 300)
> <4>[   10.968892]  pci_device_probe+0x1e2/0x210
> <6>[   10.977259] ata8: SATA link down (SStatus 0 SControl 300)
> <4>[   10.977657]  really_probe+0xde/0x380
> <6>[   10.986406] ata5: SATA link down (SStatus 0 SControl 300)
> <4>[   10.986817]  ? pm_runtime_barrier+0x50/0x90
> <4>[   10.986817]  __driver_probe_device+0x78/0x170
> <6>[   10.996042] ata7: SATA link down (SStatus 0 SControl 300)
> <4>[   10.996978]  driver_probe_device+0x1f/0x90
> <4>[   10.996978]  __driver_attach+0xd2/0x1c0
> <4>[   10.996978]  ? __pfx___driver_attach+0x10/0x10
> <4>[   10.996978]  bus_for_each_dev+0x65/0x90
> <4>[   11.047368]  bus_add_driver+0x1b1/0x200
> <4>[   11.052640]  driver_register+0x89/0xe0
> <4>[   11.057487]  ? __pfx_bnxt_init+0x10/0x10
> <4>[   11.061634]  bnxt_init+0x20/0x33
> <4>[   11.065015]  do_one_initcall+0x5b/0x340
> <4>[   11.070105]  ? rcu_read_lock_sched_held+0x3f/0x80
> <4>[   11.075198]  kernel_init_freeable+0x29e/0x2ee
> <4>[   11.080635]  ? __pfx_kernel_init+0x10/0x10
> <4>[   11.085379]  kernel_init+0x16/0x140
> <6>[   11.087743] ata16: SATA link down (SStatus 0 SControl 300)
> <4>[   11.086528]  ret_from_fork+0x2c/0x50
> <4>[   11.086528]  </TASK>
> <6>[   11.094437] ata17: SATA link down (SStatus 0 SControl 300)
> <4>[   11.094645] Modules linked in:
> <4>[   11.097999] ---[ end trace 0000000000000000 ]---
> <6>[   11.100194] ata18: SATA link down (SStatus 0 SControl 300)
>=20
>=20
> Kind regards,
> Niklas

+netdev
+bnxt maintainers=
