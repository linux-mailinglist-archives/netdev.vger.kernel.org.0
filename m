Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7494510E783
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 10:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfLBJRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 04:17:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:54546 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfLBJRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 04:17:20 -0500
Received: from [194.230.159.159] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ibhpV-00034d-II; Mon, 02 Dec 2019 10:17:17 +0100
Date:   Mon, 2 Dec 2019 10:17:16 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        alexei.starovoitov@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when
 prog is jited
Message-ID: <20191202091716.GA30232@localhost.localdomain>
References: <20191129222911.3710-1-daniel@iogearbox.net>
 <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
 <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
 <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
 <20191202083006.GJ2844@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202083006.GJ2844@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25650/Sun Dec  1 11:04:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 09:30:06AM +0100, Peter Zijlstra wrote:
> On Sun, Dec 01, 2019 at 06:49:32PM -0800, Eric Dumazet wrote:
> 
> > Thanks for the link !
> > 
> > Having RO protection as a debug feature would be useful.
> > 
> > I believe we have CONFIG_STRICT_MODULE_RWX (and CONFIG_STRICT_KERNEL_RWX) for that already.
> > 
> > Or are we saying we also want to get rid of them ?
> 
> No, in fact I'm working on making that stronger. We currently still have
> a few cases that violate the W^X rule.
> 
> The thing is, when the BPF stuff is JIT'ed, the actual BPF instruction
> page is not actually executed at all, so making it RO serves no purpose,
> other than to fragment the direct map.

Yes exactly, in that case it is only used for dumping the BPF insns back
to user space and therefore no need at all to set it RO. (The JITed image
however *is* set as RO. - Perhaps there was some confusion given your
earlier question.)

Thanks,
Daniel
