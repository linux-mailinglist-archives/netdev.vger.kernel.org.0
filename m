Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704F73D300
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405140AbfFKQwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:52:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389757AbfFKQwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:52:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7EA8F60A44; Tue, 11 Jun 2019 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560271938;
        bh=EWaGYlUEtSJujntfkWWkNzZfnY+gc4hFdn9MEawiOP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m2CioZUe39qanfZOhd2/d8dal/I3jVR8/l4r4reFyc8TdLHfBORMaDr9wqALUZid1
         tXv4GBBedi4ZFLoniNZB84Jz3pJncerK1B8KHYBYPZ0lwqMJ2Pm6o+sdLcalqm5fda
         Jh5Mw12a9TpP1nz3RdfIl4YYyZs/3ttYhu6i+BJY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 49EEC60271;
        Tue, 11 Jun 2019 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560271937;
        bh=EWaGYlUEtSJujntfkWWkNzZfnY+gc4hFdn9MEawiOP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GVUgVMbHCn+CkS+MkbgWO1xjbxVXlrgAfcqcLDDPrYmv53U3DmsA9KqaY+VVMcCAX
         LbNUFiCHvOuzzsXWd0/6RoLBMJMwiGH8pqqtxv8asl/vqenfY07xMTVVUgyX7E4/FX
         qU+52UHW3jdR4ObZArHFdrEDpecgTRN8yqq634QI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 11 Jun 2019 10:52:16 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
In-Reply-To: <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
Message-ID: <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The general plan (and I believe Daniele Palmas was working on it) was
> to eventually make qmi_wwan use rmnet rather than its internal sysfs-
> based implementation. qmi_wwan and ipa are at essentially the same
> level and both could utilize rmnet on top.
> 
> *That's* what I'd like to see. I don't want to see two different ways
> to get QMAP packets to modem firmware from two different drivers that
> really could use the same code.
> 
> Dan

qmi_wwan is based on USB and is very different from the IPA interconnect
though. AFAIK, they do not have much in common (apart from sending &
receiving MAP packets from hardware).

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
