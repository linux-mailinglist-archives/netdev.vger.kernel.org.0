Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CB75B41DB
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 23:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiIIV5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 17:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiIIV5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 17:57:52 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA034BD12;
        Fri,  9 Sep 2022 14:57:51 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n23-20020a17090a091700b00202a51cc78bso344490pjn.2;
        Fri, 09 Sep 2022 14:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=c1+vpScgxz7LgNGPJG7lEjY1wB2yXVvLAK09Ff0klGU=;
        b=JWl4mixpo5S1Nzb63cnamgw5jSxQC256Z4VHcZ5K+QlytCPl5BD/7CiBJV4pmivT+i
         7/h4czq5In76eMrUgefGI7jGTEiJ4EeRFLCAZ1HWW4Vx97eK7zGv5cRwBdJuyIG36zMC
         MsPstpiNj+Y3f7qzxiSSIrT1OE2tuwjttCXUNjlwzEu0wfDgr3krFfe4Lx6EZtpwBYOr
         hZcubbEgBlzJgQwwrD2WQR7hohjc018iVVmXLZRStytYDikwPAI9l7c89nYRhWLb6wvR
         uSBUGElkoiAMw3yXxjZeG9NWlSIT2NsYfT7jY4zMqXSvSBv0BGYL5JGYk0rBLzIgCD1A
         z9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=c1+vpScgxz7LgNGPJG7lEjY1wB2yXVvLAK09Ff0klGU=;
        b=k4wCYNqlJmRkKfs5zgzlEYCoaQ51c3H7qY71hsIRs2VD7eK6OReJH66589Jj+VkRXc
         AAG4m2d4a1m/gF1COsDp2l0qQ7rCg4f+ArGGGoriDlm8Lg8hMl7X2K5L3xs0BYyxB7Y7
         tHOpz9ERnS+rdyNtu5NlExcXdot7XQFFn+F4yDmikEfjlM6yabVo3pkpRdfwuw88G46f
         AV8xRveeYOqVCtg5J2UQwYJ6o3zLiPif7nbHH0awYDg3J8dYvmd9rI91/aUvZs23awwm
         ZmIjn36HSChFgnXfpfE+VaNbAYRYemc/9imnwJhQErTshRN9Kn85YjAPH1lFrrZmnMzr
         QBgg==
X-Gm-Message-State: ACgBeo1//ml3pnUmfTQHe9wfLku0EJT9Qi5Dg6ch3tsb1Fq2w97GG5bZ
        cVDTTrd2+W8xilsUKygV8Q==
X-Google-Smtp-Source: AA6agR5tZX5pGBAfNhBUfW8VkhuwRC43GNl4gbZOGyhkitad6WZb6xlvBWLFrZxL0p9KhQmSv9iRng==
X-Received: by 2002:a17:90a:a415:b0:1fa:749f:ecfb with SMTP id y21-20020a17090aa41500b001fa749fecfbmr11868649pjp.112.1662760670997;
        Fri, 09 Sep 2022 14:57:50 -0700 (PDT)
Received: from bytedance ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id d23-20020a170902aa9700b00174849e6914sm920386plr.191.2022.09.09.14.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 14:57:50 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:57:46 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     sdf@google.com
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        haoluo@google.com, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, kuba@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev,
        martin.lau@linux.dev, nathan@kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, Song Liu <song@kernel.org>,
        syzkaller-bugs@googlegroups.com, Tom Rix <trix@redhat.com>,
        Yonghong Song <yhs@fb.com>, Peilin Ye <peilin.ye@bytedance.com>
Subject: Re: [syzbot] WARNING in bpf_verifier_vlog
Message-ID: <20220909215746.GA12232@bytedance>
References: <000000000000e506e905e836d9e7@google.com>
 <YxtrrG8ebrarIqnc@google.com>
 <CAO-hwJJyrhmzWY4fth5miiHd3QXHvs4KPuPRacyNp8xrTxOucA@mail.gmail.com>
 <YxuZ3j0PE0cauK1E@google.com>
 <20220909211540.GA11304@bytedance>
 <YxuzdhmaHeyycyRi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxuzdhmaHeyycyRi@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 02:43:18PM -0700, sdf@google.com wrote:
> On 09/09, Peilin Ye wrote:
> > On Fri, Sep 09, 2022 at 12:54:06PM -0700, sdf@google.com wrote:
> > > On 09/09, Benjamin Tissoires wrote:
> > > Yeah, good point. I've run the repro. I think the issue is that
> > > syzkaller is able to pass btf with a super long random name which
> > > then hits BPF_VERIFIER_TMP_LOG_SIZE while printing the verifier
> > > log line. Seems like a non-issue to me, but maybe we need to
> > > add some extra validation..
> 
> > In btf_func_proto_check_meta():
> 
> > 	if (t->name_off) {
> > 		btf_verifier_log_type(env, t, "Invalid name");
> > 		return -EINVAL;
> > 	}
> 
> > In the verifier log, maybe we should just say that BTF_KIND_FUNC_PROTO
> > "must
> > not have a name" [1], instead of printing out the user-provided
> > (potentially very long) name and say it's "Invalid" ?
> 
> > Similarly, for name-too-long errors, should we truncate the name to
> > KSYM_NAME_LEN bytes (see __btf_name_valid()) in the log ?
> 
> Both suggestions sound good to me. Care to cook and send a patch with a
> fix?

Sure, I will work on it.

Thanks,
Peilin Ye

