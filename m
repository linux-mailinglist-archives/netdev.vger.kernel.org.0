Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE80928BACF
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbgJLO0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgJLO0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:26:38 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2FCC0613D0;
        Mon, 12 Oct 2020 07:26:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o9so11600015ilo.0;
        Mon, 12 Oct 2020 07:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2UGvpwgDLlhT03caF2+q4zHAkpypU3+fNgL0xUTdtrU=;
        b=mvGDqrP9p3tL3W4TJfbU6XV0+zwqkmq/1MfYM7JhbEObjrTw5Zw5P/eYnL+XpYzkyE
         nS2hgsKS5ZRslWOisN0FZGFBqF4bo5ygZwR7SpvMKgRxLThq6IfBelusaWlc60Kiav7E
         ad0EbNGDAd3QWbcivPaFGKzrbLN1KP4wynVw5rdbgEJ4g1jxzsAD5ps6iDfHtC571b2Y
         4CQeGS3NnLyhTha9LvPKb06GA1OVtVTUkdAquPDuWkFQfMp/aJcsX5dtW5Tk0ZMYvSDz
         hvi9KCP2jo32kcQU7b9sn+V+nauyZmbhTFXYf6TYdjf1aRAamz22T6tdBINxlTGWF442
         Nm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2UGvpwgDLlhT03caF2+q4zHAkpypU3+fNgL0xUTdtrU=;
        b=O5rNNSztgBKXhwWCRL/U5xyq25q6x/XXcQpev609xDWTgZfLwC7XyGDKpxEUnoB62W
         JqCGXiUcK8VHWLMBta2iy9TzY2yFws2vI4zMuZvb1fThANer4XsHxFlNwlzwgMWo6iw2
         sNpxDmdKQKdTir0lDWv739Hfv3EJUhSt1TnKbu6Td0AKo8i+JeXCNC7ixCzU6NGcIHRz
         qEw1v9Rs5LaFG889tO1fCTIEPBKOQB0F8DX07BHQO6wzJvEVG8XXDP8OEy7p+zAifoSv
         BlsAcFH4AdODQl68gqER6C3uNAKBYAipGknT07wNmKt+tLUrJrPQjUjb0XgdDNXGL4E1
         OJpg==
X-Gm-Message-State: AOAM53322eIF+ZDSYegVzvPITLCXg2YyAxQVZT6GHQBZfTRGVwcpYmJG
        +vUZ45xLmce0d82VzfjHt2QTtseKMUw=
X-Google-Smtp-Source: ABdhPJyLqqAbLWcjb+L34SpOrIQudGp7Mdq+GZREaVG9wf1YFQ7rfFAYSz88cCa/hqISyS5ggRBjAg==
X-Received: by 2002:a05:6e02:dea:: with SMTP id m10mr4192057ilj.208.1602512797401;
        Mon, 12 Oct 2020 07:26:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id g8sm7471796ioh.54.2020.10.12.07.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 07:26:36 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] l3mdev icmp error route lookup fixes
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Michael Jeanson <mjeanson@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
 <fd970150-f214-63a3-953c-769fa2787bc0@gmail.com>
 <19cf586d-4c4e-e18c-cd9e-3fde3717a9e1@gmail.com>
 <2056270363.16428.1602507463959.JavaMail.zimbra@efficios.com>
 <74f254cb-b274-48f7-6271-4056f531f9fa@gmail.com>
 <90427402.16599.1602511802505.JavaMail.zimbra@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea9e3f3a-9974-7970-5025-33987af7456b@gmail.com>
Date:   Mon, 12 Oct 2020 08:26:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <90427402.16599.1602511802505.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/20 7:10 AM, Mathieu Desnoyers wrote:
> ----- On Oct 12, 2020, at 9:45 AM, David Ahern dsahern@gmail.com wrote:
> 
>> On 10/12/20 5:57 AM, Mathieu Desnoyers wrote:
>>> OK, do you want to pick up the RFC patch series, or should I re-send it
>>> without RFC tag ?
>>
>> you need to re-send for Dave or Jakub to pick them up via patchworks
> 
> OK. Can I have your Acked-by or Reviewed-by for all three patches ?
> 


sure.
Reviewed-by: David Ahern <dsahern@gmail.com>
