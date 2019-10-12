Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0692CD5160
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 19:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfJLR0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 13:26:55 -0400
Received: from mout.web.de ([212.227.15.4]:60029 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729554AbfJLR0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 13:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570901189;
        bh=aTvoJhmGzJyzLDndjNa/ydXpVEmlvsXJjiOEAPQZ3vI=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=rKgDqQp5/RHTOZo0PQsXYux6r5z/YxAAuJtKPe7ZCf2i++vOS6nlb7hcJUl+46KAX
         xQj3HHdviSAvjZocQewz4+s7fnZ39gnWvyOtHufE1ro8QkrTjF85qiWaT2iwLEZ/un
         hr+GNBllg1jaSVr6hlqsmULEk8nnNXuXHqjb9OVY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.155.250]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lpw63-1hpWK345hv-00fiXk; Sat, 12
 Oct 2019 19:26:29 +0200
To:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luca Coelho <luciano.coelho@intel.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: iwlwifi: Checking a kmemdup() call in iwl_req_fw_callback()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
Message-ID: <71774617-79f9-1365-4267-a15a47422d10@web.de>
Date:   Sat, 12 Oct 2019 19:26:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:81oefqlZYHs5UgQG93M+vVZYpkwPZp8iXevuslFnEfSmxedsr7c
 yr1EoG818OF+pZu0w8C2kmoYcwRsByTKZD9gDqCW7BLrTKTBxiXjzTY8QzG+GtLrtGZ2Fe1
 wSTthsBaSJ7/04s1/QDo7h7hYnBpJejC11B5oyJ1OQAXAUURR+bWqHQIJnSUMzlfiv+m9I9
 AgFLUEsvtq8cUwMtT6D9g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:157GF0vRHQs=:3a94LDlEJEwjrgCLz71wZ8
 3qytvC6BgILZyKmLba5Iy94LnblfBMZsmgc1l7iKC8ZHUxa9DBJ9r6V5r2pG5igsrdgmc8dFR
 bf6KB0UEUzRRfJJ10dX8+QabKHQZg1YH7mdYAEO2RpIpDbS9SBYWKX7XPKRsl2qf7rKv2e7Dg
 yaUc65YsR25Q5LeeIZe1HumBHvX766058xz47TtQXahC7lOK9R2/FlLpFnAM1mYn6lLJuZuu6
 gogJOIGnsNyNowu+iO1GQPhvPaM+lV0/ZuZNF2w6LEFSAnplGR0/KyFlrGAyE0xoK5cuu77ZO
 LHX7b2sNFs5w9YlXLYvE7zGxERz8zh4an1dIhxbVKsQnzFZ8hGSz/xi/9+Oj6oklsyKpBBIE8
 1QpoaoYo2t6oEhVl7vdl2SRhuPwTVoExkujO+BGzfgdokUx7D9GUlL2LogkKVJmd5D5+frkpD
 rzV2zwLvQiezl9/uVdOm0ur+dyXWYwIzHcRetB0ElPKWSYGDpfPrH65sGOSHMmNLFU/JoBCJw
 AeUoZhDwPRU9Pa9LeagiJp1XaZxhAbG6H0VytL78HAMaWBMoTbCgq1U+3jcLIxT5kwX8Fh6MF
 WY3wIgH/n791ozfGe1wijTJkoQ2OvMfZU0dKs/B9VYIEsuVSMkClRx3r36j+eMSQF2c7qJGa5
 VKvbb41fp6M/EA5hY+tax0Ev3Z5Vgt5WBxwzJ2WNiL+QqEqVxLmX1u7jhRepPkoZ7N/1TM4lD
 sqDmexITjDI4rK8uCo6rBMtyYP/aPVIND4dfjjkHcNe+nWhvfiaYlxI/5Ev9H2bgkg8o0GJef
 lvuIKhcuKw3tvbm4LnGLKgeP3EKzBO0u2mIHclOY4TzrcV71ExGndCfPxyveUXqSHM/M51aCB
 KSFALEKPKjq4GAX6A9opeB9hoC2e+8reqiZs5mrrUp4l0msNzToCghX/AP8tNf2DfHH4X1ZZU
 uphGtS8RXl31CDeffZ/caaE/8NKEObmWLciPYDq+709YczpCkVobgxDsAYdZ62dC5uNASEp0V
 VJvP4NkAjEVbn21EsPGf9+hlo4Z0lCo8wMNziJfbaQDxudwHn6EkBKKzl0VpL5zSdkmxrpSB7
 NO+77f/7F6DBL6DeKj7gPGv/OiPx6K/rhesQye2fP5HCSoAPMuG5K5JBowe8XBHC6X2w+pxGZ
 rLMpShwRzmlgEzIbVlEJHR+sk7eb6IDsIxU/ZuWxds9vj97kjzYenbrpOZ4gnxpDD5PXzI0UT
 fi41vjidYgTdZeGRfh13gVwl1EBeMudn0xthqzTQtQn+VGKx90ZPtOrF9QgI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I tried another script for the semantic patch language out.
This source code analysis approach points out that the implementation
of the function =E2=80=9Ciwl_req_fw_callback=E2=80=9D contains still an un=
checked call
of the function =E2=80=9Ckmemdup=E2=80=9D.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/net/wireless/intel/iwlwifi/iwl-drv.c?id=3D1c0cc5f1ae5ee5a6913704c0d7=
5a6e99604ee30a#n1454
https://elixir.bootlin.com/linux/v5.4-rc2/source/drivers/net/wireless/inte=
l/iwlwifi/iwl-drv.c#L1454

Can it be that just an other data structure member should be used
for the desired null pointer check at this place?

Regards,
Markus
