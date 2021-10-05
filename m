Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FB84230DE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhJETna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhJETn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:43:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BB8C061749;
        Tue,  5 Oct 2021 12:41:38 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b20so593029lfv.3;
        Tue, 05 Oct 2021 12:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oAjkqsyne2ea+PiSLO5vd6qEiJ1CP72ad+5YbvqUgHE=;
        b=hV6P/aILMTnSwTG1sGTDSUQ12/cCRigFMoI5dPBW1C3EPxK6U1/o6cUagmP7aDHCJr
         ffeaeVXXAsaiIpQvFw6+3cB7/TQfh3Oc7ZJKWhA4c98eNl2h0z9yLXm9ksDSY/4zq2Ty
         zEEDXCbkADqsEByoc/qojMAeWseoyTZPPGvU8rBaPJlJSPj11bI2ZXg1E9VdSkm06KTo
         /JVvopPrk4WpY36FF+73nBdzdqM4lqfkycE/I+pug8LasLOsHhh8ukWmOlOOjN+GMJXd
         qTla8SIhEfgR46O6lSKov771B1a2S7AVNRYj0hujszKS2UQ3O4wiFS+5Ds855VrAROzq
         gJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oAjkqsyne2ea+PiSLO5vd6qEiJ1CP72ad+5YbvqUgHE=;
        b=QJ/eD/6k1IgQzQzRnNStPfqJbYpIExOB4B4S8bQduC6RXrrJ8i0fN9/IlFJNGd/Sg/
         y40YFH2UMRGSad/joMQLdWQ4Fwvwo5WrH9vad1RBL+x3tGSFscDYTvYKVasz/wFsRTiK
         L+zdR5mfmC5aJ/d0AQ3hsajCDKZa5UsPyfKaqmeBTSJaBOKFrVVPOl5GE1TNnDOP210X
         ScQ6zw3uCtglgtirFXU2UMhOcvz4l5Qglq/aZkKsLqM46L0V8EV0kswrJ3n8iTvQLRbA
         QXQicq5x3E24jTJcv904YyxzmcR7JynC1aYx88QlOTv00VWl4447rIBH0JoVN5T+/+W9
         PCcQ==
X-Gm-Message-State: AOAM532LvxSL7PpqwkCX8EWD4/5787WlXVIBovx8HWbzNPyhYkW81+TJ
        cEuNzv1iK2EEmqgCZv222Ak=
X-Google-Smtp-Source: ABdhPJys/L9EN4v81oDm67qWbMmbDERDz2dnx6LOneWcNM1cGMAbqTTK89C2daj46vnkx6kgJO803A==
X-Received: by 2002:a05:6512:3228:: with SMTP id f8mr5255705lfe.472.1633462896528;
        Tue, 05 Oct 2021 12:41:36 -0700 (PDT)
Received: from [192.168.1.103] ([31.173.84.101])
        by smtp.gmail.com with ESMTPSA id w24sm1238782lfc.99.2021.10.05.12.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 12:41:36 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [RFC 05/12] ravb: Fillup ravb_rx_ring_free_gbeth() stub
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
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-6-biju.das.jz@bp.renesas.com>
Message-ID: <6675a686-3d6b-2384-7669-1097a035d4d9@gmail.com>
Date:   Tue, 5 Oct 2021 22:41:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005110642.3744-6-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 2:06 PM, Biju Das wrote:

> Fillup ravb_rx_ring_free_gbeth() function to support RZ/G2L.
> 
> This patch also renames ravb_rx_ring_free to ravb_rx_ring_free_rcar
> to be consistent with the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
