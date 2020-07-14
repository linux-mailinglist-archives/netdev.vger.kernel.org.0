Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A457C21E612
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 05:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGNDCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 23:02:35 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38183 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNDCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 23:02:35 -0400
Received: by mail-io1-f67.google.com with SMTP id l1so15795673ioh.5;
        Mon, 13 Jul 2020 20:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SkDB5BmUKt2pKum62exqKA/yruCbaPfHu4crzZTiQmY=;
        b=uZaxcJ97EaRqK0iXxxRXZRJnHtKvxXiJF6QAfepOOwG00imEvDLGr+sVl52FQccUqI
         IbPIVyZi+7NTKaiqGqRxM9f/46r0w/OekYzuqW93U23qiWpSV9nl2RnSY56gVQRQAcPU
         /uLndQW65Fgjg0RCvCyEDIrSTgYGNe2jYRSxoEGrHXKtE+dCWMm3GiG3WjmfHHHNrUZ7
         vSGOkSNxVbSYVGrbD83lhCZnDGPRzaaq11WV4AojpbztFjRgz3qdwdO1U3S26Ca9x31M
         Zrj+CqIK98jIjr1GOHeTwyYMdmp01BZVnQHm7BJATMKLs6oEmIniIGt8M1QGdeekff7N
         Bm9Q==
X-Gm-Message-State: AOAM532oJ2U+puQi9+NNscSZeY/p4LyYluczdcVryn9Hk0hIOHyzhDBk
        f9GCw0pRdEwfdNNlEcWwBw==
X-Google-Smtp-Source: ABdhPJw8Db0s2CoU2SRIn4yaJkkZs4/hb1DG2M6depKXxi75fWnxYjQpFbbjyiQ24Wkrb7WlVZ5ZYQ==
X-Received: by 2002:a6b:b682:: with SMTP id g124mr2933447iof.55.1594695754069;
        Mon, 13 Jul 2020 20:02:34 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id w5sm9186839ilm.46.2020.07.13.20.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 20:02:33 -0700 (PDT)
Received: (nullmailer pid 1205357 invoked by uid 1000);
        Tue, 14 Jul 2020 03:02:31 -0000
Date:   Mon, 13 Jul 2020 21:02:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        devicetree@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Subject: Re: [PATCH v2 2/7] dt-bindings: net: renesas,ravb: Document internal
 clock delay properties
Message-ID: <20200714030231.GA1205304@bogus>
References: <20200706143529.18306-1-geert+renesas@glider.be>
 <20200706143529.18306-3-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706143529.18306-3-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Jul 2020 16:35:24 +0200, Geert Uytterhoeven wrote:
> Some EtherAVB variants support internal clock delay configuration, which
> can add larger delays than the delays that are typically supported by
> the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
> properties).
> 
> Add properties for configuring the internal MAC delays.
> These properties are mandatory, even when specified as zero, to
> distinguish between old and new DTBs.
> 
> Update the (bogus) example accordingly.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps",
>   - Add "(bogus)" to the example update, to avoid people considering it
>     a one-to-one conversion.
> ---
>  .../devicetree/bindings/net/renesas,ravb.txt  | 29 ++++++++++---------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
