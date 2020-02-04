Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A430151CB2
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 15:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBDO6I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Feb 2020 09:58:08 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:54569 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgBDO6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 09:58:07 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9E5A5CED29;
        Tue,  4 Feb 2020 16:07:27 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] net/bluetooth: remove __get_channel/dir
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <09359312-a1c8-c560-85ba-0f94be521b26@linux.alibaba.com>
Date:   Tue, 4 Feb 2020 15:58:05 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2287CD53-58F4-40FD-B2F3-81A9F22F4731@holtmann.org>
References: <1579596583-258090-1-git-send-email-alex.shi@linux.alibaba.com>
 <8CA3EF63-F688-48B2-A21D-16FDBC809EDE@holtmann.org>
 <09359312-a1c8-c560-85ba-0f94be521b26@linux.alibaba.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

>>> These 2 macros are never used from first git commit Linux-2.6.12-rc2. So
>>> better to remove them.
>>> 
>>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>>> Cc: Marcel Holtmann <marcel@holtmann.org> 
>>> Cc: Johan Hedberg <johan.hedberg@gmail.com> 
>>> Cc: "David S. Miller" <davem@davemloft.net> 
>>> Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com> 
>>> Cc: linux-bluetooth@vger.kernel.org 
>>> Cc: netdev@vger.kernel.org 
>>> Cc: linux-kernel@vger.kernel.org 
>>> ---
>>> net/bluetooth/rfcomm/core.c | 2 --
>>> 1 file changed, 2 deletions(-)
>>> 
>>> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
>>> index 3a9e9d9670be..825adff79f13 100644
>>> --- a/net/bluetooth/rfcomm/core.c
>>> +++ b/net/bluetooth/rfcomm/core.c
>>> @@ -73,8 +73,6 @@ static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src,
>>> 
>>> /* ---- RFCOMM frame parsing macros ---- */
>>> #define __get_dlci(b)     ((b & 0xfc) >> 2)
>>> -#define __get_channel(b)  ((b & 0xf8) >> 3)
>>> -#define __get_dir(b)      ((b & 0x04) >> 2)
>>> #define __get_type(b)     ((b & 0xef))
>>> 
>>> #define __test_ea(b)      ((b & 0x01))
>> 
>> it seems we are also not using __dir macro either.
>> 
> 
> Hi Marcel,
> 
> Thanks a lot for reminder. How about the following patch?
> 
> Thanks
> Alex
> 
> From 41ef02c2f52cee1d69bb0ba0fbd90247d61dc155 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@linux.alibaba.com>
> Date: Wed, 15 Jan 2020 17:11:01 +0800
> Subject: [PATCH v2] net/bluetooth: remove __get_channel/dir and __dir
> 
> These 3 macros are never used from first git commit Linux-2.6.12-rc2.
> let's remove them.
> 
> Suggested-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> net/bluetooth/rfcomm/core.c | 3 ---
> 1 file changed, 3 deletions(-)
> 
> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> index 3a9e9d9670be..dcecce087b24 100644
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -73,8 +73,6 @@ static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src,
> 
> /* ---- RFCOMM frame parsing macros ---- */
> #define __get_dlci(b)     ((b & 0xfc) >> 2)
> -#define __get_channel(b)  ((b & 0xf8) >> 3)
> -#define __get_dir(b)      ((b & 0x04) >> 2)
> #define __get_type(b)     ((b & 0xef))
> 
> #define __test_ea(b)      ((b & 0x01))
> @@ -87,7 +85,6 @@ static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src,
> #define __ctrl(type, pf)       (((type & 0xef) | (pf << 4)))
> #define __dlci(dir, chn)       (((chn & 0x1f) << 1) | dir)
> #define __srv_channel(dlci)    (dlci >> 1)
> -#define __dir(dlci)            (dlci & 0x01)
> 
> #define __len8(len)       (((len) << 1) | 1)
> #define __len16(len)      ((len) << 1)

just send a proper patch to the mailing list so that I can apply it.

Regards

Marcel

