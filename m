Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3155453EE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfFNF0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:26:01 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfFNF0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:26:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0024660867; Fri, 14 Jun 2019 05:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560489961;
        bh=6YXSV6HR11OJBzhjyk123lc8NA3juKrUYL/aoYkhVqw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UJtHg8ndaKW7/U7ES16QK9QEDr8C7y3xRlegAoE/cc0RWXSrBp785ggqJfgitsciu
         5q8jZB/d4oxJ3CpuKWO0+I3nwvan1QX2pPqecfsZet9anMqW+6EkNKxx5sYyyxBHQc
         LLrJVKateihMYni3999PNtREpExfznTcVFVlm+KQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF0C460213;
        Fri, 14 Jun 2019 05:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560489960;
        bh=6YXSV6HR11OJBzhjyk123lc8NA3juKrUYL/aoYkhVqw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BWxrc8uO7ZtvrV4va+9aNXLMXXBIpnfojmvfOoCzqXrrNK8R9Tpmvn3Q7/CDK8z21
         /gCAxebJ7CUSYQVxpPwg0RJXVvnTY1XeuQwrhRw74SfMi4CQAGYsP4Uv8DfwctoR2n
         D/Qm9rV3/k3FIuRsfbb3sgXgX9UQsB3f2fZd7iYU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DF0C460213
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     eliad@wizery.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: Cleanup of -Wunused-const-variable in drivers/net/wireless/ti/wl18xx/main.c
References: <CAJkfWY4WkeMv3Z+Nh4B0xtErTAi6mVCriURZTjd2Q__gMtaEqA@mail.gmail.com>
Date:   Fri, 14 Jun 2019 08:25:56 +0300
In-Reply-To: <CAJkfWY4WkeMv3Z+Nh4B0xtErTAi6mVCriURZTjd2Q__gMtaEqA@mail.gmail.com>
        (Nathan Huckleberry's message of "Thu, 13 Jun 2019 11:00:33 -0700")
Message-ID: <874l4slouz.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Huckleberry <nhuck@google.com> writes:

> I'm looking into cleaning up ignored warnings in the kernel so we can
> remove compiler flags to ignore warnings.
>
> There are two unused variables ('wl18xx_iface_ap_cl_limits' and
> 'wl18xx_iface_ap_go_limits') in drivers/net/wireless/ti/wl18xx/main.c.
> These appear to be limits when using p2p devices, yet they are never
> used.
>
> Wanted to reach out for the best course of action to fix the warning.
>
> https://github.com/ClangBuiltLinux/linux/issues/530

The the variables were added in this commit:

commit 7845af35e0deeb7537de759ebc69d6395d4123bf
Author:     Eliad Peller <eliad@wizery.com>
AuthorDate: Thu Jul 30 22:38:22 2015 +0300
Commit:     Kalle Valo <kvalo@codeaurora.org>
CommitDate: Mon Aug 10 22:16:34 2015 +0300

    wlcore: add p2p device support

And even that commit didn't use them, no idea why. Just send a patch
removing them, if someone needs them later they can be added again.

-- 
Kalle Valo
