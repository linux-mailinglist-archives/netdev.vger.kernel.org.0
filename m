Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A437214F7B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgGEUnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgGEUnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:43:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE99EC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:43:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d10so14527385pls.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QSjgN8h8WLR1fpVTaL82i8x8IQLJXzjGmk561g4cRdA=;
        b=n5hR9urC8IIuV0MtokrjcHlXAA8GAicN1Ke309bEAeY45NL9y0hIpv7DJ0FPcnKwcS
         qRPxMhBtvJNzQrhI6tIrZTrrnwmThuDMzyyX0XJ+4U3ZBcnAiUb2CU5U8t8LqZsmjiLc
         VZpOxz0eAiCztTwK3z4Ps/XNn0S+VOMWQEK7dBxZjb//bKAKXwxUI2Gl7VDJLA2fPkwK
         iUx+3UFvLNluokW2A/IJanEWn829PaIFQ+dzNEEy6/jmVcuLg4dFrvQ4ep86zIJsBojt
         oVIYlJb2Toooi1AufukHEhFtyoGuOTLtKFzsnD/80DApMmaHOo1ahVXrrZoQsJYwWtwN
         l++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QSjgN8h8WLR1fpVTaL82i8x8IQLJXzjGmk561g4cRdA=;
        b=k1RvwL0w3a8/BU1aqARCrLdbSBj1HOvdrcrqhqEGWRqWFiUl9YJ/abHRHTqxiA8Jbw
         2XbCSIYOormcAks8BZ5W9YzreRtPyZUXHH0+ytomX1PUdfXOeGr9+pj7ZeGUU+MyB9Kg
         ZmY7NbMA8yGKXLHqsc7Q5kUYn/ahFx2pHxi0O4LHEes0EnNdrwFdQCoFO9iLNNkjb12q
         12NQ8oJxQEconQ/IIgjcB6IFhF5xx7bTp2rUN43sb0TQNkM1sD0rPLF6JDmSJKgCa2Ku
         MbC0R10WOjDq/meiQebLxDBKr8MwwYREctjV8o1MoEETmjcAqfG7/wHBgWhE/A1OLpC8
         pb4w==
X-Gm-Message-State: AOAM530FOo4WxqqbWJSm/pGh9YQyKzMxeMLSMrkrwE6XO+33N5cNcv1o
        5jgelvJf5b/PqJQk/X7MXSE=
X-Google-Smtp-Source: ABdhPJzZBcdlIWsxCtuPUCvc5tKRYNp8buTWmVjBkApuDhQyeR0Nmvm6sC7hupko65euTZX3dIKq1w==
X-Received: by 2002:a17:902:9886:: with SMTP id s6mr15406120plp.112.1593981829468;
        Sun, 05 Jul 2020 13:43:49 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id 17sm15402073pfv.16.2020.07.05.13.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:43:48 -0700 (PDT)
Subject: Re: [PATCH net-next 5/5] net: dsa: tag_qca.c: Fix warning for __be16
 vs u16
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200705193008.889623-1-andrew@lunn.ch>
 <20200705193008.889623-6-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <85ebf910-27ef-a1a6-65f6-91c8751192cd@gmail.com>
Date:   Sun, 5 Jul 2020 13:43:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705193008.889623-6-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 12:30 PM, Andrew Lunn wrote:
> net/dsa/tag_qca.c:48:15: warning: incorrect type in assignment (different base types)
> net/dsa/tag_qca.c:48:15:    expected unsigned short [usertype]
> net/dsa/tag_qca.c:48:15:    got restricted __be16 [usertype]
> net/dsa/tag_qca.c:68:13: warning: incorrect type in assignment (different base types)
> net/dsa/tag_qca.c:68:13:    expected restricted __be16 [usertype] hdr
> net/dsa/tag_qca.c:68:13:    got int
> net/dsa/tag_qca.c:71:16: warning: restricted __be16 degrades to integer
> net/dsa/tag_qca.c:81:17: warning: restricted __be16 degrades to integer
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
