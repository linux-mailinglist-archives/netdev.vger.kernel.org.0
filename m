Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E542760B5
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgIWTCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWTCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:02:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB251C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 12:02:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9801813F675EB;
        Wed, 23 Sep 2020 11:45:56 -0700 (PDT)
Date:   Wed, 23 Sep 2020 12:02:43 -0700 (PDT)
Message-Id: <20200923.120243.174960615983472672.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     eric.dumazet@gmail.com, zenczykowski@gmail.com, maze@google.com,
        netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        sgill@quicinc.com, vparadka@qti.qualcomm.com, twear@quicinc.com,
        dsahern@kernel.org
Subject: Re: [PATCH v2] net/ipv4: always honour route mtu during forwarding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e5c28c89-0022-69d2-8538-74c2c842a2fc@gmail.com>
References: <20200923045143.3755128-1-zenczykowski@gmail.com>
        <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com>
        <e5c28c89-0022-69d2-8538-74c2c842a2fc@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 11:45:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Wed, 23 Sep 2020 08:36:50 -0600

> On 9/23/20 2:46 AM, Eric Dumazet wrote:
>> Apparently route mtu are capped to 65520, not sure where it is done exactly IP_MAX_MTU being 65535)
> 
> ip_metrics_convert seems to be the place"
>                 if (type == RTAX_MTU && val > 65535 - 15)
>                         val = 65535 - 15;
> 
> going back through the code moves, and it was added by Dave with
> 710ab6c03122c

At the time of that commit IP_MAX_MTU only existed in net/ipv4/route.c
and it's value was 0xFFF0.

So I didn't add anything :-)  Just moving stuff around.

