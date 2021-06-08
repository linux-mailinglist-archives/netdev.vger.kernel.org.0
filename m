Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052103A022C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhFHTBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:01:38 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:28032 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbhFHS7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:59:18 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623178624; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=klyteFDZ+WDekeP6QtMLUV+5wOl5ku5ghoMuNNz7VcWVIutWkSmNdNZptVTGWRNx+3
    tXs9nDu5q5acpPP4W7M0FkHaC/zFAJB5zt6OBsIpdjX2/oVtO2uFLaQBUW4LN8Kq6upN
    ClcAhhwAOpiTVjTcgbjckNqpwZHyk0U8FOUeC+vXufSQCF0ESv51D+ZdrqQIhWiiHiYG
    TyXZylWqmOSxOAtozJ95HyQmCfk58ChqGa7cPyC0+rscQJide6uPsEEwb2ecg/8Qpmir
    kVqCT03mJNAvteH557iO9GdLe5x4fMGB67lUwgz++/CzSc8GInNKIOUH8KkkRAUMmGeN
    5OMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623178624;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=K7m0ttXxl3h7ZX+LO6SZjTt3dphMnFPY1o2TmpIgYSg=;
    b=BLAo/bTXsnKPzKRQb1W9BKrncoPZXte7581ZtS3tRB8/0lQKY3KA/eppXIEF5URwrH
    lag1S5fbRtPsz4r1SAmi1yA42/nwZJPAfy4KiXx2+LEDYGRijcTSmL90VLNred1SfwuV
    8GJ0doK/Yr4WfmoM8caL9IyOuPT3fcBnWM3uJR02aUo22FKKNSlyiIznTdrZYrXiQGDx
    kaFbYqC0tB4tPXLOVJ/c+vk3yfT9UPAST0Z1wYA6GNrzKiFWS0LWgbAGwtlGnWcUcc7L
    7hJQsB148pRFAsx/z7Pxx3nl8wNqq3KKmeCHZAe/sDfgKp33IYXic/rv8/B00jcj5NSS
    cpVw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623178624;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=K7m0ttXxl3h7ZX+LO6SZjTt3dphMnFPY1o2TmpIgYSg=;
    b=aW/ej2qcTignCuQy/xs0XaCDfjpIkseld878Gxt1uaQVIboqk2Hfhn/ePF5CWN+p78
    6kcji3uLkkfR5DMSWlF6cFTa+ryKEJgLdF4pM5O33lLnQP+32zKvoc3RQgWp9uPo49jp
    hA6VWYSEzxFxY5p8WK5SjSTaN7bWQ/YTXJICfb332pfe4ExGw+P8mgSthc4B6CoojIHR
    xkkAYyNRFZ0rFM3fBTmOtvrdaDz+FTLjGdTObREZ2sfm9R4iUs+DUtw3nR2gEDrSD0Bq
    /FxRKt1jEmLLaxiGUHuoBkn+3wDIQJygX4FJeuY1QWYwzPuTw368bfYq3uH7p7fC9ZBF
    Jyyw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR9J8xozF0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id d075c5x58Iv3HZJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 8 Jun 2021 20:57:03 +0200 (CEST)
Subject: Re: [PATCH v2] can: bcm/raw/isotp: use per module netdevice notifier
To:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
References: <20210602151733.3630-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <265c1129-96f1-7bb1-1d01-b2b8cc5b1a42@hartkopp.net>
 <51ed3352-b5b0-03a1-ec25-faa368adcc46@i-love.sakura.ne.jp>
 <5e4693cf-4691-e7da-9a04-3e70cc449bf5@i-love.sakura.ne.jp>
 <e5a53bed-4333-bd99-ca3d-0e25dfb546e5@virtuozzo.com>
 <54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-love.sakura.ne.jp>
 <5922ca3a-b7ed-ca19-afeb-2f55233434ae@virtuozzo.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <6dc06795-9bfd-9bde-cab7-66dae0920b14@hartkopp.net>
Date:   Tue, 8 Jun 2021 20:56:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <5922ca3a-b7ed-ca19-afeb-2f55233434ae@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.06.21 18:15, Kirill Tkhai wrote:
> On 05.06.2021 13:26, Tetsuo Handa wrote:

>>
>> Updated patch is shown below.
>>
>>
>>  From 12c61ae3d06889c9bbc414f0230c05dc630f6409 Mon Sep 17 00:00:00 2001
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Date: Sat, 5 Jun 2021 19:18:21 +0900
>> Subject: [PATCH v2] can: bcm/raw/isotp: use per module netdevice notifier
>>
>> syzbot is reporting hung task at register_netdevice_notifier() [1] and
>> unregister_netdevice_notifier() [2], for cleanup_net() might perform
>> time consuming operations while CAN driver's raw/bcm/isotp modules are
>> calling {register,unregister}_netdevice_notifier() on each socket.
>>
>> Change raw/bcm/isotp modules to call register_netdevice_notifier() from
>> module's __init function and call unregister_netdevice_notifier() from
>> module's __exit function, as with gw/j1939 modules are doing.
>>
>> Link: https://syzkaller.appspot.com/bug?id=391b9498827788b3cc6830226d4ff5be87107c30 [1]
>> Link: https://syzkaller.appspot.com/bug?id=1724d278c83ca6e6df100a2e320c10d991cf2bce [2]
>> Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
>> Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>
>> Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>

Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

Hello Tetsuo and Kirill,

thanks for your effort and the review!

Indeed I really had problems to get behind the locking but now I got it 
(hopefully) :-)

At least I can confirm that the original functionality still works for 
all three affected CAN protocols (bcm/isotp/raw).

Many thanks and best regards,
Oliver

> 
>> ---
>>   net/can/bcm.c   | 59 +++++++++++++++++++++++++++++++++++-----------
>>   net/can/isotp.c | 61 +++++++++++++++++++++++++++++++++++++-----------
>>   net/can/raw.c   | 62 ++++++++++++++++++++++++++++++++++++++-----------
>>   3 files changed, 142 insertions(+), 40 deletions(-)
>>
