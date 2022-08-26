Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A845A1D73
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243915AbiHZADT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiHZADS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:03:18 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A75C6E83;
        Thu, 25 Aug 2022 17:03:15 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 27Q02fvZ2970585;
        Fri, 26 Aug 2022 02:02:41 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 27Q02fvZ2970585
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1661472162;
        bh=mqvVyInY/7AGgRQYmR5e1nAFhFPnSHj33uQc7NP3oAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tx9YeeP7HlYrnDe0Dyf9tO2NyKszl0KRLv8lVPcM8JH9FuoZjDk3VnAmAr8PBsq6K
         fqdlHe441DaA/Amm+npTv8BZJl0CagOALNSnQXxC1gmKW2Vw0TEGdlL2GIqw78u3zf
         w0+GdQ0O1fubipvN+XH04CVSLQFfF986q0VeIf0k=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 27Q02eOq2970584;
        Fri, 26 Aug 2022 02:02:40 +0200
Date:   Fri, 26 Aug 2022 02:02:40 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-hams@vger.kernel.org,
        Bernard <bernard.f6bvp@gmail.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Thomas Osterried <thomas@osterried.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 net 1/1] rose: check NULL rose_loopback_neigh->loopback
Message-ID: <YwgNoB2DXdx2+gLI@electric-eye.fr.zoreil.com>
References: <Yv2BhXInteHP7eJm@electric-eye.fr.zoreil.com>
 <CANn89i+3jZLjy0iYDo78QhQ5STt2X6B2zxX0rY-xOdqmy9WFSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+3jZLjy0iYDo78QhQ5STt2X6B2zxX0rY-xOdqmy9WFSA@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> :
[...]
> ok but then the original crash/bug reappears....

When the fuzzer runs, the system does not notice that something goes
wrong until rose_find_listener() returns NULL in rose_rx_call_request
whereas Bernard's connect passes this test.

Testing both sk == NULL and !neigh->dev after rose_find_listener may
work but it looks like an ugly bandaid.

Good night.

-- 
Ueimor
