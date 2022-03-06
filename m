Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336F74CE81B
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 02:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiCFBd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 20:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiCFBd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 20:33:56 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE1E51E63;
        Sat,  5 Mar 2022 17:33:03 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id s1so10892320plg.12;
        Sat, 05 Mar 2022 17:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wI+Kl8nulB1LQULZCJ/xzxDgYDnL5NVXY2A3p+RYqI0=;
        b=HFIsKOKb7j3mt5t1wnDSoUrKx+CDlDXseFoZh5qkeHrXO3WrXUptjO2TdjvVRpQCdq
         kQPlWjXwODYiLicbeDfV9dfowgYd1plM+/iKN61OnZY4ITu2kX5EwkLY8KD7x8DvvW8R
         z1eZR23BcRC9DUJXU9WSJJ+6owShjRrhfQsvDuulLDE1v3W31AJYOosYJwmel16I9AIt
         5O/pjbc24b//3HUPlvuBf721fFT+nBGuG3KDO+GHU12+OB86I5moaM/USXdBSEFzIQtz
         RTBNG1ShJSnnNcQglzxpPql59ArPNXDzP3Fnz7o50D9Q4XJVndnWi1h+U9rmIgxOhUms
         lckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wI+Kl8nulB1LQULZCJ/xzxDgYDnL5NVXY2A3p+RYqI0=;
        b=EONqhwKl7rii3U0qi4qhdUv0LaVPdV7kVcoCPXDG5L3/XdlrZTM6bizHMbxigB+HCl
         Ve7O5lzFKX29eI8RZrNN41bEkPqd9EO+iztqnkIwjO0p8X56FKTR/Zk2j1A84cOXaN1B
         46MABLfKu/XF0J3+RfqE5B6mTUoIqoNq/kR9T30ASUaqFxGFnxNYpGSDiWna4nfZa1qI
         3xxyUmhprcrd2VjfQ/t8Dbe9do03YtAOefyfPJVkNpBGcMhvuFSAQ0VpYGDszsvMUy3/
         fiEMzSf0I/jGAlUdRzf7UVLCbCZ1vEBrgBYAen2cwCHVtV52JThPkUojc8LYEr0+jfIy
         aFSw==
X-Gm-Message-State: AOAM530dAYsZliF6t61OxqR9va8ZlpqV/OSo2O9EiwHZOeSxxem9xPMP
        z+W00WQl3mGHWRnCGq8gUAM=
X-Google-Smtp-Source: ABdhPJwh/6Khjao8jg09MmBIZ8j2E0Nu0SDHuEmQi4q4FHzwyIhGW/HD4y2qFA74ugP2HnWCwk5FrA==
X-Received: by 2002:a17:903:2406:b0:14d:6447:990c with SMTP id e6-20020a170903240600b0014d6447990cmr5569829plo.22.1646530383080;
        Sat, 05 Mar 2022 17:33:03 -0800 (PST)
Received: from devnote2 (113x37x226x201.ap113.ftth.ucom.ne.jp. [113.37.226.201])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm11825578pfl.141.2022.03.05.17.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 17:33:02 -0800 (PST)
Date:   Sun, 6 Mar 2022 10:32:57 +0900
From:   Masami Hiramatsu <masami.hiramatsu@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 0/8] bpf: Add kprobe multi link
Message-Id: <20220306103257.fcc36747bf6a689a24c91d59@gmail.com>
In-Reply-To: <20220305200939.2754ba82@yoga.local.home>
References: <20220222170600.611515-1-jolsa@kernel.org>
        <CAEf4BzaugZWf6f_0JzA-mqaGfp52tCwEp5dWdhpeVt6GjDLQ3Q@mail.gmail.com>
        <20220305200939.2754ba82@yoga.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Mar 2022 20:09:39 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 4 Mar 2022 15:10:55 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> > Masami, Jiri, Steven, what would be the logistics here? What's the
> > plan for getting this upstream? Any idea about timelines? I really
> > hope it won't take as long as it took for kretprobe stack trace
> > capturing fixes last year to land. Can we take Masami's changes
> > through bpf-next tree? If yes, Steven, can you please review and give
> > your acks? Thanks for understanding!
> 
> Yeah, I'll start looking at it this week. I just started a new job and
> that's been taking up a lot of my time and limiting what I can look at
> upstream.

Let me update my series, I found some issues in the selftest.
I'll send v9 soon.

Thank you!

-- 
Masami Hiramatsu
