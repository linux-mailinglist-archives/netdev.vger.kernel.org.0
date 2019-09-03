Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3157A73E5
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 21:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfICTp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 15:45:57 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43932 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfICTp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 15:45:57 -0400
Received: by mail-qt1-f196.google.com with SMTP id l22so9242749qtp.10
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 12:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MH4LLlIdJXf+zTbhLkrXx/XKCuii6jgmCs2/7MVbCMc=;
        b=Y3vDerq2McIROWjRwLgx6LsQXgH5VgpOJuB8UhUYPFD0vNuasRqgZs6dSabh/piyRg
         hK2jnxaIobHZeKahx7YuHJd0B9BYZ/koMwQ9UgXs2Lrqjy/0VjxEZvFP6CY5jyVt4gXy
         cO8ul4okV9Cz3oeiN1duY9nuUyzc3PWpCDwAN2Wh86NrAApkkQV4I+HLPXywPwfCEoly
         9O1cnustCuHRr5f3Aa6jp6bzZROmSbbuJce3QmThzrBcBP7gCzww4NJbDKZgUq7OuUuM
         lnSyzx2TxD8CKEwtPlEXferFPOE8oDOKFymQXbFljyj1rI99zUm4Sf8dA5J9n6pAYKMR
         UdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MH4LLlIdJXf+zTbhLkrXx/XKCuii6jgmCs2/7MVbCMc=;
        b=Dj8ZT+cQlA7+2JAY4P3nboJrmRQ7NIu7w30jAZuadRHL1knpcpwIuTsT53ZdiTDbjx
         EdDfHHYryMs1BMg9SQ0tCgzj4o02X0V6xwTKR0P9xFVa6o8oMX/WZ2VlgC9lTWcCE9f1
         3bBCSUzPaoWS51hOQEHcpL6gIPJdpJ0VE1sTT/VlQAGq0ppK4gn1yhecSVQEiRyRCXb6
         uYWo78cKTjdnyIj4FL4mthOVSOpO2U6GnUeMVQHPFTtU6ksweACSiVXMd6ZkbOZR4eWm
         7hPfHc4ksRVVFRnmv+9DXIhGT08EInkbCBmeBn2rUBeNZSJcJhdPFwxsmLWxuJrur/qT
         SiyQ==
X-Gm-Message-State: APjAAAWlQMmwb3DRA66vPHW8QOOzw2K+Xe9PFEglsfVFev4Rs/xq5SwQ
        baMZjDRiEFOIOeLWFO0FUwpgVR2s
X-Google-Smtp-Source: APXvYqzOieQRLdpe+0RlJFOTqB7dCW3Y/Ns6vEBNIyw93+z9muHrSxtI0Zh0GmQAybb+b3PZTroL3g==
X-Received: by 2002:ac8:614c:: with SMTP id d12mr35657494qtm.178.1567539955968;
        Tue, 03 Sep 2019 12:45:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:fd80:3904:3263:f338:4c8b])
        by smtp.googlemail.com with ESMTPSA id b27sm8421888qkl.134.2019.09.03.12.45.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 12:45:55 -0700 (PDT)
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>
References: <20190901174759.257032-1-zenczykowski@gmail.com>
 <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
 <CAKD1Yr2tcRiiLwGdTB3TwpxoAH0+R=dgfCDh6TpZ2fHTE2rC9w@mail.gmail.com>
 <cd6b7a9b-59a7-143a-0d5f-e73069d9295d@gmail.com>
 <CAKD1Yr2ykCyEiUyY4R+hYoZ+eWGjbE78wtSf2=_ZjLpCyp0n-Q@mail.gmail.com>
 <CAHo-OoyQzJptNDcLe93o3-G10oRN+93ZZ35jKkLudSanvgn-2Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <60b98521-cf3a-1130-896d-2947fc4d5290@gmail.com>
Date:   Tue, 3 Sep 2019 13:45:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHo-OoyQzJptNDcLe93o3-G10oRN+93ZZ35jKkLudSanvgn-2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/19 6:17 AM, Maciej Żenczykowski wrote:
> Well, if you look at the commit my commit is fixing, ie.
>   commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
> then you'll see this in the commit description:
>   "- dst_nocount is handled by the RTF_ADDRCONF flag"
> and the patch diff itself is from
>   "f6i->fib6_flags = RTF_UP | RTF_NONEXTHOP;
>    f6i->dst_nocount = true;"
> to
>   " .fc_flags = RTF_UP | RTF_ADDRCONF | RTF_NONEXTHOP,"
> 
> (and RTF_ANYCAST or RTF_LOCAL is later or'ed in in both versions of the code)
> 
> so I'm pretty sure that patch adds ADDRCONF unconditionally to that
> function, and my commit unconditionally removes it.
> 

exactly. It was shortsighted of me to add the ADDRCONF flag and removing
it reverts back to the previous behavior.

When I enable radvd, I do see the flag set when it should be and not for
other addresses. I believe the patch is correct.

