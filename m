Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0083E4E4F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbhHIVRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhHIVRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:17:23 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09A1C0613D3;
        Mon,  9 Aug 2021 14:17:01 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id b6so20487450lff.10;
        Mon, 09 Aug 2021 14:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=smCsqTDmNnGCUYf6Byk9+DYcLO+iqLY9JquhcCT1RGU=;
        b=pfy/TZlwEOu7c/vg/NzUkVyfo3nk0koFXSP2MHuAyPUps5hvlwRDuWcZZ5KCzt4Npl
         n1MFSGNFPE5C/GV3r1Kyq2IwRynCEvY3EHZbNNZMipl3wTdVvx1XDaEXokvgYMrBGX1k
         N9ie5/1Dg8+ziC9bZqTSu7dXIU5lzb0w8fW8W0VM3iCFjKz1rl5qBmMA3Trcq3r396Dh
         5YBgPx9KfyN9OVlw9J6WEpUSbrxz30vZBmX6F0CGcfmhU0xGE+RZYTuO9jtvduvPJalr
         7eMRs0lP2nwZnLMfSW1YUj5DFiHAcl3gtam2uNCWkgobp/Pww2L95YcE8BshcU+345PD
         HF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=smCsqTDmNnGCUYf6Byk9+DYcLO+iqLY9JquhcCT1RGU=;
        b=U1u7FM/XREqdWaDMBDZkd2DvPW25kbxC5hH1ytqIC/PX2fq9BB6OLqRWhL7iJtxXpy
         Hv6Rgoe66ATtyNT1ei1mCDuvBM9YtoNJm8SGzITmDYhMNudBsyXHd/eWlZU6SnmkwW+D
         n5CBHPa5cQLpQ0SSBmIhKvs/q4HaufSGtKKYtaj/ffdv60ULFSdzC/QUiZBkQtFQamjf
         jFn2/F+xZai72FTVZVEzkJ0m2orLD3y6jO7aR1K08AEsDWw03vJcUyhV98KHo9NykysW
         OCa7pv06CKzM7U1+y0ojJ57pqzqwJuXqhIvpQQoKzmXu/p/E2efPGEsntJe7LFlLcy3x
         Yi8w==
X-Gm-Message-State: AOAM531/fWZM5qootsN4escQLdj1+Sn9drAIjtlieG9HRponIcCIpA5p
        NTMhDM8lOiN45azSHfBAIrk=
X-Google-Smtp-Source: ABdhPJzN8/zKAUenhi43fTIWR491cyCMU0pf2YoRZN5YK10i0nP7AcW43wUuzJrcwICSMzZywjAl4w==
X-Received: by 2002:a05:6512:3c8f:: with SMTP id h15mr19481758lfv.440.1628543820120;
        Mon, 09 Aug 2021 14:17:00 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id y11sm1844874lfh.185.2021.08.09.14.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 14:16:59 -0700 (PDT)
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
To:     Florian Westphal <fw@strlen.de>
Cc:     syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
References: <000000000000b720b705c8f8599f@google.com>
 <cdb5f0c9-1ad9-dd9d-b24d-e127928ada98@gmail.com>
 <20210809203916.GP607@breakpoint.cc>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <2d002841-402c-2bc3-2b33-3e6d1cd14c23@gmail.com>
Date:   Tue, 10 Aug 2021 00:16:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809203916.GP607@breakpoint.cc>
Content-Type: multipart/mixed;
 boundary="------------21B9763F459AE640797A1F93"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------21B9763F459AE640797A1F93
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/21 11:39 PM, Florian Westphal wrote:
> Pavel Skripkin <paskripkin@gmail.com> wrote:
>> I think, there a missing lock in this function:
>> 
>> 	for_each_possible_cpu(cpu) {
>> 		ct = per_cpu(nft_ct_pcpu_template, cpu);

(*)

>> 		if (!ct) >> 			break;
>> 		nf_ct_put(ct);
>> 		per_cpu(nft_ct_pcpu_template, cpu) = NULL;
>> 		
>> 	}
>> 
>> Syzbot hit a UAF in nft_ct_tmpl_put_pcpu() (*), but freed template should be
>> NULL.
>> 
>> So I suspect following scenario:
>> 
>> 
>> CPU0:			CPU1:
>> = per_cpu()
>> 			= per_cpu()
>> 
>> nf_ct_put
>> per_cpu = NULL
>> 			nf_ct_put()
>> 			* UAF *

Hi, Florian!

> 
> Yes and no.  The above is fine since pcpu will return different pointers
> for cpu 0 and 1.
> 

Dumb question: why per_cpu() will return 2 different pointers for CPU 1 
and CPU 0? As I understand for_each_possible_cpu() will iterate over all
CPUs which could ever be enabled. So, we can hit situation when 2 
concurrent processes call per_cpu() with same cpu value (*).

> The race is between two different net namespaces that race when
> changing nft_ct_pcpu_template_refcnt.
> This happens since
> 
> commit f102d66b335a417d4848da9441f585695a838934
> netfilter: nf_tables: use dedicated mutex to guard transactions
> 
> Before this, all transactions were serialized by a global mutex,
> now we only serialize transactions in the same netns.
> 
> Its probably best to add
> DEFINE_MUTEX(nft_ct_pcpu_mutex) and then acquire that when we need to
> inc/dec the nft_ct_pcpu_template_refcnt so we can't have two distinct
> cpus hitting a zero refcount.
> 
> Would you send a patch for this?
> 

Anyway, I think, moving locking a bit higher is good here, let's test 
it. I will prepare a patch, if it will pass syzbot testing, thanks!


#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master



With regards,
Pavel Skripkin



--------------21B9763F459AE640797A1F93
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-netfiler-protect-nft_ct_pcpu_template_refcnt-with-mu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfiler-protect-nft_ct_pcpu_template_refcnt-with-mu.pa";
 filename*1="tch"

From 616e99fd3ac738b2b5e43c5bc57f6f8cc7a49da0 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Tue, 10 Aug 2021 00:13:38 +0300
Subject: [PATCH] netfiler: protect nft_ct_pcpu_template_refcnt with mutex

/* .... */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/netfilter/nft_ct.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 337e22d8b40b..99b1de14ff7e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -41,6 +41,7 @@ struct nft_ct_helper_obj  {
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 static DEFINE_PER_CPU(struct nf_conn *, nft_ct_pcpu_template);
 static unsigned int nft_ct_pcpu_template_refcnt __read_mostly;
+static DEFINE_MUTEX(nft_ct_pcpu_mutex);
 #endif
 
 static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
@@ -525,8 +526,10 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
+		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		break;
 #endif
 	default:
@@ -564,9 +567,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
-		if (!nft_ct_tmpl_alloc_pcpu())
+		mutex_lock(&nft_ct_pcpu_mutex);
+		if (!nft_ct_tmpl_alloc_pcpu()) {
+			mutex_unlock(&nft_ct_pcpu_mutex);
 			return -ENOMEM;
+		}
 		nft_ct_pcpu_template_refcnt++;
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		len = sizeof(u16);
 		break;
 #endif
-- 
2.32.0


--------------21B9763F459AE640797A1F93--
