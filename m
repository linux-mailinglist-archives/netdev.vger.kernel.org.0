Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB261FFA9
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiKGUkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiKGUkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:40:39 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876872983C;
        Mon,  7 Nov 2022 12:40:38 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id b2so33357628eja.6;
        Mon, 07 Nov 2022 12:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYdHJswDeDT3txuf8JK/w+986tI61N01JzHQOoC+jnU=;
        b=Q+Ezft1Ugxx7pFfrT+/0zleWdM2c1oPP+CSzpxbWAF61TwxLeiwnKzbfP996DLBRe0
         RWTV+nn9uSwH/juyDPDPdxgnnstdQ4uFjcGFK3GlHQiUm+7E7JhUvbbzUOcfcZW8G34D
         IlQzk235D2Z6WlmavUqa+sxbA4+yhdJ9+xVBdKYlvXLWpeMauv+gg1GLUml5t8jgMe68
         55E2E+pt4lQNL43f/XQx605AqWcPvfFfPS9dFEJIAtUv/TzZ6QvIN2No8tKWx6Hh6UDi
         5MSOCw8D8sAu8W570HmZU7qgcOFUVrtE8G7LWVcPwBdp7Tr0tqLaw15O5LlBOp87iyXY
         UP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYdHJswDeDT3txuf8JK/w+986tI61N01JzHQOoC+jnU=;
        b=5xL17uxjHsBf8KtbbWxulIUCIgz9F7TUS2uIvdUqM42dDkibxH4sv2twkOA96PiQZD
         OAkQksj/2eCdRuoETm7RBYDvRrG0x1GxdGs1dOe9Y525vVT522cq2qjm9FgxLlWc2+B+
         GwaR1dkGjj2tcQ3WkysLmq+vXN8yX6kN9POjai0Xa2LFw7rbWVAplhApFeH3Z3TWULYQ
         wcU1WAm5c83WFTSaFNws01f30POKMIUuHaqcQDK3aFBOod4oZJ7WWk8V8e/BGr93OIoi
         6yS2wltQc9/loqDU6CyDdgtSdEVsrZBMHhfdNYeFUvDIwuINsk1hP4GqqGdDTD9N5toa
         yRBw==
X-Gm-Message-State: ACrzQf2eNxVhsdRkugCJYb1qkDCauRLgEVfao0MnYlRKuFw9MvsUL9SY
        4obz2f3TZ5S//CyJqKfPty4=
X-Google-Smtp-Source: AMsMyM7OX51d9S1r13lEiI4F7DiaNTNLGHVFhzmJa4PWwH5gjRXGrlYR+119nzng5vyUZSAFHDPSTw==
X-Received: by 2002:a17:906:5a5b:b0:7a6:cbc7:4ca1 with SMTP id my27-20020a1709065a5b00b007a6cbc74ca1mr49681321ejc.544.1667853636915;
        Mon, 07 Nov 2022 12:40:36 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id s14-20020a170906960e00b007803083a36asm3868053ejx.115.2022.11.07.12.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:40:36 -0800 (PST)
Date:   Mon, 7 Nov 2022 22:40:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] net: dsa: tag_mtk: assign per-port queues
Message-ID: <20221107204034.bwbhyhahku4m2xdd@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-5-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107185452.90711-5-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix,

On Mon, Nov 07, 2022 at 07:54:43PM +0100, Felix Fietkau wrote:
> Keeps traffic sent to the switch within link speed limits
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---

Do you have a patch 00/14 that explains what you're up to? I'm only
copied on 05/14 and 10/14, hard to get an idea.
