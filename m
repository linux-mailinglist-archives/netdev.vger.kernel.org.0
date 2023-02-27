Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB98C6A4C25
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjB0UT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjB0UT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:19:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63068222EC
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 12:19:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so7352515pja.5
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 12:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677529166;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3yi9V/aldemhDRvf4iBeakjiLCAhyOzdhspNuaHZSJ8=;
        b=DKJo2vJXjXE/AEVLDcWwrOaZh38caDm0Z6n8fGDRRvcicmDDLDalmoydSTynahpj73
         ZSVV90g7pKX3N9//dMMBKeTurAqBxezWNaDrzUto79NBWcelVDheuygxo1Z/TVlblEaW
         mOP19n2Q+8FGDpdIUhRpWgDMfqE3JsbaENnwVoUSOPVwonDzz8SlVsmCaQLaHgsgDU+G
         XsVgRhPqaoURdt8JgtIj2KXnyrWWOiY1i/CJIlIWMdRPqcxjZXWJor831/cejeZT5Soe
         Zi7qwjZyyvlK8HRW0YiRxGAguVQy2lO/0cAtrIf9mh0oFt6sKeVlx2Rh4NSRLydEL+1q
         wL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677529166;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yi9V/aldemhDRvf4iBeakjiLCAhyOzdhspNuaHZSJ8=;
        b=tZyoFIAXa8vCj6SaxldQ9V2aM33UcV4SznSqfEp/BVOyFR3cEy2QS7PILspCMLR+ym
         vW/nKOEMXqNfeD6F1zO96ObQ4AyYXQsehk0LWae0llbBmp7XTk7PoPJCUo+4DiT6m/Il
         xEPCHn7q5jYhuI0QMJfbBmlsD3MEWR/1uFa4phXJpLPN/Yk/EkIYvV7CWgU0VOGJwJyh
         tTE0EkIsmFHauR23nwcqJmE7MvoBdb9RG4/O0qr23ROnaH7E9NBtwAxPWmd0DivbxdHG
         DF//5/3aa9XScePh3KdTttfRoqMgYOgkXJIzXNhKZopfSF5wONDhxmQ0q/RuEkznN1xc
         knxg==
X-Gm-Message-State: AO0yUKXbHq0yZR3DVp+isdowAeMujwGhBuPuM32hlewRAmsLQdkMxOYr
        R7Op+ea6G4pGYlqriKCp5FI=
X-Google-Smtp-Source: AK7set8N0W3shIWKeFquSdn5QywZqrh3HwZCwBIwQq3a4V6qiT+XgIecqln7ZO3+iUNHheKTxenl3Q==
X-Received: by 2002:a17:902:d2cf:b0:19a:a815:2853 with SMTP id n15-20020a170902d2cf00b0019aa8152853mr237610plc.1.1677529165877;
        Mon, 27 Feb 2023 12:19:25 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d90400b00198ac2769aesm4974884plz.135.2023.02.27.12.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 12:19:25 -0800 (PST)
Date:   Mon, 27 Feb 2023 12:19:22 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:09:05PM +0000, Russell King (Oracle) wrote:

> Looking at that link, I'm only seeing that message, with none of
> the patches nor the discussion. Digging back in my mailbox, I
> find that the patches weren't threaded to the cover message, which
> makes it quite difficult to go back and review the discussion.

Sorry about that.  By accident I omitted --thread=shallow that time.

> Looking back briefly at the discussion on patch 3, was the reason
> this approach died due to the request to have something more flexible,
> supporting multiple hardware timestamps per packet?

I still think the approach will work, but I guess I got distracted
with other stuff and forgot about it.

The "multiple hardware timestamps per packet" is a nice idea, but it
would require a new user API, and so selectable MAC/PHY on the
existing API is still needed.

Thanks,
Richard
