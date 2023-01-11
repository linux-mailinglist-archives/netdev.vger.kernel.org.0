Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503466665F5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 23:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbjAKWEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 17:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjAKWEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 17:04:48 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E8562D8;
        Wed, 11 Jan 2023 14:04:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fy8so40248070ejc.13;
        Wed, 11 Jan 2023 14:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T1dXRDRPPx3RSo9jZ102bsVIy4ioIH6GmEeAyxARso4=;
        b=ejx8GFwrl5rqAft/O2RXK/RL3OpyKy8u6db6ZuMEZsh46AKvvCjLc2QipypDU2OtEe
         H190jIOUHN/PJnXoyRNwCQyQaC2sSy+wvilTvGCFB+l7+VjDnWjUgWxZpgb/er3MJDTZ
         UhzQYlT7P5i3Lcx504BnPvgokdfQbu6vhPRYt+9RMyvKQBq57anV68VDajLaopCd+5ML
         1fySatG4lKZL6Ubi1AAiZ+7FZRsYPwCMzBXB8oNJcIc7b45+0CwwU9RcCxv3e1oAx+7D
         EvBHskM4QTi5bhmhJ3BawgAQ6+iOKQuXzeBw/JsQ4zJDQCj2ZiCDvNcRfZk6Zefw+QF5
         X4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1dXRDRPPx3RSo9jZ102bsVIy4ioIH6GmEeAyxARso4=;
        b=669+YZU8yzY4FumSgps5qmMmcD3pfAPt6B/OLjJ3QozHVho15L7MkEUtE9dqwYkwCk
         VxysL7YGAA+KYxE3BKzrjRRwnFfrSoULdmoWaDbTRiNbdxC18cOxXBMmnFPX86SilNFG
         jrRRAXeLi952Sh4sGyFFhrjQlh/M3kPR2YrMLAsi+Mu1avUNY0xcup3yR7G8rd8AC2W9
         9vWWSXPA1cWmVH45pzImX4igkEymdDNVVPMghHobx0csuIu/veDhNWb1kcb4+xgVzqVQ
         m+4HFX9xG83bKa0HJM8j7nw2/oOZOfVAu5LVDEYETcVGxUwg5w0x0JzOgUd79W5BtSvi
         vJVQ==
X-Gm-Message-State: AFqh2kpTSnEbAjhngbLP1Otf1UFXoHzy6ruMtwdvXl3Xa0behMO1UsiL
        HdYehZcElRuXfuFDgbJmzRw=
X-Google-Smtp-Source: AMrXdXupw10V6/JOE/zO66L/Qs5NRfT3z2C5LZ6xsFGcUQI70K5j0wgHzMMXsL1gIEUS6/9VLDcDCQ==
X-Received: by 2002:a17:906:9f07:b0:7ec:27d7:1838 with SMTP id fy7-20020a1709069f0700b007ec27d71838mr79039390ejc.22.1673474685661;
        Wed, 11 Jan 2023 14:04:45 -0800 (PST)
Received: from skbuf ([188.25.255.127])
        by smtp.gmail.com with ESMTPSA id mb9-20020a170906eb0900b0084d34eec68esm5675635ejb.213.2023.01.11.14.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 14:04:45 -0800 (PST)
Date:   Thu, 12 Jan 2023 00:04:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/6] dsa: lan9303: align dsa_switch_ops
 members
Message-ID: <20230111220442.ztrll45sr2lvsgpi@skbuf>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-2-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109211849.32530-2-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 03:18:44PM -0600, Jerry Ray wrote:
> Whitespace preparatory patch, making the dsa_switch_ops table consistent.
> No code is added or removed.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
