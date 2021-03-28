Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E481934BFC4
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 01:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhC1X2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 19:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhC1X2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 19:28:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552BAC061756;
        Sun, 28 Mar 2021 16:28:05 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v10so3344718pfn.5;
        Sun, 28 Mar 2021 16:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJtPJGrX74z6y3eiYuE1BppPHYbXNU5Plwkze+kOBYU=;
        b=ZKSOgBinQgWNZ+yC1VonOio8zzx3vvYYlqGq9eiiyQfO7n0A3UfKZcdMLB7+h8YI2u
         1M61rKtJVwzYlVcl1AGGiEEG+9rFPQCNn7a+BniJSEdFByXFlKaJWF1Y7dlXMTKAUYHr
         ViwzGr6uXI1nRxIeu/ILYIsA5ajKo7iZjzjVUfLycHzwW2CDLlsNyrcKt3W3vmDJ4jjH
         PUlxfVooYpCvwr5yimoYlktAWaD0AN5jOnjdjIR2Tyv/F3bIVELqBAued6o+/3Rhgfyv
         Y5WJeRsEGsQoiQiwUkOeeANpWRHcpl3zyxF/X4CVepySxu/kI7Ua+IXj52t2aO6WqsNr
         JssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJtPJGrX74z6y3eiYuE1BppPHYbXNU5Plwkze+kOBYU=;
        b=BMCmOdqP3BiLiRxFaUlI+w+E5evDceXYiocEfwx+nURk1eIRWNX1kKQPKJi8Ti9doH
         0bdhWgvPPG1OFzIHJJnm18JPioUi+aOUcXRAMndC/0HMZI2qQYWYkfJAobtjvDvkcGUy
         YmnzlKvj9elKW1OhIIsCYo0w/HABaBmdC5cMaNrHVKaJVhCsx5kGS7FJpyoZjK/j3hR+
         XNCQ6boUYqVtroyq4C0ovVWVmx2Sj8oP++9jT+42kQWYHttDIRgS9SModpYd1HuYofNZ
         3+1Tgv5ZOHaLIpnp6EYk/jZuafjKg/6A1petlwEY4PM84F9lXG2IsfPpYtfIwVPGrj2e
         xwyw==
X-Gm-Message-State: AOAM533t1UPi+z7HrBWGq7skyA7TWP0jPWZArMlLNSLcvL6vHOhEfTMx
        atBsHY1IIrBQ8l+FpWI1PcQ=
X-Google-Smtp-Source: ABdhPJyKB+lGnliqbgXjjNjc5BOQvedPaEpLAZ/Y/MpHFNGaWJUo3NeRBd3+GGDZ8IiE0FQOk939vw==
X-Received: by 2002:a63:ab05:: with SMTP id p5mr21605246pgf.149.1616974082422;
        Sun, 28 Mar 2021 16:28:02 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:1b8f])
        by smtp.gmail.com with ESMTPSA id g15sm896419pfk.36.2021.03.28.16.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 16:28:01 -0700 (PDT)
Date:   Sun, 28 Mar 2021 16:27:59 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch bpf-next v7 00/13] sockmap: introduce BPF_SK_SKB_VERDICT
 and support UDP
Message-ID: <20210328232759.2ixde3jvudnl3pi6@ast-mbp>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 01:20:00PM -0700, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> We have thousands of services connected to a daemon on every host
> via AF_UNIX dgram sockets, after they are moved into VM, we have to
> add a proxy to forward these communications from VM to host, because
> rewriting thousands of them is not practical. This proxy uses an
> AF_UNIX socket connected to services and a UDP socket to connect to
> the host. It is inefficient because data is copied between kernel
> space and user space twice, and we can not use splice() which only
> supports TCP. Therefore, we want to use sockmap to do the splicing
> without going to user-space at all (after the initial setup).
> 
> Currently sockmap only fully supports TCP, UDP is partially supported
> as it is only allowed to add into sockmap. This patchset, as the second
> part of the original large patchset, extends sockmap with:
> 1) cross-protocol support with BPF_SK_SKB_VERDICT; 2) full UDP support.
> 
> On the high level, ->read_sock() is required for each protocol to support
> sockmap redirection, and in order to do sock proto update, a new ops
> ->psock_update_sk_prot() is introduced, which is also required. And the
> BPF ->recvmsg() is also needed to replace the original ->recvmsg() to
> retrieve skmsg. To make life easier, we have to get rid of lock_sock()
> in sk_psock_handle_skb(), otherwise we would have to implement
> ->sendmsg_locked() on top of ->sendmsg(), which is ugly.
> 
> Please see each patch for more details.
> 
> To see the big picture, the original patchset is available here:
> https://github.com/congwang/linux/tree/sockmap
> this patchset is also available:
> https://github.com/congwang/linux/tree/sockmap2
> 
> ---
> v7: use work_mutex to protect psock->work
>     return err in udp_read_sock()
>     add patch 6/13
>     clean up test case

The feature looks great to me.
I think the selftest is a bit light in terms of coverage, but it's acceptable.
I'd like to see the final Acks from John/Daniel and Jakub/Lorenz before merging.
Folks,
please prioritize the review of these patches.
