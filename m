Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E551E752C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgE2FFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:05:19 -0400
Received: from mout.web.de ([212.227.15.14]:41885 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2FFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 01:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590728699;
        bh=qjkBf7e4kOBG+z9NA90bU3EsZ90lI2BzVz+xxlY6fps=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=WaBbpgBuC/PV8+ODGZeph/lVleM5Yb2NvSoLOXsjcrnd+R+6MR4h2khwilghsSfQk
         Vh+W+f6vdl0TBNASzUT1Ue7ZUPBK4nJ4EqAp2bS9UnSTxVXbScZUXWQS9/EXKgwmlZ
         CxdTxTdDrYXGxwfHABnTHmvN/fOuYsxMiLs34Yhg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.131.188.184]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MoNVE-1jBp8l0pKK-00orGX; Fri, 29
 May 2020 07:04:59 +0200
Subject: Re: [02/12] net: hns3: Destroy a mutex after initialisation failure
 in hclge_init_ae_dev()
To:     Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
References: <913bb77c-6190-9ce7-a46d-906998866073@web.de>
 <9c50ab14-c5c7-129f-0e51-d40a4c552fd8@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <66335438-3c86-464d-bf6b-006521cd57bc@web.de>
Date:   Fri, 29 May 2020 07:04:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9c50ab14-c5c7-129f-0e51-d40a4c552fd8@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vPVUb+k+kQ624SyDpdbw6FxtFt/trTTOutjGtA41LGqCmsvcB0l
 yvULu2aBdhQybcUkDP9FAnwpulR1ctoN0FP+LUkdUyfa9I5mH1Z9YqhxVxlwf1c6MlSNir4
 3ozm47upnyheA7a8QxadM5FrXSFx2poPR2FhaARnijWOwvwUyeJZC8FcWEE24e6Hr2AfQ1w
 JJW0PE13nUtkpk7supWDw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ygcF331jF8g=:/vNq741sd/tGWSu03h5M3u
 suq7b2gM+hAmnyF9DHcuALtVirykwo7sYgh5iooA1WU2dAQlZZCu3+tXCEGZoQ+7+1GCoxtUr
 bj0hJGEjuWe3lQeCAaCi86SXnbEhVtQS5pU/wrTIyyYSMLZYmM7mozofev6IOPO3+EhD3+JT9
 YrCP7QWfRCVOBwIyJ3TCJ4jEsDPJuwiiniTKtn4Bc66rALyr/RK3fs8E9e9clS+EQ9qCVXXpF
 vo74ibNjkhIcgzj+7rKG5NcT+ADXsiT9G1ZMuY0CtWxzKyfDHMP7rCDclctefM0zZRw3mHoun
 AP+jbZsd5BcgoANvBK+fiSYaL8UvWi/jJLUndH1noSlca0UlpmSfBWjn93+P01N7Xyu7ASf61
 zNfmff0FdHD6Hx3HQnkJaIp01Ey+sWjMzBH0LxS/Q771WE+ieXJgba4t4vHRbAPL4RHyaW/v5
 sqavTVa0J3OAXu8esecF2GQv6DQc8DtxBU9VfsC+6XTQMOxsenWdR1N5WZSkF4swEqKzp7quI
 GBEq08UeF2olQ38CuWHqNlrIdF/SH4rjhOv2dM4Gq3MES6aUg960Z0d8xYOhiX3aQO0l50/8d
 d4HNdN6+pVDLY6ZIddFqAutjRFA1YYEMawAWikvp9Qro9L9gzsoP2JOkfGEYeF6WPik5/YN2E
 tmum/9uCHfHBzKf2a7ehjcqEaNHmcalokfqxPKwmO3lw99jdk74GNpfIC0Ix9IxhUcYBe9t9R
 h6sDoyrwp1uujz+RN1f1fKOW/2If3ImE15wJiV8+q3+tVCugAsPFBIAEdlak8x5b/tW1uiybo
 jX5YCwdN20jYR1XeZCu65D/usOCiw+L1P3hj13kEyVYI1CaJ3RbBVMP1WtVbXDCLNls6VPug4
 y7OMThN9p/gKVemlFL2AaGwCgxzmtxiuSIzqjqKjnu8+dt0cyDydfrGJcjD6dmV6BCCHFH2/H
 piHIvMh2xO8+fnjCHm+lkSz09VoZlygWzksuEPH1qsr1umG+IkdbP3j+yrBDqV0WCf7G7Wk3f
 NeaUxO+MRNqTLSe2kQHxWWI/hWD3FhPXNrR7FG11gznpm4LuqbINyTbQBnIe7T/kK9DaiVM6j
 lNHfrbPmgyyC90FOqh5UEjK3Z5d4zrrzxTHoZJZULhOcdU2QRQr9hgPaKnLBLSE6LuJ7gkAa7
 9XoAwzJJoQ5xbWHm8HrKduAR6R0oj3pvLC3UqBmHJC4toKFFE2Oy0WKzH6U92/cYzL4TLtgzh
 nkT3WM6w2o5xdz5FK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> Add a mutex destroy call in hclge_init_ae_dev() when fails.
>>
>> How do you think about a wording variant like the following?
=E2=80=A6
> It looks better. I will try to improve the skill of patch description
> and make as many as people can understand the patch.

Thanks for your positive feedback.

I suggest to avoid also a typo in the function name of the patch subject.

Regards,
Markus
