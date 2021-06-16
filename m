Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754103AA22B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 19:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFPROV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 13:14:21 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:16257
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230083AbhFPROU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 13:14:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mn2MwcGKWko3olNzqYzRP1vzQWoTwgp8pqhFMMghsMIa5RhGP2gR0lw7ELs/qeE0j+r/esDpniR1udvg+4JL0aiBzrq9eLKs9bYmCUHTWW6g61TXpFxqrLy2YQi1wDpQAvJ0G+I4lp79Zq93ZeMdm23WPrjz6A8qqM0bM3t280frCFmUVUzrkHUxUmCOtU/xdXCIikVEj1YXxAwga8CZ7yzXWOKqaKn3/fWMBBA0+tqgp/vPw8m8bNzPdydiz48I0biyU3pDC9ZKfHvKHVF/x98HUIavCh0N49eWinLN+hTEp7zhQs6zCahXKo3itK7JV1Maqaj328NdwkRCxqLBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Admmg5eUVdaS0UI9zhs+Xap9sIVkCINJROFvudfIFp0=;
 b=nuLSskziK6Yd4vzI+Nnhasn/0Gx+9tOXaHQTNGFSlSEtZ1bhfhZjPJ2oc6+CygLrocf70pyPXK2MiGmQAs8V+zyvHDqBmW/ROsY2dzD7V46qlhD6wafhm8MgM6Eb4ywQE8yEVBICXkFoTymkQNOtBdJtkHshSqgvmELvJzRjQzMudovmtwc0CYg6VESUDhqjbBWqzsEQhfWYcck+Qw9AoAyaKyOBc+9rhHhgrfGhd1DRaw89pivTFAHAQ8tT4vy0NUb/e54V9TOv3ia1K0DDxK7ICLbx30b00UKEGp1oSGGYyh6x3IUyVnPbl6tF6Ohuis5BeNuM+EX+tgSnuXmUKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Admmg5eUVdaS0UI9zhs+Xap9sIVkCINJROFvudfIFp0=;
 b=OP3ko2H3eKdZkMYfMwymfNnVUQwqtMzJ4Lu7MLeN9ek07nfwrsOG3lg0ZsOID8BTxEui4FAYpblfmAfQ8rOGj8mPoNxIC5NUMTUEv4R5nhI8EC3F3Cwju0bbNW4axu4uB36YXsYFemBcj6ubJRXc78qZ/94eVHbUmDbs+ECLNio=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from PA4PR04MB7934.eurprd04.prod.outlook.com (2603:10a6:102:ca::23)
 by PAXPR04MB8143.eurprd04.prod.outlook.com (2603:10a6:102:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 16 Jun
 2021 17:12:10 +0000
Received: from PA4PR04MB7934.eurprd04.prod.outlook.com
 ([fe80::cd49:b79:2a9d:3b7c]) by PA4PR04MB7934.eurprd04.prod.outlook.com
 ([fe80::cd49:b79:2a9d:3b7c%6]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 17:12:10 +0000
Subject: Re: [PATCH v1 net-next 3/3] net: stmmac: ptp: update tas basetime
 after ptp adjust
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "vee.khee.wong@intel.com" <vee.khee.wong@intel.com>,
        "tee.min.tan@intel.com" <tee.min.tan@intel.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, "Y.b. Lu" <yangbo.lu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
References: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
 <20210601083813.1078-4-xiaoliang.yang_1@nxp.com>
 <5d81bf51-6355-6b52-4653-412f9ce0c83a@nxp.com>
 <DB8PR04MB5785F472AC4F8ED66B9E128CF0369@DB8PR04MB5785.eurprd04.prod.outlook.com>
From:   Rui Sousa <rui.sousa@nxp.com>
Message-ID: <358c70d1-f472-8eb1-c07c-823ba1074c60@nxp.com>
Date:   Wed, 16 Jun 2021 19:12:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <DB8PR04MB5785F472AC4F8ED66B9E128CF0369@DB8PR04MB5785.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [88.168.142.79]
X-ClientProxiedBy: AM3PR03CA0072.eurprd03.prod.outlook.com
 (2603:10a6:207:5::30) To PA4PR04MB7934.eurprd04.prod.outlook.com
 (2603:10a6:102:ca::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.28] (88.168.142.79) by AM3PR03CA0072.eurprd03.prod.outlook.com (2603:10a6:207:5::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 17:12:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71811e0c-7ec2-466f-fd28-08d930e9e071
X-MS-TrafficTypeDiagnostic: PAXPR04MB8143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PAXPR04MB814385ADAF6BA77D71313DEDE80F9@PAXPR04MB8143.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PIODT06EyOyd+jWMtjw6l506izYrThgybl6jV6uROo2hU1hUD4byyEcAKEhHuV8OVeC8wfJnTEHfM3+8elCRVdtqd+DI8Dq2ViuaezAi+1EPKl8s9rldLg4xzRmeCc5EvxG02Cq7smCXH9+RvzCnRMVJsBSPkQKSDwv97Rja1TtpWWaemjIGyJxRFRzjW5fcLGFwYq9qucRbW67sLZjcNYMXfaCXXRlDBJqNlXfLamxeGc15rXfYxlDM0ZqNJqBRZ6Cy1ciKdMfwgzLk05bu5B3HEDh3R7g9AfRduWPYPJDgMOz8ee3RhkZDm1bk8EdZ+faf5nYjZlJI21fBexZOXBmwojJpwhjTVQQlIrtndoF0OPHKfnJb77Rq8dNNdRPy3c4MAn2UP0UH8uPgex/uqTIajjCvkHGlfUBo3QS3dbVgJDDiG9nc+hNmHLkFJsxDQGJL7AokfvdG9wYHzH8IEiLtwV9qNNghprxnMh8KjjgqUohgbQ9bgoM+u5L7INzw0vxAr3ccOfOqc3o39dL7iYB3xIKMgP0QuZTRP/kET28EnMfvizs2VhKf09j1yCRg4nzi9ejR7Fo7+sEhnWzIYdET5eHbIpGaA0ALhGuJnqhmz+tPsclwI7lTSK7IPHhVKcoDg4lm0KTLqKyZ8lbKxfOspRkVkiA0mSZlm2tZUm9zLG7HgeucM4SmjtYYaCAUsecxtTH9VHp/B9UAup/KPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7934.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(5660300002)(15650500001)(66946007)(4326008)(6862004)(16576012)(6486002)(37006003)(2616005)(7416002)(66476007)(956004)(83380400001)(52116002)(498600001)(38100700002)(86362001)(54906003)(53546011)(38350700002)(66556008)(8676002)(44832011)(6636002)(2906002)(31696002)(31686004)(186003)(26005)(8936002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2N4ZFBJK3lMQWQreFRRcFNONTJ2cjFnK1ZQSENyVUd0bHF5cm84SUdmd0M0?=
 =?utf-8?B?dTUxT1ltUEE0RmlKVUhSR0liL3V6NHhqL3RrT1cvUHRVcDdQK2xrOFZZeDdv?=
 =?utf-8?B?bVQ4YkF0OGNLcW8zRVAxSnJiTHdBZ1RvUG5qWXNOUGxzTWpmL2FhNkcvZ3Rq?=
 =?utf-8?B?ZUVsSnp5d3dpem9IK1luL3oyUyt4cEFFcUlNWStUTS9XdjF6M2JyZkttUnMr?=
 =?utf-8?B?cFgyRVVBalF3eE56VmRSTEk2cURIVGFGZEkzN0ZnTkVpRjV4a1kxVjg3WVVq?=
 =?utf-8?B?NXEySFRQK0hIZ0tOWWtSV2EvdHBsSW02TVdKdUVGK1Y5OWVOTWJBQkM2WGZT?=
 =?utf-8?B?a3BRSUhwL28vUkY2MkRDL3lVNE40aTNENGdtWnVSVUdxbmRjelBVNVg0b1V5?=
 =?utf-8?B?aXFBbGI0MTZPeGI1UXU3dllpemVUMyt1Z0FIZDVrd29ubHRYZllOclJTN0hy?=
 =?utf-8?B?WXhnK3BqcXcrKzcrYlFqa2d5TmQreFVjRFBYaG1VN1MrR0JPdHgvTXZJYjRn?=
 =?utf-8?B?T2dFRGd6alYxUlRYUTBHL29tN1NpeWJEWGhneVl1MTljTUxVWUVza0lmWWZZ?=
 =?utf-8?B?QWEyMGlSdnBKSzQ3aWhnaFBsbFFrUGRkck5wZmZETVhPQWRRb1VDaEQvZWVa?=
 =?utf-8?B?RWhpb2tzemYzaU1wTDRhZjNUdThZRVVKRG1OUUZZclhwWlJmN2JLYklXak5Z?=
 =?utf-8?B?dWtvZ3g2d2h5bmEzUGFYU29EMGZTT0ZwZUZIMEk3VS9heGowcyszbVV5NnpR?=
 =?utf-8?B?bnViYzZQWG9hRkRxa1VFdDhsS0NIS0JQWUo0MjRGaGMzakNHaVFWSklLVVp6?=
 =?utf-8?B?VTJDMkVIdEplRm95RHY5WlZ0Q0dhUFFNdTBiMDhMcVh3RzNDMHFtRHVFRjd4?=
 =?utf-8?B?NVR5TlhDbUxIQ3hQcDNHeHA1NUxrTVJpVEplalNxaUZyakZWZUhVWDJiRXJ4?=
 =?utf-8?B?SVJFODRrWDEvQW9aR2tNVUoyNDVnWi8rYmpGQlNCRmR1ek0xMytsUTNjRUJZ?=
 =?utf-8?B?YWYwZGdlaEVEYU5wV3ZaQy9XS0YrOHV5S0ZvVnlZUklJdWpjMEQxUHhMaGZ5?=
 =?utf-8?B?VXlYRWVNS2FhOGFWSExqcEtZUWFtWjhYa0t4MFJqR3VxOURFQmsyeitWaGl3?=
 =?utf-8?B?cXYveGhNdGVIZlJTa3lKcmZOdVNOMUVlS3hiak11TGRtYi9OZGZZSGlienBp?=
 =?utf-8?B?MzBtRExBb242TFRQQkJtbVV2QmZUOG5FK2dpNTBRRS85QjY4WUppT3J1cVVQ?=
 =?utf-8?B?aitYaXFBTTJldDFuM1lJbDFXY3dFd01USHNBcUM2aC9qR1ZDdHplbHR5TURo?=
 =?utf-8?B?MFZjZkRObWw0SDdJR1hHTWx3amQzSUlTWldBQ2NMYU1FcmtjbWRJVHdRbmdO?=
 =?utf-8?B?R0taeDVXajNTSzBVSzVEYjQxbGR4aWhLWjNBRjVXbmlRa1pBOU1PWkZPV0NW?=
 =?utf-8?B?VHNBb0JPUXQ5QUJOcUdBN2FFdjUvbCtTVGFZM3N0UVpOeTQrbldXRzgwbzRl?=
 =?utf-8?B?RUhNcnhYcTUwNkhNM2pFVjJESkQrYVZTeURyeFhOR2JCRlFVa3hkRHBOYXJS?=
 =?utf-8?B?OTg5d3FoMnNVbWZQQk0yc2tncFFDdU1GbFhyUGg5d3Q5bXhUZmR5QVJSb1ph?=
 =?utf-8?B?dnRUZm5VVmtpbFp3bVVYY2pjQWZHT1VsYTVSbXBOREdVOGZyM0dOUkJjZFB2?=
 =?utf-8?B?UlpvVHJXS1dFVlFEMU5MelhGeUZNUk1ka0kvNURJcVBwaDJYc2V2OUR4QzVW?=
 =?utf-8?Q?rO66lN3gpMi8n2kaKjjUdAiX/c5/25uN2B3e4fE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71811e0c-7ec2-466f-fd28-08d930e9e071
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7934.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 17:12:10.3115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h29e9UPsnIBdjcid9Yp/Gaf+/VyHktZC4tX7jMHuqGUpZJ8sQHSPHGpoFUsXlwQT9qX9hmJJx+aE29jcVP1B7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/2021 11:03 AM, Xiaoliang Yang wrote:
> Hi Rui,
>

Hi,

> On 2021-06-02 18:18, Rui Sousa wrote:
>>> After adjusting the ptp time, the Qbv base time may be the past time
>>> of the new current time. dwmac5 hardware limited the base time cannot
>>> be set as past time. This patch calculate the base time and reset the
>>> Qbv configuration after ptp time adjust.
>>>
>>> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
>>> ---
>>> .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 41
>> ++++++++++++++++++-
>>> 1 file changed, 40 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
>>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
>>> index 4e86cdf2bc9f..c573bc8b2595 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
>>> @@ -62,7 +62,8 @@ static int stmmac_adjust_time(struct ptp_clock_info
>>> *ptp, s64 delta)
>>>       u32 sec, nsec;
>>>       u32 quotient, reminder;
>>>       int neg_adj = 0;
>>> -    bool xmac;
>>> +    bool xmac, est_rst = false;
>>> +    int ret;
>>>
>>>       xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
>>>
>>> @@ -75,10 +76,48 @@ static int stmmac_adjust_time(struct
>>> ptp_clock_info *ptp, s64 delta)
>>>       sec = quotient;
>>>       nsec = reminder;
>>>
>>> +    /* If EST is enabled, disabled it before adjust ptp time. */
>>> +    if (priv->plat->est && priv->plat->est->enable) {
>>> +        est_rst = true;
>>> +        mutex_lock(&priv->plat->est->lock);
>>> +        priv->plat->est->enable = false;
>>> +        stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
>>> +                     priv->plat->clk_ptp_rate);
>>> +        mutex_unlock(&priv->plat->est->lock);
>>> +    }
>>> +
>>>       spin_lock_irqsave(&priv->ptp_lock, flags);
>>>       stmmac_adjust_systime(priv, priv->ptpaddr, sec, nsec, neg_adj,
>>> xmac);
>>>       spin_unlock_irqrestore(&priv->ptp_lock, flags);
>>>
>>> +    /* Caculate new basetime and re-configured EST after PTP time
>>> adjust. */
>>> +    if (est_rst) {
>>> +        struct timespec64 current_time, time;
>>> +        ktime_t current_time_ns, basetime;
>>> +        u64 cycle_time;
>>> +
>>> +        priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops,
>>> &current_time);
>>> +        current_time_ns = timespec64_to_ktime(current_time);
>>> +        time.tv_nsec = priv->plat->est->btr[0];
>>> +        time.tv_sec = priv->plat->est->btr[1];
>>
>> This time may no longer be what the user specified originally, it was adjusted
>> based on the gptp time when the configuration was first made.
>> IMHO, if we want to respect the user configuration then we need to do the
>> calculation here based on the original time.
>> Typically (using arbitrary units):
>> a) User configures basetime of 0, at gptp time 1000
>> b) btr is update to 1000, schedule starts
>> c) later, gptp time is updated to 500
>> d-1) with current patch, schedule will restart at 1000 (i.e remains disabled for
>> 500)
>> d-2) with my suggestion, schedule will restart at 500 (which matches the user
>> request, "start as soon as possible".
>>
> It is not the correct operation sequence for the user to configure Qbv before ptp clock synchronization.

The way I see it, a ptp clock discontinuity may happen at any time 
(change of grand master, grand master discontinuity, ...) outside of the 
user control. So having the driver handle all corner cases looked like a 
good solution to me.

> After adjusting the ptp clock time, it is no longer possible to determine whether the previously set basetime is what the user wants.

I may be assuming too much, but usually a Qbv schedule is determined by 
some central identity based on an absolute time (not related to the 
current time in the endpoint). So with this assumption I was considering 
the time specified by the user as "correct", independently of the 
current local ptp time.

> I think our driver only needs to ensure that the set basetime meets the hardware regulations, and the hardware can work normally. So I only updated the past basetime.

Understood, but from the point of view of the user I think the case you 
are already handling and the one I mentioned are very similar. Qbv 
schedule doesn't work as intended after the clock jump. Also, my 
suggestion simplifies a bit the code (no conversion from hardware to 
ktime), at the cost of adding extra data (software backup of the 
original user ktime).

> I am not sure if it is appropriate to reset EST configure in the PTP driver,

I'm not 100% sure either and I was hoping to see other people comments 
(and I haven't checked yet how other drivers are handling this).
That said, to handle this properly in userspace, IMHO you would need:
- some process monitoring the ptp clock and detecting jumps
- the process would need to be aware of the current Qbv schedule
- when a jump is detected, re-do the Qbv configuration

Overall, handling the issue transparently in the driver, seems like a 
better solution.

> but this case will cause the hardware to not work.
> 
>>> +        basetime = timespec64_to_ktime(time);
>>> +        cycle_time = priv->plat->est->ctr[1] * NSEC_PER_SEC +
>>> +                 priv->plat->est->ctr[0];
>>> +        time = stmmac_calc_tas_basetime(basetime,
>>> +                        current_time_ns,
>>> +                        cycle_time);
>>> +
>>> +        mutex_lock(&priv->plat->est->lock);
>>
>> Hmm... the locking needs to move up. Reading + writting btr/ctr should be
>> atomic.
> I will modify this.
>>
>>> +        priv->plat->est->btr[0] = (u32)time.tv_nsec;
>>> +        priv->plat->est->btr[1] = (u32)time.tv_sec;
>>> +        priv->plat->est->enable = true;
>>> +        ret = stmmac_est_configure(priv, priv->ioaddr,
>>> +priv->plat->est,
>>> +                       priv->plat->clk_ptp_rate);
>>> +        mutex_unlock(&priv->plat->est->lock);
>>> +        if (ret)
>>> +            netdev_err(priv->dev, "failed to configure EST\n");
>>> +    }
>>> +
>>>       return 0;
>>> }
> 
> Thanks,
> xiaoliang
> 

Br,
Rui
