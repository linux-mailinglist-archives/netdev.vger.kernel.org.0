Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E032821B0
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCFx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCFx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:53:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968CBC0613D0;
        Fri,  2 Oct 2020 22:53:54 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q4so2439495pjh.5;
        Fri, 02 Oct 2020 22:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZpLkhopR7RvaZKej0tLr3XiT6AwIkOjIodaqyAoILX4=;
        b=f/seNY1BqS1fuW+3BBt5TE22tv+sxsB2sKJPkxTwJHD5KGzxSlP2HjigjY4LOhfZ/u
         Jkii6V5xaWx4+O2Hn722cOJOvwhMimvfxd+caaq6Q2GlYRagZrMLESVkcE1z0ixQR31I
         S+1dD44MtirDQ9XQvvMcZ709Q5iLTspCyMKI67Xv+8sqdfzn3nskdi9tGf9yFzopqj1w
         /ikT85IojpD9sEj5PUPlfU1bwYJj8A5SVyXz3UeXVE1jyPFIusHC9UraXRBc/ulGyYk5
         aLEVrUAJosmGbhV+iIUkiP2P1i1WXXfb7ZaHL8TUN+dwuDno41RpUL8WCZlGY6x8QeRO
         0c/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZpLkhopR7RvaZKej0tLr3XiT6AwIkOjIodaqyAoILX4=;
        b=T82udkUCCtST5OkRXcgbgBm1qGX3YWdP46PVPxTllphHIi8wOUuomCPggtOif3FNTj
         yRvtTQ5T5Sa8L/UjN4xoz98Gex7NuI+z1f3lXCn8OZjnNEYMptCqUbVwzKWpDbEXXypW
         q5x/0VV4e5/bGZRgKjIAPfqwYPHehf8k1+86ck2EBJHUBF6t9wKpqiPTjToqnCM/SvCy
         98a6mxDF4UAoebXsLQTQ4AXwAw/s4Xh1GGvHMw+W4fQG9rFH+mPRfCBm27wmssNRQ3N3
         qT98Ve7lVtKL1NI/GvQtFVCYIxPzjjW4o2EHNytkVC++vwEyb7ePRVwtZdX2Qf+78cCb
         n4Aw==
X-Gm-Message-State: AOAM533XZGHbPkfeLj5FBVGxJ9Ee6LL1Mu500wNejEz9ctUP1WTaTfOn
        g9sh4WLPe3iKnBTxCItfrVQ=
X-Google-Smtp-Source: ABdhPJxZAAyoTPwXzIq2v9cLhdcOtS/P7paRo+bVLaSACXvjGc8ZLUNUgJjGiaHmheCQSU0L8Iy59A==
X-Received: by 2002:a17:90a:d311:: with SMTP id p17mr6275885pju.135.1601704434077;
        Fri, 02 Oct 2020 22:53:54 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id u6sm3354301pjy.37.2020.10.02.22.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:53:53 -0700 (PDT)
Date:   Sat, 3 Oct 2020 14:53:48 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20201003055348.GA100061@f3>
References: <20201002235941.77062-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201002235941.77062-1-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-03 07:59 +0800, Coiby Xu wrote:
> This fixes commit 0107635e15ac
> ("staging: qlge: replace pr_err with netdev_err") which introduced an
> build breakage of missing `struct ql_adapter *qdev` for some functions
> and a warning of type mismatch with dumping enabled, i.e.,
> 
> $ make CFLAGS_MODULE="-DQL_ALL_DUMP -DQL_OB_DUMP -DQL_CB_DUMP \
>     -DQL_IB_DUMP -DQL_REG_DUMP -DQL_DEV_DUMP" M=drivers/staging/qlge
> 
> qlge_dbg.c: In function ‘ql_dump_ob_mac_rsp’:
> qlge_dbg.c:2051:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
>  2051 |  netdev_err(qdev->ndev, "%s\n", __func__);
>       |             ^~~~
> qlge_dbg.c: In function ‘ql_dump_routing_entries’:
> qlge_dbg.c:1435:10: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Wformat=]
>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>       |         ~^
>       |          |
>       |          char *
>       |         %d
>  1436 |        i, value);
>       |        ~
>       |        |
>       |        int
> qlge_dbg.c:1435:37: warning: format ‘%x’ expects a matching ‘unsigned int’ argument [-Wformat=]
>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>       |                                 ~~~~^
>       |                                     |
>       |                                     unsigned int
> 
> Note that now ql_dump_rx_ring/ql_dump_tx_ring won't check if the passed
> parameter is a null pointer.
> 
> Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---

Reviewed-by: Benjamin Poirier <benjamin.poirier@gmail.com>
