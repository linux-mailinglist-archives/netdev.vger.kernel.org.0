Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF942310A1
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEaOyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:54:08 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38394 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfEaOyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:54:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id f97so4124615plb.5
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 07:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m4w3wlofPv1DkAeo6/a4Oh9xr/Sai15/CF/l9vqo6KI=;
        b=I2rQtkiy9wdme+tn/gvjnLpwVk0ZRorIkvjnCh7IbvFcKjyYSqVupuHxveVnQp2fd6
         Z0+4I0ujG0pD+Ycm5Q1npVlHy/TBF0MHwM95/id0ZJkqog5rhHtGFsqDSYR4d6omvhAt
         Icr/utF9kcQn/Oeb+mqq+fQIezA7rwcTxRNfVI5LuE/4uuvyC/Krm0LGI+VBmLVVFTNL
         0u9z28zfHMKPMrN8ZS3m+uuBSUMfSmiAi2Enol9TGdB02YoN8DEE4e8cGkHO92bc9R3f
         EHVqJUJDv602m+FSQR9ddRnmZYBampi/4wKbF4W/1f4dWBtJZrmLsxJ7nUEyS7lCj30H
         qm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m4w3wlofPv1DkAeo6/a4Oh9xr/Sai15/CF/l9vqo6KI=;
        b=ZK5BoeaJcJh9HNKwpF70Ykd7H+R35PoG6nDdugwsUxVNZpRgQOzUwD4E29AgNEMW30
         qnicI4xUVoVa7WHIdhEAzQibliGA37Nvz/4w+P76/VsfEE6r1F3EO1nuAMJ5UYnmjx03
         1L6LR7uVetzfFsoq+3ALnm0S4VmKzdwk6PG9NHCSkU5eL21wxY4/cJZIMUE3qpks1CZu
         laU9ORmUYmL+yfPS/23FEPHIIY0XWY9KxGF1Jd7nCNTRUj2PVF2llxKqJGwSR+UVe+jY
         BuP3jW47ACsLlX/KmOx5yhT8w90Uk5oLf011HIl8hygjDTvNXiPxHL50isVMD2gRYiw+
         vvnQ==
X-Gm-Message-State: APjAAAXd4QM2N9QbS10EnJg+6K+OIZR/PWoULIqHKTc/JRET18rawg84
        4rZ0n5XVT1pS5HYsCri4u6mQppNH14w=
X-Google-Smtp-Source: APXvYqxABGaBfLuM6y8x2ErAU++O53X86u08hk2z2G1aFXIdY4s+/OPvoFg5tgJPkhb3tlravTNITg==
X-Received: by 2002:a17:902:24b:: with SMTP id 69mr10003339plc.255.1559314447658;
        Fri, 31 May 2019 07:54:07 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id y13sm11508592pfb.143.2019.05.31.07.54.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 07:54:06 -0700 (PDT)
Subject: Re: [PATCH net-next] vrf: local route leaking
To:     George Wilkie <gwilkie@vyatta.att-mail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
 <20190525070924.GA1184@debian10.local>
 <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
 <20190527083402.GA7269@gwilkie-Precision-7520>
 <1f761acd-80eb-0e80-1cf4-181f8b327bd5@gmail.com>
 <20190530205250.GA7379@gwilkie-Precision-7520>
 <f0f4b5c8-0beb-6c97-34c8-f5b73ea426b8@gmail.com>
 <20190531103832.GA17076@gwilkie-Precision-7520>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8012f642-4118-7386-a60a-a4e4a4f18f87@gmail.com>
Date:   Fri, 31 May 2019 08:54:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190531103832.GA17076@gwilkie-Precision-7520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 4:38 AM, George Wilkie wrote:
> What are your thoughts on creating a "vrfdefault" for "local" table?
>    ip link add vrfdefault type vrf table local
>    ip link set dev vrfdefault up
>    ip ro add vrf vrfA 10.10.3.0/24 dev vrfdefault
>    ip ro add 10.10.2.0/24 dev vrfA
>    ip -6 ro add vrf vrfA 10:10:3::/64 dev vrfdefault
>    ip -6 ro add 10:10:2::/64 dev vrfA
> 
> I'm able to reach local and peer addresses for both v4 and v6 with this
> approach.

Robert looked into that some time back. I was not aware it is working,
but if it does, great.
