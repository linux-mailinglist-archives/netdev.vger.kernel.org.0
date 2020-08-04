Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663A223B8F7
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgHDKly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbgHDKly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:41:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C0EC06174A;
        Tue,  4 Aug 2020 03:41:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u185so19967793pfu.1;
        Tue, 04 Aug 2020 03:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dS+3+hYqZ66uBhMhwpE9mDgfqdGREXxXTLcJTBg38DQ=;
        b=gOMIs+Ulxkf/Kb2dkPeZGEn2TCWU8Lgw9SjOnGHaKWjSB8ENZ356Iq+3vmqhD/sbdQ
         OFQEoTVcWkrtOfczN3+xZOKCe+ic3JN0BHmTzaB/L7V38v7JFRy9/AJJ3uAPymKpGSP5
         h3Ok5CKfbYEWt4mN46WHUaN6g0HyTzjs65bjQPPAN3OpYKvrKKKxBcjIN1xtfDD8+DMe
         ETEwyXFWsSV3J/4pa5bGRR3mcl4N93gr5bNoAa0TZQHmvDp1IevU1FY87ujtQp4vtNlW
         ZYYGWlhl5el9PAqgdXCvpmfP5CPt7ITxnzsY4hB36NW5H121wgn+tZIpkoOwJNosbMs4
         iepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dS+3+hYqZ66uBhMhwpE9mDgfqdGREXxXTLcJTBg38DQ=;
        b=MWD1PMjcyXjzeFcw+3ucQqXq4nSqQ5WT0/wF9OoF+huGktoR3F5ZfC0O3EQEbZNbqj
         D6LsW9bqsaAMKp2/7j8tqI2VAJ93kHnwRMldhU9D5GMt6s8GzqytHcuE6Y1z9wQFGN5p
         0m4wu+/zKcRgWNRUcZZJk+ATi73X1IAOl7nj8f6t6HWEeOunZrY/dma1SF5hMxmZ0ofg
         kc4F41a5r/U0sx/TqBvat6Pq9lB2Am+eulnind+CxkVcw18RIbSiI2/KlAeW1kWkm/IQ
         KBGnp0HyWNzr/im45sQ0NkxldWvj57D05Ar7BBTK16KFgsX28Z43INt0knzqoPpmkCCZ
         OECw==
X-Gm-Message-State: AOAM532p9xs+HS2zH50zVnWxM7fvJEJlnOfZv2ORGMmUEX4cmjyZFh0d
        arwpGFaL2nrQYB2At+CkT3g=
X-Google-Smtp-Source: ABdhPJwVkry725oBjqKvwKBp+5Fi90O4GOYmW5vJcWNN4EmW2jkEGBAC9qAjuPvRaCJloMFFEN8n8A==
X-Received: by 2002:a63:1208:: with SMTP id h8mr18942187pgl.128.1596537713384;
        Tue, 04 Aug 2020 03:41:53 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id t63sm15210765pgt.50.2020.08.04.03.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 03:41:52 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 4 Aug 2020 18:41:48 +0800
To:     Greg KH <greg@kroah.com>
Cc:     linux-bluetooth@vger.kernel.org,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Linux-kernel-mentees] [PATCH] Bluetooth: Initialize the TX
 queue lock when creating struct l2cap_chan in 6LOWPAN
Message-ID: <20200804104148.nqxcy4f44uga7wjs@Rk>
References: <20200804093937.772961-1-coiby.xu@gmail.com>
 <20200804094253.GA2667430@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200804094253.GA2667430@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:42:53AM +0200, Greg KH wrote:
>On Tue, Aug 04, 2020 at 05:39:37PM +0800, Coiby Xu wrote:
>> When L2CAP channel is destroyed by hci_unregister_dev, it will
>> acquire the spin lock of the (struct l2cap_chan *)->tx_q list to
>> delete all the buffers. But sometimes when hci_unregister_dev is
>> being called, this lock may have not bee initialized. Initialize
>> the TX queue lock when creating struct l2cap_chan in 6LOWPAN to fix
>> this problem.
>>
>> Reported-by: syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com
>> Link: https://syzkaller.appspot.com/bug?extid=fadfba6a911f6bf71842
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  net/bluetooth/6lowpan.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
>> index bb55d92691b0..713c618a73df 100644
>> --- a/net/bluetooth/6lowpan.c
>> +++ b/net/bluetooth/6lowpan.c
>> @@ -651,6 +651,7 @@ static struct l2cap_chan *chan_create(void)
>>
>>  	l2cap_chan_set_defaults(chan);
>>
>> +	skb_queue_head_init(&chan->tx_q);
>>  	chan->chan_type = L2CAP_CHAN_CONN_ORIENTED;
>>  	chan->mode = L2CAP_MODE_LE_FLOWCTL;
>>  	chan->imtu = 1280;
>
>Nice, did syzbot verify that this resolves the issue?
>
>thanks,
>
>greg k-h

Yes. Thank you for reminding me. I'll also add an Tested-by: tag next time.

--
Best regards,
Coiby
