Return-Path: <netdev+bounces-2885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 352497046C5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F00321C20D92
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD431DDD5;
	Tue, 16 May 2023 07:45:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9159E1DDC0;
	Tue, 16 May 2023 07:45:37 +0000 (UTC)
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269AA1BF0;
	Tue, 16 May 2023 00:45:36 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-b8f46ca241bso2256787276.1;
        Tue, 16 May 2023 00:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684223135; x=1686815135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qOxPv9nPBMO3v5ymnEoGctbo7W28IsAWHhOyGgOsfAo=;
        b=rn8r3uk514tGfZzxcoqhVSweRfgsRBfDsNKddNMquvveoh25KJ3Mgrb5YIun9dnf6P
         xq4wPBSiPFBumuBDLrGBsSqlQr9MTmjVSIgIFujpu4flTasDk4Vxp29BSXWE6IiUhgUx
         4owZF74YRt1u2K5AoKkVKWYhBsCVKoLqMqv6d464COGq+D3tmXsNiWn/+ax4O/uuagbO
         prN2Xj8WVRdle6TYQmVMna/R4Q2JH+RVKLYfnBTdIyIgllIGgDMzeW2T6uOuf6kOIAro
         YtlqIpRfWoSoTOW4pKjczEpzhr8EOnRPgb4P3K6mOhe1FgU/M3n0962Loz1z90VG6l4o
         6ODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684223135; x=1686815135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOxPv9nPBMO3v5ymnEoGctbo7W28IsAWHhOyGgOsfAo=;
        b=DNtJ04M562VZc4lZzv1itAcwZVi/dUf0C//ZKq9GBUhoJKLj072Zy2qBy8bWdcCbfi
         m9Er4K8WYU042ebd9EXqc2si3gfzRT32EXjZb2hlRXixhBqYhmWMDjF72gLcOZK9A7Zi
         eJwyAwG24hgJxycGBPXGvYF0+3CdCmERQzoa+5u2VjBBrSSBDU8Xicuvlf8OpBw3pbxJ
         STjb5sdVmWf3p5uxqir3X08Zb4jM/UbamBdJ5PuhvmX0pf3DOuXkFk3R2RZrEnqZ/Q1l
         MUjRGIqEEmMIUKLcQi0RKMwLtiWtRcD1D3jAjhvA9JjvS05a6EwI+6rVLL2l4JWiNa5n
         zIPg==
X-Gm-Message-State: AC+VfDwd8onmdLh/8Wr88TnsUor56q5SH6Dbi6CKA5GbPCgpOmO1VsZm
	qRTCqmraWN4ISO8yontKfbWS5tIfv6vcGpBAjOo=
X-Google-Smtp-Source: ACHHUZ4OR+YiLhv43Pg/guNmEoGZROCAfsAlIJ6/pG9z+2LJBQ9Hgoc2Yk/aBST6KVFbW504Ww/ksaHd44302ZZstIA=
X-Received: by 2002:a25:aa8e:0:b0:ba7:498a:46f with SMTP id
 t14-20020a25aa8e000000b00ba7498a046fmr1551395ybi.2.1684223135132; Tue, 16 May
 2023 00:45:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512092043.3028-1-magnus.karlsson@gmail.com> <9e553914-3703-8f10-b3b8-7d7e90462417@iogearbox.net>
In-Reply-To: <9e553914-3703-8f10-b3b8-7d7e90462417@iogearbox.net>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 16 May 2023 09:45:24 +0200
Message-ID: <CAJ8uoz3jf2xdmaDYiBZ3jcM4G1-9h5ngXXEpmnU8iwKwp9PZdw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/10] seltests/xsk: prepare for AF_XDP
 multi-buffer testing
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org, 
	netdev@vger.kernel.org, maciej.fijalkowski@intel.com, bpf@vger.kernel.org, 
	yhs@fb.com, andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, 
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, 
	haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 15 May 2023 at 23:12, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Magnus,
>
> On 5/12/23 11:20 AM, Magnus Karlsson wrote:
> >
> > Prepare the AF_XDP selftests test framework code for the upcoming
> > multi-buffer support in AF_XDP. This so that the multi-buffer patch
> > set does not become way too large. In that upcoming patch set, we are
> > only including the multi-buffer tests together with any framework
> > code that depends on the new options bit introduced in the AF_XDP
> > multi-buffer implementation itself.
> >
> > Currently, the test framework is based on the premise that a packet
> > consists of a single fragment and thus occupies a single buffer and a
> > single descriptor. Multi-buffer breaks this assumption, as that is the
> > whole purpose of it. Now, a packet can consist of multiple buffers and
> > therefore consume multiple descriptors.
> >
> > The patch set starts with some clean-ups and simplifications followed
> > by patches that make sure that the current code works even when a
> > packet occupies multiple buffers. The actual code for sending and
> > receiving multi-buffer packets will be included in the AF_XDP
> > multi-buffer patch set as it depends on a new bit being used in the
> > options field of the descriptor.
> >
> > Patch set anatomy:
> > 1: The XDP program was unnecessarily changed many times. Fixes this.
> >
> > 2: There is no reason to generate a full UDP/IPv4 packet as it is
> >     never used. Simplify the code by just generating a valid Ethernet
> >     frame.
> >
> > 3: Introduce a more complicated payload pattern that can detect
> >     fragments out of bounds in a multi-buffer packet and other errors
> >     found in single-fragment packets.
> >
> > 4: As a convenience, dump the content of the faulty packet at error.
> >
> > 5: To simplify the code, make the usage of the packet stream for Tx
> >     and Rx more similar.
> >
> > 6: Store the offset of the packet in the buffer in the struct pkt
> >     definition instead of the address in the umem itself and introduce
> >     a simple buffer allocator. The address only made sense when all
> >     packets consumed a single buffer. Now, we do not know beforehand
> >     how many buffers a packet will consume, so we instead just allocate
> >     a buffer from the allocator and specify the offset within that
> >     buffer.
> >
> > 7: Test for huge pages only once instead of before each test that needs it.
> >
> > 8: Populate the fill ring based on how many frags are needed for each
> >     packet.
> >
> > 9: Change the data generation code so it can generate data for
> >     multi-buffer packets too.
> >
> > 10: Adjust the packet pacing algorithm so that it can cope with
> >      multi-buffer packets. The pacing algorithm is present so that Tx
> >      does not send too many packets/frames to Rx that it starts to drop
> >      packets. That would ruin the tests.
>
> This triggers build error in BPF CI:

Thanks Daniel. Will fix.

>    https://github.com/kernel-patches/bpf/actions/runs/4984982413/jobs/8924047266
>
>    [...]
>    xskxceiver.c:1881:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>            default:
>            ^~~~~~~
>    xskxceiver.c:1885:6: note: uninitialized use occurs here
>            if (ret == TEST_PASS)
>                ^~~
>    xskxceiver.c:1779:9: note: initialize the variable 'ret' to silence this warning
>      GEN-SKEL [test_progs] test_subskeleton.skel.h
>      GEN-SKEL [test_progs] test_subskeleton_lib.skel.h
>            int ret;
>                   ^
>                    = 0
>    1 error generated.
>    make: *** [Makefile:617: /tmp/work/bpf/bpf/tools/testing/selftests/bpf/xskxceiver] Error 1
>    make: *** Waiting for unfinished jobs....
>      GEN-SKEL [test_progs] test_usdt.skel.h
>    make: Leaving directory '/tmp/work/bpf/bpf/tools/testing/selftests/bpf'
>
> Pls fix and respin, thanks.

