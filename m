Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998CE3778F3
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhEIWKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIWKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:10:49 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F36C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:09:45 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id s24-20020a4aead80000b02901fec6deb28aso3081828ooh.11
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 15:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NPeFGBu1iIHqqYN091/XPUGAZew+lI26h0TTRnu9/go=;
        b=ulegOTxf8AO7SRR6b2mu3KNJzfebI4QUhagz8wlqds9zJ2F40T9BVKA6X+SyclT1Iz
         NOHdROM77UW46F8dp+Z9LmgBhq+uKq/mbU3QtUCG0v3YYh0dsSUdTxlAXsZHiAGL0BEi
         yGy0ADemfK6dKEmVIiIGmbDL8hdwughPgzCV9gpsInsfjVEq3bIv5yNAobAuTO0SE288
         7ZWbPhOBCCUuGpx5XcjDCqcxLkujPWB15pxM3/LwIklHnlGrR3rxP9b1qwl7nkAuryra
         8T5GLuwxs51AtcpnOmfFDiksVURjpnzH0BkkRT/zIY08KH2SM9pFpUyObi6k/Tu9lGLd
         BmSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NPeFGBu1iIHqqYN091/XPUGAZew+lI26h0TTRnu9/go=;
        b=LrxGb1Ya9O945dXVZ99lgwY1kimc9pLYa6Tt4Q/Cd7ZBzqd3r8AaScZyWkf1Vm0PfD
         I/LrQflosgTa2Re9ScY1Sw7D+CSugJsg7JuGk9WOFhTApDk3HmpJtWrnQa/NE4FQQyZa
         gh8cfY5572D7DJmWmOK+0Byr9SBKPH0fph+CjH0Lk4M5PR0rT/EBzvARkHGvgODzemWH
         1ChDlaea6uLIo0U0+Pk56QMASMCIj6Y/Skgi2QGSoTo9z2hZ8Mr20u0oKeGvfLY8tQZQ
         +Z/ARHJGjN+Dz+pKwiIY/mo/BKwiVc7oQTpZidCK2DUFOmTxqacjZnvDk0yGlNjQ8G0m
         BtKA==
X-Gm-Message-State: AOAM531yv0Zun8iRdRvnOum3tKne2GFfwAJAaQnl3GdtRVx7ysM1fMxZ
        OLf2ZlxF23zQ0xUoYUIjeGg=
X-Google-Smtp-Source: ABdhPJwCGjHVXCAoyzB9k+9KoNLLs3dw+5rYJxJ0c7XRCCMhYn4mIxaIGgPsRzCaniHuyihKHVWHjw==
X-Received: by 2002:a4a:9c8c:: with SMTP id z12mr16619572ooj.3.1620598184970;
        Sun, 09 May 2021 15:09:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id z4sm2654032otq.65.2021.05.09.15.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:09:44 -0700 (PDT)
Subject: Re: [iproute2] tipc: call a sub-routine in separate socket
To:     Hoang Le <hoang.h.le@dektech.com.au>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au
References: <20210506032724.4111-1-hoang.h.le@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f62d9905-22d1-08db-1b6b-e32e7d089e87@gmail.com>
Date:   Sun, 9 May 2021 16:09:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210506032724.4111-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/21 9:27 PM, Hoang Le wrote:
> When receiving a result from first query to netlink, we may exec
> a another query inside the callback. If calling this sub-routine
> in the same socket, it will be discarded the result from previous
> exection.
> To avoid this we perform a nested query in separate socket.
> 
> Fixes: 202102830663 ("tipc: use the libmnl functions in lib/mnl_utils.c")
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> ---
>  tipc/bearer.c | 50 +++++++++++++++++++++++++++++++++++++++++++++-----
>  tipc/link.c   | 15 +++++++++++++--
>  tipc/socket.c | 17 +++++++++++++++--
>  3 files changed, 73 insertions(+), 9 deletions(-)
> 

applied, thanks

