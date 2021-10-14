Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB842DB67
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhJNOZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhJNOZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:25:09 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804CFC061570;
        Thu, 14 Oct 2021 07:23:04 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e144so3983387iof.3;
        Thu, 14 Oct 2021 07:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mt7eSnisz45ZsPSM8T/CyIaaGlSe2WoikJOLdy55U7A=;
        b=b/+13GqizBkyQwbg9vChBahGTiqrD4hBhOC4AqJlCQ0yCGM9/RZb2zI5vXVccLAgSi
         u/OHC19T0yYS2Z/kqDdI5afSR0k1SozamnPm8ASGNNUzpbDq+6MrFgRpB48SjZ4iZVXN
         6XMBDcF3mBy87w7MqSCOZ/05LUjxcd9Gehduf5zFtovpg8NpId4uUVNNVy7vmhVYWzAm
         kSGuOOLjnrppjsWzmhhoyALMADb/8e9+QufS1tCBzRhtgeDCLOs1v4UhWtVzO7FyYWO5
         zXM6l6D62ZWCHtnTznW5U836wVxtDLu9FZr/gYb5jW5cd8UgrmdCnrxstI38zPpS2/yn
         pxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mt7eSnisz45ZsPSM8T/CyIaaGlSe2WoikJOLdy55U7A=;
        b=5iwunmFgC/EOSG05PPc9BM3X+tmlmex82eFo2pSZVlOuE1IXEmSL56BkpzgCc+t30v
         h4YsQjX0W5TGkGPjzmTuqxeaxNWPIkp40ZR3jkmLcvwnYGuz9Kk8Hzb56xxtKtit1QAa
         84ZJCrdM9UGWlOyfYlSKckIwBC18ao1jodXRej0d5yK+rccRZuBYEwbtOHR5fdK4/9jt
         rmgs8zq7m6B2Su9DTNiL2lmCVW1dlpQivn/PzXg6213VbgRpPETCC11IArAGZ4DSnexp
         r/S+9AuojarOHfbdv+QuzA0ZHbssEJFjs63uL4lsmKh00ng4aAZ5kXuu7rGc1aX0BC2+
         olzA==
X-Gm-Message-State: AOAM533FSwZF3Q9OYIth4NZiPbBlPvNrFRkli3BJ2b/CzoBda5a0FxbO
        PNJlyPINXxgyMMW8teP6kM2L2a9wSeVY4g==
X-Google-Smtp-Source: ABdhPJwgZ60i/G0ismeNtF5i1XGADyqWtULwrLnxxDZzRAOWiL4vfwUyM2ofEsOxrK4Eu2r/fMDnpw==
X-Received: by 2002:a6b:3e04:: with SMTP id l4mr2698067ioa.19.1634221383852;
        Thu, 14 Oct 2021 07:23:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id l10sm1265457ioq.8.2021.10.14.07.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:23:03 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] tcp: md5: Allow MD5SIG_FLAG_IFINDEX with ifindex=0
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634107317.git.cdleonard@gmail.com>
 <9eb867a3751ee4213d8019139cf1af42570e9e91.1634107317.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <80d100c7-56d7-f523-f01e-67daaaa73e1c@gmail.com>
Date:   Thu, 14 Oct 2021 08:23:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <9eb867a3751ee4213d8019139cf1af42570e9e91.1634107317.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 12:50 AM, Leonard Crestez wrote:
> Multiple VRFs are generally meant to be "separate" but right now md5
> keys for the default VRF also affect connections inside VRFs if the IP
> addresses happen to overlap.
> 
> So far the combination of TCP_MD5SIG_IFINDEX with tcpm_ifindex == 0
> was an error, accept this to mean "key only applies to default VRF".
> This is what applications using VRFs for traffic separation want.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  include/net/tcp.h   |  5 +++--
>  net/ipv4/tcp_ipv4.c | 26 ++++++++++++++++----------
>  net/ipv6/tcp_ipv6.c | 15 +++++++++------
>  3 files changed, 28 insertions(+), 18 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
