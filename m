Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C19C60171B
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJQTNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiJQTNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:13:18 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFBE76440;
        Mon, 17 Oct 2022 12:13:15 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id sc25so27098154ejc.12;
        Mon, 17 Oct 2022 12:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=33BK7h3f/72yiZ0G0CsfbKNjwF28vT9QNhpxY7FciUs=;
        b=ASQRI35WiV5mxbEg98NEP2+g577DTDF5fgw+6iiIg1RpXm9xn8yEbHt+nImfuOjuhS
         GXQLkLS88+sDIj6Y0Rz5mK6vHBjqKKzs68dJvwF8TKe1ORxkS5bZfxZwIHe3W4m5b0kY
         dc9kEYeuQdB5iRvIasohJq5Ps3jmPs11WEueBQ4ReuaK+zSFdLOLcqdolOpAkHeVfBBs
         txc8WCFkfJbs8ITZQzUf74I+fyBMwfDR8riI1zhgIY9GLe5wA9b5MEsCf/K4h9Sc485o
         +Uk/hVqP7UyfElTn3OuOvyIt2XPvYl5wgTzYfLnZXf07PMtfy1lVf1cyrKBoWYc9v7P8
         aL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33BK7h3f/72yiZ0G0CsfbKNjwF28vT9QNhpxY7FciUs=;
        b=LocHbB3N0eE2xry6dDs7g/X4YxVVYPW2hS7Nei/0M6Zn+3jlcDSbNfS45GnVQnlCqM
         d1cOulM3IU+3c6H19AavbgSVE/pFKHWFBhil877aAMNPw03X5Y9SoCXvNUELCBo175Qp
         xcW9FnhFrGto7cV3+272Nm42/ZpACfY5V4+J/UaCjX5Vbs/p1eKmr/lfbXvfdiu6zrN7
         be6IUEc9PW50PG1hMOizw8km8xNZUgEWFa4kHIOfhPXbXpL9ezSQdTy3wrxpDP06wbtE
         qfuGrTdS6JNY/00PkPPMEcwrYMF4OjT72tBvtXxDrADBUGi5/q/wITbKiwYvh/ANh+XV
         tNxw==
X-Gm-Message-State: ACrzQf29vZbU9eazBnVmf+PrciUd140HH/3zR8XZRBthov62Z2xTavDi
        pMH4cuRTZOzEa/zWT8Qb/4o=
X-Google-Smtp-Source: AMsMyM6q6ZdFHfr55FESvkOm69HKzX4gmdLDV07GHhH8bIZHXpbwsHgNVWmqfoAoUqUVOgNyS+jjYQ==
X-Received: by 2002:a17:907:8a17:b0:782:6e72:7aba with SMTP id sc23-20020a1709078a1700b007826e727abamr10072973ejc.474.1666033994246;
        Mon, 17 Oct 2022 12:13:14 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709063ca200b00773f3ccd989sm6452762ejh.68.2022.10.17.12.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:13:13 -0700 (PDT)
Date:   Mon, 17 Oct 2022 22:13:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     krzysztof.kozlowski@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Message-ID: <20221017191311.mxkjfz75pgzbcwcz@skbuf>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
 <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
 <20221009222257.f3fcl7mw3hdtp4p2@skbuf>
 <551ca020-d4bb-94bf-7091-755506d76f58@linaro.org>
 <20221010102914.ut364d57sjhnb3lj@skbuf>
 <MWHPR11MB16938D7BA12C1632FF675C0AEF299@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16938D7BA12C1632FF675C0AEF299@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 06:51:57PM +0000, Jerry.Ray@microchip.com wrote:
> >> On 09/10/2022 18:22, Vladimir Oltean wrote:
> >> > On Sun, Oct 09, 2022 at 05:20:03PM +0200, Krzysztof Kozlowski wrote:
> >> >> On 09/10/2022 00:56, Vladimir Oltean wrote:
> >> >>>>
> >> >>>> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
> >> >>>> +M:      Jerry Ray <jerry.ray@microchip.com>
> >> >>>> +M:      UNGLinuxDriver@microchip.com
> >> >>>> +L:      netdev@vger.kernel.org
> >> >>>> +S:      Maintained
> >> >>>> +F:      Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> >> >>>> +F:      drivers/net/dsa/lan9303*
> >> >>>> +
> >> >>>
> >> >>> Separate patch please? Changes to the MAINTAINERS file get applied to
> >> >>> the "net" tree.
> >> >>
> >> >> This will also go via net tree, so there is no real need to split it.
> >> >
> >> > I meant exactly what I wrote, "net" tree as in the networking tree where
> >> > fixes to the current master branch are sent:
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git, or in
> >> > other words, not net-next.git where new features are sent:
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> >>
> >> Ah, but how it can go to fixes? It has invalid path (in the context of
> >> net-fixes) and it is not related to anything in the current cycle.
> >
> >Personally I'd split the patch into 2 pieces, the MAINTAINERS entry for
> >the drivers/net/dsa/lan9303* portion, plus the current .txt schema,
> >which goes to "net" right away, wait until the net tree gets merged back
> >into net-next (happens when submissions for net-next reopen), then add
> >the dt-bindings and rename the .txt schema from MAINTAINERS to .yaml.
> >
> 
> If this patch should be flagged [net] rather than [net-next], please tell
> me.  I'm looking to add content to the driver going forward and assumed
> net-next.  Splitting the patch into 2 steps didn't make a lot of sense to
> me.  Splitting the patch into 2 patches targeting 2 different repos makes
> even less sense.  I assume the net MAINTAINERS list to be updated from
> net-next contributions on the next cycle.
> 
> As I'm now outright deleting the lan9303.txt file, I'm getting the test bot
> error about also needing to change the rst file that references lan9303.txt.
> I'll do so in the next revision.  The alternative is to drop the yaml, simply
> add to the old txt file, and be done with it.   Your call.
> 
> Regards,
> Jerry.

Ah, this is not a "my call" thing.

The portion I highlighted of the change you're making includes your name
into the output of $(./scripts/get_maintainer.pl drivers/net/dsa/lan9303-core.c).
In other words, you're voluntarily subscribing to the responsibility of
being a maintainer for the driver, getting emails from other developers,
reviewing patches. Furthermore, you also maintain the code in the stable
trees, hence your name also gets propagated there so people who use
those kernels can report problems to you.

The MAINTAINERS entry for lan9303 needs to go to the "net" tree, from
where it can be backported. This covers the driver + schema files as
they currently are. The change of the .txt to the .yaml schema then
comes on top of that (and on "net-next").
