Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE74756D5
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbhLOKr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241754AbhLOKrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:47:53 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEC0C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:47:52 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j9so5282198wrc.0
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vm1gbSVrpB94zJWkGjZXprd2gvyQcIXoY/zsN4AXLus=;
        b=ff+uCSZUEzvCvuoDSaezUQO/TfCUbYBE4cZ2DA88d2ehL/gfjZOmrmwSdpN0HHP2u+
         DGZVrSwHsjR+TdBpK0Dt6Pve4K9NtsV6HQvVMN0Dx3b36HiC6z/iihSmt2uoMX857qKs
         f2J2ottsD1E7N4vlJauIGUzNbTUbejlaTQ4N3MpgYyX927FEC4XmJE6AYWcpxSjQtY3M
         haNRSTeIfDrKD5ahNGnBnkMvu88sdu7rB+sPDS8BZ/+4fKF6IUEgiTdVa+U57hNZKBhh
         Hv6/6HJ1lrxWzYzmvtSIhzp22RLJpv4bhnugm2Ax4V/ogdBGloXUnvrdKi4XsmVu9HgK
         lTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vm1gbSVrpB94zJWkGjZXprd2gvyQcIXoY/zsN4AXLus=;
        b=kePIoDtzSYu6GGUT8mALT6g+AiyUX6gMnRTw+/f9LlvjmhpFaE+YDFDDteeyi668bQ
         FtfzQ0QghmSRdYwKb80ncA4zaCdoIOtA6FVRH1q4138sw77MpWGMEGuJEkKQ/WGAaa21
         f4ymzbtKNnKIztNe150a6+zHDB/JQ67V6nhjfcgHDo/b1E79Oj8Rm0XIlFjFtL7IzW+R
         hDSRbcpWr7Q9g4B/acphW63M5HkKmSiFszwZtHKE0HD1ZIwIZIpnW+73D0MU5MhfcGb1
         SDaEUDEpkaamsTLVHRcf34cxmByIILX68dgIWzMgOBJ7o6NG3T7GI2T9J5tWgUjLtfgK
         NXWw==
X-Gm-Message-State: AOAM532tFk7MuCOLcSEQ3eYKGMRBQaEqTzaoIqs0jI2m0ZFCp6HRhtlf
        bSHwNtIUP9WhZWhX8U9DPUXsXG4xEG2K+Q==
X-Google-Smtp-Source: ABdhPJwC3et51NM92TPmK8OVaV6AEhNhBFTY+AbT9vQesxJe1jxOz3T7tmLUaWkmJdsdcSR6hSUgfQ==
X-Received: by 2002:a5d:456e:: with SMTP id a14mr4005832wrc.256.1639565271053;
        Wed, 15 Dec 2021 02:47:51 -0800 (PST)
Received: from [10.0.0.11] ([37.165.180.14])
        by smtp.gmail.com with ESMTPSA id m9sm1503942wmq.1.2021.12.15.02.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:47:50 -0800 (PST)
Subject: Re: [PATCH net-next] ethtool: always write dev in
 ethnl_parse_header_dev_get
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20211214154725.451682-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3ea44009-3032-002c-f514-9067ffb00597@gmail.com>
Date:   Wed, 15 Dec 2021 02:47:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211214154725.451682-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/14/21 7:47 AM, Jakub Kicinski wrote:
> Commit 0976b888a150 ("ethtool: fix null-ptr-deref on ref tracker")
> made the write to req_info.dev conditional, but as Eric points out
> in a different follow up the structure is often allocated on the
> stack and not kzalloc()'d so seems safer to always write the dev,
> in case it's garbage on input.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Yep, this was basically how I wanted to fix this.


Reviewed-by: Eric Dumazet <edumazet@google.com>


> ---
>   net/ethtool/netlink.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 767fb3f17267..f09c62302a9a 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -141,10 +141,9 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
>   		return -EINVAL;
>   	}
>   
> -	if (dev) {
> -		req_info->dev = dev;
> +	req_info->dev = dev;
> +	if (dev)
>   		netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
> -	}
>   	req_info->flags = flags;
>   	return 0;
>   }
