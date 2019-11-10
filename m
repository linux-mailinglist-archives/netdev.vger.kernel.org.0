Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55D6F6813
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 10:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfKJJQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 04:16:22 -0500
Received: from mout.web.de ([212.227.15.4]:39523 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfKJJQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 04:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1573377369;
        bh=dmkasPD5KcB3hT25UbInY3ZEqQ5F55qpJk75IzR7b+M=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=Slsbj5jFktzGyQsRpSN1tp8GGAiYCZv/yuUtPEy+FIS/pzCEnAw3xp5Oa/jSjM5bq
         cWAtqEhzXLba/AzyHbEMK46a19rracdc1MuxeFyn7swSEFk2Lj5q+Tf2tuSx8so1nH
         7j3dt/3LYwT5svfWc4IEvHL5hw4p47SwObtgENRg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.170.66]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MF3Rz-1iiKaQ2DwB-00GJzN; Sun, 10
 Nov 2019 10:16:09 +0100
Subject: Re: [PATCH 1/3] fsl/fman: Add missing put_device() calls in
 mac_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Wen Yang <yellowriver2010@hotmail.com>
References: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
 <63d9c06f-7cb8-1c44-1666-12d31f937a31@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <1efec196-bec0-c15d-03a6-0d7a448add8d@web.de>
Date:   Sun, 10 Nov 2019 10:15:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <63d9c06f-7cb8-1c44-1666-12d31f937a31@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KiY/LeVuD380w8GV87lLXda01B2k55wfehsXqC2dmUK2EYE1xzG
 JVBTtlLlk6+92Toqc8E9jZCOrAoEW8btX4gpBQ8MwN7XotbXpvlZ/QX/dzxDNGJWmQoN6+B
 nYLHnMOUmX0WhT2SWUbTLvfrvoKfN0bGlhX7cInEvgStNUv/CiEQzIcQRCvRrAvxLDnrP0N
 /Il1PB0mp0VPnh1vtnzPw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HVPc5C1JJtw=:tZXA5H/XpuDB++K2qO1DaZ
 C05thr/vAfdpZRIFhCjrFtzzdd3/aRt6NuKCSUaXj0q8nccrJZVWLua4ctqNFas+7sEliW5x6
 bBY4fgmSmySHbRyyQaGBxQ05R2QlJIRUth3SACeL7jbBPFPQ9PS5CpM34XUSL5o3gsFk8JzHE
 aWgA+aqCN+QmyJ0ESJDkbvf/G9p+acQCVfbT+W+6BS0z2qE1WoOKKKcKvzdAk+1yrlpKUsIWR
 xsyWDJXLSsfCnd5+0Zx4qlMfX9rDOxLedzrKEOjOBkwpWldS74JB3fCiEFgwFmk0Yqc+Qzhtl
 P6ynbyRpspPeTCgHZV4XD9yDjUO9nC1gLfvRenZQ3RHZhrrtVaLrDyrlSl4H6Wp39J80crnVG
 C8Xf4qgoSD3JhCLsQgd4ZWeqJHQKvabWovSQtreQ3IN2URCkMfvG+n0J+pFEz4mPalemriWQB
 rHF5FytXnifOLTrMnStOhFlY9kEwPx475FIVBUn5ghEJKM0Nq/V362vRuS7w/QoquXsKFB3UQ
 2kqx0YDFJKoNcAQEC0M9duvWQ/9sbqlsM/qDMAjQ1CGt8mXAOxn8eIWSL4Zm8ofjyAmYfYnxR
 uefX5xdi9LKGZd2MiHQG4m1XFZkNV4jGd8WdaE5TmFwczQIl1tgajwrzr8TxqeFbFmSxFNxP5
 I28ejyKKggsaRn48Gm9nZ3014IjJZmuJcwYHtN8K9K9POQ7xQ9c3z68bNqcb3+E6KSzMebKJ+
 Mv2GlHykYsHnTksdNy8KSheRqWcv4sVz9tm8KgHR5crqeEgmy7/wYe9ZB1k6XJ+PCmoeyc/Ia
 t3Eg179aP0RMgnKyL+DuNf8VqNgzynZcRQQsQuLmksh7VQBciFC2ihbVfGn5UzBf42bjfZ0AO
 7Y3RDPi11IXELsRsVTzDGOsBaCsWCwQAmtCF6xePUUFvmv1+b9T9xC0ZMYyq/CM+AVVYViQJq
 XvDZl9C+uSQV/soJ5maPTQjAden2ilzpye3AjMdV0IADGO1tRSRwAMBChGbYYZs39IU4ES+tN
 yWVZG3RYVseFLJDgB/zVh/X3t3NkV0s3i0+GMw4rjwDB9DqtxBqzciK4bI7qsd90/O0qQPVvh
 6drVYjZpp8D2ruiMYumxDo0j8AT6X0ub2c8Kqk87NdVSnwQckI7MWKRO1GmbwnRjBjVbyv8GO
 rjz+XJimWOsdw5AJZt6wwm2zdhafA9y9o+8KvsnSVHgKm863kO1fInM4c0K0O54M7UPCP5AN3
 sYbDUi3pXsmsc5IBseoIVE+OBgU4nGVEGNVfmiN1URfQ9H+H7rKMgPvtNF7o=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Generated by: scripts/coccinelle/free/put_device.cocci
>
> Thus adjust jump targets to fix the exception handling for this
> function implementation.
>
> Fixes: 3933961682a30ae7d405cda344c040a129fea422 ("fsl/fman: Add FMan MAC=
 driver")

Hello,

The information =E2=80=9CState 	Rejected=E2=80=9D is displayed for this pa=
tch
at the moment.
https://patchwork.ozlabs.org/patch/1192385/

How do you think about to clarify the development situation for
the affected software module a bit more?

Regards,
Markus
