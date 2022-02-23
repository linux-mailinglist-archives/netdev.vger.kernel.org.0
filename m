Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12ACA4C1508
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241346AbiBWOEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241339AbiBWOET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:04:19 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA3EB12F7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:03:51 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m13-20020a7bca4d000000b00380e379bae2so1616023wml.3
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=zLtVcmFkmmZWPSUUMbouV4mZ1BR3JBvi21d4wzaaWeg=;
        b=HclJnQtK5E5D2I6vLgnXxiz+Ky4uRj2vYnur1VJ3DmfeaaBjG9QRK2GsypH909VCJa
         LZb1Qg0Ptx48QqBsvikZ5nPrz++I7pCzeIf2HefIF13Xvbe/SmZ2mDHSjASQBvy/f43+
         peJsW0BVuODWZkLjmh5eLdHdeq1reObZg9u6DIWaT2Xfts/9ZAx/KkJ/2Yo/nFVeJEXg
         SgX7BLkNTcsSLFwXMhjTpl7gZU6gAX2e7Zob/OReE2dT4c/bYQi+25ZXVbKqOhch4ZGq
         ZTBQ8OFD52s+jXL0peo5OZ1RESVeVQtN8sr62VfQ9tG5eeKRKDXHTUGmRWDqM5lU05xG
         kFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=zLtVcmFkmmZWPSUUMbouV4mZ1BR3JBvi21d4wzaaWeg=;
        b=wnr3kfKhHXLLauazYYwB25XKX3uXiTFIigx0dKfAi1lWeXnLFCjX7X94+TuL1FILTu
         7+fiOPaV1bt79Jhg6DZql2Qfh/uxEhCV7OUJmusFskLuz58Bgq57qc3xDvwJQaqDLLnx
         4s5FTxOFrBe1fXupZ6txpm39ZSgG2LHhshCApgUAR9E3Je6s9B9dls1Wn/KlaA5z3+dk
         5NzPcf7tsvwfSiAY9U7OLVPy5/MG2aXD9rsMOgjqXKBaAVohmGXsD29ZYTn5dlpiO7G/
         hYpGiBi90WH2ysfvA9EbwzR+7xdmUOCZnfX851rGd6mAnfHHOk+EwZHBZKmOnARA0qPV
         1CUg==
X-Gm-Message-State: AOAM533GyQdcsU+pBJ0mgECGFDCJE/FCVNjsoEp8GDDa4CrGCjJRFd4O
        a0wSQswF0KLJLAGppTD00OJ5xg==
X-Google-Smtp-Source: ABdhPJxsEW8QxKj8w9zTWFiMZ4n7p0rpBVsN7QNQmftHr3Uw6P6iTZfKtlFbRpz/Xprx8r2v4KGILg==
X-Received: by 2002:a1c:a942:0:b0:380:ead5:c4e2 with SMTP id s63-20020a1ca942000000b00380ead5c4e2mr3365248wme.100.1645625030068;
        Wed, 23 Feb 2022 06:03:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:b41:c160:5d35:a5e8:9cb4:e326? ([2a01:e0a:b41:c160:5d35:a5e8:9cb4:e326])
        by smtp.gmail.com with ESMTPSA id e9sm2853530wrx.3.2022.02.23.06.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 06:03:49 -0800 (PST)
Message-ID: <5ec208c6-fd92-afcf-1ff3-5c973025d385@6wind.com>
Date:   Wed, 23 Feb 2022 15:03:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH libnetfilter_queue] libnetfilter_queue: add support of
 skb->priority
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <Yfy2YxiwvDLtLvTo@salvia>
 <20220204102637.4272-1-nicolas.dichtel@6wind.com>
 <8c08a4e0-83a0-9fc1-798b-dbd6a53f7231@6wind.com>
 <20220204120126.GB15954@breakpoint.cc> <Yf02PG/793enEF4r@salvia>
 <e926bd60-7653-f528-ec15-2758a4ffc89a@6wind.com> <YhYLRLl9pJrdgsq1@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <YhYLRLl9pJrdgsq1@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 23/02/2022 à 11:24, Pablo Neira Ayuso a écrit :
[snip]
>> If I understand well, libnetfilter_queue is deprecated?
> 
> This library is not deprecated.
Oh ok, sorry for my misunderstanding.
So my patch is relevant?
