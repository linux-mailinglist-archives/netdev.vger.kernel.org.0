Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA00AFDC0
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfIKNco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:32:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58816 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfIKNco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:32:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6F289604D4; Wed, 11 Sep 2019 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568208763;
        bh=/BRpHZjZ2m7keYammYjNvrWUwxXADs4OYQ/v74TjEGE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eqQLHQrGRo1ocWUYO3fFZ+mDYsBrSsqIiKLIOJ6nKxKltgqTX7VukDmmuQQN9ZpXZ
         B+O7zPG0nMYMld2Uba8AgvVsGze7zOBaUdc7TXzyefb8XNQV6Ti3DP9sqKbALAGmDr
         QXdxsFbta8XjqlIH1SiDwS+MHOBsNM0yJYR1ZmlM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 36AAD6050D;
        Wed, 11 Sep 2019 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568208760;
        bh=/BRpHZjZ2m7keYammYjNvrWUwxXADs4OYQ/v74TjEGE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PKLQq0IhQnQsjem5N+SDceADO9HMbDbXwPpk0yqE0gJvX1sWxvhFHZ9lgVyVZq2ZH
         ZZLHI7O4fJOYAsKXstpDrsQSxS0vIm5z9oufUiyoLg3uytmwof08WQsBlt0+8clMpj
         aiIGDsx3m+hv4+MnK/UoNHgTUGpK+9yeqjGftB4M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 36AAD6050D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
        <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
        <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com>
        <30679d3f86731475943856196478677e70a349a9.camel@sipsolutions.net>
Date:   Wed, 11 Sep 2019 16:32:35 +0300
In-Reply-To: <30679d3f86731475943856196478677e70a349a9.camel@sipsolutions.net>
        (Johannes Berg's message of "Wed, 11 Sep 2019 14:04:30 +0200")
Message-ID: <87pnk7klfw.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

>> Sep 11 10:27:13 xps13 kernel: WARNING: CPU: 4 PID: 1246 at
>> net/mac80211/sta_info.c:1057 __sta_info_destroy_part2+0x147/0x150
>> [mac80211]
>> 
>> but if you want full logs I can send them in private to you.
>
> No, it's fine, though maybe Kalle does - he was stepping out for a while
> but said he'd look later.

Linus, it would help if you could send me full logs with timestamps.
Also if you can, please grep your logs to see if these wmi timeouts have
happened before.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
