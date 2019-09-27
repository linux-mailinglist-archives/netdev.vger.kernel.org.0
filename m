Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F257C0847
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfI0PFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 11:05:08 -0400
Received: from mout.web.de ([212.227.15.4]:45979 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbfI0PFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 11:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569596687;
        bh=7OQDDfbSFacyo7PngsnLCG3ZXjNdxSRA7tH3Dzz4XK0=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=UWVArCmDua/OYVrTPe/0/vlE5UXAMn/xDkBDfuL7IUyRg9s8U1XIESr4YC8k3kzlP
         UImA7chO16c1ks/3knpDLl7W1fg/7Qb7Ee8pS6Rkznf2h7K36Kt8K6CubrYHGo9OVb
         ChWrk0AaKp/eeHcpZtdR+WoAUuKehEekq13WcLcA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Ls9F9-1i1fdo2uH1-013uC5; Fri, 27
 Sep 2019 17:04:47 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen A McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190925154831.19044-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] i40e: prevent memory leak in i40e_setup_macvlans
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
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
Message-ID: <8d7d8cf4-c016-d22c-c2cc-dc71ea407cb4@web.de>
Date:   Fri, 27 Sep 2019 17:04:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190925154831.19044-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:kMweqxyk1Sd+3Q3V4q/NBQ39VnZP6siyyu6Jc1f0n+g2dKaq9NZ
 g8oYD/c9IDPiCaxNfQ4LLlyFNdI54HN1qwzplSuMv/B6xacuUijdaSsYg+Xy8YUzndrlT5y
 qEKuXnSGzSeer07BoYybT7Yxhl3BzCmEYkp4xC4elmauHI8NsgtYVJm7ivP9Esz9aIp7NcW
 ljlat6B1TLlZoDH/5kobQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BCQ/OYQARfA=:9UOg6doqeiWZVuGRqkohDL
 u1SitWRTl7sRVaAGbce6qAlmugJDq2SwIc/tKYQa6HK/UDHAr5p8K12gJz/4LLxTyBZ68IkmP
 IyUyDBZaBhCBKMVW/4mL1A0CWqRMGThwpaFK5NQh+C8oU+c1brlbzRwOMjEEUQXW+MRbNNB5t
 gCej+eetnA/zxnxc/3sKev2o9h0cs3xfeHFd0dgN8heh2TT1ai8zWOhGt5nSEY9qIBY6l4tl0
 pvplNhfTbo2n8ohxrgYGW8mkeMzoGMBtrzkTAom9MEo9Wqt/CgLA1YUgcXX5k2TSyxnTym8px
 KyiaTsD7Hzta7rUAc7MIsYOqtLm3dQfP+qHqO2Jrj9QqdImkMBzf945wXfYqtk2ZfWH99vj9p
 g1i+jO2SDXPTleWJx4owQUnaSp3xrDdN+z3AxkfOaUH+2twxqLiowxzNcfIuJiYkovgSA1pon
 +dpHng2pdBKwQt3UhqV+TzctKh+6kuernVO+mdwGh2bb9gjPJKLjKA4RKDidEgtLe6kyo5i9e
 5gJ199NFPBqapS8xZX03SK+npP5QOTMymCuJcNkmLRDm2FXrGAaXmZduDQqVyXQ0ER62qlshu
 ANN2wzSGezblcyToAv/Ut+oIL4w998RvPiwZp/20W06WHiPJpI6uXQzPc87qzhjwTCBKkfJ/U
 UbJQcWxQpErDNJwMKoDN82jdJG2qEGN5c8eNl7exxNHVaPDA+wtUefAMbIdtIQ4CV4ZdJ4e9E
 1vf1/sbpFJXDjP7pymzAT/5NEpMJbhevnsOex4FX+6ul/aZVmGrNm2ekRcbT/UH/roKNYk3/x
 9cr1Q3LFcx6s226bn6Dhf/OJhEH64oZF/gVZjH90E1ZXrMSZxyeI0gxtoEX/k/zff9GT51+7I
 7HXKg0HsQ/IZTc3mQ9vXJhd1fJywaoro73NrFK+WLl+m/fWZSd8sm0JDaRAB7KzjBm/HQ2OfV
 YTAGAGSy1k+mw25Gie8yseaUyxRbRAARR9f8S0cf59HP/cCGJI23jEvo6FP7fWs22yVOTtwCt
 2fnNZffh4L3IZ/5GhwW74vYm6fh0+isBjWbFNH17JmOTnteHDXBO/2u1XL6coZKgxRF1lig88
 kd/JBaGVlR5bPHIbl3TpuECEViAFYeErbg4VDXW4+8DM5ywzsW/1YG0bGc8800BjTA4h9BfZo
 782biWfpE3VF85DMDPJHCixYuJaUGvIxI49EMW3tJ57pTYwnZq+eZecahYe8GsEJmxhkvZhIa
 2N27+HgGT8r0gviOY7dgcqvOlH9lit7AQ7YoM7XGCrK4lH7cQk5FoFrr7P00=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In i40e_setup_macvlans if i40e_setup_channel fails the allocated memory
> for ch should be released.

I suggest to improve also this change description.


> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -7168,6 +7168,7 @@ static int i40e_setup_macvlans(struct i40e_vsi *vsi, u16 macvlan_cnt, u16 qcnt,
>  		ch->num_queue_pairs = qcnt;
>  		if (!i40e_setup_channel(pf, vsi, ch)) {
>  			ret = -EINVAL;
> +			kfree(ch);
>  			goto err_free;
>  		}
>  		ch->parent_vsi = vsi;

Can it matter to perform the added function call before the error code assignment?

Regards,
Markus
