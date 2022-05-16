Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7917452921D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348870AbiEPVBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349475AbiEPVBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:01:22 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FA74507B;
        Mon, 16 May 2022 13:38:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ch13so30807930ejb.12;
        Mon, 16 May 2022 13:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PMDosnlJ+gbQJYPokwfPZqLFLUpNmlvipt6Owk5quI0=;
        b=IkakkWk3Q4TG07BcLysVVBAyu3U94fvCZ/O3a70ncHxWkfdAP6tmqUtRpUbw+Oegdl
         LhFm2BB6hYEjOLl/hH8ybdoCdiOCFPYC4H2tE9zQL8qObGxorZaEkJA2XFBbuvO1sQoa
         xTqHUFKiIsNs2Z8c5imcA/Hmdp44fgDIysSWCjDSj+iJD8dRKdvyRl17lHQ+HZxlkY9D
         XB6b7LXSlm1Tw6GHT202BLrL8KC/HINZO5nBGwdh8QhpOq5/QyME0GBoqAC9RMRpU993
         mb6nAKIOQY8DAPSoG2EP6wUxyNTv0j6Tv6yJttEYftrCWhjKsz28hZVf3YTLIRyfNTtO
         q8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PMDosnlJ+gbQJYPokwfPZqLFLUpNmlvipt6Owk5quI0=;
        b=7nk84d9LXuoROjsZVctQATie6hCJdvOeqm98jUo1GupuZqb/yB9U5H1D+tZ2/jdBfe
         VOghVrTqL9ndupxlftu1qeXbxphD5M6KOtBGEO1JSDXkQh0K90xm1UFFwNcjSbooyG3S
         AOiRMTvF8kAegnDJmeGB9mCA4FiLeengN4tOQvAUtCD6BWac5LOt1O2tti1xcQOI0fG9
         s0f6+1m+PzOO0PyoRW7iEDNFBFole93ZS2Dy/oNWwxGvTpNN/mHPDJrgXFhB/C6ZOgpu
         d/LwwHhFwHSYeEOoZD62a43u4GdFxLxbGtIEgz6CLkE3kc5qixveBde3svDWukIXrrqR
         KDeQ==
X-Gm-Message-State: AOAM532pKdVQWvMQLdfh0teSDUYhOLRz7/psPv7K1h7PYpVDBXkXkV7/
        GSDiO8cKgCs7DGYGk9kY/y8=
X-Google-Smtp-Source: ABdhPJyvjaqge3EUfdfKUmm9GYsq/s4wXVCTbrQsJ5QL72XCE8kZsSqE4VubYHvaw+TrXnvOSgf2eg==
X-Received: by 2002:a17:906:14da:b0:6f4:e22a:3905 with SMTP id y26-20020a17090614da00b006f4e22a3905mr16660925ejc.737.1652733537825;
        Mon, 16 May 2022 13:38:57 -0700 (PDT)
Received: from krava ([83.240.63.110])
        by smtp.gmail.com with ESMTPSA id ek27-20020a056402371b00b0042617ba63c0sm5483932edb.74.2022.05.16.13.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:38:57 -0700 (PDT)
Date:   Mon, 16 May 2022 22:38:54 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Eugene Syromiatnikov <esyr@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf_trace: bail out from
 bpf_kprobe_multi_link_attach when in compat
Message-ID: <YoK2XtfCYmYomW3i@krava>
References: <20220506142148.GA24802@asgard.redhat.com>
 <CAADnVQKNkEX-caBjozegRaOb67g1HNOHn1e-enRk_s-7Gtt=gg@mail.gmail.com>
 <20220510184155.GA8295@asgard.redhat.com>
 <CAADnVQ+2gwhcMht4PuDnDOFKY68Wsq8QFz4Y69NBX_TLaSexQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+2gwhcMht4PuDnDOFKY68Wsq8QFz4Y69NBX_TLaSexQQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 03:30:10PM -0700, Alexei Starovoitov wrote:
> On Tue, May 10, 2022 at 11:42 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> >
> > On Tue, May 10, 2022 at 11:10:35AM -0700, Alexei Starovoitov wrote:
> > > On Fri, May 6, 2022 at 7:22 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> > > >
> > > > Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
> > > > for whatever reason,
> > >
> > > Jiri,
> > > why did you add this restriction?

sorry, I overlooked this email

the reason for that check is that we link addrs array with cookies
which are u64 and we need to swap cookies together with addrs when
we sort them

but now when I look at that, that could perhaps work event if
unsigned long is 32 bits, will check

> > >
> > > > having it enabled for compat processes on 64-bit
> > > > kernels makes even less sense due to discrepances in the type sizes
> > > > that it does not handle.
> > >
> > > I don't follow this logic.
> > > bpf progs are always 64-bit. Even when user space is 32-bit.
> > > Jiri's check is for the kernel.
> >
> > The interface as defined (and implemented in libbpf) expects arrays of userspace
> > pointers to be passed (for example, syms points to an array of userspace
> > pointers—character strings; same goes for addrs, but with generic userspace
> > pointers) without regard to possible difference in the pointer size in case
> > of compat userspace.
> 
> I see. So kprobe_multi.syms and kprobe_multi.addrs will be 'long'
> and 32-bit user space will have an issue with the 64-bit kernel.
> Let's fix it properly.
> We can remove sizeof(u64) != sizeof(void *) and keep libbpf as-is
> by keeping syms and addrs 'long' in uapi.
> As far as I can see 32-bit user space on a 32-bit kernel
> should work with existing code.
> in_compat_syscall() can be used to extend addrs/syms.

I'll check Eugene's new patchset

jirka
