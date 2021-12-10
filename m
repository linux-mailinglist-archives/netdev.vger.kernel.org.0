Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9E546F965
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhLJC5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:57:41 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47936 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233693AbhLJC5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:57:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V-6w-uX_1639104844;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V-6w-uX_1639104844)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Dec 2021 10:54:05 +0800
Date:   Fri, 10 Dec 2021 10:54:02 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/2] Introduce TCP_ULP option for
 bpf_{set,get}sockopt
Message-ID: <YbLBSrhFZ2l4cCxH@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211209090250.73927-1-tonylu@linux.alibaba.com>
 <61b258ad273a9_6bfb2084d@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b258ad273a9_6bfb2084d@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 11:27:41AM -0800, John Fastabend wrote:
> Tony Lu wrote:
> > This patch set introduces a new option TCP_ULP for bpf_{set,get}sockopt
> > helper. The bpf prog can set and get TCP_ULP sock option on demand.
> > 
> > With this, the bpf prog can set TCP_ULP based on strategies when socket
> > create or other's socket hook point. For example, the bpf prog can
> > control which socket should use tls or smc (WIP) ULP modules without
> > modifying the applications.
> > 
> > Patch 1 replaces if statement with switch to make it easy to extend.
> > 
> > Patch 2 introduces TCP_ULP sock option.
> 
> Can you be a bit more specific on what ULP you are going to load on
> demand here and how that would work? For TLS I can't see how this will
> work, please elaborate. Because the user space side (e.g. openssl) behaves
> differently if running in kTLS vs uTLS modes I don't think you can
> from kernel side just flip it on? I'm a bit intrigued though on what
> might happen if we do did do this on an active socket, but seems it
> wouldn't be normal TLS with handshake and keys at that point? I'm
> not sure we need to block it from happening, but struggling to see
> how its useful at the moment.
> 
> The smc case looks promising, but for that we need to get the order
> correct and merge smc first and then this series.

Yep, we are developing a set of patch to do with smc for transparent
replacement. The smc provides the ability to be compatible with TCP,
the applications can be replaced with smc without no side effects.
In most cases, it is impossible to modify the compiled application
binary or inject into applications' containers with LD_PRELOAD. So we
are using smc ULP to replace TCP with smc when socket create.

These patches will be sent out soon. I will send them after smc's
patches. Thank you.

> 
> Also this will need a selftests.

I will fix it.

> 
> Thanks,
> John

Thanks,
Tony Lu
