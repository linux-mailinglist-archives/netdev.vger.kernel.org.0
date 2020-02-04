Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC41519D5
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 12:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgBDL2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 06:28:15 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34965 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbgBDL2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 06:28:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tp7pt7A_1580815687;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0Tp7pt7A_1580815687)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Feb 2020 19:28:08 +0800
Subject: Re: [PATCH] net/bluetooth: remove __get_channel/dir
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1579596583-258090-1-git-send-email-alex.shi@linux.alibaba.com>
 <8CA3EF63-F688-48B2-A21D-16FDBC809EDE@holtmann.org>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <09359312-a1c8-c560-85ba-0f94be521b26@linux.alibaba.com>
Date:   Tue, 4 Feb 2020 19:28:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8CA3EF63-F688-48B2-A21D-16FDBC809EDE@holtmann.org>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2020/1/22 ÉÏÎç12:19, Marcel Holtmann Ð´µÀ:
> Hi Alex,
> 
>> These 2 macros are never used from first git commit Linux-2.6.12-rc2. So
>> better to remove them.
>>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Cc: Marcel Holtmann <marcel@holtmann.org> 
>> Cc: Johan Hedberg <johan.hedberg@gmail.com> 
>> Cc: "David S. Miller" <davem@davemloft.net> 
>> Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com> 
>> Cc: linux-bluetooth@vger.kernel.org 
>> Cc: netdev@vger.kernel.org 
>> Cc: linux-kernel@vger.kernel.org 
>> ---
>> net/bluetooth/rfcomm/core.c | 2 --
>> 1 file changed, 2 deletions(-)
>>
>> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
>> index 3a9e9d9670be..825adff79f13 100644
>> --- a/net/bluetooth/rfcomm/core.c
>> +++ b/net/bluetooth/rfcomm/core.c
>> @@ -73,8 +73,6 @@ static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src,
>>
>> /* ---- RFCOMM frame parsing macros ---- */
>> #define __get_dlci(b)     ((b & 0xfc) >> 2)
>> -#define __get_channel(b)  ((b & 0xf8) >> 3)
>> -#define __get_dir(b)      ((b & 0x04) >> 2)
>> #define __get_type(b)     ((b & 0xef))
>>
>> #define __test_ea(b)      ((b & 0x01))
> 
> it seems we are also not using __dir macro either.
> 

Hi Marcel,

Thanks a lot for reminder. How about the following patch?

Thanks
Alex

From 41ef02c2f52cee1d69bb0ba0fbd90247d61dc155 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linux.alibaba.com>
Date: Wed, 15 Jan 2020 17:11:01 +0800
Subject: [PATCH v2] net/bluetooth: remove __get_channel/dir and __dir

These 3 macros are never used from first git commit Linux-2.6.12-rc2.
let's remove them.

Suggested-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/bluetooth/rfcomm/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 3a9e9d9670be..dcecce087b24 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -73,8 +73,6 @@ static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src,
 
 /* ---- RFCOMM frame parsing macros ---- */
 #define __get_dlci(b)     ((b & 0xfc) >> 2)
-#define __get_channel(b)  ((b & 0xf8) >> 3)
-#define __get_dir(b)      ((b & 0x04) >> 2)
 #define __get_type(b)     ((b & 0xef))
 
 #define __test_ea(b)      ((b & 0x01))
@@ -87,7 +85,6 @@ static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src,
 #define __ctrl(type, pf)       (((type & 0xef) | (pf << 4)))
 #define __dlci(dir, chn)       (((chn & 0x1f) << 1) | dir)
 #define __srv_channel(dlci)    (dlci >> 1)
-#define __dir(dlci)            (dlci & 0x01)
 
 #define __len8(len)       (((len) << 1) | 1)
 #define __len16(len)      ((len) << 1)
-- 
1.8.3.1

