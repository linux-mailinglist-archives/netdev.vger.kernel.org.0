Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A596DBC43
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 19:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjDHREL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 13:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHREK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 13:04:10 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19FDC66B
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 10:04:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2s2NgTMgRZP6hldeFeuzHcxAxt8d4GRVV9GRDS+fdCcN866MDNeOQK/q/K/FS+Z7u2nJRaA0v/S+5VpwAWtP+BMZqB9m5iaj3xYeQaFEDOH/ogLxQlh0wbq3JMLOyeahfbuOSf5uGtW78yzEUUVFavaYeXFw+Qer8diL1ai9FqLxY03x/4FP8cwLMMQThuAeXPmUNPUEZo4aRSNkc6K4WjeeY3RW22sPelrbAjFSyjWo4PzsvhPvrnum7daYH4i7aEAdBTBUCMOHoT/G8jFkeeeOLAew4kBPjif2h3cn2hLuEiWC7GBrcOWzF4O+k6cEUL9r3DNx/A/OkjE7d4t4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAP7WPoh5SYgQsvJzxhbPPVeTIYxeq7+Vbil40tmJMI=;
 b=eh0eJgQuLsBkiZmYd2FB0juNwO2mmjcO12XpmMPVs60X8fGduEsGXp/M9bpTlMhsifeMxel5jPljIUyIlgD7GxlRK/eVa+1Kp+ae+UvCzYL6vjragcQT6tT3GyiAejWotFpNFicDwhNVUxdaJwhR3rUUnnEZrwGLRr0COu5+e5njS3K3kfgVId+eCu/EIx8Dl5A2gE56UPju3cisvXDihoqhDmqL49gwxQu6B5JdrUUZZCRn1BZMO6Ej8iQQs5zVEBk9qyZciA5Zbuma/pslt0wT0Acbay8/O9Rt1HThpo7hPEJJG0nq+y+cYS99vSfSHhaLR52/THy034N9AnvNLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAP7WPoh5SYgQsvJzxhbPPVeTIYxeq7+Vbil40tmJMI=;
 b=Tx5OnwH4mbNnM+1zI4m1ZoAkVea+12S0zcya07YXJ0BDjP1pwqvHmplFePu257xqFOin43fziDI8Q+cI8qiWXgtd5oUy4cjFYOmOT2Yh7JDuwif/U98rzdMIZJSd60bd/dQ6T68Gnbtfd25EjAa89jlUEcu5g87lUf64C7V3W7i2hbpy3Kl1ptRr+xBXa71bZumcUAt4lqtRMjpJot7JwsMoowqEofQPtRjeY2K1rMw+OpDmUmWYqC47YhS2sjb+Lf02gf0Tvm0tJZMsMtOeNqlQQEJL0yt4jyI6IeIsZxbbO9LJtz3TJK/1pIIQRY7bGM8zYLKnY+UzvaHFLtqz0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB7748.namprd12.prod.outlook.com (2603:10b6:8:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Sat, 8 Apr
 2023 17:04:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 17:04:06 +0000
Date:   Sat, 8 Apr 2023 20:03:59 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org, liuhangbin@gmail.com, eyal.birger@gmail.com,
        jtoppins@redhat.com
Subject: Re: [PATCH net-next v6] vxlan: try to send a packet normally if
 local bypass fails
Message-ID: <ZDGef5zrnoorhHEa@shredder>
References: <20230405050102.15612-1-vladimir@nikishkin.pw>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405050102.15612-1-vladimir@nikishkin.pw>
X-ClientProxiedBy: VI1PR09CA0071.eurprd09.prod.outlook.com
 (2603:10a6:802:29::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB7748:EE_
X-MS-Office365-Filtering-Correlation-Id: d9ccb4fe-1a38-4082-6758-08db385342b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eb3BYRhh7DCRyc2cyx4qCXhbUCcGlIHJdCYNnaC+3xGzDjFYx3E5yLxLDzdwC0adREvekttaB1uKagxzwnPl01nVWEd9PO98HvuwOW6q62NJxTwqQDeCv56sNN+TcdwHe36+oFmQVxvZ9XojuCR1VS7xR6Ju2dOoz6wq4IPJ85vmOxJuDpnAVi+734LKaFcEi2tJ4iu5Bq1f02NzTgWAcT1hqY6Hq3KR4+iaYcnO4CaUVCfAXw79ldMLPSKwmlSWYRl2nPaHNQVeZLYKwS7CpzWAJKyQQX2kH6zrw918YlCcF4ByP6jYue19Y7xuPXOuQLy1bWQoCz4osbfn0nIkb5ECNo1VPQlSEVWnv6y5wIO1oHyauPNGz4ULBQIxx6lTwLKJBx5Uet3ixAXJCQ3W1cuS+Ypejr05ERjEi7kR9c9oQqG2g6rUh9L7sTWM0Y6c4xSgb8NuMa3mPQ7kCv1SOM0XWoaHvDxhQp6Bcfv16UXMD4SWznAQop2W5iNtvtBj0BCvqjCIpVqdIZcDBEr+jhqaLvXr9qIZ3DtK0eHhedecNN8DIM3OLxWDDuVf559ISIIyGYwqKhIaEj6mcPmm2JWun4fkx6Z2ZINlXpM/TGo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(38100700002)(6666004)(26005)(9686003)(186003)(6512007)(6506007)(83380400001)(30864003)(2906002)(7416002)(5660300002)(8936002)(86362001)(478600001)(966005)(6486002)(66946007)(6916009)(4326008)(66556008)(66476007)(8676002)(41300700001)(316002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gcBe5P//3BxgjDGc5Klvzvi6sQXehH3oTsRJsnm7rQZFSP50qISnar3Hi+zI?=
 =?us-ascii?Q?VFEX5WYn9mFVZErWylSEHoa6iNlWRgDiSAoEQu7DB6b8QaTKLUGsLQlo2/ab?=
 =?us-ascii?Q?6nrIUsotwvYEO7gJZ+KS/4IevitcprJVgmR2oiogdoinPz0R89KiOITC26DY?=
 =?us-ascii?Q?SfDGQr4Hcb1pU988Yg19VSrGPk6pi4xxIXMOklJRHOMfaTsF5wSJwYdCPJ3t?=
 =?us-ascii?Q?M+nEYjeUuRfjOrZBOmldiOdNyv+BLLmj1TFFC7dqU5YObL7RY4aN65xyGrMY?=
 =?us-ascii?Q?CaNwreJPihVQ4WmToAeT1rgF/cYrrO/f8bHq6v9lYpcPTn7A0nuGU/qX6rjw?=
 =?us-ascii?Q?JbZEdHiySPvB8DdxVKO83QzhGOdsA90Pz/dI4EXlctkx53xw92aqITQFytcx?=
 =?us-ascii?Q?L4VeJ1Zov+2faEowCLW3Eq7VXfXfP+D297bWxjo6Di1MhRMQe47M0ZVvZGlo?=
 =?us-ascii?Q?MQu5+DOKPWxXPG9acJMpKnkMn1GzSKUdCbqefnm8ZPtT2jgIbi3haZ5nAR9w?=
 =?us-ascii?Q?yijCtNbWyLX7iZMtFfN6tHT4N37MIsktl/ZjK2IE2WfcSD24QP0cTXG//Pzp?=
 =?us-ascii?Q?z0jV+tg/PdkdhpgQKpPnTDi/37NVINv5z8n/OBsaRU2Xl6xAbdeqxeHbED0r?=
 =?us-ascii?Q?UJA07ICmQlKKiTZh+2l8BreR6VDLMW9AOMA/vrQcSSAzZxU3q/mrFRslTta9?=
 =?us-ascii?Q?1LWAR5eCXsV5JeKslb4ZMVEcakpWKz/Ke0fc97vzFyVkr5ZsKM9X59Uxdwkh?=
 =?us-ascii?Q?aYgDvOOubuSvTaDCyvMmLdwzBIYoJYWaZObcWi6hBtjo6ED38HDU5ovkx5cn?=
 =?us-ascii?Q?2h/Tb9U04bMe9Ru8xWfgrlwp7XVC4H6HYI0MRFgiJIDR0fKKnU4hjnDtphxE?=
 =?us-ascii?Q?e/K+CV90RkhRjdvpxyhE2P55LRSwCdj5QjT40BqOXA0cLKtZV9ybSzZzedvF?=
 =?us-ascii?Q?jAhiBszMRd1mC62BhwKAr1pClA3KnrYlQKPN21aymvBzCQKwlTw+MpMO61ig?=
 =?us-ascii?Q?dPPAd6sj4OLy5cacKFT9q0iIpOhMUVRLTU0tGU78mJJjhdB0cKNccyI5dgrQ?=
 =?us-ascii?Q?3LKsPT3IsOExyGT+lOMhkCLAYPFVrGtA1Lvg669eL4hSq1kBiCxuydX9nkdL?=
 =?us-ascii?Q?65LKCYepsU4S3722EV3msEqKJBUXtFCygkTlpZLa3YTcjkit9ORSrvZczpH4?=
 =?us-ascii?Q?/3YWaU5HQB2ZXyL2HN8+Hq/0xxGM4dZUY/4LzOXYMGqvhU4LtNGbGVm/Egxz?=
 =?us-ascii?Q?VB/YDGDI7eWA1Jng78vm4Xg50V/1DsNGxhNJTDSXO03QVq4fd1P+RQ2T7+H7?=
 =?us-ascii?Q?abmS8q5Gr2kE7+fTAVjVxnOBTTeWQKXZBiLlAcG5e7yBzVDV8cmQzBaAuROZ?=
 =?us-ascii?Q?6P+VtYJ7LU1MOm6Oaval/qCJBGGBlcYy0FQPL6stZeBgqfhexksBMFn06F+N?=
 =?us-ascii?Q?ZiVCug6Trsm2mBtswD05mtdPLxYxCGTjc3EKzGKoELJxHz7sFl5O6ws8EFWF?=
 =?us-ascii?Q?yKN2bymTgsSLqMfA5S8G9vtiOL2V6xN+vB6b/nWePz7tUZog5b75lIq65pws?=
 =?us-ascii?Q?O5dpc2Eoz68tj82Rc1k1LmzhAzOe4qt9CBw1fcLG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ccb4fe-1a38-4082-6758-08db385342b3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 17:04:05.9184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1Npvl4kKSeKgVqm3bp7YifM1GCpzZ1mCCdcLPGnw9BoGcNlY7wCbfl4TTGNu9yENfcy3jcbcRscSBT1oh/zjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7748
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I agree with Paolo's comments. Some more below.

On Wed, Apr 05, 2023 at 01:01:02PM +0800, Vladimir Nikishkin wrote:
> In vxlan_core, if an fdb entry is pointing to a local
> address with some port, the system tries to get the packet to
> deliver the packet to the vxlan directly, bypassing the network
> stack.
> 
> This patch makes it still try canonical delivery, if there is no
> linux kernel vxlan listening on this port. This will be useful
> for the cases when there is some userspace daemon expecting
> vxlan packets for post-processing, or some other implementation
> of vxlan.

Use "imperative mood" as described here:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

Something like this:

"
If a packet needs to be encapsulated towards a local destination IP and
a VXLAN device that matches the destination port and VNI exists, then
the packet will be injected into the Rx path as if it was received by
the target VXLAN device without undergoing encapsulation. If such a
device does not exist, the packet will be dropped.

There are scenarios where we do not want to drop such packets and
instead want to let them be encapsulated and locally received by a user
space program that post-processes these VXLAN packets.

To that end, add a new VXLAN device attribute that controls whether such
packets are dropped or not. When set ("localbypass") these packets are
dropped and when unset ("nolocalbypass") the packets are encapsulated
and locally delivered to the listening user space application. Default
to "localbypass" to maintain existing behavior.
"

Assuming you agree with this description, I think it reveals a bug. The
current implementation does not actually default to "localbypass":

 # ip link add name vxlan0 up type vxlan id 1000 local 192.0.2.1 dstport 4789
 # ip -d -j -p link show dev vxlan0 | jq '.[]["linkinfo"]["info_data"]["localbypass"]'
 false

Fixed by this hunk:

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index f9dfb179af58..9c8135fd7be5 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4023,6 +4023,9 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
                                    false, extack);
                if (err)
                        return err;
+       } else if (!changelink) {
+               /* default to local bypass on a new device */
+               conf->flags |= VXLAN_F_LOCALBYPASS;
        }
 
        if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {

> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>

Please add the selftest in a separate commit with its own description.

[...]

> @@ -3202,6 +3207,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
>  	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
>  	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
>  	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
> +	[IFLA_VXLAN_LOCALBYPASS]	= { .type = NLA_U8 },

I suggest NLA_POLICY_MAX(NLA_U8, 1) to make sure values other than 0 and
1 are rejected in the unlikely case that we will want to utilize them in
the future.

Also, it's a good time to enable strict validation for new VXLAN
attributes:

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 9c8135fd7be5..c37face0d021 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3177,6 +3177,7 @@ static void vxlan_raw_setup(struct net_device *dev)
 }
 
 static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
+       [IFLA_VXLAN_UNSPEC]     = { .strict_start_type = IFLA_VXLAN_LOCALBYPASS },
        [IFLA_VXLAN_ID]         = { .type = NLA_U32 },
        [IFLA_VXLAN_GROUP]      = { .len = sizeof_field(struct iphdr, daddr) },
        [IFLA_VXLAN_GROUP6]     = { .len = sizeof(struct in6_addr) },

>  };
>  
>  static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
> @@ -4011,6 +4017,14 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
>  			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
>  	}
>  
> +	if (data[IFLA_VXLAN_LOCALBYPASS]) {
> +		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_LOCALBYPASS,
> +				    VXLAN_F_LOCALBYPASS, changelink,
> +				    false, extack);

