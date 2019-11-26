Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552C410A71F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKZXdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:33:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40028 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKZXdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:33:17 -0500
Received: by mail-wm1-f67.google.com with SMTP id y5so5338258wmi.5
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tiwj4UiwaPcuuH8COeSuJeqnUeyz7Jn2pw/GZPc6fL4=;
        b=vWXHJloVmk7tQPZFwd6jrmdM2Ed4T99C5truYI5thaUBfORgLouTv02or4gzYrECc8
         Nue/zFtLXxT6onxDK9zYn7JFxiYIq726fWixOlPzXugVSjgEGI9d9dEgqGGvwEh02RIu
         sPDKtWEyDZ14eKwqvDSm9/2Csq5pZbefFZewrG7vMXM1X8XQi2wclDK6UoVp514pZCKJ
         /fsaDxlxJHrcVSE3a5UcVVGH3xFXqhVShGMk0zqsPHvGQg+09DbqRpuuDG1xxvs6D3tS
         85zVYyLTocgaK2WmG6heWsCxcJGp2G/yG1je2ceOP2G7jyFFaLIV/SX0GQhI6gfKCQ0X
         x/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tiwj4UiwaPcuuH8COeSuJeqnUeyz7Jn2pw/GZPc6fL4=;
        b=m1pXZk1WqfNaDutmmlhJCpzK56wfQJ2AoSdrKZm1U+et7B0Z/UjY8g5urGRgr6n6Qz
         H5xrQr7f1irsFHlQtudOiiW6muxFoqsNXsQmxGWaEbxrsFGqsQY2BWON0/dHBrerPzei
         WLlmUKO1EEP7NQ4HtmVgaH1JwpLR5uuQUy29giz5fYmdar5pqhPLOlBgioCu/apCHKW7
         /kAJrgtcNePUuLFJi5fW0AJyB1zb2Z5ii9ODnMCZj0k+n07OSgItmIJrCI1Oh73tAXuX
         psX74zJt6gxIABCp6r4KE96SdzyCOtFCnJQt+ILfnlLBun+I+05Ezg+zOE4dIvTGMpRY
         Kr/Q==
X-Gm-Message-State: APjAAAXdjgSJK1FSX28pLwAmVxFdwf+ZtXiGPJvZi2iVv1Q1cKQ80BRZ
        6E+NDS15WDt89OrmHYKhejxXX50F8weFrPpb
X-Google-Smtp-Source: APXvYqxth5t4bxB+UOHOViPbPSMb4lLs6d6v1krRhyrgNz7cs9gaNUEWqld0s6p6AvMml1+pM8D/yw==
X-Received: by 2002:a1c:3c86:: with SMTP id j128mr1306812wma.137.1574811194139;
        Tue, 26 Nov 2019 15:33:14 -0800 (PST)
Received: from [10.10.9.42] ([195.65.134.34])
        by smtp.gmail.com with ESMTPSA id d18sm17833106wrm.85.2019.11.26.15.33.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 15:33:13 -0800 (PST)
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment is
 not set
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
References: <20191124132418.GA13864@fuckup>
 <20191125.144139.1331751213975518867.davem@davemloft.net>
 <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
 <10e81a17-6b38-3cfa-8bd2-04ff43a30541@gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <a78cf0a6-3170-bb5f-4626-11c22f438646@gmail.com>
Date:   Wed, 27 Nov 2019 00:32:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <10e81a17-6b38-3cfa-8bd2-04ff43a30541@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

On 26.11.19 23:45, Eric Dumazet wrote:
> 
> 
> On 11/26/19 11:10 AM, Oliver Herms wrote:
>>
>> What do you think about making this configurable via sysctl and make the current
>> behavior the default? I would also like to make this configurable for other 
>> payload types like TCP and UDP. IMHO there the ID is unnecessary, too, when DF is set.
>>
> 
> Certainly not.
> 
> I advise you to look at GRO layer (at various stages, depending on linux version)
> 
> You can not 'optimize [1]' the sender and break receivers ( including old ones )
> 
> [1] Look at ip_select_ident_segs() : the per-socket id generator makes
> ID generation quite low cost, there is no real issue here.
> 

ip_select_ident_segs() is not the issue. The issue is with __ip_select_ident
that calls ip_idents_reserve. That consumes significant amount of CPU time here
while not adding any value (for my use case of company internal IPIP tunneling 
in a well defined environment to be fair).

Here is a flame graph: https://tinyurl.com/s9qv9fx
I'm curious for ideas on how to make this more efficient.
Using a simple incrementation here, as with sockets, would solve my problem well enough.

Thoughts?

Thanks
Oliver
