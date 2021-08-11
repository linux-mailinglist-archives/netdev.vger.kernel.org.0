Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BAF3E95AA
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhHKQPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHKQPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:15:02 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDEDC061765;
        Wed, 11 Aug 2021 09:14:38 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b13so3858085wrs.3;
        Wed, 11 Aug 2021 09:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xRSonHUB76cwySV9QVwkKSX6+w6/+JDvdoHOcSKZR4M=;
        b=F0cociQNYrT7puu4c1/C+wfpMCP80ApBT/f0BZp+HQ4erk9nDnPgwmnMqFVstS9Z77
         FLqQfEhgLlD2uI8hmdLKWSqyUwr7/Ll1y7dxRRha074BCWKapCEzkDWDYP6yo33m6Q69
         KR52Sz+nfZi8ZPiQd/Ox8PTdKzpgHAQMNIiRxS4hbWuFUCpkQOSuEn4a4UnZk92dj62i
         1ru3PzA5PGU7ZsW1XxBZRT7QtcLNDflKVX4whbSDxSWMm0/ay0n/in42KgA4fgS8ekNy
         EcMTRHzK2UuqSlwJKi0rMgjAi198tsds7lVOyuYRTDfVkRH+rolmv76PuYBQRdvuS4nx
         FW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xRSonHUB76cwySV9QVwkKSX6+w6/+JDvdoHOcSKZR4M=;
        b=Nb0QjhAabFXHVterZJUvcJr7FgVhlomeg3SWUAaVtNA72Ji8UnVfQXIT7PRBOgFWHv
         2V5TwJJ/KZEPt5CdOZkPnJGkP4uKtiudNsrKGKtk38gY9Jz7y8oM1ERcdGF8TYsANs4G
         jv698ViuxTGCbwAOnW28qFZE7vY2uc6WAx+oYmQkAw/0sK0YLkojovPoLjPx0LTJGUtX
         44UaJYzSCyzGMSGUDkKReO72fwlBgRZGO5g8Ex6RgliTrHFvzEeuvtiZwTWmnzCDiuXv
         bI7u/qpyr7L+OdHEAZCwtFgXsmll3JtjXZ4qfg0Bzvd0E+nICMvIOQ2TXvt0JaSn0W0D
         4c2A==
X-Gm-Message-State: AOAM530R/H7/+2c1DRtkZC4pWsq7efcd6t1Eytnav0nU/TMdxInmLbUC
        f2zBvOAl0vXqXeczM9SemMc=
X-Google-Smtp-Source: ABdhPJw0gwM4sw04NtRODYD+oOwfpchF+tu0Q0WP+S9Cv2BHqohhAtUWyuRJo4R6DM+gI/3nKFVN1w==
X-Received: by 2002:a5d:6451:: with SMTP id d17mr20741206wrw.154.1628698477050;
        Wed, 11 Aug 2021 09:14:37 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.41.250])
        by smtp.gmail.com with ESMTPSA id l2sm14152724wme.28.2021.08.11.09.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 09:14:36 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] udp: UDP socket send queue repair
To:     Bui Quang Minh <minhquangbui99@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        lesedorucalin01@gmail.com
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com>
Date:   Wed, 11 Aug 2021 18:14:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811154557.6935-1-minhquangbui99@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/21 5:45 PM, Bui Quang Minh wrote:
> In this patch, I implement UDP_REPAIR sockoption and a new path in
> udp_recvmsg for dumping the corked packet in UDP socket's send queue.
> 
> A userspace program can use recvmsg syscall to get the packet's data and
> the msg_name information of the packet. Currently, other related
> information in inet_cork that are set in cmsg are not dumped.
> 
> While working on this, I was aware of Lese Doru Calin's patch and got some
> ideas from it.


What is the use case for this feature, adding a test in UDP fast path ?

CORKed UDP is hardly used nowadays.

IMO, TCP_REPAIR hijacking standard system calls was a design error,
we should have added new system calls.

