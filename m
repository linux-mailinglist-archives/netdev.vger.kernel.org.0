Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579F547BCD0
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbhLUJX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:23:56 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:48457 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236335AbhLUJX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:23:56 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N4A1h-1mHILL3et7-0103h9; Tue, 21 Dec 2021 10:23:54 +0100
Received: by mail-wm1-f53.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so813387wmb.1;
        Tue, 21 Dec 2021 01:23:54 -0800 (PST)
X-Gm-Message-State: AOAM532vQkbbxFoMchKoE2YDv0ctIyZExlrp1xM7AcBLnwJXkhf8YZCv
        Yj1NE+WNYEYb3sm1va3/RftZO5obmDWSbTn8olU=
X-Google-Smtp-Source: ABdhPJxu4IIGUAJNFiVsKRHmu5Fm1WfAFFV+LIjz5QIC1dQeqlZKZlfsQpcmI+Ykki0QMCXpv+QkW4e8nyXrisyOwUQ=
X-Received: by 2002:a7b:cc90:: with SMTP id p16mr1841210wma.98.1640078634500;
 Tue, 21 Dec 2021 01:23:54 -0800 (PST)
MIME-Version: 1.0
References: <20211221071426.733023-1-wangborong@cdjrlc.com>
In-Reply-To: <20211221071426.733023-1-wangborong@cdjrlc.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 21 Dec 2021 10:23:38 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3zQm7zJWprcYq47VZD0ZZsuOTR3w7a8k78VH=3he2Fdw@mail.gmail.com>
Message-ID: <CAK8P3a3zQm7zJWprcYq47VZD0ZZsuOTR3w7a8k78VH=3he2Fdw@mail.gmail.com>
Subject: Re: [PATCH] net: dl2k: replace strlcpy with strscpy
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:9Jrpw3QjTo4hxhWFiFBXUAzRrXEZkyoHhbGRIoY1m4nASCg6EcF
 ZOODLhQK9cIt3r3wTu/LmQRYoCcPKhTmP2qiQibZ8vUx36LKuVBn5ItvlKd+SH6PcqCgyqY
 7bhY9Dp23pNg/nwvFSpPJXWAt5QUxjCU3KYB2MYCGEwXN4oOtokFXI+yEQdZdBeDvYO8QGt
 RRLHRkMSvmmArE0bvr2gA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UmxuFodIhxM=:MGaX4wsZkCV9MqhDsbfaMn
 gF0cnMQgzdej7XWOs8iYeK40EvIH+ERCn4hCkga9x4z0GQZU3+afcPtZkqspG9LyzFc+0GocX
 AVyWsb5oJhelLjsDOc26P5dbXjYAJAiwHeoq+3ptGJEAL7qj7qJiEM9wLHuu/DTR11tNQd/li
 LqXlamnDlmH63h6jygNyfrGLFXhFjOlXtEPrORQyZcyNETm5fmYTJ6l7SLwb0MPeNa4T076Tj
 kPWHzOk4FjSqIYSGsSKk4zirKu+6HpwkIVmfPmxJOyiz3NN4a3BHcHfHqmQ56v2ZjZbBYDBhz
 SH86uhSWi++KVcBkFoLl8cQ5be9GFSvOHoz+PGKbS4EQ2mlsjs7clC8/sh9nPpaPPxBG/BiNT
 R8hvKXQR1wBm4cNXcf5aq3Wuh4FNTVot0XtWA4y4F33X5dymaHdPCZPzM5216N81xwtx9IB8t
 d4pJdq1BlQ+892/yngKUXDeSg6IFZjVFeyIp7lEvl9jt7ng91dECT6vbZ/Ya2+Y/z9gEPyW3X
 PeGFAE3OwXZwWZbIcfKpx7mBmWgu+v0SCNdiLsVTM8o9aLqzq2xvZpwAzJsWOIDp1HHzYnudW
 bXowfCc+DW6L3T7VXPkmD/q0DpaUY9rHX1nU6WolF/2F9RCoFQSWQoJtofZyIOrCoS0Igtg1Y
 35lumcp2P1IzN0HO3M0Gqe0MoLJtARE3UX2vh3Ya8O5ZohAi1odwix3eCBWxH6/Q2gf5px0OX
 zg9h7l7XGeZinid1YgZLFuNV45cQNcGdWlzZIIkhXp07oP5ElIoHZA3t+gOPHN/1ssP2YJC74
 5KgUdMI/0Dtk8g2n7uTtZXdHccDXlq4SZRDKkBAntBlqTD+0b0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 8:14 AM Jason Wang <wangborong@cdjrlc.com> wrote:
>
> The strlcpy should not be used because it doesn't limit the source
> length. So that it will lead some potential bugs.
>
> But the strscpy doesn't require reading memory from the src string
> beyond the specified "count" bytes, and since the return value is
> easier to error-check than strlcpy()'s. In addition, the implementation
> is robust to the string changing out from underneath it, unlike the
> current strlcpy() implementation.
>
> Thus, replace strlcpy with strscpy.
>
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>

Are you trying to eliminate strlcpy() from all 800 files using it
completely? If not, I don't see a need to fix individual drivers
that use a constant source string and don't use the return
code, as the behavior should be the same.

While it seems reasonable to converge towards a more robust
string copy, none of the points you list in the changelog apply to
the function you patch here.

        Arnd
