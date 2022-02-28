Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021F64C65F4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiB1JrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 04:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiB1JrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:47:15 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF8B6A006
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:46:37 -0800 (PST)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CEBE03FCA2
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646041595;
        bh=vWRVPVArJCYlog6uyWwSBOO+0zNuAlMQrxtxYFl/jDE=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=hyq9p8CE5956HscQ2zSl/BeBPPf1RXV+uRUHaa1nBigGUghKBP147XGNXEjrBo4DL
         8+TmTL7woYEEC7lLIXj2w7LUIH01A5646f9Kz8A2TH/+owW0jWO/NTRwq8XIakvicY
         Vgqje9P4zuaT9Nqwu1gfKGbv5ICsqqCWMtRNRl1xlEwg5MyxoASpthLdnLux8hMEIY
         Ymi0fidVICipZUZYIIVx+8tN2AalMH9SLhJrzZ74sK9Py4uCz7i+DYIHCMBw7plafz
         nDCbzsd5toYdf94sTfQG/OSQ0sFNLYrTvlzhYey3RbZ2EHAs+1VYIHLLWo0D7+sfoO
         iAjq81BdhqvtQ==
Received: by mail-wr1-f71.google.com with SMTP id o9-20020adfca09000000b001ea79f7edf8so1834338wrh.16
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:46:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vWRVPVArJCYlog6uyWwSBOO+0zNuAlMQrxtxYFl/jDE=;
        b=UzCIrqssH/rMqXyMn5tc2RtZfnBy0rl7dps6cKGxicUmW28Gigjpny5Rzkb/e6u59K
         QLSj+IXV5NtmsAjmlN1e19cYfseIhsPmnIX0kR4wx+fUBgTfPAG8z17JbLKp1dtHWQfe
         yjmTCh5J08g2kMwtdgDA5QOPOzw4me46kfoHxIWyDlxrAxbh42GuTLMHy4ghXAYtDD87
         axXcP8zs10UiCwodQSFEB7gOPDoSUoExOUI4Rz760ncVikfEjVn56rHMF5R/+Yq3LvQo
         I/BW57HMikP2Z7SWV2LWs4RhoVSTx9k20OeiSSc0jFCxIaX22Lv2wE0b7I4QqVqNB1gv
         DLrA==
X-Gm-Message-State: AOAM5337MrBgqxbxTOoJEyJO7/1j1zg/oY//UDuvg9qFWKpGkfcXiclj
        onU+uElJRhBQMa+kYdIuKp/MaO4pa+lf68EIH+urWsA+ZUlBOu2bR/U4bBTt80ZyWdT4unLBxDc
        yicRukpgX1+mAOF+7zgEE9yUxTQJebo5B9A==
X-Received: by 2002:a05:600c:1c29:b0:381:7667:ab69 with SMTP id j41-20020a05600c1c2900b003817667ab69mr1406255wms.142.1646041594384;
        Mon, 28 Feb 2022 01:46:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjgfHayCZ6lM4CIvn6f9h7ICOQlGN4pyToG5DkHnFk0Kst5sueKcEZizJeXImKTwcW83XFsw==
X-Received: by 2002:a05:600c:1c29:b0:381:7667:ab69 with SMTP id j41-20020a05600c1c2900b003817667ab69mr1406248wms.142.1646041594244;
        Mon, 28 Feb 2022 01:46:34 -0800 (PST)
Received: from [192.168.0.133] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m12-20020adfe0cc000000b001ede2dd604esm9807179wri.106.2022.02.28.01.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 01:46:33 -0800 (PST)
Message-ID: <5e15401e-761f-2135-7f3c-fd78a455e380@canonical.com>
Date:   Mon, 28 Feb 2022 10:46:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] dt-bindings: net: can: renesas,rcar-canfd: Document
 RZ/V2L SoC
Content-Language: en-US
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
References: <20220227213250.23637-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220227213250.23637-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/02/2022 22:32, Lad Prabhakar wrote:
> Document RZ/V2L CANFD bindings. RZ/V2L CANFD is identical to one found on
> the RZ/G2L SoC. No driver changes are required as generic compatible
> string "renesas,rzg2l-canfd" will be used as a fallback.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> DTSI changes [0] have been posted as part of separate series.
> 
> [0] https://patchwork.kernel.org/project/linux-renesas-soc/patch/
> 20220227203744.18355-4-prabhakar.mahadev-lad.rj@bp.renesas.com/
> ---
>  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
>  1 file changed, 1 insertion(+)
> 


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
