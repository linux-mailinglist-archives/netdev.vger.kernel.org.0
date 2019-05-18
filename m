Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F034224DA
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbfERUbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:31:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34370 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfERUbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 16:31:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id j20so6581451qke.1
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 13:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UQCymVRsrbsXbEphuvWLI/HxZ8RwmUZLqk09p9l0dCE=;
        b=odTccsoVY9Bi3t6M88SD6n//ftBfNRbCMBtT5YNBKs8/PNfgGycndLeZ0eymt7lyJj
         T6SPaR9HYiA0dSN9oaH3jHsfaQIMQAuj+ykPElZjxmcorRU6xHlGakxJLjg4hf963P9/
         WywWCgtfXKFzPClcLt5Af0VPKo0vUMAiUi+jHy/eZ3vwWINR7juRX4Oq/krAYuWLb/c/
         g2x2EFz/k+yp4X0OLlZ2VG/XkL5SzFk5Y5CM/H9knkZso3+Jk2RlXq6eFo1CukjrBlZT
         tbnssBhTpPG8BxVh2QCgDw/SkDI3xiPmWrxXUbe3uTpak6fpqRnC7mwWUugpOuvRAEfG
         buCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UQCymVRsrbsXbEphuvWLI/HxZ8RwmUZLqk09p9l0dCE=;
        b=F1O/tQA/JEquqLErV0QlplmQifyiLVFC9iVx0wG26kevQPPMSakDVpvwjNsGfjueCs
         N0YYSmTjgThhhCVoPTDMkikHuukl1R/8rSgVeW87CLjsTPAOpYqHmKWvkziUCX9I3UIQ
         rxgwhtIreqX5tyfat5WlHK5Zw1RMYrIoIvcU5lF2yuMTikII15/KMn4zW2bMfBhpYMag
         R9sb5Oexop+dy7r+LdmYj/N5SzcC4eZ/FU3ClzGFDqxnGMxctxCxVQ+reA3PTbjrn1+H
         XD/Nr1JqGu8YZ+A+5CqszgrBKNO46rfJlk5Lt1W/YdHP9cqUkKKs6jNvOmQjDLShf9bt
         NYVg==
X-Gm-Message-State: APjAAAXWSNqE1d21vlfKbm5GRfJl5xJMP7MtIcB0ToEIfFNPP1JEt4EY
        8DYkXe+EWRBEr+5bHSdeLCb9Xw==
X-Google-Smtp-Source: APXvYqyMPqbn4WPBi7RsWA1LlfzxBYpDM/GQA/rsCkq7H3JhvHChlpYym1g2pAbGmBZ0CO6II8CV3w==
X-Received: by 2002:a37:c409:: with SMTP id d9mr11967225qki.125.1558211461058;
        Sat, 18 May 2019 13:31:01 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id x8sm7480632qtc.96.2019.05.18.13.30.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 13:31:00 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 1/3] flow_offload: copy tcfa_index into
 flow_action_entry
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
 <f2d3400a-1e39-1351-ce5a-a64fe76d2be3@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <aed6199c-54c5-4752-a1c8-b35561deed28@mojatatu.com>
Date:   Sat, 18 May 2019 16:30:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f2d3400a-1e39-1351-ce5a-a64fe76d2be3@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-15 3:42 p.m., Edward Cree wrote:
> Required for support of shared counters (and possibly other shared per-
>   action entities in future).
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>   include/net/flow_offload.h | 1 +
>   net/sched/cls_api.c        | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 6200900434e1..4ee0f68f2e8d 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -137,6 +137,7 @@ enum flow_action_mangle_base {
>   
>   struct flow_action_entry {
>   	enum flow_action_id		id;
> +	u32				action_index;
>   	union {
>   		u32			chain_index;	/* FLOW_ACTION_GOTO */
>   		struct net_device	*dev;		/* FLOW_ACTION_REDIRECT */
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d4699156974a..0d498c3815f5 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3195,6 +3195,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   		struct flow_action_entry *entry;
>   
>   		entry = &flow_action->entries[j];
> +		entry->action_index = act->tcfa_index;
>   		if (is_tcf_gact_ok(act)) {
>   			entry->id = FLOW_ACTION_ACCEPT;
>   		} else if (is_tcf_gact_shot(act)) {


LGTM.

cheers,
jamal

