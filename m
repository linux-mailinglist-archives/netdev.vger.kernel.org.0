Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E339523386
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbiEKM7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242897AbiEKM7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:59:07 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D954D231CB7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:59:05 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6F64B22205;
        Wed, 11 May 2022 14:59:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1652273944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IPa8o79G+Y57/PkABDKBbqBz436TxwXzAFndjWwHSs0=;
        b=B/1LTxAEJRv0X8VkvVClYunR2My15Q5N3vejrwphwSJU4oUNvN5i6zkF3yfaQ3dANc4DbR
        /Lqi0qxLnt9kdJBKp9zRfXknIv+Lr7bS2WoWAskeyo+u5jAh8lpIDNLAeZfIhxmKXl3byL
        dUbGE+Pb15ZONHNRvWf4wXfwfZliTFs=
From:   Michael Walle <michael@walle.cc>
To:     kuba@kernel.org
Cc:     alexandru.ardelean@analog.com, alvaro.karsz@solid-run.com,
        davem@davemloft.net, edumazet@google.com, josua@solid-run.com,
        krzysztof.kozlowski+dt@linaro.org, michael.hennerich@analog.com,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Date:   Wed, 11 May 2022 14:58:55 +0200
Message-Id: <20220511125855.3708961-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220510133928.6a0710dd@kernel.org>
References: <20220510133928.6a0710dd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon,  9 May 2022 17:36:33 +0300 Josua Mayer wrote:
> > +  adi,phy-output-clock:
> > +    description: Select clock output on GP_CLK pin. Three clocks are available:
> > +      A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
> > +      The phy can also automatically switch between the reference and the
> > +      respective 125MHz clocks based on its internal state.
> > +    $ref: /schemas/types.yaml#/definitions/string
> > +    enum:
> > +      - 25mhz-reference
> > +      - 125mhz-free-running
> > +      - 125mhz-recovered
> > +      - adaptive-free-running
> > +      - adaptive-recovered
> 
> I'm still not convinced that exposing the free running vs recovered
> distinction from the start is a good idea. Intuitively it'd seem that
> it's better to use the recovered clock to feed the wire side of the MAC,
> this patch set uses the free running. So I'd personally strip the last 
> part off and add it later if needed.

FWIW, the recovered clock only works if there is a link. AFAIR on the
AR8031 you can have the free-running one enabled even if there is no
link, which might sometimes be useful.

-michael
