Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B564B1E0D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 07:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbiBKGBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 01:01:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiBKGBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 01:01:41 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125A410C1;
        Thu, 10 Feb 2022 22:01:41 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id i62so10215875ioa.1;
        Thu, 10 Feb 2022 22:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w3aXknb2G2HR+EuSrw45lq11xdturSPWe/7XDoIZqYQ=;
        b=SNtB5rTwojwU89KMZRniCT7PulmV05agUzSsG7svvllDKFUVPJBF1XncIHu0eT2YO3
         peWtvP+/MgK5kvXDwQzSn0NKkJ1FJIKq/lhlY9zfpil/UMmLhY1x+EMX0K0bSxPeBDcL
         O6DlEwFaLEMzN1knYGDeHBOV9AAq2SIbI/w30x8tVuMZHQa5C3yZs1NlGDFSDq/SfJBU
         yF01RA1Ioz+YhjWp7ps8nAgbVDIYTMrKzoGSbE2GD5vugeglxLZIR/AlxBsmxfW8Wc+k
         ozvPN+yTEg9/jKXcDwbQRexOHUhzremBQdqFO7F1AUeAOno2+Ko+V/QnRpA7DyBpGshz
         xb7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w3aXknb2G2HR+EuSrw45lq11xdturSPWe/7XDoIZqYQ=;
        b=RMMm/dVAT1tE9BML5t/4rLFAICxoFn7Uk6nujxJB/rK0GKuPUy6IuM/ekHgv7S3YLP
         axr6v44ZhVapRNcY79adczKUocJaCmox5aUPkRu/NaSKb6Zc3O6mMejPJ34/bb31xExE
         FF/3G57kUWJ6aH/0FzUVwLkO5quGDF6iLx3tFy/jrbI45vY2OP29qX0Wg6o5kbfVuAFY
         ki6VdcybXtSn7mKVH5yZiw/w+A03vRUTKQIDupUIoneTLyjNERS4xtyT3tczQkCu29Nw
         IbV+Qt4U80XRjNXSjFVDtYnRR0xf8gRzRnNKZ6sUFL1/YPWpk93jE1nthgc0b3Dve2C4
         V7oA==
X-Gm-Message-State: AOAM532zT1SYcJMiDzZdjh247w4EyQmwzTSRfaKTMgFEAqivHWaKMrnI
        Rpooku8LS4K+XYofnWC/L4Qpx/s+A92e7+xe3/I=
X-Google-Smtp-Source: ABdhPJwT+alWB28ZB1KBdtpbxYvzeumJbRLT3RmrfdXWaSdg4FxQzJBW523rqhC91JwrGqN5NycN9W6Ry0Xa8pNHTcE=
X-Received: by 2002:a05:6638:2606:: with SMTP id m6mr20060jat.93.1644559300249;
 Thu, 10 Feb 2022 22:01:40 -0800 (PST)
MIME-Version: 1.0
References: <YfK18x/XrYL4Vw8o@syu-laptop> <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
In-Reply-To: <20220210100153.GA90679@kunlun.suse.cz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Feb 2022 22:01:29 -0800
Message-ID: <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
Subject: Re: BTF compatibility issue across builds
To:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc:     Yonghong Song <yhs@fb.com>, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
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

On Thu, Feb 10, 2022 at 2:01 AM Michal Such=C3=A1nek <msuchanek@suse.de> wr=
ote:
>
> Hello,
>
> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> >
> >
> > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> > > Hi,
> > >
> > > We recently run into module load failure related to split BTF on open=
SUSE
> > > Tumbleweed[1], which I believe is something that may also happen on o=
ther
> > > rolling distros.
> > >
> > > The error looks like the follow (though failure is not limited to iph=
eth)
> > >
> > >      BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Invalid nam=
e BPF:
> > >
> > >      failed to validate module [ipheth] BTF: -22
> > >
> > > The error comes down to trying to load BTF of *kernel modules from a
> > > different build* than the runtime kernel (but the source is the same)=
, where
> > > the base BTF of the two build is different.
> > >
> > > While it may be too far stretched to call this a bug, solving this mi=
ght
> > > make BTF adoption easier. I'd natively think that we could further sp=
lit
> > > base BTF into two part to avoid this issue, where .BTF only contain e=
xported
> > > types, and the other (still residing in vmlinux) holds the unexported=
 types.
