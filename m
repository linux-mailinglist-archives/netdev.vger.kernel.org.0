Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F222620A5AC
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405285AbgFYTWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404026AbgFYTWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 15:22:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D51CC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 12:22:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A89A9129D58E9;
        Thu, 25 Jun 2020 12:22:12 -0700 (PDT)
Date:   Thu, 25 Jun 2020 12:22:12 -0700 (PDT)
Message-Id: <20200625.122212.1431059494499957023.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     netdev@vger.kernel.org, ncardwell@google.com, edumazet@google.com,
        ycheng@google.com, Richard.Scheffenegger@netapp.com,
        ietf@bobbriscoe.net
Subject: Re: [PATCH v3] tcp: don't ignore ECN CWR on pure ACK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625115106.23370-1-denis.kirjanov@suse.com>
References: <20200625115106.23370-1-denis.kirjanov@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 12:22:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Thu, 25 Jun 2020 14:51:06 +0300

> there is a problem with the CWR flag set in an incoming ACK segment
> and it leads to the situation when the ECE flag is latched forever
> 
> the following packetdrill script shows what happens:
 ...
> In the situation above we will continue to send ECN ECHO packets
> and trigger the peer to reduce the congestion window. To avoid that
> we can check CWR on pure ACKs received.
> 
> v3:
> - Add a sequence check to avoid sending an ACK to an ACK
> 
> v2:
> - Adjusted the comment
> - move CWR check before checking for unacknowledged packets
> 
> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>

Applied, thanks.
