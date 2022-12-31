Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A2365A2A1
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 04:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiLaDzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 22:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLaDzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 22:55:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D864BC9C;
        Fri, 30 Dec 2022 19:55:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8D7AB8162C;
        Sat, 31 Dec 2022 03:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA4CC433EF;
        Sat, 31 Dec 2022 03:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672458930;
        bh=Pa1PYVoJoUZNt9IVRLhwAsdHtIKR1d2rvQTtv41uneE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kDaob7R5MJIEm/6MMBRzNcLBeopos02AnaOOY1AWl962V0JH7bjoW5uf6RczVV6JF
         u3DN1BbnGpyUeZheC2ziW18NyKTDDusOKI5tzMABqIwh6lejwdAFTIXHuYxhE4g+8F
         iJ/+FBmG7R7X8jx2nRjVAm0DYIS+0a13/6uIX8+ANCMRyKEBh3TFbioAJFYCMlvaNJ
         vCWovn3uEOOkAIOM+7CRwzK/2o1AcR9jrTcBabcRL70VNMvWqmRuMzR5igRj2jbHBt
         Eo8iOwnQ8I+aP23yuIJnDqVBrTB2gTFIMvTVl83xh8F6+j0Ov/sJPKK5A/Ma1D3818
         E0xHg6pZpV7dA==
Date:   Fri, 30 Dec 2022 19:55:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RESEND PATCH net v1] drivers/net/bonding/bond_3ad: return when
 there's no aggregator
Message-ID: <20221230195529.67a5266a@kernel.org>
In-Reply-To: <a09b374f-45e3-9228-4846-80f655cf3caa@yandex-team.ru>
References: <20221226084353.1914921-1-d-tatianin@yandex-team.ru>
        <20221229182227.5de48def@kernel.org>
        <a09b374f-45e3-9228-4846-80f655cf3caa@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Dec 2022 11:44:02 +0300 Daniil Tatianin wrote:
> On 12/30/22 5:22 AM, Jakub Kicinski wrote:
> > On Mon, 26 Dec 2022 11:43:53 +0300 Daniil Tatianin wrote:  
> >> Otherwise we would dereference a NULL aggregator pointer when calling
> >> __set_agg_ports_ready on the line below.  
> > 
> > Fixes tag, please?  
> Looks like this code was introduced with the initial git import.
> Would that still be useful?

yessir, the point is to let backporters know how far the bug goes.
The initial import is our local equivalent of infinity, for all
practical purposes.
