Return-Path: <netdev+bounces-2596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FA27029FE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAF7A1C20A73
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0AFC2CB;
	Mon, 15 May 2023 10:05:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9047883A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:05:28 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B9B2721;
	Mon, 15 May 2023 03:05:26 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f435658d23so62687175e9.3;
        Mon, 15 May 2023 03:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684145125; x=1686737125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ewaqi8EQbJJwmrqafdsQZ7P3G1Ovd60Qj9jt1A0qxhA=;
        b=YosMedXyQMPzA+CbFO6cqDNMYBdd4OaUcyTwsmCKEn7Eal6rNrk9btgTaSVm1MMYU5
         AMWXROeoYQICJ8D3MUG/zPhYhxAodJzfodKp15gMBagSEgolHnKyzTQX+7PMZky+vfHS
         hVzDttVWrp9ler9pu/axfUV5N9g0S4mjvWZiOv9x7J+x9u3H4PL0gSmUy0xNJEJbZsyk
         zihiIOqvOrRT8JJeV34hBhNNGUPGgfosTFKtQnHshuXHEVXZGd/bGs6NIvyM0pBnkOJ7
         SeI7bP2rtz4z38aqXlBcYdNlymBAPUTx27p2/Swmu2qFfSnTJMNeMfm2m1AwYjllD/jc
         XqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684145125; x=1686737125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ewaqi8EQbJJwmrqafdsQZ7P3G1Ovd60Qj9jt1A0qxhA=;
        b=TqITuwxg4mKoEe/0y5WDEv7dI9vHQkhaw2hPuydfbE/983+N9uzooVi3zTZzACOJ14
         d9DLzVQRJ9go4tw8PUpa/g9g303pTFp4Keh/4QU3MbhsVFzB+uKzkp++9w+ybAfLo/0s
         CLjxEywQ8Dk2rD4cfcJwImPYNislQC+AZ03XdT80cKUPz4T6G+JS/jCnM5Qr9ELxtW+a
         82G1R0MZ3PLr0h43j5fVHhhbuCXvIE69ETimjFeLmrxztvOivQNR6psbvEd3LGa1mMY/
         umk9ZKCzthXRaCrwaaT/xUVznUErut/GXKwzCwLTDriec3TZ1VIfLoIaqEl1rnSWKbPt
         W76A==
X-Gm-Message-State: AC+VfDze0s6bGKiGIEiI0F73WgPuXP57nUVAFXRLxGggKB5QbYTbqlYJ
	Q+Pd4n1bX8c11AlR7Ovmlp4=
X-Google-Smtp-Source: ACHHUZ5p1gbJa8TRERxklmUArT0mviIvBpOLya2PI+ZwwrdvAeRRy6GaPW9BipsL3nx1TyQ70ACjxA==
X-Received: by 2002:a1c:4c19:0:b0:3f4:27ff:7d52 with SMTP id z25-20020a1c4c19000000b003f427ff7d52mr17844803wmf.2.1684145124722;
        Mon, 15 May 2023 03:05:24 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id a6-20020a1cf006000000b003f0aefcc457sm36511130wmb.45.2023.05.15.03.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 03:05:24 -0700 (PDT)
Date: Mon, 15 May 2023 13:05:21 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Conor Dooley <conor@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20230515100521.lvmsnoi2xw73jc2g@skbuf>
References: <20230514115741.40423-1-krzysztof.kozlowski@linaro.org>
 <20230514-turf-phrase-10b6d87ff953@spud>
 <f38c8762-2aff-737e-a1a3-0e457f9d3810@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f38c8762-2aff-737e-a1a3-0e457f9d3810@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 08:21:40AM +0200, Krzysztof Kozlowski wrote:
> On 14/05/2023 20:32, Conor Dooley wrote:
> > On Sun, May 14, 2023 at 01:57:41PM +0200, Krzysztof Kozlowski wrote:
> > 
> >> +allOf:
> >> +  - $ref: dsa.yaml#/$defs/ethernet-ports
> >> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> >> +  - if:
> >> +      properties:
> >> +        compatible:
> >> +          enum:
> >> +            - nxp,sja1105e
> >> +            - nxp,sja1105t
> > 
> > Is there a particular reason you did not put the "t" variant after the
> > "s" one?
> 
> Order is the same as in compatible list. I could sort them here, less
> changes in the future.

They are sorted chronologically, by generation.

