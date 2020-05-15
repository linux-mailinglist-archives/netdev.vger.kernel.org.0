Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87D81D5051
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgEOOYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 10:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbgEOOYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 10:24:42 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BF5C061A0C;
        Fri, 15 May 2020 07:24:41 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id d7so2912295ioq.5;
        Fri, 15 May 2020 07:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZXHJyUrVH2Ppo0RJocomeSKiwhEwy0uPA2kDX54AR54=;
        b=EVOFOcmpPDL94IsRjPNvnyIYYQYpP3gS29gJg+dDK92cnvBUvJvEQRYOpAlgc/6M8J
         SZu9kebGfqW5HsI2Bz1KrRTe0IWqxEoVACasn9STHnKgzmmdyVJpi6TW6qxjWpYTBGve
         /OTCdlatjtHh9mvcMVi4LYkvduXle+ccc9ya1M1goXZgh9NK+nuFS6SWE1B9XOjA749k
         bQcMXdJo9MMQKbRWeFCMHwoAsyQY3D0ioDFOafMSfE2VqBBRjGAs6KAIKWt36DwOMgCM
         +JmAdRT0fXBb/78LOXdYE7TcgYXvIUChvrPmVD3cURkn8MTw4pnXHIi+1K+C/L0NzEk9
         pY7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZXHJyUrVH2Ppo0RJocomeSKiwhEwy0uPA2kDX54AR54=;
        b=cc0jmxXxFfU/SU7ZxxhfM6Nnvpr+z270e+LpgTfY0UQYB+WJ9EPeobweTPYI4UWd/o
         5vmsgi/1FRH7g5Nu+1M+epxnzsh9rLRGFkCWDmhucxIYUfW6QCjrcb8LdlDRLEHzvOT1
         6qRrzfVd4Q2QkbQRuLUQwakAXpDQuA5/mp401ngw9/x3th3wRcgPrjUMf6iPis41Wltx
         uy5TTfH28zVEFQPCl4oAwEEUYYbJLD3iyWZNNypf+/L+uHK3ZvQXKI2VdbJ/bRzfufm9
         nEeupKx6qUT3Fpgzj5r/fwnK9PaVUMwSYIjYjA2FDpB+rIQ0NKLnBvJPqJMQig+zeCOp
         0yMQ==
X-Gm-Message-State: AOAM5331YUVCUgWDZc0H5+70F0LTHODZvZcUP4v+Xa2NwS924TiudjOZ
        LPtXFmr0sgSTCnsMew5fF6o=
X-Google-Smtp-Source: ABdhPJyNl4ROAgJEJtTmGy6e1tmEXvkUdqSzy2eIMS5Jif+VoFEb0rQmZXG4MFARY6NWbaESTVHj/g==
X-Received: by 2002:a6b:720d:: with SMTP id n13mr3224903ioc.20.1589552681360;
        Fri, 15 May 2020 07:24:41 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d014:7501:8ef2:43d? ([2601:282:803:7700:d014:7501:8ef2:43d])
        by smtp.googlemail.com with ESMTPSA id t77sm977680ilb.33.2020.05.15.07.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 07:24:40 -0700 (PDT)
Subject: Re: "Forwarding" from TC classifier
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
 <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com>
 <CACAyw9-95He2yq0qoxuWFy3wqQt1kAtAQcRw2UTrqse2hUq1tA@mail.gmail.com>
 <5cca7bce-0052-d854-5ead-b09d43cb9eb9@gmail.com>
 <CACAyw9-TEDHdcjykuQZ8P0Q6QngEZU0z7PXgqtZRQq4Jh1_ojw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b212a92c-7684-8c47-1b63-75762c326a24@gmail.com>
Date:   Fri, 15 May 2020 08:24:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CACAyw9-TEDHdcjykuQZ8P0Q6QngEZU0z7PXgqtZRQq4Jh1_ojw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/20 3:59 AM, Lorenz Bauer wrote:
> 
> Yes, but that doesn't play well with changing the source address to
> the local machine's, since the upper part of the stack will drop the
> packet due to accept_local=0.

Can you defer the source address swap to the Tx path? Let the packet go
up the stack and do the fib lookup again as an skb. neighbor entry does
not exist, so the packet is stashed, neighbor resolution done, once
resolved the packet goes out. tc program on the egress device can flip
the source address, and then subsequent packets take the XDP fast path.

If the next host is on the same LAN I believe the stack will want to
generate an ICMP redirect, but that can be squashed.
