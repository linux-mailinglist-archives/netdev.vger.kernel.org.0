Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E3B321E90
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 18:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhBVRzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 12:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhBVRzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 12:55:41 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C447C0617AA
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 09:55:11 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u8so14150954ior.13
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 09:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4iQ/6A1pHeGyjMlUbh4JKbPflnnpW7pvKy+xN/oRk5Y=;
        b=Ctq58+IKe14DzaazBQFfQpQop6MG4aYU6Z5+wu/jIdnqat1f5A2aZPnQgtLwjx7HDD
         IfaxJO4Mn6OpnH5bljeYxw6T+sbJh1L7obl05QFMtBwmz/NXJS9Tsvt+xLTU7DUIbLtJ
         7Tcd7hWJ3W9wDPP1rd/xiD4ch7FZQLJCHun4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4iQ/6A1pHeGyjMlUbh4JKbPflnnpW7pvKy+xN/oRk5Y=;
        b=ondJVnHy30QtLwgQnMWMjKFtnIYeDYfdwiRCm3qrzoBe0uG446lzYez42AoKNju+SX
         4T5wmnhek6UPNBozmbTLId5fMWT3u9cfWP9H/t/LvAULBzI9Vks6YnLSzz/X+UfEUYfB
         GhdZ6G92v3+gZO1H/pvpIsmWy483hvLnxBtS817n3ovQ/6J7Yv9wbOin9h/aXP8YjLfr
         Bt08iguHm5e0a2giYAgIMemEsjqdnMU9sVD2Xu+9oU0hkE7LbB5IREN0dDRDKLgGpTwc
         bC/tGT0VnuvJnHmSCqpsZ14PoT8Nmx2AcoziwNaUqsUbxeb01JoOJE/177hkpTGlGi8I
         bA1g==
X-Gm-Message-State: AOAM531K1hykk9GLWtI6C7BojIZ1221YmmS+0KzU8gBRtjhDlrsakeaQ
        ws4rogQ5a7UTyx14T6KlSmGxhA==
X-Google-Smtp-Source: ABdhPJzxm2PkzLxteZZw8GajkbO500BR3wcCKJELWz5XqxFC0IfTEpzNHbP9K5Jv+kGcI/WnHtrOqA==
X-Received: by 2002:a6b:b2c2:: with SMTP id b185mr16611880iof.104.1614016511045;
        Mon, 22 Feb 2021 09:55:11 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id j25sm13656433iog.27.2021.02.22.09.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 09:55:10 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: rmnet: Support for
 downlink MAPv5 checksum offload
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1614012946-23506-1-git-send-email-sharathv@codeaurora.org>
 <1614012946-23506-3-git-send-email-sharathv@codeaurora.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <f968761d-2567-4538-c4cd-e1cb66d47bcd@ieee.org>
Date:   Mon, 22 Feb 2021 11:55:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1614012946-23506-3-git-send-email-sharathv@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/21 10:55 AM, Sharath Chandra Vurukala wrote:
> Adding support for processing of Mapv5 downlink packets.
> It involves parsing the Mapv5 packet and checking the csum header
> to know whether the hardware has validated the checksum and is
> valid or not.
> 
> Based on the checksum valid bit the corresponding stats are
> incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
> or left as CHEKSUM_NONE to let network stack revalidated the checksum
> and update the respective snmp stats.
> 
> Current MapV1 header has been modified, the reserved field in the
> Mapv1 header is now used for next header indication.
> 
> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
> ---

. . .


> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
> index 9661416..a6de521 100644
> --- a/include/linux/if_rmnet.h
> +++ b/include/linux/if_rmnet.h
> @@ -1,5 +1,5 @@
>   /* SPDX-License-Identifier: GPL-2.0-only
> - * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights reserved.
>    */
>   
>   #ifndef _LINUX_IF_RMNET_H_
> @@ -8,11 +8,11 @@
>   struct rmnet_map_header {
>   #if defined(__LITTLE_ENDIAN_BITFIELD)
>   	u8  pad_len:6;
> -	u8  reserved_bit:1;
> +	u8  next_hdr:1;
>   	u8  cd_bit:1;
>   #elif defined (__BIG_ENDIAN_BITFIELD)
>   	u8  cd_bit:1;
> -	u8  reserved_bit:1;
> +	u8  next_hdr:1;
>   	u8  pad_len:6;
>   #else
>   #error	"Please fix <asm/byteorder.h>"

. . .

I know that KS said he is "not convinced that it is
helping improve anything" and that it "just adds a
big overhead of testing everything again without
any improvement of performance or readability of
code."  But I will ask again that these structures
be redefined to use host byte-order masks and
structure fields with clearly defined endianness.

I strongly disagree with the statement from KS.
Specifically I feel the whole notion of "bit field
endianness" is not obvious, and makes it harder than
necessary to understand how the bits are laid out
in memory.  It also obscures in code that bit fields
have certain properties that are different from other
"normal" struct field types (such as alignment, size,
or atomicity of the field).  And I say this despite
knowing this pattern is used elsewhere in the
networking code.

In the first version of the series, Jakub asked that
the conversion be done.  I offered to implement the
change to the existing code, and that offer stands.
I can do so fairly quickly if you would like to have
it soon to build upon.

Either way, I would like a chance to review the
rest of this series, but I'd like to get this issue
resolved (either decide it must be done or not)
before I spend more time on that.

Thanks.

					-Alex
