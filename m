Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CEE60ED68
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiJ0B0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbiJ0B0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:26:00 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A50663840;
        Wed, 26 Oct 2022 18:25:58 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id kt23so429471ejc.7;
        Wed, 26 Oct 2022 18:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iR9yh+MGJc6yJjmKhl5V2S44arNolkzCvV+lLhhUe64=;
        b=Ak9cFoMVeWMSUIAGFSQkCJHFveAgowrzclOz8E4R2ovNZinoB7cMxtzP7UJ/FS1MhZ
         aIQokrDMuaFVyObAva5a9obdhGVc0TwHF/sqmrLQoYKqsWBtpU7iUc2XlX4U44VIx3Fl
         x4lm958gv/LZXmUtpDAvwe0Xa9ywn99PinYj+U49u2/uv07NVu8IdUgBKvZ4+2iiRaS3
         51j7VannowB5ZDLKDDlSh9Ip7bZdQh4pmCNSJgbMbOb17pBnjE+VQD/wO5vTADdy40DG
         99idyhZFj3/rxP/5K4LaE0m+b3wJsquLcBbqrMspfJKC+TzxL+q2Jm9yzSWNvgyyMeOD
         cJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iR9yh+MGJc6yJjmKhl5V2S44arNolkzCvV+lLhhUe64=;
        b=cn68yi2KiMsVNZc3IzAIbbTgMaf2tbtR1jQb5cm85pCIyyoahh4VruP+V0TrAJBwPM
         arNQKftY2i6Qe9+9No2BQ2hookATtzRPZEbTMsks+mTQFmRN3jd++MVCuypVuXFRxNfy
         koi4VmH/RAKltBgDRg1fG+X+EO6t13gMHGw8kHJY1trkjklAVdUxg1/tyRi9DMKImNAm
         5qTU1NhvJb6hHSzicQSCVm7J/FqlhPMPxPU+y835RiFlsmz0tVRiAUJxRm+/vZM9QaRg
         ov86u8akrIVDl7KHELI21hhWWWpR+YG+Au08gGkjsM6bGwW9A8bctwZRcbtq5QYf8uIK
         w+tg==
X-Gm-Message-State: ACrzQf26xuhnh9L+gQ4UX3zi2JBzzVdencwtUnM4bBGdzS1acoS6LAnR
        QWNOIEd6DZkn0ozUgn+ZmS4=
X-Google-Smtp-Source: AMsMyM6jmu231VAY0bBmdx9jmWK53PBwcm6TKFHHTLvhIiaAps0fm87Ok/ITHE9SN204+ArviR9/DA==
X-Received: by 2002:a17:907:744:b0:741:36b9:d2cc with SMTP id xc4-20020a170907074400b0074136b9d2ccmr38493473ejb.613.1666833956870;
        Wed, 26 Oct 2022 18:25:56 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q19-20020a170906389300b00773f3ccd989sm10022ejd.68.2022.10.26.18.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 18:25:56 -0700 (PDT)
Date:   Thu, 27 Oct 2022 04:25:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 3/7] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <20221027012553.zb3zjwmw3x6kw566@skbuf>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025212114.GA3322299-robh@kernel.org>
 <20221025212114.GA3322299-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025212114.GA3322299-robh@kernel.org>
 <20221025212114.GA3322299-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, Oct 25, 2022 at 04:21:14PM -0500, Rob Herring wrote:
> On Mon, Oct 24, 2022 at 10:03:51PM -0700, Colin Foster wrote:
> > The dsa.yaml binding contains duplicated bindings for address and size
> > cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> > this information, remove the reference to dsa-port.yaml and include the
> > full reference to dsa.yaml.
> 
> I don't think this works without further restructuring. Essentially, 
> 'unevaluatedProperties' on works on a single level. So every level has 
> to define all properties at that level either directly in 
> properties/patternProperties or within a $ref.
> 
> See how graph.yaml is structured and referenced for an example how this 
> has to work.
> 
> > @@ -104,8 +98,6 @@ patternProperties:
> >                SGMII on the QCA8337, it is advised to set this unless a communication
> >                issue is observed.
> >  
> > -        unevaluatedProperties: false
> > -
> 
> Dropping this means any undefined properties in port nodes won't be an 
> error. Once I fix all the issues related to these missing, there will be 
> a meta-schema checking for this (this could be one I fixed already).

I may be misreading, but here, "unevaluatedProperties: false" from dsa.yaml
(under patternProperties: "^(ethernet-)?port@[0-9]+$":) is on the same
level as the "unevaluatedProperties: false" that Colin is deleting.

In fact, I believe that it is precisely due to the "unevaluatedProperties: false"
from dsa.yaml that this is causing a failure now:

net/dsa/qca8k.example.dtb: switch@10: ports:port@6: Unevaluated properties are not allowed ('qca,sgmii-rxclk-falling-edge' was unexpected)

Could you please explain why is the 'qca,sgmii-rxclk-falling-edge'
property not evaluated from the perspective of dsa.yaml in the example?
It's a head scratcher to me.

May it have something to do with the fact that Colin's addition:

$ref: "dsa.yaml#"

is not expressed as:

allOf:
  - $ref: "dsa.yaml#"

?

If yes, can you explain exactly what is the difference with respect to
unevaluatedProperties?

> >  oneOf:
> >    - required:
> >        - ports
> > @@ -116,7 +108,7 @@ required:
> >    - compatible
> >    - reg
> >  
> > -additionalProperties: true
> 
> This should certainly be changed though. We should only have 'true' for 
> incomplete collections of properties. IOW, for common bindings.
> 
> > +unevaluatedProperties: false
