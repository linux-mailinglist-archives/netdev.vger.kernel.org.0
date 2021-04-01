Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BDA351956
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhDARw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbhDARtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:49:08 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46960C031166;
        Thu,  1 Apr 2021 09:51:24 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b10so2860876iot.4;
        Thu, 01 Apr 2021 09:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DmfVJtbSnGyYd2SqAzIeEbPnridg9bZgNOGndhX3qPs=;
        b=nZgEaFTptLG4xntpph92OU4DIpkhZJ6XmAe1YUXMbpYJ0R4A0jneE2T7jTSNLKLiWC
         /htGo7C6DsYn4YC4TMiT7MP6ivmvVAF+AATi3XVH3OST03dofWBXbHgOi+r8W7GI/Mhr
         mA7NxgKhpW3i7xeYQdrtqKP+siH8O00gEP3cFzQ1SMSmALPjxvRiuMMt0eGgNcEh27TK
         cFVf4thiJReIkMW7+agfijsM7ramTyAS6D1RbKHdws0WBaiQZAUoucsaQl1U7ccnPPlP
         GwAbrOhL34HkSh3mzctxUxrBVwDnD5zrucZSvO9wjwteAEUTczkzaVwBzRHDW16t3dJn
         zDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DmfVJtbSnGyYd2SqAzIeEbPnridg9bZgNOGndhX3qPs=;
        b=UByAMcA3CPOATxC32TnRdVnu6D+ZI3pTY3KvWUaF1jdBvffAZpJ54jjNJPWOThRMj6
         IJO/ZBpjrhAm8mj25QEM0Qguj/aYsKFc6m8DPFibqhAQ1v4/YpEPxwEInTfeyyGAScuB
         RahEW3JqhUQq6/jA8WL5NCtktvu8u66FUvZCw1imBV02kTb7r9Tq5Z2YIKugUlC4tmSk
         Jq/mQBiRpM0jZEOppZF4NBBO2eF+wW4LF9nM6nibpX10hp9SeCSGKhQ7xEkUXAf4zALw
         IlWUSSRiyYtvMTdRTp3olIzeJhHEdF9zzNUWruAs4DfCPT6d4r8+f1UAGyQkV+NnUduh
         KlaQ==
X-Gm-Message-State: AOAM5331P9ybAPkeuIxdOfdssAOXjgC5/u9hgYYZk+hxbVlMOfPlA4pA
        /2pRbrPoJOpbXZV83Ej1C8U=
X-Google-Smtp-Source: ABdhPJx1P0qIcPLpaZ9cCCT/gaRHe5LD2VfFK4oinDcLSQrrwbdiUgrliGUW3Y3xy7hJWZxiTAUhOw==
X-Received: by 2002:a05:6602:2596:: with SMTP id p22mr7353789ioo.186.1617295883731;
        Thu, 01 Apr 2021 09:51:23 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id w16sm3015989iod.51.2021.04.01.09.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:51:23 -0700 (PDT)
Date:   Thu, 01 Apr 2021 09:51:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Message-ID: <6065fa04de8a2_4ff9208b1@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 00/16] sockmap: introduce BPF_SK_SKB_VERDICT
 and support UDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
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

This LGTM, thanks for doing this Cong.
