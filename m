Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F413083E2
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhA2CkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhA2Cjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 21:39:52 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB00C061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 18:39:12 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id l9so10830814ejx.3
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 18:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BID6SO1xOhKk07Zjt0/WPF4F34uCsYcMcFNqdy8GKns=;
        b=c6G9l6vAtnVDn1ekbrY/Edafy0LS7kNV0MP7da8MIrERgNr6L5HRgvWV2F59jYRNG2
         1/wOeK35zQ9Y474hdRMRkI1zz9tZEklZwTksVQcK58eZzKerVrc4N9PkdezI7je2ZGIz
         LTrBgO1sybF5gPqBhazWRt3yUZX1gbrl9imEWKil7Dlzxzq4kusTzib4Az4PEfWpL5Jj
         E4VEG9SkqWicm49legynNRPLkdjQtPcGQ7CHdIW9FrB/uV+zNvn4EKKvoygERwwGII4f
         qZGS1n+JEEUWvezLzfN+ZpjSWw4FkZU35PHkEdHc+fxmxycflRA8eWKZCHjWsFyY2jmT
         JCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BID6SO1xOhKk07Zjt0/WPF4F34uCsYcMcFNqdy8GKns=;
        b=stoVJFOBdGc7Zukc2E04VNI/tAHEwmRf8nNUHEc7z3tp9S4m3UPcnBg2qJZNpG3HoL
         c1F1hpKbTx6eApktMk3+CNTipZt57Mj6TGSHd7MPaiEKVmbLW27BwgHlvjMZOF8dG/xF
         Ln3zmyngPTj5LQVh2JOumWQkDCAhTzqp36qZEYa4PKqc8GPgwWCbNJpQELatpFY6scvi
         e92FvknRYVjwLQCNvU+Rqzbf0b6vC6PHoJ0M8vuC6OXdEuDpk7G+l9x+ySaYUi/0a0GU
         xSy1eIgK/dYyCyRKLjg2AWUsN4b6y1SjAYhw+AceBgVI5TkpoPTNAypsLnJQ6IA7OuZh
         QtxA==
X-Gm-Message-State: AOAM531/RVUvZGWOkvEUmGZc65vTK4s6HWl82EsgAeBkjzqSFET9und/
        yuqn+bVV3aVpl3BkKfiCnqsiqoPymBa7Xsds2OwDXWTS
X-Google-Smtp-Source: ABdhPJzx6HJCsme2H+2C0fzJCxUTmKOne0os7F9ADxHczUb7w2i/0UrPy1j6bxr6n/4to/y4OhA+s1bE+dXvWwqEObk=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr2372541ejk.538.1611887950954;
 Thu, 28 Jan 2021 18:39:10 -0800 (PST)
MIME-Version: 1.0
References: <1611882159-17421-1-git-send-email-vfedorenko@novek.ru> <CAF=yD-Lmk+nuUWKK+HcoALyPY_xr9rMU_+AsfgAAB0+vCOijRw@mail.gmail.com>
In-Reply-To: <CAF=yD-Lmk+nuUWKK+HcoALyPY_xr9rMU_+AsfgAAB0+vCOijRw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 21:38:34 -0500
Message-ID: <CAF=yD-K2sjoMVWo0rV-3O8oPbQ-TF6bsCMVSOAx1tYjPJzi=rQ@mail.gmail.com>
Subject: Re: [net v2] net: ip_tunnel: fix mtu calculation
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Willem de Bruijn <willemdebruijn.kernel@gmail.com>--to=Slava Bacherikov" 
        <mail@slava.cc>, Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 9:21 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 8:02 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> >
> > dev->hard_header_len for tunnel interface is set only when header_ops
> > are set too and already contains full overhead of any tunnel encapsulation.
> > That's why there is not need to use this overhead twice in mtu calc.
> >
> > Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
> > Reported-by: Slava Bacherikov <mail@slava.cc>
> > Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>
> Acked-by: Willem de Bruijn <willemb@google.com>
>
> It is easy to verify that if hard_header_len is zero the calculation
> does not change. And as discussed, ip_gre is the only ip_tunnel
> user that sometimes has it non-zero (for legacy reasons that
> we cannot revert now). In that case it is equivalent to tun->hlen +
> sizeof(struct iphdr). LGTM. Thanks!

Actually, following that reasoning, we can just remove
dev->hard_header_len from these calculations, no need for branching.


>
> Btw, ip6_gre might need the same after commit 832ba596494b
> ("net: ip6_gre: set dev->hard_header_len when using header_ops")
