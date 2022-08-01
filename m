Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36582587155
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiHATVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiHATVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:21:41 -0400
X-Greylist: delayed 533 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Aug 2022 12:21:39 PDT
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C453892;
        Mon,  1 Aug 2022 12:21:39 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id DC94130B294F;
        Mon,  1 Aug 2022 21:12:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=3F52n
        xY/tmh9PZSV7vW/mnbDTdP8zzNslKlWQPThCYU=; b=CHH45DlE4nR+ZlgCvTtbJ
        Cq/aGpKN9C9JtSPYDiAq7/qeDnYjDcfyd3re2wiT5SI/FmjsvYMkF8+XloJFIm05
        VptaBDd3oMivohzia7+wNj4mAlbvxVsDnWpwHtOfgOEO8YQCX5ghTHBwVt70/6PZ
        /qNMoxTl2bteZK/G+CQEBmaStY12P57hZIZRsLcBDrxCFqbVlaDmrMn8RF1hSicR
        +B1zEH6CajkA938TYajrlWwTDI7xW30/FMk8ppDboOQcR8vBYZEXZyr7DH/Gwvl3
        fpC2AgulXOIY7ITGu61NYn1F4grh9DxP+9TcOTcKNqb3zrNNW6E76+iaRjcK/6TA
        w==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 8118E30AE002;
        Mon,  1 Aug 2022 21:12:44 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 271JCiHi007731;
        Mon, 1 Aug 2022 21:12:44 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 271JCiIL007730;
        Mon, 1 Aug 2022 21:12:44 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: Re: [PATCH v2 3/3] doc: ctucanfd: RX frames timestamping for platform devices
Date:   Mon, 1 Aug 2022 21:12:36 +0200
User-Agent: KMail/1.9.10
Cc:     Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <20220801184656.702930-4-matej.vasilevski@seznam.cz>
In-Reply-To: <20220801184656.702930-4-matej.vasilevski@seznam.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202208012112.36751.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Matej Vasilevski,

thanks much for the work

On Monday 01 of August 2022 20:46:56 Matej Vasilevski wrote:
> Update the section about timestamping RX frames with instructions
> how to enable it.
>
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

