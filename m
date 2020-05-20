Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155911DA845
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 04:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgETCzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 22:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgETCzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 22:55:11 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEA9C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 19:54:02 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 142so2192802qkl.6
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 19:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3QKQMiyMJ8pJ/XPnl2fn2shHWyyK4q/DzoYpKM+kBNQ=;
        b=oPXnwJCrlvlowiFy3+GZkY08UFAR1l1y2LfmzvQspB2hHcK9y9zGBpakX9kF9UmDir
         78d6oRZyGWSZcWCE4J0IKjJgyoth3//uOQR2O5NxhcRNe8skW7LY5p48SXrw6oZNMa4l
         C091bGKLxycVC2wrBWyEzJ16/1hlxQeW9hKEI/qQIlccWfZg4Wxvjt7X/OA3o+45vpip
         hDSvz6R1RDORXfJ1EnMJ2iBXy75bUa0tGbCouDmsq6iYpDewMPTVNDS05787tr0ppddZ
         tjFsda+5yL/IsbAk+Rpo9bKxElP8tlryhQ2Ufi15MDFSUMRCPmwpE0ec8L+5onLRMu+i
         Q/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3QKQMiyMJ8pJ/XPnl2fn2shHWyyK4q/DzoYpKM+kBNQ=;
        b=JZjuJ7AFuJsCKfZQNsgiItVuh4lDBbvWxo+iyfktQiiAIDDuAluOOxTSVUg8S7i7bx
         WsZupgCmcv63HUar/mT/snWP0KZaHpGWyxb+7iBSW4MP0YVTJYTcbg6ApE/m96nmB1ll
         jRbSdHcvg3b0zA761IRO+Cvrrj88hKTU2GrJiUu8uROaUreTsF3j2EVc2IW8etEyOvBc
         M2wkrrvtXATXn7k/icjmYjkXvLw942Aw07J+tqmHMZFZacc8uTJN6H4j/ypd8Wl+Mibn
         sVKBHY3nnFADGsjFPRsgQu6UkJN9p+5GgyGLnSIZPiaIW9NP1dnYMGMxMNw3qENPNOHs
         OkGw==
X-Gm-Message-State: AOAM531gfyuAD81pZ+l50wHdlgAUEEpXXiogeggNTumavzqm5nVlveUB
        0ct6fJf8c4Xd3Xr9IQkPIW4=
X-Google-Smtp-Source: ABdhPJxD7+ZM/73jmhi80bK98feEt4GEs46SULALMK38zGF0QthiRXde20jevLxTE1I8bPg7ePgD5A==
X-Received: by 2002:a05:620a:662:: with SMTP id a2mr2395835qkh.304.1589943241205;
        Tue, 19 May 2020 19:54:01 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d5aa:9958:3110:547b? ([2601:282:803:7700:d5aa:9958:3110:547b])
        by smtp.googlemail.com with ESMTPSA id c71sm1224771qkg.94.2020.05.19.19.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 19:54:00 -0700 (PDT)
Subject: Re: [PATCH] net: nlmsg_cancel() if put fails for nhmsg
To:     Stephen Worley <sworley@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, sharpd@cumulusnetworks.com,
        anuradhak@cumulusnetworks.com, roopa@cumulusnetworks.com,
        sworley1995@gmail.com
References: <20200520015712.1693005-1-sworley@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bb7c50c5-b077-5413-0a6d-fe7f387df55d@gmail.com>
Date:   Tue, 19 May 2020 20:53:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520015712.1693005-1-sworley@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 7:57 PM, Stephen Worley wrote:
> Fixes data remnant seen when we fail to reserve space for a
> nexthop group during a larger dump.
> 
> If we fail the reservation, we goto nla_put_failure and
> cancel the message.
> 
> Reproduce with the following iproute2 commands:
> =====================
...
> Fixes: ab84be7e54fc ("net: Initial nexthop code")
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
> ---
>  net/ipv4/nexthop.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks, Stephen.
