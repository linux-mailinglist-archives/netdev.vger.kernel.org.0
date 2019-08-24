Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F09C102
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfHXXfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:35:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfHXXfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:35:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B46115260058;
        Sat, 24 Aug 2019 16:35:07 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:35:06 -0700 (PDT)
Message-Id: <20190824.163506.328898476555373543.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net] s390/qeth: reject oversized SNMP requests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190823092923.8507-1-jwi@linux.ibm.com>
References: <20190823092923.8507-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:35:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Fri, 23 Aug 2019 11:29:23 +0200

> Commit d4c08afafa04 ("s390/qeth: streamline SNMP cmd code") removed
> the bounds checking for req_len, under the assumption that the check in
> qeth_alloc_cmd() would suffice.
> 
> But that code path isn't sufficiently robust to handle a user-provided
> data_length, which could overflow (when adding the cmd header overhead)
> before being checked against QETH_BUFSIZE. We end up allocating just a
> tiny iob, and the subsequent copy_from_user() writes past the end of
> that iob.
> 
> Special-case this path and add a coarse bounds check, to protect against
> maliciuous requests. This let's the subsequent code flow do its normal
> job and precise checking, without risk of overflow.
> 
> Fixes: d4c08afafa04 ("s390/qeth: streamline SNMP cmd code")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>

Applied.
