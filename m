Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC394323CC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhJRQ2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhJRQ2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:28:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BA8C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:26:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso374404pjw.2
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SHQG7ikR9fBih/BHH+xeTiiBWxG3uxQ+g06RtZRapNI=;
        b=IjbLDtc0Ev567lO6HDd7wrk+odyOvne1ZXHDyXr7u4Em9TNQJgHIWPKI3MsTucxXuT
         7ePb1BwZckgKSX3r4dddyjSjy184kz2ShmH2OVC0o3uia0voQjRrvXhzt6Ncwgv5Z7Uy
         HTKFx3XIB15y4Z3EwFridXRpL2QyA2fzVlMZfA5MvqYRsJwdW2LS/ZcwI/1mGseafa5c
         s2KE6B4PAs7qKmkhXJ+mga1qV1LyzZ0j5gREPKdGhks2aZ3YZ+Ggf3NC5QFHyquDMyZZ
         IOke2DLEyaL5kqH8O91wHCfQGqPzvDuscK91hrxCgE5mE8zCdAfG7Zk2NJkYT4V5p5h2
         chrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SHQG7ikR9fBih/BHH+xeTiiBWxG3uxQ+g06RtZRapNI=;
        b=LfbDRQHqEgvfrIvbq8YfUAKKVb4/4m/CCBxB5Gx1WpFIyvLjKDu2tre706NEDdAwwl
         H+UPuQfFGD/VPZz13FGwyuoql/ROqy/1ibWeOdh7AQN+2piA7fGTbD9Qzz2nQdpH5CiK
         ffu+hfvsar81LVmr0xV1GSS/ckKX73KQIP8m5S0/ymYdj0167kYzeSLuEMPe11WC9I9h
         oB1nevGO8vi7H0jUrcOoKahiOpjfLKiJaHOKVoUJdcCA3akN9Abyn852oqciyQvq+Y4n
         2mATWg38BZKDHkE5veQTyfgHsQcjgRhz7ZyG7V/5JBPn2fPhmVw/CcB2y57N/tIzUP2N
         Lndg==
X-Gm-Message-State: AOAM5300z6z1ZwNWKOLqseG3nbANGCCsHjOoMEn0EF4M27OsMw7zXOX7
        9nRt6WzAHfoa0cHAvih4/n69Tg==
X-Google-Smtp-Source: ABdhPJwNTUCGn5FmH4bhdt7xvNTnFTJOz7Zybf47m/q5cG2aVYtq8gvUVI6Vu/J5BWL070qGl84VfQ==
X-Received: by 2002:a17:90b:3687:: with SMTP id mj7mr49426655pjb.196.1634574383302;
        Mon, 18 Oct 2021 09:26:23 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id t11sm14562903pfj.173.2021.10.18.09.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 09:26:22 -0700 (PDT)
Message-ID: <6dc4c0b4-8eaa-800a-a06c-a16cbee5a22e@pensando.io>
Date:   Mon, 18 Oct 2021 09:26:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, vkochan@marvell.com,
        tchornyi@marvell.com
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
 <186dd3ec-6bab-fe3c-cbab-a54898d51f57@pensando.io>
 <20211018071915.2e2afdd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20211018071915.2e2afdd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 7:19 AM, Jakub Kicinski wrote:
> On Sat, 16 Oct 2021 14:19:18 -0700 Shannon Nelson wrote:
>> On 10/15/21 12:38 PM, Jakub Kicinski wrote:
>>> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
>>> of VLANs...") introduced a rbtree for faster Ethernet address look
>>> up. To maintain netdev->dev_addr in this tree we need to make all
>>> the writes to it got through appropriate helpers.
>>>
>>> We need to make sure the last byte is zeroed.
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>>>    	/* firmware requires that port's MAC address consist of the first
>>>    	 * 5 bytes of the base MAC address
>>>    	 */
>>> -	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
>>> -	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
>>> +	memcpy(addr, sw->base_mac, dev->addr_len - 1);
>>> +	eth_hw_addr_set_port(dev, addr, port->fp_id);
>> Notice in this case I think the original code is setting the last byte
>> to port->fp_id, found I think by a call to their firmware, not by adding
>> fp_id to the existing byte value.
> Yeah, as mentioned in the commit message and discussed with Vladimir.
> Notice that the memcpy is (,, size - 1) and the initial buf is zeroed.
>
>> This is an example of how I feel a bit queezy about this suggested
>> helper: each driver that does something like this may need to do it
>> slightly differently depending upon how their hardware/firmware works.
>> We may be trying to help too much here.
>>
>> As a potential consumer of these helpers, I'd rather do my own mac
>> address byte twiddling and then use eth_hw_addr_set() to put it into place.
> This is disproved by many upstream drivers, I only converted the ones
> that jumped out at me on Friday, but I'm sure there is more. If your
> driver is _really_ doing something questionable^W I mean "special"
> nothing is stopping you from open coding it. For others the helper will
> be useful.
>
> IOW I don't understand your comment.

To try to answer your RFC more clearly: I feel that this particular 
helper obfuscates the operation more than it helps.

sln

