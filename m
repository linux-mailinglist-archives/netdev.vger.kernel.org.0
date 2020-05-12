Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40571CED20
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 08:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgELGjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 02:39:06 -0400
Received: from mout.web.de ([217.72.192.78]:45575 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgELGjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 02:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589265532;
        bh=w1Yj9AltlGe368GUTzZ7ijrqNOUbDEF3Qjva24Q6WJI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=nz+AJo7gANfqQ31J3jz/XWNo62z7Fu+oc/qanZwCX12oqeuBgYWNdWz3SqD2yo8Rg
         1k7cmO65A8QUBkwsqVZdXOv2A0S8JnnRgwkfLbJLbh6t7Lx/sCA/hHygILEtNgYzpL
         jCaPoWagxPIQU9YFmkeAq69TWPG8oOgMGs+1/DKA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.36.232]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MmQcl-1iqqXF1ymP-00iUr7; Tue, 12
 May 2020 08:38:52 +0200
Subject: Re: net/sonic: Fix some resource leaks in error handling paths
To:     Finn Thain <fthain@telegraphics.com.au>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de>
 <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet>
 <9d279f21-6172-5318-4e29-061277e82157@web.de>
 <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet>
 <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
 <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet>
 <9994a7de-0399-fb34-237a-a3c71b3cf568@web.de>
 <alpine.LNX.2.22.394.2005120905410.8@nippy.intranet>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <3fabce05-7da9-7daa-d92c-411369f35b4a@web.de>
Date:   Tue, 12 May 2020 08:38:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2005120905410.8@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pCeNe6/ZfsXNuMeFLgFd8XMcEZxSQcMx/mz2KypmT/daBYHf1hP
 o7A+Bx1cIU4rOkWNctL8K9CsQvVtxwp1irXzPV5+/82p/Kif/ZZ4Ubpii1fmAlfc3g72cbr
 MWH7WpQ8Zhp+TVwx2aoLCCI99RTZ8PTg80pSFfecn26EWqAekzxDmaktaogRMndR+qmAkw8
 LDvUk2SP/VhdzLfaAC02Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:J6PMyRMGBcA=:WWk3NSSMfuC5VNaFQndOFG
 NDkxHqV4ZDRvfS6e0ILqoSMqlGEDXod0UVyztw4ywHLOwrf5x1jiQDMMpylvtxgGuvgdC6CQb
 MtJQGXnjKgiJHVeiO8VJIA6UPtEHVsJ9TOknfEASGjjVLnUNEUb8JHfFFPY1yxtxjNqFbOb25
 8qb4ZL6G11cprR954SEp44LBuzZosLBiMBk94PXWtIIH+7l53lvGILP6HpfQ8RVqdX59+Lron
 +/euH9v2VAlhDY34SSUn7JA9q+YgFTyQQVP9rCVC/PH1cVL9HeJrwsZpuJIe/g+TnzlmnNoH/
 dGGKqeuGXjXHkC93jMeQiXk+Hl6KDJPPvENt3JxydXVOs34ZYb1UoJB7Ex7sWTjVy4vyp0Ylz
 OP+nA0dzFK2059Opuh+0BYomACc3TG7zrPG/mLuAlEHKjh3yXcus+Wpgvm2MMFQ+NKT1oqAbM
 SKqB7JfvOsrRXFeGhYlmgtnNg8I7juDoliwQmdDXEzXjeaB6DlcvAyu763Omv4Jjiim8GlYA4
 1wjfPWf48HFdF93WZ85BAMyW1nVdq5eTMkvW0wgivuEben3YfRvrdl86z7ETQZfqKd/o5jXv+
 k4vnxFnae7Cad+0onzTUF29X9vvFIJl7iIjzpSIQw/UNBli47+WAI7/cSk2WQIbt9KSeVuDbn
 fyGjmD7utooUo7Pt1GIQ3z2Vkmm971o1r4/27Ak3Gzszo0dn704Z+QG8xLdf/18+LRtbraJQx
 C6NE0fpxfdScNF1U9PHlyXnc/p9m4uRPcT37AWDR3zlxSTGogHTL91Y7HvuVtwsZd38dFfMI8
 fJlH6rMIaVsg3lrR8xWSK9FDnlFf5z3eVX4Er6IGCqFcmeOt9VVdDFtJu3xfmkJkOKqof/hqh
 NLfFKyP94Itfvasy0XGq5DbunMYLxKYru9XF/f5yVRv3u11DJhMqGMz0DX4Ld1HJcAMAGONUD
 ApSsIOy06EKhs31/2gJu4qXPFy2ariXfYq+1DkAObdvmchR+pe5+PuZAZLOlEm/43clLD9Fuy
 NzmdVx7l/4vzbHxeORCdCRrWOwyBIBYRReIzpG8pKdtP7STPs0Iy6e2CZbcI5hMM43zsz9YJU
 oJbiCGbrrsBv8760MgqEb6BAMKRq4ojeR3LdmiSk/sXJE2bN/EZFGCQCZMBwvBJ6UAN3c1iKG
 ilcq6LfjVgCzOR8+qEhIJ82qfAADwirTincqgHcQ4tBLZ3aoMaq+UHIiLeHleePG0UJ9T10eJ
 HZrGqwlmQiOviqODh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Markus, if you were to write a patch to improve upon coding-style.rst,
> who should review it?

All involved contributors have got chances to provide constructive comment=
s.
I would be curious who will actually dare to contribute further ideas for =
this area.


> If you are unable to write or review such a patch, how can you hope to
> adjudicate compliance?

I can also try to achieve more improvements here to see how the available
software documentation will evolve.

Regards,
Markus
