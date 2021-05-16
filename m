Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4C5381BC8
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 02:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhEPAGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 20:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhEPAGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 20:06:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EE4C061573;
        Sat, 15 May 2021 17:04:59 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id h127so2495856pfe.9;
        Sat, 15 May 2021 17:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yuIe23T1ZzwA/hvnEoZmSVtQo6uyXi3XeYJGd2J9de4=;
        b=Qk5cxF8sN2LyF0dF/TPowq3xn1EdWyF7BvnltDTCCMtwORUtnmEkde/CMz0kMckg+5
         Y1FKVmc6eTFQDgmhMvReKCFcSn2kksfk7cDnnaLoF/r5pj3Jw9zS+vssfWfoQGqGrJOi
         aMQlwCu5f9YvUEfigERZulZCm0eBBE9C3YM0rZMmzHxap39Kni4DyNQc8zOTa4uxxCoK
         h4VIJTxvtcwvLRuxz9dcYnMgZSYajkeHpQgi/Yu9sVnhiE3PzvE5MGj6pivboDdEq4Oe
         zO++W41Xk1QiqT0lGf3nSUZfw9tK46Dw/KRjC1MVQlozXYSOdAAFTazw8IwBd2RHuYXn
         DwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yuIe23T1ZzwA/hvnEoZmSVtQo6uyXi3XeYJGd2J9de4=;
        b=iy3j8zn3ePZnAyjBQPGrNLKhlosJAQQjB68m5erH/Atj09QG5G57op8xel4SoFIMEi
         0A1vn6lKMDHI2izXk2N5WeLf2cY2LhPAD7yTEI0tsA3u/rMhB5Te/WIXxToi/CtuBo4z
         I8cCC1ALCNuO1HQ9xapfZ3CYRd6rKJXQOQcQxcB1Bm3TQ3Nxr4GW0Jza2JDx29KZULiQ
         xvOMeuD3SHyNfepFYq20/JfUyzKPjRiHsW/K5BrqoWK2ZUtNbRtyO339Aib/bWXcYl0V
         Of/DQqMx0NacnhwOKhCGEdxL2L20tTAEYjiBO67i2wNkbVNeow5R6tfnTBiFMAxN8eqe
         /QOg==
X-Gm-Message-State: AOAM533NEohZN0XQF6NJF8j7C1z2AQlJPSL7Fz78pnpmA5Gm7WAHWKmX
        Gz4tUmA+TFw4Dl+2GFTU8o4=
X-Google-Smtp-Source: ABdhPJyKXGE763dXQtkEMj6clFouoy6q3jHPfFagv9TuboK8gOc+kBFPumS+05mU0mg/4SgJBI4ydQ==
X-Received: by 2002:a63:5b5b:: with SMTP id l27mr7064469pgm.55.1621123499223;
        Sat, 15 May 2021 17:04:59 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y14sm4639500pjn.48.2021.05.15.17.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 17:04:58 -0700 (PDT)
Subject: Re: [RFC 01/13] [net-next] bcmgenet: remove call to
 netdev_boot_setup_check
To:     Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
References: <20210515221320.1255291-1-arnd@kernel.org>
 <20210515221320.1255291-2-arnd@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <48c1bfa7-901d-bed7-7ab4-1ebd0ca7c63e@gmail.com>
Date:   Sat, 15 May 2021 17:04:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210515221320.1255291-2-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2021 3:13 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver has never used the netdev->{irq,base_addr,mem_start}
> members, so this call is completely unnecessary.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
