Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DBD162F19
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBRSy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:54:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42863 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgBRSy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:54:28 -0500
Received: by mail-wr1-f65.google.com with SMTP id k11so25241194wrd.9;
        Tue, 18 Feb 2020 10:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y7qUJSXwwRkICtUYTtp+S0/ljWs/qWqgz7p3m1sFX4Y=;
        b=aLFDpYUJFF3GYhbt7B7EhwuQo/+PXdf4Cfpf+fLFmynmOloqWaNW1NN/1+DrE7t4Lu
         Srcd9TdLK9vwjhpJ8K2kKkKkWQ4oHIUkxPZt5Gy8dYKeMWmWWc9zxm8N8nGQKRGzV+r5
         llpag+bUfQ9rhiEhw7+9h+haFlzXKTb9ybJpGu3xQIoj7RRhUFhgueF5quN0Hq+efrIy
         Hd1c9NtOLP6y376rgYS4FLyixrDnbWje9cDdiVSt4/UjDuoBeuAv7dmdvMT67HdyFMVE
         YbQEK98gshDK24QcUU95gt1ddTGfPWpSY9k5zn/cRfSnp9sMGNa5R+H7ApcvIUFoG3FP
         qvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y7qUJSXwwRkICtUYTtp+S0/ljWs/qWqgz7p3m1sFX4Y=;
        b=KUVKgi8qOCsQy/5/tcCKj0smDbe4/XPfsWuAaydK4o5NCxXAA/Tii/Vt8vOT9o/8Tn
         ld/s853kG8DWN5VZedExGCXeZF9nezkyRr8F5AeVQV8lf1gNFeQbmWQXhOfPq1z+0DzL
         iiEMIAD6DnMtZP6ll59sa9u5rmAOqVxjgYPwvgAYJupdG0DcyQLTE4lnDk2aoacrQ9tH
         cMhA1MuZIAvSJJcQl8ZYkQgvH2OKAQ1EoLEkek/v7Pk7HOP3j0ovdMLm1xZGSaY4ZZWl
         y5X+pPTbkcPFPCKN30nbkEyrJJAPcCRV0j/OU+Z8VGKEQMq+5JA7gOiCtYbW6Wfc95L/
         Vhhg==
X-Gm-Message-State: APjAAAU9M0EESoCmjA/GtJ9GUrc+GIi780eTTnxZTHCCE0nNwJpO+6+Z
        WZRcWFFjPXR/lxpUOSngYiuwV7jKvng=
X-Google-Smtp-Source: APXvYqzzvKAZpis1HIhIgd3mnujaR+Dlua6dzCzgByfruiDOYiVDYIQnuVVk6MPyVZLvqfKfOGODfQ==
X-Received: by 2002:adf:a381:: with SMTP id l1mr30546370wrb.102.1582052065975;
        Tue, 18 Feb 2020 10:54:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id e22sm4299861wme.45.2020.02.18.10.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:54:25 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] net: core: add helper tcp_v6_gso_csum_prep
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
References: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com>
 <9fdc5f0c-fdf0-122e-48a5-43ff029cf8d9@gmail.com>
 <CAKgT0UeUEcoKZsRnxzftMA4tc2chasmW+sWQkP11hVLbdYTYxA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f349d932-582c-96f9-fa7a-b76c615adb96@gmail.com>
Date:   Tue, 18 Feb 2020 19:53:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UeUEcoKZsRnxzftMA4tc2chasmW+sWQkP11hVLbdYTYxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 19:25, Alexander Duyck wrote:
> On Mon, Feb 17, 2020 at 1:41 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Several network drivers for chips that support TSO6 share the same code
>> for preparing the TCP header. A difference is that some reset the
>> payload_len whilst others don't do this. Let's factor out this common
>> code to a new helper.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  include/net/ip6_checksum.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
>> index 7bec95df4..ef0130023 100644
>> --- a/include/net/ip6_checksum.h
>> +++ b/include/net/ip6_checksum.h
>> @@ -76,6 +76,18 @@ static inline void __tcp_v6_send_check(struct sk_buff *skb,
>>         }
>>  }
>>
>> +static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb,
>> +                                       bool clear_payload_len)
>> +{
>> +       struct ipv6hdr *ipv6h = ipv6_hdr(skb);
>> +       struct tcphdr *th = tcp_hdr(skb);
>> +
>> +       if (clear_payload_len)
>> +               ipv6h->payload_len = 0;
>> +
>> +       th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
>> +}
>> +
>>  #if IS_ENABLED(CONFIG_IPV6)
>>  static inline void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb)
>>  {
> 
> So functionally I believe this is correct. The only piece I have a
> question about is if we should just force the clear_payload_len as
> always being the case since the value should either be
> ignored/overwritten in any GSO case anyway.
> 
I also thought about this and just wasn't sure whether this functional
change may break any driver. But yes, then let's change it this way.
Breaking down the series into smaller patches makes it easier to
revert an individual patch in case of a problem.

> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
Thanks for the review.
