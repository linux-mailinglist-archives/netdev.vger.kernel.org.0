Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4338648201B
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbhL3T6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:58:48 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33734
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242041AbhL3T6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:58:47 -0500
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 354E83F1AB
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640894326;
        bh=GNWzUrlrK9iApcC0QIt7hy4CWeyRUiCxofVD3uisya4=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=IQ0XcJkyjY35RH82W+KcSDToOvW8gpc1+D8s2XE8QiRxzgBMArbosRdYWRJRr1hUM
         EjC13HVx4kkYU3P2gyH4FsFPUx7X8mwhrXXyg2I94H27jRDbTX2tIObJISFcWEeips
         tFjt+WW1y00eslzFdEZKLNsgiKXIvQFtwtcqV9esj7NwiU/T+qQWo0TMwJvK8f/10i
         7JwiitkuMLMLR1wgUfNbTaC3xu8zRLGZ20jSsmRgwp8IsLc2goaF8xNUPY2ejzsfZ9
         dQaFZoaKat4LeXcYj243dA3R087vNje3ItgKKzqwwQ23an2lIjE2TRCVqyfFfTgvT9
         bc6JhD1WxNlJg==
Received: by mail-lj1-f199.google.com with SMTP id v19-20020a2e87d3000000b0022dbe4687f1so5758421ljj.7
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 11:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GNWzUrlrK9iApcC0QIt7hy4CWeyRUiCxofVD3uisya4=;
        b=0tzyjVr/9mK9KhUCme+KBWwkLn3joBTevGXnjMKsC5LmQ1o3ohLlku2KuZKr9tGCQR
         YEHUZSDoVAxHpOPflHuJgLelZWguJ+3jT6h8J31MGsBUJyTeYlzpxNYhnFLG4F9NzqJ+
         Gbs7NjZPh50uxUnJ1o0ZZSv7+rpL4n9Xy/mgePtGpq4aJa4FzQHSeXRgz9rBNpi0vlZB
         4IwXOg5iach48z6WIVAN9g9AmaWTRb28R/+b6ViossNdyX7xYcuSyCzwuMcyg6KEh49b
         rhFYkUUMxjH/mvGdE0aW21LqgSnE/Zr7yuoIaTL1ZmhinhENUXDsY+UGbUfFgjSPMHdA
         8U8g==
X-Gm-Message-State: AOAM532Lo2wVQUMlxHCYbYVEBDxL+pByEoCthdwH0ZVDBGfouk9VZSS7
        ZMG3fIoMYx+eD1Fqb+IJnGlNK5f6kQkfAj1ioMQ0J+6CdYVSJ+1/zo6aPhtKln1gWODQ0/M0jSm
        C5LcWZM6UjuPqpbIwadcFD66UOSW8dJa91g==
X-Received: by 2002:a05:6512:2311:: with SMTP id o17mr25992429lfu.256.1640894325566;
        Thu, 30 Dec 2021 11:58:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSa/wf1cnt5j7jqACUSdQ38QoQdVyafz5ZdxBfdxwsi0qKJ3PwI4Qbtw2FxwfqCGrdy+92UA==
X-Received: by 2002:a05:6512:2311:: with SMTP id o17mr25992421lfu.256.1640894325422;
        Thu, 30 Dec 2021 11:58:45 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id z36sm2571458lfu.182.2021.12.30.11.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Dec 2021 11:58:44 -0800 (PST)
Message-ID: <eb2f0bb7-46ee-2290-6b60-90f555e4811c@canonical.com>
Date:   Thu, 30 Dec 2021 20:58:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] nfc: st21nfca: remove redundant assignment to variable i
Content-Language: en-US
To:     Colin Ian King <colin.i.king@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20211230161230.428457-1-colin.i.king@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211230161230.428457-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/12/2021 17:12, Colin Ian King wrote:
> Variable i is being assigned a value that is never read, the
> assignment is redundant and can be removed. Cleans up clang-scan
> build warning:
> 
> drivers/nfc/st21nfca/i2c.c:319:4: warning: Value stored to 'i'
> is never read [deadcode.DeadStores]
>                         i = 0;
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
