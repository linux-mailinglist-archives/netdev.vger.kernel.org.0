Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E144A46B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfFROtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:49:25 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36429 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbfFROtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:49:24 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so30507481ioh.3
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ap07iMMDwvqvf6wJY7huIyyJ+pDvEBU+WHYN6Gn6nFI=;
        b=RzR5Cmr4AAgMmYc/hTcgCFrZEnKoq3zR8LPn+MGa5AlaiMEtOEL+fnckNGkf82JKty
         5jSMzzweUB/IVGeAmNkPbq2qcFWQn8jqOw2fhu+9fIPOQmiTFn+XG/+q8kXM0d6a/wKm
         C2Iog2EZQLfqE1g62dDaDqvWHTj604UF4c8aaOVpXHQsGwCbr3XkeSsaAGvX2ByVACQl
         7RX8PfBc7mVBpDI4MUrd8U9YgYLSx8zIXXTYL1Pmc9dD+SWkUIChSDmW11t2e6pVP5A/
         o9WXhKJVT9/GgJMqk3KzCSM8Sjti9u4knZVsVDWnAspJSHxTpOlJQahyPfqzZocZ9bMd
         IhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ap07iMMDwvqvf6wJY7huIyyJ+pDvEBU+WHYN6Gn6nFI=;
        b=lP4/vRduLSAWi3poJjnH98Ol8pPvV6kApnrYXLaB9mMrrOtYZaYuTs+/vFFjQJgVTN
         1unZj2NeZ/d6zaKU1Ibh+WPJlwy1AEpT/3llPJMLP4rYzBfcmQbIpdjVZur9gUShtRcC
         eZ6tsZSmhoURFkJ8ftVOYkMk7fIOR+aYcvsLCef0v/LF2vviyhRXHPydR/tdX933jprW
         f5aA8peRuPfanUQhbi5cyoJW/8KZ0nX/JCEQyRQKbIUVo3fIil1HmWBFQX5kLjSupbO0
         gFS2wmnOdaeH5z7nMZB8b8Q8R+X10Ueu80tkayWh+kNhyzxJ7cBQzSUpqGcw2isAm+hO
         JYOw==
X-Gm-Message-State: APjAAAWQXNIwYI0frrI8GgDZdXx4JlKw/jaHphuZ2YoAqPCNhoH7Xp7U
        +mb3ZQu5Vxkc/brZmVDuM/NsAlem
X-Google-Smtp-Source: APXvYqxrB3tYJg46N4eUdAXPrs5GNQmVtP+wOQfLI2MhU4JDtN3pvy0xtZEG480ashuSFyo1QXKshA==
X-Received: by 2002:a5d:964d:: with SMTP id d13mr32048162ios.224.1560869363309;
        Tue, 18 Jun 2019 07:49:23 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fd97:2a7b:2975:7041? ([2601:282:800:fd80:fd97:2a7b:2975:7041])
        by smtp.googlemail.com with ESMTPSA id f4sm13103125iok.56.2019.06.18.07.49.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:49:22 -0700 (PDT)
Subject: Re: [PATCH net v5 2/6] ipv4/fib_frontend: Allow RTM_F_CLONED flag to
 be used for filtering
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560827176.git.sbrivio@redhat.com>
 <4c351295757f82ddc83f6e433150fedda5517fe1.1560827176.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <96c48380-f26c-cf99-f3c3-223ed351a697@gmail.com>
Date:   Tue, 18 Jun 2019 08:49:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <4c351295757f82ddc83f6e433150fedda5517fe1.1560827176.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 7:20 AM, Stefano Brivio wrote:
> This functionally reverts the check introduced by commit
> e8ba330ac0c5 ("rtnetlink: Update fib dumps for strict data checking")
> as modified by commit e4e92fb160d7 ("net/ipv4: Bail early if user only
> wants prefix entries").
> 
> As we are preparing to fix listing of IPv4 cached routes, we need to
> give userspace a way to request them.
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---

Reviewed-by: David Ahern <dsahern@gmail.com>


