Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8C95B26A4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiIHTTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiIHTT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:19:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5805F86
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 12:19:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oWN3d-0007cX-99; Thu, 08 Sep 2022 21:19:25 +0200
Date:   Thu, 8 Sep 2022 21:19:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: b118509076b3 (probably) breaks my firewall
Message-ID: <20220908191925.GB16543@breakpoint.cc>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Clayton <chris2553@googlemail.com> wrote:
> Just a heads up and a question...
> 
> I've pulled the latest and greatest from Linus' tree and built and installed the kernel. git describe gives
> v6.0-rc4-126-g26b1224903b3.
> 
> I find that my firewall is broken because /proc/sys/net/netfilter/nf_conntrack_helper no longer exists. It existed on an
> -rc4 kernel. Are changes like this supposed to be introduced at this stage of the -rc cycle?

The problem is that the default-autoassign (nf_conntrack_helper=1) has
side effects that most people are not aware of.

The bug that propmpted this toggle from getting axed was that the irc (dcc) helper allowed
a remote client to create a port forwarding to the local client.
