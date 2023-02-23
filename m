Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914226A02E0
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 07:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjBWGlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 01:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjBWGlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 01:41:01 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7708F9004;
        Wed, 22 Feb 2023 22:40:56 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z20-20020a17090a8b9400b002372d7f823eso7571195pjn.4;
        Wed, 22 Feb 2023 22:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdHPnsPa9JsSktPZ91JIj0abI1B8FcfEYdJ7HepTpNU=;
        b=Z6Rg/M6aR/JpMwCWMZEPgrQvHTTj9263dfmEejeQuM1pqXd0MO4ViDmFbVFEB5DZlE
         Nx7YTeOsd5uBsppnHpswSILUt+jEBhLdVlf0TYuhC9IKMCEprA5kbNBUwcmT1tuvQ09I
         LaURJyjxsA4bZHeAO/hSpJTPdltW/o8y2mnwT0boEfdiWdJIgol76LNTsfVlNagztjVA
         1HHzd4nbzh52f5xeT1e2DCDF44NR0NOu420WASxMq9DMd/B6AW7Db6Cd792qsOU/00Vy
         tcenmmJr+5EhDqHTefgn+EUJDz+yPeDmniUBRA2oFH52sEcjpEUG/j9rJLCVzC9Gp5cP
         QRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdHPnsPa9JsSktPZ91JIj0abI1B8FcfEYdJ7HepTpNU=;
        b=RVtHIjoYij+pLfKEYL2yMoD9vyqNTcU5qlGzpDYaPhbk0EqmIsU7wN+rcXlkH/qgvO
         E5vB2FGODp0K7NVudzkm4jaWBrRoAt6eijLFsHm3zvvXiuNtyOCwknrJxc4jx2tqXaV3
         zuOFyN4HqT8OOf+02ZsC4DLG+Ddd0s62r9lHzpzeaOBFZSBwp+XexVcoJejIq66Gya8t
         uPrL09njtTEo1n01qXuBTX9zTa9lbFAXhFngqQbrXIQDv+gYFCSwoSz8+8ylrqmooMFL
         UoiwqoYr2qvVk7U9B3wv1I8tmUKXRODxOYODiyvPC9ghie9yIPsOj0XnIaP+kOKBMzT3
         DCHg==
X-Gm-Message-State: AO0yUKV/w+B+U5QH9ngYLtMBgTFZsWyicE4lNDi3XsJDch/DuYN4f0KT
        7gm5VtKJUQx0abhd08fgPOA=
X-Google-Smtp-Source: AK7set/yrhf5VaDf1y4KwXxpA96cLUkHaRCV5X9oEyE38jdeud7wFxU++sG0nGsUJzPTCGS9w4qj8g==
X-Received: by 2002:a17:90b:4f4e:b0:230:acb2:e3e8 with SMTP id pj14-20020a17090b4f4e00b00230acb2e3e8mr10670399pjb.23.1677134455961;
        Wed, 22 Feb 2023 22:40:55 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090a31c100b001fde655225fsm3467883pjf.2.2023.02.22.22.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 22:40:54 -0800 (PST)
Date:   Thu, 23 Feb 2023 14:40:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: run mptcp in a dedicated netns
Message-ID: <Y/cKbW8SuPwBg96/@Laptop-X1>
References: <20230219070124.3900561-1-liuhangbin@gmail.com>
 <8781d9c2-2352-ac0b-9d79-82be8eb404ff@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8781d9c2-2352-ac0b-9d79-82be8eb404ff@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 03:44:17PM -0800, Martin KaFai Lau wrote:
> > +	system("ip netns del " NS_TEST " >& /dev/null");
> 
> It needs to be "&>", like the fix in commit 98e13848cf43 ("selftests/bpf:
> Fix decap_sanity_ns cleanup").

:Shame, Didn't notice this when do copy/paste...

> 
> Since it needs to respin, could you help and take this chance to put the
> above SYS() macro into the test_progs.h. Other selftests are doing similar
> thing also. If possible, it may be easier to have a configurable
> "goto_label" as the first arg.

OK, I will fix it.

Thanks
Hangbin
