Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34EA3DF6B7
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhHCVHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhHCVHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:07:13 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0044AC061757;
        Tue,  3 Aug 2021 14:07:00 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x7so142077ljn.10;
        Tue, 03 Aug 2021 14:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L3rU4ifoOnF4riIv3FdwQH45WWMP9lZjaHwDZe8Bc0w=;
        b=nKsAbERg5PscQchW8ZdrISG1iFWtuqT/GuK7OjZlJRfD6+/S39/iSpyDAXYJ+LKr7F
         t3tkRJGhu7PixYBgq27Plsr0rUj8/x53daXtKlYVv16aVtseC+WkFTf/tVTUsLRuvwrt
         USF1bTuXDqLSJFeETDR/qEt8kpNVUy3RXS/4S16AODXzeGajztLwOsbi99JUFMZRbx4p
         hKSzZEB2Liamf5mp7zpc1LftuRYsCKyngEQDQg+dQZkiAacgXhUNPDyK6tZANsV6t8DG
         RG2ymOje8/sNkCQJuTmzd0oeUnse6YQJFbXFba3vZQq1T/agazv14GDE2YgVARgPUQUq
         c5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L3rU4ifoOnF4riIv3FdwQH45WWMP9lZjaHwDZe8Bc0w=;
        b=rGQdsM3OAuwcUmQsDjwKp22ddtIUEHagn+Kf6vg6dbWDLfG0FmMh9/oBhhZs3onaKg
         uvlh1isxV2xpnmJg99ev4MLP7Ntv8XG+GnXPyh2rlsI/5bWH0jIM2p5E7sufkOR1DTtY
         H1yJkZvcY54NpHTceng37TZqXEeYUfOv+EELphsRR8TpAnj4grNU0/tYhBd04TdkDnC5
         p1FFbk6oFbbwZ6jtVB1wR2osWljQMSWnVpOw9m0IEXRaMvyP2WQufDTU9pdZwBbfqkMr
         FkgtmHcgvUEuFRxBUPGUHvNUO2ZuuY9T0xaHMyjQ1nKPWfDLmpOQAtZY/JjdiPRLZiyP
         jgOA==
X-Gm-Message-State: AOAM531ZBpip6Z2d01FJmR8UPGXfQ4NnbyqE1SzsGunzFxmAE6MGJ1VC
        dz5It1jjyfVSOPTRu+OMl7M=
X-Google-Smtp-Source: ABdhPJwNrELtfqA+rtCvFIEtXaXkXQf90EOhlU/qk4TAZyWwi1CorPso6tt0CRE/zEU/YI8/HT9S5A==
X-Received: by 2002:a2e:8145:: with SMTP id t5mr15904927ljg.432.1628024819425;
        Tue, 03 Aug 2021 14:06:59 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.76.0])
        by smtp.gmail.com with ESMTPSA id e14sm1347208lfn.97.2021.08.03.14.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 14:06:58 -0700 (PDT)
Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <ca7f38af-8ba7-877b-e76e-d30537f54fed@gmail.com>
Date:   Wed, 4 Aug 2021 00:06:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> R-Car Gen3 supports TX and RX clock internal delay modes, whereas R-Car
> Gen2 and RZ/G2L do not support it.
> Add an internal_delay hw feature bit to struct ravb_hw_info to enable this
> only for R-Car Gen3.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]

   OK, this one also seems uncontroversial:

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