What is the idea behind forbidding changing this attribute? It's not
fundamental to the VXLAN device like "id" / "external" / "vnifilter". I
suggest enabling it unless you have a good reason not to. It is useful
for the selftest (see below).

> +		if (err)
> +			return err;
> +	}
> +
>  	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
>  		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
>  				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,

[...]

> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 8d679688efe0..0fc56be5e19f 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -827,6 +827,7 @@ enum {
>  	IFLA_VXLAN_TTL_INHERIT,
>  	IFLA_VXLAN_DF,
>  	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
> +	IFLA_VXLAN_LOCALBYPASS,
>  	__IFLA_VXLAN_MAX
>  };
>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index 39e659c83cfd..1253bd0aa90e 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -748,6 +748,8 @@ enum {
>  	IFLA_VXLAN_GPE,
>  	IFLA_VXLAN_TTL_INHERIT,
>  	IFLA_VXLAN_DF,
> +	IFLA_VXLAN_VNIFILTER,
> +	IFLA_VXLAN_LOCALBYPASS,

I wasn't aware of this file (looks like others weren't as well). Not
sure you actually need to touch it (git history shows that it is synced
by those who need it), but if you do, then make sure you also copy the
comment next to the vnifilter attribute.

>  	__IFLA_VXLAN_MAX
>  };
>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 1de34ec99290..7a9cfd0c92db 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -83,6 +83,7 @@ TEST_GEN_FILES += nat6to4.o
>  TEST_GEN_FILES += ip_local_port_range
>  TEST_GEN_FILES += bind_wildcard
>  TEST_PROGS += test_vxlan_mdb.sh
> +TEST_PROGS += test_vxlan_nolocalbypass.sh
>  
>  TEST_FILES := settings
>  
> diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> index 383ac6fc037d..09a5ef4bd42b 100755
> --- a/tools/testing/selftests/net/rtnetlink.sh
> +++ b/tools/testing/selftests/net/rtnetlink.sh
> @@ -505,6 +505,9 @@ kci_test_encap_vxlan()
>  	ip -netns "$testns" link set dev "$vxlan" type vxlan udpcsum 2>/dev/null
>  	check_fail $?
>  
> +	ip -netns "$testns" link set dev "$vxlan" type vxlan nolocalbypass 2>/dev/null
> +	check_fail $?
> +

