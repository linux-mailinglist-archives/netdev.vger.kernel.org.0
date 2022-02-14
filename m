Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4644B5B5B
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiBNUqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:46:49 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiBNUqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:46:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B961BD698;
        Mon, 14 Feb 2022 12:44:30 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7F624210FA;
        Mon, 14 Feb 2022 20:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644869987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPYDxwn02j+uAz2XIbkytGv7cPvbywJp1Y3k1ZeKMaw=;
        b=iXid/fzFeEnhGNDrDAKdNjfAJGDw6h7H265CbtDR8Rt+TUka0y7tc3KvRqZ5tQbz2xzNe9
        Yad98s+dqYLxOz4JdwiMErpMPZdPd4OYOzBxNrXMJh/kgCbSG8D7n6OqngFTh7qni1iIF+
        Fj0os55imocQj1L3iUGTXN+DQDwJoKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644869987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPYDxwn02j+uAz2XIbkytGv7cPvbywJp1Y3k1ZeKMaw=;
        b=A1Gz7oByjgxwz4lxRcOEAXegE/ONC8Uqt8sp0fXt+xtrEno8a/+ThB22TA8Un1VRQjTXG7
        ZTlhPXjKL5hveeCQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 662AAA3B85;
        Mon, 14 Feb 2022 20:19:47 +0000 (UTC)
Date:   Mon, 14 Feb 2022 21:19:46 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
Message-ID: <20220214201946.GO3113@kunlun.suse.cz>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
 <87a6ex8gm8.fsf@toke.dk>
 <CAEf4BzYJCHB-oYqFqJTfHU4D795ewgkndQtR1Po5H521fH0oMg@mail.gmail.com>
 <87v8xl6jlw.fsf@toke.dk>
 <Ygdjt0Qbki0tHG4k@syu-laptop.lan>
 <87ee467p1f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ee467p1f.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 04:40:44PM +0100, Toke Høiland-Jørgensen wrote:
