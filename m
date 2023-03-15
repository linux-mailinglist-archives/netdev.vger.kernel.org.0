Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC486BB8D7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjCOP7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbjCOP7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:59:05 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2345CEC4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:58:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so2249021wms.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678895914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4T7kaFXTtcBiL480Pu1H+dPHHZBHfWZruPkbuDpElk8=;
        b=orWFTXeYxi92rTypv8705tMzPRL0iQkfcJfozc5JJmOoy9O8ZKGejPtyX45xI9XT62
         vITO6coe/qM1Rvh/Tsc2xgrRrnU431aAr8TDpbMr+ab80dfYwdRJqT1eNd04Wm9OyjVH
         edgd3Av/uR2k8+OSrwoP/8T3AIPc7ADiEnKml0nF1GJoGfTLZc0vxwmbmF7pPgjOcth7
         9nDiZXauGeZ1ZbWSmgIS/DmC65y0vEacS+WOJmh9+UrEG0okAaTpyxCKZEv70u5qMYoW
         fQtEPPdxq75rnY3atHnTKcgHyKC0RajenYPnDtrPgqVcY65v+WSLt7LxecCTU251L8fU
         y15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678895914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4T7kaFXTtcBiL480Pu1H+dPHHZBHfWZruPkbuDpElk8=;
        b=CjPX4ySWJldUmtKyeyTthAdwlJ8t1IF/+hv3Ei4nYprM5fzBCnqP2a297i6Tt2eu38
         ytTYI6RLP8Hkj9qbcBllYio0llZo+ehFN4U/T6ieo1oGhRgOuqiCY2HGziU5AwyAHDBf
         KNm6Hn5e3ZgjBKMS742ecGQjOVr9ReHo0ni44kyKAA++HouLRnu4O1e44d6t4fXEYhpk
         lJucmeBfnmZJVYGAGUG1YxqhWRaqONLo9B+EB4koMnOPfCCoSzyTkQ6lhKZbakL1ogcB
         1eadqj1xpPRnAdLrUBYA82K3DfNv5zBTCAKWRGPacCu/a/cF9U313OVnoM5WrnrtxedN
         T0rw==
X-Gm-Message-State: AO0yUKX4b8qE7DgiAUOojpHs9Ai4GutiCQvf6L/lxnMBmfMlOLKDIIOg
        d7fLE7W5mH+u6B/EmNe9ZcvYnw==
X-Google-Smtp-Source: AK7set+ONSOP7xhpe0wCgX7SfduEVrDjgtriSUcZeiep4x+56T+bLa7KcDCOR9jdxUvOYqxcd/tbjA==
X-Received: by 2002:a05:600c:4751:b0:3ea:f0d6:5d36 with SMTP id w17-20020a05600c475100b003eaf0d65d36mr18465919wmo.29.1678895914447;
        Wed, 15 Mar 2023 08:58:34 -0700 (PDT)
Received: from blmsp ([2001:4090:a247:8056:883:2e39:923e:f1d])
        by smtp.gmail.com with ESMTPSA id t14-20020a05600c198e00b003ed29899dfdsm2500905wmq.21.2023.03.15.08.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 08:58:33 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:58:33 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: can: tcan4x5x: Add tcan4552 and
 tcan4553 variants
Message-ID: <20230315155833.qsb5t367on5hl5li@blmsp>
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-2-msp@baylibre.com>
 <680053bc-66fb-729f-ecdc-2f5fe511cecd@linaro.org>
 <20230315112508.6q52rekhmk66uiwj@pengutronix.de>
 <54aae3b8-ee85-c7eb-ecda-f574cb140675@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54aae3b8-ee85-c7eb-ecda-f574cb140675@linaro.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:14:27PM +0100, Krzysztof Kozlowski wrote:
> On 15/03/2023 12:25, Marc Kleine-Budde wrote:
> > On 14.03.2023 21:01:10, Krzysztof Kozlowski wrote:
> >> On 14/03/2023 16:11, Markus Schneider-Pargmann wrote:
> >>> These two new chips do not have state or wake pins.
> >>>
> >>> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> >>> ---
> >>>  .../devicetree/bindings/net/can/tcan4x5x.txt          | 11 ++++++++---
> >>>  1 file changed, 8 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> >>> index e3501bfa22e9..38a2b5369b44 100644
> >>> --- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> >>> +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> >>> @@ -4,7 +4,10 @@ Texas Instruments TCAN4x5x CAN Controller
> >>>  This file provides device node information for the TCAN4x5x interface contains.
> >>>  
> >>>  Required properties:
> >>> -	- compatible: "ti,tcan4x5x"
> >>> +	- compatible:
> >>> +		"ti,tcan4x5x" or
> >>> +		"ti,tcan4552" or
> >>> +		"ti,tcan4553"
> >>
> >> Awesome, they nicely fit into wildcard... Would be useful to deprecate
> >> the wildcard at some point and switch to proper compatibles in such
> >> case, because now they became confusing.
> > 
> > I plead for DT stability!
> > 
> > As I understand correctly, the exact version of the chip (4550, 4552, or
> > 4553) can be detected via the ID2 register.
> 
> So maybe there is no need for this patch at all? Or the new compatibles
> should be made compatible with generic fallback?

I can use the value being read from the ID2 register to get the version.
This at least holds the correct value for tcan4550, 4552 and 4553. But
the state and wake gpios can't be used in case of a 4552 or 4553.

So yes, it is possible to do it without the new compatibles but the
changes for state and wake gpios need to stay.

What do you two prefer?

Best,
Markus
