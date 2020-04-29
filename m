Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC571BD133
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD2Ad3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726274AbgD2Ad2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:33:28 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC3DC03C1AC;
        Tue, 28 Apr 2020 17:33:28 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o185so172635pgo.3;
        Tue, 28 Apr 2020 17:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6scFRPeF1FJKdxvlENRi3WSFxupq2F2QcqZVK0DBTU0=;
        b=BubY9+h0FKrwer5J4NQZIm3Kc+DjxBbl6VGDJsG9zqKWyD727Ay2IEFMMiSTefkZ6O
         WDMdsWEhNyegFvnPL8SbANLBGU/QxbuB4VzjLh31cVEgzOax6qBvbucJhaACZIVuszd1
         a1GgGZzkHX9D1XbTkyp/s4pXVC2ZivyTB7Tflv90l4snHvtsruwGaFfrCb20cKGaVFsg
         bDNNlmqvEWtUGzDY7tanadvrK/Qt/swJsiWDkxd5p6v9awkvYo6rCEoZAdQtNeZgSUgc
         xvWb97JOM+SbTr6FEFrd0OZ77sezBXnz27lqUB6BV9wSn9spNH0Hztx5RVJo/RFJXNUa
         Ctuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6scFRPeF1FJKdxvlENRi3WSFxupq2F2QcqZVK0DBTU0=;
        b=gajDvS/oIVqEc3jgOXnYG0hSJEMJDaRxyU214FbzadtKtZRl0nIcSXG8FJavAV/9LG
         qxfdbEYqfbDLRmPivsm5EI7H6b99yH5fKpWlMrqTPl0eaDvvlSKzBqF5/hIv1S6IlGuB
         Gyrt8F/yQKo0uerDLzNEuNz0DTwiGWTl3ofxFLDufk1SYVBoK/LwRiupS3OB23/9TS0x
         C+BmgVomINU6AYCuPPU6gRkFUUnS2LuYKQoZxfe1h4LO4i2OSEy5O3FW4tjVShjfJcPH
         AE0vVvZViC0oaZ21JEDxwZfcz7NrdrhvNFWG8c5XfWETM+DikjBKTI5jJ0GpU9s3ZFXL
         OtCw==
X-Gm-Message-State: AGi0PuY0xkHpb+UplFOYWP5G00B4IRzlfe9/NRtw+R21IWirA9uRlMlM
        +jbH3/dFbxEP8dKMJuMtc9c=
X-Google-Smtp-Source: APiQypJBhqxFedDe5F7cMnZGiyuDRgwC4lgUfGy4nc6o3I9XycrG5PKd8ZrUcV8gDhu4oEOLFI8kqw==
X-Received: by 2002:a63:651:: with SMTP id 78mr29534041pgg.129.1588120407876;
        Tue, 28 Apr 2020 17:33:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id a16sm15978842pff.41.2020.04.28.17.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 17:33:27 -0700 (PDT)
Date:   Tue, 28 Apr 2020 17:33:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 00/10] bpf_link observability APIs
Message-ID: <20200429003324.afboiyqnxjxry6pg@ast-mbp.dhcp.thefacebook.com>
References: <20200429001614.1544-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429001614.1544-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:04PM -0700, Andrii Nakryiko wrote:
> This patch series adds various observability APIs to bpf_link:
>   - each bpf_link now gets ID, similar to bpf_map and bpf_prog, by which
>     user-space can iterate over all existing bpf_links and create limited FD
>     from ID;
>   - allows to get extra object information with bpf_link general and
>     type-specific information;
>   - implements `bpf link show` command which lists all active bpf_links in the
>     system;
>   - implements `bpf link pin` allowing to pin bpf_link by ID or from other
>     pinned path.
> 
> v2->v3:
>   - improve spin locking around bpf_link ID (Alexei);
>   - simplify bpf_link_info handling and fix compilation error on sh arch;
> v1->v2:
>   - simplified `bpftool link show` implementation (Quentin);
>   - fixed formatting of bpftool-link.rst (Quentin);
>   - fixed attach type printing logic (Quentin);
> rfc->v1:
>   - dropped read-only bpf_links (Alexei);
>   - fixed bug in bpf_link_cleanup() not removing ID;
>   - fixed bpftool link pinning search logic;
>   - added bash-completion and man page.

Applied, Thanks
