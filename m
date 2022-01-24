Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7A8497799
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 04:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240985AbiAXDLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 22:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbiAXDLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 22:11:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB54C06173B;
        Sun, 23 Jan 2022 19:11:34 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso19464540pjh.0;
        Sun, 23 Jan 2022 19:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ngdcx5M1+3hpr61oSCKB6Asopn1L3OGrgWMCvfbgA58=;
        b=phsGvUiGdErZNfIQ7O94rTBjcrw/qCtZzEu8oxQG/T71ap9PrhTtqd+jAGb8VtgsKw
         zk3Cukyr4rLwpqpWQMRyCJaoeRBi+Kb1rH4IOzpSxW2x5R2USOMgckQG5yYCleBUnD6T
         ZKwdqAItudQWnQ3Ks0phtGTIuskcoj9ypM/WlXodeIotZExbuEWGbeT4tQGgNc1z9VZb
         KODNGngXJ/k+nzO2RrBEMre6OSMcDdaZzUQtcKFaTgG/OU7Bnpadk/5JgMn97+vovIc6
         S7I1Yc1qayhXeCpXgTCkjYiOcNn1Ew8xqBD2ZtOFS8gI+KsVdNWHYhwgB0DUJ7ANzDTv
         hunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ngdcx5M1+3hpr61oSCKB6Asopn1L3OGrgWMCvfbgA58=;
        b=GRHEOz6uq9M4e5IO6AsQkxtDxihN5yvoq9m8OLQ7uFvG1lO5EG0zlQADkuUY4jgLbN
         t/E58CazjgxRyQt/3C+cdclZoO60rAo96uG+LLj1KdaxtwclpwMQIydhttsErRKc47yK
         ufCTUzDVvcRTAu5kPjWmSAKfSi+ZtgOgKret4o53IGT9DefDYYPJRaIiJNazwrXmwCba
         LRCLqTJCSHS09YjPRfJjiYzvB1T+NgyfCIawUX46Vtc7Otg7xHa8Jbwa9rnUR8vY8cuT
         58Q99QQAzX4FMDg/HZVyFwDbXYxYO+lsmSoxdIaA8bqcWKgZcVui9DRKgR+RYnHnEGLn
         sH/A==
X-Gm-Message-State: AOAM533xf5SceE2VCl4662AClVkUrFKrzKm68d6SE8IWPuS0PhHDgm5x
        yTu+DwP4UzkAcQWE315XuzM=
X-Google-Smtp-Source: ABdhPJwrtLcF/btxfxb4QnWFj6jb6J38TexNp2eUnjzz/DGNPKQMH1qowkpMkSX0SSRmeSRpBnggbQ==
X-Received: by 2002:a17:902:a70b:b0:149:75ae:4d63 with SMTP id w11-20020a170902a70b00b0014975ae4d63mr13208287plq.50.1642993893555;
        Sun, 23 Jan 2022 19:11:33 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:5d89:db9e:1ac7:6fdc? ([2600:8802:b00:4a48:5d89:db9e:1ac7:6fdc])
        by smtp.gmail.com with ESMTPSA id ms14sm11715278pjb.15.2022.01.23.19.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jan 2022 19:11:32 -0800 (PST)
Message-ID: <b9b73ab6-662c-5343-da75-29ed25fd1b35@gmail.com>
Date:   Sun, 23 Jan 2022 19:11:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 02/54] net/ethernet: don't use bitmap_weight() in
 bcm_sysport_rule_set()
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-3-yury.norov@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123183925.1052919-3-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2022 10:38 AM, Yury Norov wrote:
> Don't call bitmap_weight() if the following code can get by
> without it.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
