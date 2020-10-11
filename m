Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E850828AAE9
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbgJKWY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387645AbgJKWY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 18:24:28 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72624C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 15:24:28 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u8so20640414ejg.1
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5MLnYhax1FHKZMD1D+K7nuhGrlej5A2HVWzHYnxBNzQ=;
        b=l+tdSyjpgfWl3Pbft45NtL8pZpKkBfSwNwScBYdDXz1Gd0TezKCBS2dFBLtEFnQa0a
         RZZ2/OFHHvbNroS2e8VoUnpa+68kA8aiAcQ7rVUntbIYhBHIcjWbDblIvZxInFj8Oylz
         bdCgH3CiIK3EysyipsUPj+2MpHNkQzvAmy6MePI3wabyML28OU16kf0tcUHJBBEQeVmx
         tP+5Q/G2LJzK4JGEftU6T6tbYSLYSYktfg9Fi3kU4rixAo/+U5z3H7/7cPZa88ENLnEl
         wP1ZFTAlRXG3T0SuR71CQfseZ4mNObUwwqEko6z63sUb6KtK9dXEapvAT6zjJLl263xW
         zaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5MLnYhax1FHKZMD1D+K7nuhGrlej5A2HVWzHYnxBNzQ=;
        b=arDbjOonNjJ0fMsU56k6oU9TOGoEpluDK4YV5RHHqXjZk5LjQXCLWXKJG5RA8/m4cW
         KnVCvYbtGhUkTIUtvhrd7xUfFtRifVFWDuDo5Rfve+xGxEr/HUutvcIrBPOaPKhWtCBz
         n3iy0T/PEjv70WsefVk9p6M3NXaG5b0WmKzMj4r4qz5z6eKiMhQA1rbmT3s1HFCiDf57
         cgXhRyKVa8BxzQbNzzHofXcVSCpF7+HeODAUuQl4OooDEc8/gTw9elIakOo5Z8htuTkG
         Si/G4r61MFB7KM3ezxXsjTFZRrijzqqAf7YbjJXuB8r7UnySKlKucUvVlwpp+A1QYBY5
         xIpA==
X-Gm-Message-State: AOAM5321o4DzYD9QBTMepd4hGTVhDtoyQliPP3ZmnOzMuvOOn2uJ1TOr
        WD3obXaPpgRh1T8pePuVOCk4An40u2Llhw==
X-Google-Smtp-Source: ABdhPJw5U2Ed0jvNbo9pFWQN+an/QxTfIIncGRp0EdzA4gFNbR1mlCyOMLujiRoPJBqaCEkJN9T1Lw==
X-Received: by 2002:a17:906:1955:: with SMTP id b21mr26177729eje.42.1602455066758;
        Sun, 11 Oct 2020 15:24:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id p5sm9676873ejd.56.2020.10.11.15.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 15:24:26 -0700 (PDT)
Subject: Re: [PATCH RFC] net: add helper eth_set_protocol
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <027ab4c5-57e8-10b8-816a-17c783f82323@gmail.com>
 <20201011151332.3123c94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7439895e-3ed5-9aec-826d-194187446dfc@gmail.com>
Date:   Mon, 12 Oct 2020 00:24:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201011151332.3123c94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.10.2020 00:13, Jakub Kicinski wrote:
> On Tue, 6 Oct 2020 22:10:00 +0200 Heiner Kallweit wrote:
>> In all cases I've seen eth_type_trans() is used as in the new helper.
>> Biggest benefit is improved readability when replacing statements like
>> the following:
>> desc->skb->protocol = eth_type_trans(desc->skb, priv->dev);
>>
>> Coccinelle tells me that using the new helper tree-wide would touch
>> 313 files. Therefore I'd like to check for feedback before bothering
>> 100+ maintainers.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> FWIW in case you're planning to start sending conversion patches..
> 
> I'm not 100% sold on this. Maybe it's because I'm used to the call 
> as it is. I don't feel like eth_set_protocol() expresses what
> eth_type_trans() does well enough. Besides there's a whole bunch of
> *_type_trans calls for different (old) L2s, are we going to leave those
> as they are?
> 
Didn't look at the other *_type_trans functions yet. Seems like at least
eth_type_trans() has old functionality that I didn't expect. Based on
name and usage of the function I was under the assumption that it treats
the skb as const. But it does:
skb->dev = dev;
skb_reset_mac_header(skb);
Such (intentional) side effects are not too nice. But as this function is
used in hundreds of places, I think a refactoring would need significant
effort. For now I tend to leave the situation as it is.

>> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
>> index 2e5debc03..c7f89b1bf 100644
>> --- a/include/linux/etherdevice.h
>> +++ b/include/linux/etherdevice.h
>> @@ -64,6 +64,11 @@ static const u8 eth_reserved_addr_base[ETH_ALEN] __aligned(2) =
>>  { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 };
>>  #define eth_stp_addr eth_reserved_addr_base
>>  
>> +static inline void eth_set_protocol(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +	skb->protocol = eth_type_trans(skb, dev);
>> +}
>> +
>>  /**
>>   * is_link_local_ether_addr - Determine if given Ethernet address is link-local
>>   * @addr: Pointer to a six-byte array containing the Ethernet address
> 

