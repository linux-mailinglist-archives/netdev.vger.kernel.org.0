Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A512C67E6CE
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbjA0Ndx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjA0Ndw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:33:52 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7EDB46A
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:33:51 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-4fda31c3351so66683747b3.11
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LsiVPv7OXf3ExuR/x1QLsbSK0Yc1X3gJCIkhgm59BZ8=;
        b=cKvzye7ysgghYqJwZq//rXKC9NNK/vH0zjdQ4DLup+j9TQeljMsktpRr48J6qAkyi8
         Xgebg4JFvgSN1egVKtWBTiDT9FR93WoCNanKGheWYcxHifqbxuzCQ/fR8FLcjcxr4onh
         205SKJKzexd+6Y0DlxZIIsosND6gdI57QrW7O5RLDRR2wj8ifctwV7FuiPBI2yxnbY1U
         G+kqmlFWvrsSoq/8vGun5xhnt+zFBQt+kf2XHO0gBCsIKFc9J+QH6nOW99GnVZdsUxys
         Rcz4z7Iz04PZ8ZcPI0MmKsio/njLfQ13cWemmwK1WOr488PmrktOw5L+hqoMC4BSYIsa
         pI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LsiVPv7OXf3ExuR/x1QLsbSK0Yc1X3gJCIkhgm59BZ8=;
        b=x3fDerjGth1jk3LxkuHsZnZEFJStQvqioNOqoGo/7XYGpZ76VaibfAVRZGheefaPs+
         RxSs104jcRurHjQgDbXrJSi5FNO7DUh25o6dRc+4FAe69BSfoIUtVjtgdN5DmftsARWo
         UYROlss/KnLBZGPXKGZPlChcOi+ZEIItjGLfxdwzLmcuJtF2/2gHscWZDoQhh6c7UhQF
         JsS7rU1T0s22QUTtgnCv0iesCGuAlbZICRSUMt8qGpYrhsTkEogMG/lqiR7u6+4IR0g9
         BBNq2eHdy6t2R0fy/9dqfR53LxMZNL+LrkjIfs6uAgSbdYQGf9J5KEuGehIOavwLZYk3
         g5AA==
X-Gm-Message-State: AO0yUKXdCFfr/YOPO9TrOwBzfvH4hKNKBPGj2QUJ/BA4DCfqgXbw6gAu
        e3Vefr18cclvP0IYBlyaz3SOvJwAAStsJSdok1L8PA==
X-Google-Smtp-Source: AK7set+23XABERc4/9M4iGnepCQcsMHI6qX9mtTdr1x2sMDQOz8Z0hhaQdNg4xs3ifqtUCquLHhiBRNh1hEQpLb3tZ8=
X-Received: by 2002:a81:ab53:0:b0:506:3a16:693d with SMTP id
 d19-20020a81ab53000000b005063a16693dmr1952939ywk.360.1674826430379; Fri, 27
 Jan 2023 05:33:50 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
In-Reply-To: <20230126153022.23bea5f2@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 27 Jan 2023 08:33:39 -0500
Message-ID: <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        deb.chatterjee@intel.com, anjali.singhai@intel.com,
        namrata.limaye@intel.com, khalidm@nvidia.com, tom@sipanda.io,
        pratyush@sipanda.io, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 6:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> > There have been many discussions and meetings since about 2015 in regards to
> > P4 over TC and now that the market has chosen P4 as the datapath specification
> > lingua franca
>
> Which market?

Network programmability involving hardware  - where at minimal the
specification of the datapath is in P4 and
often the implementation is. For samples of specification using P4
(that are public) see for example MS Azure:
https://github.com/sonic-net/DASH/tree/main/dash-pipeline
If you are a vendor and want to sell a NIC in that space, the spec you
get is in P4. Your underlying hardware
doesnt have to be P4 native, but at minimal the abstraction (as we are
trying to provide with P4TC) has to be
able to consume the P4 specification.
For implementations where P4 is in use, there are many - some public
others not, sample space:
https://cloud.google.com/blog/products/gcp/google-cloud-using-p4runtime-to-build-smart-networks

There are NICs and switches which are P4 native in the market. IOW,
there is beacoup $ investment
in this space that makes it worth pursuing. TC is the kernel offload
mechanism that has gathered deployment
experience over many years - hence P4TC.

> Barely anyone understands the existing TC offloads.

Hyperboles like these are never helpful in a discussion.
TC offloads are deployed today, they work and many folks are actively
working on them.
Are there challenges? yes. For one (and this applies to all kernel
offloads) the process gets
in the way of exposing new features. So there are learnings that we
try to resolve in P4TC.
I'd be curious to hear about your suffering with TC offloads and see
if we can take that
experience and make things better.

>We'd need strong,
> and practical reasons to merge this. Speaking with my "have suffered
> thru the TC offloads working for a vendor" hat on, not the "junior
> maintainer" hat.

P4TC is "standalone" in that it does not affect other TC consumers or
any other subsystems on performance; it is also
sufficiently isolated in that  you can choose to compile it out
altogether and more importantly it comes with committed
support.
And i should emphasize this discussion on getting P4 on TC has been
going on for a few years in the community
culminating with this.

cheers,
jamal
