Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C1C5596D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfFYUwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:52:20 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35575 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:52:20 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so218773ioo.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZosbCRC3BKmkQ4XQ5xvCgitO4p+sD8O9+llqMw5MMfY=;
        b=kYF5aSJ8hJKJowd7YHidCCY5qC8sxTvJ8W/rbazw3GzJvkkFjO4EI/wWEH25uhNP70
         Au5Hlkpx+18w3tjZEv2yjaRlfrrTEgbUD0+38J1sZVoh9/DhMJTRO/JjNBOvIhk4cS+Y
         HoTLfOthXRh98gZJ4fWhotVqOGRVsUJCWeN85P5U8iC9AyuemM1D2OW/pt8oZvWcSaed
         fQgYJVlYh7go1nnrkdtMgeFo/rcwXflT6MutrPBH4ZCVhOWUzOuoUw/WqbM2x/U1Uuyt
         aNWC5DTlXVB7ICuKKe0nao5KlA15llWyJ6J+0dF5jmnlenGmQRwhc0KLmO0SjXtYZhYX
         8i2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZosbCRC3BKmkQ4XQ5xvCgitO4p+sD8O9+llqMw5MMfY=;
        b=WKe4tPj38NyhZwre8j5eqZXQ+PUlgoIpHv5CWSl9QzvRLuG+qB4U6NfWrufPMmEpqZ
         8Fz1KHlxuQwTtV5ADkzLdLSXCyhayhCqVIJ85Blg+gbMs8W9tbmBle4flK4eFkvJlU3/
         CqJpXIzssJbzlm5uNDRgPMJq4BEELcnfF/DUSMEyPE5UrkkrKpeaz5rLVdZSFAMUUJS3
         3nT74Wrmh5GfpaKjJ1Q+2V02Tn8b5yhv2nyEM+uosBdLFHiXL1uL763XWoh6J2woAteD
         d/N3f+H9QdJXwmg6qIg6jJYbcLqMTpAD41pB4+X6HyuanTF+EUfhpUOxEb3dr/CPzFhE
         LAlw==
X-Gm-Message-State: APjAAAVseduGm8+ykUxzdVcHE/Py2f69MfVGgAIkbtyZ1hrLWNyPXc2/
        1bDJY4b4sZP/7oV1XW+g/KLAYaJm
X-Google-Smtp-Source: APXvYqwBpyShQASk8PIZZsGa5T6FY9BBk+2Lojf3KP8PSTgbpo0Wq2vbUkqbKQe7Jlw8o+gHjvsh1g==
X-Received: by 2002:a5d:915a:: with SMTP id y26mr742360ioq.207.1561495938517;
        Tue, 25 Jun 2019 13:52:18 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:15b9:c7c8:5be8:b2c9? ([2601:282:800:fd80:15b9:c7c8:5be8:b2c9])
        by smtp.googlemail.com with ESMTPSA id c1sm13042985ioc.43.2019.06.25.13.52.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 13:52:17 -0700 (PDT)
Subject: Re: [PATCH net] vrf: reset rt_iif for recirculated mcast out pkts
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20190625103359.31102-1-ssuryaextr@gmail.com>
 <f0a47b5d-6477-9a6a-cf5d-6e13f0b4acdc@gmail.com>
 <CAHapkUghFv-DyjY=KtKrJYicJpvRrL1cRa50Gr7tG-H4-10Lzg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4a22424-9f4f-cbc2-8fb8-292c1501e875@gmail.com>
Date:   Tue, 25 Jun 2019 14:52:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAHapkUghFv-DyjY=KtKrJYicJpvRrL1cRa50Gr7tG-H4-10Lzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 2:42 PM, Stephen Suryaputra wrote:
> On Tue, Jun 25, 2019 at 4:22 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 6/25/19 4:33 AM, Stephen Suryaputra wrote:
>>> @@ -363,10 +376,20 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>>>  #endif
>>>                  ) {
>>>                       struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
>>> -                     if (newskb)
>>> +                     if (newskb) {
>>> +                             /* Reset rt_iif so that inet_iif() will return
>>> +                              * skb->dev->ifIndex which is the VRF device for
>>> +                              * socket lookup. Setting this to VRF ifindex
>>> +                              * causes ipi_ifindex in in_pktinfo to be
>>> +                              * overwritten, see ipv4_pktinfo_prepare().
>>> +                              */
>>> +                             if (netif_is_l3_slave(dev))
>>
>> seems like the rt_iif is a problem for recirculated mcast packets in
>> general, not just ones tied to a VRF.
> 
> It seems so to me too but I wonder why this hasn't been seen...
> Can I get more feedbacks on this? If there is an agreement to fix this
> generally, I will remove the if clause and respin the patch with more
> accurate changelog.

rt_iif is used to save the original oif during a route lookup so if
packets are delivered locally apps can know the real oif and not the
loopback/VRF device which is just a trick for local traffic.

The raw socket lookup was recently changed to handle local traffic with
raw sockets bound to a device. e.g., ping was recently changed to use
SO_BINDTODEVICE vs IP_PKTINFO and revealed that the socket lookup was
not considering rt_iif when doing the lookup for 'ping -I <dev> <dev addr>'

The mcast use case seems to get hung up on rt_iif being set when packets
are recirculated for local delivery which is slightly different use case
than local traffic to local addresses.
