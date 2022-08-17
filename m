Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D7059707D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbiHQOFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbiHQOEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:04:52 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFB066A71;
        Wed, 17 Aug 2022 07:04:11 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gb36so24667544ejc.10;
        Wed, 17 Aug 2022 07:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=mVA/ftXBTRCBqAVa0b4WI+Q+4R86Al02EQrIzwFas0I=;
        b=H1AdnNX81zvb6+L8fW//LUTu29uCpX5rrHVQnNIjXBnoNObrjbsS/BFGBBweZ4ECBj
         M8bP0rAmYtgGiu4WEbiutnmtaTcRtAUVFGVdFAmyWTW2vLCoSeYRFRg+VDn5eEg9/j7G
         dFmJxLI+rcH8IJVzvXgFLEOOVd4SsaXzNeDBylxew5RM4DqZkVmrruaImlXZLiXgXGh3
         7HbUVn2s/xOGaWZ6D4FZRs5qlDAbpuO9Ul2QZO8y+rrnDl10HOBdoCRXWqq8by95P4mB
         h5v+VxAayq1wcO4X5uXvuJbK414v0QNF8+FMgYDMRWY6CxuCiOOnSp/gJr9nWmGNcVIf
         J0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=mVA/ftXBTRCBqAVa0b4WI+Q+4R86Al02EQrIzwFas0I=;
        b=kDqXNZ7AA1Z3MFEXKPk92zY1zeeciyUpeCqEoshppSel36toQbqZh9rvijd58ISTr2
         mKPolgEdA01seiJ9NLQkH9fLeK3Kg2oE2gy7tkUa/7xivEmCQ8fs6p6GlEq9y7VDe1Bj
         L8rZl6qYRM8v87vcU2nTqGGQHMbZZajn9pt8L1QW+sIqM378cITJuQ8C4z999yDwfXSz
         hPSw1uPJOZK+OKlnqVZTLNo2RAU9FF+HZ9qYTOWXGlBzeDyK9J3+CCTYiDJiuvNJeBkm
         l8aDYLzMidJlgZoY9d+MsMVMgc1L8hI5nnD0CT+DmFwR5TturArxSac8OR4wDzg3uWz2
         Vbpw==
X-Gm-Message-State: ACgBeo0B7S/YqhWW4ax8qV4NvatAqvt94RF9HduqhuWp+H62aV4l/oOc
        k4ct3SshsU3fPzluQnm87Bo=
X-Google-Smtp-Source: AA6agR4Gr1kT8N8Cpa3HrWj57nzy+YqMeq/pGIXlwFucDMek9b8qasF3juwXGravWpuNfEajv5OWeQ==
X-Received: by 2002:a17:907:3ea9:b0:738:dac0:371e with SMTP id hs41-20020a1709073ea900b00738dac0371emr4953803ejc.455.1660745049633;
        Wed, 17 Aug 2022 07:04:09 -0700 (PDT)
Received: from skbuf ([188.26.184.170])
        by smtp.gmail.com with ESMTPSA id e6-20020a1709061e8600b006fec4ee28d0sm6678060ejj.189.2022.08.17.07.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:04:08 -0700 (PDT)
Date:   Wed, 17 Aug 2022 17:04:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, craig@mcqueen.id.au,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: Bug 216320 - KSZ8794 operation broken
Message-ID: <20220817140406.jqv72rkpro5gmgvu@skbuf>
References: <967ef480-2fac-9724-61c7-2d5e69c26ec3@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <967ef480-2fac-9724-61c7-2d5e69c26ec3@leemhuis.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 03:36:44PM +0200, Thorsten Leemhuis wrote:
> I noticed a regression report in bugzilla.kernel.org that afaics nobody
> acted upon since it was reported. That's why I decided to forward it by
> mail to those that afaics should handle this.

Thanks. I don't track bugzilla, but I will respond to this ticket.
Is there a way to get automatically notified of DSA related issues?
