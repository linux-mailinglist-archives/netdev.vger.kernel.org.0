Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1FC49BD5C
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 21:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiAYUmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 15:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiAYUmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 15:42:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA1DC06173B;
        Tue, 25 Jan 2022 12:42:32 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so4053237pjp.0;
        Tue, 25 Jan 2022 12:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PMctrldMf2S/f/I1l/eTo+t/ba/alGG1j0/ACCI4cdo=;
        b=LCgrEQHXMYetbj2RsqFpwyGrfHSmnxbllW6ieP+3E3Jfcigrl85BrGewMUF3XKYB8U
         LDzbq4qTTu6Ooy56H7eRjCWj1aIZjcUm9ORsUEP1oAqQ9mFVaqQX/SlVCnGgdqd8xCgI
         KyyBfkABXDF2SYkX5QH9sL5OaGYZdkK1toDoCbdWHRPBTjisUZ++VLfTmaPe7VEjj0ai
         Ig35u3OTE7VwyTwXXCUcolVQEevba2QCjXn+vVvRkqHMiO6rLixZuZ5Ij455Qw5IALmn
         6B4yjZiCfIEA3LYlDDlDI7nziuoWbAIT3KmU4tHNyZjupj6HMhxps8uoLxJg2MSdMOeh
         CRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PMctrldMf2S/f/I1l/eTo+t/ba/alGG1j0/ACCI4cdo=;
        b=uyYm/phCjWQ+pnF6R3eTx41eQF0YPFLextH9Vcl01GbkNphP0EPWaUP8gVVSAwDn+J
         i8LL74wSrl/WnS/GEnrA5apN+4g6kqYWnWfunX3oQafUq26uxV3KqUQN7cpTxzPw0g14
         A5dOJaucdI0Lmi+htYdjN7TClDM7Pk4m6MebWpwueuyKTGdxVWr0Ak9YTmAmtjiTcELL
         sUmz1uhVngD1Q/3s0U62RtarzBjGT1VPsBjKbOKtUQUAkTsAJzo67fJ85gOP+Zl4djfe
         3k0CW9k727JePD7RD8pdYTMvaH2g3gLJ6upDhtgsdzke4Z3Qbizmac1LKI9pMq2qIkPm
         Ayuw==
X-Gm-Message-State: AOAM530YMONMjbQRMkL4wP3JujNPidCGo65ZRDJv/1zOLTKHOni5Z0hV
        9U5fTZmq86/hD+SfFeJrboLvXu1mg0i3S7uQ1dw=
X-Google-Smtp-Source: ABdhPJwjoLo8t/w6QkYWkj0v+wGYitF06y/+3A18wiZw38ydPLzqPraAoJjgcHh6QhWCy/uL7RJuQ1GD1DRuURXhF/4=
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr5274812pjb.62.1643143351672;
 Tue, 25 Jan 2022 12:42:31 -0800 (PST)
MIME-Version: 1.0
References: <1b99ae14-abb4-d18f-cc6a-d7e523b25542@gmail.com> <fb79a3fb-8ada-63cc-1f33-1825dbfde481@gmail.com>
In-Reply-To: <fb79a3fb-8ada-63cc-1f33-1825dbfde481@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jan 2022 12:42:20 -0800
Message-ID: <CAADnVQ+ewS9WE3rS3LbhL4w1aND8v_JOvzKUK+ZuseGfk8Sdew@mail.gmail.com>
Subject: Re: "resolve_btfids: unresolved symbol" warnings while building v5.17-rc1
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 12:29 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On 11/15/21 16:34, Pavel Skripkin wrote:
> > Hi, net/bpf developers!
> >
> > While building newest kernel for fuzzing I met following warnings:
> >
> > ```
> >     BTFIDS  vmlinux
> > WARN: resolve_btfids: unresolved symbol tcp_dctcp_kfunc_ids
> > WARN: resolve_btfids: unresolved symbol tcp_cubic_kfunc_ids
> > WARN: resolve_btfids: unresolved symbol tcp_bbr_kfunc_ids
> >     SORTTAB vmlinux
> >
> > ```
> >
> > I haven't seen such warnings before and have no idea are they important
> > or not. Config is attached.
> >
> > My host is openSUSE Tumbleweed with gcc (SUSE Linux) 10.3.1 20210707
> > [revision 048117e16c77f82598fca9af585500572d46ad73] if it's important :)
> >
> >
>
> Hi Kumar and other net/bpf developers!,
>
> while building v5.17-rc1 (0280e3c58f92b2fe0e8fbbdf8d386449168de4a8) with
> mostly random config I met this warning
>
> ```
> WARN: resolve_btfids: unresolved symbol bpf_lsm_task_getsecid_subj
> ```

Thanks for the report.
It's already fixed in bpf tree.
