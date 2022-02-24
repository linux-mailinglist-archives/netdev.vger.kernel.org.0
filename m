Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0D74C2328
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiBXEzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiBXEzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:55:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0C52325E2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCAABB823FA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 04:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E153C340E9;
        Thu, 24 Feb 2022 04:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645678512;
        bh=wo8LS7gWeE0HTFx1noRqiArdxG5VrRuGDVI+2zYSn3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YOAOMxSJUH3v0zxJpAIhvH3OEheOarwzVarAzZkMO3VhoCFdS52V1bkBYhdS2IHqu
         xpI85cW3Wb0ji80bxCDQFFIZbMSONkyObInWjpVCQCkFundJOjyavR10upfnwNL4I5
         gcqAL6h6509L/jtclN7rU4cN0oiR1X90EANy+kPrIVwmq9p94iRsmr8N9bzS5MfwSp
         iyS0zabU3BUXf8UC9vhteuIfil8XTFFIPnbwtX3QV5frORWsGJVaQAqTImCIRG8BKa
         T24HFOmPreknTvarYgIwxCQ2MLKl9DSuTHBEcjtML1BlnU96OGQhJKsd8KGjFzy9xQ
         OWWS6yBjcs9pw==
Date:   Wed, 23 Feb 2022 20:55:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v7 6/8] net/funeth: add the data path
Message-ID: <20220223205510.0bd583cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218234536.9810-7-dmichail@fungible.com>
References: <20220218234536.9810-1-dmichail@fungible.com>
        <20220218234536.9810-7-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 15:45:34 -0800 Dimitris Michailidis wrote:
> +	if (unlikely(skb->len < FUN_TX_MIN_LEN)) {
> +		FUN_QSTAT_INC(q, tx_len_err);
> +		return 0;
> +	}

Is there something in the standards that says 32 byte frames are
invalid? __skb_put_padto() is your friend.
