Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D884A680FC
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 21:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbfGNTP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 15:15:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfGNTP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 15:15:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A943E14E7AC4A;
        Sun, 14 Jul 2019 12:15:58 -0700 (PDT)
Date:   Sun, 14 Jul 2019 12:15:58 -0700 (PDT)
Message-Id: <20190714.121558.1681539034718383341.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     lorenzo.bianconi@redhat.com, netdev@vger.kernel.org,
        marek@cloudflare.com
Subject: Re: [PATCH net v2] net: neigh: fix multiple neigh timer scheduling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <26f58e35-f1f8-9543-819f-ef7f52da1e49@gmail.com>
References: <793a1166667e00a3553577e1505bebd435e22c88.1563041150.git.lorenzo.bianconi@redhat.com>
        <26f58e35-f1f8-9543-819f-ef7f52da1e49@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 14 Jul 2019 12:15:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Sun, 14 Jul 2019 07:58:19 -0600

> On 7/14/19 2:45 AM, Lorenzo Bianconi wrote:
>> @@ -1124,7 +1125,9 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>>  
>>  			atomic_set(&neigh->probes,
>>  				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
>> -			neigh->nud_state     = NUD_INCOMPLETE;
>> +			if (check_timer)
>> +				neigh_del_timer(neigh);
> 
> Why not just always call neigh_del_timer and avoid the check_timer flag?
> Let the NUD_IN_TIMER flag handle whether anything needs to be done.

Agreed.
