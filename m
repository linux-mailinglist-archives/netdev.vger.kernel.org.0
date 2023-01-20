Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7549C67536D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjATLao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjATLan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:30:43 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367DEE1;
        Fri, 20 Jan 2023 03:30:42 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id s124so4173736oif.1;
        Fri, 20 Jan 2023 03:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eYVnKhOD8g9iG32ASFP7LNl/DoJNo6pqrK1SwH3IDBM=;
        b=IZ0uvt/pVdZMIlBJafgLN+aJRWaaPo4rF+159uCQGDL+a+ApsPSXmNf/tvt0tc18gg
         rpipvcgZGfLLgd3trSLAIYv/rPY1nOAtYNCHNunSflVvce2L518dhaxaT+kb4NKWkiTK
         9LQDpUXl5GXA8La+c3W0T+Ji6+ZUzmoR5sKbQlq5xl4zZROVg5en+5ek2HvJBV6I9L/J
         bZVy3hxgSzQZB2wHJgUrUJOJD3LYUoVJ7RjrJBLTRnZ7j1D6td1eujgi44K409pSNR31
         4afzQd9+r+dwoZvMonlFEovbob5X+Q5sjQx2Mqf094ur2AFbLMl+LU3ZJxt4pYCg1MsA
         QQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYVnKhOD8g9iG32ASFP7LNl/DoJNo6pqrK1SwH3IDBM=;
        b=kv5qlt4dp47wRcA2kLuTcVZkiSYLVJJIlgkAftZ+jzBH4dvXM2P+LoSsVTT8b1m6E1
         cxkPdFtMqTVOIuVk1Uc3ztmEA0hGqm8jmXG/cCkNto/X2fTTXc7/SmBS3wzKcmViumJ3
         l8UOyw+GmqtpxJCj+6E0g3N9MtvrrIXcewYDim0Xl7BBmI+3Awcye9YJKK9EGBSAvHAv
         4BpWs4zkD4DFc6SJyjYRp/fcjiV91F68uJcg39uGLTVKnBFim3JIgk2tYpz5j5PX0eUf
         M2oYRYJj8xdu4BPhZCT1G9MA0co56RSlcBQBhLAZwPzlnwG8RWDjDEqF/0byL85H+i3u
         k9uw==
X-Gm-Message-State: AFqh2krmm41EHDwMaEbl67Z0HEQADy+6oLY53zcWoi7poOcDTL+JZuqd
        FnT6fS4Qk08LWtZzk37ziBXyx9IPcQi8yA==
X-Google-Smtp-Source: AMrXdXt4ZjK3bRGPQTgndqPAK0rblVjzgALC0VwITPkgza+a+oo52q3bocvYkRkQz4viZUJ6+Wf+Gg==
X-Received: by 2002:aca:230b:0:b0:35e:d234:712a with SMTP id e11-20020aca230b000000b0035ed234712amr6163938oie.40.1674214241410;
        Fri, 20 Jan 2023 03:30:41 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:3243:26ee:68de:6577:af10])
        by smtp.gmail.com with ESMTPSA id bx6-20020a0568081b0600b003436fa2c23bsm1046134oib.7.2023.01.20.03.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 03:30:40 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id DB4824AE701; Fri, 20 Jan 2023 08:30:38 -0300 (-03)
Date:   Fri, 20 Jan 2023 08:30:38 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v3 0/7] Allow offloading of UDP NEW connections
 via act_ct
Message-ID: <Y8p7XsUFaHRFGIBJ@t14s.localdomain>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <Y8m4A7GchYdx21/h@t14s.localdomain>
 <87k01hbtbs.fsf@nvidia.com>
 <87fsc5bsh9.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsc5bsh9.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 08:57:16AM +0200, Vlad Buslov wrote:
> On Fri 20 Jan 2023 at 08:38, Vlad Buslov <vladbu@nvidia.com> wrote:
> > On Thu 19 Jan 2023 at 18:37, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> >> On Thu, Jan 19, 2023 at 08:50:57PM +0100, Vlad Buslov wrote:
> >>> Currently only bidirectional established connections can be offloaded
> >>> via act_ct. Such approach allows to hardcode a lot of assumptions into
> >>> act_ct, flow_table and flow_offload intermediate layer codes. In order
> >>> to enabled offloading of unidirectional UDP NEW connections start with
> >>> incrementally changing the following assumptions:
> >>> 
> >>> - Drivers assume that only established connections are offloaded and
> >>>   don't support updating existing connections. Extract ctinfo from meta
> >>>   action cookie and refuse offloading of new connections in the drivers.
> >>
> >> Hi Vlad,
> >>
> >> Regarding ct_seq_show(). When dumping the CT entries today, it will do
> >> things like:
> >>
> >>         if (!test_bit(IPS_OFFLOAD_BIT, &ct->status))
> >>                 seq_printf(s, "%ld ", nf_ct_expires(ct)  / HZ);
> >>
> >> omit the timeout, which is okay with this new patchset, but then:
> >>
> >>         if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
> >>                 seq_puts(s, "[HW_OFFLOAD] ");
> >>         else if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
> >>                 seq_puts(s, "[OFFLOAD] ");
> >>         else if (test_bit(IPS_ASSURED_BIT, &ct->status))
> >>                 seq_puts(s, "[ASSURED] ");
> >>
> >> Previously, in order to be offloaded, it had to be Assured. But not
> >> anymore after this patchset. Thoughts?
> >
> > Hi Marcelo,
> >
> > I know that for some reason offloaded entries no longer display
> > 'assured' flag in the dump. This could be changed, but I don't have a
> > preference either way and this patch set doesn't modify the behavior.
> > Up to you and maintainers I guess.
> 
> BTW after checking the log I don't think the assumption that all
> offloaded connections are always assured is true. As far as I understand
> act_ct originally offloaded established connections and change to
> offload assured was made relatively recently in 43332cf97425
> ("net/sched: act_ct: Offload only ASSURED connections") without
> modifying the prints you mentioned.

Oh. Somehow this behavior glued to my mind as it was always there. Not
sure which glue was used, please don't ask :D
Thanks!

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
