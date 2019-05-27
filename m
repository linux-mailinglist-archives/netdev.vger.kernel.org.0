Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A122ADC1
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 06:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfE0Erj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 00:47:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfE0Erj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 00:47:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4093214784BF2;
        Sun, 26 May 2019 21:47:38 -0700 (PDT)
Date:   Sun, 26 May 2019 21:47:37 -0700 (PDT)
Message-Id: <20190526.214737.894681363036180862.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, john.fastabend@gmail.com, vakul.garg@nxp.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net 0/4] net/tls: two fixes for rx_list pre-handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524173433.9196-1-jakub.kicinski@netronome.com>
References: <20190524173433.9196-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 21:47:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 24 May 2019 10:34:29 -0700

> tls_sw_recvmsg() had been modified to cater better to async decrypt.
> Partially read records now live on the rx_list. Data is copied from
> this list before the old do {} while loop, and the not included
> correctly in deciding whether to sleep or not and lowat threshold
> handling. These modifications, unfortunately, added some bugs.
> 
> First patch fixes lowat - we need to calculate the threshold early
> and make sure all copied data is compared to the threshold, not just
> the freshly decrypted data.
> 
> Third patch fixes sleep - if data is picked up from rx_list and
> no flags are set, we should not put the process to sleep, but
> rather return the partial read.
> 
> Patches 2 and 4 add test cases for these bugs, both will cause
> a sleep and test timeout before the fix.

Thanks for the test cases.

Series applied and queued up for -stable.
