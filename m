Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B594CAC62
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbiCBRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 12:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbiCBRrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:47:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADCAD048D;
        Wed,  2 Mar 2022 09:46:47 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 77E661F37E;
        Wed,  2 Mar 2022 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646243206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMbcdpBbIinSLQvZoRT1fsWp5d0Ubaf6+r5t7qhGPes=;
        b=ts7AW2kOSBadKVSj1oKXNBIF8UW2eUfUBb4MOUFWZeWZQYK4dNcmI/9HfGPOJhuM3UEk0E
        zso5pal8eo2O38MYz3eZ32t8Pf80bwqq7xpeDcDFAE1tbkWh8W4dBPQx0AqtpR6IJuKeon
        M28Db8OJ9MrcFo/p7WjJZtVf/iZ9Jdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646243206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMbcdpBbIinSLQvZoRT1fsWp5d0Ubaf6+r5t7qhGPes=;
        b=a9F03uNXntvJz/kl+nGaLuDvYqmXbSmAktlmK/hEz2/ndQYw55U/qrPtVEoAuahq9r/0bp
        /z4sXmUGLgSpdEDQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 24BA4A3B81;
        Wed,  2 Mar 2022 17:46:46 +0000 (UTC)
Date:   Wed, 2 Mar 2022 18:46:45 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Connor O'Brien <connoro@google.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
Message-ID: <20220302174645.GS3113@kunlun.suse.cz>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
 <YgdIWvNsc0254yiv@syu-laptop.lan>
 <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com>
 <YgwBN8WeJvZ597/j@syu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgwBN8WeJvZ597/j@syu-laptop>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 03:38:31AM +0800, Shung-Hsi Yu wrote:
