Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF57425AB2A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgIBMbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 08:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgIBMbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 08:31:32 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED746C061244;
        Wed,  2 Sep 2020 05:31:31 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t11so2227056plr.5;
        Wed, 02 Sep 2020 05:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nWY+6erNVM6Xl8glEmPwXLUrDWTRISXUW1W403933l8=;
        b=VD0OSq39q348n1v0uQAp3k88+WIjjZosqgA9X8iTDSWTjcUIiBYN3MZ9VOTTkyBU/Q
         Q8A5ixCGv3EdEq1ELmY51HVWXGc6dVFfTsdeZMCnFDhjOZa2FlBInUpVq5Vrea0B3Ij5
         8KFVifnTJ3frLnDMCOfvogXrKpMfrvqfZLCnChDBdXM6iRJ7ccpTaCPtYApB6msTmr5a
         TnM7Y9wvDxm0xsxg79JeuF/yIcTYKrAts5AAKNZD1I2OSDSdVrPUR2F+rRVe/9YNR+5R
         Faa2IUmCjlH7Il+4Irn4qnbm9MEs4rRa8geygx0mGNnyegeHbk7GuA/2LUGvi/S/7vF1
         aabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nWY+6erNVM6Xl8glEmPwXLUrDWTRISXUW1W403933l8=;
        b=T8R/J9o7Rx1Lb2PMpTm/M7EP17rwxp8BBwa7K0hkiMvz5s+UVahiGw4BecHsWD7yg8
         IC6TB31kb3A8rRSY4/JxyzqYOxt5BqY6xIU3ZWLjbwoKdyVo4Fxoye+QLICcn3BrJNTU
         4Vt7PBXsi5GGw8hdKM3WXzIuYq8l87JnHhDn7Xt/dAkoM8jVspthotP5tqY390VicVol
         cN5wfWkRgQ/4z9JxDnYy7dPkQ8O4H19ZFJKZVj3PsxoOAYJ6ONrB3zqm6p2ycZKrLi5u
         83VaJ7KYCjImfADARpW4OMZd0Cr9xHTjOw3QFBEAaAqbFqB82tV3X/D3A+ztCbD3w822
         qdLw==
X-Gm-Message-State: AOAM533yV5tqpeXSl1HyD2Yrcxsploa1ag5YPaV6M6rJZnxvP89L2EZb
        KdJxu++3agDHkLTPtXyhnlw=
X-Google-Smtp-Source: ABdhPJy5I6Gyc/KFdPbcmJPMUULGfd168li2aLRy3APbEPCpTrTUdoGGSsFGxSMYWgDx+YsfSquKCw==
X-Received: by 2002:a17:90a:bf8d:: with SMTP id d13mr2160253pjs.100.1599049891350;
        Wed, 02 Sep 2020 05:31:31 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id gx5sm1062511pjb.57.2020.09.02.05.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 05:31:30 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Wed, 2 Sep 2020 20:31:25 +0800
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Greg KH <gregkh@linuxfoundation.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot+dd768a260f7358adbaf9@syzkaller.appspotmail.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: fix "list_add double add" in
 hci_conn_complete_evt
Message-ID: <20200902122357.ca2fztgah7gwz7yp@Rk>
References: <000000000000c57f2d05ac4c5b8e@google.com>
 <20200823010022.938532-1-coiby.xu@gmail.com>
 <C0A907BA-9C0D-4124-A2AF-3748055DB062@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yijhrv2ys2svaijk"
Content-Disposition: inline
In-Reply-To: <C0A907BA-9C0D-4124-A2AF-3748055DB062@holtmann.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yijhrv2ys2svaijk
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Mon, Aug 31, 2020 at 06:06:18PM +0200, Marcel Holtmann wrote:
>Hi Coiby,

Hi Marcel,

Thank you for reviewing this patch!

>
>> When two HCI_EV_CONN_COMPLETE event packets with status=0 of the same
>> HCI connection are received, device_add would be called twice which
>> leads to kobject_add being called twice. Thus duplicate
>> (struct hci_conn *conn)->dev.kobj.entry would be inserted into
>> (struct hci_conn *conn)->dev.kobj.kset->list.
>>
>> This issue can be fixed by checking (struct hci_conn *conn)->debugfs.
>> If it's not NULL, it means the HCI connection has been completed and we
>> won't duplicate the work as for processing the first
>> HCI_EV_CONN_COMPLETE event.
>
>do you have a btmon trace for this happening?

