Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9864452681F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380816AbiEMRSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378778AbiEMRSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE490369F5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E539B830E5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBF9C34100;
        Fri, 13 May 2022 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652462299;
        bh=zIcDyWOiRIlQvvATGGpbQ+T7ymGZ8Ill1E9AQiIaJOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mhxyNLSMD1SryhkZ65IjyGkU6386AZ5onVz5vMmEbPOdLX7/AZHNHVjkUz7EcBBrh
         djAs6BmfWsBf5rMZv05teCGkf91/QVL+D9xFshp2ITmUjTQTVFGLhYbeKWcBTXmbSe
         CbENebuyTIYD5J+fadXigcV5xRTJXWP4Ma8KGasajZ+3XDRelBcoFUW6PCHAZKrgll
         5Pi6El4iMgKsleuK00qqmrkhhTead/Phwtep492EpK3Mp/i7WhqtnBTApQelpiS/Ki
         uSrm6fSlWVNqGxNwWzuZeEEipM5VVIdMjiKQeQxiiKHPhIL1OFBPYQrnLtM88bobd5
         8PsF5UyM65qVw==
Date:   Fri, 13 May 2022 10:18:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] inet: add READ_ONCE(sk->sk_bound_dev_if) in
 INET_MATCH()
Message-ID: <20220513101817.3f001a85@kernel.org>
In-Reply-To: <CANn89i+V+ZW3qjb=OycX5vsEdcymdsn9-HF379QFqL3T2_a0Ag@mail.gmail.com>
References: <20220512165601.2326659-1-eric.dumazet@gmail.com>
        <09dae83a-b716-3a0c-cc18-39e6e9afa6cc@hartkopp.net>
        <CANn89i+V+ZW3qjb=OycX5vsEdcymdsn9-HF379QFqL3T2_a0Ag@mail.gmail.com>
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

On Thu, 12 May 2022 10:14:23 -0700 Eric Dumazet wrote:
> On Thu, May 12, 2022 at 10:02 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> 
> > When you convert the #define into an inline function, wouldn't it be
> > more natural to name it lower caps?
> >
> > static inline bool inet_match(struct net *net, ... )  
> 
> Sure, it is only a matter for us to remember all the past/present
> names, based on implementation details, especially at backport times.

We can apply as is if you prefer, but I'm not sure I follow TBH.
The prototype (arguments) of the function/macro have changed so there 
is nothing to be gained from not changing the name AFAICT, no?
