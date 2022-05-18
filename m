Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B8E52B936
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbiERLxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiERLxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:53:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC5936319;
        Wed, 18 May 2022 04:52:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id n13so1440136ejv.1;
        Wed, 18 May 2022 04:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MqhErziUEw78e6VTLZU9E1LrqvgPXxI1qfZwHRU+Wg4=;
        b=Ldg0yXUBO/N4BoCEL7z+USUKsS/S7OwcsdUEa+17wn71t6KoOvHEcMecvQy9RH+rhT
         PZH0NsGuUwp1qLZZHfy0kN7+eVMcnqVL9iSjaB3TAkHRT1VgjUJ/KHoe/NOWR4IPVhVn
         w/jyj6LWAJueW2Eq48G0LLBsStTRFNcHSKQorDw1DAVWbfYg0wzdGrLVlfwGa4I7zP+3
         aqNoGcN0CiOUBPFbem1tSRNp57u8lCIlOjnWUbd8sjzHypD57pkn2OzEQ/AljChMlwgW
         Al/uKpm2LDC1TY+7UyYmsI5fSijEh112WKnZdhKnvRTC9OKBvVGuvh5VLrVgqSbAhe5f
         JSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MqhErziUEw78e6VTLZU9E1LrqvgPXxI1qfZwHRU+Wg4=;
        b=Up6dHyQtIVojN4EsK5ogdDWRVCSMKOKFu4uFv+1UdKjjLKb/sU6zGqaTCwst6ABNOA
         OXFPBW43OjIb0ho8/yAAX61R1tAY8QOchv693ErtSSEPJE/qdKXmV/x0RZKhI8vj+PLZ
         FgCixcj7wrUacowO8AnZH7LDjphkThTxtREH28xJIeUTKIfAMZk6FjzJRjlqodbcW1cx
         VKoQhf2NIfmgWS2129iwE39hfBvTosqS6TlzFAnI3x+fZUFl36/TBK8vuDYRDyquCG0U
         gRMF0uT+7o6cUYOxMjUe9CjglDo+Hcd9H2JZqE5KlHbsZiDXXoRzr9tPUesprfyqIp/B
         KEfQ==
X-Gm-Message-State: AOAM533MOuBjGCtHL4m0WrtWFnEOp+vye+BpDV6/aBsvfovqJq2nRjN4
        1HYJoda0TrR4VO0l3YFcD+U=
X-Google-Smtp-Source: ABdhPJzdLHDC2YSdudKFMOdqsfKyN9aV51oMqEDlQjYPkWzCw/9Gb/RZCjdQlKmgk/6akMA3FUaWlA==
X-Received: by 2002:a17:907:2cc3:b0:6fa:55f:8805 with SMTP id hg3-20020a1709072cc300b006fa055f8805mr24115348ejc.46.1652874777182;
        Wed, 18 May 2022 04:52:57 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id n24-20020a056402515800b0042ad0358c8bsm1221775edd.38.2022.05.18.04.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 04:52:56 -0700 (PDT)
Date:   Wed, 18 May 2022 14:52:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net-next 4/9] net: dsa: microchip: move struct mib_names
 to ksz_chip_data
Message-ID: <20220518115255.xyazzfo2snzy6c3f@skbuf>
References: <20220517094333.27225-1-arun.ramadoss@microchip.com>
 <20220517094333.27225-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517094333.27225-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 03:13:28PM +0530, Arun Ramadoss wrote:
> The ksz88xx family has one set of mib_names. The ksz87xx, ksz9477,
> LAN937x based switches has one set of mib_names. In order to remove
> redundant declaration, moved the struct mib_names to ksz_chip_data
> structure.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
