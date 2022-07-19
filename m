Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7C057A749
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiGSTfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiGSTe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:34:58 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130045.outbound.protection.outlook.com [40.107.13.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6EC564C7;
        Tue, 19 Jul 2022 12:34:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+Azxr6OZKWhAr/ECazV1oQOUiStIiHSa1URupPK0fF+MdZqFCB6PLJzUNypNuUytYizDh7l46nUlb9yGy7ExArZ/vW3NQe3Dv29oL5ow53v8eY4kuvMO2eVthiYQA4lh9/kb7qaMRcnB0RoGYDhbSNw7/oBA0TFHP1CHzdYKaF1k+D005xJR5MA1UFA+lQurPX/DXaC/AMq3ZYq/8h6nfdg56UrjMG38ENZihDdvX3voGCa4SL5KAicOnE1MMkuqkPRPXk/IB59Eez4EHuGBnIIIcpa2p0Eti7T/60xzyiQlI57swixWzrDRN58ZJA1T5kb5aldATh/jV6GxMI/9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41uLQjxB7W7WUrs9yR4TDE9pwHiSGEtbHX0FQTN4Ti8=;
 b=ntS6oesvTrv1gJBfPYmMQmVtBC93c8+3Q9CxqslLjCnshCwLrsd56oPCpeSc4Prptcfe5Q9kRjrWVn+rPnF8BEeFNK9JdYSLWo8SHBNjOb+ixZCWlfJy/4uqLPIDG8+BYPK9plM9L2PcibYlG2jEnDJaoC6uHD4AtEPuQ/4XQKizpcXQX4yjQEome2WFp9oL8PUGQA11xFjYH0RwXQo0Zt84kYtYdsW40DB1khoKawDLexQ5E16LyUp5B+C+PhMt3FNml6f4TDh/RYTnMccafSorH/er5TjpzOQr+CfP9EKYiyyu0NaPGqfW9tkUfsKyFHiBE7SoLrbz8XTzffosVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41uLQjxB7W7WUrs9yR4TDE9pwHiSGEtbHX0FQTN4Ti8=;
 b=WLYoWo5XY9zV9cNdgqoKN6CXo7dq52OIyQ0vAqcPlfQt2iAIhsVKOrMbif33r1E/1GgMZOWP95kaoCpcKZNDhVZjQqWpZzRwiKc8lIuoKdbgK04c72utHE3LvvF+h4brePdPovLhjhV6jyZiS+8h1yvRMG8419fWkqgPAxtMnW0iKrRYyUrhHY8U9dMek/out3It6Bh3ji75oPHhvbW8wTSLXKmZq5e+6Aw7siRHrc9iOongSfa7tZ5fO6j+j2TH0fz4i3CmVbzsVbbEUWOXcvpBL60Q09qXNT9suhfTvJ3NzHyljoJa8S9AwpgSxuKQYeKcne1GAM7yA7S1hpSs/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3916.eurprd03.prod.outlook.com (2603:10a6:5:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 19:34:51 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 19:34:51 +0000
Subject: Re: [RFC PATCH net-next 0/9] net: pcs: Add support for devices probed
 in the "usual" manner
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
 <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
 <20220719153811.izue2q7qff7fjyru@skbuf>
 <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
 <20220719181113.q5jf7mpr7ygeioqw@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
Date:   Tue, 19 Jul 2022 15:34:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220719181113.q5jf7mpr7ygeioqw@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:208:32a::34) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ffa2d4d-75c7-448f-bf9d-08da69bdbfa6
X-MS-TrafficTypeDiagnostic: DB7PR03MB3916:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrE7xZ5SSHtW04kRoeAbEzrRur6RuzdD5o5io2pOSDWLiyC6bPAT4jjPT5LpL70Zrd9ojAoeqXSnzuJHejKtJgBAZfVC3okQ0OfOsf8N5HA7qUeyZwhG+vBDtuuCs+oe93UkXyzasEeB3yIMOispYfAFrBKvvnkq0ws6UfIjMMKHeZG+gvO+PmACm3a2UrmKKBrO4JKt1V9q+oN9/nkfTopz04py8Gn7/J1816ijFfTB/uLifz2MwmGWvRtllDNdG/o7TzakCJ3qY54iPfMRX46ZfAcinfuHmCFL0BsLAgosjvBM4NPhBw8wb1vJ8OWT8xXPEU3bmspntv5VXvBj/q0U83rrdk/mUu25p9TKzty33vj7HS7PWug/VZuQqCTjQnFMNVH8Ywm0eHkLq8rOi0Qwg6yq2CfzWkCV/SFgAFm8eB+7O42rBWbrfnixnfRawDYd+vdHy2BMSKluFzBX1t3yrckNTB/ljFrvaLVTvsylg56hoJrhiJlspuof18oM6Ue9omzxAiL1RbHVtvqtSp7g+VW4KBCabHKOzpI45VQcLqFBqZVqrXWR4zagtbzZYlCWwHV5wbrBKDDHd5yTcaYZmTLhYFtitk0MvVA04LCZET4eG/P0Z3ipSoL7e3d8i2jW3lMxCQxjPEPvef+ydVHCWvA7Xlc7AB/ymC99Q1QJcsx1AlodSO5yxGRDuB9oK2LCoD10ISYPnQ/QJunC4Xart06/q4sSZVBwsO+2m6gBVA1mont64+Nc1OGwV2iRlXfKbKQfDzP7jSdFkVuJWA8y0krN55NdqEkjVkNUM4Q4K1pqncIvfQuIED7252+0+Yg8R0ATRxDz22kj+3t9FjQSK3OzMhd7u/YvTI3nKAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(39850400004)(396003)(136003)(38350700002)(31696002)(38100700002)(36756003)(86362001)(31686004)(2616005)(186003)(52116002)(26005)(6666004)(478600001)(6486002)(53546011)(6512007)(41300700001)(2906002)(316002)(66556008)(8936002)(6916009)(4326008)(5660300002)(66476007)(6506007)(7406005)(7416002)(54906003)(83380400001)(66946007)(30864003)(44832011)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFQxdVdpWDhITGRBVEdzY3A1Njk0a1F4UUpJOVlzUWhWeW9GUzdtaDdjSmRu?=
 =?utf-8?B?dFpWY0c0aWJOdUJQU3oxSDRHL25EeitnTXJHWG9iU3NFeXpaS0ZBRUxhSnN1?=
 =?utf-8?B?bFdKTmVJUGUvMjZsd2ZQRDZOQVg3T1dwRDdJSjFoTzV0RlBvWlp1MHh1Ykhs?=
 =?utf-8?B?Y1U3eldEL3dqZ0lHOUNaakhRREMwMGlWcHRQZUJ2b2hJUHRaMlZzN1VOalQ2?=
 =?utf-8?B?aTh5MEZZOW4vUGFpcGNDTHpWOWZFL2c2ZWFNcVJVUnh6KzJyc3pzbFR2dUhH?=
 =?utf-8?B?M2d5OFV5ZVFyWVVVanpzWTFncWRaSFZKZE5QVk8yZW1IVGlpdEU0ZWlEazZR?=
 =?utf-8?B?NGZ3K0R5NDdFYWJJa1FxVit6aFFWelRoUHNzR3VJbC9SeEpCeFBYdFlaVVJD?=
 =?utf-8?B?Mkg2K1hpMnE0bTA3NHJDd01aUC9YektmN2dHbnBWQ3AvRnlLc0dqYUozNlRF?=
 =?utf-8?B?cFNRc2w1SFlSVXdtM3RvWWdhV0c5eVZUK1JyNkd1emlNYm43ejFVV2F2QUxT?=
 =?utf-8?B?SjJLMWRDaVRTMUQ3VmR3OGxSdnpXYzAyN24vVC9ubDVlL3hjamcrczNDSndi?=
 =?utf-8?B?NkdVdityWU15RVZRc3U5bmtyZkpHWXZWcFRQWlJsUnZLNVE2T1k2aS9tSndM?=
 =?utf-8?B?ZGtuNnp1b1duc0h1aHFLakh6bHlCT0hMRGt4bE1qQ0JzTmtOVjI2K1hBd2JB?=
 =?utf-8?B?cnRSUnVmaEtoUHEvV3dUSDZJSkM3TGJPTkFyd0RHYlhPZTJNUmRMeWpTMklj?=
 =?utf-8?B?Qm91Y3lGb3R3UVAyQXB4V3VQMWwvZkNFMDJyUVIrb3VQQ05Od1JXOWpkQVps?=
 =?utf-8?B?c1lEU1phc29ySjE1U1hJbUlTTU9ZNXJtTzdMbDFTWUJYTFNPUEV1Vk5peUtx?=
 =?utf-8?B?L1ZNaFo1bStycE9wK09QMmtRZWl1Vnl3ZGpVK0x3bXF5eE91RkNFN2hOZWtj?=
 =?utf-8?B?dFZ5Y2hRWDRDYklUamRyUHUxMVMxc1MxSEZNNEt1ZkJ5ZTdoSzRmNHdLMlFB?=
 =?utf-8?B?NlN0ZTU3L0dGbUg4SEg5MFVLUytqRmNDTXZ2ZllxR0VnMXI1Vjh0aktBZXlC?=
 =?utf-8?B?MlY1NVZnTHRXblJENlA3SkNZWXlhY2dKbm1NVklUdys0VlZhdWN4UXFEcU5n?=
 =?utf-8?B?dExTNWdLSkQ1QWFDVTU5eko0ZURLOHZQay93V1dsSWNuVW1oVjREUFF3a0pj?=
 =?utf-8?B?NmpXRFp4SVJicm84aHBORDlFcjF1TVB6dVlYY2ljRHpaZURmY3VxSitCeE9w?=
 =?utf-8?B?MWhUa2NQYi9QdEhQcXV4bG5FRnFEM2l2cHhoNm9GVUtGUmNpZmYzY3NTVWpO?=
 =?utf-8?B?RnVVcU5uT0EzTmE0bWhNbnpCdkJDQ1VrRVFWVkE2SHNadFc3N2IrN1FNQVRQ?=
 =?utf-8?B?T1Z4MS83WGlFUmpoUnd6cnFQMGt3OG5zOXdVMTR5LythK1JrUG8xdno5UUxo?=
 =?utf-8?B?MmkydkFoSWdtb2NRZ1NmcGloekNrcGtHa3puaWVhcWprUnBhclY0ZmIyTmRr?=
 =?utf-8?B?azBYYkpBTWdoUmhwMVo0VXBrc0F0SzVjb0FxNS8xYjdURTg3blVqeEJlTVhq?=
 =?utf-8?B?VFJuRWZjWUZwbGdoYm1oYlZRMWFiQzRxQWZ2dDYzV3cxVHlRamdHbkpHdmZ3?=
 =?utf-8?B?NnhZWGhUZlhSNHlrdTZCRE1SaUZrZmNTdHhGLytQckNraFRaZWpFWWlGQ1hz?=
 =?utf-8?B?UTNDaHVBNDY2V2JuT2RjUEdWZGJkWXVIbXAvcGlOd0lQQjkvTUxLd1FsV1A0?=
 =?utf-8?B?WXZzNWtEUUV3WWhNdHo2OUE2dTF4YWI3akE4S1BJeG9pejhtanlGZGwxYy9D?=
 =?utf-8?B?ZEpMODM4cmhSWi9tQlFmUUtKeXlHSTYwalVXMi85Y0tpSkN1MWFPTWN5L0xT?=
 =?utf-8?B?ZEY1aUFQVEMrRi9OaEswL1RrUFlWd2NNQytCTXlxSnVEMWVnbGlGRkNFM1A1?=
 =?utf-8?B?MzN1aFZDZGVkOUswU3E3T2ZzOHY4QTFRclM3aFlMS2lrK3dYN1JGa2FUT0lT?=
 =?utf-8?B?NDVwMWZDQWxodEVWY3hpVi8rcDkrZzhQWmFVMVhXTnlqV0w5NVVIcGVsRHox?=
 =?utf-8?B?VE4wdzhuUFpwb0s0c0lIemNyWVdJZGc4US9tRFBYUWE5U2p6Zis4UkU5K3JK?=
 =?utf-8?B?TmFuckRSSWRxUU5GZ0g2L1RQYVlaT1YyS2E3cE5UblM3UTRWQllDeVMxN1hh?=
 =?utf-8?B?U2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ffa2d4d-75c7-448f-bf9d-08da69bdbfa6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 19:34:51.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnbzer3TktpsNBmwEw5WF2djkN44t6QFkwr3IWPkV//9XIvGioyv8DxscRt9eJJiEBQe04z1ywN6a5HJAKnERg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/22 2:11 PM, Vladimir Oltean wrote:
> On Tue, Jul 19, 2022 at 11:46:23AM -0400, Sean Anderson wrote:
>> I'm saying that patches 4 and 5 [1] provide "...a working migration
>> path to [my] PCS driver model." Since enetc/ocelot do not use
>> devicetree for the PCS, patch 9 should have no effect.
>> 
>> That said, if you've tested this on actual hardware, I'm interested
>> in your results. I do not have access to enetc/ocelot hardware, so
>> I was unable to test whether my proposed migration would work.
>> 
>> --Sean
>> 
>> [1] I listed 6 but it seems like it just has some small hunks which should have been in 5 instead
> 
> Got it, thanks. So things actually work up until the end, after fixing
> the compilation errors and warnings and applying my phy_mask patch first.
> However, as mentioned by Russell King, this patch set now gives us the
> possibility of doing this, which happily kills the system:
> 
> echo "0000:00:00.5-imdio:03" > /sys/bus/mdio_bus/drivers/lynx-pcs/unbind
> 
> For your information, pcs-rzn1-miic.c already has a device_link_add()
> call to its consumer, and it does avoid the unbinding problem. It is a
> bit of a heavy hammer as Russell points out (a DSA switch is a single
> struct device, but has multiple net_devices and phylink instances, and
> the switch device would be unregistered in its entirety), but on the
> other hand, this is one of the simpler things we can do, until we have
> something more fine-grained. I, for one, am perfectly happy with a
> device link. The alternative would be reworking phylink to react on PCS
> devices coming and going. I don't even know what the implications are
> upon mac_select_pcs() and such...

We could do it, but it'd be a pretty big hack. Something like the
following. Phylink would need to be modified to grab the lock before
every op and check if the PCS is dead or not. This is of course still
not optimal, since there's no way to re-attach a PCS once it goes away.

IMO a better solution is to use devlink and submit a patch to add
notifications which the MAC driver can register for. That way it can
find out when the PCS goes away and potentially do something about it
(or just let itself get removed).

---
 drivers/net/pcs/core.c     | 115 +++++++++++++++++++++++++++----------
 drivers/net/pcs/pcs-lynx.c |  20 +++----
 include/linux/pcs.h        |  23 +++++++-
 include/linux/phylink.h    |  19 +-----
 4 files changed, 117 insertions(+), 60 deletions(-)

diff --git a/drivers/net/pcs/core.c b/drivers/net/pcs/core.c
index 782a4cdd19b2..46e4168802db 100644
--- a/drivers/net/pcs/core.c
+++ b/drivers/net/pcs/core.c
@@ -10,42 +10,83 @@
 #include <linux/phylink.h>
 #include <linux/property.h>
 
+struct phylink_pcs {
+	struct mutex lock;
+	struct list_head list;
+	struct device *dev;
+	void *priv;
+	const struct phylink_pcs_ops *ops;
+	int refs;
+	bool dead;
+	bool poll;
+};
+
 static LIST_HEAD(pcs_devices);
 static DEFINE_MUTEX(pcs_mutex);
 
 /**
  * pcs_register() - register a new PCS
- * @pcs: the PCS to register
+ * @init: Initialization data for a new PCS
  *
  * Registers a new PCS which can be automatically attached to a phylink.
  *
- * Return: 0 on success, or -errno on error
+ * Return: A new PCS, or an error pointer
  */
-int pcs_register(struct phylink_pcs *pcs)
+struct phylink_pcs *pcs_register(struct device *dev,
+				 struct pcs_init *init)
 {
-	if (!pcs->dev || !pcs->ops)
-		return -EINVAL;
-	if (!pcs->ops->pcs_an_restart || !pcs->ops->pcs_config ||
-	    !pcs->ops->pcs_get_state)
-		return -EINVAL;
+	struct phylink_pcs *pcs;
 
+	if (!init->ops)
+		return ERR_PTR(-EINVAL);
+	if (!init->ops->pcs_an_restart || !init->ops->pcs_config ||
+	    !init->ops->pcs_get_state)
+		return ERR_PTR(-EINVAL);
+
+	pcs = kzalloc(sizeof(*pcs), GFP_KERNEL);
+	if (!pcs)
+		return ERR_PTR(-ENOMEM);
+
+	pcs->dev = dev;
+	pcs->priv = init->priv;
+	pcs->ops = init->ops;
+	pcs->poll = init->poll;
+	pcs->refs = 1;
+	mutex_init(&pcs->lock);
 	INIT_LIST_HEAD(&pcs->list);
+
 	mutex_lock(&pcs_mutex);
 	list_add(&pcs->list, &pcs_devices);
 	mutex_unlock(&pcs_mutex);
-	return 0;
+	return pcs;
 }
 EXPORT_SYMBOL_GPL(pcs_register);
 
+static void pcs_free(struct phylink_pcs *pcs)
+{
+	int refs;
+
+	refs = --pcs->refs;
+	mutex_unlock(&pcs->lock);
+	if (refs)
+		return;
+
+	WARN_ON(!pcs->dead);
+	mutex_lock(&pcs_mutex);
+	list_del(&pcs->list);
+	mutex_unlock(&pcs_mutex);
+	kfree(pcs);
+}
+
 /**
  * pcs_unregister() - unregister a PCS
  * @pcs: a PCS previously registered with pcs_register()
  */
 void pcs_unregister(struct phylink_pcs *pcs)
 {
-	mutex_lock(&pcs_mutex);
-	list_del(&pcs->list);
-	mutex_unlock(&pcs_mutex);
+	mutex_lock(&pcs->lock);
+	pcs->dead = true;
+	pcs_free(pcs);
 }
 EXPORT_SYMBOL_GPL(pcs_unregister);
 
@@ -65,26 +106,25 @@ static void devm_pcs_release(struct device *dev, void *res)
  *
  * Return: 0 on success, or -errno on failure
  */
-int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs)
+struct phylink_pcs *devm_pcs_register(struct device *dev,
+				      struct pcs_init *init)
 {
 	struct phylink_pcs **pcsp;
-	int ret;
+	struct phylink_pcs *pcs;
 
 	pcsp = devres_alloc(devm_pcs_release, sizeof(*pcsp),
 			    GFP_KERNEL);
 	if (!pcsp)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	ret = pcs_register(pcs);
-	if (ret) {
+	pcs = pcs_register(dev, init);
+	if (IS_ERR(pcs)) {
 		devres_free(pcsp);
-		return ret;
+	} else {
+		*pcsp = pcs;
+		devres_add(dev, pcsp);
 	}
-
-	*pcsp = pcs;
-	devres_add(dev, pcsp);
-
-	return ret;
+	return pcs;
 }
 EXPORT_SYMBOL_GPL(devm_pcs_register);
 
@@ -106,16 +146,20 @@ static struct phylink_pcs *pcs_find(const struct fwnode_handle *fwnode,
 
 	mutex_lock(&pcs_mutex);
 	list_for_each_entry(pcs, &pcs_devices, list) {
-		if (dev && pcs->dev == dev)
-			goto out;
-		if (fwnode && pcs->dev->fwnode == fwnode)
-			goto out;
+		mutex_lock(&pcs->lock);
+		if (!pcs->dead) {
+			if (dev && pcs->dev == dev)
+				goto out;
+			if (fwnode && pcs->dev->fwnode == fwnode)
+				goto out;
+		}
+		mutex_unlock(&pcs->lock);
 	}
 	pcs = NULL;
 
 out:
 	mutex_unlock(&pcs_mutex);
-	pr_devel("%s: looking for %pfwf or %s %s...%s found\n", __func__,
+	pr_debug("%s: looking for %pfwf or %s %s...%s found\n", __func__,
 		 fwnode, dev ? dev_driver_string(dev) : "(null)",
 		 dev ? dev_name(dev) : "(null)", pcs ? " not" : "");
 	return pcs;
@@ -132,10 +176,15 @@ static struct phylink_pcs *pcs_find(const struct fwnode_handle *fwnode,
  */
 static struct phylink_pcs *pcs_get_tail(struct phylink_pcs *pcs)
 {
+	bool got_module;
+
 	if (!pcs)
 		return ERR_PTR(-EPROBE_DEFER);
 
-	if (!try_module_get(pcs->ops->owner))
+	got_module = try_module_get(pcs->ops->owner);
+	pcs->refs += got_module;
+	mutex_unlock(&pcs->lock);
+	if (!got_module)
 		return ERR_PTR(-ENODEV);
 	get_device(pcs->dev);
 
@@ -222,5 +271,13 @@ void pcs_put(struct phylink_pcs *pcs)
 
 	put_device(pcs->dev);
 	module_put(pcs->ops->owner);
+	mutex_lock(&pcs->lock);
+	pcs_free(pcs);
 }
 EXPORT_SYMBOL_GPL(pcs_put);
+
+void *pcs_get_priv(struct phylink_pcs *pcs)
+{
+	return pcs->priv;
+}
+EXPORT_SYMBOL_GPL(pcs_get_priv);
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index c3e2c4a6fab6..f792f2a7cdf2 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -26,7 +26,6 @@
 #define IF_MODE_HALF_DUPLEX		BIT(4)
 
 struct lynx_pcs {
-	struct phylink_pcs pcs;
 	struct mdio_device *mdio;
 };
 
@@ -37,8 +36,7 @@ enum sgmii_speed {
 	SGMII_SPEED_2500	= 2,
 };
 
-#define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
-#define lynx_to_phylink_pcs(lynx) (&(lynx)->pcs)
+#define phylink_pcs_to_lynx(pl_pcs) pcs_get_priv(pl_pcs)
 
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
@@ -318,21 +316,23 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 static int lynx_pcs_probe(struct mdio_device *mdio)
 {
 	struct device *dev = &mdio->dev;
+	struct phylink_pcs *pcs;
 	struct lynx_pcs *lynx;
-	int ret;
+	struct pcs_init init;
 
 	lynx = devm_kzalloc(dev, sizeof(*lynx), GFP_KERNEL);
 	if (!lynx)
 		return -ENOMEM;
 
 	lynx->mdio = mdio;
-	lynx->pcs.dev = dev;
-	lynx->pcs.ops = &lynx_pcs_phylink_ops;
-	lynx->pcs.poll = true;
+	init.priv = lynx;
+	init.ops = &lynx_pcs_phylink_ops;
+	init.poll = true;
 
-	ret = devm_pcs_register(dev, &lynx->pcs);
-	if (ret)
-		return dev_err_probe(dev, ret, "could not register PCS\n");
+	pcs = devm_pcs_register(dev, &init);
+	if (IS_ERR(pcs))
+		return dev_err_probe(dev, PTR_ERR(pcs),
+				     "could not register PCS\n");
 	dev_info(dev, "probed\n");
 	return 0;
 }
diff --git a/include/linux/pcs.h b/include/linux/pcs.h
index 00e76594e03c..2605603149ec 100644
--- a/include/linux/pcs.h
+++ b/include/linux/pcs.h
@@ -6,12 +6,27 @@
 #ifndef _PCS_H
 #define _PCS_H
 
-struct phylink_pcs;
 struct fwnode;
+struct phylink_pcs;
+struct phylink_pcs_ops;
 
-int pcs_register(struct phylink_pcs *pcs);
+/**
+ * struct pcs_init - PCS initialization data
+ * @priv: the device's private data
+ * @ops: a pointer to the &struct phylink_pcs_ops structure
+ * @poll: poll the PCS for link changes
+ */
+struct pcs_init {
+	void *priv;
+	const struct phylink_pcs_ops *ops;
+	bool poll;
+};
+
+struct phylink_pcs *pcs_register(struct device *dev,
+				 struct pcs_init *init);
 void pcs_unregister(struct phylink_pcs *pcs);
-int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs);
+struct phylink_pcs *devm_pcs_register(struct device *dev,
+				      struct pcs_init *init);
 struct phylink_pcs *_pcs_get_by_fwnode(const struct fwnode_handle *fwnode,
 				       const char *id, bool optional);
 struct phylink_pcs *pcs_get_by_provider(const struct device *dev);
@@ -30,4 +45,6 @@ static inline struct phylink_pcs
 	return _pcs_get_by_fwnode(fwnode, id, true);
 }
 
+void *pcs_get_priv(struct phylink_pcs *pcs);
+
 #endif /* PCS_H */
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index a713e70108a1..864536d1b293 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -392,24 +392,7 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
 		 int speed, int duplex, bool tx_pause, bool rx_pause);
 #endif
 
-struct phylink_pcs_ops;
-
-/**
- * struct phylink_pcs - PHYLINK PCS instance
- * @dev: the device associated with this PCS
- * @ops: a pointer to the &struct phylink_pcs_ops structure
- * @list: internal list of PCS devices
- * @poll: poll the PCS for link changes
- *
- * This structure is designed to be embedded within the PCS private data,
- * and will be passed between phylink and the PCS.
- */
-struct phylink_pcs {
-	struct device *dev;
-	const struct phylink_pcs_ops *ops;
-	struct list_head list;
-	bool poll;
-};
+struct phylink_pcs;
 
 /**
  * struct phylink_pcs_ops - MAC PCS operations structure.
-- 
2.35.1.1320.gc452695387.dirty
