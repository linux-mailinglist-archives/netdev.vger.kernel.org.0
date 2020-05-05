Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736DD1C4E2A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 08:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgEEGQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 02:16:15 -0400
Received: from mout.web.de ([217.72.192.78]:44503 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEGQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 02:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588659342;
        bh=XmK5O44OmJ3eYVQg33Sdnbohqm5cOU1jNxpCWHBTu6A=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FAFT/bMXb6o9udnUvj8IE/L1kcJpEvX+KRzsgKlil/cVeWWqvLzxv4xnOQ+Gw0UrO
         MGp/YBCd84W5ns4q4eWjXK3Rt8giJ7exKL9MBhi8tVKPqeNH1Gj5bjCuJd82+2Z0o2
         pL2gCqj36FZsO4b05mt5LKFUMmBm7OzXxE+qtEzc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.132.123]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LuuS5-1j5Q683PyD-0101ej; Tue, 05
 May 2020 08:15:41 +0200
Subject: Re: net: rtw88: fix an issue about leak system resources
To:     Dejin Zheng <zhengdejin5@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
References: <79591cab-fe3e-0597-3126-c251d41d492b@web.de>
 <20200504144206.GA5409@nuc8i5> <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de>
 <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
 <20200505005908.GA8464@nuc8i5>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <c5890e43-4b86-eed2-4de9-caa70743255d@web.de>
Date:   Tue, 5 May 2020 08:15:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505005908.GA8464@nuc8i5>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:04v4GgQazZfnLBwYRDKACuz5kVWtBLeCVWNzMsfuq0kNv5Luj/1
 g6h/n46RJVkJ1Bo0le1H0natVVECtTWfhpf4azmzAz8Ph/RoPtIYOiEB0hlQmrzZRth6qlB
 4qQ56bRgBHIp82HyBzy8oSLIg2fMEMnZ+9WExPiESlyc8r1Q2GfE4HcQmiT9XDBLWl5lZ3t
 AkBzqOjof+LsTljRMeCdQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lkTaNKRfqBY=:7S23YAPDfggYtmMwgw/bvY
 Kc4o1/tOR0+mNqygGaszEAIAElITYnGEZMO36hEMyht9J+3lvx/ZrBeQg7aGElj0EplcicwMh
 pyWBDV18J9vodPvxikdPu+MH7fN1xoWTYSkbHfAbSq/+qhfflzzm/zNVW6UtyjEsheKmyfHGq
 ihY0pg815H7UgOr+EFb+bN7t+VakBg5EPVEomte+fKBoSN5IToaurYTHzTfC69Wm7U/HV96F7
 xJng4QATI/XdxghhskYjU4QefXIQYwE+/TItkNT3k3bAZbHK/2j5d/ojKSpvdLDx7pYgybg7Q
 LwhQfotmEIOD1sqBXe+cvMLiwS2n5uEhzI6yVddNawkTfhTy46updfBR42gAJ+9T52kbLuPjM
 ueJQ8vX1RRAIlvp3FIaWG51pSzYts5OruMdJpwdwqANk+NuHkmGK1k/5O25QPSYE7ZJI/sygb
 uuoiEqCdZClfmQ0oUV2nx4aNJbalxG0KtosoVjmuEaiTdRjxyqdB5eXo8cPBEKppoZN/SI6Bt
 vHDtUmzQxTpjZ36/MkPSJCqxoo0UBhNR4KFSHBwBx/rUzzeU0iQZV8MtFcGlUsrPgP1qSaCUg
 pIy2FLdI3sFQnS7xGyfO0TSXBuhqJpfrhfw9zJ6qGThXe4hdVduIKPg/FqaUJPhatsL8F6pin
 BH8nZynXzQdi+gqj43KBgUctsMdjg+9lJmbl9aDaboYtyo6+rHPPOUO6z71R7dVsL/o6C4P3s
 McesrJiNNri0WdYjMSYmE7vY5+/OkWIykPwN2yvwwYmjBA5IeeXQtYMyuuIOf5bsN3S+FWbrw
 aJyLnm9wcikm43gbCREeMMDm/ulpeYk3lh7jn9rdYxDAZgPnNBk6Vi7dUnwO4BZg/tVqYYQtC
 BKvX+8xxlq5WZrAKPUEWr01QWSK/yfHLfRxdCwq69HKSHxHB5Ce+GoqlBHoMR0B9vR3fi5F+a
 ahQOkSyPiPR7D7l1kVtb2EpqbtL5t14I+TIcmdVGtMvaKZ1weRsRsrZRsgqG5DkO23UsFYJAh
 yX3wQwdo0op5UIsEgyzBuko72D7thJbW9pjKNQ1XmY8mcPxudxuaK/JriYJ5sciaTHA8E6AxP
 V70xdtg0YwRd0qOoT/IKmePidACjj7HZYle6939J1PrVPSi+F71xt7JlsTeq5PRBk047xw9Q2
 ApHn6B1aKB2zzKa5l8jGrRitqiSq5gFoDj60vlokLxv9+LaGiI4QH1+2uLiZdMs3JwKLJAIeA
 eAux0RSRlqt3JTBOT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Brian, Thanks very much for your reminder,

Reminders can hopefully trigger positive effects.


> These comments have always bothered me.

Thanks for such information.


> Now I can put it on my blacklist.

I find it unfortunate that you choose to adjust your communication preferences
in this direction.
Thus I am curious if other contributors will get more chances to integrate
another bit of advice into your software development attention.

Regards,
Markus
