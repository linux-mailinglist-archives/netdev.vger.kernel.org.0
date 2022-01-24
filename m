Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC0A497797
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 04:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbiAXDLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 22:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiAXDLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 22:11:14 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F734C06173B;
        Sun, 23 Jan 2022 19:11:14 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so10742377pjt.5;
        Sun, 23 Jan 2022 19:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ngdcx5M1+3hpr61oSCKB6Asopn1L3OGrgWMCvfbgA58=;
        b=cxFZvegw+jK0d8rLytqB5GjFNn1yJivtYwl5vmkTY+hWSpMYJOshCRuxy381njLRQg
         zvGdck9Fk8d14wf+wBxlH/umc8ZMT4hABzfGs758LEKuXU9frbJMRBX49Lr82IrL6VUp
         Onbr5JQdq3DSfEju9opgr9o14Q5QV790qL+AarB3jl0yLJxDXwOOpn1T9mwFh0xeuy2K
         E4dqZ5/8IjhBonFjZhcvgrqJiJQjKqy5aABX2Ob4xsuIZGbrm+YGJSjApF8XLkDCmRwt
         bzO76FJFb2sEoILiqM0IiPlOama+T/fug3abRSs/0rvB0MH+MFeGbl7MK6Cq0NoRdmVv
         qL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ngdcx5M1+3hpr61oSCKB6Asopn1L3OGrgWMCvfbgA58=;
        b=j0hY4XqHWE/KuFo0zzh39vZL7OSXofGN0EKxnBftxFpqu1ow9KflimlrYDXsgj8cq7
         SrDPIC5XuFysP0dPX6VrRa67HUaVOAux9YqlY6nmrc7u+MpDAtPL8crxW0sTEwGpPhqn
         rqzK37nEcS5ZadEIJM4G002cGOvGUTN6owRxA4UER1ladsZ+AnNd4N9u2FhXt5E4FAKH
         5s7+5y2PYM2PqCgtoKRBUSiCSQtFuFgxTW60hz+OY29yC/9uDrk1CfOGI4nWOSOTUr6h
         hvxL8EjSsqppW3OtLgWAaDdOQ46zfVJcgGeICbARw6g7eob8W/LgOwKTthE81wI3/Ubi
         bZnA==
X-Gm-Message-State: AOAM531YSxQT2Z/VEsiAY+1EtBq/l7ZhBDdEnv0/XAW1g+iwgDvMUQR1
        2FEV9cZTeKsCMVdU73zTOl8oaFDD7Pg=
X-Google-Smtp-Source: ABdhPJwsITlUtrpFF0W1Pl8rQSWKnemFiprVvSgVMRwXNdibudmm/Vx/mu+nTR5mfkCtyA6A6VY6Aw==
X-Received: by 2002:a17:90a:6287:: with SMTP id d7mr14198pjj.6.1642993873543;
        Sun, 23 Jan 2022 19:11:13 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:5d89:db9e:1ac7:6fdc? ([2600:8802:b00:4a48:5d89:db9e:1ac7:6fdc])
        by smtp.gmail.com with ESMTPSA id s6sm12118945pjg.22.2022.01.23.19.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jan 2022 19:11:12 -0800 (PST)
Message-ID: <33765916-500d-88e2-30ea-8c55b559b7b6@gmail.com>
Date:   Sun, 23 Jan 2022 19:11:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 01/54] net/dsa: don't use bitmap_weight() in
 b53_arl_read()
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
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-2-yury.norov@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123183925.1052919-2-yury.norov@gmail.com>
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
