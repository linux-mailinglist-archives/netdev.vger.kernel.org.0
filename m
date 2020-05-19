Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A926A1D8F56
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgESFqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:46:10 -0400
Received: from verein.lst.de ([213.95.11.211]:42337 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgESFqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 01:46:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F31C968B02; Tue, 19 May 2020 07:46:06 +0200 (CEST)
Date:   Tue, 19 May 2020 07:46:06 +0200
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
Subject: Re: [PATCH 10/18] maccess: unify the probe kernel arch hooks
Message-ID: <20200519054606.GA23853@lst.de>
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-11-hch@lst.de> <20200514101318.1c14647e41b7038b99b91fcd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514101318.1c14647e41b7038b99b91fcd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 10:13:18AM +0900, Masami Hiramatsu wrote:
> > +		bool strict)
> >  {
> >  	long ret;
> >  	mm_segment_t old_fs = get_fs();
> >  
> > +	if (!probe_kernel_read_allowed(dst, src, size, strict))
> > +		return -EFAULT;
> 
> Could you make this return -ERANGE instead of -EFAULT so that
> the caller can notice that the address might be user space?

That is clearly a behavior change, so I don't want to mix it into
this patch.  But I can add it as another patch at the end.
