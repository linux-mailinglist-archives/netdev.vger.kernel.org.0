Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C83319B544
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbgDASTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:19:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730420AbgDASTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:19:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2010C11D69C3E;
        Wed,  1 Apr 2020 11:19:32 -0700 (PDT)
Date:   Wed, 01 Apr 2020 11:19:30 -0700 (PDT)
Message-Id: <20200401.111930.504991135006095672.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, herat@chelsio.com, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix MPS index overwrite when setting MAC
 address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585683969-17582-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1585683969-17582-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Apr 2020 11:19:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Wed,  1 Apr 2020 01:16:09 +0530

> From: Herat Ramani <herat@chelsio.com>
> 
> cxgb4_update_mac_filt() earlier requests firmware to add a new MAC
> address into MPS TCAM. The MPS TCAM index returned by firmware is
> stored in pi->xact_addr_filt. However, the saved MPS TCAM index gets
> overwritten again with the return value of cxgb4_update_mac_filt(),
> which is wrong.
> 
> When trying to update to another MAC address later, the wrong MPS TCAM
> index is sent to firmware, which causes firmware to return error,
> because it's not the same MPS TCAM index that firmware had sent
> earlier to driver.
> 
> So, fix by removing the wrong overwrite being done after call to
> cxgb4_update_mac_filt().
> 
> Fixes: 3f8cfd0d95e6 ("cxgb4/cxgb4vf: Program hash region for {t4/t4vf}_change_mac()")
> Signed-off-by: Herat Ramani <herat@chelsio.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied and queued up for -stable.
