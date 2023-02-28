Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DEC6A610B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjB1VMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjB1VME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:12:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305573645B
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:11:43 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id i3so11869622plg.6
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677618701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cFP0htlkJzLE3hJ3isyi4ivODWnmwstLPr/TGzbgO9A=;
        b=N9lF0mUFm9MluKEh/UhRvC60juFm9lZG+SOya1YDeKTUdCQhrMFF4+xnYEPo+8196V
         vEa5mopTkX/umz3phnYRDqHpkJtSEX5zWSd8V1BhUYjKIyU2sZY9CyapBHWdzPC/ixqi
         EtTsgFh+8chHLk6wmZ1QtjF6O8Dc1AJR+rlvh8MTrti927oRlHq3Tif3RfjjtWXi9iOH
         EpZgdbYD1qTDmpuLgOW5VYU9bBx0fQNMzFDnPO1Hljxi6l9QqvkE8IS3MMtN7ni/ZAbc
         UuYTDhdJjPenKrRn/haFzstY0G+oG+76TnXSlVbOoxHSu+BtT3fNG2h5IQlvziPevISL
         co3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677618701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFP0htlkJzLE3hJ3isyi4ivODWnmwstLPr/TGzbgO9A=;
        b=TQjikW2/o4zvA+LeXEXFWuHX69t2KL19sojB0o4DNdV9eqUJtcWCS43MO45GFGzWRn
         Z6gjUE4Pn83TZiRtYLL1KA6y3sj0AkUjj9sakEmoHISAa60QD/6yYqqY9CNF5zUUIIoE
         Kece5f5BCcX9pG6DBWCrYvoRMHGIplRUF0RJs4aoG2nxuiWlDCE0w3H4iM3MF7bmLmzv
         4Eq2FTdZp7Q1z7hiXhzBuNciC1wcR5eIUy9r6X3pagu4HMySQxq1ZWM67SgOIUpSVBTs
         Aj/fF2cgQ2PxRlp4fzXUnrGMxNUiCzRemyhS+3Fx8MnKd8Z2XoLgmJno9LXEApFx/Aeb
         diYA==
X-Gm-Message-State: AO0yUKXHXqNc4dyb9f9xAKS6At58wJSIWUJitghUgG/0tTLbwGwFpxr3
        AIpz5nTSUZ/rOX12KfVOuzs=
X-Google-Smtp-Source: AK7set/CD8yoPH5+fygFnaiIQH/6SauHGC6oZIceOrnDpccbJMYmNyZr8wbSlBtU+b7taiYpKRSU3g==
X-Received: by 2002:a05:6a20:8f06:b0:cb:7cc4:3ddb with SMTP id b6-20020a056a208f0600b000cb7cc43ddbmr5392517pzk.3.1677618700721;
        Tue, 28 Feb 2023 13:11:40 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g17-20020aa78751000000b0058837da69edsm6455745pfo.128.2023.02.28.13.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 13:11:40 -0800 (PST)
Date:   Tue, 28 Feb 2023 13:11:36 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/5uCFXZb4mBYroS@hoboy.vegasvil.org>
References: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228164435.133881-1-michael@walle.cc>
 <Y/4yymy8ZBlMrjDG@shell.armlinux.org.uk>
 <a7d0a9c31e86441b836baf3b5cd7804d@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7d0a9c31e86441b836baf3b5cd7804d@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 09:13:57PM +0100, Michael Walle wrote:

> All I'm trying to say, is there might also be some board constraints so
> the MAC driver might not always be telling what is best, PHY or MAC.

+1

I can't see how the MAC, in general, could possibly determine whether
it should be preferred.

Thanks,
Richard