This is going to fail if you are going to enable change link support
like I suggested above. I suggest removing this test and instead testing
changing this attribute in the dedicated test.

>  	ip -netns "$testns" link set dev "$vxlan" type vxlan udp6zerocsumtx 2>/dev/null
>  	check_fail $?
>  
> diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
> new file mode 100755
> index 000000000000..efa37af2da7b
> --- /dev/null
> +++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
> @@ -0,0 +1,102 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# This file is testing that the [no]localbypass option for a vxlan device is
> +# working. With the nolocalbypass option, packets to a local destination, which
> +# have no corresponding vxlan in the kernel, will be delivered to userspace, for
> +# any userspace process to process. In this test tcpdump plays the role of such a
> +# process. This is what the test 1 is checking.
> +# The test 2 checks that without the nolocalbypass (which is equivalent to the
> +# localbypass option), the packets do not reach userspace.
> +
> +EXIT_FAIL=1
> +ksft_skip=4
> +EXIT_SUCCESS=0
> +
> +if [ "$(id -u)" -ne 0 ];then
> +        echo "SKIP: Need root privileges"
> +        exit $ksft_skip;
> +fi
> +
> +if [ ! -x "$(command -v ip)" ]; then
> +        echo "SKIP: Could not run test without ip tool"
> +        exit $ksft_skip
> +fi
> +
> +if [ ! -x "$(command -v bridge)" ]; then
> +        echo "SKIP: Could not run test without bridge tool"
> +        exit $ksft_skip
> +fi
> +
> +if [ ! -x "$(command -v tcpdump)" ]; then
> +        echo "SKIP: Could not run test without tcpdump tool"
> +        exit $ksft_skip
> +fi
> +
> +if [ ! -x "$(command -v grep)" ]; then
> +        echo "SKIP: Could not run test without grep tool"
> +        exit $ksft_skip
> +fi
> +
> +ip link help vxlan 2>&1 | grep -q "localbypass"
> +if [ $? -ne 0 ]; then
> +   echo "SKIP: iproute2 bridge too old, missing VXLAN nolocalbypass support"

