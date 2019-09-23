Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A8DBBDF7
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 23:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503114AbfIWVbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 17:31:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39029 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729120AbfIWVbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 17:31:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id v4so5331494pff.6;
        Mon, 23 Sep 2019 14:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M2IFVrWJfMOAbZ8zA9rzidNehYbIVV/clhh3kKcrw9E=;
        b=o8Q/uBGSu8ZdsYS0hUd/MewIisiM0eWQnwEplzkf+gYm/+TEQ0x7wO5DVHWHHVe/1B
         0R0x1l1ZgAZL2svOvsBblBhkx5ehvs33a2hc77H9E6JVDuHr4xO8nflmbNTSSO5jD9iQ
         h4hdHieLDX+zxUZwtq2k28rij1Zk4LOQEoC4vll4zH/9+V+z8ZHdrlLNkJ9veJHtkxnt
         PLv3/AUQxmm8hLJdIYeGw2crjNLORwJVUzqMuxBVVf9cgcI4a5WWmlBYmZKVDoesuY+l
         kJhKM/vSQcJ9fjG9cZDQzi+wF15QqnJHsXhg3AnAD4+JcbXEzmxJwwEhbqD4zA/IVwoE
         TxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M2IFVrWJfMOAbZ8zA9rzidNehYbIVV/clhh3kKcrw9E=;
        b=o9ZOte/izGDEaX426hAhp0oZlnRj9vetu0m2ce6mteC2OjvhqX/Oucp+S3JyKOtlQZ
         d+uHIsZns5E8zMOIdtuzwbYLEJ0Lk4P/A4ZWLR9zR4t7kGDtn6MODbENmokM50kgtcpd
         dcf2mjgtKznOzoaIJCmXCRL//aT0sI4qnL2Kt53foyyEsoghLtCKA942fp9V/j936DIN
         32mjHvTe2xT1AsKhMuG6vdnKsHua70JCiHqjCHmsZgCSg3iCdoh9fMh0SoCd+INoMyMr
         G9RPG6q7puGjSg9Iva/OdNXrZezaEIQr4LQw1Ioaq09q+pBzrHbewKm2RqXjI4iOhSl8
         dlDA==
X-Gm-Message-State: APjAAAWa6Pzdpd1qYL2W9Lm3tsF/otwWmuBrAGBTqRqbgUmxCssItAyu
        rF65gMwOZWT+iTI/SowUTNLuUUoK
X-Google-Smtp-Source: APXvYqz11dgh3msJRTJFiRiQ3k2P7vA2ePQWKiABBwCaAzm+nc2axjz7y3bjzbHGSmKtH1j4Z0C4gg==
X-Received: by 2002:a17:90a:8d13:: with SMTP id c19mr1716231pjo.142.1569274267670;
        Mon, 23 Sep 2019 14:31:07 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id z22sm12576337pgf.10.2019.09.23.14.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 14:31:06 -0700 (PDT)
Subject: Re: [PATCH] kcm: use BPF_PROG_RUN
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Herbert <tom@herbertland.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190905211528.97828-1-samitolvanen@google.com>
 <0f77cc31-4df5-a74f-5b64-a1e3fc439c6d@fb.com>
 <CAADnVQJxrPDZtKAik4VEzvw=TwY6PoWytfp7HcQt5Jsaja7mxw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <048e82f4-5b31-f9f4-5bf7-82dfbf7ec8f3@gmail.com>
Date:   Mon, 23 Sep 2019 14:31:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJxrPDZtKAik4VEzvw=TwY6PoWytfp7HcQt5Jsaja7mxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/19 10:06 AM, Alexei Starovoitov wrote:
> On Fri, Sep 6, 2019 at 3:03 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 9/5/19 2:15 PM, Sami Tolvanen wrote:
>>> Instead of invoking struct bpf_prog::bpf_func directly, use the
>>> BPF_PROG_RUN macro.
>>>
>>> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> Applied. Thanks
> 

Then we probably need this as well, what do you think ?

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 8f12f5c6ab875ebaa6c59c6268c337919fb43bb9..6508e88efdaf57f206b84307f5ad5915a2ed21f7 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -378,8 +378,13 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 {
        struct kcm_psock *psock = container_of(strp, struct kcm_psock, strp);
        struct bpf_prog *prog = psock->bpf_prog;
+       int res;
 
-       return BPF_PROG_RUN(prog, skb);
+       preempt_disable();
+       res = BPF_PROG_RUN(prog, skb);
+       preempt_enable();
+
+       return res;
 }
 
 static int kcm_read_sock_done(struct strparser *strp, int err)
