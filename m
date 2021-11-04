Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF664456AD
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhKDQCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbhKDQCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:02:01 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA11AC061714;
        Thu,  4 Nov 2021 08:59:23 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id r10-20020a056830448a00b0055ac7767f5eso8893927otv.3;
        Thu, 04 Nov 2021 08:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+DWga+L4ukHUCEsqSLIkNP4gRULHLBKXgraKCXcH83k=;
        b=IyRG8ML45zPkZrb9Ey4t+9jJPcza2/TWEHCg+nrHeGAI7KDAUjIk2L06MTntVeODJb
         YqsXJZ95FkU+U++mo87rxsam8aByv0w/rbL7iqux1amjU9NHdGSI/JJWwblsGPZC9K1a
         2s6IqGipEFy35oVS6CkiQR9aAZ9201VfG+V93DWKSUS3pQvc5cO2J8k/P+KOfKc8C3/2
         VGhl/x4owQwIzUZYD8Mms0M/FR8mwGgbUbUEPhFt5S8rGDKlr6Ic7mbS8I5L/DH8wVsu
         c+wd8hqEWHbLd1r5PI29LNirjRzYoKQbPDOWw0kMakXt+fEgN9wVDqHuBbIAedKUXO8d
         8/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+DWga+L4ukHUCEsqSLIkNP4gRULHLBKXgraKCXcH83k=;
        b=5+z9Bgit9Xs1/vSy5Muwad7zss6xDtlfBc6IVCPm+ZEcyHIaQ6D1eulqM0ku/NyQms
         3tjWWhhtH1idCzNNZmw5TAtsv8NlAomjsSM60vGczZwnuj79WDTSqj2hNdfH2WfUI2T+
         2tUdmAuJyEEsdz7fD8SMZhbyxlTjrN/X2edsDInzRRLeO/YOWcKWY3/9Ny1zgE/Dt+CC
         hnnvipbiv6e7BFfpt9oItHnm6vbg+9rvrILF+f1Zj45F/gdsbF5wwEl91vrt8hU1quGn
         mN5PzBzQ+DnAWI1pAtcZtN/ffWxBE+B9mX44aSV6kydVP3772sr6ACBNTryaznXfjAJq
         9M3Q==
X-Gm-Message-State: AOAM531ObNydYPJBIp6EJ1vYYclmtesHMHEQ90ynzR8ckfQjYXsEYEFu
        IPoSr+GTmm2FCL7UVy31tEMmgkt1rd4=
X-Google-Smtp-Source: ABdhPJwvan2UYqGozZ4ixz4iSDrhnJrkcHeLP7/F7Pn69DbBlbf933yALBOlRknquOcOd4gLzQ+Ltg==
X-Received: by 2002:a9d:3a4:: with SMTP id f33mr13068470otf.131.1636041562964;
        Thu, 04 Nov 2021 08:59:22 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 3sm1564261oif.12.2021.11.04.08.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 08:59:22 -0700 (PDT)
Message-ID: <f0a0155c-6f4c-231f-dfbf-3239214f52ff@gmail.com>
Date:   Thu, 4 Nov 2021 09:59:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2] ipv4/raw: support binding to nonlocal addresses
Content-Language: en-US
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20210321002045.23700-1-pbl@bestov.io>
 <20211102141921.197561-1-pbl@bestov.io>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211102141921.197561-1-pbl@bestov.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/21 8:19 AM, Riccardo Paolo Bestetti wrote:
> Add support to inet v4 raw sockets for binding to nonlocal addresses
> through the IP_FREEBIND and IP_TRANSPARENT socket options, as well as
> the ipv4.ip_nonlocal_bind kernel parameter.
> 
> Add helper function to inet_sock.h to check for bind address validity on
> the base of the address type and whether nonlocal address are enabled
> for the socket via any of the sockopts/sysctl, deduplicating checks in
> ipv4/ping.c, ipv4/af_inet.c, ipv6/af_inet6.c (for mapped v4->v6
> addresses), and ipv4/raw.c.
> 
> Add test cases with IP[V6]_FREEBIND verifying that both v4 and v6 raw
> sockets support binding to nonlocal addresses after the change. Add
> necessary support for the test cases to nettest.
> 
> Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
> ---

Reviewed-by: David Ahern <dsahern@kernel.org>


