Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402BE51C0BC
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiEENeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379529AbiEENeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:34:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F59B7D9;
        Thu,  5 May 2022 06:30:38 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a21so5234038edb.1;
        Thu, 05 May 2022 06:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=LEyhSb4KLLHDvo9x+lHGafva3P7wuUyOsl0RpBl3TYY=;
        b=erloLqL3L1Z5rKgWGi4x265WiJi7qZEJLqO8bCzSE2d4j++qzExi65405a1CWA8eOF
         /tuO4stZhJCz4LgMWaweViYv4mbdAhIA9TVAfY9EvDuTb+QABNmIP9dS2da456z1ikc/
         vI/QBWiPprwIxazaUWrFJLU8MpQ4vTlDlJK2bsf2jjZ4B7DSFFjagZ56gTH7g06akm07
         Yo8ZPTDQ3ZSw856iCNFu9yd3y9sIDJY3DtGvj5TmOKIxtGTdl23i9LIGGzlG7TroyxLJ
         eoR+jrykBs7MqoK6pTyjsmHb1VRdDJrFWCuOj7nov6KTYsXw7PAk+darzy5Lz3OPe5wi
         hWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=LEyhSb4KLLHDvo9x+lHGafva3P7wuUyOsl0RpBl3TYY=;
        b=EvPJj2H8KxmPHIbZM3R6K3X1tPcUwqLz0vHaQJQyoin3bYQSH0EmxIx/zCocnCWbDZ
         ahB/WmAjQ+huOxH3eUyxVPp/r0umnAtFWU8DsDPF2I0/1Pk/ln4Chd7+QDY1NV0PLqee
         9oDEKUpzp+1z9FzHa/v8Tgdiz8c6zPTeAuiB9vKemQnEUnQ6YUYQbgc9/IiHzgEYEg9q
         0U2vOwUdAgnsSUahERpSP1IdsIynrVT53PyAGwP2ilV9HhwjFBtWcaxTtV4iJXR2PF+0
         vW0M4oPuEyBvufFFveuWqIWePocaiqrLqkVlleOPq3jitIzlb74hkmMTnzraKadP87A0
         BUmQ==
X-Gm-Message-State: AOAM531zONSQDU/ELrU1/DvaEL+RanGifX49TDOY2mZq5oBzTCVNzewP
        TDi6a/Kz/iyth/dumvTgWGI=
X-Google-Smtp-Source: ABdhPJzLBZeGQSoC4QxkDn6W8OqQ2KRQfFIE+hPKggNvQz9ecywyyuj4wg8kdTVlJk79vAMxJ2B0QA==
X-Received: by 2002:a50:ce14:0:b0:425:cb75:5322 with SMTP id y20-20020a50ce14000000b00425cb755322mr30882298edi.386.1651757433754;
        Thu, 05 May 2022 06:30:33 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id qz24-20020a170907681800b006f4cb79d9a8sm766846ejc.75.2022.05.05.06.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:30:33 -0700 (PDT)
Message-ID: <6273d179.1c69fb81.7c36a.435b@mx.google.com>
X-Google-Original-Message-ID: <YnPRd5865LV21/Bw@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:30:31 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 09/11] leds: trigger: netdev: add additional
 hardware only triggers
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-10-ansuelsmth@gmail.com>
 <YnModmKCG3BD5nvd@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnModmKCG3BD5nvd@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:29:26AM +0200, Andrew Lunn wrote:
> On Tue, May 03, 2022 at 05:16:31PM +0200, Ansuel Smith wrote:
> > Add additional hardware only triggers commonly supported by switch LEDs.
> > 
> > Additional modes:
> > link_10: LED on with link up AND speed 10mbps
> > link_100: LED on with link up AND speed 100mbps
> > link_1000: LED on with link up AND speed 1000mbps
> > half_duplex: LED on with link up AND half_duplex mode
> > full_duplex: LED on with link up AND full duplex mode
> > 
> > Additional blink interval modes:
> > blink_2hz: LED blink on any even at 2Hz (250ms)
> > blink_4hz: LED blink on any even at 4Hz (125ms)
> > blink_8hz: LED blink on any even at 8Hz (62ms)
> 
> I would suggest separating blink intervals into a patch of their own,
> because they are orthogonal to the other modes. Most PHYs are not
> going to support them, or they have to be the same across all LEDs, or
> don't for example make sense with duplex etc. We need to first
> concentrate on the basics, get that correct. Then we can add nice to
> have features like this.
> 
>      Andrew

Okok will just drop this. I agree that adds additional complexity to the
code and would make this even harder to merge.

-- 
	Ansuel
