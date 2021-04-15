Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7889B3611A3
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhDOSDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbhDOSDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:03:12 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26876C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:02:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j5so23223859wrn.4
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NYIOGdLOaf4FVLHeWERAY9WfDOunEwso7/Lsl/mvqgI=;
        b=gss37SGJsIKUcFkQy1rQDwgyTbDFqoFpoUecECa6J5q+f8GNsHUTJA7d5jPdLhfyNQ
         MqS31hgWXSriv/4DQ/ZnBZcYFXm+ozJi710dz4pLzaH8Wn5EWv1gltc7vylbWQuRPUg1
         e3rk2xw61N94hyzRfCL79FpssWRgbrE8iI2jgvnSMpB1gu3T01WmmpHiww995IbghwQY
         Al2Yw3OE076e3/VqdPSEc9xsbcBT1WqAeqH6vVHIvv/P5LNYRg86q9hLdzF+jEWC3Xg5
         nrpyZn0i3oqEJfIy3z0m7PQc81UwGlcV1KvUPWJx8vfQfEIKwmvGoer8UQvjcbgVL0PB
         aU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NYIOGdLOaf4FVLHeWERAY9WfDOunEwso7/Lsl/mvqgI=;
        b=f/xjB7H73ZR29hxW1wp/e1iNNTUxm8kiMIdm/5E4Gr5mKsJHHrmUEEPBwZBeSZsY8r
         ryH7kvxsaoEWZJU7KEzZ9ASVIZch94EntKfolQq2iYkazAnRzsQZeHtrZerocNZg/v/u
         m5qNLJ8Mwg1ixq7vh84ccWJIXgTc/oO650CY4/dqHiwo7MBFJWZHAV/lXS9vYT+ZW/sz
         T2s/uJcsM8rnoKkHWcFa4YDw1Al5D2k/FIdB4/N25AB3I2aD9y8dUltQYl65ylL1V/Zk
         i2WIYxJNmHR3/rj9VDKMTMcjvSZ/2uMGMRiZrCKZGRXHhi2tWn3m24A+crzRPDB2sce+
         xa3w==
X-Gm-Message-State: AOAM5302u3yxX5ic8i1soKneQN4hP9sbVm18F3NnGB/OneLM2F43shLO
        5kHdxy7cf/zkaOC+BDq3thvGZZSH5AU=
X-Google-Smtp-Source: ABdhPJy+Sc0KZskCbRLLSaHbepI9sW87rH0vBKS1h0mqOtlfXaXmxPylllLDAaasSotgu0Z7mksa7w==
X-Received: by 2002:adf:f302:: with SMTP id i2mr4672049wro.423.1618509767961;
        Thu, 15 Apr 2021 11:02:47 -0700 (PDT)
Received: from [192.168.1.101] ([37.173.146.249])
        by smtp.gmail.com with ESMTPSA id m2sm3725989wmq.6.2021.04.15.11.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 11:02:47 -0700 (PDT)
Subject: Re: [PATCH v2] net: sched: tapr: remove WARN_ON() in
 taprio_get_start_time()
To:     Du Cheng <ducheng2@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        eric.dumazet@gmail.com,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
References: <20210415063914.66144-1-ducheng2@gmail.com>
 <20210415075953.83508-1-ducheng2@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a4b17cd6-6f00-f760-dbda-f83ff63cae22@gmail.com>
Date:   Thu, 15 Apr 2021 20:02:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415075953.83508-1-ducheng2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/21 9:59 AM, Du Cheng wrote:
> There is a reproducible sequence from the userland that will trigger a WARN_ON()
> condition in taprio_get_start_time, which causes kernel to panic if configured
> as "panic_on_warn". Remove this WARN_ON() to prevent kernel from crashing by
> userland-initiated syscalls.
> 
> Reported as bug on syzkaller:
> https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c
> 
> Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
> Signed-off-by: Du Cheng <ducheng2@gmail.com>
> ---
> Detailed explanation:
> 
> In net/sched/sched_taprio.c:999
> The condition WARN_ON(!cycle) will be triggered if cycle == 0. Value of cycle
> comes from sched->cycle_time, where sched is of type(struct sched_gate_list*).
> 
> sched->cycle_time is accumulated within `parse_taprio_schedule()` during
> `taprio_init()`, in the following 2 ways:
> 
> 1. from nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
> 2. (if zero) from parse_sched_list(..., tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], ...);
> 
> note: tb is a map parsed from netlink attributes provided via sendmsg() from the userland:
> 
> If both two attributes (TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
> TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST) contain 0 values or are missing, this will result
> in sched->cycle_time == 0 and hence trigger the WARN_ON(!cycle).
> 
> Reliable reproducable steps:
> 1. add net device team0 
> 2. add team_slave_0, team_slave_1
> 3. sendmsg(struct msghdr {
> 	.iov = struct nlmsghdr {
> 		.type = RTM_NEWQDISC,
> 	}
> 	struct tcmsg {
> 		.tcm_ifindex = ioctl(SIOCGIFINDEX, "team0"),
> 		.nlattr[] = {
> 			TCA_KIND: "taprio",
> 			TCA_OPTIONS: {
> 				.nlattr = {
> 					TCA_TAPRIO_ATTR_PRIOMAP: ...,
> 					TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST: {0},
> 					TCA_TAPRIO_ATTR_SCHED_CLICKID: 0,
> 				}
> 			}
> 		}
> 	}
> }
> 
> Callstack:
> 
> parse_taprio_schedule()
> taprio_change()
> taprio_init()
> qdisc_create()
> tc_modify_qdisc()
> rtnetlink_rcv_msg()
> ...
> sendmsg()
> 
> These steps are extracted from syzkaller reproducer:
> https://syzkaller.appspot.com/text?tag=ReproC&x=15727cf1900000
> 
>  net/sched/sch_taprio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8287894541e3..5f2ff0f15d5c 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -996,7 +996,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
>  	 * something went really wrong. In that case, we should warn about this
>  	 * inconsistent state and return error.
>  	 */
> -	if (WARN_ON(!cycle))
> +	if (!cycle)
>  		return -EFAULT;
>  
>  	/* Schedule the start time for the beginning of the next
> 


NACK

I already gave feedback in v1 why this fix is not correct.

