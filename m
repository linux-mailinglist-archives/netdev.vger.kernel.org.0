Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB3658A04A
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbiHDSJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiHDSJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:09:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF5B6BD6D;
        Thu,  4 Aug 2022 11:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41008B82659;
        Thu,  4 Aug 2022 18:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E61DC433D6;
        Thu,  4 Aug 2022 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659636587;
        bh=BCuL3wPihFZ4RUzoccGQX5On9lEl6ElteDBDW7ANNsM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mwTp9Mhxec4JRfepApvLoPZX27LJuI4/rVNS4bl8bcyjchZv6R07mAljpnWXc+nnY
         aXKYDb46s/IrEnaHJBF/Qwft4o9f9lPDP/y6vUfHvMod0plK7spQWi0N58c3HTM9j3
         oFFLmUdd+8rFp3RyLEZAVEov0wUruqsfTTHyxtjnNybI4mdrZfwnSUygtq7GjB0eoW
         bxkMoJ5pHmt/0Le+b757zXlLR08r6GzsAgbGX8U+SsIYSRXN6EWPPzUDx/duCgyg6+
         f17sfafaogbH7XLx8M+3xITmZTqjDeAIp8PsT1NIuu7Np7ns9bXWFbOe5Ei8WsdI+J
         bmQxg2a03G8bQ==
Date:   Thu, 4 Aug 2022 11:09:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Adel Abouchaev <adel.abushaev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC net-next 1/6] net: Documentation on QUIC kernel Tx crypto.
Message-ID: <20220804110945.08c5d58b@kernel.org>
In-Reply-To: <CANn89iJMCrLBbPPEnk2U7ja58AawCrDe01JmBStN9btBPQQgOQ@mail.gmail.com>
References: <adel.abushaev@gmail.com>
        <20220803164045.3585187-1-adel.abushaev@gmail.com>
        <20220803164045.3585187-2-adel.abushaev@gmail.com>
        <Yuq9PMIfmX0UsYtL@lunn.ch>
        <4a757ba1-7b8e-6012-458e-217056eaee63@gmail.com>
        <Yuvl9uKX8z0dh5YY@lunn.ch>
        <7c42bf11-8a30-3220-9d52-34b46b68888f@gmail.com>
        <CANn89iJMCrLBbPPEnk2U7ja58AawCrDe01JmBStN9btBPQQgOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Aug 2022 10:00:37 -0700 Eric Dumazet wrote:
> On Thu, Aug 4, 2022 at 9:58 AM Adel Abouchaev <adel.abushaev@gmail.com> wrote:
> > Looking at
> > https://github.com/shemminger/iproute2/blob/main/misc/ss.c#L589 the ss.c
> > still uses proc/.
> 
> Only for legacy reasons.

That but in all honesty also the fact that a proc file is pretty easy
and self-describing while the historic netlink families are undocumented
code salads.

> ss -t for sure will use netlink first, then fallback to /proc
> 
> New counters should use netlink, please.

Just to be sure I'm not missing anything - we're talking about some 
new netlink, right? Is there an existing place for "overall prot family
stats" over netlink today?
