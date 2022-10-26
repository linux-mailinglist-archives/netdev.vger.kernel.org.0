Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0FC60E6BC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 19:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbiJZRrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 13:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiJZRrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 13:47:06 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B451A99D2;
        Wed, 26 Oct 2022 10:47:04 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-13b23e29e36so20383254fac.8;
        Wed, 26 Oct 2022 10:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HB//srE+jyi0FWpKiy+4h9s6yd6ZaGXhIBWWMCtKONM=;
        b=tUd3qmxA3RYvZ+yKS51u5YN5DrGffrZmHU9MBVrgSntXbW+TdYxjAWtU3G3K2+dYIJ
         SHW7WFdPyZmbh1NlB+flShomMCfroDnFcl45/5ni87G0+S5QE6oslRUrQWxbzlGuc7C+
         ureB3qWfpCEg7v0x7+jjq3Z5v6kq+QEdxxE9tBWw2kbGxu69nHtsLTbzg69M/uvks6bh
         DPu2xRDES/b8hyUKfb5cM0aciFCXrxAI/GgC3KzAVRcuiITiOYac2GmLgrmBAdb5njv5
         ZV8uJ2QN6IMCkjjLcA3/mHdhJ1SUveepZCLcpMv525gBhR0Vq5tQMNnNA67E8/FTVGGe
         b20w==
X-Gm-Message-State: ACrzQf0ElWXZx6bIqQTEsPUJTFDaOzKPiQir4FqhgxzP6Zoh+OQck6EB
        tEA0S8d44Ha0vA/BQxsjcw==
X-Google-Smtp-Source: AMsMyM7519BMQbcZ6P8S30eJ39PNdmtUMBDMdv4cp8EuTysDhqzQIi3UvRg1RXimILV387Wj+AclvQ==
X-Received: by 2002:a05:6870:63aa:b0:13a:fe6c:5ed0 with SMTP id t42-20020a05687063aa00b0013afe6c5ed0mr3049476oap.257.1666806423841;
        Wed, 26 Oct 2022 10:47:03 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z22-20020a4a2256000000b004767df8f231sm2349508ooe.39.2022.10.26.10.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 10:47:03 -0700 (PDT)
Received: (nullmailer pid 811863 invoked by uid 1000);
        Wed, 26 Oct 2022 17:47:04 -0000
Date:   Wed, 26 Oct 2022 12:47:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-mediatek@lists.infradead.org,
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
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 7/7] dt-bindings: net: mscc,vsc7514-switch:
 utilize generic ethernet-switch.yaml
Message-ID: <20221026174704.GA809642-robh@kernel.org>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025050355.3979380-8-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 10:03:55PM -0700, Colin Foster wrote:
> Several bindings for ethernet switches are available for non-dsa switches
> by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
> the common bindings for the VSC7514.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 36 +------------------
>  1 file changed, 1 insertion(+), 35 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> index ee0a504bdb24..1703bd46c3ca 100644
> --- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> @@ -19,11 +19,8 @@ description: |
>    packet extraction/injection.
>  
>  properties:
> -  $nodename:
> -    pattern: "^switch@[0-9a-f]+$"
> -
>    compatible:
> -    const: mscc,vsc7514-switch
> +    $ref: ethernet-switch.yaml#

??? 'compatible' is a node?

Rob
