Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08611F8CC
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfEOQlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:41:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEOQlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:41:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9493D14E75B9F;
        Wed, 15 May 2019 09:41:50 -0700 (PDT)
Date:   Wed, 15 May 2019 09:41:50 -0700 (PDT)
Message-Id: <20190515.094150.697892727321848072.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net] tcp: do not recycle cloned skbs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANn89i+2OuujyrwxR_n=VBwNHABai3B+0tti_jMkMU4UD1Wn8A@mail.gmail.com>
References: <20190515161015.16115-1-edumazet@google.com>
        <20190515.092412.1272864626450901775.davem@davemloft.net>
        <CANn89i+2OuujyrwxR_n=VBwNHABai3B+0tti_jMkMU4UD1Wn8A@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 May 2019 09:41:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 May 2019 09:26:54 -0700

> On Wed, May 15, 2019 at 9:24 AM David Miller <davem@davemloft.net> wrote:
>>
>> From: Eric Dumazet <edumazet@google.com>
>> Date: Wed, 15 May 2019 09:10:15 -0700
>>
>> > It is illegal to change arbitrary fields in skb_shared_info if the
>> > skb is cloned.
>> >
>> > Before calling skb_zcopy_clear() we need to ensure this rule,
>> > therefore we need to move the test from sk_stream_alloc_skb()
>> > to sk_wmem_free_skb()
>> >
>> > Fixes: 4f661542a402 ("tcp: fix zerocopy and notsent_lowat issues")
>> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>> > Diagnosed-by: Willem de Bruijn <willemb@google.com>
>>
>> Applied and queued up for -stable.
> 
> Note the patch targets current net tree, but does not need to be
> backported to older kernel versions
> (4f661542a402 is only in upcoming 5.2)

Doesn't it fix a fix for something in 5.0?
