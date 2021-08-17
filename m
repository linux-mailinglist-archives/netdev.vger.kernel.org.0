Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD23EF2D9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 21:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhHQTp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 15:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhHQTpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 15:45:25 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D5BC061764;
        Tue, 17 Aug 2021 12:44:51 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bt14so25072362ejb.3;
        Tue, 17 Aug 2021 12:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Y7rTjG/M+6uDTVtHjtP9IvKhLKkvCTPLQrKnClbwO8=;
        b=dJ/oF4FahfL1E/71MtOarwOSy7m+DqBC9ZyCxPCttLspkSD4tGsuW6M+5iwfLNa6z1
         AU73EBgbj/KAHZrnicl7cAVf/vE9I9PemFbv2m5Swg6eRMtU2YvP29a2/+DubQmOGY8N
         NL1E3XHIIE8+CM1UUjfCWTeY80X2oSWugOTUAETj7egkk3L60Hi4+12x7gK+/mhN+2ac
         X0D/5dvh9FYaEXhMjgH81lb0QajAvaJoI9PVWXgC1hW3sn7sHiINbP80qfq9ClYZMZQt
         DrNoAFnbAOP8vfG9ZAgFbhJs1RVquqzoBygfsqBRLTBI5L2pABPmFK58o6kRAqOI7s0k
         na8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Y7rTjG/M+6uDTVtHjtP9IvKhLKkvCTPLQrKnClbwO8=;
        b=eLyJsBMq5RyELyCQoOi6cxzLH7hvNfLlT8Vz+6IGckFDfQLZEajsoBz6fI4DMA+aFd
         jB1sCD7aG3oULQpgnb5eYzrMQK8N6jMoGPO1HdhnQHc1cLn+gM6db52Ak2iWBUTtiaRB
         XD48OrpC2ULUN89ioV6SQOmtU2JGST3ak0uNah1SxmKdfJaNT0Al5k351Z1cnOriUVPK
         kuHz/Y7TgazlBAYUoNEWF1dgyuvkwJs1q1NuHTyJXxCn4Zzp4IVT94SeiXInCcoIgiYl
         mehK6KYcSlU3lTDFeeOymIf5T6HMtd0GLiJjJ3UzP1iMBHTAzMcYOirmuyA5ykQMn9SA
         aofw==
X-Gm-Message-State: AOAM533lm6d7LZTwe/FPJG50TtIimx0NtlPSPppW7hqPYceYrpzG9hL4
        Uh2ztm68f20wYfxExjec4KM=
X-Google-Smtp-Source: ABdhPJxSzbC7xCrfHySEOs6nop5UC/NICe1HW3vn63kPCsfsWQgTxPfGvXBcy2dM8UdmgwYYf5nXhw==
X-Received: by 2002:a17:906:2792:: with SMTP id j18mr5755698ejc.168.1629229489882;
        Tue, 17 Aug 2021 12:44:49 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v8sm1144428ejy.79.2021.08.17.12.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:44:49 -0700 (PDT)
Date:   Tue, 17 Aug 2021 22:44:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH] net: dsa: lantiq_gswip: Add 200ms assert delay
Message-ID: <20210817194448.tyg723667ql4kjvu@skbuf>
References: <20210817193207.1038598-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817193207.1038598-1-olek2@wp.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 09:32:07PM +0200, Aleksander Jan Bajkowski wrote:
> The delay is especially needed by the xRX300 and xRX330 SoCs. Without
> this patch, some phys are sometimes not properly detected.
> 
> Fixes: a09d042b086202735c4ed64 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Tested-by: Aleksander Jan Bajkowski <olek2@wp.pl> # tested on DWR966, HH5A
> ---

Generally the convention is:

From: Patch Author <patch.author@email.com>

Commit description

Signed-off-by: Patch Author <patch.author@email.com>
Signed-off-by: Patch Carrier 1 <patch.carrier1@email.com>
Signed-off-by: Patch Carrier 2 <patch.carrier2@email.com>
Signed-off-by: Patch Carrier 3 <patch.carrier3@email.com>
Signed-off-by: Patch Submitter <patch.submitter@email.com>

This patch is clearly not following this model for more than one reason.
