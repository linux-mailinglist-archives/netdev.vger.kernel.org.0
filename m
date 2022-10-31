Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFCE613A73
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiJaPoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiJaPoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:44:10 -0400
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD8C11A2B;
        Mon, 31 Oct 2022 08:44:09 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id cy15-20020a056830698f00b0065c530585afso6973985otb.2;
        Mon, 31 Oct 2022 08:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifwpmU7A0PMQ06MNBDvyGSIa8Sixxnkraic/SyG2pxo=;
        b=xWeqNRs+xYaVY6pJ0/6AED+LI0KlGpT8/Xej8vjW1SbOIFob2Q0qJ+a5dioCyt/Yxt
         gm0dOWhC8OMIlV2sYNDHIuT0xA8W1pL8spyDAuILElCVkPviCwMvr9QycUzy1WM+v//6
         nPr1kpc4E7wQejg4hElLXbSKYwji1hjkzJkjDmu1neZIMZLjgng+Gs2jiBFN3zY0MiHJ
         Dl8kYNZyajMlkeiZ5gfO7yxF2RmEB/Mk4YHvNV70COLtCVPAdP/+kONOkCmCJ2Hu3iiC
         hC591Fp1e+2Lks/oP9/IP29GsLLtlCdAdsKF/yyB6GGw0Ae4b0Rrv/IJVrn6pzBauKmZ
         fqvg==
X-Gm-Message-State: ACrzQf0ZS/65EJSTloq4f3J+kB2WM2YBySsA6UVVeQmsv1AjIGxmEWgL
        1DxsVIRyrTbczj2N8aTkXQ==
X-Google-Smtp-Source: AMsMyM4dyhQJfUihmItaQeAe7EzaxUEKtl/G0crodesYYunz1GQ0UewMwDpLQSlnR0+F3iiPt9nM5A==
X-Received: by 2002:a9d:7384:0:b0:66c:42ae:a3da with SMTP id j4-20020a9d7384000000b0066c42aea3damr5180443otk.220.1667231048700;
        Mon, 31 Oct 2022 08:44:08 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v13-20020a056870708d00b0013c955f64dbsm3147424oae.41.2022.10.31.08.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 08:44:08 -0700 (PDT)
Received: (nullmailer pid 2922103 invoked by uid 1000);
        Mon, 31 Oct 2022 15:44:09 -0000
Date:   Mon, 31 Oct 2022 10:44:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
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
        =?iso-8859-1?Q?n=E7_=DCNAL?= <arinc.unal@arinc9.com>,
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
Message-ID: <20221031154409.GA2861119-robh@kernel.org>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025212114.GA3322299-robh@kernel.org>
 <20221025212114.GA3322299-robh@kernel.org>
 <20221027012553.zb3zjwmw3x6kw566@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027012553.zb3zjwmw3x6kw566@skbuf>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 04:25:53AM +0300, Vladimir Oltean wrote:
> Hi Rob,
> 
> On Tue, Oct 25, 2022 at 04:21:14PM -0500, Rob Herring wrote:
> > On Mon, Oct 24, 2022 at 10:03:51PM -0700, Colin Foster wrote:
> > > The dsa.yaml binding contains duplicated bindings for address and size
> > > cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> > > this information, remove the reference to dsa-port.yaml and include the
> > > full reference to dsa.yaml.
> > 
> > I don't think this works without further restructuring. Essentially, 
> > 'unevaluatedProperties' on works on a single level. So every level has 
> > to define all properties at that level either directly in 
> > properties/patternProperties or within a $ref.
> > 
> > See how graph.yaml is structured and referenced for an example how this 
> > has to work.
> > 
> > > @@ -104,8 +98,6 @@ patternProperties:
> > >                SGMII on the QCA8337, it is advised to set this unless a communication
> > >                issue is observed.
> > >  
> > > -        unevaluatedProperties: false
> > > -
> > 
> > Dropping this means any undefined properties in port nodes won't be an 
> > error. Once I fix all the issues related to these missing, there will be 
> > a meta-schema checking for this (this could be one I fixed already).
> 
> I may be misreading, but here, "unevaluatedProperties: false" from dsa.yaml
> (under patternProperties: "^(ethernet-)?port@[0-9]+$":) is on the same
> level as the "unevaluatedProperties: false" that Colin is deleting.
> 
> In fact, I believe that it is precisely due to the "unevaluatedProperties: false"
> from dsa.yaml that this is causing a failure now:
> 
> net/dsa/qca8k.example.dtb: switch@10: ports:port@6: Unevaluated properties are not allowed ('qca,sgmii-rxclk-falling-edge' was unexpected)
> 
> Could you please explain why is the 'qca,sgmii-rxclk-falling-edge'
> property not evaluated from the perspective of dsa.yaml in the example?
> It's a head scratcher to me.

A schema with unevaluatedProperties can "see" into a $ref, but the 
ref'ed schema having unevaluatedProperties can't see back to the 
referring schema for properties defined there.

So if a schema is referenced by other schemas which can define their own 
additional properties, that schema cannot have 'unevaluatedProperties: 
false'. If both schemas have 'unevaluatedProperties: false', then it's 
just redundant. We may end up doing that just because it's not obvious 
when we have both or not, and no unevaluatedProperties/ 
additionalProperties at all is a bigger issue. I'm working on a 
meta-schema to check this.


> May it have something to do with the fact that Colin's addition:
> 
> $ref: "dsa.yaml#"
> 
> is not expressed as:
> 
> allOf:
>   - $ref: "dsa.yaml#"
> 
> ?

No. Either way behaves the same. We generally only use 'allOf' when 
there might be more than 1 entry. That is mostly just at the top-level.

Rob
