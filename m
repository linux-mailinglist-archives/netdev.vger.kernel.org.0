Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E86629083
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiKODIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbiKODHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:07:40 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D111706E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:07:33 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id k22so12895418pfd.3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4OZ9m7ZTKSG3DlV3MLDz7rwnjtDEki1L+4K9gaJ8Kk=;
        b=nKd+qHpGBYWHO56wOC/Eb/py6pEwaj1rOI+Oh4RQseL7aQH97snTpBd/rKkTBPLMOE
         7Jqs0LSjh5ePN2nnHlDgUiuucLfg8G3NPKFnq7ihCF9dLwA0YN7NgP4XIW5383wJBe/3
         QO83ua5hIAJCi3jBzoy6IZcdpYZaGcxtkO9NbYi8jC8d5uwkievGPmMSRwRUKjzAnv0H
         rrgm17C0YR60PRPw7yu+A/AcVy9niqqRE6K6dtzFTnfDrAKyIThn/fhj9pUAJBwUyNHO
         RvVlggKqptDLM7N4yrG2nuunCUJhUbDlsZ2dmqMkOKbyTI5JvDKgATi+CWAXnLaZM2GS
         Tm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4OZ9m7ZTKSG3DlV3MLDz7rwnjtDEki1L+4K9gaJ8Kk=;
        b=xHvELQ/w4oBEyGA/m0TSybZ3xk4s1/iaAsf0pdtFJ4XL/O7eYQ+0ZX4uLaIDHDbGsx
         GDvOnX2OncVQG4WPqQIR7QHsCL2CUfUB2eDAq0H4yNPcy/QIvYeermDv0lGutlklgqZj
         V5hkxi8G/hxxvw3VqCbPpe1d/Hqyy+rqaMrhML4MmEM9ylth3yKSx2jqJ03KSZWmOrBC
         /JBp8nYCz972IH6VqozK0as0TIl77pKO4EP8lbTQ99BYTdpQyjC0srW3EWP1fbDsQpoH
         Pw9Vr1tWnmczMUwi/uMRSuQuA0XD1P/fG3VHjzJX0mqcHAXSlhZnIwVuUfu3uQBSXzHe
         cnSQ==
X-Gm-Message-State: ANoB5pkq/lXkeojq0/VnhseStjji4cc6vlAdNJ6tqFW/Yb4ADDg//nge
        2zjdYXtIhNXJ2hpS8dy/sZAMjvduMkoPTg==
X-Google-Smtp-Source: AA0mqf6TdyQdARTdGNGnsBYA7irr+pefnm9kTQXOR/R3gS6PQn292VJe/pJ9t/UDgqug7odJl/HR4Q==
X-Received: by 2002:a63:fe4b:0:b0:470:2c90:d89f with SMTP id x11-20020a63fe4b000000b004702c90d89fmr14433307pgj.253.1668481652306;
        Mon, 14 Nov 2022 19:07:32 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090322d000b00186f0f59c85sm8412311plg.235.2022.11.14.19.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 19:07:31 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:07:21 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y3MCaaHoMeG7crg5@Laptop-X1>
References: <Y1kEtovIpgclICO3@Laptop-X1>
 <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
 <20221102163646.131a3910@kernel.org>
 <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org>
 <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org>
 <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110092709.06859da9@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:27:09AM -0800, Jakub Kicinski wrote:
> > I understand your frustration but from an operational pov it is
> > better to deal with one tool than two (Marcelo's point).
> 
> IDK, we can have a kernel hook into the trace point and generate 
> the output over netlink, like we do with drop monitor and skb_free().
> But I really doubt that its worth it. Also you can put a USDT into OvS
> if you don't want to restart it. There are many options, not everything
> is a nail :S

I have finished a patch with TCA_NTF_WARN_MSG to carry the string message.
But looks our discussion goes to a way that this feature is not valuable?

So maybe I should stop on here?

Anyway, thanks a lot for your time and comments.

Hangbin
