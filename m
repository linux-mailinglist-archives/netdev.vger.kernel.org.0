Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75508162F15
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgBRSy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:54:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41523 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgBRSy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:54:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so25288618wrw.8;
        Tue, 18 Feb 2020 10:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r+BjQ+2qeHRzwq563xO8WHAunXFGHBK9xvOKVsSVi74=;
        b=mhl+g3cDhkTh8cc47iq87t0C9LHE681ndAKjC4TcbgXItv3EV1BNGcZxW5ApFu+dRD
         rNmdhehJtbaguOOf2RdAwyBVCEGKnm1Ab+s4SScl3ZcEQ5v5P+SBZNsFqmJGVkX+39XZ
         I+R8zvVLwGieoR+97B6rq2CJ6eL3TEgU9aUzu1j7uP/tcCLucNEqtlhiZ3vM7/sRTmks
         f8aHHnPf5e4qDI1bdZ3x7w7kbT80hZoNEWa4iVISvQtJxdd6QUuQ0k71XHOsyWqQZeAs
         CKAaG3WvJwmT3tDBXTiwdX57NNHHjDF7wrWkHr/RSQu/O5xfh4SxCdgkHp2ectLBNeE/
         F3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r+BjQ+2qeHRzwq563xO8WHAunXFGHBK9xvOKVsSVi74=;
        b=r1fl9jFNGBXR0Af3v22D4ruQPFmxRTW1mgQNoUsZugbTYWzaVnndI4YMHU43shHAUi
         Vj2tZTXXtPkY6Y9VZ74NHSw4Wsf8Hh6fJj+ZLHysnOWP0tzr5zUrwjqydrAy+JdI8p1z
         I6ZTv1q09nwZGNCUp8PL35JZUMhlYoUWoSeE1Lhh4V3reoaFNNupgmf6VemvYC2Kw+Vj
         cTm1X1+kNjrm8seEMxc2PGta3FKKN/8OAfrs73lHyTYgu3CtX6rvRhyB2moeKZ4tyDH3
         8m2KY0i94wtEg/hR2km7CO8/TD8b/A1WExhKu0sgNVD1Isb7EQmJmZ6a7fafoAc9riTr
         CUqA==
X-Gm-Message-State: APjAAAV59woFsZMiDsUvBvbJ8c0iMw2gy06Ngy6hjylIjsvHcPRHwmmr
        Bnr92SlVj9BZ3eDMLEaVhC0AbbyT9lo=
X-Google-Smtp-Source: APXvYqzABYNfk9UgM05SPcBk6+APE0YnacggzTdBt6Oqs3cqUS9GbNk32+DfkE8bsypZSm0XV9Cwyw==
X-Received: by 2002:adf:e88f:: with SMTP id d15mr29211606wrm.186.1582052063505;
        Tue, 18 Feb 2020 10:54:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id c141sm4251997wme.41.2020.02.18.10.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:54:23 -0800 (PST)
Subject: Re: [PATCH net-next 2/3] r8169: use new helper tcp_v6_gso_csum_prep
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
 <02ea88e7-1a79-f779-d58c-bb1dced0b3b4@gmail.com>
 <CAKgT0UfaBpLxWQZO55-KE8QKJD9XgC2SCPAtzo=PA_MAwRxtuw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5dacf5fb-873b-79d5-326f-f30feb1ac645@gmail.com>
Date:   Tue, 18 Feb 2020 19:45:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfaBpLxWQZO55-KE8QKJD9XgC2SCPAtzo=PA_MAwRxtuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 19:37, Alexander Duyck wrote:
> On Mon, Feb 17, 2020 at 1:42 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Simplify the code by using new helper tcp_v6_gso_csum_prep.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 26 ++---------------------
>>  1 file changed, 2 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 5a9143b50..75ba10069 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -4108,29 +4108,6 @@ static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
>>         return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
>>  }
>>
>> -/* msdn_giant_send_check()
>> - * According to the document of microsoft, the TCP Pseudo Header excludes the
>> - * packet length for IPv6 TCP large packets.
>> - */
>> -static int msdn_giant_send_check(struct sk_buff *skb)
>> -{
>> -       const struct ipv6hdr *ipv6h;
>> -       struct tcphdr *th;
>> -       int ret;
>> -
>> -       ret = skb_cow_head(skb, 0);
>> -       if (ret)
>> -               return ret;
>> -
>> -       ipv6h = ipv6_hdr(skb);
>> -       th = tcp_hdr(skb);
>> -
>> -       th->check = 0;
>> -       th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
>> -
>> -       return ret;
>> -}
>> -
>>  static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
>>  {
>>         u32 mss = skb_shinfo(skb)->gso_size;
>> @@ -4163,9 +4140,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>                         break;
>>
>>                 case htons(ETH_P_IPV6):
>> -                       if (msdn_giant_send_check(skb))
>> +                       if (skb_cow_head(skb, 0))
>>                                 return false;
>>
>> +                       tcp_v6_gso_csum_prep(skb, false);
>>                         opts[0] |= TD1_GTSENV6;
>>                         break;
>>
> 
> This change looks more or less identical to the one you made in
> "drivers/net/usb/r8152.c" for patch 3. If you have to resubmit it
> might make sense to pull that change out and include it here since
> they are both essentially the same change.
> 
Right, it's the same change. I just treated r8169 separately because
I happen to be maintainer of it.
