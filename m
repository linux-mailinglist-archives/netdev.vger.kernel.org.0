Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B678BAF1
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbfHMN6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:58:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbfHMN6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:58:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7880F608FF; Tue, 13 Aug 2019 13:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565704723;
        bh=M8oAe1f6maG+IxzSwYrxoIVVdKazq93Sv32mx1kHDTk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UnYXjBsohipGcIhOiU7MbVsbLEx9berNqc16y6AT7dc/+7gM6zxDlknkaGartFwBs
         wTmVznRdzrY7vbtfaxJW34Ni3lRNUiHaW/8eEfkCugzi5yqEM6ZWHdysjhRjB3oQgt
         VkLtVzoHaMUKupIMsrs2eneH48+uRPOHZlasrHwI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA5A560734;
        Tue, 13 Aug 2019 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565704722;
        bh=M8oAe1f6maG+IxzSwYrxoIVVdKazq93Sv32mx1kHDTk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IaI8Q6n2wPeQJAHwk4P9fPwbfo0nHJdPoiRlNZit9WBgBvAj3zU2/5X/WCuv732RX
         vZFSpNsdsZs39QlwnnytW2C2fIDI61aQ+3GkJUV7EJzbTGFvac0y/PwRTQQFfQ5+Jl
         a0EinvMjNaLJuO2Kne/S5kgkz5Rrrf8sqfsWTFiY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA5A560734
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar\@gmail.com" <amitkarwar@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "huxinming820\@gmail.com" <huxinming820@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants\@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs\@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: Re: [EXT] INFO: trying to register non-static key in del_timer_sync (2)
References: <000000000000927a7b0586561537@google.com>
        <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
        <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
        <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
        <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
        <CAAeHK+z8MBNikw_x50Crf8ZhOhcF=uvPHakvBx44K77xHRUNfg@mail.gmail.com>
Date:   Tue, 13 Aug 2019 16:58:36 +0300
In-Reply-To: <CAAeHK+z8MBNikw_x50Crf8ZhOhcF=uvPHakvBx44K77xHRUNfg@mail.gmail.com>
        (Andrey Konovalov's message of "Tue, 13 Aug 2019 15:36:33 +0200")
Message-ID: <87k1bhb20j.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Konovalov <andreyknvl@google.com> writes:

> On Wed, Jun 12, 2019 at 6:03 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
>>
>> Hi Dmitry,
>>
>> We have a patch to fix this: https://patchwork.kernel.org/patch/10990275/
>
> Hi Ganapathi,
>
> Has this patch been accepted anywhere? This bug is still open on syzbot.

The patch is in "Changes Requested" state which means that the author is
supposed to send a new version based on the review comments.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
