Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EE7693D51
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 05:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBMEKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 23:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMEKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 23:10:31 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB6EEC59;
        Sun, 12 Feb 2023 20:10:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z1so12219485plg.6;
        Sun, 12 Feb 2023 20:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jLxavbgTsLV4ncNbN+zXdMNpmVf9uLLt8VgKSTFDO+c=;
        b=mOb6HsiCiGAkC1eKU7b7RkbyxnHaj8OiV+nNnL+P42KrGV0/Sv+aFgByACiqH/yngH
         pBkjK0t5jLvpFoqeqJZQUsT1XsMMTIBAgtSu7JsGY0DOciHMTGBAMQ1wYyP3tMr5x8Cy
         7CGB9a1a9bMId0IGF+9it/ji1ob3gXVu1toeQdjKtQkL15eOjhhxKmBYsq3TwogFoVXy
         9CoJQRoB4XP6iFDRzdG0CbP1yI2r9K8veMSc1nnhowgQKcNZO6SSV6Zn7/4eHYGPAf0q
         XMdOjECl6mmXUpJZlGuTkhmZHmAsC/VCFd1zSiPko0I5AGYQQ8R6W0D3hXLXjn6w39QI
         ugmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLxavbgTsLV4ncNbN+zXdMNpmVf9uLLt8VgKSTFDO+c=;
        b=upviX354T8PG6WtU/Nxa8wat4bmZhxVSgBAC79YriHo2HloYS7JW3533oRhmjtk7KW
         42pS0SFzaC6bV0Lsd5Cir3wf95C73RA2UV3BcWio2LPmZpeNaV1+63pIhEuMTcFmEQjH
         X/CaprRBvMR+E94xD0A8vLLVs3pR8CyU56xoME8/wezM22m1DNBRJ8OtfPIJR++N/ak+
         6T3keoQLTT/JYaMzSopAT1P+W1L2r6v5D/scpMjdX4tNRYZ6k1ghVsNyDdILiMOg6C7W
         KfW0NVdqgJaTxsJa01L9t6CUTjp4qUwMY36Du8UEaRBYU9sQc72RkOeVF7tQseQZURsf
         OsYg==
X-Gm-Message-State: AO0yUKXx9f8IIbwcwPGka02ko5TKXtbDRHHRoU/nZ5QgB0GPAz29fdZy
        JMC1RqI/Hmdo+2KCqhiqwJF8dyXz42SnQw==
X-Google-Smtp-Source: AK7set9iyPR0EE/y21NcsCe7bkTFM5EhqDr6dlWNq8QyNsa7uCCh4Fqsm6cFpxCNWK4OI6QMDCcCdA==
X-Received: by 2002:a17:902:ea01:b0:199:4362:93f2 with SMTP id s1-20020a170902ea0100b00199436293f2mr23387508plg.65.1676261429466;
        Sun, 12 Feb 2023 20:10:29 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ja20-20020a170902efd400b00183c6784704sm4911905plb.291.2023.02.12.20.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 20:10:28 -0800 (PST)
Date:   Mon, 13 Feb 2023 12:10:18 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Message-ID: <Y+m4KufriYKd39ot@Laptop-X1>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 05:22:24PM +0100, Matthieu Baerts wrote:
> Hi Hangbin Liu,
> 
> On 10/02/2023 10:32, Hangbin Liu wrote:
> > Some distros may not enable mptcp by default. Enable it before start the
> > mptcp server. To use the {read/write}_int_sysctl() functions, I moved
> > them to test_progs.c
> > 
> > Fixes: 8039d353217c ("selftests/bpf: Add MPTCP test base")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  .../testing/selftests/bpf/prog_tests/mptcp.c  | 15 ++++++-
> 
> Thank you for the patch!
> 
> The modifications linked to MPTCP look good to me.
> 
> But I don't think it is needed here: I maybe didn't look properly at
> 'bpf/test_progs.c' file but I think each program from 'prog_tests'
> directory is executed in a dedicated netns, no?
> 
> I don't have an environment ready to validate that but if yes, it means
> that on a "vanilla" kernel, net.mptcp.enabled sysctl knob should be set
> to 1. In this case, this modification would be specific to these distros
> patching MPTCP code to disable it by default. It might then be better to
> add this patch next to the one disabling MPTCP by default, no? (or
> revert it to have MPTCP available by default for the applications asking
> for it :) )

I think this issue looks like the rp_filter setting. The default rp_filter is 0.
But many distros set it to 1 for safety reason. Thus there are some fixes for
the rp_filter setting like this one. e.g.

[Liu@Laptop-X1 net]$ git log --oneline tools/testing/selftests/net | grep rp_filter
f6071e5e3961 selftests/fib_tests: Rework fib_rp_filter_test()
d8e336f77e3b selftests: mptcp: turn rp_filter off on each NIC
e86580235708 selftests: set conf.all.rp_filter=0 in bareudp.sh
1ccd58331f6f selftests: disable rp_filter when testing bareudp
71a0e29e9940 selftests: forwarding: Add missing 'rp_filter' configuration
bcf7ddb0186d selftests: disable rp_filter for icmp_redirect.sh
adb701d6cfa4 selftests: add a test case for rp_filter
42801298386c selftests: forwarding: mirror_gre_nh: Unset rp_filter on host VRF
27a2628b3c24 selftests: forwarding: mirror_gre_vlan_bridge_1q: Unset rp_filter

Thanks
Hangbin
