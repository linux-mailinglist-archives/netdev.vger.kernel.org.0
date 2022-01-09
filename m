Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A01488C53
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 21:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiAIUpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 15:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiAIUpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 15:45:07 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518EDC06173F;
        Sun,  9 Jan 2022 12:45:07 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c126-20020a1c9a84000000b00346f9ebee43so6093832wme.4;
        Sun, 09 Jan 2022 12:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Gi9wdT5oBY51uN+zY1MwVpQ/L/Lhj3gJuhU6uQRdk/w=;
        b=m1su08LbeO1QD13eo/+OKp3M9WjRJAE8Kaz45RmW61zZ/KHLJTuFEEGlr7OdcQdp6Y
         LRmE73W+JHeQGv9q1Jc3LbukOGWJNs7Anulqo+3FQZHPyShZnUppB4Xhntozni6/NXlU
         Ti6qB0FPK64y6jUD2meZdwvdm6/5BIwLEAU4WwqeDqtKOqvTMnCSDcdanbU1siPDSJlR
         luqBwyH5jm5f5m/0FyUei0zfhnfHze72CEYD/IHeb4ONc8HupgopkR9BxFf5WjokM4M0
         eTRxuIyv2Jayi8ZmUfMdfg1yRZInYNod1HgV0VRmPTZx26GCAadz7olmnd07QVarAku1
         7CVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Gi9wdT5oBY51uN+zY1MwVpQ/L/Lhj3gJuhU6uQRdk/w=;
        b=InMX340hjm6HFJ6MO0T6qGNRrkd3lfsmSetED3Fu/o0atveQw/SHmbrFI7hIjTqkWC
         UqsIRFHlI1Pcnsf4VNtYLocYLHMejjdgZhYQCfRUXw82eme2jUQ3/qk0OhVmmmGrPybz
         zjzZvjt3/ktxzf8rrIvVYeu1O1XVeLoBxzJqYgli7ITKD7vBRLnYQcPTDQ2nXsrLZtxf
         7zEX0Yut/NNWDZU0lv3+oBv8bEmwNW03cVDJyDMImOJgRf3jJ8itnbVTgSxlhKY9pTiE
         M2Rk8+FTzvWRQsSnEDFy8HCJrwmTlk3dVLqP5e4mGfdl/VsK8Z+fMvHlucz2lb3rooM4
         h34g==
X-Gm-Message-State: AOAM531HFgjlm8UcrCLnphGuXyjK5I91fRmhyGMklBojAAKjyig7hIzZ
        TxjHeO+OidHq56L4WbWa++w=
X-Google-Smtp-Source: ABdhPJxaNhA2ItZzKI6DN4P4iEVQQrkjsiqKEKfNL810ixld5yhvQDHS1ieLOJEQh6FXCWW/mskzSg==
X-Received: by 2002:a7b:c931:: with SMTP id h17mr2675642wml.49.1641761105763;
        Sun, 09 Jan 2022 12:45:05 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id l14sm5030936wrr.53.2022.01.09.12.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 12:45:05 -0800 (PST)
Date:   Sun, 9 Jan 2022 21:45:01 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     conleylee@foxmail.com
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sun4i-emac.c: enable emac tx dma
Message-ID: <YdtJTQJJ4aEUcp/D@Red>
References: <YdLhQjUTobcLq73j@Red>
 <tencent_E4BA4D6105A46CCC1E8AEF48057EA5FE5B08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_E4BA4D6105A46CCC1E8AEF48057EA5FE5B08@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Sun, Jan 09, 2022 at 05:17:55PM +0800, conleylee@foxmail.com a écrit :
> From: conley <conleylee@foxmail.com>
> 
> Hello
> I am reading the R40 user manual and trying to create a new path to enable
> emac tx dma channel. According to the figure 8-21(TX Operation Diagram),
> I try to enable emac tx dma channel by the follow steps:
> 1. enable tx dma mode
> 2. set packet lengths
> 2. move data from skb to tx fifo by using dma in xmit function.
> 3. start transfer from tx fifo to phy in dma tx done callback
> 
> But it doesn't work. emac tx interrupt and dma finished interrupt are
> raised, but no packets are transmitted (I test it by tcpdump).
> Do you know how to configure the emac tx dma correctly? Thanks ~
> 

Hello

Here are my thoughts to help you:
- Your email is not a real patch, but an ask for help, so you should not use [ PATCH ] in the subject.
- If it was a patch, "v1" is not necessary
- Your patch below is doing too many unrelated different things, it is hard to see the DMA TX enable part
- I think you could first send a preliminary patch which adds all EMAC_INT_CTL_TX_xxx which are already used by the driver (to reduce the diff)
- Without the DTB change, it is hard to see the whole picture, did you correctly use the right dma number for an easy example.
- Knowing also the board (and so PHY, modes etc...) could help
- I think your priority should not to add TX, but to fix reported problems to your initial patch (build warnings/error https://marc.info/?l=linux-arm-kernel&m=164159846213585&w=2) since your work on TX will need to be applied after this.
- For the previous point, always build test with at least 2 different 32/64 arch. And if possible a total different arch (like x86_64).

Anyway, I will try to test your patch on my a10 board

Regards
