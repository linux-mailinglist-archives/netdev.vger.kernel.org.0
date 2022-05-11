Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A1352383E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344401AbiEKQLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiEKQLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:11:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675E03055E
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 025F761BD2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAAEC340EE;
        Wed, 11 May 2022 16:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652285498;
        bh=N00hREsH/v71ujk9GtrnvWOkEvPIR1uio7dyU8IAhUQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GAw7BE6OoQvz5SVztZsxXMxCoR/cuUthf/Dm9iutVKTJlg34cxO3gbvqEKvUZhK/m
         BKxMOFil407Qin4xjRaDSvPqvE1ZC9Wte/mRJtOA7TEH8MZHOiRUWnn3jg0Bnou2Bq
         BkxLrn0DKY/XOgyD2aJecNpIQhPJWI7gwUkd2SEbK7e4Iw6KKw/aQgOguepPsxQDek
         ER59LSkU+jat5RDYsL8FK/QRLaKeCZYIdiPjvrvJwa/STT3k9r7NunWn5qeDFC4wO3
         6V9jmJV39ytRa2oxifW78+8fwe2RFpTxIepU1Z1EDCsgLumOK9e1+LBuQaElfPzxuK
         XYdk9enZyyweQ==
Date:   Wed, 11 May 2022 09:11:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     alexandru.ardelean@analog.com, alvaro.karsz@solid-run.com,
        davem@davemloft.net, edumazet@google.com, josua@solid-run.com,
        krzysztof.kozlowski+dt@linaro.org, michael.hennerich@analog.com,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Message-ID: <20220511091136.34dade9b@kernel.org>
In-Reply-To: <20220511125855.3708961-1-michael@walle.cc>
References: <20220510133928.6a0710dd@kernel.org>
        <20220511125855.3708961-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 14:58:55 +0200 Michael Walle wrote:
> > I'm still not convinced that exposing the free running vs recovered
> > distinction from the start is a good idea. Intuitively it'd seem that
> > it's better to use the recovered clock to feed the wire side of the MAC,
> > this patch set uses the free running. So I'd personally strip the last 
> > part off and add it later if needed.  
> 
> FWIW, the recovered clock only works if there is a link. AFAIR on the
> AR8031 you can have the free-running one enabled even if there is no
> link, which might sometimes be useful.

Is that true for all PHYs? I've seen "larger" devices mention holdover
or some other form of automatic fallback in the DPLL if input clock is
lost. I thought that's the case here, too:

> > > +      The phy can also automatically switch between the reference and the
> > > +      respective 125MHz clocks based on its internal state.
