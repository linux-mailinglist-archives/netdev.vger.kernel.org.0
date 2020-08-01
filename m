Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39916234F5B
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 03:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgHABzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 21:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHABzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 21:55:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B4FC06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 18:55:06 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f193so4911383pfa.12
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 18:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yAZdBkWJEK9JiccXohfEw4ByOm/L57z2LNyO8IPtqnE=;
        b=XO4ALYhucPa9bjVBxBbjmQbKmZ7YnECNCzSXcLImTp6voKGZ4wAYrM/bSWvkTOF1wH
         HB6v/tYVvfv2VArBpGg8sxCR1Jaog5vjlgIsqqj6kQT31l4aZt3AUD9y0Fm7R9xmQjoV
         GF1X7S1otglRfsAeqOIoKxkQD9bd/+9BgzjAq8C9T46PrQjyRPvBHdpvfRnI06q+Z7ve
         kLyRruwmX3oA8BeFceg33mNnzZXpeLA9U3Omc1DMS/vTQw6b/SXQV31YoCi5Hgx05xSY
         h3mvYUPG1vZ+dBoPwfrsCfsP6vRSNRbcgiyVTncqp+TmqfLAw/+gAf1soH0Bn2iKgZly
         4maw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yAZdBkWJEK9JiccXohfEw4ByOm/L57z2LNyO8IPtqnE=;
        b=qucXzP5uhj4+mA6GHcn8sf6v3SEcts8qIsgftgycpw2kCFzlzLTFaNAhF8xnxUn7fI
         SRw0kFXPymTstxszhYOvchQr8gNjuTi73V2epqSFIscur9wCbeXxUAymdqz0tussNvEF
         FUyoPT0APjS5nDN4hT8JoGfvvJspqQoOVIo1gNcvUUaVY20HVx4A999S8iuMy7A0zl0l
         jGP5cSTh4dO+q0Anpvyp8ps0aIGGDfxk/Sr3qJTN1qI6ndcqIGgOSg0LMSfJDYOtpmft
         +7BhwE4r+FnXs8QJq1Iu6/K8dNKnqgN1zvCnxdjPT22aTSY5m96GJbwIBacMz+wDvP/N
         8wIw==
X-Gm-Message-State: AOAM531v1t6F6kSLjh6g/f+fWoDgkKJi8nO/WRnNxpztnh/7E+E/x7fe
        aL3sHotA/z3RzpfU61Od2ow=
X-Google-Smtp-Source: ABdhPJycvlfn/TRyc/UL5xKFigjYcT3uPOUre8gyNb7M6v4fIi/yEZHktTlHp2DcghimLv88rHXCHA==
X-Received: by 2002:a63:338c:: with SMTP id z134mr6022499pgz.245.1596246906072;
        Fri, 31 Jul 2020 18:55:06 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y8sm10684607pjj.17.2020.07.31.18.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 18:55:05 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 0/9] mptcp: add syncookie support
To:     David Miller <davem@davemloft.net>, fw@strlen.de
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com
References: <20200730192558.25697-1-fw@strlen.de>
 <20200731.165627.166873468993268295.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5ef62124-9c7a-03e7-9a20-665336fd153b@gmail.com>
Date:   Fri, 31 Jul 2020 18:55:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200731.165627.166873468993268295.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/31/20 4:56 PM, David Miller wrote:
> From: Florian Westphal <fw@strlen.de>
> Date: Thu, 30 Jul 2020 21:25:49 +0200
> 
>> Changes in v2:
>  ...
>> When syn-cookies are used the SYN?ACK never contains a MPTCP option,
>> because the code path that creates a request socket based on a valid
>> cookie ACK lacks the needed changes to construct MPTCP request sockets.
>>
>> After this series, if SYN carries MP_CAPABLE option, the option is not
>> cleared anymore and request socket will be reconstructed using the
>> MP_CAPABLE option data that is re-sent with the ACK.
>>
>> This means that no additional state gets encoded into the syn cookie or
>> the TCP timestamp.
>  ...
> 
> Series applied, thanks Florian.
> 

Build is broken

I had to use :

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 11b20474be8310d7070750a1c7b4013f2fba2f55..f0794f0232bae749244fff35d8b96b1f561a5e87 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -213,7 +213,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
                tcp_sk(child)->tsoffset = tsoff;
                sock_rps_save_rxhash(child, skb);
 
-               if (tcp_rsk(req)->drop_req) {
+               if (rsk_drop_req(req)) {
                        refcount_set(&req->rsk_refcnt, 2);
                        return child;
                }
@@ -286,10 +286,11 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
                                            struct sock *sk,
                                            struct sk_buff *skb)
 {
-       struct tcp_request_sock *treq;
        struct request_sock *req;
 
 #ifdef CONFIG_MPTCP
+       struct tcp_request_sock *treq;
+
        if (sk_is_mptcp(sk))
                ops = &mptcp_subflow_request_sock_ops;
 #endif
