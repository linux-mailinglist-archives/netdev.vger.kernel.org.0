Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C7EC15C0
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 16:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfI2OU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 10:20:27 -0400
Received: from mout.gmx.net ([212.227.17.20]:44323 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfI2OU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 10:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1569766813;
        bh=QjI2UKdBTdDpx4cfmKvkvgj/Fe/s7UCv8NhDMhZZ83Q=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=i7wnqtKFdzLyx0BtJPPZGiShPm6JBNEb+2pEsyxqR1VI1xyJhmekU8vtNBhB9fmFZ
         oGvygj/tA4L2dTrO5cOXo1M3Oh5dj+Ui5ts03i9/vVA/9w1PuS7S545qrnBBfNI608
         a2BtGUmw0qSu7yuWw+i3qT7cjxVH03nXj7G/UUMU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.130]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MJmGP-1iYiIv43p3-00KAVg; Sun, 29
 Sep 2019 16:20:13 +0200
Subject: Re: [PATCH RFC V2] nl80211: Fix init of cfg80211 channel definition
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Osipenko <digetx@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1569766379-9516-1-git-send-email-wahrenst@gmx.net>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <560d7cb0-b509-6f2a-f31a-1743131e14df@gmx.net>
Date:   Sun, 29 Sep 2019 16:20:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569766379-9516-1-git-send-email-wahrenst@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:E+Gc2cS4gkyzLOB29obc3xQlu0XoQVRGJvunw+VypChp4pm/K3D
 YuUgzyjCQBqfS4HIj8paluhlTzX8hfH82fg0Ilr7GtiVI2jv5L94rfcoHdqKn1jfQVdGUTj
 +UKHxGtpo2E4rKOpdS0rYkVd1FMof12yha5IQo4664pXa+5fXKb8upinEhrqE8qYW8OKIog
 i2gOv91jqlcso6iZE+0/w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:f7pxAe5sqkQ=:4tM3hg7I9Yh/lnxS3cDqJQ
 bEE/lgFkxFw1EB8Ll8n5xXU4uGZ80aTUzQovNIR6JG96w6Or3ak4NoMjDie9BjjzyTxV4/CyY
 CtLYqRCfDANTiNeDfge1QXlFCW3DPOj1HfhtmnXPHJ5HktKzRyNhscRhiUJPbyftR6NH+G8pJ
 5SnVj0tbMzcLTxP2xSJ1RBYaW/U0ekB9CJ/jmMpJH3on/4TNSQ3arQUZSYKzfQnZQLxpxY7fv
 hDx7+o9COROUgGeCuZSRsg7sW4qdFxpzugQzc+qtay8/BhXSq4wNwUx3p07wiowOjqGTnMpyo
 Tm/jyWnKNYEWv7eicByuV/yPNihn2hfN8FZ7tBlgb7k1xnu2vBPP+EBUoVwNZkTPScJZz3MhX
 Oep3CVwXhy1f79tWaOoFLV3qjbgHhDhSk6bUVIjJf7aOSgYRGUwMZCwwMeapRU6qrbVcCPmUW
 KCzP33JjV8VIXBfI9ytCchHpdOZTuU53Wxsv5uGCoK0SS0zM7OUDW9STjKSbpL6o4fkRnIrV5
 ouGXEDheF1cz+SkQxIHGVXs4tJKyxixglsYd03Hj1WPn3F52v/BJRYTz1hx5bOc13IyP9ikAx
 X9/TdxPky1NTLgGu+pAaTqnV5PllAZHKTCYKfM0tUa9GOZiMN0/FuBv2eCMdP1q3uM0UGQQ91
 4e20VaAcSF9TOPIaOozYE03baZllf4HwWBWQiyww0Xf08sieOWXpd16PnL8AIvn0aTzte0Kpv
 PdtIqA8cebx9PjZRJfI5sUBgfIXpKXyyO9+kEOjFBherLZBmMY81ZbTFV9Is6gkqiUJO7U1Un
 V0dQON21G6lAtaTBcl9GQaMmqVDBEZl+oUNHlcVJQ7+BKViRmDslnMm+B4OejKM+CkxjYn1yC
 C2E+G30wJWmwufzugkIDWnTt0y67CDTzdytpBio21IsbYwpAFWqt3lDMhRnphsYQ+3RvTjpoX
 M6e3pW1+nJCeYqkxl3ftdtXAT9AOG7Ao/TAjh4rQLnmsB6CEtLrRXXz4rqhTqT6L8Gc7lYCGb
 RKOrNwA5kVaa7wsx1yI2jDpoXxwSawRUA/ktUE7WKkq7z9NrrRF+jjqlN11BEzIxHfvg/HRvC
 KmnHTn7V2TEclEH/COIcPt6d/BBr7l+I2iMCS0T3ueoUKC3HxmsWQ3SbyqbVccu510GgHnAD/
 EITgfvHJiMdOU00LPazxwQUQ/beKZ1OqDIiID19arvWFcnji81fBsZTKIhK8ZMltfMwwNBahe
 YxB0nXZ5ytjlUzFMRvltsqZ9KiPqDjjudFHqlZCcdkBIM4XMOkhv3hs6ikLQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

Am 29.09.19 um 16:12 schrieb Stefan Wahren:
> The commit 2a38075cd0be ("nl80211: Add support for EDMG channels")
> introduced a member to the cfg80211 channel definition. Unfortunately
> the channel definitions are allocated on the stack and are not always
> initialized via memset. Now this results in a broken probe of brcmfmac
> driver, because cfg80211_chandef_valid() accesses uninitialized memory
> and fail. Fix this by init the remaining occurences with memset.
>
> Reported-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Fixes: 2a38075cd0be ("nl80211: Add support for EDMG channels")
i oversight your patch. Sorry for the noise.
