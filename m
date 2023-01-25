Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6517167BA75
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbjAYTO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbjAYTOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:14:55 -0500
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389695977B;
        Wed, 25 Jan 2023 11:14:55 -0800 (PST)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-15eec491b40so22539430fac.12;
        Wed, 25 Jan 2023 11:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7ZIBYBRXifYa1RtWi0W5plTVmV3V/O0RyNi5ZPu0Kk=;
        b=ad9Mcn6QtZ34nz5DzKeDXWw2SD/0g4j7GH33XzxMUVayXkKEAI79XuYNGrqufIzbyU
         +UVwGJqkc3BSntGNndfefUe6smskW83K1bYLX/FCFEXsv2rW3VBRjNbLDss/6pM+m2jU
         aF9hmHA1yNOut7EQqw2ctXz4MYlfBrbPuj7fWzh5/ITWP2jZhh5viofn9SuPPdZo6sCq
         UDALWEb0C6H6n+RNdkr+sQGVcUmB25Dn7Pv5sjsmSU7weG8hm7deQl03vnNp6UbsVnxG
         39ZlBNixMHqDL3VSXF1bDOAJXqcgYIPuo/xAHqoxJMyV/U2UMajnnqqjZrDDs8yO15W1
         4N7g==
X-Gm-Message-State: AO0yUKUlrU0LvYZVku4q5aNnEXdWfzb0Zae4HN66zffhcoje0vkxpmJ4
        UfDlmQD3buu0HtCrUi/r2A==
X-Google-Smtp-Source: AK7set9RPG5e415X/SdpB5uk1kHASr/2oECDpr8qipqh4aQ+mfMq/Fi+zRv3nSJSuzfKUkhbcN5fbA==
X-Received: by 2002:a05:6870:f28b:b0:163:1eab:b7d6 with SMTP id u11-20020a056870f28b00b001631eabb7d6mr3312262oap.11.1674674094446;
        Wed, 25 Jan 2023 11:14:54 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t10-20020a4a96ca000000b004a3d98b2ccdsm2151545ooi.42.2023.01.25.11.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:14:54 -0800 (PST)
Received: (nullmailer pid 2707731 invoked by uid 1000);
        Wed, 25 Jan 2023 19:14:53 -0000
Date:   Wed, 25 Jan 2023 13:14:53 -0600
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Andrey Konovalov <andrey.konovalov@linaro.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: stmmac: add DT parameter to keep RX_CLK running
 in LPI state
Message-ID: <20230125191453.GA2704119-robh@kernel.org>
References: <20230123133747.18896-1-andrey.konovalov@linaro.org>
 <Y88uleBK5zROcpgc@lunn.ch>
 <f8b6aca2-c0d2-3aaf-4231-f7a9b13d864d@linaro.org>
 <Y8/mrhWDa6DuauZY@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8/mrhWDa6DuauZY@lunn.ch>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 03:09:50PM +0100, Andrew Lunn wrote:
> > > Could
> > > dwmac-qcom-ethqos.c just do this unconditionally?
> > 
> > Never stopping RX_CLK in Rx LPI state would always work, but the power
> > consumption would somewhat increase (in Rx LPI state). Some people do care
> > about it.
> >
> > > Is the interrupt
> > > controller part of the licensed IP, or is it from QCOM? If it is part
> > > of the licensed IP, it is probably broken for other devices as well,
> > > so maybe it should be a quirk for all devices of a particular version
> > > of the IP?
> > 
> > Most probably this is the part of the ethernet MAC IP. And this is quite
> > possible that the issue is specific for particular versions of the IP.
> > Unfortunately I don't have the documentation related to this particular
> > issue.
> 
> Please could you ask around. Do you have contacts in Qualcomm?
> Contacts at Synopsys?
> 
> Ideally it would be nice to fix it for everybody, not just one SoC.

Yes, but to fix for just 1 SoC use the SoC specific compatible to imply 
the need for this. Then only a kernel update is needed to fix, not a 
kernel and dtb update.

Rob
