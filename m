Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6CF5F346D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiJCRZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJCRZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:25:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C4419C23
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CB93B811C2
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB71C433C1;
        Mon,  3 Oct 2022 17:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664817922;
        bh=jHT0rusEQYJdwxpkBANcSQRZVGu7lBKag25lZ5m2Des=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bk8K0MGX3oWNVxRr5RD+giNmBU/TrsRabHkUi/QTed/FZRkwLmIlj70SJJZu4rlwf
         AB+riajVZB9EScdIZAW0aIWUosPrHsei1fqrNligEgmVIXEAeNVs19SCP1wrLjDYBl
         5sLPu2/HXuWGr73Zcb1TWY59FKblbTa+QhNtzZr+TYEbiLOqI1F4Bp7c23gx676dS3
         iCUXdDV/sksJgovu2+d+hi76bade/BQJQeB25aEm3juJ8e3DnAiFdoEP22KeOQfP7l
         RjaDMWPE0KxUMlx61mfnLdLeOl+2F8SL7mvJ0xYUAAlz6j2R370lJ5QI0LLUGGEFdQ
         rRqCbx2rngWyA==
Date:   Mon, 3 Oct 2022 10:25:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable
 contexts
Message-ID: <20221003102520.75fc51b4@kernel.org>
In-Reply-To: <YzjCzGGGE3WUsQr0@zx2c4.com>
References: <20221001205102.2319658-1-eric.dumazet@gmail.com>
        <YzjCzGGGE3WUsQr0@zx2c4.com>
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

On Sun, 2 Oct 2022 00:44:28 +0200 Jason A. Donenfeld wrote:
> So instead, why not just branch on whether or not we can sleep here, if
> that can be worked out dynamically? 

IDK if we can dynamically work out if _all_ _possible_ callers are 
in a specific context, can we?

> If not, and if you really do need two sets of macros and functions,
> at least you can call the new one something other than "slow"? Maybe
> something about being _SLEEPABLE() instead?

+1 for s/SLOW/SLEEPABLE/. I was about to suggest s/SLOW/TASK/.
But I guess it's already applied..
