Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822D355DFE5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343958AbiF1KVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241044AbiF1KVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:21:11 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7930DCD;
        Tue, 28 Jun 2022 03:20:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id fd6so16859946edb.5;
        Tue, 28 Jun 2022 03:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9XPUwyFas2H8lcJww0EajnujL9NExORhBnhKC1IrqLU=;
        b=g7dF4r+KJGcuK7Wdmmp1dwPz2yt/6+6V+eWDhFKpTmun1Y9RBZl2/qNZRJEJrEHUDj
         gIpjKKnk/Jfo/WO3lYhRBrMKFGJf/ZtzHc3tUEYoptMDDfJfi/uHFM4uXglVNoLaYjzB
         cg8ag7LpYqJ9btmpgUl+PQJ5qwBXHvKXdPtFXcwo71yGvdchDETGpKNJ2qg/S6iV2izb
         s8ofzOGuHN+W+xkr5R/TubJCVPANRMcLNvbQnMWNXiLeDxTjd6wRUJjjuu6CVMNyOpwo
         YcLUtK1qDa86i1PJbAGOS4P2UwmsbSBIC3FNQO9DOF+7IsnEVjvAuKm/BwGNlxsJn5bB
         2h3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9XPUwyFas2H8lcJww0EajnujL9NExORhBnhKC1IrqLU=;
        b=xvy7zwfHZLlPy5ze6YRvt40tNj5GpbJEUticw5oh/6Sk0sF/2Q0mkA7wz2YDMRlwGe
         u9J6tWV//02rlqEgspFK6L7imWKcb8So/1MW4f+fY06ZTHR2jyvR7pTHYoU7FOspcusj
         HmenYmchkPO/04Y/guUxEd1ayz4QB1bLa5WPnN2Cr2CNbcFwEaWcIef7SrWqYgcEXvcP
         QKQyJRppj487CTVj5ufai//XZdn7+wYEWDhUMFQ1LBSE3G0/eQvnaBfAVraSsdYFEduj
         qOUPChLh0qDIXTvk1icgrzEkK1w7/1td4uR+gk6dmiI2UF/8Wh16SD10nY63aezfeqxD
         97cQ==
X-Gm-Message-State: AJIora/5A0FhfA04YRnijGYgS7LPQzFkAQx31l95dA/cFZO5ejuWH4qf
        JEycmgPGuMIgtrStb56/oyM=
X-Google-Smtp-Source: AGRyM1sKnFdZJkQPEmLF12lsDvpgxty5ZtGoPnUadM/o3rTuRMPCubU21TweehOES21GHpjsuvlbfQ==
X-Received: by 2002:a05:6402:120f:b0:435:6e96:69a with SMTP id c15-20020a056402120f00b004356e96069amr21806144edw.363.1656411644118;
        Tue, 28 Jun 2022 03:20:44 -0700 (PDT)
Received: from skbuf ([188.25.231.135])
        by smtp.gmail.com with ESMTPSA id x6-20020aa7cd86000000b0043574d27ddasm9110243edv.16.2022.06.28.03.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 03:20:43 -0700 (PDT)
Date:   Tue, 28 Jun 2022 13:20:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 4/4] net: dsa: microchip: count pause packets
 together will all other packets
Message-ID: <20220628102041.n24n27lzhcmrrlxy@skbuf>
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
 <20220628085155.2591201-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628085155.2591201-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 10:51:55AM +0200, Oleksij Rempel wrote:
> This switch is calculating tx/rx_bytes for all packets including pause.
> So, include rx/tx_pause counter to rx/tx_packets to make tx/rx_bytes fit
> to rx/tx_packets.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

I think this is a reasonable thing to do.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