> On Fri, Feb 11, 2022 at 10:36:28PM -0800, Yonghong Song wrote:
> > On 2/11/22 9:40 PM, Shung-Hsi Yu wrote:
> > > On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
> > > > On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
> > > > > On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > > On 2/10/22 2:01 AM, Michal Suchánek wrote:
> > > > > > > On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> > > > > > > > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > We recently run into module load failure related to split BTF on openSUSE
> > > > > > > > > Tumbleweed[1], which I believe is something that may also happen on other
> > > > > > > > > rolling distros.
> > > > > > > > > 
> > > > > > > > > The error looks like the follow (though failure is not limited to ipheth)
> > > > > > > > > 
> > > > > > > > >         BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
> > > > > > > > > 
> > > > > > > > >         failed to validate module [ipheth] BTF: -22
> > > > > > > > > 
> > > > > > > > > The error comes down to trying to load BTF of *kernel modules from a
> > > > > > > > > different build* than the runtime kernel (but the source is the same), where
> > > > > > > > > the base BTF of the two build is different.
> > > > > > > > > 
> > > > > > > > > While it may be too far stretched to call this a bug, solving this might
> > > > > > > > > make BTF adoption easier. I'd natively think that we could further split
> > > > > > > > > base BTF into two part to avoid this issue, where .BTF only contain exported
> > > > > > > > > types, and the other (still residing in vmlinux) holds the unexported types.
> > > > > > > > 
> > > > > > > > What is the exported types? The types used by export symbols?
> > > > > > > > This for sure will increase btf handling complexity.
> > > > > > > 
> > > > > > > And it will not actually help.
> > > > > > > 
> > > > > > > We have modversion ABI which checks the checksum of the symbols that the
> > > > > > > module imports and fails the load if the checksum for these symbols does
> > > > > > > not match. It's not concerned with symbols not exported, it's not
> > > > > > > concerned with symbols not used by the module. This is something that is
> > > > > > > sustainable across kernel rebuilds with minor fixes/features and what
> > > > > > > distributions watch for.
> > > > > > > 
> > > > > > > Now with BTF the situation is vastly different. There are at least three
> > > > > > > bugs:
> > > > > > > 
> > > > > > >     - The BTF check is global for all symbols, not for the symbols the
> > > > > > >       module uses. This is not sustainable. Given the BTF is supposed to
> > > > > > >       allow linking BPF programs that were built in completely different
> > > > > > >       environment with the kernel it is completely within the scope of BTF
> > > > > > >       to solve this problem, it's just neglected.
> > > > > > >     - It is possible to load modules with no BTF but not modules with
> > > > > > >       non-matching BTF. Surely the non-matching BTF could be discarded.
> > > > > > >     - BTF is part of vermagic. This is completely pointless since modules
> > > > > > >       without BTF can be loaded on BTF kernel. Surely it would not be too
> > > > > > >       difficult to do the reverse as well. Given BTF must pass extra check
> > > > > > >       to be used having it in vermagic is just useless moise.
> > > > > > > 
> > > > > > > > > Does that sound like something reasonable to work on?
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > ## Root case (in case anyone is interested in a verbose version)
> > > > > > > > > 
> > > > > > > > > On openSUSE Tumbleweed there can be several builds of the same source. Since
> > > > > > > > > the source is the same, the binaries are simply replaced when a package with
> > > > > > > > > a larger build number is installed during upgrade.
> > > > > > > > > 
> > > > > > > > > In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
> > > > > > > > > More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
> > > > > > > > > struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
> > > > > > > > > struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
> > > > > > > > > are previously missing in base BTF of 5.15.12-1.1.
> > > > > > > > 
> > > > > > > > As stated in [2] below, I think we should understand why rebuild is
> > > > > > > > triggered. If the rebuild for vmlinux is triggered, why the modules cannot
> > > > > > > > be rebuild at the same time?
> > > > > > > 
> > > > > > > They do get rebuilt. However, if you are running the kernel and install
> > > > > > > the update you get the new modules with the old kernel. If the install
> > > > > > > script fails to copy the kernel to your EFI partition based on the fact
> > > > > > > a kernel with the same filename is alreasy there you get the same.
> > > > > > > 
> > > > > > > If you have 'stable' distribution adding new symbols is normal and it
> > > > > > > does not break module loading without BTF but it breaks BTF.
> > > > > > 
> > > > > > Okay, I see. One possible solution is that if kernel module btf
> > > > > > does not match vmlinux btf, the kernel module btf will be ignored
> > > > > > with a dmesg warning but kernel module load will proceed as normal.
> > > > > > I think this might be also useful for bpf lskel kernel modules as
> > > > > > well which tries to be portable (with CO-RE) for different kernels.
> > > > > 
> > > > > That sounds like #2 that Michal is proposing:
> > > > > "It is possible to load modules with no BTF but not modules with
> > > > >    non-matching BTF. Surely the non-matching BTF could be discarded."
> > > 
> > > Since we're talking about matching check, I'd like bring up another issue.
> > > 
> > > AFAICT with current form of BTF, checking whether BTF on kernel module
> > > matches cannot be made entirely robust without a new version of btf_header
> > > that contain info about the base BTF.
> > 
> > The base BTF is always the one associated with running kernel and typically
> > the BTF is under /sys/kernel/btf/vmlinux. Did I miss
> > anything here?
> > 
> > > As effective as the checks are in this case, by detecting a type name being
> > > an empty string and thus conclude it's non-matching, with some (bad) luck a
> > > non-matching BTF could pass these checks a gets loaded.
> > 
> > Could you be a little bit more specific about the 'bad luck' a
> > non-matching BTF could get loaded? An example will be great.
> 
> Let me try take a jab at it. Say here's a hypothetical BTF for a kernel
> module which only type information for `struct something *`:
> 
>   [5] PTR '(anon)' type_id=4
> 
> Which is built upon the follow base BTF:
> 
>   [1] INT 'unsigned char' size=1 bits_offset=0 nr_bits=8 encoding=(none)
>   [2] PTR '(anon)' type_id=3
>   [3] STRUCT 'list_head' size=16 vlen=2
>         'next' type_id=2 bits_offset=0
>         'prev' type_id=2 bits_offset=64
>   [4] STRUCT 'something' size=2 vlen=2
>         'locked' type_id=1 bits_offset=0
>         'pending' type_id=1 bits_offset=8
> 
> Due to the situation mentioned in the beginning of the thread, the *runtime*
> kernel have a different base BTF, in this case type IDs are offset by 1 due
> to an additional typedef entry:
> 
>   [1] TYPEDEF 'u8' type_id=1
>   [2] INT 'unsigned char' size=1 bits_offset=0 nr_bits=8 encoding=(none)
>   [3] PTR '(anon)' type_id=3
>   [4] STRUCT 'list_head' size=16 vlen=2
>         'next' type_id=2 bits_offset=0
>         'prev' type_id=2 bits_offset=64
>   [5] STRUCT 'something' size=2 vlen=2
>         'locked' type_id=1 bits_offset=0
>         'pending' type_id=1 bits_offset=8
> 
> Then when loading the BTF on kernel module on the runtime, the kernel will
> mistakenly interprets "PTR '(anon)' type_id=4" as `struct list_head *`
> rather than `struct something *`.
> 
> Does this should possible? (at least theoretically)

At least not this way because you have different number of entries which
was the original issue.

So is this possible at least theoretically, and how likely will that
happen in practice?

What else other than the number of entries has to match?

Thanks

Michal
