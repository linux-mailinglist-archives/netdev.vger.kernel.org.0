Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8C24A8C7
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgHSV6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSV6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:58:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026AEC061757;
        Wed, 19 Aug 2020 14:58:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y10so9923218plr.11;
        Wed, 19 Aug 2020 14:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Slmlxej47s8TYSV/lTa7cjH1TUjlzp7BpAXRL++feQY=;
        b=fV1JUBO+o/DIZy0W7m1xwRfC1efNfPHi9BYLaJ4R+l13kB2GCK6rzdG4/oMHYNcyMO
         wiebUJkxRTjQUNF9tIJ/IshHTmIlInOJpfDy7VMnUzv0h4bJfeIG7dTbnHSqnoIH/9lj
         C2nngzmX6g6iPdnZHSapKnDzYltOiBIsc5bK/WFP/LhiIICHOmo6RMj1zc7kRPF6/F9c
         2bRfYjYB6hRWrUHn3GSksZ8vwWeBI9LkGWp2ZUoPjRlit5ofK1F3hvN00lJjhA3Z8Juf
         Q8doDsa/hijyVraVTxJ+GtMzMaELlXYoxvMOzkfoeGpsJVNQRWJiohFtA5mQNLbxku8F
         ir0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Slmlxej47s8TYSV/lTa7cjH1TUjlzp7BpAXRL++feQY=;
        b=KArmDYJcS6tkhrHWtrpFlQnSvuZ0mQnsZaxRhIwEVA6ugD+agfaf2FxzzGLvWru8bX
         r67OY0LLw65DFTGCIPOMyiuoeS3vkOTP4ANbAemECctNWpnuvCXM/jCFvWVoZh97zzAq
         YzI71UlBpe2QoLuxlG/D+cxjH8MJNg9v9aXaDGQsYMw0V6uOFriILTAiWAJT9vEOSltm
         gsSoqosyj80qUIsnOGHuVSNw59yrgqHM94Xl0mbOBKYcLzSi1ipOYaNJvAoHdDszDhtf
         TGIPB60u4VJJJ5XSeosiKy2qmOfuBdmgcIrxQ1d+Keexq5mvn/XO9YS5sDcQh5HCqI4L
         509g==
X-Gm-Message-State: AOAM530QA55bIJ+gaoVbo3eSr8dX0kaBMuk/IOg8MGmqFykqto9gy7+W
        ZPz4XCNgEzwnGRLFnZ/VTmyP/7cVaDQ=
X-Google-Smtp-Source: ABdhPJzYcffqlqVTrh1N+PG6CfMZJCSZPVl+1fxN6fUu5ZI3BkBSyznBNcpDB729GFJhn4Ta/7rkCQ==
X-Received: by 2002:a17:902:6bc6:: with SMTP id m6mr153197plt.302.1597874329953;
        Wed, 19 Aug 2020 14:58:49 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:20fd])
        by smtp.gmail.com with ESMTPSA id h1sm202803pfr.39.2020.08.19.14.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 14:58:48 -0700 (PDT)
Date:   Wed, 19 Aug 2020 14:58:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 0/5] Add libbpf support for type- and enum
 value-based CO-RE relocations
Message-ID: <20200819215846.frvsnoxu6vv4wamt@ast-mbp.dhcp.thefacebook.com>
References: <20200819194519.3375898-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819194519.3375898-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 12:45:14PM -0700, Andrii Nakryiko wrote:
> 
> Selftests are added for all the new features. Selftests utilizing new Clang
> built-ins are designed such that they will compile with older Clangs and will
> be skipped during test runs. So this shouldn't cause any build and test
> failures on systems with slightly outdated Clang compiler.
> 
> LLVM patches adding these relocation in Clang:
>   - __builtin_btf_type_id() ([0], [1], [2]);
>   - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3], [4]).
> 
>   [0] https://reviews.llvm.org/D74572
>   [1] https://reviews.llvm.org/D74668
>   [2] https://reviews.llvm.org/D85174
>   [3] https://reviews.llvm.org/D83878
>   [4] https://reviews.llvm.org/D83242

Applied.
Thank you for listing the above in the commit log, but please follow up with
corresponding update to README.rst and mention the same details there: the
symptoms of missing clang features, which tests are going to be skipped for
older clang, etc.

Also progs/test_core_reloc_type_id.c talks about some bug with
__builtin_preserve_type_info() please add llvm diff number that fixes
it to that .c file.