> Shung-Hsi Yu <shung-hsi.yu@suse.com> writes:
> 
> > On Sat, Feb 12, 2022 at 12:58:51AM +0100, Toke Høiland-Jørgensen wrote:
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> 
> >> > On Fri, Feb 11, 2022 at 9:20 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >>
> >> >> > On Thu, Feb 10, 2022 at 2:01 AM Michal Suchánek <msuchanek@suse.de> wrote:
> >> >> >>
> >> >> >> Hello,
> >> >> >>
> >> >> >> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> >> >> >> >
> >> >> >> >
> >> >> >> > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> >> >> >> > > Hi,
> >> >> >> > >
> >> >> >> > > We recently run into module load failure related to split BTF on openSUSE
> >> >> >> > > Tumbleweed[1], which I believe is something that may also happen on other
> >> >> >> > > rolling distros.
> >> >> >> > >
> >> >> >> > > The error looks like the follow (though failure is not limited to ipheth)
> >> >> >> > >
> >> >> >> > >      BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
> >> >> >> > >
> >> >> >> > >      failed to validate module [ipheth] BTF: -22
> >> >> >> > >
> >> >> >> > > The error comes down to trying to load BTF of *kernel modules from a
> >> >> >> > > different build* than the runtime kernel (but the source is the same), where
> >> >> >> > > the base BTF of the two build is different.
> >> >> >> > >
> >> >> >> > > While it may be too far stretched to call this a bug, solving this might
> >> >> >> > > make BTF adoption easier. I'd natively think that we could further split
> >> >> >> > > base BTF into two part to avoid this issue, where .BTF only contain exported
> >> >> >> > > types, and the other (still residing in vmlinux) holds the unexported types.
> >> >> >> >
> >> >> >> > What is the exported types? The types used by export symbols?
> >> >> >> > This for sure will increase btf handling complexity.
> >> >> >>
> >> >> >> And it will not actually help.
> >> >> >>
> >> >> >> We have modversion ABI which checks the checksum of the symbols that the
> >> >> >> module imports and fails the load if the checksum for these symbols does
> >> >> >> not match. It's not concerned with symbols not exported, it's not
> >> >> >> concerned with symbols not used by the module. This is something that is
> >> >> >> sustainable across kernel rebuilds with minor fixes/features and what
> >> >> >> distributions watch for.
> >> >> >>
> >> >> >> Now with BTF the situation is vastly different. There are at least three
> >> >> >> bugs:
> >> >> >>
> >> >> >>  - The BTF check is global for all symbols, not for the symbols the
> >> >> >>    module uses. This is not sustainable. Given the BTF is supposed to
> >> >> >>    allow linking BPF programs that were built in completely different
> >> >> >>    environment with the kernel it is completely within the scope of BTF
> >> >> >>    to solve this problem, it's just neglected.
> >> >> >
> >> >> > You refer to BTF use in CO-RE with the latter. It's just one
> >> >> > application of BTF and it doesn't follow that you can do the same with
> >> >> > module BTF. It's not a neglect, it's a very big technical difficulty.
> >> >> >
> >> >> > Each module's BTFs are designed as logical extensions of vmlinux BTF.
> >> >> > And each module BTF is independent and isolated from other modules
> >> >> > extension of the same vmlinux BTF. The way that BTF format is
> >> >> > designed, any tiny difference in vmlinux BTF effectively invalidates
> >> >> > all modules' BTFs and they have to be rebuilt.
> >> >> >
> >> >> > Imagine that only one BTF type is added to vmlinux BTF. Last BTF type
> >> >> > ID in vmlinux BTF is shifted from, say, 1000 to 1001. While previously
> >> >> > every module's BTF type ID started with 1001, now they all have to
> >> >> > start with 1002 and be shifted by 1.
> >> >> >
> >> >> > Now let's say that the order of two BTF types in vmlinux BTF is
> >> >> > changed, say type 10 becomes type 20 and type 20 becomes type 10 (just
> >> >> > because of slight difference in DWARF, for instance). Any type
> >> >> > reference to 10 or 20 in any module BTF has to be renumbered now.
> >> >> >
> >> >> > Another one, let's say we add a new string to vmlinux BTF string
> >> >> > section somewhere at the beginning, say "abc" at offset 100. Any
> >> >> > string offset after 100 now has to be shifted *both* in vmlinux BTF
> >> >> > and all module BTFs. And also any string reference in module BTFs have
> >> >> > to be adjusted as well because now each module's BTF's logical string
> >> >> > offset is starting at 4 logical bytes higher (due to "abc\0" being
> >> >> > added and shifting everything right).
> >> >> >
> >> >> > As you can see, any tiny change in vmlinux BTF, no matter where,
> >> >> > beginning, middle, or end, causes massive changes in type IDs and
> >> >> > offsets everywhere. It's impractical to do any local adjustments, it's
> >> >> > much simpler and more reliable to completely regenerate BTF
> >> >> > completely.
> >> >>
> >> >> This seems incredibly brittle, though? IIUC this means that if you want
> >> >> BTF in your modules you *must* have not only the kernel headers of the
> >> >> kernel it's going to run on, but the full BTF information for the exact
> >> >
> >> > From BTF perspective, only vmlinux BTF. Having exact kernel headers
> >> > would minimize type information duplication.
> >> 
> >> Right, I meant you'd need the kernel headers to compile the module, and
> >> the vmlinux BTF to build the module BTF info.
> >> 
> >> >> kernel image you're going to load that module on? How is that supposed
> >> >> to work for any kind of environment where everything is not built
> >> >> together? Third-party modules for distribution kernels is the obvious
> >> >> example that comes to mind here, but as this thread shows, they don't
> >> >> necessarily even have to be third party...
> >> >>
> >> >> How would you go about "completely regenerating BTF" in practice for a
> >> >> third-party module, say?
> >> >
> >> > Great questions. I was kind of hoping you'll have some suggestions as
> >> > well, though. Not just complaints.
> >> 
> >> Well, I kinda took your "not really a bug either" comment to mean you
> >> weren't really open to changing the current behaviour. But if that was a
> >> misunderstanding on my part, I do have one thought:
> >> 
> >> The "partial BTF" thing in the modules is done to save space, right?
> >> I.e., in principle there would be nothing preventing a module from
> >> including a full (self-contained) set of BTF in its .ko when it is
> >> compiled? Because if so, we could allow that as an optional mode that
> >> can be enabled if you don't mind taking the size hit (any idea how large
> >> that usually is, BTW?).
> >
> > This seems quite nice IMO as no change need to be made on the generation
> > side of existing BTF tooling. I test it out on openSUSE Tumbleweed 5.16.5
> > kernel modules, and for the sake of completeness, includes both the case
> > where BTF is stripped and using a pre-trained zstd dictionary as well.
> >
> > Uncompressed, no BTF                             362MiB -27%
> > Uncompressed, parital BTF                        499MiB +0%
> > Uncompressed, self-contained BTF                1026MiB +105%
> >
> > Zstd compressed, no BTF                           95MiB -35%
> > Zstd compressed, partial BTF                     147MiB +0%
> > Zstd compressed, self-contained BTF              361MiB +145%
> > Zstd compressed (trained), self-contained BTF    299MiB +103%
> >
> > So we'd expect quite a bit of hit as the size of kernel module would double.
> >
> > For servers and workstation environment an additional ~200MiB of disk space
> > seems like tolerable trade-off if it can get third-party kernel module to
> > work. But I cannot speak for other kind of use cases.
> 
> Well, there are also in-between tradeoffs (i.e., you can build a subset
> of the modules with self-contained BTF and a subset with partial BTF
> depending on what fits your build environment).

As for that you would typically want in-tree modules with partial BTF.
It's a bug if they don't match, and if you can ignore the non-matching
BTF you should bee able to boot a system that is functional enough to
re-install the kernel. Today nothing critical depends on CO-RE.

On the othere hand if you build something out-of-tree be it virtualbox
or some module updated with cutting edge experimental changes you will
likely want full BTF.

Thanks

Michal
