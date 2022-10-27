Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F7360F9D9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiJ0N5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbiJ0N5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:57:25 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A3B1863D1;
        Thu, 27 Oct 2022 06:57:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b12so2876570edd.6;
        Thu, 27 Oct 2022 06:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BgGH6TofYD/rywKyhWW+67Sd2MLqM/FPkdY/So3sHD4=;
        b=QYNHhJ0Q5odDV5Znrq7Z4C0wb996yCM3sI+sSoeb894XyTEdPwfJUI+KaxuTDF+9gK
         QFwt8X3/iA6uLP4ScXCa8K6VkokbdfVemVw8moeqTlKM0JUYNp62EprtNx0j4cAnjtMb
         LymqnSjQbg3pmQLwFec8Ga/ldYqugf4wKKtY8OgKTyWqEcJQ0sHZfa+31rIRnrJUWgmN
         uc+n41S3QkamQukeCzF583FfUfNuscLaerBHYrcv9mYlXNgGFw81eSujBdG9SIGxavjN
         diT3F5f+/W0TU3z9rBR1ioHNc7j+zHi3GMkQ3MryCQHfxbXdltbiNb/C0HNQ4I82hDOn
         KI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BgGH6TofYD/rywKyhWW+67Sd2MLqM/FPkdY/So3sHD4=;
        b=tDe50LS3qPEJHUeTQ3vIqUSZh0biW57PdyNHrtoRqsmPtyBTq0fYezzEgz/U1Q0okL
         GwkGyswQvR4bq9ocSObgaq8QOYSEex8vqXHK3dMGhNqYJ2uh70SulRcxLJy4SHlZaVGJ
         SXGazHqPCFYMtQey6mJHGDo2U8tmmufhdwd6RlojDdQ0cYH9RWCvJhB7aBS2LbcFOo1X
         J56MyuLnO4sE3dTGN32/pvTUcMsl4P9ra8t50me78+fWjXO/1aHWkuCBv2xWOnFEXKcf
         l995eQgO5wXtw8hJf9lkasbNfg24BXYLUixXrKxXnKyvCDiAMeNwg03k9pvFw1bwOnkH
         SVaA==
X-Gm-Message-State: ACrzQf0FmUJVbtCVg1UVq+wMIsAfIjfWWhLlkpDdJAGvQn5EgQAwGvU6
        BNwTuAAHoG2tSt4kDJ1gF9Y=
X-Google-Smtp-Source: AMsMyM7znxxuJfWua4nVUntiZGhW/BW+/Ph8zaQrDns4Gxtt/ED7QjMyb8B76QNY6qSRPIyhw3Dd0Q==
X-Received: by 2002:a05:6402:3789:b0:461:3ae6:8d73 with SMTP id et9-20020a056402378900b004613ae68d73mr33173388edb.229.1666879043022;
        Thu, 27 Oct 2022 06:57:23 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id n30-20020a50935e000000b004575085bf18sm974968eda.74.2022.10.27.06.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 06:57:22 -0700 (PDT)
Date:   Thu, 27 Oct 2022 16:57:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Camel Guo <camelg@axis.com>, Camel Guo <Camel.Guo@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, kernel <kernel@axis.com>
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
Message-ID: <20221027135719.pt7rz6dnjvcuqcxv@skbuf>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
 <16aac887-232a-7141-cc65-eab19c532592@linaro.org>
 <d0179725-0730-5826-caa4-228469d3bad4@axis.com>
 <a7f75d47-30e7-d076-a9fd-baa57688bbf7@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7f75d47-30e7-d076-a9fd-baa57688bbf7@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Camel,

On Thu, Oct 27, 2022 at 08:46:27AM -0400, Krzysztof Kozlowski wrote:
> >  >> +      - enum:
> >  >> +          - mxl,gsw145-mdio
> >  >
> >  > Why "mdio" suffix?
> > 
> > Inspired by others dsa chips.
> > lan9303.txt:  - "smsc,lan9303-mdio" for mdio managed mode
> > lantiq-gswip.txt:- compatible   : "lantiq,xrx200-mdio" for the MDIO bus
> > inside the GSWIP
> > nxp,sja1105.yaml:                  - nxp,sja1110-base-t1-mdio
> 
> As I replied to Andrew, this is discouraged.

Let's compare apples to apples, shall we?
"nxp,sja1110-base-t1-mdio" is the 100Base-T1 MDIO controller of the
NXP SJA1110 switch, hence the name. It is not a SJA1110 switch connected
over MDIO.
