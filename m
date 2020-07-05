Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C194B214F68
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgGEUi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgGEUi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:38:57 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DE7C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:38:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k27so1351767pgm.2
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JHUPmUVcDC2iq5tqpau6kLCNNTkKxIxtYWDK9nkiGtc=;
        b=aCR8qaOXDKxLeKhBTcAaFiAZy3q3XcOO/mn/UyVx9xI/8CroJFyfY0+Nu2WjBU3g8A
         fe0XmzqVkBLWwm+XpHgKpSW5WmSF8I+cpMt1Z8F9NzQFJTJcIcAHMJS+vz2CRgWQn8JQ
         yX+jivbD8cNvfkv5o17rBxlX9g90UgKIyUqSUQGXqNP50IncG05KpdS+EBfAgd87HEKx
         FLNlKhU+pXKQ3tGI8JHQq+Rk5lEhwFI1S9pGGv1qfqD+rAESuKHum0WZkJNeLnCN8CC0
         PRhKcsVSqTmtDufZV037GMffupOpaLero2AE8HO52kvKMQeJCmGJ1vT9jTaPFm/rkEsy
         VYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JHUPmUVcDC2iq5tqpau6kLCNNTkKxIxtYWDK9nkiGtc=;
        b=CPcJFu8OGLu8EJYh8M/noGzZoSHkk1zfXy9XygTpbEdgMT5HBKKXAEtBBGCmkVN6Pc
         XGcZwOWMhBlEugGRYkIH5rtHQcpOrUpXW43dNSQi5xSRB3Mm9MAdcAdjZyfWxE+mYTMG
         w2jFYs6IX9q5oQj5tLb9LHEHgcUcDXo8BC/W1B9QcloQkdvLB6Qt0X4PHH8c4/btg/8C
         YHLDbnvSTq5eF6A2RwXJYW9HC9lHeBUk09JQ0GCxyELe1wQNhgf6ZKePDXNvQy30Mnkc
         oApCXovJI+4Hx93fCw44p3PV6/5jPuFrvmX33OzNzCRV35vNSHK1BrGZmFqeY7c+Zrci
         o9eg==
X-Gm-Message-State: AOAM531RAYtlW6h/bT9DA/x3X8/ZCbrHnWHrXmCwrnB/CsCmJIrMArZo
        biT50MpfB86LWvhn/JU7edtSiPF2
X-Google-Smtp-Source: ABdhPJxgjbBzdmnWp9I5VytxBzIxxXMXFFKrfs8eQX278HM9qvibiT3MJClzlGukquK7qTL6mIW5LQ==
X-Received: by 2002:a62:75c8:: with SMTP id q191mr32134580pfc.321.1593981536234;
        Sun, 05 Jul 2020 13:38:56 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id q1sm18107230pfk.132.2020.07.05.13.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:38:55 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: dsa: b53: Fixup endianness warnings
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200705203625.891900-1-andrew@lunn.ch>
 <20200705203625.891900-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e7a702b9-b3a9-599d-5e1b-cd2dd0c2e319@gmail.com>
Date:   Sun, 5 Jul 2020 13:38:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705203625.891900-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 1:36 PM, Andrew Lunn wrote:
> leX_to_cpu() expects to be passed an __leX type.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