s/bridge/ip/

> +   exit $ksft_skip
> +fi
> +
> +
> +packetfile=/tmp/packets-"$(uuidgen)"
> +
> +# test 1: packets going to userspace
> +rm "$packetfile"
> +ip link del dev testvxlan0

Try using namespaces (like in test_vxlan_mdb.sh) to avoid interfering
with the existing user environment. Also, like test_vxlan_mdb.sh, please
use the general framework of log_test() and run_cmd(). I ran your test
and although it passed, it emitted a lot of error messages (unlike other
tests):

# ./test_vxlan_nolocalbypass.sh 
rm: cannot remove '/tmp/packets-d614f8e4-549e-461e-9500-65bfea4d827e': No such file or directory
Cannot find device "testvxlan0"
PING 172.16.100.2 (172.16.100.2) 56(84) bytes of data.
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on lo, link-type EN10MB (Ethernet), snapshot length 262144 bytes
From 172.16.100.1 icmp_seq=1 Destination Host Unreachable
From 172.16.100.1 icmp_seq=2 Destination Host Unreachable
From 172.16.100.1 icmp_seq=3 Destination Host Unreachable
From 172.16.100.1 icmp_seq=4 Destination Host Unreachable
8 packets captured
16 packets received by filter
0 packets dropped by kernel
Positive test passed
Cannot find device "testvxlan0"
PING 172.16.100.2 (172.16.100.2) 56(84) bytes of data.
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on lo, link-type EN10MB (Ethernet), snapshot length 262144 bytes
From 172.16.100.1 icmp_seq=1 Destination Host Unreachable
From 172.16.100.1 icmp_seq=2 Destination Host Unreachable
From 172.16.100.1 icmp_seq=3 Destination Host Unreachable
0 packets captured
0 packets received by filter
0 packets dropped by kernel
Negative test passed

