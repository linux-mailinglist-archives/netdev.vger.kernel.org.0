Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6542BCD2
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbhJMKcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbhJMKcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:32:12 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615ACC061570;
        Wed, 13 Oct 2021 03:30:08 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y12so8221644eda.4;
        Wed, 13 Oct 2021 03:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y/rnqiiRDqzhToYNQ2Zuvuqbkbv5/WaDX5sqgB4Xrno=;
        b=Jj86qHBhhjlKiPDP7CjiDwa3rXVoGd38psAEjP9nnnGjHqsZ6KyPzsMvLr/y1ZtBq3
         SPap+O09GBgNCsF4KtMo0HDfjtGGHrhiIEJLH2OM+fpeNCtWsyRkenG/CNcEBgC9I5QJ
         pF3w4/RvuVplPCiEjB2l3haCyBtqmyjEymOwsYjzj2WDzo8csLhW8WPmlpnM7Te6tFpu
         Bf0c+bR1FkgM8wa4pMLgZa6W9RRE1HqpEm3rpZ7jmF9teFL82zYEP4IGOmjh7bhfpxFA
         EBzuXPgODZGqfoeebSIEnlR38UhDlWimz5u2A2BCpphsOu9wsHm4FfijGEvswqMLkPxQ
         nu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y/rnqiiRDqzhToYNQ2Zuvuqbkbv5/WaDX5sqgB4Xrno=;
        b=zwqCwqw1E6hYEZpUjSVTU7uZqo/1Tfa6aXzehw/G32lYAv6XrwS0KiUI7AabLdv/AZ
         lTc/kmMFhACzLxjGats0755rgZu4jmcsySRx2WCvpAT8sdd/wjx1W592TwVMw/2ZBgwI
         p2unMd1BZupKCNle5uVhjohLkFfaBwaadFodUCgsC2aOE+WqORbXgm9NX41d0h0qjEIp
         Kn9apkqN8Mip9ajzNCTiFd/HhwdQg2ai19p2thoidSFzOvEWy+FuHeAnDdM52FmBGjcL
         UST11J8wgHFvBlup3rCKGznExWcI1h8KKbnqyJzxYk4xSFdyUmkek8Vs6H9RCmIqc37h
         aojQ==
X-Gm-Message-State: AOAM533tRNa/+J/mus+4tXqyM62U0/vpIts4+ggqy9Iw6octpHxNOJ2o
        3XUCrbIh24i1+8Z3erw7pDg=
X-Google-Smtp-Source: ABdhPJyz3L+DI2qSA77Phw1w3Asc0E2qWte8XGDO3iCC/qA5s5ah4fZ6hEl79BhG1vwc6Lx7oII4iw==
X-Received: by 2002:a17:906:1707:: with SMTP id c7mr37987499eje.377.1634121006829;
        Wed, 13 Oct 2021 03:30:06 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id h18sm6430351ejt.29.2021.10.13.03.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:30:06 -0700 (PDT)
Date:   Wed, 13 Oct 2021 12:30:03 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [net-next PATCH v6 15/16] dt-bindings: net: dsa: qca8k: convert
 to YAML schema
Message-ID: <YWa1KwlM2SFP5jM0@Ansuel-xps.localdomain>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
 <20211013011622.10537-16-ansuelsmth@gmail.com>
 <1634094529.487895.3858822.nullmailer@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634094529.487895.3858822.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 10:08:49PM -0500, Rob Herring wrote:
> On Wed, 13 Oct 2021 03:16:21 +0200, Ansuel Smith wrote:
> > From: Matthew Hagan <mnhagan88@gmail.com>
> > 
> > Convert the qca8k bindings to YAML format.
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/qca8k.txt     | 245 ------------
> >  .../devicetree/bindings/net/dsa/qca8k.yaml    | 362 ++++++++++++++++++
> >  2 files changed, 362 insertions(+), 245 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> ./Documentation/devicetree/bindings/net/dsa/qca8k.yaml:362:7: [error] no new line character at the end of file (new-line-at-end-of-file)
>

Stupid me will fix that...

> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dt.yaml: switch@10: 'oneOf' conditional failed, one must be fixed:
> 	'ports' is a required property
> 	'ethernet-ports' is a required property
> 	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> 

About this i fixed with the next patch. Should I include that in this
patch? Or i can ignore this error?

> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/patch/1540096
> 
> This check can fail if there are any dependencies. The base for a patch
> series is generally the most recent rc1.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit.
> 

-- 
	Ansuel
