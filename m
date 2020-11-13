Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7422B24CF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKMTns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgKMTnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 14:43:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90B8B208B6;
        Fri, 13 Nov 2020 19:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605296626;
        bh=T/eDe+uNV+QDT3kdKIBtkpN/kuxChX/D38Hmz/lcKbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FrXP01f0yqpxut5lROWZzVWXTLNt8/he7dZCBRmlY5QYbuIhE+mUIaMAZqqxUSTej
         aHtbRAqRACTX6Rod5uGluvbXhtgoszRzKvqIDmtNr2uKIke6gUdku4THSUait8VbMY
         dySQSYgvrzd/+CTxTfW1K4sD25SBCsIveP7OAhus=
Date:   Fri, 13 Nov 2020 11:43:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to
 deal with usage counter
Message-ID: <20201113114345.73768af3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110092933.3342784-2-zhangqilong3@huawei.com>
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
        <20201110092933.3342784-2-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 17:29:32 +0800 Zhang Qilong wrote:
> In many case, we need to check return value of pm_runtime_get_sync, but
> it brings a trouble to the usage counter processing. Many callers forget
> to decrease the usage counter when it failed, which could resulted in
> reference leak. It has been discussed a lot[0][1]. So we add a function
> to deal with the usage counter for better coding.
> 
> [0]https://lkml.org/lkml/2020/6/14/88
> [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

FWIW I'm expecting to apply this series to net-next once we get an ack
from the power management side.
