Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6F1CE96A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgELAAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgELAAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:00:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DD8C061A0C;
        Mon, 11 May 2020 17:00:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DDDB120ED551;
        Mon, 11 May 2020 17:00:04 -0700 (PDT)
Date:   Mon, 11 May 2020 17:00:03 -0700 (PDT)
Message-Id: <20200511.170003.1583663679589394092.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: improve msg_control kernel vs user pointer handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511115913.1420836-1-hch@lst.de>
References: <20200511115913.1420836-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 17:00:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Mon, 11 May 2020 13:59:10 +0200

> this series replace the msg_control in the kernel msghdr structure
> with an anonymous union and separate fields for kernel vs user
> pointers.  In addition to helping a bit with type safety and reducing
> sparse warnings, this also allows to remove the set_fs() in
> kernel_recvmsg, helping with an eventual entire removal of set_fs().

Looks good.  Things actually used to be a lot worse in the original
compat code but Al Viro cleaned it up into the state it is in right
now.

Series applied to net-next, thanks!
