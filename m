Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548895BF248
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIUAk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIUAk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:40:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4D14362B;
        Tue, 20 Sep 2022 17:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F788B82DC4;
        Wed, 21 Sep 2022 00:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE9BC433C1;
        Wed, 21 Sep 2022 00:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663720853;
        bh=MWlEw1UNRXi3JxOk0I3huE7q55AKj+oZp9V5gN/1Zdc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I++YjRKdI0zD1tkCO51gbFlBwiSDBKlfCD6c7OYxEsTSXyTFtRMPi+/r4UQP6GQ10
         M/cgyGPdypYcGOLi7hxiIdC0AUhbmjFqOYsICzw2DNxU1VT1bdDb/+5uU/3dKIu6p3
         gP3xPJMTVQtpiu+2QvMA0EOzf24JeNJZKJBnlwL3P8lsO3sOx9qbg9FvvX4us2X4rE
         OMqrSumpDVXvUL3N5y4CTV0o4X5Va4IC8UVcfjd8SmMU7mik7JPWJ4tIXY/Rvs9ZCY
         ynOZDa7jL34aiurlNB9GrLQaZUHj30/bZzvgZ8w/F7RQGsongu1mZIrEVVBKqVpo1k
         qQHXrY5jD4vEQ==
Date:   Tue, 20 Sep 2022 17:40:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] udp: Refactor udp_read_skb()
Message-ID: <20220920174052.47d9858b@kernel.org>
In-Reply-To: <20220920173859.6137f9e9@kernel.org>
References: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
        <20220920173859.6137f9e9@kernel.org>
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

On Tue, 20 Sep 2022 17:38:59 -0700 Jakub Kicinski wrote:
> On Wed, 14 Sep 2022 01:15:30 -0700 Peilin Ye wrote:
> > Delete the unnecessary while loop in udp_read_skb() for readability.
> > Additionally, since recv_actor() cannot return a value greater than
> > skb->len (see sk_psock_verdict_recv()), remove the redundant check.  
> 
> These don't apply cleanly, please rebase?

Ah, it's the WARN_ON_ONCE() change. In that case please resend after
net is merged into net-next (Thu evening).
