Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B342E087B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 11:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLVKD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 05:03:56 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:51412 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgLVKD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 05:03:56 -0500
Received: from mac-pro.holtmann.net (p4ff9fbc9.dip0.t-ipconnect.de [79.249.251.201])
        by mail.holtmann.org (Postfix) with ESMTPSA id E165FCED1D;
        Tue, 22 Dec 2020 11:10:31 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v3 4/5] Bluetooth: advmon offload MSFT handle controller
 reset
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAJQfnxHrvnsLRDHNFWAN9uPJmWiTpE6x4YAmgs77KO6QQBFW7w@mail.gmail.com>
Date:   Tue, 22 Dec 2020 11:03:13 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <8EB5497C-1D36-42B5-946C-3CC60D6F98CB@holtmann.org>
References: <20201216043335.2185278-1-apusaka@google.com>
 <20201216123317.v3.4.I215b0904cb68d68ac780a0c75c06f7d12e6147b7@changeid>
 <73E2D097-F8D4-4BFA-8EC1-C04B079F1BFC@holtmann.org>
 <CAJQfnxHrvnsLRDHNFWAN9uPJmWiTpE6x4YAmgs77KO6QQBFW7w@mail.gmail.com>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

>>> When the controller is powered off, the registered advertising monitor
>>> is removed from the controller. This patch handles the re-registration
>>> of those monitors when the power is on.
>>> 
>>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
>>> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
>>> Reviewed-by: Yun-Hao Chung <howardchung@google.com>
>>> 
>>> ---
>>> 
>>> (no changes since v1)
>>> 
>>> net/bluetooth/msft.c | 79 +++++++++++++++++++++++++++++++++++++++++---
>>> 1 file changed, 74 insertions(+), 5 deletions(-)
>>> 
>>> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
>>> index f5aa0e3b1b9b..7e33a85c3f1c 100644
>>> --- a/net/bluetooth/msft.c
>>> +++ b/net/bluetooth/msft.c
>>> @@ -82,8 +82,15 @@ struct msft_data {
>>>      struct list_head handle_map;
>>>      __u16 pending_add_handle;
>>>      __u16 pending_remove_handle;
>>> +
>>> +     struct {
>>> +             u8 reregistering:1;
>>> +     } flags;
>>> };
>> 
>> hmmm. Do you have bigger plans with this struct? I would just skip it.
>> 
> This struct is also used in patch 5/5 to store the "enabled" status of
> the filter.
> Suspend/resume would need to enable/disable the filter, but it is not
> yet implemented in this patch series.

just do it without the nested structs. I think you are overdoing it here.

Regards

Marcel

