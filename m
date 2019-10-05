Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F93FCCAF8
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbfJEQJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 12:09:04 -0400
Received: from mout.web.de ([212.227.15.4]:44659 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbfJEQJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 12:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570291719;
        bh=1+fXZSHTAhxOAIXnw/ROPSDqcFHC4nZKNKs7zywpgbw=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=flr7/PuDfOcNNQENkxkN0UmJ88ssgmZkxi2s9hudyCKH1wV1O4ReLQrDadW73lTFO
         +mBOUk1TVW4c+11yGQwgrToaIYtJc2saAsvd6l+0OGIWuMEWWQUbWRxDZbrOEXUuR+
         dznhjE4Nt4hwbgMqpNK/F8bGatLreyIPMAvEMJIQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.178.111]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MPaxV-1iCg0l3e6L-004h4O; Sat, 05
 Oct 2019 18:08:39 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191004195315.21168-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] rtlwifi: fix memory leak in rtl_usb_probe
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <037d04e8-4651-a657-6be6-b1eca072bb81@web.de>
Date:   Sat, 5 Oct 2019 18:08:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191004195315.21168-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:PTXTyKlngoYizrVOmtkzORQ0kDz2UE5brHu1fjldv0jOV26NHPl
 qQU+vI2CNCQMcOVI+Q+SfQUbZzDwIgst3alsBn1CTgO6VD1RSnY+Tzs9T28ceINS5zP7S7A
 JrLrZhzEaZN3akDTc0m9ti/BLoC0hkptqPViB+Dr0SUZUW75I6ivDNsrm2W3Ym0Z6oNR20d
 KguwijeJ5+Z8fIO9MAljw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:05ZT3l++kVo=:Z369oQmBzxGgyJcD2+xEmp
 GHp+xqATYB0iHOw6UntDmO9Zgnj9dyzUG9hFRYKTzkJqjAufGn6kL7blyLMz9CFKrJm9qwids
 va7ASA191ssgDhvqNkqKg7SsvaRkXNERUKc+y3D0WSrnUpfXCjtFUtTs+O8d0uxkF7w9DMCuP
 cLGdBJkelieHbLxgJKLWQh2zgxxb4PPS41jejof1uby+RGA3NQVxKAas8uQSkyhhDf8kqAKI3
 5ics2Z4mXsPZX6gnvJMKHMq/YHoczMA1UyQm3M4OFVwsqFawSJ02V4xshtrYm9+Pj+ZgTW9mu
 7pFxSlL3sMGlKTBe+CcrhLmxRQ7ik/sjLShL4B9JjHVYyWO0zYJsosRv3h/3bMSnS8Q8L3yAs
 AVsCDvlGoEAcfsEm6SO1FJgPOo4+HlBp/ctcJ+lOJH4DwIxKB6Jp6KmUGyk+kto4TZDJozol0
 +hPwBfEkOSM0L1+uqPV1AqnIMfz+ZkTFfu0+Yz6Byr7pTzfmoiNO2FxrLwQiHTIzH8s3CqpvC
 P9AcPE9JsjhlPkCJs2vNP7NXnQs7E957ZR5ab5hIdcrPZjjoWvM31GV2oWbmXFHE8IJOVUt0F
 dxLQqgLJIhUyAsBOWhhiJXf2AEm6E6R0IHMa7LFHxtF+6GM8C1ds60byBFHBQUcsOanCMs1Mu
 4mWez5lztW08yPVaZEln2yV/NyOgJPkHRB57Bx/DneRK4SFrZCwvbU9miz6PsRxugsLvIU4Ry
 m9RzGCIRZvQ56Pi75AAvB0IP5XxdjzUTSlZblQKH4HJMSreTKkhAMAuCQIeVBhmmb5YAHzfoK
 V9T7yxqc3wINTT/YDvfOcRqFA6hgd1UJ/MXTxuWI+gSAReESG7SpOYBIlDbvZAnuhcueZaAyg
 T6rdbU/NqaBBIy+ct3NafaYsGbQyULJA4w2Ztw1XDP8Roc23zI9gFrtHCxbONWt4FvbxVFt5S
 tjTGKK6dumuFHhpuKuBUiuiPf0+L21gn36+LPL0BNY4SYVCTamrzn4NKw16l2irA6iBVeCtnB
 gJGJaPtaQTNUvjojs8jy2eLDoiul2T6+gVeY5k2CNDMYDM0CErOzOyvOtBKXSI4UYJHQdqtui
 sf7N7S4gZy2a2chJ7mZNZOwlXovi0xoAMkcs8Zb3M6TFFjPbjh1DMxBnXFfRGK053XKBdQA5L
 /lfYwVnpGzaOhd0CXHdzOaO+t0g5J9HybVG78XlowmSoNQlAvbqkGMPZd/k1DZlqIWGLtRRS7
 EsbPu+hbot9gRETO44Ek7HE86axs/h7c/8F20sqb4QKX05185b5mpsmSC/c0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In rtl_usb_probe, a new hw is allocated via ieee80211_alloc_hw(). This
> allocation should be released in case of allocation failure for
> rtlpriv->usb_data.
>
> Fixes: a7959c1394d4 ("rtlwifi: Preallocate USB read buffers and eliminate kalloc in read routine")

Which event did trigger the sending of this patch variant
after a similar change was integrated already?
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=3f93616951138a598d930dcaec40f2bfd9ce43bb
https://lore.kernel.org/lkml/20191001092047.71E8460A30@smtp.codeaurora.org/
https://lore.kernel.org/patchwork/comment/1331936/

Regards,
Markus
