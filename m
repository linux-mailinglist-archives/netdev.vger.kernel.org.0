Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCFC5E4B0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfGCM7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:59:24 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44860 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCM7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:59:23 -0400
Received: by mail-qk1-f196.google.com with SMTP id p144so2461838qke.11;
        Wed, 03 Jul 2019 05:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B3EbCvz8X6j0zzkGiu03xLcJoPBmlD1JcdVbnYZ1AM0=;
        b=kPKV/kPrPzogkaCvQyzRg/c8dr8quQTQpvi+Cap2nAr5jbHSvqbvTJzTp6BvkbDvVu
         jIFT07EYyUtwZao9gaKVX9kqdsaIljf84DqpAZ+ZxTQw497ttJZLhIUjKc+JZHhn2jEY
         52c+Bfk5XVL0yDuKnzqd8Jp/z4wvp8o53KdqJq2aimGRXc93zhApMAYbKK4sr4YXbT6T
         rYO+9zllfrWUo6Sxp/4ZCpALQH3cD0h7jatKOA8SM73Ivv7suTDw9CEvEmthD2OrmgTH
         j4E2dPT6Bv2Ppa1d4dytTNOYhvFi/0ffn9x5SDpzp26AEiSYGoJULeHngSLuouSAJ5Ux
         JW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B3EbCvz8X6j0zzkGiu03xLcJoPBmlD1JcdVbnYZ1AM0=;
        b=FOPI1BRaNljBNuFyrdLx20egWULXduS7YRmfzJOLHzW/FAsmbFr5CfhdVomC/Quqya
         LzuAoVfgyYN4C4n6Uk4G+pFrZIcJ1GzFCeznIdv2P+hD9Hd3BEQVHujmPLn0V+r7nfQC
         FaKi3nsSOiBGEHsSBwLXD2spMUHjDf0IcqvcD/HTmKvGJsp05hlBneVNDRCDrx1qcjUR
         QIVHiTm8YH6QAnzuitH9ZxhfljBG4vjCDVirwQmhryuEsUnAWtBTlxxCRZCMHhaAAvKm
         nui6hay+jP5i9LbTLesLdBpezYA5qvlCHFj7zbtDGBrETxRAUAf0JAmNLU1CwcjBwp08
         I/ZA==
X-Gm-Message-State: APjAAAUbkAJBV+ZAKrjd79oLzlKg5aYvJnD38GXUU/ez9If+wdG9WFrH
        xsRwE7JaSOx4Z9w+j6EWy1icXOF6fPE=
X-Google-Smtp-Source: APXvYqwiMScv8YFY/uIqT4gRFTXx7BmI72I2/asiZLeQvcpTyote35EuKr+TQcP3CYjZ2zLQyL6/uw==
X-Received: by 2002:a05:620a:1285:: with SMTP id w5mr28646990qki.302.1562158762393;
        Wed, 03 Jul 2019 05:59:22 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::105b? ([2620:10d:c091:480::2a6d])
        by smtp.gmail.com with ESMTPSA id u7sm891625qkm.62.2019.07.03.05.59.19
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 05:59:21 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Daniel Drake <drake@endlessm.com>
Cc:     Chris Chiu <chiu@endlessm.com>, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20190627095247.8792-1-chiu@endlessm.com>
 <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
 <4c99866e-55b7-8852-c078-6b31dce21ee4@gmail.com>
 <CAD8Lp47mWH1-VsZaHr6_qmSU2EEOr9tQJ3CUhfi_JkQGgKpegA@mail.gmail.com>
Message-ID: <89dbfb9d-a31a-9ecb-66bd-42ac0fc49e70@gmail.com>
Date:   Wed, 3 Jul 2019 08:59:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAD8Lp47mWH1-VsZaHr6_qmSU2EEOr9tQJ3CUhfi_JkQGgKpegA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/19 3:42 AM, Daniel Drake wrote:
> On Tue, Jul 2, 2019 at 8:42 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>> We definitely don't want to bring over the vendor code, since it's a
>> pile of spaghetti, but we probably need to get something sorted. This
>> went down the drain when the bluetooth driver was added without taking
>> it into account - long after this driver was merged.
> 
> Yeah, I didn't mean bring over quite so literally.. Chris is studying
> it and figuring out the neatest way to reimplement the required bits.
> 
> As for the relationship with bluetooth.. actually the bug that Chris
> is working on here is that the rtl8xxxu wifi signal is totally
> unusable *until* the bluetooth driver is loaded.

So this is not my experience at all from when I wrote the code. The
8723bu dongle I used for it came up just fine.

> Once the bluetooth driver is loaded, at the point of bluetooth
> firmware upload, the rtl8xxxu signal magiaclly strength becomes good.
> I think this is consistent with other rtl8xxxu problem reports that we
> saw lying around, although they had not been diagnosed in so much
> detail.

See this is the very opposite of what I have experienced. The bluetooth
driver ruins the signal when it's loaded with my dongle.

> The rtl8723bu vendor driver does not suffer this problem, it works
> fine with or without the bluetooth driver in place.

My point is this seems to be very dongle dependent :( We have to be
careful not breaking it for some users while fixing it for others.

Cheers,
Jes
