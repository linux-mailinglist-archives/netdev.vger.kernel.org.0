Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436ECFF87A
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfKQIKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 03:10:12 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:38168
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbfKQIKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 03:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1573977989;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=hlHVQMXwJQJ4/NEGFptUUYWXjBSrUibkwRWXPfizBGw=;
        b=NfiaNUE/gU0W3ZdeEgUtqulJshrxGpNkKrB/u4F5fjrASHj88fQ7DXF13/YJav6d
        es7GjhUFz1wQLZGx+7vM8EEt1hgPGFvFIqL0vSt/9BIemHntiyfLc6GvwBr6mE1Djgx
        hgvlgImxWKzUk+EOG8VC8sMe64QIM2ecdnDUBzxE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1573977989;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=hlHVQMXwJQJ4/NEGFptUUYWXjBSrUibkwRWXPfizBGw=;
        b=RsQjte3JmAkCnKT+wuPbuZxgWuLM5sSw5FvNGVhcX98NPCvuoJIOcwGqRRTALdv+
        tPTiNpYzITRCoXsoeOj1ZuLzhFEjURQxGP6myqSXR6O0ATFt6BWlft4+nZWB1QCysYU
        v8qJEM4qNQUEhD7PkiPnRCSGOH3eVtIIwCEbvT90=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 17 Nov 2019 08:06:29 +0000
From:   merez@codeaurora.org
To:     Colin King <colin.king@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wil6210: fix break that is never reached because of
 zero'ing of a retry counter
In-Reply-To: <20191115120953.48137-1-colin.king@canonical.com>
References: <20191115120953.48137-1-colin.king@canonical.com>
Message-ID: <0101016e78662264-7ebb46fa-638f-4817-b76a-ed66524d25be-000000@us-west-2.amazonses.com>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.17-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-11-15 14:09, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a check on the retry counter invalid_buf_id_retry that is 
> always
> false because invalid_buf_id_retry is initialized to zero on each 
> iteration
> of a while-loop.  Fix this by initializing the retry counter before the
> while-loop starts.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: b4a967b7d0f5 ("wil6210: reset buff id in status message after
> completion")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> Note: not tested, so I'm not sure if the loop retry threshold is high 
> enough
> 
> ---

Reviewed-by: Maya Erez <merez@codeaurora.org>
