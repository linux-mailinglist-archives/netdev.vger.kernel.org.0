Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C82560D586
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiJYUbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiJYUbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:31:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DC93C8DB;
        Tue, 25 Oct 2022 13:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Kn41KvvRKURQXqaXHScfb81l81NkFHEbTZZ1F3tjXuQ=; b=MQLhrqp6VPmz5S+1m+8JNo3SMD
        BHl1ZU327KqsKiuCoyvfVJ1FJJitl8o7sf0nOfjM8qxUNdIOzMOegIy5iEiDiKkDW5Tq9ZE0z6zxW
        gXqCDn+Z2AQsqz1+4EdiNMQbuB39jGrFgR9/i9PJTzIYc49c1CGd8Pm/ZloAOH4cIGRouCsVV/IjA
        e+VRIyXxPpCRVhLLwudwIdfOJWIbqpSDwOrRxxSA1soLqGHZIv0m2Eu+v2PbSx3Px3q0C7sxhd6rH
        P6veK71gMreI9ehae64mDUu6HaIhHBbcLwPARRg/9NvlbkyJ8sJYWlTUxWDdypmP3rAqSpCRpR2Er
        SKuXgfbA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onQZi-006ObR-4W; Tue, 25 Oct 2022 20:31:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3E3C030017F;
        Tue, 25 Oct 2022 22:31:01 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DD30D2C450331; Tue, 25 Oct 2022 22:31:00 +0200 (CEST)
Date:   Tue, 25 Oct 2022 22:31:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>, dave.hansen@intel.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
Message-ID: <Y1hHhMczQlqi4DxD@hirez.programming.kicks-ass.net>
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
 <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
 <20221025193845.z7obsqotxi2yiwli@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025193845.z7obsqotxi2yiwli@desk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 12:38:45PM -0700, Pawan Gupta wrote:

> > I think the focus should be on finding the source sites, not protecting
> > the target sites. Where can an attacker control the register content and
> > have an indirect jump/call.
> 
> That is an interesting approach. I am wondering what mitigation can
> be applied at source?

Limiting the value ranges for example. Or straight up killing the values
if they go unused -- like how we clear the registers in entry.

> LFENCE before an indirect branch can greatly
> reduce the speculation window, but will not completely eliminate it.

Depends on the part; there's a whole bunch of parts where LFENCE is
sufficient.


