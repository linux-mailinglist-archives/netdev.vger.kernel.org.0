Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0F1484E53
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 07:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiAEGUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 01:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiAEGUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 01:20:36 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF422C061761;
        Tue,  4 Jan 2022 22:20:35 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so2479269pjd.1;
        Tue, 04 Jan 2022 22:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bNwe4oIcNb/8JXdCal8u+s4Xw1CuZ9aIVgP9glbDtco=;
        b=dCyW8DOgj90bOP8wmVsBFogAWY9+gG/gsBtEmyMXXZCQF8yglSfQZAqDh15JS/ONWM
         umaLiincH5L9pfRKkpxy+SPo/Nhuqk7IMSv9JLyI6BBSkYzZhw9rDkARjYsSFaF4ol7c
         3ocftncsqPstC7UADU9xBf0k2p2DfHFDqxkRtBav8hqpcp9roR64NWqQ3y6BtqSI+FXB
         UmfKsXGMwKgACq3phz1j25WaYDe4YVAHjEyMECr24OLNbN+1gQ0/Xg6Qvl3pQ7goYPl9
         SIsfGQtQshq6CVyAonxoIRKDXKAJdFOJBknQkZVgF+DpDwNjUrfnGod5Rhr1XPieNA4T
         H9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bNwe4oIcNb/8JXdCal8u+s4Xw1CuZ9aIVgP9glbDtco=;
        b=eA6clVsR0hJ9nMcOqa0lesoy/O5QcvV/YF/sNrlli4+rP+RLq536Xdmj9+DD+6AH2q
         mUxl2kErUUr6DSb2bMZGm5U8seZYlKkOYQLaHrIt59t5rttEVOqN9ov0Mzv3pkM6VR1S
         zoOypZHMpEhDWuAXP1Q9ooQOVIvoutaFS7Ad8GHy6AEgvRl7xpfxYKCUqjNNtPDxVVM6
         uViJZK5F4yyQeUKE5Iw4gr5DlSbAmDR3GGuH3bukzosws9QRaBnyQIINOlUc/49JBSXS
         iXlRpJYJ2ggRmWyJnvwSdNGKzUaLfjVo6HAUZedNQtb64mtnoBbfZA0K2HfB6SgNMhDz
         saTA==
X-Gm-Message-State: AOAM532Jhu7Ez8z3GVpmAk72/V133sdjLFIWbVidVSkaHUflKNOonRSk
        giQCBce9kDcq8LYfX6+J75s=
X-Google-Smtp-Source: ABdhPJxAeaPLqvLVQR8dKtSmvogxTaoXFFfUf/ptgt7BnA0OK2zlnTHbXhBgLs14AYYAQxTihcSxFg==
X-Received: by 2002:a17:90b:1b0a:: with SMTP id nu10mr2359860pjb.198.1641363635306;
        Tue, 04 Jan 2022 22:20:35 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1a5b])
        by smtp.gmail.com with ESMTPSA id r10sm42977627pff.120.2022.01.04.22.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 22:20:35 -0800 (PST)
Date:   Tue, 4 Jan 2022 22:20:33 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v6 11/11] selftests/bpf: Add test for race in
 btf_try_get_module
Message-ID: <20220105062033.lufu57xhpyou3sie@ast-mbp.dhcp.thefacebook.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-12-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220102162115.1506833-12-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 09:51:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> This adds a complete test case to ensure we never take references to
> modules not in MODULE_STATE_LIVE, which can lead to UAF, and it also
> ensures we never access btf->kfunc_set_tab in an inconsistent state.
> 
> The test uses userfaultfd to artifically widen the race.

Fancy!
Does it have to use a different module?
Can it be part of bpf_testmod somehow?