> +ip link add testvxlan0 type vxlan  \
> +  id 100 \
> +  dstport 4789 \
> +  srcport 4789 4790 \
> +  nolearning noproxy \
> +  nolocalbypass
> +ip link set up dev testvxlan0
> +bridge fdb add 00:00:00:00:00:00 dev testvxlan0 dst 127.0.0.1 port 4792
> +ip address add 172.16.100.1/24 dev testvxlan0
> +tcpdump -i lo 'udp and port 4792' > "$packetfile" &
> +tcpdump_pid=$!
> +timeout 5 ping -c 5 172.16.100.2
> +kill "$tcpdump_pid"
> +ip link del dev testvxlan0

Instead of creating and deleting a VXLAN device. I suggest the
following:

1. Create a VXLAN device without setting the new option.

2. Test that by default packets do not reach the listening user space
application.

3. Set "nolocalbypass". This is possible if you enable change link
support like I suggested above.

4. Test that packets do reach the listening user space application.

5. Set "localbypass".

6. Test that packets do not reach the listening user space application.

Regarding the "listening user space application", you can try to use
socat. See commit 8826218215de ("selftests: fib_tests: Add test cases
for interaction with mangling") for reference.

I think it's better than using tcpdump on the loopback device because
you can actually test that packets are delivered to user space.

Thanks

> +
> +if grep -q "VXLAN" "$packetfile" ; then
> +  echo 'Positive test passed'
> +else
> +  echo 'Positive test failed'
> +  exit $EXIT_FAIL
> +fi
> +rm "$packetfile"
> +
> +# test 2: old behaviour preserved
> +ip link del dev testvxlan0
> +ip link add testvxlan0 type vxlan  \
> +  id 100 \
> +  dstport 4789 \
> +  srcport 4789 4790 \
> +  nolearning noproxy \
> +  localbypass
> +ip link set up dev testvxlan0
> +bridge fdb add 00:00:00:00:00:00 dev testvxlan0 dst 127.0.0.1 port 4792
> +ip address add 172.16.100.1/24 dev testvxlan0
> +tcpdump -i lo 'udp and port 4792' > "$packetfile" &
> +tcpdump_pid=$!
> +timeout 5 ping -c 5 172.16.100.2
> +kill "$tcpdump_pid"
> +ip link del dev testvxlan0
> +
> +if grep -q "VXLAN" "$packetfile" ; then
> +  echo 'Negative test failed'
> +  exit $EXIT_FAIL
> +else
> +  echo 'Negative test passed'
> +fi
> +rm "$packetfile"
> +
> +exit $EXIT_SUCCESS
> +
> -- 
> 2.35.7
> 
> --
> Fastmail.
> 
