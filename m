Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BC3CB32B
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 03:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbfJDBzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 21:55:21 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41512 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbfJDBzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 21:55:20 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so2880679pfh.8
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 18:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tIjUI93MXPbThVQ0BONUxbtI2VsE/NWJbHjpyhbmzAo=;
        b=CPNxw/6XvAk7PMkhVYFGDge2LNTuE7zgLHPsmrTigY6I7HK9NGvKM+VBbZdRBuCrcn
         yOXzBNGypSsp8Sz0/OUF2MciVzpB12t58RaFYTS2+rZ5mdER2MPmPM1bSAAlzWfbfueg
         6atu9sZjZL465JoxzrJ86206A/QK4lmXqXtNkXffPtVF2LBXUBxeQ5G1Bzi0AQUZKgaO
         /3PQ9XwcS7s9Zt98m1ZJy25UrqhqEP25Ivj4yfNXOykVxBbvotN7krMwlsTAxWHsodB7
         VOGiMfXxZZG2tg8tH3A7Cm9txUhtJnGDGgDAqLNBjGIjCQ4InOhzzIR23PgXehWnaI09
         5ktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tIjUI93MXPbThVQ0BONUxbtI2VsE/NWJbHjpyhbmzAo=;
        b=Eye1cgSmavudGHKHRTwgezUV34tLMifmobiD0Szl2TQugpwWiGGxfWdnhOWcBD3y4O
         Ht7lBUKicwYgiBdYX9CTBdTc+Tw7W3pUFiszVdBYtao2pw5MucICJQFyBWdtJMQxjqlC
         QXL3gO0+INwEjSKGtMGtdNVW7Tj97MMf+HFHK+naAKovgZpBOkm1lP2pxYSWFL957VVs
         VWOryar8Wj0h9qizLirGooM2Eqk3hiyCFWiYgQu9xqNVCNsR9oTyo0/sRGT4DA5+3zqi
         DtoFfeXUfeGNVk/kDiy6M5U1368B+NRDA1c0Lt2IRxPH03svBui5rh03JZrpi24cpUe2
         OVng==
X-Gm-Message-State: APjAAAUcqzpvZJgguZKEL0O498T6xq33Aa39WMv6y8TpjpVC7/EhIHqs
        lAMUVkDmTz1a5h/fxnEe/gg=
X-Google-Smtp-Source: APXvYqzJ8l4kHFPjS8Lznv3ttGqMgr0XuWRos8ZOnNmLoxnH8RksegKM0yaBmNm9lGStuxyxqPsX3A==
X-Received: by 2002:a63:6a81:: with SMTP id f123mr12910792pgc.348.1570154120130;
        Thu, 03 Oct 2019 18:55:20 -0700 (PDT)
Received: from dahern-DO-MB.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id 2sm4896277pfo.91.2019.10.03.18.55.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 18:55:18 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho>
 <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
 <20191003053750.GC4325@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e4f0dbf6-2852-c658-667b-65374e73a27d@gmail.com>
Date:   Thu, 3 Oct 2019 19:55:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191003053750.GC4325@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 11:37 PM, Ido Schimmel wrote:
>>>>> The new indication is dumped to user space via a new flag (i.e.,
>>>>> 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
>>>>>
>>>>
>>>> nice series Ido. why not call this RTM_F_OFFLOAD to keep it consistent
>>>> with the nexthop offload indication ?.
>>>
>>> See the second paragraph of this description.
>>
>> I read it multiple times. It does not explain why RTM_F_OFFLOAD is not
>> used. Unless there is good reason RTM_F_OFFLOAD should be the name for
>> consistency with all of the other OFFLOAD flags.
> 
> David, I'm not sure I understand the issue. You want the flag to be
> called "RTM_F_OFFLOAD" to be consistent with "RTNH_F_OFFLOAD"? Are you
> OK with iproute2 displaying it as "in_hw"? Displaying it as "offload" is
> really wrong for the reasons I mentioned above. Host routes (for
> example) do not offload anything from the kernel, they just reside in
> hardware and trap packets...
> 
> The above is at least consistent with tc where we already have
> "TCA_CLS_FLAGS_IN_HW".
> 
>> I realize rtm_flags is overloaded and the lower 8 bits contains RTNH_F
>> flags, but that can be managed with good documentation - that RTNH_F
>> is for the nexthop and RTM_F is for the prefix.
> 
> Are you talking about documenting the display strings in "ip-route" man
> page or something else? If we stick with "offload" and "in_hw" then they
> should probably be documented there to avoid confusion.
> 

Sounds like there are 2 cases for prefixes that should be flagged to the
user -- "offloaded" (as in traffic is offloaded) and  "in_hw" (prefix is
in hardware but forwarding is not offloaded).
