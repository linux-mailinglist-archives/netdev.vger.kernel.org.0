Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2612B1C4CA8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgEEDZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:25:10 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C15C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:25:10 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t40so399195pjb.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TuANwFRMv1KyeY6w0vkJab3h3bdWVySehLTRW1qEW90=;
        b=BD2pMbrfOgbroEGshNIoSrXBntV6xE5fJfDUYWfz55LJH1/30pJ2TXG84RN5HX+n/s
         meRR9vxLkin8N9Dc+H2+8+U6XtkBe32zpXwF22JuvXGMDYIEEjMYj98OX2Rke1+NoJDC
         l3oRRzf47ai1OfmD40jwCHfsNvwYtdfln2fT1lB7banGorom1MPiRzeu46bT5vrbUYqg
         nYwSvAGF53x0g4iJCEIRnht6+LqzkVdk1eXQyarnm1fgQK9j/jw1oEc7unH3KrFSRUup
         fzKhr3lNB1z0uvBch4gnIA+8ifSc0C+MhvtMgbPyNWEid3RmvpojMU64qJSWncl4FJrU
         Sswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TuANwFRMv1KyeY6w0vkJab3h3bdWVySehLTRW1qEW90=;
        b=BeVf++Afaf8mbarL6TKDjYULx+sZw7rPNFsNhSIYLdaINIdFZGFk+T6VMkOSETVsdo
         WmaJMsIH4XkgCl0AXs2hTlUoKnkBcsPnw+7IYQI86cNkLzxYNrAkRZUYyCwDbA9vuDP4
         qG6ydcYEBoZ3Ry7yVB3shJ50r7mlOmbLiCm5gFqDRs+rwUKGju+RV70fP4ybNdi1/vZ7
         3TCheQzGpwxSdr29nHDKP6l7Mif6nJzEFFkBAg0SKufwH6MUcMVJ9gJB5uct7rcQk6bh
         4LsPvkw67dNdKABHhGuU8pvlKCabSJduZXOo30IeEq1jIxbjOczhQkGnhQe/mLUj6rRM
         I4/w==
X-Gm-Message-State: AGi0PuaQxL19H072n3lJVGk+V5BOzlHnRN/o6ePKddhfVmwwRe3s5VUu
        46bBErS1gHUBBcD+rwqpBSI=
X-Google-Smtp-Source: APiQypIkj7a+fO44HtQu8wAvGWzMSyM8xQDMp7431AZk0AVPB31O70nyfUsih+3hYrCh3pk/Lfzf8w==
X-Received: by 2002:a17:902:d883:: with SMTP id b3mr866484plz.133.1588649109916;
        Mon, 04 May 2020 20:25:09 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l64sm378958pjb.44.2020.05.04.20.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:25:08 -0700 (PDT)
Subject: Re: [PATCH net-next v2 10/10] net: phy: Send notifier when starting
 the cable test
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-11-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9b5c8a6d-93f0-0200-7185-e27e70968199@gmail.com>
Date:   Mon, 4 May 2020 20:25:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-11-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> Given that it takes time to run a cable test, send a notify message at
> the start, as well as when it is completed.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
