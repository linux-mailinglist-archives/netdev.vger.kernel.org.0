Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F634CFFCF
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 14:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242814AbiCGNTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 08:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbiCGNTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 08:19:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AE028985
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 05:18:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1390B61204
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767ACC36AED
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646659088;
        bh=0x9avxE1QuPb1xRSPHVfHgo20smbkC0ezQPHmsX583Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fdfnW2FlS2s/NtI9OIEPoL3friIZhn4gB+q9ykNTwU5vvuw+nEflebKpQ3V3Pf4Lq
         z1BWhCICYLQtHghvBBeeuVJezZ3Hf6PZ3w+svus4UbBeUsvAyA0WgXS5q6PEXrcohQ
         U23e8nTBn7HGvs9ksItlQIjmC62kxSbWB5GB4c5VWjL7CJVUNiioReQrUB0b+B0izG
         3192CzMmcsmDuN9waHQVmNKjgENwZ5u7B40kB4aazoknGByseLS7kWkeZnji6uljzW
         qp6gKFVNXu3ojloMsNRa7sUIp/hh1PyEtMUFyfS2vflRdTLJz7zczBt/r6E6axLPhR
         2anp04mEGAqyA==
Received: by mail-ej1-f47.google.com with SMTP id dr20so31808642ejc.6
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 05:18:08 -0800 (PST)
X-Gm-Message-State: AOAM532xHBbDxwlKQ3AXHulSYp4kLzE6eQGBx0fIiFTi4Lvzo71UvLyb
        x7GoBGTK2b2DaGemB6MsLbE+In+MdEcxEbotRLobIw==
X-Google-Smtp-Source: ABdhPJxvgCXjgHPF1PjOKJm57sEpqWrgNtbAss/mIVzf2hdDQwOt3w5GqYZan1KufyCv5U1e45adv0v2fXT5T3kQmJk=
X-Received: by 2002:a17:906:a1c8:b0:6da:a635:e402 with SMTP id
 bx8-20020a170906a1c800b006daa635e402mr9441257ejb.598.1646659086280; Mon, 07
 Mar 2022 05:18:06 -0800 (PST)
MIME-Version: 1.0
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
 <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
 <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
 <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com>
 <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
 <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com>
 <b6bf8463c1b370a5b5c9987ae1312fd930d36785.camel@linux.ibm.com>
 <CAADnVQKfh3Z1DXJ3PEjFheQWEDFOKQjuyx+pkvqe6MXEmo7YHQ@mail.gmail.com> <40db9f74fd3c9c7b660e3a203c5a6eda08736d5b.camel@linux.ibm.com>
In-Reply-To: <40db9f74fd3c9c7b660e3a203c5a6eda08736d5b.camel@linux.ibm.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 7 Mar 2022 14:17:55 +0100
X-Gmail-Original-Message-ID: <CACYkzJ65D2OZKrEbrCS32+FsQ3BVzs1zQcRQSLnaNQHYTjZFBA@mail.gmail.com>
Message-ID: <CACYkzJ65D2OZKrEbrCS32+FsQ3BVzs1zQcRQSLnaNQHYTjZFBA@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florent Revest <revest@google.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 7, 2022 at 3:57 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Thu, 2022-03-03 at 14:39 -0800, Alexei Starovoitov wrote:
>
> > . There is no such thing as "eBPF modules". There are BPF programs.
> > They cannot be signed the same way as kernel modules.
> > We've been working on providing a way to sign them for more
> > than a year now. That work is still ongoing.
> >
> > . IMA cannot be used for integrity check of BPF programs for the same
> > reasons why kernel module like signing cannot be used.
>
> I assume the issue isn't where the signature is stored (e.g. appended,
> xattr), but of calculating the hash.  Where is the discussion taking

This has the relevant background: https://lwn.net/Articles/853489/

We had some more discussions in one of our BSC meeting:

https://github.com/ebpf-io/bsc/blob/master/minutes.md

and we expect the discussions to continue over conferences this year
 (e.g. LSF/MM/BPF, Linux Plumbers). As I mentioned on another thread
we don't have to wait for conferences and we can discuss this in the BPF
office hours. Please feel free to add an agenda at:

https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU/edit#gid=0

(best is to give some notice so that interested folks can join).

> place?   Are there any summaries of what has been discussed?
>
> FYI, IMA isn't limited to measuring files.  Support was added for
> buffer measurements (e.g kexec boot command line, certificates) and
> measuring kernel critical data (e.g. SELinux in memory policy & state,
> device mapper).

Nice. I need to look at how this is implemented.

- KP

>
> thanks,
>
> Mimi
>
