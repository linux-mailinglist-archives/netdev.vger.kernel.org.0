Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F9A412A58
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhIUBk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhIUBiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:38:23 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0A8C0F26EF;
        Mon, 20 Sep 2021 12:19:20 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q26so32659859wrc.7;
        Mon, 20 Sep 2021 12:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zn6E5ZQEnhBIjrLqGG2ocBWfZkloXRG9O89ektDdbwo=;
        b=YxbzXV0depQzsyfE8ap8QQxP+ftYOMD0mmb8wr17aRDOymorLXOpANYKCHtEwV8/hK
         WJpoSCHhf+Seni9te2sTvK12otX6FGTvK6blNSkFYHnUxaB+CO9ViQ24O9RXGeEEaDYL
         2/Cb6oG8fKht3BLsUYMQ7Yu606aLy+OTaWsO7TQLOw+4YTaWunWzNdWvL+rJBgQBi9dp
         ghVhZVuwLrDdab0oFOfvK54qF6mEJ4bqvo/uDr8ubBH/S5mxvec2pbml+FEACgDVyYzm
         Nihu01lQaf/LbH41FYYGuG3RFXZxCFUlczb/sumQvcIT1nR4jI2U5bDEcgvKeGi9LhXb
         OxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zn6E5ZQEnhBIjrLqGG2ocBWfZkloXRG9O89ektDdbwo=;
        b=S7czhRJsnCcQony00Wr6lN6SWeRd+0PHg/Lt0IfF83fcenVMZfwpdhkjCIeTFfEpU6
         ImOHq8nP9tphjR3KwuzHP0zZWFlTrIesE8u3N7P/QlNY7e2oMjCeFgtE0tNDCFeSRbN8
         RNGAbYVgy3tDTYdr6SsaficY9gxz4DVbRvmQlxfUm9TKwkZJTvekaiaBE2c/qT0AaBvA
         R+3ojtBWdMkuI4VKyZRUZnVc9rK34xKREV0BCL0/7LjcBlXYTCvuYFpI3n1Gub8vqqnW
         RC0yoYL0yNJKfkt4/YzgbG4TQAzTBRq+PsmN0OWmgAFoQ+hWni9/tcJUZfS4bAeJrMUs
         ngXw==
X-Gm-Message-State: AOAM532TjvHW4oOXLUxAbgo6uZkRERIOVIePDe7pvMnOHe/L426Qu4uM
        MnSqrPSlr+ZSGcb5Tyt0zFXeKZ1HWTU=
X-Google-Smtp-Source: ABdhPJwpuJHnG6wEweu0AG1zY54nGYq1Lt4P+waYA/46JzJc04ww9oNMUDPQ43PSx2iIlxEcllEbMQ==
X-Received: by 2002:a5d:4481:: with SMTP id j1mr7818486wrq.6.1632165559183;
        Mon, 20 Sep 2021 12:19:19 -0700 (PDT)
Received: from [10.8.0.102] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id v191sm377637wme.36.2021.09.20.12.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 12:19:18 -0700 (PDT)
Subject: Re: [PATCH v2] packet.7: Describe SOCK_PACKET netif name length
 issues and workarounds.
To:     Ralf Baechle <ralf@linux-mips.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        Thomas Osterried <thomas@osterried.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
References: <YUNIz64en4QslhL6@linux-mips.org>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <4ab8a2b2-069f-9950-7e2c-ce2cc815dd01@gmail.com>
Date:   Mon, 20 Sep 2021 21:19:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YUNIz64en4QslhL6@linux-mips.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ralf,

On 9/16/21 3:38 PM, Ralf Baechle wrote:
> Describe the issues with SOCK_PACKET possibly truncating network interface
> names in results, solutions and possible workarounds.
> 
> While the issue is known for a long time it appears to have never been
> properly documented is has started to bite software antiques including
> the AX.25 userland badly since the introduction of Predictable Network
> Interface Names.  So let's document it.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Patch applied!

Thanks,

Alex

> ---
>   man7/packet.7 | 39 ++++++++++++++++++++++++++++++++++++---
>   1 file changed, 36 insertions(+), 3 deletions(-)
> 
> Changes in v2: Correct issues raised by Alejandro Colomar in review of v1.
> 
> diff --git a/man7/packet.7 b/man7/packet.7
> index 706efbb54..fa022bee8 100644
> --- a/man7/packet.7
> +++ b/man7/packet.7
> @@ -616,10 +616,10 @@ is the device name as a null-terminated string, for example, eth0.
>   .PP
>   This structure is obsolete and should not be used in new code.
>   .SH BUGS
> +.SS LLC header handling
>   The IEEE 802.2/803.3 LLC handling could be considered as a bug.
>   .PP
> -Socket filters are not documented.
> -.PP
> +.SS MSG_TRUNC issues
>   The
>   .B MSG_TRUNC
>   .BR recvmsg (2)
> @@ -627,6 +627,38 @@ extension is an ugly hack and should be replaced by a control message.
>   There is currently no way to get the original destination address of
>   packets via
>   .BR SOCK_DGRAM .
> +.PP
> +.SS spkt_device device name truncation
> +The
> +.I spkt_device
> +field of
> +.I sockaddr_pkt
> +has a size of 14 bytes which is less than the constant
> +.B IFNAMSIZ
> +defined in
> +.I <net/if.h>
> +which is 16 bytes and describes the system limit for a network interface name.
> +This means the names of network devices longer than 14 bytes will be truncated
> +to fit into
> +.IR spkt_device .
> +All these lengths include the terminating null byte (\(aq\e0\(aq)).
> +.PP
> +Issues from this with old code typically show up with very long interface
> +names used by the
> +.B Predictable Network Interface Names
> +feature enabled by default in many modern Linux distributions.
> +.PP
> +The preferred solution is to rewrite code to avoid
> +.BR SOCK_PACKET .
> +Possible user solutions are to disable
> +.B Predictable Network Interface Names
> +or to rename the interface to a name of at most 13 bytes, for example using
> +the
> +.BR ip (8)
> +tool.
> +.PP
> +.SS Documentation issues
> +Socket filters are not documented.
>   .\" .SH CREDITS
>   .\" This man page was written by Andi Kleen with help from Matthew Wilcox.
>   .\" AF_PACKET in Linux 2.2 was implemented
> @@ -637,7 +669,8 @@ packets via
>   .BR capabilities (7),
>   .BR ip (7),
>   .BR raw (7),
> -.BR socket (7)
> +.BR socket (7),
> +.BR ip (8),
>   .PP
>   RFC\ 894 for the standard IP Ethernet encapsulation.
>   RFC\ 1700 for the IEEE 802.3 IP encapsulation.
> 


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
