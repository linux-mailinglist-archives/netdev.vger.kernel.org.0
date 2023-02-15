Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB74C6974FB
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjBODn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBODn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:43:58 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1787330184;
        Tue, 14 Feb 2023 19:43:57 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d2so16965639pjd.5;
        Tue, 14 Feb 2023 19:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXx6lEwD2TEgOQrVayIfHTVdxpHuO1zPkPYf3xv3xtw=;
        b=Q1rTsXnoB3obtyVtX4GfqR/zWDu/Df5wVPlIDHjKg46vnqPGJc0+28fiedhAQFF6KC
         FNX/m0sbtLZG1vkxuGXh7IvbQ3mmXfjiQ7kmlm6bktfbGYnSLXIfJaq9vMT04jl3A3Ta
         D1//u5n2di7srwVBCwF7mq5DdNVdUJ16MDpEbe24w+M4Q9E9MfFCAN7LPKI7IVH15o87
         pvZSF4GoI6LLquasg7RzvIkioVRMhEydDKRH/ZQVX53h0wlm9B7KJqIFBa8ereiFHIvD
         23hUZ8ZoBFmkMDASqdKU5WY0mtIbZCs+d+/xPpAsU2UyU+S7rktpf/Vth6IDo7LqW+Ha
         aPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXx6lEwD2TEgOQrVayIfHTVdxpHuO1zPkPYf3xv3xtw=;
        b=fGdH2n6V6rx7N9idlpXG1jmJvO2C35+Ca1FSneHqRYxoHaNAgmivitvTpSalPGyFVz
         W+owGlvh1SbPYvvObkZc/wWT/VlyxnozEfKHj5WGCb6lSZBPFrMvX54cmMgc0Bb0QUXS
         ipJhajrWRzbgfenmGI9Q2j0mDg6fxPzp/Z5HZ/3vIzg9OtKWjyn2plzyB6zKEkKKjXyf
         bPBJC397FnluTqfKJ/4eoCWqbtDWDvpQf8TO88pHM2CRywSouk3p3351xjThMI5BccFT
         xgdLDWbPxd2ob2i9E3gq2XQH96pVpEuI5zr0uP5IZqN/wow2a2bxzbH5T4w85XqJ+yy+
         u2+A==
X-Gm-Message-State: AO0yUKVCideQyyU2Tpw9nF5LIWMzBgDvw7I3DVQY5/8ZQI+k0gMKnqqK
        hh+E6hDYfYk3GeJtAlFvwnG9MdvMA8UkoQ==
X-Google-Smtp-Source: AK7set+aDPeR/pNnHNeLF5I8RiB6SfJjYY8z+6cPCM7Ze4rq8zHobFTUM5eMqWl9QQveSfcVMj4ZQA==
X-Received: by 2002:a17:902:e80b:b0:196:725c:6ea with SMTP id u11-20020a170902e80b00b00196725c06eamr1045418plg.19.1676432636542;
        Tue, 14 Feb 2023 19:43:56 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e18-20020a170902ed9200b0019904abc93dsm10948008plj.250.2023.02.14.19.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 19:43:54 -0800 (PST)
Date:   Wed, 15 Feb 2023 11:43:46 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Message-ID: <Y+xU8i7BCwXJuqlw@Laptop-X1>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
 <Y+m4KufriYKd39ot@Laptop-X1>
 <19a6a29d-85f3-b8d7-c9d9-3c97a625bd13@tessares.net>
 <Y+r78ZUqIsvaWjQG@Laptop-X1>
 <78481d57-4710-aa06-0ff7-fee075458aae@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78481d57-4710-aa06-0ff7-fee075458aae@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 11:22:58AM -0800, Martin KaFai Lau wrote:
> On 2/13/23 7:11 PM, Hangbin Liu wrote:
> > On Mon, Feb 13, 2023 at 05:28:19PM +0100, Matthieu Baerts wrote:
> > > But again, I'm not totally against that, I'm just saying that if these
> > > tests are executed in dedicated netns, this modification is not needed
> > > when using a vanilla kernel ;-)
> > > 
> > > Except if I misunderstood and these tests are not executed in dedicated
> > > netns?
> > 
> > I tried on my test machine, it looks the test is executed in init netns.
> 
> The new test is needed to run under its own netns whenever possible. The
> existing mptcp test should be changed to run in its own netns also. Then
> changing any pernet sysctl (eg. mptcp.enabled) is a less concern to other
> tests. You can take a look at how other tests doing it (eg. decap_sanity.c).

Thanks for the reference. I will update the patch to make mptcp run in it's
own netns.

Hangbin
