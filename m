Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37F83F5423
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhHXAjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbhHXAje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 20:39:34 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446B4C061575;
        Mon, 23 Aug 2021 17:38:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n12so11219490plf.4;
        Mon, 23 Aug 2021 17:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nvQfn4Lm9XjuSF4MMKdAhjaGiegbxL+5ChcYOK7EBiw=;
        b=OWcIEcteyARKSz0sUqBbk65Bg+LfmCFkPd4H0EiJp728ZxaZG966RS5Z3zagvbvaRy
         2JuS5Fe7od33AZgnpKFogWny/Br5SA+AaQ+mLwTdKAktgJG2xlXqLp+jBF9aNl0g5rVb
         HATjheG/TBF7iWETbynkYAbUVv8ofhrCi+3iiAUaskS4lzF5bb0D2n/DPCrGGy4xJCEa
         RNTZnzYKi+X5VfZqAgO8oWyyMssN5IYx2+SFUMcz5SVyCDiBD/Vs+oG6tO+6xv+rdgO9
         HvtT4UsCHJGrjk31u4XcDJLeaQgLIAnrqWIFrSQeWi39iLBp1PY6/iuLBO6vhgq1YNOm
         aoag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nvQfn4Lm9XjuSF4MMKdAhjaGiegbxL+5ChcYOK7EBiw=;
        b=m5tkyZppVbKvZeUBGGkjX6CKw81AH8Kzrw9Wec81wwVYSYE2b4xF/AN5HvhURTt/w8
         okuU7W+iEqHqaGkXbSMKDwQ0NeDHSpDgynwPxh2as8430f/JEUbecTisgu2iIZWtpuh8
         /I2oKkswU8lM7EsiIOsVdckHwwdJNYu291IHaOYu+UaWAf/3MGNBD/TL1rSAOOM7bim6
         +GZ3ynFV6OhjblqYj91mFY23iX0K5LdnhdB8ykemd3xUC0LFAfIn1VWlkuI3lAwbWIB+
         XM5sQ/7EF/ByBe02J0CGJvnp6xQkvsJd7ieGgHlHtO3+/UNvTgDhB5O21AuliXxgNX8q
         ZYCA==
X-Gm-Message-State: AOAM5315hgbwW+b/aM/tMdByKfJdMsse8kr/cEZIkrDt5SXYdazhUP3J
        tYRUv2C+d4MBgmcmIC6hb1Q=
X-Google-Smtp-Source: ABdhPJy1jT3/yYhojNwqJn/bvwsNLf7FlclkjZFE0lQ2Mc5EWXQjCXDSmGJSn4ljnX3OUGPNcO6J/w==
X-Received: by 2002:a17:902:b102:b0:134:a329:c2f8 with SMTP id q2-20020a170902b10200b00134a329c2f8mr6164883plr.71.1629765530595;
        Mon, 23 Aug 2021 17:38:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9af7])
        by smtp.gmail.com with ESMTPSA id g26sm20035390pgb.45.2021.08.23.17.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 17:38:50 -0700 (PDT)
Date:   Mon, 23 Aug 2021 17:38:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     hjm2133@columbia.edu
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, sdf@google.com,
        ppenkov@google.com
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: Implement shared persistent
 fast(er) sk_storoage mode
Message-ID: <20210824003847.4jlkv2hpx7milwfr@ast-mbp.dhcp.thefacebook.com>
References: <20210823215252.15936-1-hansmontero99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823215252.15936-1-hansmontero99@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 05:52:50PM -0400, Hans Montero wrote:
> From: Hans Montero <hjm2133@columbia.edu>
> 
> This patch set adds a BPF local storage optimization. The first patch adds the
> feature, and the second patch extends the bpf selftests so that the feature is
> tested.
> 
> We are running BPF programs for each egress packet and noticed that
> bpf_sk_storage_get incurs a significant amount of cpu time. By inlining the
> storage into struct sock and accessing that instead of performing a map lookup,
> we expect to reduce overhead for our specific use-case. 

Looks like a hack to me. Please share the perf numbers and setup details.
I think there should be a different way to address performance concerns
without going into such hacks.

> This also has a
> side-effect of persisting the socket storage, which can be beneficial.

Without explicit opt-in such sharing will cause multiple bpf progs to corrupt
each other data.
