Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA85A1B6CB2
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 06:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgDXEd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 00:33:57 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:37871 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgDXEd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 00:33:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587702836; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=a/cWZWil63oy2LeUPylT7nToPBhx2A8BfuTg5P7sK6o=; b=fEOGjumWpkxsLO9A9EfNzK17RwFTxUTG2he6n+T7he9r8fGQmxymi9bK0EQExrWHUHI/vaUv
 J03q+jnt5xt8pzLeubIskwp1aBw4r6CMAs9hxj6qcePTAQ0FAzivJOtLmx1H7HFOJPMqwjh8
 gUV46TsXUBxl0xX+QoIvPkc5KdI=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ea26c23.7f79f87ed6c0-smtp-out-n01;
 Fri, 24 Apr 2020 04:33:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 767B9C432C2; Fri, 24 Apr 2020 04:33:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC793C433CB;
        Fri, 24 Apr 2020 04:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC793C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        stas.yakovlev@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ipw2x00: Remove a memory allocation failure log message
References: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
        <5868418d-88b0-3694-2942-5988ab15bdcb@cogentembedded.com>
        <3c80ef48-57a8-b414-6cf1-6c255a46f6be@wanadoo.fr>
Date:   Fri, 24 Apr 2020 07:33:33 +0300
In-Reply-To: <3c80ef48-57a8-b414-6cf1-6c255a46f6be@wanadoo.fr> (Christophe
        JAILLET's message of "Thu, 23 Apr 2020 22:47:25 +0200")
Message-ID: <87zhb1h59e.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

> Le 23/04/2020 =C3=A0 11:46, Sergei Shtylyov a =C3=A9crit=C2=A0:
>> Hello!
>>
>> On 23.04.2020 10:58, Christophe JAILLET wrote:
>>
>>> Axe a memory allocation failure log message. This message is useless and
>>> incorrect (vmalloc is not used here for the memory allocation)
>>>
>>> This has been like that since the very beginning of this driver in
>>> commit 43f66a6ce8da ("Add ipw2200 wireless driver.")
>>>
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>> ---
>>> =C2=A0 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++---
>>> =C2=A0 1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>>> b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>>> index 60b5e08dd6df..30c4f041f565 100644
>>> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>>> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>>> @@ -3770,10 +3770,9 @@ static int ipw_queue_tx_init(struct ipw_priv
>>> *priv,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct pci_dev *dev =3D priv->pci_dev;
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 q->txb =3D kmalloc_array(count, s=
izeof(q->txb[0]), GFP_KERNEL);
>>> -=C2=A0=C2=A0=C2=A0 if (!q->txb) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IPW_ERROR("vmalloc for auxi=
liary BD structures failed\n");
>>> +=C2=A0=C2=A0=C2=A0 if (!q->txb)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> +
>>
>> =C2=A0=C2=A0 No need for this extra empty line.
>
>
> That's right, sorry about that.
>
> Can it be fixed when/if the patch is applied, or should I send a V2?

Please send v2.

> If a V2 is required, should kcalloc be used, as pointed out by Joe Perche=
s?
> (personally, If the code works fine as-is, I don't think it is
> required, but it can't hurt)

There's always the risk of regressions, which happens even with cleanup
patches so hurting is always possible :)

I can take a patch changing the allocation but please do it in a
separate patch. Though personally I wouldn't bother, ipw2x00 is an old
driver and not being actively developed anymore.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
