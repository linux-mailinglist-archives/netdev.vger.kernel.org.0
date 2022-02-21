Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEAF4BED2D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 23:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbiBUWY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 17:24:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiBUWY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 17:24:59 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C6F23BE4;
        Mon, 21 Feb 2022 14:24:34 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3D732C01C; Mon, 21 Feb 2022 23:24:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1645482270; bh=YIY6TJhRnXEVzCDf5M3a63Q44e12FNrwl3WIohQXR6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZ1I+PfvzXczBl8nwUrmsd0FLqkROaXt/6wl55kJmu37yoy/rQwiwmnDxg39pmrLp
         d5J5YLkBNvrUQfagkvm/Fzt8mpKGT8+7EKGo++HeTBrfks8FAaY/6SrmIn5684/1+5
         1YVzSrAnXR6a7syeny4j/rbgKhXlyIZsgzTFVL0XVZ4WFF2wdHVbECZ73WSOTKmFSv
         H5sfOvKlHLX0U1Z+ZCsm5pS3jWD5A/KhyXarpSgH0dP41iCnTQp6o0bjEgyZgYRqiw
         /AmTyyBUSB70Zu/Vl/DIv6Ei/NLEJto9o8l9LRUwRgzJm6fYXzKAd0lcOyinYqyHBl
         doSF2otKJ0A5A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 08083C009;
        Mon, 21 Feb 2022 23:24:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1645482269; bh=YIY6TJhRnXEVzCDf5M3a63Q44e12FNrwl3WIohQXR6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KGbTalYgnx0afizMcFdjhLMVpS/+ImEnTco4kas/K98wbkYpeZPvEYQyM1Fbp8WBo
         WzhdhGUx5dJFirSA9nS0Goo6rN3l2LTWDXQ79n+LNY4u9KqCaWv5Q1aXjQTqV8L4hX
         nMv++5Hvq+OsaCodqNTJfRoEMjHGs9d7rjxpQW15RHqDm1fsZeSeAO1wTTo0mVvMmQ
         hcpefH2E3NDrZ+TCUkV68kixPAdG1r9jApkhACcclHCcl5L08MBMx8dpZLYMigDPmb
         nE8eDWunlF/ihThAkcRYZitIcbul9S9qeuYJSNQVJkeVqY62Xncru0F6jQMryqasfu
         Wk3ySpEhglltA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 80620b33;
        Mon, 21 Feb 2022 22:24:24 +0000 (UTC)
Date:   Tue, 22 Feb 2022 07:24:09 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH nf 2/5] netfilter: nf_tables_offload: incorrect flow
 offload action array size
Message-ID: <YhQRCVqtBfiHxChp@codewreck.org>
References: <20220221161757.250801-1-pablo@netfilter.org>
 <20220221161757.250801-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220221161757.250801-3-pablo@netfilter.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso wrote on Mon, Feb 21, 2022 at 05:17:54PM +0100:
> immediate verdict expression needs to allocate one slot in the flow offload
> action array, however, immediate data expression does not need to do so.
> 
> fwd and dup expression need to allocate one slot, this is missing.
> 
> Add a new offload_action interface to report if this expression needs to
> allocate one slot in the flow offload action array.
> 
> Fixes: be2861dc36d7 ("netfilter: nft_{fwd,dup}_netdev: add offload support")
> Reported-and-tested-by: Nick Gregory <Nick.Gregory@Sophos.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

FYI this patch has been reported as fixing an arbitrary oob write on
oss-security just now:
https://www.openwall.com/lists/oss-security/2022/02/21/2

So it might make sense to send it quickly to Linus and linux-stable for
immediate backport as it will get some attention...
The poster didn't say anything about coordinating this with security
handling people so it's safe to assume that wasn't done.


Thanks,
-- 
Dominique