> >
> > What is the exported types? The types used by export symbols?
> > This for sure will increase btf handling complexity.
>
> And it will not actually help.
>
> We have modversion ABI which checks the checksum of the symbols that the
> module imports and fails the load if the checksum for these symbols does
> not match. It's not concerned with symbols not exported, it's not
> concerned with symbols not used by the module. This is something that is
> sustainable across kernel rebuilds with minor fixes/features and what
> distributions watch for.
>
> Now with BTF the situation is vastly different. There are at least three
> bugs:
>
>  - The BTF check is global for all symbols, not for the symbols the
>    module uses. This is not sustainable. Given the BTF is supposed to
>    allow linking BPF programs that were built in completely different
>    environment with the kernel it is completely within the scope of BTF
>    to solve this problem, it's just neglected.

You refer to BTF use in CO-RE with the latter. It's just one
application of BTF and it doesn't follow that you can do the same with
module BTF. It's not a neglect, it's a very big technical difficulty.

Each module's BTFs are designed as logical extensions of vmlinux BTF.
And each module BTF is independent and isolated from other modules
extension of the same vmlinux BTF. The way that BTF format is
designed, any tiny difference in vmlinux BTF effectively invalidates
all modules' BTFs and they have to be rebuilt.

Imagine that only one BTF type is added to vmlinux BTF. Last BTF type
ID in vmlinux BTF is shifted from, say, 1000 to 1001. While previously
every module's BTF type ID started with 1001, now they all have to
start with 1002 and be shifted by 1.

Now let's say that the order of two BTF types in vmlinux BTF is
changed, say type 10 becomes type 20 and type 20 becomes type 10 (just
because of slight difference in DWARF, for instance). Any type
reference to 10 or 20 in any module BTF has to be renumbered now.

Another one, let's say we add a new string to vmlinux BTF string
section somewhere at the beginning, say "abc" at offset 100. Any
string offset after 100 now has to be shifted *both* in vmlinux BTF
and all module BTFs. And also any string reference in module BTFs have
to be adjusted as well because now each module's BTF's logical string
offset is starting at 4 logical bytes higher (due to "abc\0" being
added and shifting everything right).

As you can see, any tiny change in vmlinux BTF, no matter where,
beginning, middle, or end, causes massive changes in type IDs and
offsets everywhere. It's impractical to do any local adjustments, it's
much simpler and more reliable to completely regenerate BTF
completely.

If it was reasonable to support what you are asking for, I'd probably
already have done that a long time ago.

>  - It is possible to load modules with no BTF but not modules with
>    non-matching BTF. Surely the non-matching BTF could be discarded.

We started out with strict behavior like this to be able to detect any
problems with module BTFs instead of silently ignoring them. It seems
like that worked, we do know about this problem acutely. But as Alexei
said, relaxing this is the simplest way forward. It could be easily
controlled by new Kconfig value, so that default strict behavior can
be preserved as well.


>  - BTF is part of vermagic. This is completely pointless since modules
>    without BTF can be loaded on BTF kernel. Surely it would not be too
>    difficult to do the reverse as well. Given BTF must pass extra check
>    to be used having it in vermagic is just useless moise.
>
> > > Does that sound like something reasonable to work on?

No, at least not to me. Splitting vmlinux BTF into two parts (internal
and external) doesn't help with anything, see above explanation.

> > >
> > >
> > > ## Root case (in case anyone is interested in a verbose version)
> > >
> > > On openSUSE Tumbleweed there can be several builds of the same source=
. Since
> > > the source is the same, the binaries are simply replaced when a packa=
ge with
> > > a larger build number is installed during upgrade.
> > >
> > > In our case, a rebuild is triggered[2], and resulted in changes in ba=
se BTF.
> > > More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 =
cpec,
> > > struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *=
h,
> > > struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those func=
tions
> > > are previously missing in base BTF of 5.15.12-1.1.
> >
> > As stated in [2] below, I think we should understand why rebuild is
> > triggered. If the rebuild for vmlinux is triggered, why the modules can=
not
> > be rebuild at the same time?
>
> They do get rebuilt. However, if you are running the kernel and install
> the update you get the new modules with the old kernel. If the install
> script fails to copy the kernel to your EFI partition based on the fact
> a kernel with the same filename is alreasy there you get the same.

Isn't this failure to copy a new kernel a failure in itself? I'd blame
module BTF the last in this scenario, but maybe I don't understand the
case completely.

>
> If you have 'stable' distribution adding new symbols is normal and it
> does not break module loading without BTF but it breaks BTF.

You don't even need to add a new symbol. Just change the order of
types in DWARF information and you get a different (though equivalent)
BTF type ID numbering which invalidates module BTFs just as much. I'm
not saying it's a feature, but it isn't a bug either, IMO. Technical
decisions and tradeoffs.

>
> Thanks
>
> Michal
