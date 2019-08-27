Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8589EB62
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfH0OpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 10:45:10 -0400
Received: from mout.web.de ([217.72.192.78]:46695 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfH0OpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 10:45:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566917097;
        bh=136zRDCFtnxKZVXYpCFtMMCXu8o+6cc0jXSq2IGvEdE=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=JIdC+EyHDjXoCaMupMgQjdj/fx/udqs5aYP90IMaA50uYo4ueWb26+SRSJQRn3Hez
         5AmIS/Zcyff9TarKJGDjAbRu+gg4SjaDhR2StzJd8sEVljr1+xv8TDy6A/jWqejCEN
         6UtQKr2zT8AzT4BMVi7M9zdfY/MkoYVvJsOoEwXs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.143.232]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LtWsC-1iAQge3NAq-010t8c; Tue, 27
 Aug 2019 16:44:56 +0200
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wil6210@qti.qualcomm.com, "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] wil6210: Delete an unnecessary kfree() call in
 wil_tid_ampdu_rx_alloc()
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 mQINBFg2+xABEADBJW2hoUoFXVFWTeKbqqif8VjszdMkriilx90WB5c0ddWQX14h6w5bT/A8
 +v43YoGpDNyhgA0w9CEhuwfZrE91GocMtjLO67TAc2i2nxMc/FJRDI0OemO4VJ9RwID6ltwt
 mpVJgXGKkNJ1ey+QOXouzlErVvE2fRh+KXXN1Q7fSmTJlAW9XJYHS3BDHb0uRpymRSX3O+E2
 lA87C7R8qAigPDZi6Z7UmwIA83ZMKXQ5stA0lhPyYgQcM7fh7V4ZYhnR0I5/qkUoxKpqaYLp
 YHBczVP+Zx/zHOM0KQphOMbU7X3c1pmMruoe6ti9uZzqZSLsF+NKXFEPBS665tQr66HJvZvY
 GMDlntZFAZ6xQvCC1r3MGoxEC1tuEa24vPCC9RZ9wk2sY5Csbva0WwYv3WKRZZBv8eIhGMxs
 rcpeGShRFyZ/0BYO53wZAPV1pEhGLLxd8eLN/nEWjJE0ejakPC1H/mt5F+yQBJAzz9JzbToU
 5jKLu0SugNI18MspJut8AiA1M44CIWrNHXvWsQ+nnBKHDHHYZu7MoXlOmB32ndsfPthR3GSv
 jN7YD4Ad724H8fhRijmC1+RpuSce7w2JLj5cYj4MlccmNb8YUxsE8brY2WkXQYS8Ivse39MX
 BE66MQN0r5DQ6oqgoJ4gHIVBUv/ZwgcmUNS5gQkNCFA0dWXznQARAQABtCZNYXJrdXMgRWxm
 cmluZyA8TWFya3VzLkVsZnJpbmdAd2ViLmRlPokCVAQTAQgAPhYhBHDP0hzibeXjwQ/ITuU9
 Figxg9azBQJYNvsQAhsjBQkJZgGABQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEOU9Figx
 g9azcyMP/iVihZkZ4VyH3/wlV3nRiXvSreqg+pGPI3c8J6DjP9zvz7QHN35zWM++1yNek7Ar
 OVXwuKBo18ASlYzZPTFJZwQQdkZSV+atwIzG3US50ZZ4p7VyUuDuQQVVqFlaf6qZOkwHSnk+
 CeGxlDz1POSHY17VbJG2CzPuqMfgBtqIU1dODFLpFq4oIAwEOG6fxRa59qbsTLXxyw+PzRaR
 LIjVOit28raM83Efk07JKow8URb4u1n7k9RGAcnsM5/WMLRbDYjWTx0lJ2WO9zYwPgRykhn2
 sOyJVXk9xVESGTwEPbTtfHM+4x0n0gC6GzfTMvwvZ9G6xoM0S4/+lgbaaa9t5tT/PrsvJiob
 kfqDrPbmSwr2G5mHnSM9M7B+w8odjmQFOwAjfcxoVIHxC4Cl/GAAKsX3KNKTspCHR0Yag78w
 i8duH/eEd4tB8twcqCi3aCgWoIrhjNS0myusmuA89kAWFFW5z26qNCOefovCx8drdMXQfMYv
 g5lRk821ZCNBosfRUvcMXoY6lTwHLIDrEfkJQtjxfdTlWQdwr0mM5ye7vd83AManSQwutgpI
 q+wE8CNY2VN9xAlE7OhcmWXlnAw3MJLW863SXdGlnkA3N+U4BoKQSIToGuXARQ14IMNvfeKX
 NphLPpUUnUNdfxAHu/S3tPTc/E/oePbHo794dnEm57LuuQINBFg2+xABEADZg/T+4o5qj4cw
 nd0G5pFy7ACxk28mSrLuva9tyzqPgRZ2bdPiwNXJUvBg1es2u81urekeUvGvnERB/TKekp25
 4wU3I2lEhIXj5NVdLc6eU5czZQs4YEZbu1U5iqhhZmKhlLrhLlZv2whLOXRlLwi4jAzXIZAu
 76mT813jbczl2dwxFxcT8XRzk9+dwzNTdOg75683uinMgskiiul+dzd6sumdOhRZR7YBT+xC
 wzfykOgBKnzfFscMwKR0iuHNB+VdEnZw80XGZi4N1ku81DHxmo2HG3icg7CwO1ih2jx8ik0r
 riIyMhJrTXgR1hF6kQnX7p2mXe6K0s8tQFK0ZZmYpZuGYYsV05OvU8yqrRVL/GYvy4Xgplm3
 DuMuC7/A9/BfmxZVEPAS1gW6QQ8vSO4zf60zREKoSNYeiv+tURM2KOEj8tCMZN3k3sNASfoG
 fMvTvOjT0yzMbJsI1jwLwy5uA2JVdSLoWzBD8awZ2X/eCU9YDZeGuWmxzIHvkuMj8FfX8cK/
 2m437UA877eqmcgiEy/3B7XeHUipOL83gjfq4ETzVmxVswkVvZvR6j2blQVr+MhCZPq83Ota
 xNB7QptPxJuNRZ49gtT6uQkyGI+2daXqkj/Mot5tKxNKtM1Vbr/3b+AEMA7qLz7QjhgGJcie
 qp4b0gELjY1Oe9dBAXMiDwARAQABiQI8BBgBCAAmFiEEcM/SHOJt5ePBD8hO5T0WKDGD1rMF
 Alg2+xACGwwFCQlmAYAACgkQ5T0WKDGD1rOYSw/+P6fYSZjTJDAl9XNfXRjRRyJSfaw6N1pA
 Ahuu0MIa3djFRuFCrAHUaaFZf5V2iW5xhGnrhDwE1Ksf7tlstSne/G0a+Ef7vhUyeTn6U/0m
 +/BrsCsBUXhqeNuraGUtaleatQijXfuemUwgB+mE3B0SobE601XLo6MYIhPh8MG32MKO5kOY
 hB5jzyor7WoN3ETVNQoGgMzPVWIRElwpcXr+yGoTLAOpG7nkAUBBj9n9TPpSdt/npfok9ZfL
 /Q+ranrxb2Cy4tvOPxeVfR58XveX85ICrW9VHPVq9sJf/a24bMm6+qEg1V/G7u/AM3fM8U2m
 tdrTqOrfxklZ7beppGKzC1/WLrcr072vrdiN0icyOHQlfWmaPv0pUnW3AwtiMYngT96BevfA
 qlwaymjPTvH+cTXScnbydfOQW8220JQwykUe+sHRZfAF5TS2YCkQvsyf7vIpSqo/ttDk4+xc
 Z/wsLiWTgKlih2QYULvW61XU+mWsK8+ZlYUrRMpkauN4CJ5yTpvp+Orcz5KixHQmc5tbkLWf
 x0n1QFc1xxJhbzN+r9djSGGN/5IBDfUqSANC8cWzHpWaHmSuU3JSAMB/N+yQjIad2ztTckZY
 pwT6oxng29LzZspTYUEzMz3wK2jQHw+U66qBFk8whA7B2uAU1QdGyPgahLYSOa4XAEGb6wbI FEE=
