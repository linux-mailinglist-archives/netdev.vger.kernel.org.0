Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B823B1F8137
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 08:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgFMGO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 02:14:29 -0400
Received: from mout.web.de ([212.227.15.3]:39725 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgFMGO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 02:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592028854;
        bh=zzfaI/5Fsj4DsU2m6PXbv/Wzw+tpFP4l9qKOFWBgplg=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=qCK/3o2KsY4Tl3PSaiQoCjwXc3UtktMx5ZOawJzUJJX3lkTQF9sUiW8yE057YfAUo
         BMCtscO4e3sijcgJQlAwJVJ+NOR8EoO5DRlCyBPh7XIVW9SxwwAxA/R4A+a+BREkvm
         HEjThws7uLPAACk2VY+3ium3mYoLiCN3pWfREm58=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.51.155]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MODiX-1jZCsJ35QH-00OX0I; Sat, 13
 Jun 2020 08:14:14 +0200
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>
Subject: Re: [PATCH] rocker: Fix error handling in dma_rings_init()
To:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <c87858ed-a91f-22d3-09d7-17a00703d168@web.de>
Date:   Sat, 13 Jun 2020 08:14:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YTFLqxMUzBDbtI2OoiEMb6OVTT//BgJVn7VwQojeTBTBNTbzBeJ
 cTCqWiUUaYf2CTlswzkZE1GRKMgmystLRBUaNB8oBD5rPmrx9vf1Gvo0wkBQpJFLfddnm2V
 PK24ItZS2JVsxZ11z5F3tkIgXxNEFEkefapGoUYVGofS/niqRkScJZWA8mytO5tWaAtsWyV
 RnzvY3IRfY/n1Kl9UqRpg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XkznZQilmE8=:/s3dFtP8WRfzWsU8gEk8Ni
 NEHDKd3sIKguUbS0R9IuUD9r9uJGyAHj0PuB/uutT+BP6gqydBRbgzfVhh8iBChbamsA4qf3W
 +YzSONIOqInGc2fqdWz7WuaTUNSYZS3sIyhDZPvJ7q40O2TeGs5DWMXGWZ9pqQQMsg8OxXwnO
 yRO44PMBgYPt74zeOxTJftbaU+EpwH1S8BLlJXzBax/L3cRcRx0UlY5M/JuUAo8jmIYbvO31U
 mApvgXNzCNcXTZzERR/6gKFvGpWm511flihz6Dh+VvF0QPo5VJ7PgQLMa0Z8gIbVfXvso0Uu3
 M8OFQtYSi5UX+boaFpGI8v/N6l3tHDRSi19MGLDlTaqghlGUTp79Sq8E6sUKuN2rrqM/AkLL8
 h6oZy05z1Vo2BtPXihfAulUaKwFud6iUsR2DMdSFvCN9kGghrYDZcYlZdKrIM5Brs0UYX9SWf
 A/AV1XQqeRSwtWU9D9hU0rlsnuzr9X6OqX0iIQO/e/oEZh8780GmH9vPI3TLVK0aoOspnOdQi
 EFXcfQRDfpOKjcbEv5xoqj5f1Jr6zCQjqpzVmImvnZQCE8b7ryWhMbgrl1kNvVeSjtLA71rUY
 VES1rYnloakaXUNhOo8wCK2SzIuu476I/aQ7oznbIvoysy2ep6rXzCwMkpslOKYiW+8lE6dN+
 jovQpplbdT6d9Wr5B5TTz0x44G6zDJK/lgbV5WEzrZtOdxQahglG3jZG6/T5X6KiYzy3Ic33+
 4a07J3QeEBeUHew4k2my0vCO0lUrRLXdMeetE6l8j1mL2sl+thLcXTrTc+D6NMIzUgLyIvsCd
 ypXnjtPjqfNSFs/2Xcv1dsnWAAZUFOhEVjoIVxE0PXiMsi+E92ijaWWLNof73gcyioG5tHmtC
 81KpenQqVI8QjpHN63EsfazAfkrXjf7lNjqywb/Cjs6XT7r94ZqfQRmR2KZQ+/3vH9pZCdoCI
 DD9bgZmHNy1xN55yF9RH/aL24l3L8vo+kDp/ce0yoPu3QqQMy3b1jWht1L1cNdHFke+jelKSx
 oqL5PSf29LUDxmCXSyp2vbLK2bLKy2CfjDlun4pkfDO+FMPr36zaHIqIuQF8cwolJDFlfwohc
 vRU1iCfK43IxPHji7rjlbvYGLVLUidZSAwJ/w599W9iOrMpctPuMfV/gg5+qdnCFmaO0+IWto
 +io2FER5LoMPBB2XHnez0Rp0iyRY85zF985mn9M7bLF80ytmVjC1feRSPtnn8TgtDWK+C9lap
 CmRLilWUK24MkUO/7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6 The patch fixes the
> order consistent with cleanup in rocker_dma_rings_fini().

I suggest to choose another imperative wording for your change description=
.
Will the tag =E2=80=9CFixes=E2=80=9D become helpful for the commit message=
?

Regards,
Markus
