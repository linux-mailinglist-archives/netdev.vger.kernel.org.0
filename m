Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F601E8170
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgE2POP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:14:15 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:36411 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbgE2PON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 11:14:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590765253; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=bmkITlJbkFN/KpY0Y2LGiwl4ZkNFL5njART6ph7HoIs=; b=LhRHe7XW2wjdjylwciWhVjzyY0t9lQwTZwDuSGOqQdEnTDdW9SvU+HULy4Fymz2qOShBBNQZ
 /jp74AhsG86irGOyr9w94+lP21su+KtV4uzod7ad6p+1uMlzy2DruxFtPok3Vc8seGiyrT5z
 11IB8371QL1ic3bRMyjoHNVrg9w=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5ed126b8c0031c71c2cc0f63 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 15:14:00
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C1A64C433CA; Fri, 29 May 2020 15:13:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 79299C433C6;
        Fri, 29 May 2020 15:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 79299C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/10] staging: wfx: introduce nl80211 vendor extensions
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
        <87imghv9nm.fsf@codeaurora.org> <4249981.oEEGoI9oy7@pc-42>
Date:   Fri, 29 May 2020 18:13:55 +0300
In-Reply-To: <4249981.oEEGoI9oy7@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Wed,
        27 May 2020 15:05:09 +0200")
Message-ID: <87wo4usrik.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Wednesday 27 May 2020 14:34:37 CEST Kalle Valo wrote:
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>=20
>> > This series introduces some nl80211 vendor extensions to the wfx drive=
r.
>> >
>> > This series may lead to some discussions:
>> >
>> >   1. Patch 7 allows to change the dynamic PS timeout. I have found
>> >      an API in wext (cfg80211_wext_siwpower()) that do more or less the
>> >      same thing. However, I have not found any equivalent in nl80211. =
Is it
>> >      expected or this API should be ported to nl80211?
>>=20
>> struct wireless_dev::ps_timeout doesn't work for you?
>
> Indeed, cfg80211_wext_siwpower() modify wireless_dev::ps_timeout, but
> there is no equivalent in nl80211, no?

Ah, I remember now. Something like 10 years ago there was a discussion
about using qos-pm framework for modifying the timeout (or something
like that, can't remember the details anymore) but no recollection what
was the end result.

> Else, I choose to not directly change wireless_dev::ps_timeout because I
> worried about interactions with other parts of cfg80211/mac80211.

This is exactly why we have strict rules for nl80211 vendor commands. We
want to have generic interfaces as much as possible, not each driver
coming up with their own interfaces.

>> >   2. The device The device allows to do Packet Traffic Arbitration (PT=
A or
>> >      also Coex). This feature allows the device to communicate with an=
other
>> >      RF device in order to share the access to the RF. The patch 9 pro=
vides
>> >      a way to configure that. However, I think that this chip is not t=
he
>> >      only one to provide this feature. Maybe a standard way to change
>> >      these parameters should be provided?
>> >
>> >   3. For these vendor extensions, I have used the new policy introduce=
d by
>> >      the commit 901bb989185516 ("nl80211: require and validate vendor
>> >      command policy"). However, it seems that my version of 'iw' is not
>> >      able to follow this new policy (it does not pack the netlink
>> >      attributes into a NLA_NESTED). I could develop a tool specificall=
y for
>> >      that API, but it is not very handy. So, in patch 10, I have also
>> >      introduced an API for compatibility with iw. Any comments about t=
his?
>>=20
>> If you want the driver out of staging I recommend not adding any vendor
>> commands until the driver is moved to drivers/net/wireless. Also do note
>> that we have special rules for nl80211 vendor commands:
>>=20
>> https://wireless.wiki.kernel.org/en/developers/documentation/nl80211#ven=
dor-specific_api
>
> I hoped to suggest the move of this driver outside of staging in some
> weeks (the last items in TODO list are either non-essential or easy to
> fix). So, you suggest me to resend these patches after that change?

It makes a lot easier for the review if there are no nl80211 vendor
commands in the driver, most likely you would need to remove them. So
yes, don't add anything unless absolutely essential until the driver is
accepted upstream. The smaller the driver the faster the review.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
