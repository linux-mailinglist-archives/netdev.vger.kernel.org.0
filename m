Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F0DA1218
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfH2Gvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfH2Gvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 02:51:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA1E82073F;
        Thu, 29 Aug 2019 06:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567061514;
        bh=Tvk8O+MqkCt0qJtVET3j6ajgw/8+u6fpffg9CLrLLD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CxfE49YIHfWKhVTWbcrgeRVoBLw1cONxvlqhCny7z3gnlrOlmC1MlZdmRxZoKgR/y
         dUtEnGXEGwj0GWHVH+93I9tsLwon+n4a8olljv+Aq0LR/yWrNTWUe0ohis5r2IL43E
         xgVSPCQeRN8jRiimWKLfvNZhRKazhDeKwvoZMU4o=
Date:   Thu, 29 Aug 2019 08:51:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Julia Kartseva <hex@fb.com>, ast@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, rdna@fb.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: auto-split of commit. Was: [PATCH bpf-next 04/10] tools/bpf: add
 libbpf_prog_type_(from|to)_str helpers
Message-ID: <20190829065151.GB30423@kroah.com>
References: <cover.1567024943.git.hex@fb.com>
 <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
 <20190828163422.3d167c4b@cakuba.netronome.com>
 <20190828234626.ltfy3qr2nne4uumy@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828234626.ltfy3qr2nne4uumy@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 04:46:28PM -0700, Alexei Starovoitov wrote:
> On Wed, Aug 28, 2019 at 04:34:22PM -0700, Jakub Kicinski wrote:
> > 
> > Greg, Thomas, libbpf is extracted from the kernel sources and
> > maintained in a clone repo on GitHub for ease of packaging.
> > 
> > IIUC Alexei's concern is that since we are moving the commits from
> > the kernel repo to the GitHub one we have to preserve the commits
> > exactly as they are, otherwise SOB lines lose their power.
> > 
> > Can you provide some guidance on whether that's a valid concern, 
> > or whether it's perfectly fine to apply a partial patch?
> 
> Right. That's exactly the concern.
> 
> Greg, Thomas,
> could you please put your legal hat on and clarify the following.
> Say some developer does a patch that modifies
> include/uapi/linux/bpf.h
> ..some other kernel code...and
> tools/include/uapi/linux/bpf.h
> 
> That tools/include/uapi/linux/bpf.h is used by perf and by libbpf.
> We have automatic mirror of tools/libbpf into github/libbpf/
> so that external projects and can do git submodule of it,
> can build packages out of it, etc.
> 
> The question is whether it's ok to split tools/* part out of
> original commit, keep Author and SOB, create new commit out of it,
> and automatically push that auto-generated commit into github mirror.

Note, I am not a laywer, and am not _your_ lawyer either, only _your_
lawyer can answer questions as to what is best for you.

That being said, from a "are you keeping the correct authorship info",
yes, it sounds like you are doing the correct thing here.

Look at what I do for stable kernels, I take the original commit and add
it to "another tree" keeping the original author and s-o-b chain intact,
and adding a "this is the original git commit id" type message to the
changelog text so that people can link it back to the original.

If you are doing that here as well, I don't see how anyone can object.

thanks,

greg k-h
