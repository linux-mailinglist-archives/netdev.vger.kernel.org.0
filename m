Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FF42F04B5
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 02:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbhAJBZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 20:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbhAJBZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 20:25:23 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B96C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 17:24:43 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id v3so7631955plz.13
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 17:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WnN0PzClSISeFF68JSqSVBfauakNRlL8s2Al9dfWsrE=;
        b=mpB77HDp/L57ytP1++u542OIN8KXlXAa+aHWeIor+v9HDNOZls+xXk7HDDJ0W1/t6N
         BWROV+D+2WoieC/+qYf5MNvVPsYXohuzmeClilhoAH+2eJ1LHLcCguJ4H1xi/4xQlEvq
         ThUWbnrRukvK4f+urQckLoZRu1paAgn9G2HOnR7UULAsFiYf1Agx7wuVSOaFMQ6L08NP
         Ib0lrFlLCHxFG5QQgnG7dHvCBvq9eMEaIKsHU1h3zSvrnFiYRvtvN5BUsTnVCQpMgrGE
         Iz5gOBvQ1U0sNNBQDm9Uy6+P8LzyaI5iyVz4jEJ/2hbH2PMaMV0bbn9vdyavT7AFtEWZ
         TiDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WnN0PzClSISeFF68JSqSVBfauakNRlL8s2Al9dfWsrE=;
        b=Etda7WBSN3PdeS4WwDjCXUILxB7G/MmhOVZj9IYhyygvIYMm8xMjCcSKLhYgU/K/D6
         WUsaVhAl7cha6bCrvmf2p2nC3LSb4L8IKa/06xSqscU+IqigHnovKax7vECXqp+vO6CF
         Qr71tgaUuQ3FIPJIi4SCGq7R7Jj6eci6LsYt8UFNgZ+hGN/vdwZn2qNCPUdsuivFc0Vq
         lrbQVmbbhdkVbcKT626zSJKDcA9tfybz/vpgbqhB8vY8HESf1N1RfbLNZ59PO3y+Cgyh
         wLajklHFaa/Y20Pngy/U3qJXmucFqrezlraH/+24DKPwFn7yfFGxmyu2Wa8X7jfwWfrW
         UIAw==
X-Gm-Message-State: AOAM531kB8nDCuY8jLWQcJdYXF0VfCmCtaraAuX2IrYSdkz91zMyIyMJ
        q2tIHO6xZn9PTLRJkfhCiho=
X-Google-Smtp-Source: ABdhPJxUoWbu6ThsPr9ERz+W+X9oCb2em6GbRsRg+I148fLU0NTHlY0TPH5e1+sHjtdxGQe88N26+A==
X-Received: by 2002:a17:902:b493:b029:dc:3e1d:4dda with SMTP id y19-20020a170902b493b02900dc3e1d4ddamr10588266plr.48.1610241882604;
        Sat, 09 Jan 2021 17:24:42 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i10sm14938358pgt.85.2021.01.09.17.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 17:24:41 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: felix: the switch does not support DMA
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com
References: <20210109203415.2120142-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b64a110c-e38e-7cc8-39d8-164cf048f62a@gmail.com>
Date:   Sat, 9 Jan 2021 17:24:39 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109203415.2120142-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/9/2021 12:34 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The code that sets the DMA mask to 64 bits is bogus, it is taken from
> the enetc driver together with the rest of the PCI probing boilerplate.
> 
> Since this patch is touching the error path to delete err_dma, let's
> also change the err_alloc_felix label which was incorrect. The kzalloc
> failure does not need a kfree, but it doesn't hurt either, since kfree
> works with NULL pointers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
