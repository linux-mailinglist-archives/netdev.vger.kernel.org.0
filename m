Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F853B9414
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhGAPlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhGAPlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:41:17 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEF6C061762;
        Thu,  1 Jul 2021 08:38:46 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id t24-20020a9d7f980000b029046f4a1a5ec4so6957455otp.1;
        Thu, 01 Jul 2021 08:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zib80wgFzx9ahee3bIKMkwejK/FkG5eEXcgWdlijaqc=;
        b=FZUNFQIdjYzMB2K1IUtk/vVlJFK/nKmRlp/8BQ/nIq0wuCGWlq+so/FNB9i5pxWMd2
         7qP1VRF/PVIwhNVAQKN7Q1Apjp7IHogf0yarIi3zR2cdilvLjNngO0HmP8bFBbhrF+xt
         CgZl6vqmDEsLlQFE0B1HePLfu/4jOnwTow63RUt5BhAFCD18P2tVThJlP/gmfTX+m+5m
         C1aFM3iO1dQWwJLYbXZ6t3oiydfWvGakbUXq4NM8hcrypnFoPG44eSwWVKC/izmUtnsh
         8/3N39OFY+XAFmi9vTQA8Ri+Jv4SXVq75jn/KxlR185JvbBXHLMfHOWfr14b0UhMKzrJ
         KokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zib80wgFzx9ahee3bIKMkwejK/FkG5eEXcgWdlijaqc=;
        b=raPDnMA1mj7oYZ5/BuiEhheuPqz+Xv/a1lejzixkjV//SxYly/Trp09f6dzgvsROY2
         lgXeFFvayRKB1h5hDAdZRQPTRXUxhbh5/FS4lFZJyL8rz8PxYwOKUT2hwhXxDbZMWziu
         L9ctdk57OUvKS/S/tcqHyBXaBYuI3xmAfG171JW1qABHNSLm24alHZ0SUbmRKRxsTFYB
         1qHIfaFnI+IYAIfNeP79ktQ2p0Ak8EMT6drEsDAiu+lFgGv4QhlBbmFpHB97tkiRXzck
         Sx9deYlkm5wqwBLPn2hmCJEKWr0C8jEw54siRm8GhocYkc0qL8yEJ2qQX0VpkrQS7/ty
         sMFA==
X-Gm-Message-State: AOAM533+2MZat1e3ib//Cd8rHBn1eGsT2b/hqNkoNItMZW12VLxe8O+2
        lUmtc2jb5kz9aOpKkvRvSEjVQcpMdo2DxA==
X-Google-Smtp-Source: ABdhPJx9JvtCD1nl5lnZ6b2+DFCK/CH63l1KRTe+QRhJ/7Z+RK4AOySz3ONC/ELKNTsAQiv4QjMT/Q==
X-Received: by 2002:a9d:2f25:: with SMTP id h34mr520534otb.228.1625153926246;
        Thu, 01 Jul 2021 08:38:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id f12sm22418ooh.38.2021.07.01.08.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 08:38:45 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
To:     Guillaume Nault <gnault@redhat.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
 <YN1Wxm0mOFFhbuTl@shredder> <20210701145943.GA3933@pc-32.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
Date:   Thu, 1 Jul 2021 09:38:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701145943.GA3933@pc-32.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/21 8:59 AM, Guillaume Nault wrote:
> I first tried to write this selftest using VRFs, but there were some
> problems that made me switch to namespaces (I don't remember precisely
> which ones, probably virtual tunnel devices in collect_md mode).

if you hit a problem with the test not working, send me the test script
and I will take a look.
