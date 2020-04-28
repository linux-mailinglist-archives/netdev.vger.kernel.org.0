Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266A61BBCF9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 14:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgD1MCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 08:02:39 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:40574 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbgD1MCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 08:02:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588075358; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: References: In-Reply-To: Subject: Cc:
 To: From: Sender; bh=YxH+2DR7vWFpUoIHziSKBV2f45z4/gOayRfRydsyFKo=; b=FDKO4/8mgK5sRx2kKweRRvieNMEBJsBsEmFUFMes8rOsJqAcBFd2po/jDeLsNM2Ytgvy6H7N
 PQ54bSkcpcPzijUuoH8zEHPtKTCdyRdCyEgAZaRzrW0GcFCIZh70TH5OslYg17pQnLvgV34S
 3Y3WNBCUl0KAQA1RB9t6qUbDeQ8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ea81b20.7f91eb17bbc8-smtp-out-n04;
 Tue, 28 Apr 2020 12:01:36 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BC9DBC43637; Tue, 28 Apr 2020 12:01:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E244DC433D2;
        Tue, 28 Apr 2020 12:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E244DC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     ath10k@lists.infradead.org,
        Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linus =?utf-8?Q?L=C3=BCssing?= <ll@simonwunderlich.de>,
        mail@adrianschmutzler.de
Subject: Re: [PATCH] ath10k: increase rx buffer size to 2048
In-Reply-To: <3097447.aZuNXRJysd@sven-edge> (Sven Eckelmann's message of "Sat,
        25 Apr 2020 13:14:42 +0200")
References: <20200205191043.21913-1-linus.luessing@c0d3.blue>
        <3300912.TRQvxCK2vZ@bentobox> <3097447.aZuNXRJysd@sven-edge>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
Date:   Tue, 28 Apr 2020 15:01:28 +0300
Message-ID: <87blnblsyv.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sven Eckelmann <sven@narfation.org> writes:

> On Wednesday, 1 April 2020 09:00:49 CEST Sven Eckelmann wrote:
>> On Wednesday, 5 February 2020 20:10:43 CEST Linus L=C3=BCssing wrote:
>> > From: Linus L=C3=BCssing <ll@simonwunderlich.de>
>> >=20
>> > Before, only frames with a maximum size of 1528 bytes could be
>> > transmitted between two 802.11s nodes.
>> >=20
>> > For batman-adv for instance, which adds its own header to each frame,
>> > we typically need an MTU of at least 1532 bytes to be able to transmit
>> > without fragmentation.
>> >=20
>> > This patch now increases the maxmimum frame size from 1528 to 1656
>> > bytes.
>> [...]
>>=20
>> @Kalle, I saw that this patch was marked as deferred [1] but I couldn't =
find=20
>> any mail why it was done so. It seems like this currently creates real w=
orld=20
>> problems - so would be nice if you could explain shortly what is current=
ly=20
>> blocking its acceptance.
>
> Ping?

Sorry for the delay, my plan was to first write some documentation about
different hardware families but haven't managed to do that yet.

My problem with this patch is that I don't know what hardware and
firmware versions were tested, so it needs analysis before I feel safe
to apply it. The ath10k hardware families are very different that even
if a patch works perfectly on one ath10k hardware it could still break
badly on another one.

What makes me faster to apply ath10k patches is to have comprehensive
analysis in the commit log. This shows me the patch author has
considered about all hardware families, not just the one he is testing
on, and that I don't need to do the analysis myself.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
