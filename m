Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1EC1B9160
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgDZQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 12:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbgDZQAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 12:00:11 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D66BC061A0F;
        Sun, 26 Apr 2020 09:00:11 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSjhG-00C1Jz-QW; Sun, 26 Apr 2020 15:59:58 +0000
Date:   Sun, 26 Apr 2020 16:59:58 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pass kernel pointers to the sysctl ->proc_handler method v3
Message-ID: <20200426155958.GS23230@ZenIV.linux.org.uk>
References: <20200424064338.538313-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424064338.538313-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 08:43:33AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series changes the sysctl ->proc_handler methods to take kernel
> pointers.  This simplifies some of the pointer handling in the methods
> (which could probably be further simplified now), and gets rid of the
> set_fs address space overrides used by bpf.
> 
> Changes since v2:
>  - free the buffer modified by BPF
>  - move pid_max and friends to pid.h
> 
> Changes since v1:
>  - drop a patch merged by Greg
>  - don't copy data out on a write
>  - fix buffer allocation in bpf

OK, I can live with that; further work can live on top of that, anyway.
How are we going to handle that?  I can put it into never-rebased branch
in vfs.git (#work.sysctl), so that people could pull that.

FWIW, I'm putting together more uaccess stuff (will probably hit -next
tonight or tomorrow); this would fit well there...
