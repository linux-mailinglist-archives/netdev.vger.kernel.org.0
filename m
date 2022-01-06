Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B719486DE3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 00:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245658AbiAFXlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 18:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245583AbiAFXlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 18:41:08 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EACDC061212;
        Thu,  6 Jan 2022 15:41:08 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id j16so3555104pll.10;
        Thu, 06 Jan 2022 15:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o74yz8L6+6jfB2t7yJMQ/dU1oEeqRAnFvYqJIOklSMM=;
        b=YQfG3ndjXDyU7Xr8KvEWdWR0nLgB27EdwMoI6hRz7tEQwtpgnkbNIOIhP6sEbtyj8w
         V6Ki4x81rY0Q6Fy2S+b8RRVHIF/g4EQGzF/4sTR77FFokEkzOrlgd6WgZr2UtngJgDg3
         cQ+2/Ta5HxcsQZ5Exspr6OBcphuY/HW6ClBFNts16sfH+brxDe8t9nROySQaVyD+o660
         g4fHOZ6p8IUOSofLkb0WNYXMxvJwlJKMEu0tF/IUA9R6nR2MrewuE3Zy3ib4Lr5BDl0A
         f9NKtyEwIVTqMlBJ+uLuQtr5F0S5DiDOvj8A6nQJRlmibZ1+VqPpCoA4I2bjAerwhgvX
         jOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o74yz8L6+6jfB2t7yJMQ/dU1oEeqRAnFvYqJIOklSMM=;
        b=G0UhSwZZ2OLymfoPx2KXjG3yZWhbRv7SNV+hAzsRvRceTpW9lZLMgaNU+YFSEvglIg
         lhq0kazhXBH054u9GFiPx1pWuvP5kVqWBiT+K3jTals9WLQ7glaAos3HW5VRTfKPEwm0
         +wWegyknHxH72d2yI2UPACSM8vXwqMI9jDKqQ5xnPp/EFW/+x2ROMbAN1QBOc+wtBaob
         txL4TzxjFRnturLX30HUeYVCOYybVGLrib92vKe9V6KXoYiq14JwW9fdRb6n3MC9f8I6
         oCNDugpfAYW6XVZQImgcmpiOlsmN2tLGnfDX2uwsw5DAJ4i5HyE1nMwDZXsYmAC8JDXd
         TdrQ==
X-Gm-Message-State: AOAM533yjozxmTtoFLzaABdwduL+zumPoOD+HG4O6ZBhfbxwvBF31GpZ
        qOC1nSe9jJyLbw4Ssj33OHdCenWwGG2Zqrf8rlA=
X-Google-Smtp-Source: ABdhPJwtjy/59anDWHfkRRBgPMKKDZmuTIxtzhlS/B1ABuPfT9lJx8gT0b+s/Ju5YRa5MBkMQ+FJ+ya8BeTUiQczPRo=
X-Received: by 2002:a17:90a:ba11:: with SMTP id s17mr12798687pjr.138.1641512467898;
 Thu, 06 Jan 2022 15:41:07 -0800 (PST)
MIME-Version: 1.0
References: <20220102162115.1506833-1-memxor@gmail.com> <20220102162115.1506833-4-memxor@gmail.com>
 <20220105061911.nzgzzvt2rpftcavi@ast-mbp.dhcp.thefacebook.com> <20220106085906.3zeugweq3twnkwzh@apollo.legion>
In-Reply-To: <20220106085906.3zeugweq3twnkwzh@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 15:40:56 -0800
Message-ID: <CAADnVQ+J+733_LU0QchkmpZz511_sCTeOAYi5MQ4YFMZQMygTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 03/11] bpf: Populate kfunc BTF ID sets in
 struct btf
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 12:59 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> I'm not insisting, but for vmlinux we will have multiple
> register_btf_kfunc_id_set calls for same hook, so we have to concat multiple
> sets into one, which may result in an unsorted set. It's ok to not sort for
> modules where only one register call per hook is allowed.
>
> Unless we switch to linear search for now (which is ok by me), we have to
> re-sort for vmlinux BTF, to make btf_id_set_contains (in
> btf_kfunc_id_set_contains) work.

Could you give an example when it happens in vmlinux?
Is it when modules are built-in (like tcp_bbr.c, tcp_cubic.c) ?
But then they should go into struct btf of the module?
Or THIS_MODULE becomes vmlinux and everything goes there?
If that's the case then yeah, sorting is needed.
Please make it clear in the comment and the commit log.
It should be clear to reviewers without having to grill the author
with questions.
Would certainly save time for both author and reviewer. Agree?
