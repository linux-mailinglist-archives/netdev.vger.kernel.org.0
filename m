Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653FA4AB117
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 18:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345366AbiBFRyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 12:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiBFRyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 12:54:35 -0500
X-Greylist: delayed 315 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 09:54:33 PST
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FECC043184;
        Sun,  6 Feb 2022 09:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644170072;
        bh=yn5JeOkppnD0tGfSCvueihPF+e+1FFRHsDAP44tpu0A=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=DndPjgzVbgVlCdctnu+YOe0OBCZQ5U+9xrRQWL3E7EsIpH+uqMz6vGi15Jt6NVTPs
         SxDoA6HfPxR6bs0fvXg76U2uMVljQGysoMbC+wry0pnJvgjiCPiFoiFJN06yQtQSq0
         mKE/0lPjrqPRFxF77UJbNu/RnvcEILriVe1zGNDI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.86.27] ([95.91.192.147]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MAwXr-1nS4Kj3eEz-00BHk2; Sun, 06
 Feb 2022 18:49:01 +0100
Message-ID: <f676e339-5808-2163-2afd-ea254cfb2684@rempel-privat.de>
Date:   Sun, 6 Feb 2022 18:48:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFT] net: asix: add proper error handling of usb read
 errors
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, oneukum@suse.com,
        robert.foss@collabora.com, freddy@asix.com.tw
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
References: <20220105131952.15693-1-paskripkin@gmail.com>
 <7dbe85db-92b8-68bd-d008-33a4be9a55b9@gmail.com>
From:   Oleksij Rempel <linux@rempel-privat.de>
In-Reply-To: <7dbe85db-92b8-68bd-d008-33a4be9a55b9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ogiNkPRfVD7er2HY8jDw3fJHT8IWv+jZw7C4hxqJgCNurxo4kxX
 7P2drfrdw826WnAmJddx9xLl2//DEGJaqCarPLrbmpJsqFHwrSn8YbT8+54WZnz6gbB4rwp
 +/vG9O7weJJEEkm+Wd9LH0D0o73uAV9jGpPgUQ8LiZJ3bT8wgTV6Nf7qEaldbooz+2btQQe
 VuNfi/PIt4wgAKN9Nyk5A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sDslPLSxVgE=:irwCf0SrJagZK9QOHvtnQL
 LN1VWkoEgE/tYd+SfKWKJIX9WDMKAI/Gy595HT7w953fB8s4/2JGD7TzQSeZBiKpUl1LlYuuM
 Q5RtrI4vZypV9zj/J0fzzLU2cIzumf1NzmKyJQNR4tZzIJHoy6pRdM3JAwu62xvQqJDLYISfE
 ZPRUSE2RwoN2Ripo4lW1ZDJH0zCX4lkqrC7qGfzjHavjDWLDSj8kShaXBWwHPIW+2uVTGdqw3
 vJlrbPeoATjjrXGEtj3n1fLXI/KXcUKu7ELqbIuJp0eMK+6ko0admp7qlXUGUsyASfaOGw8q1
 8PESRaeNFcS2KYiO1Ddv+LQXO2Xni0TX+unlECS6fsJdX3MzbQaZy2lYepdMvBQnchiKytwTP
 MXkzksuGxTsdHL3/IMkNNr5HxmVCSaDCObRQZ8PvNGnrMAPWgnNutizjRjPgtLWY0OatBp8Y3
 Dnx+rYILWDC/N4RUPKztz+7BeVLaqwDS/mUypBfw7y7aVa59vNvpJ8kwbQpywifOCnoStmEzC
 aGDLcjK4MVk0ANs+Kw2nMM7TFxANrWxGuSK2hBK7FBPRNv+si7J6mLHeSVhUrFxf3BaNR+D7D
 E9Gi/rkeFUOayIkaaehhOpiu4b1eM8LFiCX9p42vBrdpy8fJZsrdC+RAkbM2T7/v+EqMOBnuU
 gsDjnATVcS+nojo2dk+KB1zVYUK6NoVSjsUUWfYspTA9+xA3klyPwYc4g8EOnGuXNpbmVTxTm
 d2VrpNCiJjjelhRF3JqJe5DpboQYHtJ/2RaR3vMwamn0Poq31EdRCQgA5py4O493qxneXqy/4
 hu/f0+aEWGXk4IJAgZ4nPq0aQ9kiM/9ec+Z/uL226yz+2g5Dmm/6rBs0ymJcY7YffPRrB1Iji
 tIWC/5hbB7r25UFZZtRIO5eicgjTtkPMEB+9sB631iUJ2OkAF5nQ3QNm9TdIhBJO9IE2iZW6S
 9WERGkpdBU9uLQ+lSoKSIE3mD4Cd07lh8qq70s7xv8d5bkbCPxWPcc3gxD914JRyRib3FFLLy
 O2Ayz5xdlqWFr8M4Vkkuet8SsCuK2KxsDz1qE8rpzprjatM8o/23bo7gaWOi6p+HEe7nE3y3c
 gR56gg4X3AhT2g=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 06.02.22 um 18:23 schrieb Pavel Skripkin:
> On 1/5/22 16:19, Pavel Skripkin wrote:
>> Syzbot once again hit uninit value in asix driver. The problem still th=
e
>> same -- asix_read_cmd() reads less bytes, than was requested by caller.
>>
>> Since all read requests are performed via asix_read_cmd() let's catch
>> usb related error there and add __must_check notation to be sure all
>> callers actually check return value.
>>
>> So, this patch adds sanity check inside asix_read_cmd(), that simply
>> checks if bytes read are not less, than was requested and adds missing
>> error handling of asix_read_cmd() all across the driver code.
>>
>> Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
>> Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotma=
il.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>
> gentle ping :)

Please resend patch against latest net-next with "net-next" tag instead of=
 "RFT".

=2D-
Regards,
Oleksij
