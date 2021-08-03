Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711093DF57C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239597AbhHCTXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 15:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbhHCTXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 15:23:05 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10854C061757;
        Tue,  3 Aug 2021 12:22:53 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id u13so4497185lje.5;
        Tue, 03 Aug 2021 12:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tX6Nes6Tya5cekbY+qN6NZDqUK1uRfuKO2zy2ytbhqo=;
        b=fD3vSCXlb8n6YT1qemNGLmJp9TBM8UCu+ILw8ao3yPk3j/kJIGV6CWZ5d43a0emRkG
         /m9JEkGFqUc/pJswtm3KiR+JUewYHeoJR8JBm2BjtFBn2QSCnRCVjdWnfAxFCXzlno86
         kS9jtB5zflmMVWJ3T5G1OY1MxrPXk5wkJLvUh1+b4IbzlJQh/ojCZwJqtQOG9tE3qgNl
         axYTaBNImEa9WwNjduCj/eYqxzGzWw8cRI3o+k9qm9AO2hMXm2rjOS2w+J5R0XbbCJSv
         H+iTapzeR+qPLUq3y7Qae5+hYTE5D5Sjyawo0agrvQAGv4WbUeOWUYV3NCaOOdmTZ2qb
         cl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tX6Nes6Tya5cekbY+qN6NZDqUK1uRfuKO2zy2ytbhqo=;
        b=I749zO4rhNJtJ48jaSyZFesq2QEs5zCU0Qjkj0e3s3MVBq9tKgVo3a/UqDC+rhK00K
         yEQYg0ACEWRaScHzEX+VEV0L0TJgcrW2H7Hym/+cC1Ypil1DW3nBGfrGDRltcwU4/S5u
         6zQxgsKjN6iQ+BVaxsY1DvpghXLZ3nkbjvHqgx3e5rDTbIDRvCETV3vdki9waUnb9xLf
         gj6kDBItimdMQNSq+zAmViFKaYcrC4u8ChzXhuiBLPEsyAQVMXZ0BPPPmC7RJMq7FUYk
         Oi7jxxQfQ/HZSA6bfbBn68yPL5NcMDepE2NbsXlMcMdNrBbqS7IcnGOtiFq80Z/XbSxX
         0jpw==
X-Gm-Message-State: AOAM532G8OV6PDMiy0dkNkc8HdqPdl5dS41+XUJ0lC3iOzLiRh1YlPEz
        q2bYkQRJ0LhwlVGcBueIaZS/UZcIXR4=
X-Google-Smtp-Source: ABdhPJxZ7SGtoL4xtRqc7Ob4gzk5vGJY5yIK9KI/viESHCp7rVZJr6ZwCCZdXt1HhW/QCkEt4f9RnQ==
X-Received: by 2002:a2e:900c:: with SMTP id h12mr15238972ljg.240.1628018571475;
        Tue, 03 Aug 2021 12:22:51 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.73.7])
        by smtp.gmail.com with ESMTPSA id k30sm1210938lfj.123.2021.08.03.12.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 12:22:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
 <dab78c92-8ee0-f170-89db-ee276d670a1b@gmail.com>
 <OS0PR01MB5922F86AB0FDB179B789B6DD86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <f5695fbd-f365-c86e-3ca2-41cf59ad8354@gmail.com>
Date:   Tue, 3 Aug 2021 22:22:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922F86AB0FDB179B789B6DD86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 10:13 PM, Biju Das wrote:

[...]
>>> The number of queues used in retrieving device stats for R-Car is 2,
>>> whereas for RZ/G2L it is 1.
> 
>>
>>    Mhm, how many RX queues are on your platform, 1? Then we don't need so
>> specific name, just num_rx_queue.
> 
> There are 2 RX queues, but we provide only device stats information from first queue.
> 
> R-Car = 2x15 = 30 device stats
> RZ/G2L = 1x15 = 15 device stats.

    That's pretty strange... how the RX queue #1 is called? How many RX queues are, at all?

> Cheers,
> Biju

MBR, Sergei
