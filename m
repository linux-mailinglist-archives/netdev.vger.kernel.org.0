Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569101CD210
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 08:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgEKGsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 02:48:52 -0400
Received: from mout.web.de ([212.227.15.3]:39935 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgEKGsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 02:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589179713;
        bh=I7ZMUbsLp3ba8yPp5HvebF9FR82Id0vPvozz+hw8gPg=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=m/i3QTDK1Cy6JCftMOfTlTO7anEesMjAMdIhGmjxl4fSvRQrVh0APHCJNyx3kmoqW
         LMe7/f17/sMEFJzubD6tkchFAI99MwILdytLE53wW6pb0ytQGOQ/uDtfW+QcYLFcKR
         LgTpN+EQssvJvr2PzUqKCnC2FJNWWoLaldAEuVWo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.185.130]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MLxrY-1jSWT70pLw-007mz3; Mon, 11
 May 2020 08:48:33 +0200
Subject: Re: net/sonic: Fix some resource leaks in error handling paths
To:     Finn Thain <fthain@telegraphics.com.au>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de>
 <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet>
 <9d279f21-6172-5318-4e29-061277e82157@web.de>
 <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet>
 <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
 <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <9994a7de-0399-fb34-237a-a3c71b3cf568@web.de>
Date:   Mon, 11 May 2020 08:48:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uZi5+O0uS2C5ciQOk5D1zedOssFPxSDT1BQBW8wI1gVgF6ssWik
 MvALphqfXpNv+cFhDHBRHtg+BgYWV53rmClWNVn7lj8OeAOkB4zqVDxfXiE2TqkizevQTOu
 qcQIqZ/5X+eskO4OC6QcEGyH+98PbFDLYuUuQVq00DLLOmE6JHN+5LVbsO1f+sbmMZ4+siT
 DNRKKEO9MzwK3QFL4kAcQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:z0wbBaVbcPg=:YJ6IH3Qcx6jm83n2G3bYYW
 cHIvsZG0rydZ7XQ5yUIGPLLyyoxgIJOigEkIIfIb2WxA4f0o9otzeDHl+5DtBkNQ32nlV+Dpw
 WwQk6cErOa90O62U9GVzXtFDV8TWZ+DEQbnb8TCKrg5Z0rl1XZND9Eif55JvIJQx3J8wp2Zn4
 5IHJ8oU70CJFicsqaQlFt16Nyd9JbaSqb8HtIU/htiYuK0dc5+BzVoP99h1VFxbA3xXscmShn
 GkninevpayJMqMlgYggQtEGyom57GvaEKvbN/T47C9wOOVE1GkTTkYvqAV/Ful4Rvu0vh1czN
 fYNxchqSSeFMVauCmhfqlUCIrKR6R1N8JnM1uhvyv7ta1Dx1X/Ju0H+ZcfW9pABRbFhKiUftI
 6mHjP/wJLYhYgmyrlU+bmJAMXR4Ja4gRyhK/5bWedpmFWhu/oCLUb+dz57B1tzxdWWQhbel8u
 P4hcV4uKQPNYdB3FHjyE/GRFtnQMd5Ee7v0lY1meaWI6JRhk+drKjoRS5fGPVmEdv8U15U+cg
 SPN8qmx5EdHw5y4nwazPGKdRY1PsgSmZtl+0rTHTkdo+NB70Jp4NEFu2zxH8+rKiF4JEt3kCM
 EVgNf1LvjXOJf0WRPCgfN0dT8t/D09hrD3BWMjuyN8HLki14PEUgZ/ITBpB9fk+wxpB4P9dAc
 YKBVedZUFbLokP7dGB/1DhiegXYjykTtYDbuIkIDcQkXbw6sazJ1mpiCUwAaT8/LnDmCmMJyG
 rqD4Zjjb8eekGTcCe576snbSFVibMqvpoAZ05MUPC0dA5iWNkCv2iUb/Icq7dY3weHiI+4e7b
 vKIE6HeT6Xs8huL+aKWRdb3FVKPf1uu4mMDBVousZNCeql5Hs3kLF3Ihuf+qORB2nsoIs0f7T
 vs4l5SjjLaRxOYjziacN1AVRb+I6O4zhYrqHeozvdEq2cUbtpbBVfpthke86t6tjxZS33AwS6
 oMOs/r6VIH71bRIya+AEzQ3tIVNKLcY1oSM+N+/+KtPPVTsDV8h0+04ZdALppXqXvkYZGXtFX
 +Nn9ZSnW03bXwLnUPM6jLxJRa3StRCzL6jUvxk+Zk71P41kSzS8hHLmGVXrIMwWRwj2YyGfpl
 77qIK7IsTep/0+sLQJujw7rmXQqEgxM0CTesScdDTCxPfMub/ca526zXHLDrH4TLDr2ih8AdV
 702uco/hi6Sw5oweTmONzPX/DQsmTM6aSxixPOf50BmiYNNbaHxqzvUmdC5vqXeTILeUhVLsv
 +jzUGdGse3R1bO9Xs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you can't determine when the bug was introduced,

I might be able to determine also this information.


> how can you criticise a patch for the lack of a Fixes tag?

I dared to point two details out for the discussed patch.


>> To which commit would you like to refer to for the proposed adjustment
>> of the function =E2=80=9Cmac_sonic_platform_probe=E2=80=9D?
>
> That was my question to you. We seem to be talking past each other.

We come along different views for this patch review.
Who is going to add a possible reference for this issue?


>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/coding-style.rst?id=3De99332e7b4cda6e60f5b5916cf994=
3a79dbef902#n460
>
> My preference is unimportant here.

It is also relevant here because you added the tag =E2=80=9CReviewed-by=E2=
=80=9D.
https://lore.kernel.org/patchwork/comment/1433193/
https://lkml.org/lkml/2020/5/8/1827


> I presume that you mean to assert that Christophe's patch
> breaches the style guide.

I propose to take such a possibility into account.


> However, 'sonic_probe1' is the name of a function.

The discussed source file does not contain such an identifier.
https://elixir.bootlin.com/linux/v5.7-rc5/source/drivers/net/ethernet/nats=
emi/macsonic.c#L486
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/net/ethernet/natsemi/macsonic.c?id=3D2ef96a5bb12be62ef75b5828c0aab83=
8ebb29cb8#n486


> This is not some sequence of GW-BASIC labels referred to in the style gu=
ide.

I recommend to read the current section =E2=80=9C7) Centralized exiting of=
 functions=E2=80=9D
once more.


>> Can programming preferences evolve into the direction of =E2=80=9Csay w=
hat the
>> goto does=E2=80=9D?
>
> I could agree that macsonic.c has no function resembling "probe1",
> and that portion of the patch could be improved.

I find this feedback interesting.


> Was that the opinion you were trying to express by way of rhetorical
> questions? I can't tell.

Some known factors triggered my suggestion to consider the use of
the label =E2=80=9Cfree_dma=E2=80=9D.


> Is it possible for a reviewer to effectively criticise C by use of
> English, when his C ability surpasses his English ability?

We come along possibly usual communication challenges.

Regards,
Markus
