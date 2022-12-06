Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2109C644C1C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiLFS6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiLFS6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:58:05 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA0D27FD1;
        Tue,  6 Dec 2022 10:58:00 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l11so21662713edb.4;
        Tue, 06 Dec 2022 10:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vP4yoAxZQe7lGtKIEBGWB6ey+WQkOJMp8NlEiVTIdQo=;
        b=mnsLAHIXTDa8QW7ak5ihzA0ZKHqUEkAUeE2IKUWFSQG+gFp1fqO/BX+xRhibxjJ1oj
         YKn0KfL8IQJ3jujI/H65co/xzjFMMCnyr5jil7bJVydJ3lth9pcX17j9jDJYHMI0+DmP
         vI3F2wjIIJKnDDMkybFoNv+zAX8C5OdvFcQu2LCMV2sx3Jrjb4wBOmmTAXw38cI4WPTD
         tnjHOpmFwcQCvqGDLAnFEuE0TBSfWMrmoPGjT0/37/TL3G/RYms/0/cwc3iRNMrIbvK9
         bG8/crp6KUKl5AC4o/5y1VES8UsAOhsO3ZoNfrpNv9wUwYhEOyNyhQqFKvVhlOX92kql
         z7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vP4yoAxZQe7lGtKIEBGWB6ey+WQkOJMp8NlEiVTIdQo=;
        b=cISzJOWg9sj+8GggkKUtGSCPtsYm+i79kM3i4PZrtEqhOQn9RwdLfsXCDqlV6tjKRn
         willZtVxaeRsgyWH4ZuBeKlhOZ77yxDN7yUZGwUp+lo5DKxpBF9vqmS3pdVLWqkW1B0s
         Pmx16CrfXt1AYY5chfBk7rNCONCVRU69Q4oINkSGojLFThVrDh4sqDvxr4eWI3sFCUKe
         Ys39JVriT3zkKcCAeTycJGaFlcb3qjHDpb4KzBGtqlwx7exgSLutwRRv5gWfnh4P/G0v
         jUPOje2BkH40X5WHQVz7zLfVazLiQv+UfCXjZ5vzhRByzeGGZftOa4D62HiPlOo+1vP+
         GEFA==
X-Gm-Message-State: ANoB5pnUYDS4FewEpTodo/uE0wQ5NWGtmzXZk57Q7IgVtXtZBTUd8gGC
        ZBamPj4vAm4bpDcfodXlV4Q=
X-Google-Smtp-Source: AA0mqf5YrKa9iLqYiddlN8Pr+CwuJU4bCYvtxl4Cb8IAu5rhWscsq3txMeMBABh//BIjpG4vmcpXFw==
X-Received: by 2002:a50:ff04:0:b0:46b:19aa:cfc4 with SMTP id a4-20020a50ff04000000b0046b19aacfc4mr37143179edu.384.1670353079231;
        Tue, 06 Dec 2022 10:57:59 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id du1-20020a17090772c100b007c07909eb9asm7680508ejc.1.2022.12.06.10.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:57:58 -0800 (PST)
Date:   Tue, 6 Dec 2022 20:57:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 0/2] dsa: lan9303: Move to PHYLINK
Message-ID: <20221206185756.hfecpkcy2lqahng7@skbuf>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206183500.6898-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 12:34:58PM -0600, Jerry Ray wrote:
> This patch series moves the lan9303 driver to use the phylink
> api away from phylib.
> 
> 1) adds port_max_mtu api support.
> 2) Replace .adjust_link with .phylink_get_caps dsa api

What does the max MTU have to do with phylink? What is it that makes
these two patches related?

> 
> Clearing the Turbo Mode bit previously done in the adjust_link
> API is moved to the driver initialization immediately following
> the successful detection of a LAN93xx device.  It is forced to a
> disabled state and never enabled.
> 
> At this point, I do not see anything this driver needs from the other
> phylink APIs.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>

You don't need to put your sign off on the cover letter.
