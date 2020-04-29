Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DB11BDBB0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 14:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgD2MPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 08:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbgD2MPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 08:15:18 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3849C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 05:15:16 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id t11so1456561lfe.4
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 05:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fR8uUeszZzFt2LU2tuKirZn9/ZjcfUzUQ8MAaG7aJLU=;
        b=GivbK70Yv83IrbrW7RhyIJdlS0bHppB43QCI+a4XVmY1/4udQeKLqvMPBq7OxM/056
         uwcfBGuL4DltRCWPQVj8cVbNuvYMki5OEe7YtVUPHH9StzW0f3XVWAzDdm6KFjyvo2ZA
         ONal6lpruxUL2QKx/PxeBOHbdefVIbbwQ9vk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fR8uUeszZzFt2LU2tuKirZn9/ZjcfUzUQ8MAaG7aJLU=;
        b=REFIkayk7df4128RpO0FSiRbO5re5MCwwT2cYfgEffBwab2pVGZ5WcNeSGXSbOX2fx
         aMczM0fi5rsxvpUd+G6/te5TCTQBogAxMdWls6498JFhA5tODxRAcL9/XZFmSv+wrBJO
         HvE+UQrCOfSO2SFNVSllOw95ch23vAVJGwbPw618IoyoKsSg8IKTViUvEiL4Dd69VyKb
         KWVLV4WOWa+YJyNr+s26xEYxuYeTT90HdYrhUU/hqxZ/VM8CTs2lLzSsiXrRpYyRmrQ5
         QPeJW9bOXONDMpB2aTO+F3ShoVSYvgugr6HYI0cSt/8qecj4gINhM4BOVDyXuhgd1lXV
         EgkA==
X-Gm-Message-State: AGi0PuZqxu9dcWyNlr6HvfGjNlclGI45iI0vyoDLw9XE2BtQHN2VMKu4
        fND30IvZsea4DOpfq/lr1Zw4uw==
X-Google-Smtp-Source: APiQypLeMlSBJaJY8gtk/W5nI4lvaeHsjiQ1yDq0jG4P+mgzUjcApTyZVTBPIGrd1YKYMhPE7tlb1g==
X-Received: by 2002:ac2:5e26:: with SMTP id o6mr21918859lfg.49.1588162515349;
        Wed, 29 Apr 2020 05:15:15 -0700 (PDT)
Received: from [192.168.1.149] (ip-5-186-116-45.cgn.fibianet.dk. [5.186.116.45])
        by smtp.gmail.com with ESMTPSA id l18sm2183374ljg.98.2020.04.29.05.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 05:15:14 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type printing
To:     Joe Perches <joe@perches.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
 <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
 <alpine.LRH.2.21.2004201623390.12711@localhost>
 <7d6019da19d52c851d884731b1f16328fdbe2e3d.camel@perches.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <9c14a68e-c374-bca4-d0f8-c25b51c8dfe4@rasmusvillemoes.dk>
Date:   Wed, 29 Apr 2020 14:15:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7d6019da19d52c851d884731b1f16328fdbe2e3d.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2020 18.32, Joe Perches wrote:
> On Mon, 2020-04-20 at 16:29 +0100, Alan Maguire wrote:

>>>>   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
>>>>
>>>>   pr_info("%pTN<struct sk_buff>", skb);
>>>
>>> why follow "TN" convention?
>>> I think "%p<struct sk_buff>" is much more obvious, unambiguous, and
>>> equally easy to parse.
>>>
>>
>> That was my first choice, but the first character
>> after the 'p' in the '%p' specifier signifies the
>> pointer format specifier. If we use '<', and have
>> '%p<', where do we put the modifiers? '%p<xYz struct foo>'
>> seems clunky to me.

There's also the issue that %p followed by alnum has been understood to
be reserved/specially handled by the kernel's printf implementation for
a decade, while other characters have so far been treated as "OK, this
was just a normal %p". A quick grep for %p< only gives a hit in
drivers/scsi/dc395x.c, but there could be others (with field width
modifier between % and p), and in any case I think it's a bad idea to
extend the set of characters that cannot follow %p.

Rasmus
