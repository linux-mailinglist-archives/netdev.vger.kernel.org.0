Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49BF34C0F3
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhC2BTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhC2BT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:19:27 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFF9C061574;
        Sun, 28 Mar 2021 18:19:26 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u20so14006628lja.13;
        Sun, 28 Mar 2021 18:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Smru08tWfGhJ9MLKDXXKFDprQCfl2137QzAftLbmSd8=;
        b=XZnPqK+9YSiMlmYMG4jFoMtGolzBbImhME5shuNv7/SQZq5qVG0+dEj/AJg8fNvnrG
         vssvdJT4W5N96/83MND5IXVCZxLE1xGiSU+OFll9guGOtqahvKIBpTt4JH/4kWHCnbV2
         hxOqtfsyzUP9Z+XCPemHsvpGOdf+H3wgUkSyDaxje77TIfTWJRwuvaAqR34ziexQyfeM
         4jz7WS5LwbaUSrmAVLsAo0//0CqUV/u3LHzYh2xsc5S6SqfuLpyoXg0tCaCsaiF+sog7
         LCSW3dpnuXPXzwrnyw0V6hlnHHLwYMV7gdhqhLq9zGrvoRMIHpd8mz/mS+L25pJm6b49
         BHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Smru08tWfGhJ9MLKDXXKFDprQCfl2137QzAftLbmSd8=;
        b=KLBvzigWOqizT16tBa2JyBFYGAUS7jtHBZbw8Ad9r9Vk+ydRmWpT6Zn8r4Mr7d73yR
         +zUibi1cmNfrWe5/yfUvKUc5kt7G4Ed2/1ZogeYasNGfBlRfQLBB6Df0orF84s0hO0/I
         bHOCIe8TsFjl52Uqyjey7qAitgKC/nI7MOZtgJW+uYws0t8xQBO6btfZotLjKQdPQjzJ
         bbBoT1ZzothQK/J0yiqVadLD92oDCYSFUkMWMnWPd8O14NzRgVfeBKxeOvv1yJGjh2t9
         dEfAxNlmrldAk94rAcy1rcmtMg6oGR6bbU0a4/SGkFVIq36MWpMqXhxuNSq2mBaVzKyw
         N5RA==
X-Gm-Message-State: AOAM531CoBefxZ+N2xQ219fjnpOFIjGaB00Wder1FZfeLK6DQ8ZyYftC
        NhFl56sNZ6PdVSvy1G2OReUeDNCHdU+O9Dqls0ins3l2
X-Google-Smtp-Source: ABdhPJxjv6bwZg6lBe4uWanAuPYQSHu8ZfL/ynVJ2a/tFENiO0CpWndHR+ZZXj4ml+qxZyiTOcRJJ6PqA3oCvH8Wlnc=
X-Received: by 2002:a2e:8ec1:: with SMTP id e1mr16488718ljl.236.1616980764840;
 Sun, 28 Mar 2021 18:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210329003213.2274210-1-kafai@fb.com>
In-Reply-To: <20210329003213.2274210-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 28 Mar 2021 18:19:13 -0700
Message-ID: <CAADnVQKc2VPXN3aJTFD9Y-oMyK1wVj2NRiF6bHF_0RVzvQw+Aw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: tcp: Fix an error in the
 bpf_tcp_ca_kfunc_ids list
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 5:32 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> There is a typo in the bbr function, s/even/event/.
> This patch fixes it.
>
> Fixes: e78aea8b2170 ("bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied.
