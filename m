Return-Path: <netdev+bounces-7604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 722CD720CFD
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 03:29:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFDD21C2127D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 01:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554DC17E1;
	Sat,  3 Jun 2023 01:29:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49288816
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 01:29:00 +0000 (UTC)
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47BD18D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:28:58 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6b13e2af122so740505a34.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 18:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685755738; x=1688347738;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8L1A67+T5PSxz1zMkFnJ4yneIMrWRpk2sulMTsaGC1Q=;
        b=Ln56BhnKOK5GARtByD2d1mcCIKKWMSn16dLMcEYY8/0HGne3B2iICESfhEbcPedMui
         WVUFQ1S0Ai8hdqAdYfRLY+oYZtidKroaJaNkjPcrQBZbczkwxlnxfRZ9eVbSyOARfaUl
         cs5nxm5WafThoMT0gqTmE5xlggOUHaYwHcZ2D0GJjGeYvmnlOm6UhakTREKONPQUP8TF
         ml2K39UlabmuTSX3iIjOnHF6p7DftyFuOTllR5ouvK+Eq7BghjwVR4K9hi6ILj23k0Mt
         zG4ITJToiA9ZOojTnNV7rsj7kYPVTpW6F9/nzAYSiBmSoZurqAP/mDlYiXVz1zvGl5hi
         oi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685755738; x=1688347738;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8L1A67+T5PSxz1zMkFnJ4yneIMrWRpk2sulMTsaGC1Q=;
        b=Vq83awFw8dUK+sUIfEB4PoRk+oIO8x2lX2jznvj++0TGZedMtszKV9aH9/4sq6afrn
         WhmxnsImNmzyeJuEbZgg5KdI7c+qr+Om03oOLFcIBzN6qC7HZHXTeaRDvamRlAIpegSy
         9Uj7rbHcszTcwtxkv1GEB3in+vqS9QbptZke4bkmIeEQvcvKrXi4lEStBfIBwRVQQ0PK
         WWkTi4LdQ7I1e768bF2x61ySS7U4rrlqmuYZh2+F8BD4LDy68QvnETXUgJltEj9AgKYS
         DcZRa380XE8+F+YMAIZfDvx4SdUgtdmuRKgvT3eUE8e0pw+QaDs2GD7hon8Y7Tpx1E5P
         j//w==
X-Gm-Message-State: AC+VfDzBXV84MzlQcYuo2OS9/rR9UqQCY6UMuNprxOOZmxWMaIa8MKhK
	Vo67grTbVvLiRmHoNG6crADlZQ==
X-Google-Smtp-Source: ACHHUZ6L1yQL/3drAudtdwmk+bZxxFF6QCcyRVZyd8sR2ueomtKu1mqgr/ZbOpPLWrv7gjtJBhy/5w==
X-Received: by 2002:a9d:64c7:0:b0:6af:9d30:4ba8 with SMTP id n7-20020a9d64c7000000b006af9d304ba8mr2979323otl.26.1685755738131;
        Fri, 02 Jun 2023 18:28:58 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:643c:5e1a:4c7c:c5cd? ([2804:14d:5c5e:44fb:643c:5e1a:4c7c:c5cd])
        by smtp.gmail.com with ESMTPSA id l17-20020a9d7a91000000b006af7580c84csm1170169otn.60.2023.06.02.18.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 18:28:57 -0700 (PDT)
Message-ID: <e43314cc-8298-e07b-3086-54e4ea298136@mojatatu.com>
Date: Fri, 2 Jun 2023 22:28:53 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH net-next] net/sched: introduce pretty printers for
 Qdiscs
Content-Language: en-US
To: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
References: <20230602162935.2380811-1-vladimir.oltean@nxp.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230602162935.2380811-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 02/06/2023 13:29, Vladimir Oltean wrote:
> Sometimes when debugging Qdiscs it may be confusing to know exactly what
> you're looking at, especially since they're hierarchical. Pretty printing
> the handle, parent handle and netdev is a bit cumbersome, so this patch
> proposes a set of wrappers around __qdisc_printk() which are heavily
> inspired from __net_printk().

