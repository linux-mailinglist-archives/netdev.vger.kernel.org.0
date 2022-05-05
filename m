Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC5751C299
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380664AbiEEOeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380716AbiEEOeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:34:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FCA101EE;
        Thu,  5 May 2022 07:30:34 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id z2so7513695ejj.3;
        Thu, 05 May 2022 07:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uPRFuYIOzOX+lfHSk0TAnDa37PyGEjlIVUZQBvDYK1w=;
        b=Ms9X8X7IdWm5uZCCq9ScGLgW/sXkqzuQt2MfNvGCiSUdy3p1lmn/MQbFiO9gmHa4l5
         SisY3i4Tnyif2yoKWa2WiCMUkEzJbVgp1xQN5CNGnuu0DG72B/S5X4+cqBg5ZzNFBI46
         +KOpXVb50bBGy2bXxdsH/KdSPtoQW9d0hKi7dqah4HYBemjgMXT1+8mgOZfEHDiAYQTj
         788BxS6V3RIr8akFPjMSeRasMYTWAOfMCBH2tamxmzbyA2CCzHQ1rAwJWmtmE2Urfxi9
         hODTnyoCuYr0su4GNyEX6kBsTk/R7WmfF9k5DE1I6PRYGokbU+fSQseIw/uUqg3Y4So0
         HBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uPRFuYIOzOX+lfHSk0TAnDa37PyGEjlIVUZQBvDYK1w=;
        b=HqTfpE5AOOhcb/aInSfzu6dl+xsDVzA7F8ECoeruD93LbZGW0BubJOOtzlnZrShun7
         YFP7SvaZ21a0Y+ZojtU49Fj8YfcghqrOpp5DWlfHXkX1sRiUKUQ8RgM4mA02yQ3PgJf1
         aLB0SYZ1EmCJRNWzqQGqqFrf7F8zoAJiZrDM/ZP5IoU4eIzVmUpE/WVWb+wQe2eolRRk
         wXcafGLfGuRZsX1G+5em+ypuU2VYAg2CEiGJJWVz/ARpAcLyCt+aD7VTCRfeUTY1UYaT
         mzUwni3wOFNZ1ZwUfJ/BFwZBfIVqmVGznq15WtZ3LNcbNDZWJWXiZKebj/YdSQvenV0b
         LGlw==
X-Gm-Message-State: AOAM531p21hV/MKrhg9M+fjMotm/CHtYHqkhFwRn1M5bx1O67ldps6l5
        B5ecVc6yYamTe3Emne6atW0=
X-Google-Smtp-Source: ABdhPJyPihA5bLvhSw6UjJz5kS4lcJeRXQCszddNar6sz3CWTvzELecqGlLzWWo3/pL8xJfE3F+E5w==
X-Received: by 2002:a17:907:a0c9:b0:6f4:bbdf:8081 with SMTP id hw9-20020a170907a0c900b006f4bbdf8081mr9156501ejc.257.1651761032841;
        Thu, 05 May 2022 07:30:32 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id b18-20020aa7dc12000000b0042617ba63acsm918452edu.54.2022.05.05.07.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:30:32 -0700 (PDT)
Message-ID: <6273df88.1c69fb81.1757e.5347@mx.google.com>
X-Google-Original-Message-ID: <YnPfhlqqNkxWMwU5@Ansuel-xps.>
Date:   Thu, 5 May 2022 16:30:30 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH RESEND 0/5] dt-bindings: support Ethernet devices as LED
 triggers
References: <20220505135512.3486-1-zajec5@gmail.com>
 <6273d900.1c69fb81.fbc61.4680@mx.google.com>
 <b9ef7ce4-2a9d-9ecb-0aee-3f671c25d13f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9ef7ce4-2a9d-9ecb-0aee-3f671c25d13f@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 04:21:33PM +0200, Rafał Miłecki wrote:
> On 5.05.2022 16:02, Ansuel Smith wrote:
> > On Thu, May 05, 2022 at 03:55:07PM +0200, Rafał Miłecki wrote:
> > > From: Rafał Miłecki <rafal@milecki.pl>
> > > 
> > > Some LEDs are designed to represent a state of another device. That may
> > > be USB port, Ethernet interface, CPU, hard drive and more.
> > > 
> > > We already have support for LEDs that are designed to indicate USB port
> > > (e.g. light on when USB device gets connected). There is DT binding for
> > > that and Linux implementation in USB trigger.
> > > 
> > > This patchset adds support for describing LEDs that should react to
> > > Ethernet interface status. That is commonly used in routers. They often
> > > have LED to display state and activity of selected physical port. It's
> > > also common to have multiple LEDs, each reacting to a specific link
> > > speed.
> > > 
> > 
> > I notice this is specific to ethernet speed... I wonder if we should
> > expand this also to other thing like duplex state or even rx/tx.
> 
> I didn't see any router with separated Rx/Tx LEDs, but it still sounds
> like a valid case.
>

Not a normal configuration but it's doable. For qca8k you can really set
the led to do whatever you want.

> We could add flags for that in proposed field like:
> trigger-sources = <&port (SPEED_1000 | LINK | TX)>;
> 
> Or add separated field for non-speed flags like:
> trigger-sources = <&port SPEED_1000 (LINK | TX)>;
> 
> Let's see what DT experts say about it.

-- 
	Ansuel
