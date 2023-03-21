Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6D06C3EAF
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 00:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCUXj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 19:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCUXjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 19:39:54 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E65C15577;
        Tue, 21 Mar 2023 16:39:53 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so12010583wmb.2;
        Tue, 21 Mar 2023 16:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679441991;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jwfMZ6FsDD8+QlFgG9YSGQ+zSUs+XYTprVxYaYY4xCs=;
        b=bkBHelgXJwSgw9NZ5DcQ/rAeODyT2QbCZQWqLR3yhQe7qk2WtbX3WlX//JoMlB0gX0
         lfalGUbwfgFGT4ELFVIjA759O+kKuqGQtJS87Vk0JPkszPWrW7TnHebl6ei2+oorMVhd
         Lc98meTC4oaHoutzsVkMwR95MIwhSE9MwDhFyknkqQPJcwG7O5IR8GeQyHr9MTD/9SGU
         pxFGpcTlofPElg4Phc7kkGzdUqKwVaBFHVxGp3tGJeLa84o6nDOEeypP1oikHYn+q7wR
         Jrtu2GEePEQfegjd54V3W5o2sm98uxNpYUTvOBLoOV3Ny09R0J74nwQSogF+VMIzc3FY
         26XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679441991;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwfMZ6FsDD8+QlFgG9YSGQ+zSUs+XYTprVxYaYY4xCs=;
        b=xdDlQYoYZbOFfBaeXuHW4Q0P7xijQqOvRMo5wz+k2uewxT6rAUnWVSqDJjjhFIZEQv
         Ug3VLLvPYGFFQPZFcyvCmg9By9CGFMDlknDjbG8t5vqQcTft5VbzPaf5CF9W9tygQwH5
         SNpZHKl/gowqMKYyX4hUB6+nxqgMKqIEUMDOVDFuzxGzgcj8tzJ3kwy65th4BuuEBTcS
         Bcv351atxgu+vbsg+7SGMjGEeT78bGlL7dxO6rIyASz0RBruguR7b1iZxMTPDBXEfVbs
         pdzmwdMn2R3VgWax83dZJfUAUD3JQmoHcna9HFmv5VEMxWN+4e4pTOLv+yU+6/EeHOlN
         NIQQ==
X-Gm-Message-State: AO0yUKVDH14GiAixz7VZU5qKeYcvef3a9rfx0Qp/3aYWgJ/0C5JN4GoO
        KSJJi0MLA37z5VBHoawey74=
X-Google-Smtp-Source: AK7set/s45oboY6J1DqDB/0FL+87KkEyElGWJ9yuDvg1P5AEXq8dYBcKJ3L/B1aVpUVe1ob2ikoHEg==
X-Received: by 2002:a7b:c7c4:0:b0:3ea:ed4d:38f6 with SMTP id z4-20020a7bc7c4000000b003eaed4d38f6mr3681988wmk.4.1679441991057;
        Tue, 21 Mar 2023 16:39:51 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id l15-20020a7bc44f000000b003edef091b17sm7840916wmi.37.2023.03.21.16.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:39:50 -0700 (PDT)
Message-ID: <641a4046.7b0a0220.44d4e.95d4@mx.google.com>
X-Google-Original-Message-ID: <ZBpARKRa7Hcg0crS@Ansuel-xps.>
Date:   Wed, 22 Mar 2023 00:39:48 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 10/15] dt-bindings: net: ethernet-controller:
 Document support for LEDs node
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-11-ansuelsmth@gmail.com>
 <20230321211953.GA1544549-robh@kernel.org>
 <641a35b8.1c0a0220.25419.2b4d@mx.google.com>
 <38534a25-4bb3-4371-b80b-abfc259de781@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38534a25-4bb3-4371-b80b-abfc259de781@lunn.ch>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 12:23:59AM +0100, Andrew Lunn wrote:
> > > Are specific ethernet controllers allowed to add their own properties in 
> > > led nodes? If so, this doesn't work. As-is, this allows any other 
> > > properties. You need 'unevaluatedProperties: false' here to prevent 
> > > that. But then no one can add properties. If you want to support that, 
> > > then you need this to be a separate schema that devices can optionally 
> > > include if they don't extend the properties, and then devices that 
> > > extend the binding would essentially have the above with:
> > > 
> > > $ref: /schemas/leds/common.yaml#
> > > unevaluatedProperties: false
> > > properties:
> > >   a-custom-device-prop: ...
> > > 
> > > 
> > > If you wanted to define both common ethernet LED properties and 
> > > device specific properties, then you'd need to replace leds/common.yaml 
> > > above  with the ethernet one.
> > > 
> > > This is all the same reasons the DSA/switch stuff and graph bindings are 
> > > structured the way they are.
> > > 
> > 
> > Hi Rob, thanks for the review/questions.
> > 
> > The idea of all of this is to keep leds node as standard as possible.
> > It was asked to add unevaluatedProperties: False but I didn't understood
> > it was needed also for the led nodes.
> > 
> > leds/common.yaml have additionalProperties set to true but I guess that
> > is not OK for the final schema and we need something more specific.
> > 
> > Looking at the common.yaml schema reg binding is missing so an
> > additional schema is needed.
> > 
> > Reg is needed for ethernet LEDs and PHY but I think we should also permit
> > to skip that if the device actually have just one LED. (if this wouldn't
> > complicate the implementation. Maybe some hints from Andrew about this
> > decision?)
> 
> I would make reg mandatory.
>

Ok will add a new schema and change the regex.

> We should not encourage additional properties, but i also think we
> cannot block it.
> 
> The problem we have is that there is absolutely no standardisation
> here. Vendors are free to do whatever they want, and they do. So i
> would not be too surprised if some vendor properties are needed
> eventually.
>

Think that will come later with defining a more specific schema. But I
honestly think most of the special implementation will be handled to the
driver internally and not with special binding in DT.

-- 
	Ansuel
