Return-Path: <netdev+bounces-3416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D9B706F85
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23E2828114D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4BE31137;
	Wed, 17 May 2023 17:34:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCAC442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 17:34:42 +0000 (UTC)
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC941FFE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:34:40 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 3f1490d57ef6-b9e6ec482b3so1429699276.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684344879; x=1686936879;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ql8BC1wuvR5d44VGKffkgtVNaL4Zvqgmq6JQdp5Xcyo=;
        b=Ts5I871f8CDqaKIpSwAivKlE0KqAvCsD9eZepF9T478bEBKo1G9XTQjOfi1hXNrhMd
         6tO6HzOHcGILpbqcuj8GC2TGH/4cr41Uhhke++dKJOnO1JyQOjkLb6t5rFV8PBLciw4t
         iBFOZmWTRTUZXd4Y6Kbu9SMHwrR/GyZT3Sd+OyzWKG6xEVwSdWo0Amtp+5sW2q9yFiNn
         WLA6ZDB/ucsjqmjG5Olg2bQ7MaFkhvpBOl8Whqx8Tqp/m8fWsyKDjsH2FmPJY0uXBlSd
         dGcq3aiHdLPoxTttbnbUL7uVRnT3pLrx8ht3zvHFM0y+lyppRL1iZQKZLCOA1wnAo+86
         5/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684344879; x=1686936879;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ql8BC1wuvR5d44VGKffkgtVNaL4Zvqgmq6JQdp5Xcyo=;
        b=I/lq8ghX6ALx0COHH9Ja1rnlE3pE4FYWo2BrjLwIRCN36bxDkurx1GrQ4/t/lZD9kx
         5uZahRudpTy9PzhLsYxwHkigHpXdNNhXItgniphhxt/54PbKIMA/6eHRGcxv/E5uJuh4
         BOYp2WIruwEuOk22zScdmO5lRSh8tBT0ZPEtry3rN5n+3fx/6wJF9YLyZVg+tKwxA4mY
         QynM1NJcVWIC3pnvoWW6XK4L0BzOy+uMEhMoipEMkUceCNkQ/L2yum8bZPTPm5nx7MPx
         RMKtG3WwemlDb5/1hGb4EP8ZDpzvMHIcv3lVys9zaSYhC9Wz1I7R6o8HhHYoZ0nsENkf
         aZ2g==
X-Gm-Message-State: AC+VfDykRw2Zaux9nUV1vWRJNbC99YIRTdtXxxkLpQYcQYRshwlcz5Ej
	tvA3W2fVxjswgKSHPySb040=
X-Google-Smtp-Source: ACHHUZ7baHBH06HaX7dF/YOdki1wrSUBxQcMdbVAlLZ27ZI9N86BKMDG5pC2HyflniQWmvz+kRjFJA==
X-Received: by 2002:a05:6902:1894:b0:ba8:494c:3e9 with SMTP id cj20-20020a056902189400b00ba8494c03e9mr3953707ybb.64.1684344879465;
        Wed, 17 May 2023 10:34:39 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:d976:e286:fb8b:a4e3? ([2600:1700:6cf8:1240:d976:e286:fb8b:a4e3])
        by smtp.gmail.com with ESMTPSA id p205-20020a25d8d6000000b00ba2da98431fsm659316ybg.56.2023.05.17.10.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 10:34:39 -0700 (PDT)
Message-ID: <41144311-75ef-850f-6b99-2d19a3e7efb3@gmail.com>
Date: Wed, 17 May 2023 10:34:37 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Fwd: [RFC PATCH net-next 2/2] net: Remove unused code and
 variables.
Content-Language: en-US
To: Thinker Li <thinker.li@gmail.com>
References: <20230517042757.161832-1-kuifeng@meta.com>
 <20230517042757.161832-3-kuifeng@meta.com> <ZGTrOCcP9ITrKLlw@corigine.com>
 <CAFVMQ6SX=CES2EpovCbB5eSZjZuSbxAmoACbNdLCGWdU8kf=PQ@mail.gmail.com>
Cc: netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
 kernel-team@meta.com, Kui-Feng Lee <kuifeng@meta.com>, davem@davemloft.net,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, =?UTF-8?Q?Maciej_=c5=bbenczykowski?=
 <maze@google.com>, Mahesh Bandewar <maheshb@google.com>
From: Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <CAFVMQ6SX=CES2EpovCbB5eSZjZuSbxAmoACbNdLCGWdU8kf=PQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thank you for comments.

On 5/17/23 10:27, Thinker Li wrote:
> 
> 
> 
> On Tue, May 16, 2023 at 09:27:57PM -0700, Kui-Feng Lee wrote:
>  > Since GC has been removed, some functions and variables are useless.  
> That
>  > includes some sysctl variables that control GC.
>  >
>  > Signed-off-by: Kui-Feng Lee <kuifeng@meta.com <mailto:kuifeng@meta.com>>
> 
> Hi Kui-Feng,
> 
> thanks for your patch.
> Some initial review from my side.
> 
>  > -static void fib6_gc_timer_cb(struct timer_list *t)
>  > -{
>  > -     struct net *arg = from_timer(arg, t, ipv6.ip6_fib_timer);
>  > -
>  > -     fib6_run_gc(0, arg, true);
>  > -}
>  > -
> 
> There is a forward declaration of fib6_gc_timer_cb around line 80.
> It should be removed too.

Got it!

> 
> ...
> 
>  > @@ -3283,28 +3281,6 @@ struct dst_entry *icmp6_dst_alloc(struct 
> net_device *dev,
>  >       return dst;
>  >  }
>  >
>  > -static void ip6_dst_gc(struct dst_ops *ops)
> 
> There is a forward declaration of ip6_dst_gc() around line 94.
> That should be deleted too.
> 
Got it!

>  > -{
>  > -     struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
>  > -     int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
>  > -     int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
>  > -     int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
>  > -     unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
>  > -     unsigned int val;
>  > -     int entries;
>  > -
>  > -     if (time_after(rt_last_gc + rt_min_interval, jiffies))
>  > -             goto out;
>  > -
>  > -     fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), 
> net, true);
>  > -     entries = dst_entries_get_slow(ops);
>  > -     if (entries < ops->gc_thresh)
>  > -             atomic_set(&net->ipv6.ip6_rt_gc_expire, rt_gc_timeout 
>  >> 1);
>  > -out:
>  > -     val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
>  > -     atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> 
> rt_elasticity));
>  > -}
>  > -
> 


