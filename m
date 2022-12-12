Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2113B649C5A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiLLKkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiLLKjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:39:23 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E838BE15;
        Mon, 12 Dec 2022 02:32:53 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id m18so26741803eji.5;
        Mon, 12 Dec 2022 02:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oiwl2c63AO+NrruKJbKlZpKuGSFSXf3Tju4e8sWaifI=;
        b=UGKQiptlBN3qqIdRrlqUM6laB083sdblO1l6gx94GWrEqN/pEIaC/ADAVvElvUadzd
         wCWAdKdXKfLU15N6YKymzEgwkJZoE612akG8YIg10FTpK8d2d4ZT6OvGelCxqO0GMDSa
         6wPD5NwyodeR0w37eIbDYTht81SCF0jQf5bvK9RjBqFDPITl7X3XtCPACH2TrjbvnUBx
         AQ/gQgui1kcFsTOUKIy8Zcyl60J2hP00zk8wPeu11xhD+Hk58+LcsdKwn6+feh9atTdE
         juq98rHeOmvEJle8TqzTmQPCBZzFXlsoiutiQIc1ZepuYUafyyp9vkJO24akljZAfvMg
         Lh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiwl2c63AO+NrruKJbKlZpKuGSFSXf3Tju4e8sWaifI=;
        b=kaM/zhg75na6dLagh7I0LaPXLIDguWrG0Dd1DY/+Mtoo0eZiKbmdd+NQkNC7qDEXVr
         Fyori9+fvipvfNzIBdgTQwtyjPbw/rtDXMIi0o82fm38U0sweS8ZwpMsnenhV17Gc8T2
         ZWEA5UTTaGWz1qbpwrCUrzu/CmSO3Qjy9gF9Pbrsz0YglqQaEQO6zvnGXfl/i54devm3
         OdhjfQvmSx1IL37kh3YAx+EQXGxuK3+vwcoDhqBZ88qZdhIcjZy2/htOEzXJD1IVskQw
         GffC3PLb0nhbeJeP6V6L7PIHmb7A3rDqM47ug52xeZe/uiIwfoj8sFeSJ8nmrKJyquqg
         J7rQ==
X-Gm-Message-State: ANoB5pmP0y5xbKdlbtvujrR/2i/HnDIklRPaIpH8y2fcVIczVfKIU+HC
        Hc+6eChmrxrnJAKnuR1N3Ns=
X-Google-Smtp-Source: AA0mqf4N/bZH1XE/66G5F4ToAvEhzkEo8dhz4w+UxeFjIotk0gQmJG6ESuNp93avICDiDvKlV5b6mw==
X-Received: by 2002:a17:906:f741:b0:7b4:edca:739 with SMTP id jp1-20020a170906f74100b007b4edca0739mr13312088ejb.5.1670841171906;
        Mon, 12 Dec 2022 02:32:51 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id hw18-20020a170907a0d200b0073022b796a7sm3152613ejc.93.2022.12.12.02.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 02:32:51 -0800 (PST)
Date:   Mon, 12 Dec 2022 12:32:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: hellcreek: Sync DSA
 maintainers
Message-ID: <20221212103249.2l5tm65khg26bdb3@skbuf>
References: <20221212081546.6916-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212081546.6916-1-kurt@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 09:15:46AM +0100, Kurt Kanzenbach wrote:
> The current DSA maintainers are Florian Fainelli, Andrew Lunn and Vladimir
> Oltean. Update the hellcreek binding accordingly.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
