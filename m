Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FBB36B42D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhDZNjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhDZNjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:39:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9522C061574;
        Mon, 26 Apr 2021 06:38:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso5327254pjn.0;
        Mon, 26 Apr 2021 06:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6BA3bzR3xgCgttcDOM4HB5ATaqy4xRVcX1skX89C1tg=;
        b=r0orE5Dmd6xs+cvP5uhd9uAMuwjIUwpeKt/Rbe/2F8f5zdUyyowuhsQNUozQ4e7A8D
         FKl7kGfbmfoGjqQCc29+xa22ftvMRZr20Afui/L11w/XC1CAxSWE2nbgsGfWRVtvUTJg
         19tLyG3YetkEY0hd2TnwGB0Wr2Ax5oRzENURxfWFXDlCbdRu74Z+JBM5BXIMhhiPtZbN
         Owd6yS9efEnWgVJjHCGMUbVvzf2hnHgOlArFcQvNLmsSEJy+X5Y5jYtxMGoIi+nf0pD4
         kbPk/vcrXd8JjGddec1A3j0mZMFFwQeck0rIKjTZ/dXOhMkyjbvN3khonFaC3koKBYCa
         oQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6BA3bzR3xgCgttcDOM4HB5ATaqy4xRVcX1skX89C1tg=;
        b=jjAXBMyTexnd04DsrYcCpvDMgwVfUGEky4AE9WS71OLRla/PWnbYy5vq9NBIf7CK3y
         +guEXeINli8HQ8p1Qq2S6dlWpiVcDIOzO1BAykxl13k0Lms/X9ppnLYjjeuJI7d6RW7E
         Z9mWdCLXOzg3LLt69v4q2kYYwCj+ErPAiPWarHgp/ougc1kyFytUC1tFaFAmgowfkygz
         d+z8e/pY2uiYtELQsNOBRHxE70bTou4/yf7SDEQ6p+c6ZvYRcUry77iC7H59inU+HKZO
         Uz/AcHR8X3hjJv/p2OOLNl+D/fUOonFdbtX0M4J3N0R5ZCFV8K3UgVngH7JKmr4M1t1/
         ildw==
X-Gm-Message-State: AOAM531adWk32AMMJ9FrwKQBT39IFXYxnclAhkR38z1FX03kodDpQk4o
        iKdGk4V93gVtYyEDgNW5xCg=
X-Google-Smtp-Source: ABdhPJwwNvQ1kHrtUqbTFiR7NQTLzJI1fV0oh1o80FBJD0v/FiW1lAU7ut12s9m+//LAAQX2Julj2g==
X-Received: by 2002:a17:902:e851:b029:eb:1fd0:fa8e with SMTP id t17-20020a170902e851b02900eb1fd0fa8emr19091530plg.38.1619444330258;
        Mon, 26 Apr 2021 06:38:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t1sm12244834pjo.33.2021.04.26.06.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 06:38:49 -0700 (PDT)
Date:   Mon, 26 Apr 2021 06:38:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Message-ID: <20210426133846.GA22518@hoboy.vegasvil.org>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426093802.38652-4-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 05:37:58PM +0800, Yangbo Lu wrote:
> @@ -624,7 +623,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	dev_sw_netstats_tx_add(dev, 1, skb->len);
>  
> -	DSA_SKB_CB(skb)->clone = NULL;
> +	memset(skb->cb, 0, 48);

Replace hard coded 48 with sizeof() please.

Thanks,
Richard
