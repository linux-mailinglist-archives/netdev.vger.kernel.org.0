Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B581714130
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfEEQxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:53:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52404 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEQxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 12:53:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A551114D99A61;
        Sun,  5 May 2019 09:53:11 -0700 (PDT)
Date:   Sun, 05 May 2019 09:53:09 -0700 (PDT)
Message-Id: <20190505.095309.439816991626967361.davem@davemloft.net>
To:     Markus.Amend@telekom.de
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dccp@vger.kernel.org
Subject: Re: [PATCH v3] net: dccp: Checksum verification enhancement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <FRAPR01MB11707401056D4D6C95D8C615FA3A0@FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE>
References: <FRAPR01MB11707401056D4D6C95D8C615FA3A0@FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 09:53:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <Markus.Amend@telekom.de>
Date: Tue, 30 Apr 2019 16:11:07 +0000

> The current patch modifies the checksum verification of a received DCCP
> packet, by adding the function __skb_checksum_validate into the
> dccp_vX_rcv routine. The purpose of the modification is to allow the
> verification of the skb->ip_summed flags during the checksum validation
> process (for checksum offload purposes). As __skb_checksum_validate
> covers the functionalities of skb_checksum and dccp_vX_csum_finish they
> are needless and therefore removed.
> 
> Signed-off-by: Nathalie Romo Moreno <natha.ro.moreno@gmail.com>
> Signed-off-by: Markus Amend <markus.amend@telekom.de>

I don't see how this can be correct as you're not taking the csum
coverage value into consideration at all.
