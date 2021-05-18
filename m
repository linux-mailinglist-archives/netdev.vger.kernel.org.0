Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB7388084
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 21:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351871AbhERTbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 15:31:14 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41472 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbhERTbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 15:31:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621366189; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=xImqkEVhZ7NBDDa6rAwINqmmjR5AFYmB3VNpZQ5pQL4=;
 b=sHMIy2+X1kqi1Ezd2c7Pkmimx0uqqLYt7o9z3kIcYwc0Y6lzEHgZND6XqCebe4EP8t/GiWbC
 YHHBmJKxYJOLMbv+v0JtpUMOHaQehxKCV1YkhrlRjoFmckZcG2DugcoRn98tT1VuAwMLpWQ4
 PuupvhXRxHmv1ULL2CAyVgfgilE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60a415aab15734c8f953d91c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 May 2021 19:29:46
 GMT
Sender: jjohnson=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E2BA0C4338A; Tue, 18 May 2021 19:29:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jjohnson)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 675B4C433D3;
        Tue, 18 May 2021 19:29:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 May 2021 12:29:44 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] b43: don't save dentries for debugfs
In-Reply-To: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
Message-ID: <891f28e4c1f3c24ed1b257de83cbb3a0@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-18 09:33, Greg Kroah-Hartman wrote:
> There is no need to keep around the dentry pointers for the debugfs
> files as they will all be automatically removed when the subdir is
> removed.  So save the space and logic involved in keeping them around 
> by
> just getting rid of them entirely.
> 
> By doing this change, we remove one of the last in-kernel user that was
> storing the result of debugfs_create_bool(), so that api can be cleaned
> up.

Question not about this specific change, but the general concept
of keeping (or not keeping) dentry pointers. In the ath drivers,
as well as in an out-of-tree driver for Android, we keep a
debugfs dentry pointer to use as a param to relay_open().

Will we still be able to have a dentry pointer for this purpose?
Or better, is there a recommended way to get a dentry pointer
NOT associated with debugfs at all (which would be ideal for
Android where debugfs is disabled).

Thanks,
Jeff

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
