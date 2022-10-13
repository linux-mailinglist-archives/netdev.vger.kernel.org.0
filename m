Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2355D5FD38F
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 05:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJMDeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 23:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJMDeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 23:34:13 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3289B11C6FF
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 20:34:12 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q1so496455pgl.11
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 20:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XO+97KxgluoajPHIXHQ8Pu1WlMxATOZK61Q8UDagKn4=;
        b=rWdO99mDYoyhMfakQMEPK+uf/aAGfBGVGzyhKfSU439QvdifZ6wj/XKsaDLMWf3m4G
         gSj/kPWqNSLyiW6QqYw240jyn7R/0QUabcPB07lJGOK8aLXGBz1jd5EWYkpB6Cii6EQJ
         /pY6o5SS9Fd7QWhBHUPlSxKpV22NoDk9gZuZyuFY9/D4S5gzLQEBDwMIn5/QkKd81Byk
         aEllZFOX89wTs+RMadSWYZ4NnPYMlIQ9YkdjAz2XxpRvgNaewbamcUBS+20LQ9gUbe/1
         2ebrJ647KK/AEkw+B0k92jmpTH90B5+ksn1qBvT8zKZ/D2XsY0RgitAAUYRS+UfLJThk
         wZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XO+97KxgluoajPHIXHQ8Pu1WlMxATOZK61Q8UDagKn4=;
        b=LhrWnyFZS7d3H4YEilk5AWh3q4CrcMfR99Erv8pa7jf555TWo8k7Ut4hPrtWKuLIZX
         +WuYFQqxPmzJ3cRuCz391mHN9PAt+2bC5z44uv1hCkPCQUINBWycrWch4GcJnvOCF4yI
         gwUPuCQnyspYQBnGiwxs2ikPLnJFfXJgi55O0KoxDIHwTCWlA1FQppUqzaHVEVj2j8Ea
         EORb6dJ0GB16f9OzWQmElp5vodmccfb+6NgM6olFFZD2jmOGEaLW8Wm7s1oTJWx3KhYm
         JsX2Og9GqOfZNzhD0tSOVKszveiuPYu7VBrAc8m4RGpmLezA/KjloJlYCwHFrrz1IGL5
         DLlg==
X-Gm-Message-State: ACrzQf0lL8bqGzmZX3pUorNJTcRNn8E4gTXS3S6GQI/FdDWONU3Rth/e
        M24PvBgr6/D7RoRAKLy2K0K3gQbAJUY1yTBEWAjK2g==
X-Google-Smtp-Source: AMsMyM68pkfkjql0u5736BvWl8jC0iqn4gzZliZGCQJ+V8p6w7WpzJYLJ9HKSC2nrbICS2ezhRFKR/P3/5oZUadTCFs=
X-Received: by 2002:a05:6a00:cc4:b0:565:e009:b94c with SMTP id
 b4-20020a056a000cc400b00565e009b94cmr1851123pfv.25.1665632051470; Wed, 12 Oct
 2022 20:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
 <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
 <20221012173825.45d6fbf2@kernel.org> <20221013005431.wzjurocrdoozykl7@google.com>
 <20221012184050.5a7f3bde@kernel.org> <20221012201650.3e55331d@kernel.org>
In-Reply-To: <20221012201650.3e55331d@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 12 Oct 2022 20:34:00 -0700
Message-ID: <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 8:16 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 12 Oct 2022 18:40:50 -0700 Jakub Kicinski wrote:
> > Did the fact that we used to force charge not potentially cause
> > reclaim, tho?  Letting TCP accept the next packet even if it had
> > to drop the current one?
>
> I pushed this little nugget to one affected machine via KLP:
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 03ffbb255e60..c1ca369a1b77 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 return true;
>         }
>
> +       if (gfp_mask == GFP_NOWAIT) {
> +               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
> +               refill_stock(memcg, nr_pages);
> +       }
>         return false;
>  }
>
AFAICT, if you force charge by passing __GFP_NOFAIL to try_charge(),
you should return true to tell the caller that the nr_pages is
actually being charged. Although I am not very sure what
refill_stock() does. Does that "uncharge" those pages?


> The problem normally reproes reliably within 10min -- 30min and counting
> and the application-level latency has not spiked.
