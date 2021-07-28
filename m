Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F41F3D85CA
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 04:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhG1CH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 22:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhG1CH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 22:07:56 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2BBC061757;
        Tue, 27 Jul 2021 19:07:54 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c16so831100plh.7;
        Tue, 27 Jul 2021 19:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5mXMjFPqPwFYqgDq1yqkwzfqi2rFOlo0l2pItgAk0Ng=;
        b=MdLIJXGQlUxFzYCyWYJRYBGi5eFuhpyYUtSmbbHTYV0IubJLEhICHBM+kQKOXcugaS
         rJ9zFAFusLuHPGz0dHF7l0j2NLF4Tdp94IEiZ+ScPhrudkWYpe5h/luZzzMe8u/Z5z8k
         fbnOmWmLitck4SSADPA3zeAKpb1To3Dkh1lpqX7Do1J0ogQFyQ+RTI2cEYjSpVW/j0l/
         AdcBV7tT3LtcPNTM1HAhRQexmT0lrP/nplvwD+IcPjgksZ2QTOBvo9eZ7AEhx00LU4gL
         6uJ9XsJoTBUJIxZ8IUyru8zMxCu8ka3soqsZVflM3U5Ek+J3Js1HiMz6e51zqoIWHY4f
         Df/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5mXMjFPqPwFYqgDq1yqkwzfqi2rFOlo0l2pItgAk0Ng=;
        b=Uyhtp7dl23z09JC1aAF9mB+4SXMVRLYVNgdx+VyVCBt4fG3P49Yq/J/S9SV54qJWHR
         OCkwXRv95mo8cc0c1qHuAEbTNR/RQ+D+XChVpPvO+smQLK0X+bT2pKbYR11IXyykFH4G
         O2Dqrxp07wm/8rMYCTgkjxNwL75jr6GLMYNrCzMFKZhF2pEx+wB67gD70hM8K1TQVVk5
         6ly+lepe9GMZlpH0c/ESHbX5GuIjFOBqBHEZTr2A/rwfQiogmgFRGYdLNNOPONER0RUR
         Ky4lTFctjfZGkIlSAvgnSd0OjsE1RyVQGPs1/2ZJJwfF97DHjhOELqmhamgPFkoezzg9
         muKw==
X-Gm-Message-State: AOAM532mWKtk/eHMdKvJfGb9vveUYFwR1RtyL/0N0rDMaj5wj9pWdbe6
        NQWaua52OpAJHKgh8luOkTNHzQitXoWX5Z+sGVU=
X-Google-Smtp-Source: ABdhPJyPZXkdPgV465qK/iIZ6+cZ7aKV9G8U3swzQ+rDg0M1oNPMtKGj9dHG7T6zOPdzBZ+62F6s1uiYRvC544TCAm0=
X-Received: by 2002:a05:6a00:26e5:b029:330:be3:cacd with SMTP id
 p37-20020a056a0026e5b02903300be3cacdmr25949003pfw.78.1627438074471; Tue, 27
 Jul 2021 19:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-3-jiang.wang@bytedance.com> <6100363add8a9_199a412089@john-XPS-13-9370.notmuch>
In-Reply-To: <6100363add8a9_199a412089@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Jul 2021 19:07:43 -0700
Message-ID: <CAM_iQpVedTzRbf-bC7WuGMFYF=qnUxbnUdqJ9+FaxrTAn5DkTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/5] af_unix: add unix_stream_proto for sockmap
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jiang Wang <jiang.wang@bytedance.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 9:37 AM John Fastabend <john.fastabend@gmail.com> wrote:
> Do we really need an unhash hook for unix_stream? I'm doing some testing
> now to pull it out of TCP side as well. It seems to be an artifact of old
> code that is no longer necessary. On TCP side at least just using close()
> looks to be enough now.

How do you handle the disconnection from remote without ->unhash()?

For all stream sockets, we still only allow established sockets to stay
in sockmap, which means we have to remove it if it is disconnected
or closed.

But it seems Jiang forgot to call ->unhash() when disconnecting.

Thanks.