Please see the attachment "btmon_output" which is a plain text file.
I couldn't find a way to save traces in btsnoop format (the kernel would
panic immediately after running the re-producer before QEMU has a chance
to write the btsnoop file to the disk image).

I've also also attached a simplified re-producer rep9_min.c if it interests you.
>
>> Reported-and-tested-by: syzbot+dd768a260f7358adbaf9@syzkaller.appspotmail.com
>> Link: https://syzkaller.appspot.com/bug?extid=dd768a260f7358adbaf9
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>> net/bluetooth/hci_event.c | 5 +++++
>> 1 file changed, 5 insertions(+)
>>
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index 4b7fc430793c..1233739ce760 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -2605,6 +2605,11 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
>> 	}
>>
>> 	if (!ev->status) {
>> +		if (conn->debugfs) {
>> +			bt_dev_err(hdev, "The connection has been completed");
>> +			goto unlock;
>> +		}
>> +
>
>And instead of doing papering over a hole, I would rather detect that the HCI event is not valid since we already received one for this connection.

To check conn->debugfs is what I think could be used to detect this
duplicate HCI event. Or you are suggesting this is not sufficient
and implement something like a state machine instead?

>
>Regards
>
>Marcel
>

--
Best regards,
Coiby

--yijhrv2ys2svaijk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=btmon_output

Bluetooth monitor ver 5.54
= Note: Linux version 5.8.0+ (x86_64)                                  0.447880
= Note: Bluetooth subsystem version 2.22                               0.447950
@ MGMT Open: btmon (privileged) version 1.18                  {0x0001} 0.449370
= New Index: 00:00:00:00:00:00 (Primary,Virtual,hci0)           [hci0] 5.834012
@ RAW Open: rep9_ (privileged) version 2.22                   {0x0002} 5.840840
= Open Index: 00:00:00:00:00:00                                 [hci0] 5.843719
< HCI Command: Reset (0x03|0x0003) plen 0                    #1 [hci0] 5.844689
> HCI Event: Command Complete (0x0e) plen 252                #2 [hci0] 5.844982
      Reset (0x03|0x0003) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
< HCI Command: Read Local Supported... (0x04|0x0003) plen 0  #3 [hci0] 5.845194
> HCI Event: Command Complete (0x0e) plen 252                #4 [hci0] 5.845356
      Read Local Supported Features (0x04|0x0003) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
< HCI Command: Read Local Version In.. (0x04|0x0001) plen 0  #5 [hci0] 5.845522
> HCI Event: Command Complete (0x0e) plen 252                #6 [hci0] 5.845593
      Read Local Version Information (0x04|0x0001) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
< HCI Command: Read BD ADDR (0x04|0x0009) plen 0             #7 [hci0] 5.845849
> HCI Event: Command Complete (0x0e) plen 10                 #8 [hci0] 5.845914
      Read BD ADDR (0x04|0x0009) ncmd 1
        Status: Success (0x00)
[   50.133219][ T8087] kobject_add_internal failed for hci0:200 with -EEXIST, don't try to register things with the same name in the same directory.
[   50.135031][ T8087] Bluetooth: hci0: failed to register connection device
        Address: AA:AA:AA:AA:AA:AA (OUI AA-AA-AA)
< HCI Command: Read Buffer Size (0x04|0x0005) plen 0         #9 [hci0] 5.846623
> HCI Event: Command Complete (0x0e) plen 11                #10 [hci0] 5.846710
      Read Buffer Size (0x04|0x0005) ncmd 1
        Status: Success (0x00)
        ACL MTU: 1021 ACL max packet: 4
        SCO MTU: 96   SCO max packet: 6
< HCI Command: Read Class of Device (0x03|0x0023) plen 0    #11 [hci0] 5.846806
> HCI Event: Command Complete (0x0e) plen 252               #12 [hci0] 5.846862
      Read Class of Device (0x03|0x0023) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
< HCI Command: Read Local Name (0x03|0x0014) plen 0         #13 [hci0] 5.893252
> HCI Event: Command Complete (0x0e) plen 252               #14 [hci0] 5.893318
      Read Local Name (0x03|0x0014) ncmd 1
        Status: Success (0x00)
        Name:
< HCI Command: Read Voice Setting (0x03|0x0025) plen 0      #15 [hci0] 5.893439
> HCI Event: Command Complete (0x0e) plen 252               #16 [hci0] 5.893490
      Read Voice Setting (0x03|0x0025) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
< HCI Command: Read Number of Suppo.. (0x03|0x0038) plen 0  #17 [hci0] 5.893559
> HCI Event: Command Complete (0x0e) plen 252               #18 [hci0] 5.893600
      Read Number of Supported IAC (0x03|0x0038) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
< HCI Command: Read Current IAC LAP (0x03|0x0039) plen 0    #19 [hci0] 5.893666
> HCI Event: Command Complete (0x0e) plen 252               #20 [hci0] 5.893710
      Read Current IAC LAP (0x03|0x0039) ncmd 1
        Status: Success (0x00)
        Number of IAC: 0
< HCI Command: Set Event Filter (0x03|0x0005) plen 1        #21 [hci0] 5.893777
        Type: Clear All Filters (0x00)
> HCI Event: Command Complete (0x0e) plen 252               #22 [hci0] 5.893818
      Set Event Filter (0x03|0x0005) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
< HCI Command: Write Connection Acc.. (0x03|0x0016) plen 2  #23 [hci0] 5.893884
        Timeout: 20000.000 msec (0x7d00)
> HCI Event: Command Complete (0x0e) plen 252               #24 [hci0] 5.893925
      Write Connection Accept Timeout (0x03|0x0016) ncmd 1
        invalid packet size
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00                       .........
= Index Info: AA:AA:AA:AA:AA.. (Ericsson Technology Licensing)  [hci0] 5.894458
@ MGMT Event: Index Added (0x0004) plen 0              {0x0001} [hci0] 5.894531
< HCI Command: Write Scan Enable (0x03|0x001a) plen 1       #25 [hci0] 5.895481
        Scan enable: Page Scan (0x02)
> HCI Event: Command Complete (0x0e) plen 4                 #26 [hci0] 5.895547
      Write Scan Enable (0x03|0x001a) ncmd 1
        Status: Success (0x00)
> HCI Event: Connect Request (0x04) plen 10                 #27 [hci0] 5.895786
        Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Class: 0x000000
          Major class: Miscellaneous
          Minor class: 0x00
        Link type: ACL (0x01)
> HCI Event: Connect Complete (0x03) plen 11                #28 [hci0] 5.895828
        Status: Success (0x00)
        Handle: 200
        Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Link type: ACL (0x01)
        Encryption: Disabled (0x00)
> HCI Event: Connect Complete (0x03) plen 11                #29 [hci0] 5.895842
        Status: Success (0x00)
        Handle: 200
        Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Link type: ACL (0x01)
        Encryption: Disabled (0x00)
@ RAW Close: rep9_                                            {0x0002} 5.951790
< HCI Command: Accept Connection Re.. (0x01|0x0009) plen 7  #30 [hci0] 6.130913
        Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Role: Slave (0x01)

--yijhrv2ys2svaijk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rep9_min.c"

// based on the reproducer
// https://syzkaller.appspot.com/bug?id=f0ec9a394925aafbdf13d0a7e6af4cff860f0ed6
// wich is autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/capability.h>

const int kInitNetNsFd = 239;

#define MAX_FDS 30

static long syz_init_net_socket(volatile long domain, volatile long type,
                                volatile long proto)
{
  int netns = open("/proc/self/ns/net", O_RDONLY);

  if (netns == -1)
    return netns;

  int sock = syscall(__NR_socket, domain, type, proto);
  int err = errno;

  /** if (setns(netns, 0)) */
  /**   exit(1); */

  close(netns);
  errno = err;
  return sock;
}

#define BTPROTO_HCI 1
#define ACL_LINK 1
#define SCAN_PAGE 2

typedef struct {
  uint8_t b[6];
} __attribute__((packed)) bdaddr_t;

#define HCI_COMMAND_PKT 1
#define HCI_EVENT_PKT 4
#define HCI_VENDOR_PKT 0xff

struct hci_command_hdr {
  uint16_t opcode;
  uint8_t plen;
} __attribute__((packed));

struct hci_event_hdr {
  uint8_t evt;
  uint8_t plen;
} __attribute__((packed));

#define HCI_EV_CONN_COMPLETE 0x03
struct hci_ev_conn_complete {
  uint8_t status;
  uint16_t handle;
  bdaddr_t bdaddr;
  uint8_t link_type;
  uint8_t encr_mode;
} __attribute__((packed));

#define HCI_EV_CONN_REQUEST 0x04
struct hci_ev_conn_request {
  bdaddr_t bdaddr;
  uint8_t dev_class[3];
  uint8_t link_type;
} __attribute__((packed));

#define HCI_EV_REMOTE_FEATURES 0x0b
struct hci_ev_remote_features {
  uint8_t status;
  uint16_t handle;
  uint8_t features[8];
} __attribute__((packed));

#define HCI_EV_CMD_COMPLETE 0x0e
struct hci_ev_cmd_complete {
  uint8_t ncmd;
  uint16_t opcode;
} __attribute__((packed));

#define HCI_OP_WRITE_SCAN_ENABLE 0x0c1a

#define HCI_OP_READ_BUFFER_SIZE 0x1005
struct hci_rp_read_buffer_size {
  uint8_t status;
  uint16_t acl_mtu;
  uint8_t sco_mtu;
  uint16_t acl_max_pkt;
  uint16_t sco_max_pkt;
} __attribute__((packed));

#define HCI_OP_READ_BD_ADDR 0x1009
struct hci_rp_read_bd_addr {
  uint8_t status;
  bdaddr_t bdaddr;
} __attribute__((packed));

#define HCI_EV_LE_META 0x3e
struct hci_ev_le_meta {
  uint8_t subevent;
} __attribute__((packed));

#define HCI_EV_LE_CONN_COMPLETE 0x01
struct hci_ev_le_conn_complete {
  uint8_t status;
  uint16_t handle;
  uint8_t role;
  uint8_t bdaddr_type;
  bdaddr_t bdaddr;
  uint16_t interval;
  uint16_t latency;
  uint16_t supervision_timeout;
  uint8_t clk_accurancy;
} __attribute__((packed));

struct hci_dev_req {
  uint16_t dev_id;
  uint32_t dev_opt;
};

struct vhci_vendor_pkt {
  uint8_t type;
  uint8_t opcode;
  uint16_t id;
};

#define HCIDEVUP _IOW('H', 201, int)
#define HCISETSCAN _IOW('H', 221, int)

static int vhci_fd = -1;

static void hci_send_event_packet(int fd, uint8_t evt, void* data,
                                  size_t data_len)
{
  struct iovec iv[3];
  struct hci_event_hdr hdr;
  hdr.evt = evt;
  hdr.plen = data_len;
  uint8_t type = HCI_EVENT_PKT;
  iv[0].iov_base = &type;
  iv[0].iov_len = sizeof(type);
  iv[1].iov_base = &hdr;
  iv[1].iov_len = sizeof(hdr);
  iv[2].iov_base = data;
  iv[2].iov_len = data_len;
  if (writev(fd, iv, sizeof(iv) / sizeof(struct iovec)) < 0)
    exit(1);
}

static void hci_send_event_cmd_complete(int fd, uint16_t opcode, void* data,
                                        size_t data_len)
{
  struct iovec iv[4];
  struct hci_event_hdr hdr;
  hdr.evt = HCI_EV_CMD_COMPLETE;
  hdr.plen = sizeof(struct hci_ev_cmd_complete) + data_len;
  struct hci_ev_cmd_complete evt_hdr;
  evt_hdr.ncmd = 1;
  evt_hdr.opcode = opcode;
  uint8_t type = HCI_EVENT_PKT;
  iv[0].iov_base = &type;
  iv[0].iov_len = sizeof(type);
  iv[1].iov_base = &hdr;
  iv[1].iov_len = sizeof(hdr);
  iv[2].iov_base = &evt_hdr;
  iv[2].iov_len = sizeof(evt_hdr);
  iv[3].iov_base = data;
  iv[3].iov_len = data_len;
  if (writev(fd, iv, sizeof(iv) / sizeof(struct iovec)) < 0)
    exit(1);
}

#define HCI_HANDLE_1 200
#define HCI_HANDLE_2 201

static void send_complte_ev()
{
  struct hci_ev_conn_complete complete;
  memset(&complete, 0, sizeof(complete));
  complete.status = 0;
  complete.handle = HCI_HANDLE_1;
  memset(&complete.bdaddr, 0xaa, 6);
  *(uint8_t*)&complete.bdaddr.b[5] = 0x10;
  complete.link_type = ACL_LINK;
  complete.encr_mode = 0;
  hci_send_event_packet(vhci_fd, HCI_EV_CONN_COMPLETE, &complete,
                        sizeof(complete));
}

static bool process_command_pkt(int fd, char* buf, ssize_t buf_size)
{
  struct hci_command_hdr* hdr = (struct hci_command_hdr*)buf;
  if (buf_size < (ssize_t)sizeof(struct hci_command_hdr) ||
      hdr->plen != buf_size - sizeof(struct hci_command_hdr)) {
    exit(1);
  }
  switch (hdr->opcode) {
  case HCI_OP_WRITE_SCAN_ENABLE: {
    uint8_t status = 0;
    hci_send_event_cmd_complete(fd, hdr->opcode, &status, sizeof(status));
    return true;
  }
  case HCI_OP_READ_BD_ADDR: {
    struct hci_rp_read_bd_addr rp = {0};
    rp.status = 0;
    memset(&rp.bdaddr, 0xaa, 6);
    hci_send_event_cmd_complete(fd, hdr->opcode, &rp, sizeof(rp));
    return false;
  }
  case HCI_OP_READ_BUFFER_SIZE: {
    struct hci_rp_read_buffer_size rp = {0};
    rp.status = 0;
    rp.acl_mtu = 1021;
    rp.sco_mtu = 96;
    rp.acl_max_pkt = 4;
    rp.sco_max_pkt = 6;
    hci_send_event_cmd_complete(fd, hdr->opcode, &rp, sizeof(rp));
    return false;
  }
  }
  char dummy[0xf9] = {0};
  hci_send_event_cmd_complete(fd, hdr->opcode, dummy, sizeof(dummy));
  return false;
}

static void* event_thread(void* arg)
{
  while (1) {
    char buf[1024] = {0};
    ssize_t buf_size = read(vhci_fd, buf, sizeof(buf));
    if (buf_size < 0)
      exit(1);
    if (buf_size > 0 && buf[0] == HCI_COMMAND_PKT) {
      if (process_command_pkt(vhci_fd, buf + 1, buf_size - 1))
        break;
    }
  }
  return NULL;
}
static void initialize_vhci()
{
  int hci_sock = syz_init_net_socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
  if (hci_sock < 0)
    exit(1);

  vhci_fd = open("/dev/vhci", O_RDWR);
  if (vhci_fd == -1)
    exit(1);

  struct vhci_vendor_pkt vendor_pkt;
  if (read(vhci_fd, &vendor_pkt, sizeof(vendor_pkt)) != sizeof(vendor_pkt))
    exit(1);

  if (vendor_pkt.type != HCI_VENDOR_PKT)
    exit(1);

  pthread_t th;
  if (pthread_create(&th, NULL, event_thread, NULL))
    exit(1);

  if (ioctl(hci_sock, HCIDEVUP, vendor_pkt.id) && errno != EALREADY)
    exit(1);

  struct hci_dev_req dr = {0};
  dr.dev_id = vendor_pkt.id;
  dr.dev_opt = SCAN_PAGE;
  if (ioctl(hci_sock, HCISETSCAN, &dr))
    exit(1);
  struct hci_ev_conn_request request;
  memset(&request, 0, sizeof(request));
  memset(&request.bdaddr, 0xaa, 6);
  *(uint8_t*)&request.bdaddr.b[5] = 0x10;
  request.link_type = ACL_LINK;
  hci_send_event_packet(vhci_fd, HCI_EV_CONN_REQUEST, &request,
                        sizeof(request));

  send_complte_ev();
  send_complte_ev();
  pthread_join(th, NULL);
  close(hci_sock);
}

int main(void)
{
  initialize_vhci();
  return 0;
}

--yijhrv2ys2svaijk--
