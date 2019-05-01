Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D2C10BFE
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEAR3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:29:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfEAR3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 13:29:19 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20C021478DBE9;
        Wed,  1 May 2019 10:29:17 -0700 (PDT)
Date:   Wed, 01 May 2019 13:29:14 -0400 (EDT)
Message-Id: <20190501.132914.1542638584464970678.davem@davemloft.net>
To:     shmulik@metanetworks.com
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        shmulik.ladkani@gmail.com
Subject: Re: [PATCH net] ipv4: ip_do_fragment: Preserve skb_iif during
 fragmentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429133930.6287-1-shmulik.ladkani@gmail.com>
References: <20190429133930.6287-1-shmulik.ladkani@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 10:29:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shmulik Ladkani <shmulik@metanetworks.com>
Date: Mon, 29 Apr 2019 16:39:30 +0300

> Previously, during fragmentation after forwarding, skb->skb_iif isn't
> preserved, i.e. 'ip_copy_metadata' does not copy skb_iif from given
> 'from' skb.
> 
> As a result, ip_do_fragment's creates fragments with zero skb_iif,
> leading to inconsistent behavior.
> 
> Assume for example an eBPF program attached at tc egress (post
> forwarding) that examines __sk_buff->ingress_ifindex:
>  - the correct iif is observed if forwarding path does not involve
>    fragmentation/refragmentation
>  - a bogus iif is observed if forwarding path involves
>    fragmentation/refragmentatiom
> 
> Fix, by preserving skb_iif during 'ip_copy_metadata'.
> 
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>

Applied and queued up for -stable.
