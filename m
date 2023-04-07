Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428436DAEDF
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjDGOgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjDGOgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:36:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07736EAB
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 487F164BD3
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A38C433D2;
        Fri,  7 Apr 2023 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680878162;
        bh=qRdMt0MxCAp9G7jRbbzA/fr9Gwc+XvTzAb3Aw9xiLb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UKvzeadEgkuGRWmodxeKCH44L8p7JrDSdTDtLk0wkd1/GkWWbvgQyZXfXhEfMHjgy
         lx+4h4pS02XSM/IycYW/4nhRz6WfqdtCD8NCJgI12gZ12+lW8sfy2UwJvOaO6qkoP/
         2ePg3O3VXiniVKPzTlGcMxtwSyUo3phvQFso0IcmYtykJLj9/HUfgRf3eWeVcQQRD6
         xgt/E1VAUff9zFJgbrbZqlXnC/uP2XuB1+EBG1/nbQGAgWM04kXVP99oirUKLxJXdA
         VRQ5fpgTxEd1ClhFw0VoNTPMKeiKQI6PGv7hhlVfqHdQmD0Trr1THfsv/ktWxUvBx5
         grxbDoThJMJ+Q==
Date:   Fri, 7 Apr 2023 07:36:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next v4 6/7] bnxt: use new queue try_stop/try_wake
 macros
Message-ID: <20230407073601.36374c99@kernel.org>
In-Reply-To: <CANn89iJrBGSybMX1FqrhCEMWT3Nnz2=2+aStsbbwpWzKHjk51g@mail.gmail.com>
References: <20230407012536.273382-1-kuba@kernel.org>
        <20230407012536.273382-7-kuba@kernel.org>
        <CANn89iJrBGSybMX1FqrhCEMWT3Nnz2=2+aStsbbwpWzKHjk51g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 11:25:23 +0200 Eric Dumazet wrote:
> BTW, we should make sure the @desc argument of netif_txq_try_stop() is
> correctly implemented.
> I often see drivers with either buggy or not efficient implementation.

What do you have in mind?

Should we update the sample code in driver.rst further?
There is outdated sample code there:
https://www.kernel.org/doc/html/next/networking/driver.html
but IDK if people read the documentation :(
