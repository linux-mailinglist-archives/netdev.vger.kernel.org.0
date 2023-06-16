Return-Path: <netdev+bounces-11344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F2A3732AB6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50A931C20F5E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5520DC8E5;
	Fri, 16 Jun 2023 08:58:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AC963D5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:58:34 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F1530D7;
	Fri, 16 Jun 2023 01:58:30 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-98276e2a4bbso68164166b.0;
        Fri, 16 Jun 2023 01:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686905908; x=1689497908;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WqL9oiXQZlu9tr63nbdFWbanVHkBmc6TZcy501+z5QY=;
        b=VbfedRmdNOpDI0Wgyg9ZuO89iFubmefURribGIrux0BjGwffpJAtdUuUuF5vrf74wt
         mdZMAjSSwoUbAKkDxsbHzn/DFY0UmoZ0TXBkUFU7rPL2yUSTTZQfwujiGgKNaZl04GwY
         PF9GvPC6FzQQmIxMBZNvPL1KCHr/tZLb5RsGv6uHZZW75TGeuqQ+YBQ7EcF1E8F+mMHM
         LNejAbyX53NPvguRoxACJMJSSFSw/RhbiDxIDUMpBwFb0rUySVxl/IgsnTAdYyNSFuxB
         hKIDFbJezvjpjVSlyx/SxRk6oS8VV5YeZ+AdnbZ+6EFbMg25M4/L3xSW3r+eDVTDUiEA
         3lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686905908; x=1689497908;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqL9oiXQZlu9tr63nbdFWbanVHkBmc6TZcy501+z5QY=;
        b=h61pYr3EbTf9jyHmd0oUaIxXMXlShd4nl+mCOzLskx6ABacfZEBmAJo6FUtZ0P5XOt
         QttP/M3/+RSX5C4h02mkByYPFfxPKLZWqOF7IAUr4IjrXR59tap7W4KfNz+l4vs9yD2i
         JehfCg/Y8stJSNFPBcZisdqWy/Hmc36IK9Nj4GfxWjMhgEPnnKoBbs70h/STH3LxJ4dD
         cpuvjr7gqFBJu35vE/SjvfhRRva0DKowB9cBe+pylWzcxI6GXhdqCYOOhhncXxoMY/uE
         /Q9fhjj5W6jKQh1Tyz7rM1EdjOj3WloS5yoFgXNv3tNASfwMR5PbdG5F+eMTH55EeEi3
         cbXA==
X-Gm-Message-State: AC+VfDxGskg0Xi8uv+mWEqbYD+1fhEsdqu4FlUQsU1AIF1LJdUMX73fo
	VUyCpcAMtLGNCRvdmRiXHhY=
X-Google-Smtp-Source: ACHHUZ61wh/bWNczJw7w6o9Aca2HL0E434nU0acwtPx0mh6i74KKobpHcFNWP4W1b1VpOaU7JH+fJA==
X-Received: by 2002:a17:907:3e16:b0:978:a186:464f with SMTP id hp22-20020a1709073e1600b00978a186464fmr1545011ejc.39.1686905908381;
        Fri, 16 Jun 2023 01:58:28 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bi9-20020a170906a24900b009745417ca38sm10458757ejb.21.2023.06.16.01.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 01:58:28 -0700 (PDT)
Date: Fri, 16 Jun 2023 11:58:25 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?546L5piOLei9r+S7tuW6leWxguaKgOacr+mDqA==?= <machel@vivo.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"opensource.kernel" <opensource.kernel@vivo.com>
Subject: Re: =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggdjFdIGRyaXZlcnM6bmV0OmRzYTpG?=
 =?utf-8?Q?ix?= resource leaks in fwnode_for_each_child_node() loops
Message-ID: <20230616085825.7tuz4ryp5dn7zims@skbuf>
References: <20230615070512.6634-1-machel@vivo.com>
 <ZIsME1gwEWEyyN1o@corigine.com>
 <20230615203649.amziv2aqzi3vishu@skbuf>
 <PS1PR0601MB3737C84D2AF397AB8B4E9207BD58A@PS1PR0601MB3737.apcprd06.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PS1PR0601MB3737C84D2AF397AB8B4E9207BD58A@PS1PR0601MB3737.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:36:43AM +0000, 王明-软件底层技术部 wrote:
> Okay，thank you ,I will do as you suggest.

And because that patch is in net-next.git and not (yet) in net.git, the
prefix should be "[PATCH v2 net-next]".

