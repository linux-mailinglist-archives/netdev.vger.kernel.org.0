Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954FC4F2003
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 01:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbiDDXNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 19:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243817AbiDDXLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 19:11:43 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162182CCBE;
        Mon,  4 Apr 2022 15:49:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so9354987plg.5;
        Mon, 04 Apr 2022 15:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DiZpMTn/EVNY/pnuPoizyqHMne6cPx1y5mye2ibx/ok=;
        b=bgnp+RZ4/8nfeh0NMWErXmEtEshX86JerNFp8dq/RD44FxWiFAl972gOEJDqV++XyA
         By4VZtAU4QVALrso+XOALjElN48YFB3TiZeU9RcQxb+9XSdszdEltEwvn9K8oecLmXTQ
         TQQfzdCYgQyp4jsdjY5EwU/Uh3faCKJvnJbzu8VpGOGyjkhm+VjdOWOKNFg2CdC9WIHu
         9qKlg3mhSFcqJlntThMyi4VG3ISf3oNk+2Ry4A/oRGT+IxjxU5e24QVPCkZiEspbB6Ae
         CcLSJd1INuQNNkvMz1KILSOVf2EODqUP+szWpO3DLZgvPGzGiBVeiL6R9WCUXhOUmtMv
         ed7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DiZpMTn/EVNY/pnuPoizyqHMne6cPx1y5mye2ibx/ok=;
        b=nSCgURZ9JtxcJTR+gACePQ7grQ99Rs3SQJCalGLbJ+at5C/uDs3SiSxMp25l1hEy06
         vLzTo/Y4/4+bIaiHf4ryPBEyur+gKx+PC6L1CE8BwZbRj1v33J5h6stAYgHNs1dQyC27
         EEtaLda69g5EbVG5ZavTivO78JyH/thLvgSkEkgkS8KiWK07yg4GpV91nWfONClwId0q
         9gakhqxUbknXKhWvStYfxRkG8VVJuWJl/HfEUAlN7dB0bXdiq4uehDEUDTQ9HW9oMQky
         VTbYsyEOuNUHHJAhDmZoN2BXvagxwZnZel7ozHsvqg5F45QmItecDpsHPAcLpBw+DDDh
         5Puw==
X-Gm-Message-State: AOAM531MhNqDQmgeDTREiYYf8WTj6/maWDYT/GssIs2GpwqiBtA595Yi
        lPvLCizoW27lrkeKoGvYVMEs47HZn3ALs1YRYD0=
X-Google-Smtp-Source: ABdhPJw6yLez+Pola3pnCcu1X++dRI9Dtud1fwRlNqRru6KsE9kQoMKYHIIF+h1m/5FNxuqFspqfjNyXq2uiHfs7URQ=
X-Received: by 2002:a17:902:ba83:b0:154:727e:5fc5 with SMTP id
 k3-20020a170902ba8300b00154727e5fc5mr475882pls.55.1649112560582; Mon, 04 Apr
 2022 15:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
 <b9f5995f96da447c851f7c9db8232a9b@huawei.com> <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
 <CAEiveUcx1KHoJ421Cv+52t=0U+Uy2VF51VC_zfTSftQ4wVYOPw@mail.gmail.com> <c2e57f10b62940eba3cfcae996e20e3c@huawei.com>
In-Reply-To: <c2e57f10b62940eba3cfcae996e20e3c@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 4 Apr 2022 15:49:09 -0700
Message-ID: <CAADnVQJSso+GSXC-QmNmj0GBPZzxRCRfqAcQbqD-6y0CtMSopQ@mail.gmail.com>
Subject: Re: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF programs
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Djalal Harouni <tixxdz@gmail.com>, KP Singh <kpsingh@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 4, 2022 at 10:21 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Djalal Harouni [mailto:tixxdz@gmail.com]
> > Sent: Monday, April 4, 2022 9:45 AM
> > On Sun, Apr 3, 2022 at 5:42 PM KP Singh <kpsingh@kernel.org> wrote:
> > >
> > > On Sat, Apr 2, 2022 at 1:55 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > ...
> > > >
> > > > > Pinning
> > > > > them to unreachable inodes intuitively looked the
> > > > > way to go for achieving the stated goal.
> > > >
> > > > We can consider inodes in bpffs that are not unlinkable by root
> > > > in the future, but certainly not for this use case.
> > >
> > > Can this not be already done by adding a BPF_LSM program to the
> > > inode_unlink LSM hook?
> > >
> >
> > Also, beside of the inode_unlink... and out of curiosity: making sysfs/bpffs/
> > readonly after pinning, then using bpf LSM hooks
> > sb_mount|remount|unmount...
> > family combining bpf() LSM hook... isn't this enough to:
> > 1. Restrict who can pin to bpffs without using a full MAC
> > 2. Restrict who can delete or unmount bpf filesystem
> >
> > ?
>
> I'm thinking to implement something like this.
>
> First, I add a new program flag called
> BPF_F_STOP_ONCONFIRM, which causes the ref count
> of the link to increase twice at creation time. In this way,
> user space cannot make the link disappear, unless a
> confirmation is explicitly sent via the bpf() system call.
>
> Another advantage is that other LSMs can decide
> whether or not they allow a program with this flag
> (in the bpf security hook).
>
> This would work regardless of the method used to
> load the eBPF program (user space or kernel space).
>
> Second, I extend the bpf() system call with a new
> subcommand, BPF_LINK_CONFIRM_STOP, which
> decreases the ref count for the link of the programs
> with the BPF_F_STOP_ONCONFIRM flag. I will also
> introduce a new security hook (something like
> security_link_confirm_stop), so that an LSM has the
> opportunity to deny the stop (the bpf security hook
> would not be sufficient to determine exactly for
> which link the confirmation is given, an LSM should
> be able to deny the stop for its own programs).
>
> What do you think?

Hack upon a hack? Makes no sense.
