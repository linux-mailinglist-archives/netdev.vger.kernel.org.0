Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA981FFE85
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgFRXT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFRXTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:19:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7FEC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 16:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=dui5/mlHJxerULQJAPyoRJAKnj05/yNH5FqsYDl1WCM=; b=A8SOj+0n9QuzrOTNvFiXIyim14
        XFSOhNUigi4tQaUuZu42q23BLTvbp6CXTX6+gqUBe6yXKKdFgI5rqMnYDThif3uM69MnZKjXPHRdP
        MjqxL95VQb4ml4JXg/CXD9N8VfGGsUtboQ4VqpYazKM1gXfpjJWWHTxILTT9nZkVKUi5z+dDZEjhg
        NH8kxRvZWwBfZ7uQy64isW6BU/tcirwkvIH5poIGbokcELHj5m9TNDOyVFuVwKuULmaz9qnOBBU6d
        X4ZxrTiZ7MIYB6iaN5RXCe/K1RpC/FR/WTAUC1PCnvIpcmbU+uIa2G0jRA1luyWJ+qe9HUf86rLgl
        cwVZ0kKg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jm3oU-0000wO-Sk; Thu, 18 Jun 2020 23:19:19 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: af_decnet.c: missing semi-colon and/or indentation?
Message-ID: <4649af05-ac31-4c57-a895-39866504b5fb@infradead.org>
Date:   Thu, 18 Jun 2020 16:19:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please see lines 1250-1251.


	case TIOCINQ:
		lock_sock(sk);
		skb = skb_peek(&scp->other_receive_queue);
		if (skb) {
			amount = skb->len;
		} else {
			skb_queue_walk(&sk->sk_receive_queue, skb)     <<<<<
				amount += skb->len;                    <<<<<
		}
		release_sock(sk);
		err = put_user(amount, (int __user *)arg);
		break;



or is this some kind of GCC nested function magic?


commit bec571ec762a4cf855ad4446f833086fc154b60e
Author: David S. Miller <davem@davemloft.net>
Date:   Thu May 28 16:43:52 2009 -0700

    decnet: Use SKB queue and list helpers instead of doing it by-hand.



thanks.
-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
