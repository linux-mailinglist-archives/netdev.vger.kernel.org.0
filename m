Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE047604C8D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiJSQA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiJSQAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:00:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B946474
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 08:59:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1BF7B824F4
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2C6C433D6;
        Wed, 19 Oct 2022 15:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666195152;
        bh=u7cp2OyVXBmm4KMgDXWSPKNpyGhslbvwjI9yr/eIMfg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=czOE0/6Rn11TT4/QIq6ZUEojKq0818f7ejqU9W+ZMrfBuE7k4kGZfNzNwQRt3Vw0N
         EuOaQZk1Tbgo3vdrPG0MHVsM/yJcWUigPVI2TeVJxuvI7KvpeFa8fvT5QhZV+11E79
         3CvOoDr8JxggFMUWucdoydn1yfgG96q31EtLNCGi3BpWGFfCw5uNNKNuBSZ9bCPPTt
         uORpVm0LqOJ97YW+uueAi2hyW2PnyPbR34uvpuXkXDOlK2bdf2ha+DBRMEkDEq1XKt
         XUPPjC5bPwGURTrq1ZRWxAV3oUjDw8LG1rqxYxJFXZ/DchqlhCWd4WllxmKSxf3VAX
         PdUot49EvmkdA==
Date:   Wed, 19 Oct 2022 08:59:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 01/13] genetlink: refactor the cmd <> policy
 mapping dump
Message-ID: <20221019085911.78c61724@kernel.org>
In-Reply-To: <68eaa8749d8ad971b34cce82f4306e77ccccbf3a.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-2-kuba@kernel.org>
        <68eaa8749d8ad971b34cce82f4306e77ccccbf3a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 09:50:16 +0200 Johannes Berg wrote:
> > +			if (ctrl_dumppolicy_put_op(skb, cb, &op))
> > +				return skb->len;
> > +
> > +			ctx->opidx = genl_get_cmd_cnt(ctx->rt);  
> 
> This (now without a comment that you removed rather than changed), still
> strikes me as odd.
> 
> I guess if we add a comment /* don't enter the loop below */ that'd be
> nicer, but I feel maybe putting the loop into the else instead would be
> nicer?

The comment got eaten in rebases, it comes back in patch 10 apparently..
I'll put it back in v2.
