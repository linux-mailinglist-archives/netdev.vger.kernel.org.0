Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49267475329
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 07:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbhLOGtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 01:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240122AbhLOGtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 01:49:35 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3B1C06173F
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 22:49:35 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o13so36298848wrs.12
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 22:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=d1ToojkIgklMB+4yJ7wavNNpDv07oHI9Uz3VmK4pBHA=;
        b=pWt085OoLtnHGEYfbyD38ZuZCPBCdpxa3JNzoRKz7r+1W64h5LGIRDL+cY+vL1Xxza
         mQfdu1EVE8D5nMBc8N56NeWgrSVYzCboFs+QZT95uIqBY7LSda7H61oR2WPJzndr2DYf
         awU+w3P1JtATCh5lkzNjwqIYpazCNrvXYtAvRVEn+wLaVsCqlKH/3Wg6xJ0a5ymXhlz7
         uuAGnkrHPSWclqQjiNum9E2rwLxl79bPM1fvuiudSN0OYm6YUBs8jgLLq5nodAGlxhBR
         Gk8gNxjkM4bmBzsa76J0KcXuLXrcg5Rh3OdWv5OhOTyl4FedkuundOdWVJTLlKLHr6bD
         J/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d1ToojkIgklMB+4yJ7wavNNpDv07oHI9Uz3VmK4pBHA=;
        b=heP6URYsZomtHUvV1k6ZpDV+ilmXcXnUSosujbAurw8ANj+tSQI8v9WWuQxTGI0q9k
         Xjl+EJvVwPGRkAYmxk09PWu+Y3at3JbD+ffZ3I17n9oyumYcdwuTvqfL87ox+yLfJiQD
         AYdkPX9bJWEVA1uR7aRYnejrSPVRGu1ZHFRPXt4lZo7EWRBizYdrTxNzPrWiNDacGOvX
         Gg+IyO4IHVX8cLIwioFvThUhhXa0/p7GTzb+9ccn8kk13649CH5AKIIKSMi2rqqBU011
         /aHo5kgEebuPK1CFYY04Sf7Ed4ExxscKGBWyU5ENFGUzh4x6NhmrcFY9bFQwQmsRoUOe
         Hfkw==
X-Gm-Message-State: AOAM5303Wmi7xiBHdlknaGzf+H8lJhyneHMgiu5x2PVoLgvTDlCsHsYE
        BaFRN2O+g7kCFtirssbdkAPLsg==
X-Google-Smtp-Source: ABdhPJyahB3zCXmo7DIPu0LNNlK0jgC448teBE2QGy3RKNDKLdrrKJoAh7KlN5LPDkMBJ+Eh7J+5GQ==
X-Received: by 2002:adf:e58e:: with SMTP id l14mr3092324wrm.518.1639550973613;
        Tue, 14 Dec 2021 22:49:33 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id g198sm1067840wme.23.2021.12.14.22.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:49:32 -0800 (PST)
Date:   Wed, 15 Dec 2021 06:49:30 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] sctp: hold cached endpoints to prevent possible UAF
Message-ID: <YbmP+gzoCyKiEJBM@google.com>
References: <20211214192301.1496754-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214192301.1496754-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021, Lee Jones wrote:

> The cause of the resultant dump_stack() reported below is a
> dereference of a freed pointer to 'struct sctp_endpoint' in
> sctp_sock_dump().
> 
> This race condition occurs when a transport is cached into its
> associated hash table followed by an endpoint/sock migration to a new
> association in sctp_assoc_migrate() prior to their subsequent use in
> sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
> table calling into sctp_sock_dump() where the dereference occurs.
> 
>   BUG: KASAN: use-after-free in sctp_sock_dump+0xa8/0x438 [sctp_diag]
>   Call trace:
>    dump_backtrace+0x0/0x2dc
>    show_stack+0x20/0x2c
>    dump_stack+0x120/0x144
>    print_address_description+0x80/0x2f4
>    __kasan_report+0x174/0x194
>    kasan_report+0x10/0x18
>    __asan_load8+0x84/0x8c
>    sctp_sock_dump+0xa8/0x438 [sctp_diag]
>    sctp_for_each_transport+0x1e0/0x26c [sctp]
>    sctp_diag_dump+0x180/0x1f0 [sctp_diag]
>    inet_diag_dump+0x12c/0x168
>    netlink_dump+0x24c/0x5b8
>    __netlink_dump_start+0x274/0x2a8
>    inet_diag_handler_cmd+0x224/0x274
>    sock_diag_rcv_msg+0x21c/0x230
>    netlink_rcv_skb+0xe0/0x1bc
>    sock_diag_rcv+0x34/0x48
>    netlink_unicast+0x3b4/0x430
>    netlink_sendmsg+0x4f0/0x574
>    sock_write_iter+0x18c/0x1f0
>    do_iter_readv_writev+0x230/0x2a8
>    do_iter_write+0xc8/0x2b4
>    vfs_writev+0xf8/0x184
>    do_writev+0xb0/0x1a8
>    __arm64_sys_writev+0x4c/0x5c
>    el0_svc_common+0x118/0x250
>    el0_svc_handler+0x3c/0x9c
>    el0_svc+0x8/0xc
> 
> To prevent this from happening we need to take a references to the
> to-be-used/dereferenced 'struct sock' and 'struct sctp_endpoint's
> until such a time when we know it can be safely released.
> 
> When KASAN is not enabled, a similar, but slightly different NULL
> pointer derefernce crash occurs later along the thread of execution in
> inet_sctp_diag_fill() this time.
> 
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: lksctp developers <linux-sctp@vger.kernel.org>
> Cc: "H.P. Yarroll" <piggy@acm.org>
> Cc: Karl Knutson <karl@athena.chicago.il.us>
> Cc: Jon Grimm <jgrimm@us.ibm.com>
> Cc: Xingang Guo <xingang.guo@intel.com>
> Cc: Hui Huang <hui.huang@nokia.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: Daisy Chang <daisyc@us.ibm.com>
> Cc: Ryan Layer <rmlayer@us.ibm.com>
> Cc: Kevin Gao <kevin.gao@intel.com>
> Cc: linux-sctp@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  net/sctp/diag.c | 4 ++++
>  1 file changed, 4 insertions(+)

Ignore this one.  For some reason 1/2 didn't send.

Submitted a RESEND of the set.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