Message-ID: <b9620e49-618d-b392-6456-17de5807df75@web.de>
Date:   Tue, 27 Aug 2019 16:44:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:b686WEIBMhQs/LRLyV8vd+6S5YnUNI6Z/b6Mb9kUJkzfm22gkgr
 SD3bwJXJ5QYl5l6xcEC+ODDSWEmEM+1Tj2R/LQPx6ZDUX446fGmIpVjwA4/9RrzuJJiYRSr
 cr9bPo1OaYdGhir/9y+7lnNPswNsgrSZ9v+TySYGAoolEBeMWMEpS7q/lk2Ueyie9Spfvb4
 fWXgI8v0Er5wyF6j5DDaQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nlpurH5kzFE=:KhYmMYV8dRvHYcOWKRRTsV
 eyO402nyTD+mB9uwhPKkZAB3ox1w2JQIvDuL7J3R88aFNWWFhhCXO7bDiVJFl2SEJDUwPvy2i
 LYHmAEAOA+Bh5GJCCKwUJKo+S5EIkSrtJ0AYO8VP39DMzBC0WP0wHJt8tb98OEjF1TJMWzdTd
 jCUSAIeKRnJzhy78YI7du3RnVCyH+G1TDuCcNx+NJpojvXAQK0XWzx7dqETgdarAOLZamzK4k
 B/WW/bcU3qP1KI8lFlC4Ukk0i5kTLnasL6H01sLZV2bCFIWNBjtrVe1RXbUkvsE+xuKk97AVV
 45whQalTAmrpcSIbwn8e3oMWriGSinUy6MEwXO1voZ6s18fe6utZhxbFH34N30xz6t01iphPZ
 jO56wMPPlPrlByE0C0GAh70ZX0x97WQbMHTufymNPpTJf1wrs2FaP94VvMlbwyw0s0rcFCXNA
 s7mdl15fdUrAb7DS9P++EwJubCf2T8roEMvq1RXJUAjod3mvRViBOjC7zIkQIQTDnLYP38Rwn
 y7oTRQMxZtXKJMK0sgfkyHNzYnxwWAx6UMoppaDBgKMj5e8QTB8kKyobs/oREggtrUS6c7YoR
 pX+Gr0uAnbQgYfLEieUUfCVC5/mWCQEzcMhlOVWXalI77hQ5GU0XwbUf4Y6DMw2dP3cIXM42z
 QAcoYmUUyaVNz6lfy0BVCdUKbbIjRNImV/DgmdXR+/J8Bia7+FnZeQacL4bauPFBPJS7FiQXY
 A1LQ09IYM8X1WGCxsnJGU2NXYm8PAvC1/+bijiHYAQJriXNVJJr1YJ11fquMyqcCEUDm+gzwg
 bpV2BdG0RFaul/vE9o/ydlVvkCFckzDDPyNIjfF/qFuFcSv9zOzgZ+LBXi7B9IjONLqNu7k17
 0UIHA096Il7hsamUXFczdycotF36SU7yDANSym6WsOMfNv3+wqjox/yMQZ1vGsOmZjUZytDXJ
 plq2oD0dYj5KLAAeLciCXQJ4jdedngsuQIFcCfh8XTW0EIVMk/aW33f+3gnuvCK5WhUytrArC
 4ctYGE74Q8vsLCpiYiogOx6AuNp3u+DQO0hLa/pw7pKGx0RZYJNRmMSynNmEaYWhLQhe1A3Qk
 mO6jVqM4OJNmoUjnN4a9S1QY9DfCgzN7YioRQK6Ae3K2sTLsybmu5ADmZmUdaXA9ElJdTEgn9
 ehwb8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Aug 2019 16:39:02 +0200

A null pointer would be passed to a call of the function =E2=80=9Ckfree=E2=
=80=9D
directly after a call of the function =E2=80=9Ckcalloc=E2=80=9D failed at =
one place.
Remove this superfluous function call.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/w=
ireless/ath/wil6210/rx_reorder.c
index 784239bcb3a6..13246d216803 100644
=2D-- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -260,7 +260,6 @@ struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct=
 wil6210_priv *wil,
 	r->reorder_buf =3D
 		kcalloc(size, sizeof(struct sk_buff *), GFP_KERNEL);
 	if (!r->reorder_buf) {
-		kfree(r->reorder_buf);
 		kfree(r);
 		return NULL;
 	}
=2D-
2.23.0