Probably worth mentioning drgn 
(https://drgn.readthedocs.io/en/latest/user_guide.html)
I've picked it up recently after Peilin mentioned it and it's quite helpful.

> 
> It is assumed that these printers will be more useful for untalented
> kernel hackers such as myself rather than to the overall quality of the
> code, since Qdiscs rarely print stuff to the kernel log by design (and
> where they do, maybe that should be reconsidered in the first place).
> 
> A single demo conversion has been made, there is room for more if the
> idea is appreciated.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   include/net/sch_debug.h | 45 +++++++++++++++++++++
>   net/sched/Makefile      |  2 +-
>   net/sched/sch_api.c     |  4 +-
>   net/sched/sch_debug.c   | 86 +++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 134 insertions(+), 3 deletions(-)
>   create mode 100644 include/net/sch_debug.h
>   create mode 100644 net/sched/sch_debug.c
> 
> diff --git a/include/net/sch_debug.h b/include/net/sch_debug.h
> new file mode 100644
> index 000000000000..032de4710671
> --- /dev/null
> +++ b/include/net/sch_debug.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NET_SCHED_DEBUG_H
> +#define __NET_SCHED_DEBUG_H
> +
> +#include <linux/bug.h>
> +#include <linux/kern_levels.h>
> +
> +struct Qdisc;
> +
> +__printf(3, 4) __cold
> +void qdisc_printk(const char *level, const struct Qdisc *sch,
> +		  const char *format, ...);
> +__printf(2, 3) __cold
> +void qdisc_emerg(const struct Qdisc *sch, const char *format, ...);
> +__printf(2, 3) __cold
> +void qdisc_alert(const struct Qdisc *sch, const char *format, ...);
> +__printf(2, 3) __cold
> +void qdisc_crit(const struct Qdisc *sch, const char *format, ...);
> +__printf(2, 3) __cold
> +void qdisc_err(const struct Qdisc *sch, const char *format, ...);
> +__printf(2, 3) __cold
> +void qdisc_warn(const struct Qdisc *sch, const char *format, ...);
> +__printf(2, 3) __cold
> +void qdisc_notice(const struct Qdisc *sch, const char *format, ...);
> +__printf(2, 3) __cold
> +void qdisc_info(const struct Qdisc *sch, const char *format, ...);
> +
> +#if defined(CONFIG_DYNAMIC_DEBUG) || \
> +	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
> +#define qdisc_dbg(__sch, format, args...)			\
> +do {								\
> +	dynamic_qdisc_dbg(__sch, format, ##args);		\
> +} while (0)
> +#elif defined(DEBUG)
> +#define qdisc_dbg(__sch, format, args...)			\
> +	qdisc_printk(KERN_DEBUG, __sch, format, ##args)
> +#else
> +#define qdisc_dbg(__sch, format, args...)			\
> +({								\
> +	if (0)							\
> +		qdisc_printk(KERN_DEBUG, __sch, format, ##args); \
> +})
> +#endif
> +
> +#endif
> diff --git a/net/sched/Makefile b/net/sched/Makefile
> index b5fd49641d91..ab13bf7db283 100644
> --- a/net/sched/Makefile
> +++ b/net/sched/Makefile
> @@ -6,7 +6,7 @@
>   obj-y	:= sch_generic.o sch_mq.o
>   
>   obj-$(CONFIG_INET)		+= sch_frag.o
> -obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o
> +obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o sch_debug.o
>   obj-$(CONFIG_NET_CLS)		+= cls_api.o
>   obj-$(CONFIG_NET_CLS_ACT)	+= act_api.o
>   obj-$(CONFIG_NET_ACT_POLICE)	+= act_police.o
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index fdb8f429333d..a6bfe2e40f89 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -31,6 +31,7 @@
>   #include <net/netlink.h>
>   #include <net/pkt_sched.h>
>   #include <net/pkt_cls.h>
> +#include <net/sch_debug.h>
>   #include <net/tc_wrapper.h>
>   
>   #include <trace/events/qdisc.h>
> @@ -597,8 +598,7 @@ EXPORT_SYMBOL(__qdisc_calculate_pkt_len);
>   void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
>   {
>   	if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
> -		pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
> -			txt, qdisc->ops->id, qdisc->handle >> 16);
> +		qdisc_warn(qdisc, "%s: qdisc is non-work-conserving?\n", txt);

Looks much better

>   		qdisc->flags |= TCQ_F_WARN_NONWC;
>   	}
>   }
> diff --git a/net/sched/sch_debug.c b/net/sched/sch_debug.c
> new file mode 100644
> index 000000000000..1f47dac88c6e
> --- /dev/null
> +++ b/net/sched/sch_debug.c
> @@ -0,0 +1,86 @@ > +#include <linux/pkt_sched.h>
> +#include <net/sch_generic.h>
> +#include <net/sch_debug.h>
> +
> +static void qdisc_handle_str(u32 handle, char *str)
> +{
> +	if (handle == TC_H_ROOT) {
> +		sprintf(str, "root");
> +		return;
> +	} else if (handle == TC_H_INGRESS) {
> +		sprintf(str, "ingress");
> +		return;
> +	} else {
> +		sprintf(str, "%x:%x", TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
> +		return;
> +	}

nit: Did you consider a switch?

> +}
> +
> +static void __qdisc_printk(const char *level, const struct Qdisc *sch,
> +			   struct va_format *vaf)
> +{
> +	struct net_device *dev = qdisc_dev(sch);
> +	char handle_str[10], parent_str[10];
> +
> +	qdisc_handle_str(sch->handle, handle_str);
> +	qdisc_handle_str(sch->parent, parent_str);
> +
> +	if (dev && dev->dev.parent) {
> +		dev_printk_emit(level[1] - '0',
> +				dev->dev.parent,
> +				"%s %s %s%s %s %s parent %s: %pV",
> +				dev_driver_string(dev->dev.parent),
> +				dev_name(dev->dev.parent),
> +				netdev_name(dev), netdev_reg_state(dev),
> +				sch->ops->id, handle_str, parent_str, vaf);
> +	} else if (dev) {
> +		printk("%s%s%s %s %s parent %s: %pV",
> +		       level, netdev_name(dev), netdev_reg_state(dev),
> +		       sch->ops->id, handle_str, parent_str, vaf);
> +	} else {
> +		printk("%s(NULL net_device) %s %s parent %s: %pV", level,
> +		       sch->ops->id, handle_str, parent_str, vaf);
> +	}
> +}
> +
> +void qdisc_printk(const char *level, const struct Qdisc *sch,
> +		  const char *format, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, format);
> +
> +	vaf.fmt = format;
> +	vaf.va = &args;
> +
> +	__qdisc_printk(level, sch, &vaf);
> +
> +	va_end(args);
> +}
> +EXPORT_SYMBOL(qdisc_printk);
> +
> +#define define_qdisc_printk_level(func, level)			\
> +void func(const struct Qdisc *sch, const char *fmt, ...)	\
> +{								\
> +	struct va_format vaf;					\
> +	va_list args;						\
> +								\
> +	va_start(args, fmt);					\
> +								\
> +	vaf.fmt = fmt;						\
> +	vaf.va = &args;						\
> +								\
> +	__qdisc_printk(level, sch, &vaf);			\
> +								\
> +	va_end(args);						\
> +}								\
> +EXPORT_SYMBOL(func);
> +
> +define_qdisc_printk_level(qdisc_emerg, KERN_EMERG);
> +define_qdisc_printk_level(qdisc_alert, KERN_ALERT);
> +define_qdisc_printk_level(qdisc_crit, KERN_CRIT);
> +define_qdisc_printk_level(qdisc_err, KERN_ERR);
> +define_qdisc_printk_level(qdisc_warn, KERN_WARNING);
> +define_qdisc_printk_level(qdisc_notice, KERN_NOTICE);
> +define_qdisc_printk_level(qdisc_info, KERN_INFO);


