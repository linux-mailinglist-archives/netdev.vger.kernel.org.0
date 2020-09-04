Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8FF25CEC6
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgIDAbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 20:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgIDAbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:31:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4649BC061244;
        Thu,  3 Sep 2020 17:31:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so3403554pgm.11;
        Thu, 03 Sep 2020 17:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Da/UPlvuCfPrmcDHalSMb8ED2kNEjjHNWBwxpRFuaZA=;
        b=fznu/Vzjd08LMHqFp9CP5OhKqFdzklkincPmrI8jSbzdV+oiNRZj/Xgwjr8XHO7Ifg
         kOn+G4fWLHWHHrMb3M51vNztvOr4Z/VsAaG2gLnnJjpME74eXvcP9w1YP+dvfFPiA/wn
         6xTTHW9OgOnUOH9VlLOKVGrSvF5+sOtndrik+Wxer5FzVCdRGWNSfQHUxKjTxY1Y+53B
         dafeFVNNRdn7f069S6gRkYya9HdXHQ9rMoeuumug7P5TwLOtcOl/y04e/F41GUTQI8ls
         8LFqSqeSvToRiK3R3niCdZ0ERkCrzOfiqfwTzF4gZz0P80gD29C3uIlTshqDmJ0+Ha8w
         BBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Da/UPlvuCfPrmcDHalSMb8ED2kNEjjHNWBwxpRFuaZA=;
        b=nKjtXliugh5T5lSaxbSuEMZ1L1603Ws6soAS1cW9/P/I7rk2R6TdPr54hk2gHf5r9F
         t/sv1z/qmviBx9yVDzvejMVMdm+4F4UhmSwTtZzuZcNj5Y+0Ze4yGRMQMPdnPnqgUwEz
         nJaa9r4A1emGJwIo/mYkj9F4IpSyMflZ0UTap/0sjBwaWgJZXGtgAOiaQOw2ZsHPrXQN
         qbK/AIIp62qS/ZyS6ZfTv5mtZpYHS7QHcWNO75y5iK5jBd2mCi2W9D+nc1CfF5z6dRPE
         yfE0rZKtgO8N+lnnLRsEiXX6f5OnsxxVOnTp1aFF4Lg+cm9t1mloq11TWJCNThdochcI
         jAbA==
X-Gm-Message-State: AOAM5305H6CqWTTj52LAjQTf6TaNeYfj81ECIZk7i2xqp099C5phaXf8
        3v+ta7Yp1muM0MoSo0vMgl4=
X-Google-Smtp-Source: ABdhPJyFTEHUJD1b0NpYag0PQZOvuTt7didHkNmczFNjTEPNSCfTwtkgJEQkxMX/67OsaTzfFleN2g==
X-Received: by 2002:a63:5b42:: with SMTP id l2mr4959386pgm.197.1599179505746;
        Thu, 03 Sep 2020 17:31:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8159])
        by smtp.gmail.com with ESMTPSA id m20sm4438025pfa.115.2020.09.03.17.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 17:31:44 -0700 (PDT)
Date:   Thu, 3 Sep 2020 17:31:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 00/14] Add libbpf full support for BPF-to-BPF
 calls
Message-ID: <20200904003142.krb4b2jzfqovev5o@ast-mbp.dhcp.thefacebook.com>
References: <20200903203542.15944-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203542.15944-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 01:35:28PM -0700, Andrii Nakryiko wrote:
> 
> This patch set removes all such restrictions and adds complete support for
> using BPF sub-program calls on BPF side. This is achieved through libbpf
> tracking subprograms individually and detecting which subprograms are used by
> any given entry-point BPF program, and subsequently only appending and
> relocating code for just those used subprograms.
> 
> In addition, libbpf now also supports multiple entry-point BPF programs within
> the same ELF section. This allows to structure code so that there are few
> variants of BPF programs of the same type and attaching to the same target
> (e.g., for tracepoints and kprobes) without the need to worry about ELF
> section name clashes.

Applied. Thanks
