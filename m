Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E342A8E1A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 05:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKFELq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 23:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKFELq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 23:11:46 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438F5C0613CF;
        Thu,  5 Nov 2020 20:11:46 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id l2so55537lfk.0;
        Thu, 05 Nov 2020 20:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1t+DyFGBu7TMnMe6PTT1F2bobTRLrvcc45IDlkNv7jM=;
        b=jjmaoF36k8DKHkB/9SOXaG2rf+G+DYXFAoyrPsno2lWYMIk7ZggVDZXwj/xE+zJIDK
         RTYRpus8gfBl41fvnblUvs7q3e4WcvdHnBOlyVy7AgLKWxKIMZb7QsmhPSH8BFza6YJF
         2PkU5O1u5nF3IM+zdPamUQjp6S1mw9J78ib/inwt2c/oKQTD3DShI7e8Na2O624+XeMC
         zhnBhUL5ZgoYNOxPJuruL99UJ9dm9m5sVK8rHqEI2CAoK9eNWBJiWw5Lp0qUrgY98dji
         9V6FR6/pzqQZMHR/ZnSjIZARbvfkRKcLFc+Ar60bywYBUGBXt+p5Ni4jCPXX24vYvsYP
         J1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1t+DyFGBu7TMnMe6PTT1F2bobTRLrvcc45IDlkNv7jM=;
        b=HMaT3BM2yKl2YjrJjeBG4FqJQceEjuqjBboloQHawNqGbuJpQCJy1aAQE+ZwMcPRTC
         EvsosTQyk4RYQjQlUlTgncTNhqoNnxXb0W3U29oEz6Cp1QfxTQo4pQuxOOD9g/p4nyab
         hJllMAtoxZka460BgvpjsxGWoO77KvhDAoGrg7Hg5IFgcT3241BAve0TKuqmHs70UFj6
         v4VyRo02o5rVTcEYNgRp9nG+cGOyhqSfQovAAaqdMVHQuhwDBrVO7Quuf1W09awP8Bjh
         A5LMpgvgpx6W84iF6NuZGX8kAHe+7iB+J/Hu52zAA85hhMTUXOQt1p8rmvJU4qpSp2F4
         zgpg==
X-Gm-Message-State: AOAM532JPP5RWYMI28BoEpMZIM+by+br5liqN/E+OG+hGnef/bBJcnZF
        ZYZUNGsyMzy0Xj/T3Z0/W7+1S0JfKbCAEL+ZuEY=
X-Google-Smtp-Source: ABdhPJybmji3JQgQ5CHsonkE9Y65p/bburT5aQ7oCcuhrmZlcpioHJwHggx32V5RWjw9VYDHg3G/005oddc8YRmWsJ0=
X-Received: by 2002:a05:6512:32a4:: with SMTP id q4mr92771lfe.477.1604635904761;
 Thu, 05 Nov 2020 20:11:44 -0800 (PST)
MIME-Version: 1.0
References: <20201029201442.596690-1-dev@der-flo.net> <CAEf4BzaR8D1tHSN+s4xjqdHc1ScL_O13E7fsyYgsD=Cj8vohmQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaR8D1tHSN+s4xjqdHc1ScL_O13E7fsyYgsD=Cj8vohmQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 5 Nov 2020 20:11:33 -0800
Message-ID: <CAADnVQJL574xA3WkdvQa1N-rk81OToTDNbkBVM_n1VR1ZqQCSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] bpf: Lift hashtab key_size limit
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Florian Lehner <dev@der-flo.net>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 1:38 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 1:16 PM Florian Lehner <dev@der-flo.net> wrote:
> >
> > Currently key_size of hashtab is limited to MAX_BPF_STACK.
> > As the key of hashtab can also be a value from a per cpu map it can be
> > larger than MAX_BPF_STACK.
> >
> > The use-case for this patch originates to implement allow/disallow
> > lists for files and file paths. The maximum length of file paths is
> > defined by PATH_MAX with 4096 chars including nul.
> > This limit exceeds MAX_BPF_STACK.
> >
> > Changelog:
> >
> > v5:
> >  - Fix cast overflow
> >
> > v4:
> >  - Utilize BPF skeleton in tests
> >  - Rebase
> >
> > v3:
> >  - Rebase
> >
> > v2:
> >  - Add a test for bpf side
> >
> > Signed-off-by: Florian Lehner <dev@der-flo.net>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > ---
>
> LGTM.
> Acked-by: Andrii Nakryiko <andrii@kernel.org>

Applied.
Sorry for the delay. The patch got lost in patchwork.
