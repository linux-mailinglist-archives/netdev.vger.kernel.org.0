Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD65C3BF7BD
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 11:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhGHJqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 05:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhGHJqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 05:46:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB05C061574;
        Thu,  8 Jul 2021 02:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=XHXCY6ZWXWOPegX8TQxkuSJ6srl8fMLRk8je2hHJc6I=;
        t=1625737419; x=1626947019; b=jird/N4hMXE7n2PoKmS0IoDaYEz7PHwKklqJ3nRnht2wxjQ
        tr4eh8e/F6wjCFMdpc3CHgmJ2+wmzBazDpPJWUK+KSHCemyeSZj83vzWfZ0xdOyJDCj3s6vrKXjZy
        W0Nx9ee+zSGk+RB7MliEzAloMZ4mONIb84u7KKz732OZ9Y0UieRGKw6qa1bPE6r/xVnE/iW9xG8Vc
        EhcXL8AwbIAt4Qy6q0VSChGD+V8SAm9CQtfzeblbVC9zrE5iygS0aS69KmT1cUikbmjbd3asLnt+m
        kZdy4cXUV1m/bN2KXdOGw+XhPFu8F0D/G5sUfTTYte1JxSoFHPB+nDBznp9K2O3g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m1QZ2-00H1iq-B3; Thu, 08 Jul 2021 11:43:24 +0200
Message-ID: <3c160d187382677abe40606a6a88ddac0809c328.camel@sipsolutions.net>
Subject: Re: [PATCH v2] net: rtnetlink: Fix rtnl_dereference may be return
 NULL
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org, ryazanov.s.a@gmail.com, avagin@gmail.com,
        vladimir.oltean@nxp.com, cong.wang@bytedance.com,
        roopa@cumulusnetworks.com, zhudi21@huawei.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 08 Jul 2021 11:43:20 +0200
In-Reply-To: <20210708092936.20044-1-yajun.deng@linux.dev>
References: <20210708092936.20044-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-08 at 17:29 +0800, Yajun Deng wrote:
> The value 'link' may be NULL in rtnl_unregister(), this leads to
> kfree_rcu(NULL, xxx), so add this case handling.
> 

I don't see how. It would require the caller to unregister something
they never registered. That would be a bug there, but I don't see that
it's very useful to actually be defensive about bugs there.

>  And modify the return
> value to 'void' in rtnl_unregister(). there is no case using it.
> 
> Fixes: addf9b90de22 (net: rtnetlink: use rcu to free rtnl message handlers)
> Fixes: 51e13685bd93 (rtnetlink: RCU-annotate both dimensions of rtnl_msg_handlers)

It certainly fixes nothing in those patches.

johannes

