Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0499444253B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhKBBkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKBBkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:40:24 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FD9C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 18:37:50 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id o10-20020a9d718a000000b00554a0fe7ba0so22005607otj.11
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 18:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=l2DELrjzPwvE9HYtmkXg1QHQij7anpRmhUwdOI70V0E=;
        b=gEFgmSZUgKU5rsH5O3g7u1AH2GM4yF4Ca+yN10UU+oy+zvce2CTkL9p05xW6F3ubPs
         tAFNCNDisS+vxcrxe7INkjjrNTgrJgUSynKMS2H/epTH0zMu4u5wuNu6i4J1JdeDBRFK
         BOQcz+e5Xs0Uw22xnwvO5/orvtScAu8FqLvsq7G5xHL3ZMlPZuNtQmyKFyiiDEzw7wD9
         9HlX4scoyhxB8SwCkkybKirUQYw/PX0EHh2r3AcvdK732Pc6bIQ8Y8sH2x7VS18Cm6Uu
         UzjxicIZ+DHDkcbNtLBm+FIO2J0E/Xh2QQRMDVqVK1+3Yo+LCxUSnq8JyhrYCEnpkW3/
         c1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l2DELrjzPwvE9HYtmkXg1QHQij7anpRmhUwdOI70V0E=;
        b=PkEMCibZbiXZslGwm9Rh2GfA4EAeWedcVrT5S69hNwP8uNfTUm2rIMnyOU5JQdpXj+
         za3MVQ06C5funEF5kgcFDT7342TGXedMvaTcGg/MJQVcm8nlmkpGtkbINIs9s7+/IzaK
         33ugmBBcvJhCZOawWFQtCyxpTXdruGuZMURrH70WYXkQ82mIctN6/SRt1YUGlC4nPcCw
         FQEL0P6EAv7ka9t86w7/Mm1zc2GLYnNjp1ne76ZgDNGBcxL4Jpx9Xi2G0nzfl1ibaB0I
         rsNiLWVeEwItIPVoZc992NrucBMjJsGW6k0dZe9StbxTnZrUL4fHVJ50ntlv9ae5UoOj
         KtXg==
X-Gm-Message-State: AOAM532VWTZnvPABzrE2aj1N7wgr27LQ31BT4Ucab3CkMComP7GE4MlM
        e+m8bw0iQpTpisK+JkwrEuE=
X-Google-Smtp-Source: ABdhPJz79VJO7nEhoSOPeKK0xkdjOCAhduRa5t60fCZU7CYkFY1QRFKGPBkJjRQ5q/RV3SfRuIF5kA==
X-Received: by 2002:a9d:4c8c:: with SMTP id m12mr24547249otf.6.1635817069562;
        Mon, 01 Nov 2021 18:37:49 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id g4sm3913101oos.7.2021.11.01.18.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 18:37:49 -0700 (PDT)
Message-ID: <480b2c10-a546-0066-23ed-da1293c13abf@gmail.com>
Date:   Mon, 1 Nov 2021 19:37:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 2/3] net: ndisc: introduce ndisc_evict_nocarrier sysctl
 parameter
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org
References: <20211101173630.300969-1-prestwoj@gmail.com>
 <20211101173630.300969-3-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211101173630.300969-3-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 11:36 AM, James Prestwood wrote:
> In most situations the neighbor discovery cache should be cleared on a
> NOCARRIER event which is currently done unconditionally. But for wireless
> roams the neighbor discovery cache can and should remain intact since
> the underlying network has not changed.
> 
> This patch introduces a sysctl option ndisc_evict_nocarrier which can
> be disabled by a wireless supplicant during a roam. This allows packets
> to be sent after a roam immediately without having to wait for
> neighbor discovery.
> 
> A user reported roughly a 1 second delay after a roam before packets
> could be sent out (note, on IPv4). This delay was due to the ARP
> cache being cleared. During testing of this same scenario using IPv6
> no delay was noticed, but regardless there is no reason to clear
> the ndisc cache for wireless roams.
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  9 +++++++++
>  include/linux/ipv6.h                   |  1 +
>  include/uapi/linux/ipv6.h              |  1 +
>  net/ipv6/addrconf.c                    | 12 ++++++++++++
>  net/ipv6/ndisc.c                       | 12 +++++++++++-
>  5 files changed, 34 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


