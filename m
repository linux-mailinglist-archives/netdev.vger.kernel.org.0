Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF91048F71C
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 14:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiAON2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 08:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiAON2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 08:28:41 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253A5C061574;
        Sat, 15 Jan 2022 05:28:41 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso12421523wmj.0;
        Sat, 15 Jan 2022 05:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:in-reply-to:content-transfer-encoding;
        bh=W34vgF+QY6PHwV2f3DFwv95/36E7hs/TzxxiFpAxgBY=;
        b=fuhXA2ZYCu1HlHnr9B2JgVdgnmEk6eqPUEgdWHwe3+vAtJv9SGFbT1xG5gH9fLQUzw
         Yq6gwJiC5lJrVgGzq7antGASPEJ2YotQ2xzixqEivhSxedCm0UiFWOxR2fYZu1g7t7Yj
         00bRKr5fQwAx8QjsWILoguEq5eepTEcoOQB2XGKwTWhF0TfQJ6g/VIMXZesWwBAxmHuk
         zfCPBoLL+f4TdcEn/YF/skDT99VHbM0YwuUgLInEvpE5k+2K0/lI8+w1HlTgazss48I3
         FQ2ZXnU4yyrPyLI5yAGURDYpdmTTZbYsyFEY5ENLHXAcmmAu7ErFYQ2U0iOqxOyzZPWf
         qbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=W34vgF+QY6PHwV2f3DFwv95/36E7hs/TzxxiFpAxgBY=;
        b=6tU3MzAPQL9EfWBMP7/V7+2VybcYo/6KWD/4H+gW5xLBp4nZ4iKjMCva9FqYyrDH8W
         NWpEWm+igvEwel4JOs+0D3G9O9EwNvZnhnLKpmtCWJs7pMWRpdUl4UKive5r/3817QmM
         ez+2sRq+8auCBNagHBqyMXDa5gxj2qAJtOVmEsPkLJBN3SBhgIuG40uQuGyicEl/Lbfs
         5f5DntxMyGpyAQc78NFL532JUyvGw7Z6QcG4OUCDUcfn3Slos8gjjOZKuM0ey/NuUVyg
         os0nJ+f3FewjML8Hno147vGOuNypPPLy4Tr2TA2s0uh3PfYO5YiwA4KxFNnYluxEteCN
         fgVg==
X-Gm-Message-State: AOAM532f/bYmZJn1HHLDC3wBYQzqzBKaZ1FywweVlwX6mrKuOira1738
        /Pib0Wp9DgDUKgsp5/KbovwWsJN+Z2g=
X-Google-Smtp-Source: ABdhPJxmgJReFqIOKk72gOoDU3eXMOUvPSdAPuFYT0Pg7A44g0BaxU8bJ77q40COTI3o0RIHVfnazA==
X-Received: by 2002:a1c:e909:: with SMTP id q9mr11940446wmc.184.1642253319671;
        Sat, 15 Jan 2022 05:28:39 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id 8sm7692777wrz.60.2022.01.15.05.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jan 2022 05:28:39 -0800 (PST)
Message-ID: <219d9c80-fa47-8359-0b11-e4713d99568a@gmail.com>
Date:   Sat, 15 Jan 2022 14:28:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Possible bug in `tcp(7)` regarding `TCP_USER_TIMEOUT`
Content-Language: en-US
To:     =?UTF-8?Q?Jo=c3=a3o_Sampaio?= <jpmelos@gmail.com>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
References: <CAO_YKa1+A+G-HazuXpepsAqa4CkmQFCWQs+zwSpYo11zuzvLCQ@mail.gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <CAO_YKa1+A+G-HazuXpepsAqa4CkmQFCWQs+zwSpYo11zuzvLCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello João,

On 1/15/22 13:23, João Sampaio wrote:
> Hello,
> 
> The manpage for TCP (`man 7 tcp`, [1]) reads, in the paragraphs about
> `TCP_USER_TIMEOUT`:
> 
> [1] https://man7.org/linux/man-pages/man7/tcp.7.html
> 
> ```
> This option can be set during any state of a TCP
> connection, but is effective only during the synchronized
> states of a connection (ESTABLISHED, FIN-WAIT-1, FIN-
> WAIT-2, CLOSE-WAIT, CLOSING, and LAST-ACK).
> ```
> 
> When I read that, I understand that that option should only apply to
> established TCP connections, and should not apply when trying to
> establish a TCP connection.
> 
> I wrote a simple program to test that:
> 
> ```
> #include <netdb.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <string.h>
> #include <time.h>
> #include <sys/socket.h>
> #include <netinet/in.h>
> #include <netinet/tcp.h>
> 
> // We'll skip error-checking since this is just for testing purposes.
> 
> void do_connect(int with_tcp_user_timeout) {
>     struct addrinfo hint;
>     struct addrinfo *ai;
>     int sock;
>     time_t start;
>     time_t end;
>     unsigned int timeout = 10000;
> 
>     memset(&hint, 0, sizeof(hint));
>     hint.ai_family = AF_INET;
>     hint.ai_socktype = SOCK_STREAM;
>     hint.ai_protocol = IPPROTO_TCP;
>     getaddrinfo("10.0.42.16", "5432", &hint, &ai);
> 
>     sock = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
>     if (with_tcp_user_timeout) {
>         setsockopt(
>             sock, IPPROTO_TCP, TCP_USER_TIMEOUT, &timeout,
>             sizeof(timeout)
>         );
>     }
> 
>     printf(
>         "Attempting to connect, with_user_tcp_timeout = %d... ",
>         with_tcp_user_timeout
>     );
>     fflush(stdout);
> 
>     start = time(NULL);
>     connect(sock, ai->ai_addr, ai->ai_addrlen);
>     end = time(NULL);
>     printf("Done!\n");
> 
>     freeaddrinfo(ai);
> 
>     printf(
>         "with_tcp_user_timeout = %d, took %ld seconds\n",
>         with_tcp_user_timeout, end - start
>     );
> }
> 
> int main(void) {
>     // Let's connect with TCP_USER_TIMEOUT first for faster useful
>     // first data.
>     do_connect(1);
>     do_connect(0);
> 
>     exit(EXIT_SUCCESS);
> }
> ```
> 
> This program gives me the following output:
> 
> ```
> $ gcc main.c -Wall -Wextra -Werror && ./a.out
> Attempting to connect, with_user_tcp_timeout = 1... Done!
> with_tcp_user_timeout = 1, took 10 seconds
> Attempting to connect, with_user_tcp_timeout = 0... Done!
> with_tcp_user_timeout = 0, took 130 seconds
> ```
> 
> So it seems like that option does apply when trying to establish a
> connection! This above output was obtained with Linux 5.15.8 and gcc
> 9.3.0.
> 
> Am I reading the manpage wrong, or is the manpage wrong? Or is this
> just an "undocumented behavior" that shouldn't be relied on and can
> be removed without warning in future releases?

I never used TCP_USER_TIMEOUT, so can't answer.  I added Jerry and David
(and netdev@) to the thread, which I guess should know how to answer you
better.

Thanks,

Alex

-- 
Alejandro Colomar
Linux man-pages maintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
