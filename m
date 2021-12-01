Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C024644CB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhLACSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhLACSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:18:53 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC6FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 18:15:33 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so11528183otu.10
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 18:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=I7Ej8qs188p2B4AEAU5WYRe+YSbz1jougFanMO40+Ps=;
        b=mH3qiQhSz5gr/GBetgPmqhgQt43OVaRFDsPGZQrXjJcV5HB75vikXQnQ5uzejFEN+U
         BtgxDuzQpG3sLN9ynbNJyKko97sJExeGBPTMIrSy/6uWv7sfxyS8iLp4BDNt5JUT2xJ0
         RRoBTvAwNak/xLUhga+ka16XA8HFrUd/yAyDoqrz0/uVa1ZrQ7hQ1H3hpumfpbhfD0EA
         BEWhMwifUKbS+XoikDgK+Z9H6WYGxNx0Ek3CBW3AbqIbW9jpSNcw57uUI1/KQhxwRWCu
         7PGuthzEIJVi0jXFhSeDWd7rhKl6u3LSuqwDhWIMiFM97BDMO99fBjGdXoynGO01/jOZ
         kFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I7Ej8qs188p2B4AEAU5WYRe+YSbz1jougFanMO40+Ps=;
        b=Ch/6FNC1jWURGzfb0EWvdy4LERwZx5oLF6lCCWo5LizoYPFPp5e9ARb+TlAutMUf5F
         BftfKzJriw1ly+gcz+B4ps99Wn96ck9kG8sCMxUeCxiZXKXNBeg5Y5QenSz+BNIMybf1
         JMKDyRSyz45i9tvEsk2FIvJBNOc8rkoOLhAWAwkEawQlr8V0U0DsFXBW/guWn4Cgm7Fx
         /iOoxD8666keQf8AVn7V8K8lZtahNA7WEjARsOiKrD3/cFlhGaJlf4zmUUP3XfKeXq80
         BLicpRFLShanVm9pZZzuE/KFoRoqrHCER+NLBGMkUcxio8c/scH0ESyLjj8biHBxA1cL
         xxRQ==
X-Gm-Message-State: AOAM531+NHMreU3zZDrRiRnpBahpG7yiVAtocd/WBynjty609NyeUqqp
        y+OxoND9nI1gcv1eQeJLy7itdC9lNI/irA==
X-Google-Smtp-Source: ABdhPJwxay+S+1OXD1K+QmBuiNwyJ/avG9hBr0vy2NA4m5zHu+zRie/HJxmsYprEvObtjnHvzzrbCA==
X-Received: by 2002:a05:6830:3499:: with SMTP id c25mr3188282otu.206.1638324932824;
        Tue, 30 Nov 2021 18:15:32 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id g24sm3462892oti.19.2021.11.30.18.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 18:15:32 -0800 (PST)
Message-ID: <40480957-bc05-9dcd-f565-33faaaaef906@gmail.com>
Date:   Tue, 30 Nov 2021 19:15:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net] vrf: Reset IPCB/IP6CB when processing outbound pkts
 in vrf dev xmit
Content-Language: en-US
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20211130162637.3249-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211130162637.3249-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 9:26 AM, Stephen Suryaputra wrote:
> IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
> in the codepath of vrf device xmit function so that leftover garbage
> doesn't cause futher code that uses the CB to incorrectly process the
> pkt.
> 
> One occasion of the issue might occur when MPLS route uses the vrf
> device as the outgoing device such as when the route is added using "ip
> -f mpls route add <label> dev <vrf>" command.
> 
> The problems seems to exist since day one. Hence I put the day one
> commits on the Fixes tags.
> 
> Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
> Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  drivers/net/vrf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

