Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34639864B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 12:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhFBKUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 06:20:54 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:50945
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232681AbhFBKUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 06:20:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfXWcRvQA3OlENcxmCGK493dbM5o0qbV5YqzbAoKpe8qLUngeK1tnqa2hYvZQCtstVk8LgHxRUwdL7bZPAXWH4Qmoo62BhyGvomI1AG8PSLxsVJumW7nZLKSMkM+b2Ppq7Hjkn+jjGPoXI20Vn7n5+yLTYYbll5aOALZk6dK0GFiov36p9SjhXbJQ896I6PvGoJpTsUWctvmkOjT6cgFmb34B2u1IlMRgn+wwq2zoAcyQ9Tbepud0RMPAYc0EZSPqau9ztX2Kk78xr/kbE/GqYewuSVBqkaV9BQdFvTDx9/ATXbBqndyaW8gD970LLRRHti/mr3Es/edUDZEpJHSxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1jiXLTNKHtsVJvTHJF+LOE8sRibU18KXM63yzjE8aM=;
 b=Pn7JCsidYcIXfxpd97lB2ilOe+kS2FFiXmqmlJAp6kvkqKRVm/a8fHC5a9lyc9PFEErKS0Hq/ddKPDbAIDMuW9dCrwFYVh5TA+H6Ag2hWr0cZm9G+PUVAhTqmowaml8guHlHkmH9h6UnlZrqNTZUcXPvLMjS/2fIDETYKBWcZeheir52bAVNM7pjX6RD50nn1mGwTNp4qSQ7/r3BZkZz+uA+XVbhGgO37NJohVrWbPCI2PS/iabIiCcNRsOgjWk/7vmFzWcajCJEJmqm84VXqlZE5/R5zgUV2N5AeTk9EKQAjyrnsSozvd8+b0U1m8ICKNzbJScYOsYvdyAaHYim1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1jiXLTNKHtsVJvTHJF+LOE8sRibU18KXM63yzjE8aM=;
 b=lQef+Mwajocc0zeMNO7Xif6rY5mgAKmlRC0ErMkJOyb1T2MWsDWuecIOaLTZWrzRDz+dCi2iJZCnSHps138CcHwteFAf3WzcCj7pFI1koN92PfOjb36nSDNwj2Yr+EOqOMQXbhEwtVSfmMM/Ij7Ijaj6Snvnopepa4XYY/UXjCQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from PA4PR04MB7934.eurprd04.prod.outlook.com (2603:10a6:102:ca::23)
 by PAXPR04MB8428.eurprd04.prod.outlook.com (2603:10a6:102:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 10:18:20 +0000
Received: from PA4PR04MB7934.eurprd04.prod.outlook.com
 ([fe80::1c99:498e:3e59:ea96]) by PA4PR04MB7934.eurprd04.prod.outlook.com
 ([fe80::1c99:498e:3e59:ea96%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 10:18:20 +0000
Subject: Re: [PATCH v1 net-next 3/3] net: stmmac: ptp: update tas basetime
 after ptp adjust
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     netdev@vger.kernel.org, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        tee.min.tan@intel.com, mohammad.athari.ismail@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        leoyang.li@nxp.com, vladimir.oltean@nxp.com,
        qiangqing.zhang@nxp.com, mingkai.hu@nxp.com, yangbo.lu@nxp.com,
        davem@davemloft.net, joabreu@synopsys.com, kuba@kernel.org,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        mcoquelin.stm32@gmail.com
References: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
 <20210601083813.1078-4-xiaoliang.yang_1@nxp.com>
From:   Rui Sousa <rui.sousa@nxp.com>
Message-ID: <5d81bf51-6355-6b52-4653-412f9ce0c83a@nxp.com>
Date:   Wed, 2 Jun 2021 12:18:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210601083813.1078-4-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [88.168.142.79]
X-ClientProxiedBy: AM8P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::31) To PA4PR04MB7934.eurprd04.prod.outlook.com
 (2603:10a6:102:ca::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.28] (88.168.142.79) by AM8P190CA0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Wed, 2 Jun 2021 10:18:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a443fcdf-a321-4f1b-57b4-08d925afbe95
X-MS-TrafficTypeDiagnostic: PAXPR04MB8428:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PAXPR04MB84289DDCB852B58577A10913E83D9@PAXPR04MB8428.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMtNHZf5SGhVU6Fq7tLKcd1Ay/8VNVOtZQHfGAh7RFR49Z/446zSN9FxxPU1cl/BEIfhTjTlRX+NMKKsp2wZajHGVULfj3q2gbwnTK6Avj1NNIMZmXM7u4F/KvQxon3jIm/bmQkp7k8SnQUvwoJr4639p39u9JHVzaZdq6+2VuTb7piOv9d+ds/n81z4fjFz2TABy9QX1e5cKGEsSNghNpXMGnMOGe5w3ZqAWX2+5dMoH95XTAgpBV8jlN7GIUCJUx8v86fYTCAIq5o0G4SmcxsGTByy+ANiN+7+Ooyo0kIAYo48AeK3M43kQjmP1og8ZZ1hzB4U2pR+BxL4py3WRurCv9CtcwETjpsmbrowH0Kbhtm+KdviXRdBhNZ7gR+ZrisIdNRr61HQyS4C5zSms+oCmy78q57gAXHT2/0dlFCPLqW0siUit6YtssOB4ZY4W0z4hTLaRtsubVYm3hWqYj06/z2huIlKVlgIJlX4YnVTdJMkGdF2XGGE9ANZ/pn2eAOX/Vd3KTajIGbQFDA27ClSIFieFfruDE4fH9LKj0wVdOgcjtrpwiDQ82uUY6qm+ceILTIkzWMWpXcGs5FqZ3ATFyJ/X2NYGUhNBxSvx9Kq+74AFBgCJG4D52Zivf5O03iRQcQGjPBELyF5s5z86nbOYaXtTMi20yqa+/WbUS/d3LbL5qONDxIPnZhxvxC6bT+kqKqtJUYRZgekndmtVJNu19u7mpCX5e46987mzzud3yXDy6f7eU/kYVK3cVtv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7934.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39830400003)(396003)(66476007)(66946007)(66556008)(6636002)(6486002)(83380400001)(44832011)(4326008)(2906002)(31696002)(15650500001)(8936002)(37006003)(38350700002)(38100700002)(16576012)(8676002)(956004)(6862004)(2616005)(34490700003)(53546011)(5660300002)(52116002)(508600001)(36756003)(26005)(31686004)(86362001)(6666004)(186003)(7416002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZFo3UkxKNWJWaDVTK1Z3T0lOdnFpZ1o4eURGbU1NcXh4TjZpM0x6Y2RBR3pD?=
 =?utf-8?B?RC9CMDBDOXF6Q2Y4Rk5vNUZseG1HUnkvQk1VMis1eGVFQjNWaElObVBkTklO?=
 =?utf-8?B?aVp6WGZvQkZBZTNpQ2R2N3dMZXBnNlRDL1lZdThHQlkvNy9sR2VEZ1p3MUlu?=
 =?utf-8?B?eXlwSEdhMWUwbHUzeThHOXYrMnYxWm5pUzcva3k0K3JPK2k4bzFlMEt0WmJk?=
 =?utf-8?B?UFUzYVh1OVVHYy9TSjdzSHdxNENiclQ1N0VEbVpPb2FrQlpQNjM4R0tiNGxC?=
 =?utf-8?B?WVZWN0dtc09EQzFmN0hQdER0V1poOEZyeUNPQUsrZEpJcGhzbU1SSFp2MFNQ?=
 =?utf-8?B?cmRoZFlNRWM1cmVCZ2NXaFUzUldXd3REQUswZ0ZBNEMwZTlMU1U0aEE2dTVI?=
 =?utf-8?B?OE1FQjRGbmphRXFMS3haclg3c2N1U0VTaS9VclJqWlB3MVFJSU12OG5aeU5E?=
 =?utf-8?B?NVNLa1hna3V1NVVXNmZYL2FEZ01OVmE4TFlrUGVxMXpkV0N1VnBVeXlsaHdD?=
 =?utf-8?B?cG4wV0luMU5GM2xub3EzN0NISW9TNlVDRVNoU0RCSHBoT3hZUVlHNlliL2sy?=
 =?utf-8?B?WEZMZnZpWG5CWXBSNERGM2tMaENpMEU0di8rT1JFYnp2TSsyNUkzaWlPd1Mr?=
 =?utf-8?B?bndodXAxNjNGYUZQWXM3aGxIWUZWTHZ1bCsvM1oyYWRtT2dlSHF3Mk5VZmhk?=
 =?utf-8?B?VERrTE4wdVVrVUhUajBXVlowSktVdU9nUGN2STlJTnN3VTB6YU4yQjBhNnlz?=
 =?utf-8?B?VWt6RVQzNTVwdUltWkhrNDduQkVvMGtLQ0V2bDNkUEpyai9DL0tnU0NBeHE5?=
 =?utf-8?B?M2FRWk9CWHZvSjZiVXJ3SGZvVHE5VmxCV0V6bEpXWWRrM1crMkxhc2JEaDNH?=
 =?utf-8?B?SkZqVGNPaEFPS1pTOVlMYmIvNkpwY05SNG9qT3Z4b0dyaHpQMWkrK1Irc2dk?=
 =?utf-8?B?R1VzOUNuNUZIcXBKUzI4UTBnTDJYYmZjZkdhMHI3U3ZvajZRZDZoUWl0dUU0?=
 =?utf-8?B?U24yQUJ3R3Jla2luTTNXZEZ2NjM5bmZNdXZsWS96ZnlsdUN6Wi9kUW5TRE9X?=
 =?utf-8?B?MVUwV0tCWjB6QkcvQ2RtZnd3N3QwVDVuMHFESXRvTHJ6ZXZPY0lQUnJHVWNz?=
 =?utf-8?B?SENGUDVjVjZ0NWVaTWFxUzFlRjJvV3hGcTNtMlpyTFJTaUxkWE5rbWJNUEl1?=
 =?utf-8?B?N2FhcElMQlJReXJRYS8wVGJnMjdMc1Z2WVR5SXJ3L1RmTy9TdXRCRHpkOHlC?=
 =?utf-8?B?TkhBTk5FWVdsUzRqYnZZZU1qcFNsNTlGc2xOYWNBbitRSFhCY0lqczZJdTlv?=
 =?utf-8?B?NFhzQkZnM3RqSGdKeENnWjNwVkNLVUs1cEc0bnp5WHJtMEZGTDhPOEUyZGpP?=
 =?utf-8?B?MXMvNUlKQ3JzeTJITEwxYTdKMTlTaUJtMEdURk14OXFSL20vTWhBYW9aWnN5?=
 =?utf-8?B?NEpPQS9wMzUvbXVlU0w0MUduQ2hxSXQxV21zYzVHT1JXeEtnbWFLRDBpRUFZ?=
 =?utf-8?B?SkV2WWwzeVUyekh6cXkva0dZVGJqVjh6YjE5UjFPb0prUWJQenliZDBzRlFr?=
 =?utf-8?B?MWRyeUVRcVhYbHZlSDUyWFhJby9vSTNmWUtPeWVnWjdiWHp0VjZ6dXNNcERC?=
 =?utf-8?B?citLOWNrcVFxOUxjUHY0YlFPWmg1S0EyWDRMdUpIRlR3dEpmU0JGSlMzVENR?=
 =?utf-8?B?TERZcSt3b1VBek9VY3prclJ4aGIvMFdTOWJ6UFVlRnB4N0s3bTJnamdFSEoy?=
 =?utf-8?Q?D2HZJlYkRjZCwK3sK7RZvl9RAexv91s6uc5/vl+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a443fcdf-a321-4f1b-57b4-08d925afbe95
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7934.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 10:18:20.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jh566gqLtuKIB8anPxqD3qgS2/9pKbjLVugMp2hAv4m0LyjoLpGGbThYic2Hnenaa9JQk3ASa0wXpyTcyqjR3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8428
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/2021 10:38 AM, Xiaoliang Yang wrote:

Hi Xiaoliang,

> After adjusting the ptp time, the Qbv base time may be the past time
> of the new current time. dwmac5 hardware limited the base time cannot
> be set as past time. This patch calculate the base time and reset the
> Qbv configuration after ptp time adjust.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
> .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 41 ++++++++++++++++++-
> 1 file changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c 
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> index 4e86cdf2bc9f..c573bc8b2595 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> @@ -62,7 +62,8 @@ static int stmmac_adjust_time(struct ptp_clock_info 
> *ptp, s64 delta)
>      u32 sec, nsec;
>      u32 quotient, reminder;
>      int neg_adj = 0;
> -    bool xmac;
> +    bool xmac, est_rst = false;
> +    int ret;
> 
>      xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
> 
> @@ -75,10 +76,48 @@ static int stmmac_adjust_time(struct ptp_clock_info 
> *ptp, s64 delta)
>      sec = quotient;
>      nsec = reminder;
> 
> +    /* If EST is enabled, disabled it before adjust ptp time. */
> +    if (priv->plat->est && priv->plat->est->enable) {
> +        est_rst = true;
> +        mutex_lock(&priv->plat->est->lock);
> +        priv->plat->est->enable = false;
> +        stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
> +                     priv->plat->clk_ptp_rate);
> +        mutex_unlock(&priv->plat->est->lock);
> +    }
> +
>      spin_lock_irqsave(&priv->ptp_lock, flags);
>      stmmac_adjust_systime(priv, priv->ptpaddr, sec, nsec, neg_adj, xmac);
>      spin_unlock_irqrestore(&priv->ptp_lock, flags);
> 
> +    /* Caculate new basetime and re-configured EST after PTP time 
> adjust. */
> +    if (est_rst) {
> +        struct timespec64 current_time, time;
> +        ktime_t current_time_ns, basetime;
> +        u64 cycle_time;
> +
> +        priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops, 
> &current_time);
> +        current_time_ns = timespec64_to_ktime(current_time);
> +        time.tv_nsec = priv->plat->est->btr[0];
> +        time.tv_sec = priv->plat->est->btr[1];

This time may no longer be what the user specified originally, it was 
adjusted based on the gptp time when the configuration was first made.
IMHO, if we want to respect the user configuration then we need to do 
the calculation here based on the original time.
Typically (using arbitrary units):
a) User configures basetime of 0, at gptp time 1000
b) btr is update to 1000, schedule starts
c) later, gptp time is updated to 500
d-1) with current patch, schedule will restart at 1000 (i.e remains 
disabled for 500)
d-2) with my suggestion, schedule will restart at 500 (which matches the 
user request, "start as soon as possible".

> +        basetime = timespec64_to_ktime(time);
> +        cycle_time = priv->plat->est->ctr[1] * NSEC_PER_SEC +
> +                 priv->plat->est->ctr[0];
> +        time = stmmac_calc_tas_basetime(basetime,
> +                        current_time_ns,
> +                        cycle_time);
> +
> +        mutex_lock(&priv->plat->est->lock);

Hmm... the locking needs to move up. Reading + writting btr/ctr should 
be atomic.

> +        priv->plat->est->btr[0] = (u32)time.tv_nsec;
> +        priv->plat->est->btr[1] = (u32)time.tv_sec;
> +        priv->plat->est->enable = true;
> +        ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
> +                       priv->plat->clk_ptp_rate);
> +        mutex_unlock(&priv->plat->est->lock);
> +        if (ret)
> +            netdev_err(priv->dev, "failed to configure EST\n");
> +    }
> +
>      return 0;
> }
> 

Br,
Rui Sousa
