Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8072FDF6F
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404722AbhATXzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbhATXl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 18:41:29 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567C9C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 15:40:49 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id d85so55709qkg.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 15:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Osl7RNbWiN5uZKD67FNy0SG031Les7099RpsMShVWBk=;
        b=pfowKxsyJgAOb9S+AE+zm23BYLJyvWxqIhJRnmpqFLMuBCBMufFdRlDWPJZ/2Z0k7h
         fVa/KwGsc0zPfipYU59vVvHhLJnHErt6IgeHYD4I3raf49eLV7IfMjIF6QGi3XPQvRwc
         oUo5at0xEA/VMoXk0AwRByTsBVEVF7nc6pocPDE9YyXzuYvRu8x/VpNBDL5BGnxl+Bep
         iOn+z7ZTGMAySPEvsQbNB30/2vPvunPRZnQ/+/diyiCHgM1O1mEKle0gEiC6YbQIqUgr
         brEmT7IHWWR5uK7QorMtiAOk7whzyBmgxwb9I4g12tgTV/8ocCCFBVP0CfpBmG46ht9T
         sOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Osl7RNbWiN5uZKD67FNy0SG031Les7099RpsMShVWBk=;
        b=AcD0BkZZaQHaDDBhS2bfLNAOCNGY14vB7sCKQ3tpOBdrC6InO9hIA4mAYoET5fVlnW
         HJ4e8I2u32df2XrBuRUtiWmgVwJu2K/1vBNrXklM7PzGIGSO6l45XkY8c5/0ZZR4Zi46
         FQ4YWaO347a/6WbUW09lQNlpyqYQy2O7XS6XjZvQA0bjkauijK9jVreefJMAYfsv/pFB
         20d1FvzpO3jEV4Pwfie9//vbN0A0rmkBAbH3k4jViWZktEENQyJfw+TAQdw2DFOs85vi
         QTPJzomZWJf5UzUGhh8QvKw6g16RpM+xa1PM91te2Ytq7tsmRHIv9Xw7Li2p1e2vquTf
         ZtaQ==
X-Gm-Message-State: AOAM5312jj7ydQCTEf482+Ed0a9lfY+jxc37SnedKL55AITvYsrggy4D
        IyYVXkMTt5Jak4x3u60c8EY=
X-Google-Smtp-Source: ABdhPJzAHAqXOIyRHnMg8znqziCqCnTCjuPqfVqIyVfdWn+z18i0szbPmlqG2Mycp1ZIUWHK5koJdA==
X-Received: by 2002:ae9:ef83:: with SMTP id d125mr11933025qkg.63.1611186048460;
        Wed, 20 Jan 2021 15:40:48 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f016:4ecb:865e:1ab1:c1d6:3650])
        by smtp.gmail.com with ESMTPSA id t184sm2473352qkd.100.2021.01.20.15.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 15:40:47 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 3F828C0EA1; Wed, 20 Jan 2021 20:40:45 -0300 (-03)
Date:   Wed, 20 Jan 2021 20:40:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next ] net/sched: cls_flower add CT_FLAGS_INVALID
 flag support
Message-ID: <20210120234045.GC3863@horizon.localdomain>
References: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVs5WOS0-Y7RvpOr12F8u84Rwna8EQ0NzuFof7Suc7Wyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVs5WOS0-Y7RvpOr12F8u84Rwna8EQ0NzuFof7Suc7Wyw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 02:18:41PM -0800, Cong Wang wrote:
> On Tue, Jan 19, 2021 at 12:33 AM <wenxu@ucloud.cn> wrote:
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 2d70ded..c565c7a 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -237,9 +237,8 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
> >  void
> >  skb_flow_dissect_ct(const struct sk_buff *skb,
> >                     struct flow_dissector *flow_dissector,
> > -                   void *target_container,
> > -                   u16 *ctinfo_map,
> > -                   size_t mapsize)
> > +                   void *target_container, u16 *ctinfo_map,
> > +                   size_t mapsize, bool post_ct)
> 
> Why do you pass this boolean as a parameter when you
> can just read it from qdisc_skb_cb(skb)?

In this case, yes, but this way skb_flow_dissect_ct() can/is able to
not care about what the ->cb actually is. It could be called from
somewhere else too.
That's my rationale on it, not sure if wenxu thought the same.

Thanks,
Marcelo
