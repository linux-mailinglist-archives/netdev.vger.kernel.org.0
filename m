Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6C2628666
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbiKNRAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiKNQ7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:59:52 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147862FC07;
        Mon, 14 Nov 2022 08:59:07 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s12so18219947edd.5;
        Mon, 14 Nov 2022 08:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ktBBLTT3vSliP/exlkdDZyhEYwd2DSgNnMzZXpJJ7W8=;
        b=HZuPUSrd8qXjxX3o0nHA4aQWN50i4yDSsiEHuuvdnZJKmk+2eJ74UY/x6wy9xLCFs7
         5d5DuSQNIX5DwL8A1m5P3piV8kYvQc9jMxENcp5LPPLD6TwXhYBbPy3KU6Bco2cjft29
         Xhgyvhi/ftRXWR/baep+rNIE+7aAOIT0ZAXa9HySYvG/r6t3/j2b+o2Sv2vJGvLBDkMg
         Ig4kRnM4rF3RCkAcPeDtHm+zOTnXJMLrgurt03e+WV60bqHyx7glPIFFy4+mroR0RHVp
         +2P+tqpz/CTD78/LXRxjRK1UDgr00MLFHiZ4b4vNq/HzlFLmJdbRp0CZ938xVfubuq1X
         gXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktBBLTT3vSliP/exlkdDZyhEYwd2DSgNnMzZXpJJ7W8=;
        b=KWsGL0lo6t623V2Gsdjps5tGyBmswE//BCT/DiFXQmKh5RdaGOHn0VJiCDpJrzUmXH
         +JwRhaA8vBQ0dcauTbozHNrA4lnhH+wluT8cKikdubHGPbHBRGFFRqs3fCcL7EaavHI6
         HLqb9DHBNMMtTTGLkJQqjqYwbDohGdP+SrBk5xdQ7FgmB2xuxo4R+UteM2v8G8BG2JnY
         IvZfBulycSTjjpgwRiGoe7vrjbiWjrqBeXZibQILd+Mk6wZGEWwh5JMkn2Dz9W+ncjfM
         tF7ojOASZ/Xq9mn8W6zZGlYxexIrI8g2fX99NmuLMqZPUryjabGQx5V/LO/+xGY/Qfs3
         uHIg==
X-Gm-Message-State: ANoB5plvN3ZxS2CTmVbTbQXVNVQA673aFO+/1fOTqBmRL/2GnuHJCyiy
        0CSnQCduIupPGTjEL0aLoloXyAvdgGAF1Q==
X-Google-Smtp-Source: AA0mqf6KPdGicfujqyp38xxA1ljZVkAXFApryF1sKrwWLtkMAWOLpAjaxlm/Q43Dm+kgIumEoT8FoQ==
X-Received: by 2002:aa7:d793:0:b0:460:d1f6:2917 with SMTP id s19-20020aa7d793000000b00460d1f62917mr12193750edq.207.1668445145415;
        Mon, 14 Nov 2022 08:59:05 -0800 (PST)
Received: from skbuf ([188.25.170.202])
        by smtp.gmail.com with ESMTPSA id w25-20020aa7da59000000b00463bc1ddc76sm4971101eds.28.2022.11.14.08.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 08:59:05 -0800 (PST)
Date:   Mon, 14 Nov 2022 18:59:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Message-ID: <20221114165902.zqkx32qlrkolcjxb@skbuf>
References: <20221114124214.58199-1-nbd@nbd.name>
 <20221114124214.58199-1-nbd@nbd.name>
 <20221114124214.58199-2-nbd@nbd.name>
 <20221114124214.58199-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124214.58199-2-nbd@nbd.name>
 <20221114124214.58199-2-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 01:42:11PM +0100, Felix Fietkau wrote:
> If a metadata dst is present with the type METADATA_HW_PORT_MUX on a dsa cpu
> port netdev, assume that it carries the port number and that there is no DSA
> tag present in the skb data.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
