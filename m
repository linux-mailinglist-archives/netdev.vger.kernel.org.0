Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC260DE77
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiJZJ6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJZJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:58:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFED575491
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 02:58:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ez6so13554147pjb.1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 02:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UNdJyHmPICiiVVyf+QtT6dwqqedXrOVZhbs6RG8krns=;
        b=St5wua7vnKvu8cYa5ohMuzAJGm6mg2H8XqRMKPolFkcSt2geRrz+EXezH9IG7xGj0O
         oJz/qKSMyj03XiYM9Ck/9eRgvPMN4YXlFh5a+seFwAF157UxoLP0bdrdfx57lKQY+iw/
         bfYC4KI6iTav46PKJESETkxGkg3eWrXNEHVx1whtK+xyg+NNmfCgA88erKdyMQuexACb
         nsdcLlCs3GzqUfwvKFO5erehqWkXYFMV/IkVGDFicSPhY/ZqCaG2NN/Igp0svf6Qiw4t
         aJTZfTPKUa+xubRoK52G9/h8kv2g0RsCEwr9nfYhq5+Ro2sNde1JtjdIXQYdrOf1VlbR
         TLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNdJyHmPICiiVVyf+QtT6dwqqedXrOVZhbs6RG8krns=;
        b=HYthBWGrx7dgF9t45gCrt8czRr8lIA9BpzY9PW2xvHNaM6gKo2qu34wgJ9hqWY5nim
         THIzz6M97b0F63+7UqW6nJqPgUyZh55FhKruK+bHxR9ZcLlkODiqjChPQZX2fhmKH/vF
         E3/oH/2WMW0OSPkBUahYkYFmOJsRtw1xmRJIL8jwHeuuEDFKO/O/QggcmfrNlZlay3m0
         lVUBnnha/1M0UHFOtfl+2M07grgwhbgKSQPRZCW5BfIAfjRWNSu8hmShlc7DLjOBuTRQ
         Sh5fGBGtYEQ93YtS8WXZYtadNpJJdD8Wapsi2ZPR/iVspgiBjdpad9g8pmjrrFZIOGqY
         Fzsw==
X-Gm-Message-State: ACrzQf07415efvQ+kopj4t6yrlARsjeiwdjvrxAcN1CFCzxNqJz0yafT
        L2iSy8s7h0nJmMP2XQAGJtQ=
X-Google-Smtp-Source: AMsMyM5ovLUaNfPIpOP5Ys5v1r3RDb18xaTZ/wA8rsKE8DXoWkVevdcGxCQXo/VtHrEf1P2UoXoJjw==
X-Received: by 2002:a17:90b:38c3:b0:20d:6790:19fa with SMTP id nn3-20020a17090b38c300b0020d679019famr3331185pjb.68.1666778301462;
        Wed, 26 Oct 2022 02:58:21 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b0017f9db0236asm2585255plf.82.2022.10.26.02.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 02:58:20 -0700 (PDT)
Date:   Wed, 26 Oct 2022 17:58:14 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y1kEtovIpgclICO3@Laptop-X1>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
 <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain>
 <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 02, 2022 at 11:27:08AM -0400, Jamal Hadi Salim wrote:
> > But, precisely. In the example Hangbin gave, it is showing why the
> > entry is not_in_hw. That's still data that belongs to the event that
> > happened and that can't be queried afterwards even if the user/app
> > monitoring it want to. Had it failed entirely, I agree, as the control
> > path never changed.
> >
> > tc monitor is easier to use than perf probes in some systems. It's not
> > uncommon to have tc installed but not perf. It's also easier to ask a
> > customer to run it than explain how to enable the tracepoint and print
> > ftrace buffer via /sys files, and the output is more meaningful for us
> > as well: we know exactly which filter triggered the message. The only
> > other place that we can correlate the filter and the warning, is on
> > vswitchd log. Which is not easy to read either.
> 
> To Jakub's point: I think one of those NLMSGERR TLVs is the right place
> and while traces look attractive I see the value of having a unified
> collection point via the tc monitor.

Hi Jamal,

Sorry for the late response. I just came back form vacation. For this issue,
I saw netlink_dump_done() also put NLMSGERR_ATTR_MSG in NLMSG_DONE.
So why can't we do the same here?

In https://www.kernel.org/doc/html//next/userspace-api/netlink/intro.html,
The "optionally extended ACK" in NLMSG_DONE is OK.

> Since you cant really batch events - it seems the NLMSG_DONE/MULTI
> hack is done just to please iproute2::tc?

Yes.

> IMO:
> I think if you need to do this, then you have to teach iproute2
> new ways of interpreting the message (which is nice because you
> dont have to worry about backward compat). Some of that code
> should be centralized and reused by netlink generically
> instead of just cls_api, example the whole NLM_F_ACK_TLVS dance.

Would you please help explain more about this?

> 
> Also - i guess it will depend on the underlying driver?
> This seems very related to a specific driver:
> "Warning: mlx5_core: matching on ct_state +new isn't supported."
> Debuggability is always great but so is backwards compat.
> What happens when you run old userspace tc? There are tons
> of punting systems that process these events out there and
> depend on the current event messages as is.

I think old tc should just ignore this NLMSGERR_ATTR_MSG?

Thanks
Hangbin
