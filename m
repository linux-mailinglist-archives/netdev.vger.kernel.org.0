Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29551D7C62
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgERPJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:09:07 -0400
Received: from verein.lst.de ([213.95.11.211]:38896 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgERPJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 11:09:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 27D5268B02; Mon, 18 May 2020 17:09:04 +0200 (CEST)
Date:   Mon, 18 May 2020 17:09:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] maccess: allow architectures to provide kernel
 probing directly
Message-ID: <20200518150903.GD8871@lst.de>
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-15-hch@lst.de> <20200516124259.5b68a4e1d4670efa1397a1e0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516124259.5b68a4e1d4670efa1397a1e0@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 12:42:59PM +0900, Masami Hiramatsu wrote:
> > Provide alternative versions of probe_kernel_read, probe_kernel_write
> > and strncpy_from_kernel_unsafe that don't need set_fs magic, but instead
> > use arch hooks that are modelled after unsafe_{get,put}_user to access
> > kernel memory in an exception safe way.
> 
> This patch seems to introduce new implementation of probe_kernel_read/write()
> and strncpy_from_kernel_unsafe(), but also drops copy_from/to_kernel_nofault()
> and strncpy_from_kernel_nofault() if HAVE_ARCH_PROBE_KERNEL is defined.
> In the result, this cause a link error with BPF and kprobe events.

That was just a bug as I didn't commit the changes to switch everything
to _nofault and remove _unsafe entirely, sorry.
