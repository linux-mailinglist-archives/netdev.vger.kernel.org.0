Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5711B1796
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgDTUya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgDTUya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 16:54:30 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC6BC061A0C;
        Mon, 20 Apr 2020 13:54:28 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id x2so9876239qtr.0;
        Mon, 20 Apr 2020 13:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3aM6ySTt1JA7jga8iVB04qoFk3fpif9WQjyZ29LThzI=;
        b=YaogCojRTUgSB+jUNI3fSG5ccXoSk8Bw04wQouLVShhv0/tv3ct4nWsJ1N6sTBtH1d
         KHxP3O0TsOPoMafNckeSZ4az+t3rMKL4AQikakeuQ0n4lTQuAa57kVVoZbrojZDOvh77
         5G2zgjvQBZUmJiUwck+2DsZevexBIvDyU6+xfcOTRUp1fbqCzpGvLKpGid8a8pMM79A1
         D1AeR9G5k/NVmy3JptxkOjCalx2VGzbnQghGRSWr+ww+vWu+XzdI8t6YYHaIb19nE/e7
         35XHyTLZNLfsreGwwo/EHjQFoIPGN9vNr6K/zxjTKWKciWaGF5+ktS0I+fwzRKMSIDUK
         fiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3aM6ySTt1JA7jga8iVB04qoFk3fpif9WQjyZ29LThzI=;
        b=PkHv8ch1JxONg+iAUirxDFtmybW+CtTAajiTghc/n/lmJssqVORrnMWVy2vWOrEfEN
         k0f+xdenSCOoe8Gvzvv7rdWRWKP8fenX9jTTsBBiMf+Bdv8KURoNWydii3zpBK4q9dxy
         3Ihmr8MfO1UqfU2Bgzwhsyv9FNfDYveZ5mf7Q5HqUgWWEVuPrIZKAPJJbwo4t1N78otg
         otsQwEtPozy8nU6+fUbCiXgwI5VTd6S85n8Vs/SJX9pzCnoAFe+7pfM3IdH6PMzIfFrt
         bFc5LPHkpesvH4x+zx2gIW2+43RFliPp2Y/rHe0+AWzEBf/S+wYvYJ9wCg/xEZ6gueh5
         I9NA==
X-Gm-Message-State: AGi0PubSXwbqHLFDFEaho/FFrclp0Pfowk7W/gx9eZdte6z6yIG/wDpQ
        7gpRgflpeFSEGz2rv5ofJSb8ud6XOws=
X-Google-Smtp-Source: APiQypI7P5JXpytVExer74SB7iMdYf7opTKWYEUzYs39TbQSovr9cn03dXWRNr7pSH51VqVffCl5Dw==
X-Received: by 2002:ac8:33f9:: with SMTP id d54mr18512969qtb.239.1587416067884;
        Mon, 20 Apr 2020 13:54:27 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id a17sm480190qka.37.2020.04.20.13.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 13:54:26 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8E2FC409A3; Mon, 20 Apr 2020 17:54:24 -0300 (-03)
Date:   Mon, 20 Apr 2020 17:54:24 -0300
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type printing
Message-ID: <20200420205424.GB23638@kernel.org>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
 <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, Apr 18, 2020 at 09:05:36AM -0700, Alexei Starovoitov escreveu:
> On Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire wrote:
> > ...gives us:
> > 
> > {{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,
 
> This is unreadable.
> I like the choice of C style output, but please format it similar to drgn. Like:
> *(struct task_struct *)0xffff889ff8a08000 = {
> 	.thread_info = (struct thread_info){
> 		.flags = (unsigned long)0,
> 		.status = (u32)0,
> 	},
> 	.state = (volatile long)1,
> 	.stack = (void *)0xffffc9000c4dc000,
> 	.usage = (refcount_t){
> 		.refs = (atomic_t){
> 			.counter = (int)2,
> 		},
> 	},
> 	.flags = (unsigned int)4194560,
> 	.ptrace = (unsigned int)0,
 
> I like Arnaldo's idea as well, but I prefer zeros to be dropped by default.
> Just like %d doesn't print leading zeros by default.
> "%p0<struct sk_buff>" would print them.

I was thinking about another way to compress the output of a given data
structure someone is tracking, having to print it from time to time,
which is to store a copy of the struct as you print it and then, when
printing it again, print just its pointer, i.e. that:

*(struct task_struct *)0xffff889ff8a08000 = {

Line, then just printing the fields that changed, say just that refcount
was bumped, so it first print:

*(struct task_struct *)0xffff889ff8a08000 = {
      .thread_info = (struct thread_info){
              .flags = (unsigned long)0,
              .status = (u32)0,
      },
      .state = (volatile long)1,
      .stack = (void *)0xffffc9000c4dc000,
      .usage = (refcount_t){
              .refs = (atomic_t){
                      .counter = (int)2,
              },
      },
      .flags = (unsigned int)4194560,
      .ptrace = (unsigned int)0,

Then, the next time it would print:

*(struct task_struct *)0xffff889ff8a08000 = {
      .usage = (refcount_t){
              .refs = (atomic_t){
                      .counter = (int)3,
              },
      },
},

- Arnaldo
