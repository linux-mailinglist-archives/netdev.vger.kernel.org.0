Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BEE62FB6D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbiKRRRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiKRRQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:16:49 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D6913D4A;
        Fri, 18 Nov 2022 09:16:48 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bj12so14518056ejb.13;
        Fri, 18 Nov 2022 09:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f50cXlhSl5OKrL1veymKT19+b2RPjsREkRB5uQP4LcA=;
        b=QWjssaTSe3zToxs7F5fKzajzmgz8VhcvKDm0hRrHuwiXrD1YwxCIGmQUFznFn6cWdc
         LAWbgCMKKLIkUlcG4y4d9y6zpjXISYczomA9Srn7ihvFeBiBmHeO3rpJf9oRGLQoxDtS
         2NSKw+j7omgw+IA6KOZpuvr3wJyKxyO5OcOyOg9yCzzrggw6hXGH3Y4jhWwd/hnviHYY
         ppCxqMujBu5zZsAaDL2GxX2Mphe3S6m1eDvxiQdbUjwECdbParRgy+H1o5TcYa3oPZdD
         KYxRJiES2RE3FwiD2bxPHDsLCojI6qRKiPcMqc7YzA1cwKwW8egTGq6ISxcRWlv8PlW2
         FJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f50cXlhSl5OKrL1veymKT19+b2RPjsREkRB5uQP4LcA=;
        b=1H9qnhq976MHBJuOZU8z2pp6Ddbll9+leiF+BnEuTritrfjJ/D1mQvsfMhteaThyXK
         4SdxBOP82IV/HzcZhvFzFVBqKlKWrtm1tQj42hUaKFAWTWEAX6/WoVp+eg/W+/Gpxfvk
         7ASsynRLHiqlMnCxtvVrEbc+ThlzVd5/PTi5n+uuae1CW9YWb+n2bhrrl4j6gTk3Lc32
         l074qPXiKO39kqZ9iyLDpYVSImw5WbI7mOPUM6+aCF3B/PmvAD0zl0g7xVsZuQhKOutr
         jqLyw18QVpiRwgOiitjmQ+1SufhLow2yo9xmEFLydM/wFxF1enwzB9Rrf8Kr9i7coXeV
         uGXQ==
X-Gm-Message-State: ANoB5pnLMkh1tqfgl64LUWEswzVeTUfouTFEEYTxg5hcLq9c4ChYVAUV
        PnlNYRUkMVywpzH9/u5wQmE=
X-Google-Smtp-Source: AA0mqf55zNNnFg4E/G89nnnEUNEODkzsqNbeeOGil51xumuQsyZ9Cr4hsH00FdIYZW/GQxpu7lr2eg==
X-Received: by 2002:a17:906:f88:b0:78d:ff14:63f9 with SMTP id q8-20020a1709060f8800b0078dff1463f9mr6677725ejj.516.1668791806361;
        Fri, 18 Nov 2022 09:16:46 -0800 (PST)
Received: from skbuf ([188.27.185.168])
        by smtp.gmail.com with ESMTPSA id r9-20020a1709060d4900b007ae243c3f05sm1900342ejh.189.2022.11.18.09.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:16:46 -0800 (PST)
Date:   Fri, 18 Nov 2022 19:16:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Message-ID: <20221118171643.vu6uxbnmog4sna65@skbuf>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
 <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
 <Y3bLlUk1wxzAqKmj@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3bLlUk1wxzAqKmj@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 01:02:29AM +0100, Andrew Lunn wrote:
> > Well, part of my goal in sending out this patch is to get some feedback
> > on the right thing to do here. As I see it, there are three ways of
> > configuring this phy:
> > 
> > - Always rate adapt to whatever the initial phy interface mode is
> > - Switch phy interfaces depending on the link speed
> > - Do whatever the firmware sets up
> 
> My understanding of the aQuantia firmware is that it is split into two
> parts. The first is the actual firmware that runs on the PHY. The
> second is provisioning, which seems to be a bunch of instructions to
> put value X in register Y. It seems like aQuantia, now Marvell, give
> different provisioning to different customers.
> 
> What this means is, you cannot really trust any register contains what
> you want, that your devices does the same as somebody elses' device in
> its reset state.
> 
> So i would say, "Do whatever the firmware sets up" is the worst
> choice. Assume nothing, set every register which is important to the
> correct value.

If "do whatever the firmware sets up" is the worst choice, it means you
think it's worse than "doing whatever the firmware sets up, except a few
fixups here and there which worked on my board". Whereas I think _that's_
actually even worse.

What might be an even bigger offence than giving different provisioning
to different customers is giving different documentation to different
customers. In the Aquantia Register Specification for Gen4 PHYs given
to NXP, the SerDes mode field in register 1E.31C cannot even _take_ the
value of 6. They're all documented only from 0 to 5. I only learned that
6 (XFI/2) was a thing from the discussion between Sean and Tim.
