Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF65E5E87
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfJZSOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:14:08 -0400
Received: from mout.web.de ([212.227.17.11]:48801 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfJZSOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 14:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572113645;
        bh=P0QRPzu97eM85ioKCQUZzgOlFJMIqiLQjrqtNN63F80=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=OQlBZwsIID7KQdCcLI1l9vZ04GOFE1uyl8VPSfNaRh/0sSujN/OWUsDH2FkZxeHFB
         y9ODdvKoOAQvdJ2VqbWkuCDWZiZaGgKf+M/CMgSXP4Z1txlWbUoz5eX48/u70JTiOh
         xKm6Run+sC8zXKkRUTIJp5q+vqJmsIcGpDflQ5fc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.128.16]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LdmyV-1hh9Ax02yJ-00j5vR; Sat, 26
 Oct 2019 20:08:32 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
References: <20191026045331.1097-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] wimax: i2400: Fix memory leak in
 i2400m_op_rfkill_sw_toggle
To:     Navid Emamdoost <navid.emamdoost@gmail.com>, linux-wimax@intel.com,
        netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <fa90b9ac-9ff9-7b08-f31f-f349a9fb0a58@web.de>
Date:   Sat, 26 Oct 2019 20:08:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191026045331.1097-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:zMvTWzLbYsGH07KMKCzlzbEGjwD31ZAnXOGzsYIM9cYHIhd4rTj
 7aVubAlivkO4vId9as8vxOzJLFgbhiYyVg2YEtsthARo1b0OyLjOpEZvU5qAJoeq/O/ndKL
 QO/x5yPWwPkmondTkdOwJ6W/+ZIANVrN/S7tUFjMl1wQqnSdVxjcI6+Y04R+/M5SJMAHARq
 rJD8jEAQaMgZMwyyjB3ZA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yEof+5jIHUg=:YFr3NbUYp9xuaicQFYiNYY
 g/DOMr53uAhAgrYdBHeNfqm9u7WIJXrRzxotKW/VJJ4GnQ4rlHHGx20urmD22UPvWBhSW+3cQ
 xHkIIH/Kaclln9tGrfaBkz58nV4n5vizMl9MhGj7Z5SDf8swI00IwhVyah5Iu3kE0S2KAef+3
 AveqjxZhnii4JQF3wwKBJmnr1MGbBLP2YgPhgM9f4G4cu2uSzZwaTTuYDUchBwGl2k4Qjqg1a
 YE20Ryv6yAMZV757Rer/000dahNj6Ncd8M7uvCh5QfFj8eBbE2bLBKHXFGsKRh+gIZCqJqWlj
 Ue96MEb2Urx9XQbZnSJmwuaWXOiCIv/nSRtVHojJsjuicctfQW+w59QOYbbX0qJTLWvPMlwVo
 nx2CXkKW29MPFpFRkFR3oGJJoXfLHnmwO+L0sClIi+bZO6sDjijQl3iKzeVWTCsy0kAC1/zmK
 Gi1ijawdnzkIiQMIYNDJ3Bl2g8DF7B6NWssBErkhJ0vSCHZEJyjQ3JpiOropnJAABvIEzIb8+
 +yZzBY8xfoRysGsHrlM6x+rxk3i5s+lPRreZkXhGrnTJmzAHVKYV8KEHWxRfaQ9UOClNNxyNt
 aXkABqUkNvw8TKf1h4nWYKbpKt3EmtP5m5UNB5ZMXLzbYcSmfkgetM6OD+Zh0g8WjOj8MwANn
 YZl+RTQikfYg9otWy3fZIXzHosDG38INkrLA8LeMbdqeSU4L8IPk1LA57b9IJeuwmcwi0zgTF
 FTorU/sveIxHCYvT5Up6xygpFfyuZEZxfgppvl2xoq+1c8UrQ+xysr1169/4uTBVA5kjgergA
 0EQ46o/z49AHJpzWMv/YmWDhch8t3t89LnQ8bnpxHzd/TWyDR6UL7C5ClTWHU2HjcpZ37UQC8
 pWPA9V+09cYCrNtKQgQyshmQ4fuB1ToedQwX88508N0MboIyrweI+WieQHS3CDQzgzvISKLL7
 Zd73RIos7FwDfgk8gqhXHGfmTD8m7Cqg/YX1lVtYxZ3U4KYhgFzQi/OBQXwcI+6YPSe7YlGe6
 x7eL5DDFOHorYAFokpKjF+3h+CM/hhBD3X9cHYIHZdhXgfb9km7ei2Fbcsd18coN5VEF+ZRU/
 lXjgi6pn0nG7V+U4gvsGJRGnK2rf2DGCNNgksQCikLQZsT5lfysQB8oeonpXhDWZtE2dxPfz8
 xJWvFKxFghfhnCtNX4wTHYj3ZBOnO3bAd2L4K3z76lMmxF0zPpMvb2Lt4OnPQFcAfHRQQxiYY
 b0s/k0mT3tvfQj/iZPmyOehkArAjjcc0Cal/kfkB0GHEi4xUOneMqrL55oHE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Move kfree(cmd) before return to be reached by all execution paths.

I suggest to reconsider this change suggestion once more.


> Fixes: 2507e6ab7a9a ("wimax: i2400: fix memory leak")

I find it interesting that you would like to fix your commit from 2019-09-10.
https://lore.kernel.org/patchwork/patch/1126399/

Will it be helpful to refer also to the commit 024f7f31ed15c471f80408d8b5045497e27e1135
("i2400m: Generic probe/disconnect, reset and message passing" from 2009-01-07)?


> +++ b/drivers/net/wimax/i2400m/op-rfkill.c
> @@ -127,12 +127,12 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
>  			"%d\n", result);
>  	result = 0;
>  error_cmd:
> -	kfree(cmd);
>  	kfree_skb(ack_skb);
>  error_msg_to_dev:
>  error_alloc:
>  	d_fnend(4, dev, "(wimax_dev %p state %d) = %d\n",
>  		wimax_dev, state, result);
> +	kfree(cmd);
>  	return result;
>  }


I would prefer to improve the exception handling like the following.
(Would you like to avoid passing a null pointer at the end?)

-error_cmd:
+free_skb:
-	kfree(cmd);
 	kfree_skb(ack_skb);
-error_msg_to_dev:
+free_cmd:
+	kfree(cmd);
-error_alloc:
+exit:


How do you think about this update variant?

Regards,
Markus
