Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CCF1C7886
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgEFRrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:47:51 -0400
Received: from verein.lst.de ([213.95.11.211]:42252 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728566AbgEFRrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 13:47:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C3AAB68C7B; Wed,  6 May 2020 19:47:47 +0200 (CEST)
Date:   Wed, 6 May 2020 19:47:47 +0200
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
Subject: Re: [PATCH 08/15] maccess: rename strnlen_unsafe_user to
 strnlen_user_unsafe
Message-ID: <20200506174747.GA7549@lst.de>
References: <20200506062223.30032-1-hch@lst.de> <20200506062223.30032-9-hch@lst.de> <CAHk-=wj3T6u_kj8r9f3aGXCjuyN210_gJC=AXPFm9=wL-dGALA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj3T6u_kj8r9f3aGXCjuyN210_gJC=AXPFm9=wL-dGALA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 10:44:15AM -0700, Linus Torvalds wrote:
> So while I think using a consistent convention is good, and it's true
> that there is a difference in the convention between the two cases
> ("unsafe" at the beginning vs end), one of them is actually about the
> safety and security of the operation (and we have automated logic
> these days to verify it on x86), the other has nothing to do with
> "safety", really.
> 
> Would it be better to standardize around a "probe_xyz()" naming?

So:

  probe_strncpy, probe_strncpy_user, probe_strnlen_user?

Sounds weird, but at least it is consistent.

> Or perhaps a "xyz_nofault()" naming?

That sounds a little better:

   strncpy_nofault, strncpy_user_nofault, strnlen_user_nofault

> I realize this is nit-picky, and I think the patch series as-is is
> already an improvement, but I do think our naming in this area is
> really quite bad.

Always open for improvements :)

> The fact that we have "probe_kernel_read()" but then
> "strncpy_from_user_unsafe()" for the _same_ conceptual difference
> really tells me how inconsistent the naming for these kinds of "we
> can't take page faults" is. No?

True.  If we wanted to do _nofaul, what would the basic read/write
versions be?
