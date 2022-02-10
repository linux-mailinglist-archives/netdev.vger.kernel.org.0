Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429984B1841
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345004AbiBJWfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:35:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345016AbiBJWfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:35:08 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B162651;
        Thu, 10 Feb 2022 14:35:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x4so3125072plb.4;
        Thu, 10 Feb 2022 14:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yio3W8tU7n6Og6i8QNkADT/VmqN2wsuwvdvGfDcg6S8=;
        b=XtDuBR+Rc+YSVXSa8hxzBmpWMGzgBjHssP4129RTobqnhJ+4fom6J87SPOLTCtaZDs
         8y2nuEaTJUh8nEtpbSX3uQlQIFTbYrswJKe3MTVkPkWVzz7dLVboKP/98qve/sTyu7WR
         0kWJ66FCKLYtKbtwFQS++TznWra9elS2KLvk+w2L/m1ZoZu2MTZ0tkRhKXjLWGAIGGvv
         KY+AeKjF+HTzUP6uVjDlrH/fTP8bIfMRCQ34hghK1wowAQQVpsLdRObpV4Wyk6RjhDlz
         pMppIb+ge7X4gtLvve6s3oEj8aZppmD5XxafDFszwY1Wjxs8K0WEaUDNniGtmQkweRBL
         bL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yio3W8tU7n6Og6i8QNkADT/VmqN2wsuwvdvGfDcg6S8=;
        b=wtQ9y/u9ZdPEZ+ifxPoc/0YBa+5d4DmJHl0iBaAuKE6tCES7aSWDEEr5uS50CVQICA
         an8OLT56st5YqrhExNTkp6mOE5Z0zvRT13/+Rd0m4rTpE6Bwlxax6V0ZlQUv9rqrtn1Y
         53GPqS9ERcl65RZJBmw1oYv7ZC5LUlsmicHLo5z+upe/idbUt4oHHThX3ByRK5UnFsEE
         j4x6gJXQ/oHYsCQM2UQ3QfBpsF+S18x1ns7Z3dt+r11mu0TT9JloiHnMYEP81jvy9umL
         +3RCFVhu5vgXsreFjq3g0MdoyMRbYVq2PijTJjffWkjhvvkSCx7F7zb2u9WR/REumor0
         +qvQ==
X-Gm-Message-State: AOAM533nJSF+rgRkPQZq6pHpFqGA0TB8rX0KpmpWzFTsmk7TKiY1tJXb
        zuYdGfCzOnS9YFAN4FyVoRrdIQeRU69y1OsNX9o=
X-Google-Smtp-Source: ABdhPJw0o7eKGEYp9LjH4HpPbylWZYPCTplKb4zimxIuM7WQr+9Bc0ZimQJ8K9GhOmqshIYoaFIudXnnRCG6a2NDVTk=
X-Received: by 2002:a17:902:d4ca:: with SMTP id o10mr1924732plg.116.1644532508702;
 Thu, 10 Feb 2022 14:35:08 -0800 (PST)
MIME-Version: 1.0
References: <YfK18x/XrYL4Vw8o@syu-laptop> <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz> <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
In-Reply-To: <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Feb 2022 14:34:57 -0800
Message-ID: <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
Subject: Re: BTF compatibility issue across builds
To:     Yonghong Song <yhs@fb.com>, "Connor O'Brien" <connoro@google.com>
Cc:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 2/10/22 2:01 AM, Michal Such=C3=A1nek wrote:
> > Hello,
> >
> > On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> >>
> >>
> >> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> >>> Hi,
> >>>
> >>> We recently run into module load failure related to split BTF on open=
SUSE
> >>> Tumbleweed[1], which I believe is something that may also happen on o=
ther
> >>> rolling distros.
> >>>
> >>> The error looks like the follow (though failure is not limited to iph=
eth)
> >>>
> >>>       BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Invalid na=
me BPF:
> >>>
> >>>       failed to validate module [ipheth] BTF: -22
> >>>
> >>> The error comes down to trying to load BTF of *kernel modules from a
> >>> different build* than the runtime kernel (but the source is the same)=
, where
> >>> the base BTF of the two build is different.
> >>>
> >>> While it may be too far stretched to call this a bug, solving this mi=
ght
> >>> make BTF adoption easier. I'd natively think that we could further sp=
lit
> >>> base BTF into two part to avoid this issue, where .BTF only contain e=
xported
> >>> types, and the other (still residing in vmlinux) holds the unexported=
 types.
> >>
> >> What is the exported types? The types used by export symbols?
> >> This for sure will increase btf handling complexity.
> >
> > And it will not actually help.
> >
> > We have modversion ABI which checks the checksum of the symbols that th=
e
> > module imports and fails the load if the checksum for these symbols doe=
s
> > not match. It's not concerned with symbols not exported, it's not
> > concerned with symbols not used by the module. This is something that i=
s
> > sustainable across kernel rebuilds with minor fixes/features and what
> > distributions watch for.
> >
> > Now with BTF the situation is vastly different. There are at least thre=
e
> > bugs:
> >
> >   - The BTF check is global for all symbols, not for the symbols the
> >     module uses. This is not sustainable. Given the BTF is supposed to
> >     allow linking BPF programs that were built in completely different
> >     environment with the kernel it is completely within the scope of BT=
F
> >     to solve this problem, it's just neglected.
> >   - It is possible to load modules with no BTF but not modules with
> >     non-matching BTF. Surely the non-matching BTF could be discarded.
> >   - BTF is part of vermagic. This is completely pointless since modules
> >     without BTF can be loaded on BTF kernel. Surely it would not be too
> >     difficult to do the reverse as well. Given BTF must pass extra chec=
k
> >     to be used having it in vermagic is just useless moise.
> >
> >>> Does that sound like something reasonable to work on?
> >>>
> >>>
> >>> ## Root case (in case anyone is interested in a verbose version)
> >>>
> >>> On openSUSE Tumbleweed there can be several builds of the same source=
. Since
> >>> the source is the same, the binaries are simply replaced when a packa=
ge with
> >>> a larger build number is installed during upgrade.
> >>>
> >>> In our case, a rebuild is triggered[2], and resulted in changes in ba=
se BTF.
> >>> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 =
cpec,
> >>> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *=
h,
> >>> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those func=
tions
> >>> are previously missing in base BTF of 5.15.12-1.1.
> >>
> >> As stated in [2] below, I think we should understand why rebuild is
> >> triggered. If the rebuild for vmlinux is triggered, why the modules ca=
nnot
> >> be rebuild at the same time?
> >
> > They do get rebuilt. However, if you are running the kernel and install
> > the update you get the new modules with the old kernel. If the install
> > script fails to copy the kernel to your EFI partition based on the fact
> > a kernel with the same filename is alreasy there you get the same.
> >
> > If you have 'stable' distribution adding new symbols is normal and it
> > does not break module loading without BTF but it breaks BTF.
>
> Okay, I see. One possible solution is that if kernel module btf
> does not match vmlinux btf, the kernel module btf will be ignored
> with a dmesg warning but kernel module load will proceed as normal.
> I think this might be also useful for bpf lskel kernel modules as
> well which tries to be portable (with CO-RE) for different kernels.

That sounds like #2 that Michal is proposing:
"It is possible to load modules with no BTF but not modules with
 non-matching BTF. Surely the non-matching BTF could be discarded."

That's probably the simplest way forward.

The patch
https://patchwork.kernel.org/project/netdevbpf/patch/20220209052141.140063-=
1-connoro@google.com/
shouldn't be necessary too.
