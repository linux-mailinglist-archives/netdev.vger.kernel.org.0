Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32372871F9
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgJHJvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:51:05 -0400
Received: from z5.mailgun.us ([104.130.96.5]:58441 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729254AbgJHJvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 05:51:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602150664; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=nlXSo1WC6dBplvW6l8S+mM5RRz5OBfe21tJnXYaiLbs=; b=dY57ec3Mh1fj9yqbpjCHzOH0jfx0y+HMke9p4BQHa+PajGkJ23Mcs/d1BFhhlylEvsGbyMbJ
 h+U2lzwCH7BAg/ePxBkaNlAnaU1XevwYoJ5JDJ/l5g5jpB8W2yUlQNpyKtRc06cfzliKNitd
 HmTMatZuBhTaz6ofBxCOjUY1YSA=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f7ee107aad2c3cd1caf0157 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Oct 2020 09:51:03
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 465B6C433FE; Thu,  8 Oct 2020 09:51:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9E5BAC433CB;
        Thu,  8 Oct 2020 09:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9E5BAC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/7] wfx: move out from the staging area
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
        <20201007105513.GA1078344@kroah.com> <87ft6p2n0h.fsf@codeaurora.org>
Date:   Thu, 08 Oct 2020 12:50:58 +0300
In-Reply-To: <87ft6p2n0h.fsf@codeaurora.org> (Kalle Valo's message of "Thu, 08
        Oct 2020 10:30:06 +0300")
Message-ID: <877ds12ghp.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
>> On Wed, Oct 07, 2020 at 12:19:36PM +0200, Jerome Pouiller wrote:
>>> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>>>=20
>>> I think the wfx driver is now mature enough to be accepted in the
>>> drivers/net/wireless directory.
>>>=20
>>> There is still one item on the TODO list. It is an idea to improve the =
rate
>>> control in some particular cases[1]. However, the current performances =
of the
>>> driver seem to satisfy everyone. In add, the suggested change is large =
enough.
>>> So, I would prefer to implement it only if it really solves an issue. I=
 think it
>>> is not an obstacle to move the driver out of the staging area.
>>>=20
>>> In order to comply with the last rules for the DT bindings, I have conv=
erted the
>>> documentation to yaml. I am moderately happy with the result. Especiall=
y, for
>>> the description of the binding. Any comments are welcome.
>>>=20
>>> The series also update the copyrights dates of the files. I don't know =
exactly
>>> how this kind of changes should be sent. It's a bit weird to change all=
 the
>>> copyrights in one commit, but I do not see any better way.
>>>=20
>>> I also include a few fixes I have found these last weeks.
>>>=20
>>> [1] https://lore.kernel.org/lkml/3099559.gv3Q75KnN1@pc-42
>>
>> I'll take the first 6 patches here, the last one you should work with
>> the wireless maintainers to get reviewed.
>>
>> Maybe that might want to wait until after 5.10-rc1 is out, with all of
>> these changes in it, making it an easier move.
>
> Yes, the driver needs to be reviewed in linux-wireless list. I recommend
> submitting the whole driver in a patchset with one file per patch, which
> seems to be the easiest way to review a full driver. The final move will
> be in just one commit moving the driver, just like patch 7 does here. As
> an example see how wilc1000 review was done.
>
> Device tree bindings needs to be reviewed by the DT maintainer so CC
> devicetree on that patch.

BTW, I wrote some instructions for new wireless drivers:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#new_driver

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
