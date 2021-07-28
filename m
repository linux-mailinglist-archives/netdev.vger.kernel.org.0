Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99A53D882A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhG1Gr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbhG1GrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:47:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C62C061757;
        Tue, 27 Jul 2021 23:47:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mt6so3736405pjb.1;
        Tue, 27 Jul 2021 23:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f66ZMHZX+lCkPsWnoYKEl7miIfZefe6vta28xUC0ams=;
        b=QSlXzl3nG4d05ac1KocLQg/TAFy0ByJexdBYysGlKPUTyB8otk2LExPHVLIdaSf3Rs
         LhPmBqxhvmdrVZ1/QD/FQa6cSNbuNLxVOmgS4bAeZyLa8aVSQjqNMQe2eJZH5hHhZVVn
         BaEwGDZ30PhsvIsdxsmrxaRgSIMTzVLFQsytP+r75t1Pp2+ltVp+BQ0v55XJ1QTetIwR
         SxvnDYVQWV0RIMuwJrH7WP2b8/Py+YB6VHToOSroB6oKZe8I7Qy4J1FefrQy0JMQBqS0
         XbIGVeAlEkJpq7BmyHP5IyRVmMLfLLKkshzd1w8kIudmRZDlEZ5ISzoPZL5bUPjhfJ+b
         GC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f66ZMHZX+lCkPsWnoYKEl7miIfZefe6vta28xUC0ams=;
        b=MVMC2fPTSv9SM6gIqY9F29aMyJmuxuYU8BwIsQrvJw8cx4u89l5HHNk1A7VgzUrgYm
         YruAB69KrnT29HvKuVNDvfug4o82vECHctQULnO1sNc7cYpy3Sz1RGgwUksROcBKvH1Q
         3gQDEoxONIqBudnuXTlPUCb1pSnR1SbaZ7ycP7W704Gz1yrcYqLcJRDdiuN/rfrdcufM
         TDuc04wB+KXqhA+8yImy2NW5kYWprs/I/DUKwQ1AbwOVaPTjtwEOl4c8SEcefErZlcre
         ZRlgcHgeibNfWuG4bvIx5/fmZuAz1xC+PgiT87nJ5u+O0lGKb3LY5SIo1p/v0jA+cc/k
         4XGQ==
X-Gm-Message-State: AOAM533m52r5AqgzbEF0bh1/BsQb6invurXwz/hOeOTqNK+ZpX2RTbRF
        QG6a7t18oXOpZBuVzEZwwEU=
X-Google-Smtp-Source: ABdhPJzUGfTWenR5pyv+kD2gjeeNASQWqjw4ZqfE9VZ3L+19W85P9CVHWKdC7pxqjuohZ7r6EXDOvw==
X-Received: by 2002:a63:cd4d:: with SMTP id a13mr27428425pgj.364.1627454843309;
        Tue, 27 Jul 2021 23:47:23 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id c16sm5973776pfb.196.2021.07.27.23.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 23:47:22 -0700 (PDT)
Subject: Re: [PATCH] Bluetooth: skip invalid hci_sync_conn_complete_evt
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
References: <20210721101710.82974-1-desmondcheongzx@gmail.com>
 <A47B24AE-C807-4ADA-B0F7-8283ACC83BF7@holtmann.org>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <30d1e002-4739-4ce4-2857-77404e4dfb68@gmail.com>
Date:   Wed, 28 Jul 2021 14:47:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <A47B24AE-C807-4ADA-B0F7-8283ACC83BF7@holtmann.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/7/21 10:39 pm, Marcel Holtmann wrote:
> Hi Desmond,
> 
>> Syzbot reported a corrupted list in kobject_add_internal [1]. This
>> happens when multiple HCI_EV_SYNC_CONN_COMPLETE event packets with
>> status 0 are sent for the same HCI connection. This causes us to
>> register the device more than once which corrupts the kset list.
> 
> and that is actually forbidden by the spec. So we need to complain loudly that such a device is misbehaving.
> 
>> To fix this, in hci_sync_conn_complete_evt, we check whether we're
>> trying to process the same HCI_EV_SYNC_CONN_COMPLETE event multiple
>> times for one connection. If that's the case, the event is invalid, so
>> we skip further processing and exit.
>>
>> Link: https://syzkaller.appspot.com/bug?extid=66264bf2fd0476be7e6c [1]
>> Reported-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
>> Tested-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>> net/bluetooth/hci_event.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index 016b2999f219..091a92338492 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -4373,6 +4373,8 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
>>
>> 	switch (ev->status) {
>> 	case 0x00:
>> +		if (conn->state == BT_CONNECTED)
>> +			goto unlock;  /* Already connected, event not valid */
> 
> The comment has go above and be a lot more details since this is not expected behavior from valid hardware and we should add a bt_dev_err as well.
> 

Hi Marcel,

Apologies for the delayed response.

Thanks for the feedback, I'll add more elaboration for the new check and 
add a bt_dev_err in a v2 patch.

>> 		conn->handle = __le16_to_cpu(ev->handle);
>> 		conn->state  = BT_CONNECTED;
>> 		conn->type   = ev->link_type;
> 
> Regards
> 
> Marcel
> 

