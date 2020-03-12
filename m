Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07D182950
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387970AbgCLGud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:50:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387889AbgCLGud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:50:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F8C914DD5D48;
        Wed, 11 Mar 2020 23:50:32 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:50:31 -0700 (PDT)
Message-Id: <20200311.235031.754217366237670514.davem@davemloft.net>
To:     paolo.lungaroni@cnit.it
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it, ahmed.abdelsalam@gssi.it
Subject: Re: [net] seg6: fix SRv6 L2 tunnels to use IANA-assigned protocol
 number
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311165406.22044-1-paolo.lungaroni@cnit.it>
References: <20200311165406.22044-1-paolo.lungaroni@cnit.it>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:50:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Lungaroni <paolo.lungaroni@cnit.it>
Date: Wed, 11 Mar 2020 17:54:06 +0100

> The Internet Assigned Numbers Authority (IANA) has recently assigned
> a protocol number value of 143 for Ethernet [1].
> 
> Before this assignment, encapsulation mechanisms such as Segment Routing
> used the IPv6-NoNxt protocol number (59) to indicate that the encapsulated
> payload is an Ethernet frame.
> 
> In this patch, we add the definition of the Ethernet protocol number to the
> kernel headers and update the SRv6 L2 tunnels to use it.
> 
> [1] https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
> 
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
> Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Acked-by: Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>

Applied.

But this is that classic case where we add a protocol element to the
tree before the official number is assigned.

Then the number is assigned and if we change it then everything using
the original number is no longer interoperable.
