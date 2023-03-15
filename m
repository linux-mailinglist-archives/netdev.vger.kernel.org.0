Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93926BA445
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 01:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCOAuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 20:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCOAuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 20:50:06 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7082799B;
        Tue, 14 Mar 2023 17:50:04 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o12so69283611edb.9;
        Tue, 14 Mar 2023 17:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678841403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTaI6oLBvIWrQBcdvPr8QslmdKZi9k5sOZurX5juDoU=;
        b=TJTxgwKGXlPcohU5vHvrPKVNnynCZGsyGbXDCtRkAijHVosgjxKLzgccWP5KtwwodJ
         YMerE7KWSJXRKYQ70TjE/EGwZAHEB990CI0MSu9RBKZ2RJT/n5EOAk2NlM84cNdEEVYH
         BnzELAwYcRzOpfV0+15d9PSk0jC77cKzsRotV7FmvRMSlNy/aEvv3i2aGUU5+uNTSs/b
         hnqfUZAvch+c09iC0efWIlY7jT+XiNPUsADsTZi80gbJqVAXcJJc/C8zohBAlhn4nAMg
         S3sOX9hvQkOEpF0LrZtzx/ZfDdSR5jJvzV5SKc3TU/VzSK9lWOetwiWzXbp54exwAnZN
         2DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678841403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eTaI6oLBvIWrQBcdvPr8QslmdKZi9k5sOZurX5juDoU=;
        b=Z47+ZJQd3tv+5vn6M1Cfn+g2s84Jju3yhFSRZzaYtoIIU7/jJx2nbILdv8f5pANWcb
         NxD2ctn1Lcl0OaTFZYPRA3u5NMowIelQ63Z8ysHCIN1bu+M5CEIcVTSeGr1/SCD5sbR+
         auBbT97bag+chmcd983Z1n76LtRwEmEqL1gLwOSQzFphmxB+0M+R2ROIE202AcXskakJ
         XU5cn23TL76v1xtQi+1GiTu2GLP6jBUTJUYVnSHGBikpy9wSBWlNgs/sW3+rLEHp7SHi
         BzHLgOmN4j6PBVLaR7jnJ3xNwXKmSLjy5s+XzIKa8mI6JsHEGB1uMs++R2N2aDpVQGZo
         AeQw==
X-Gm-Message-State: AO0yUKUv/2YoxnOI2XyMsP9AuM094g8Kzft7p4QnaFY1eqWMA0tqGbFN
        ceBa/PDNGY9RfMQ9GRPkjQU=
X-Google-Smtp-Source: AK7set/F2ZR4puIh6B+EqpLBjQeqN42t7YhXpKQWNql2xnUPsCyhGWrmMl701j4uKGz4aaEAf91pkA==
X-Received: by 2002:a17:907:a2ce:b0:8a9:e031:c4b7 with SMTP id re14-20020a170907a2ce00b008a9e031c4b7mr4171885ejc.4.1678841403233;
        Tue, 14 Mar 2023 17:50:03 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090629cb00b008e17dc10decsm1791873eje.52.2023.03.14.17.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 17:50:03 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:50:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v3 09/14] dt-bindings: net: dsa: dsa-port:
 Document support for LEDs node
Message-ID: <20230315005000.co4in33amy3t3xbx@skbuf>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:15:11AM +0100, Christian Marangi wrote:
> Document support for LEDs node in dsa port.
> Switch may support different LEDs that can be configured for different
> operation like blinking on traffic event or port link.
> 
> Also add some Documentation to describe the difference of these nodes
> compared to PHY LEDs, since dsa-port LEDs are controllable by the switch
> regs and the possible intergated PHY doesn't have control on them.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 21 +++++++++++++++++++
>  1 file changed, 21 insertions(+)

Of all schemas, why did you choose dsa-port.yaml? Why not either something
hardware specific (qca8k.yaml) or more generic (ethernet-controller.yaml)?
