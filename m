Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2161D1F72
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390772AbgEMTkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:40:07 -0400
Received: from verein.lst.de ([213.95.11.211]:48364 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387670AbgEMTkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 15:40:06 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C111968B05; Wed, 13 May 2020 21:40:03 +0200 (CEST)
Date:   Wed, 13 May 2020 21:40:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] maccess: allow architectures to provide kernel
 probing directly
Message-ID: <20200513194003.GA31028@lst.de>
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-15-hch@lst.de> <CAHk-=wgzXqgYQQt2NCdZTtxLmV1FV1nbZ_gKw0O_mRkXZj57zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgzXqgYQQt2NCdZTtxLmV1FV1nbZ_gKw0O_mRkXZj57zg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:36:18PM -0700, Linus Torvalds wrote:
> > +               arch_kernel_read(dst, src, type, err_label);            \
> 
> I'm wondering if
> 
>  (a) we shouldn't expose this as an interface in general

We do export something like it, currently it is called
probe_kernel_address, and the last patch renames it to
get_kernel_nofault.  However it is implemented as a wrapper
around probe_kernel_address / copy_from_kernel_nofault and thus
not quite as efficient and without the magic goto semantics.

>  (b) it wouldn't be named differently..

It probably should with all the renaming..
