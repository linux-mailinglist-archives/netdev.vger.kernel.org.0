Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03ECF4011A0
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 22:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbhIEU5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 16:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbhIEU5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 16:57:21 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DDCC061575;
        Sun,  5 Sep 2021 13:56:18 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id mf2so9239130ejb.9;
        Sun, 05 Sep 2021 13:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sLIDTslMkmVgxwNYRM+eX3+QW+s41+jdqv1D6XAF4jo=;
        b=Kt8HKzudt6txUZf+ckJlGjgRcWHvF80hMvoIA4pgmyNf/h4I07A98U5gHmj1Xmejvd
         t2b2SoEhKWIos8yn7JN82OIJBuEPIVMxOxZz9a1xePbu3V1ujo4T44/XAcUTy/DMsEhM
         +flQ83HWTT1oZBPOPSiDaglxjXRhtPARZ6TUyJ0rsZa3TKgBhkLRL4yqb1Vdljyvg8dx
         scIH8WVOmGz6Hr+L6M/6mbzjbhjydWlKmoWS/uLry1Vu+lW/FgLo3KIwkayHXYe+0NQb
         KOy9a2qB6kbgBxTDFls7Eadh6kF+fbQ5SSVS+p/ZWm39zNpNN7xMkrgHp+vwew2vx03Q
         +jRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sLIDTslMkmVgxwNYRM+eX3+QW+s41+jdqv1D6XAF4jo=;
        b=Kr6Qa71Q0/g37sM4mjFbr7NSR7w2qa3DS3e98iUfJZbhyDcs8nEec3G7KnJnx64wji
         0vG5hy+sRP9nZYvTEYgLGOErpHlMrwVtLdj/NbK6DRLB8tsQMig17ODIeBkpPLYKmEhH
         N2iBEZOKnYLxt2Ebg1qicEvmTcBLP+tlbw149ji7B5qyhSVLaPPOrA6mpldSeL2XSbKn
         obEmh0tob3nfEcmiGiumNdZzjwQh2xn0SsCbLBDriJFxrTu+A0MI91/09NkxuUWc0S0e
         O6D6fKyrR6y1RWMI8MLDjrrLZ9OlFYBklOcJbzStAJOuLq2P7fXJn1yaoVMtmdVYVUb9
         KhgA==
X-Gm-Message-State: AOAM532iQzcT53qMvJkd0dTmDTkGaiKfJRbCKyE1z3y1K54KLE4QDd2t
        W8JnEDPz1X4MoCKMGvsqBr58lA4UeFIjwg==
X-Google-Smtp-Source: ABdhPJw8gV2nOVyZT97AF5qGSIE2zSaYEKOV5D9AgSGZlDQ2VmRxF/0sWNhywMYYIDtRNzRhMnoRog==
X-Received: by 2002:a17:906:5950:: with SMTP id g16mr10164350ejr.135.1630875376684;
        Sun, 05 Sep 2021 13:56:16 -0700 (PDT)
Received: from kista.localnet (cpe-86-58-29-253.static.triera.net. [86.58.29.253])
        by smtp.gmail.com with ESMTPSA id sb21sm2816383ejb.8.2021.09.05.13.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 13:56:16 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 31/52] dt-bindings: net: dwmac: Fix typo in the R40 compatible
Date:   Sun, 05 Sep 2021 22:56:15 +0200
Message-ID: <2971718.iJFk65zBEU@kista>
In-Reply-To: <20210901091852.479202-32-maxime@cerno.tech>
References: <20210901091852.479202-1-maxime@cerno.tech> <20210901091852.479202-32-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne sreda, 01. september 2021 ob 11:18:31 CEST je Maxime Ripard napisal(a):
> Even though both the driver and the device trees all use the
> allwinner,sun8i-r40-gmac compatible, we documented the compatible as
> allwinner,sun8i-r40-emac in the binding. Let's fix this.
> 
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: netdev@vger.kernel.org
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>

Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej


