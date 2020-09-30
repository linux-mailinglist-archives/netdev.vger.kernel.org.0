Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE82427DF20
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 06:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgI3ECW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 00:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI3ECV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 00:02:21 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82FFC061755;
        Tue, 29 Sep 2020 21:02:21 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x16so277301pgj.3;
        Tue, 29 Sep 2020 21:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=A6Iu8CK+fvMEAi5WAmBNnIyxewSXT0brLKenSVEGXL4=;
        b=FOUG2k8+MaztgIzts4HwDlrGsCudjd56IKZWBLbgBRGW/+cSpuwEsCSWMlu5X5nBBu
         8v6RNE3ofy5cTam6TcIjkuItXIvPyc7BnaDjbojyP6bpWtePhAM6lThFjdqzXAhLVzGv
         rJbQKjncIrbIlyRWHDJ29BFUMMRVe0Y5VsBPbLsl3Bst+P8Ktaa043qBw5dyOe+/kXhe
         UYwVUTDrG5ZOP70fROR05CZtKDJ9zhOZyHz1hblG2GGXhyuRq1b96FSREuL9ukVIUWXe
         18YjjTXSkaJR3uRKRYnMtw/wPv5ezudgB2hkwL7x8DllO4HhtpI+cExOxnfKNgTAw4d1
         a28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=A6Iu8CK+fvMEAi5WAmBNnIyxewSXT0brLKenSVEGXL4=;
        b=VcRc6mu+7brWc75q6ILlvYGzEL6KabQ23PT5qCQEAUJ26350zKIcCrIa9ueDPpQl7g
         tmauz128WqxRYuV0/aJSrrs03p+GWwlUrLn34I3Q4/mKCh7dMapxTNeGAaD5LHKbO9R8
         BdGwSp8Mq+z4wrccAaXtIvIZnHX8YBYi7y3qqrAKN3NeoZc3QkALRfZESJFG3Wj3kaql
         gSiKk7QOXWogOwuXeBkvq5oBvKVwClUsYV6V0YoQEohOGkLD2uNd9SdTcq1A8RMjShMG
         5suLpl9qAgM+7SRmLg10aAlvHqU+0UX1wYr5OoAV0PEEURvumOeeTrR9AGeOMfRrabc2
         y94A==
X-Gm-Message-State: AOAM5331xaOuVIzMSKRR4G7p4gGVGfROG5u3spkiwnjHBM2RJ0eB6eLQ
        Nt71zBF5XpISpvpn6TzuX0wxGR7licyYlqdzwoQ=
X-Google-Smtp-Source: ABdhPJyA5nA4I3XO3XKaf/fb/M89xL8cx8S1ztqnn2lD6/kSbg6onBEyGX/DZDqqLsywchH+AQJnXQ==
X-Received: by 2002:a63:a51a:: with SMTP id n26mr624314pgf.1.1601438540777;
        Tue, 29 Sep 2020 21:02:20 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.218.220])
        by smtp.gmail.com with ESMTPSA id f19sm354554pfd.45.2020.09.29.21.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 21:02:19 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees][PATCH] net: usb: rtl8150: prevent
 set_ethernet_addr from setting uninit address
To:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200929082028.50540-1-anant.thazhemadam@gmail.com>
 <20200929084752.GA8101@carbon>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <b5542434-7d12-0bba-8e54-8c5edfcb33b3@gmail.com>
Date:   Wed, 30 Sep 2020 09:32:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929084752.GA8101@carbon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/09/20 2:17 pm, Petko Manolov wrote:
> On 20-09-29 13:50:28, Anant Thazhemadam wrote:
>> When get_registers() fails (which happens when usb_control_msg() fails)
>> in set_ethernet_addr(), the uninitialized value of node_id gets copied
>> as the address.
>>
>> Checking for the return values appropriately, and handling the case
>> wherein set_ethernet_addr() fails like this, helps in avoiding the
>> mac address being incorrectly set in this manner.
>>
>> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> ---
>>  drivers/net/usb/rtl8150.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
>> index 733f120c852b..e542a9ab2ff8 100644
>> --- a/drivers/net/usb/rtl8150.c
>> +++ b/drivers/net/usb/rtl8150.c
>> @@ -150,7 +150,7 @@ static const char driver_name [] = "rtl8150";
>>  **	device related part of the code
>>  **
>>  */
>> -static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
>> +static int get_registers(rtl8150_t *dev, u16 indx, u16 size, void *data)
>>  {
>>  	void *buf;
>>  	int ret;
>> @@ -274,12 +274,17 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>>  		return 1;
>>  }
>>  
>> -static inline void set_ethernet_addr(rtl8150_t * dev)
>> +static bool set_ethernet_addr(rtl8150_t *dev)
>>  {
>>  	u8 node_id[6];
>> +	int ret;
>>  
>> -	get_registers(dev, IDR, sizeof(node_id), node_id);
>> -	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
>> +	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
>> +	if (ret > 0 && ret <= sizeof(node_id)) {
> get_registers() was recently modified to use usb_control_msg_recv() which does
> not return partial reads.  IOW you'll either get negative value or
> sizeof(node_id).  Since it is good to be paranoid i'd convert the above check
> to:
>
> 	if (ret == sizeof(node_id)) {
>
> and fail in any other case.  Apart from this minor detail the rest of the patch 
> looks good to me.
>
> Acked-by: Petko Manolov
Got it. I'll be sure to include this in a v2, and send that in soon enough.
Thanks for pointing that out. :)

Thanks,
Anant



