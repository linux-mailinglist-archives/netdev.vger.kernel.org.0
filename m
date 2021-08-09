Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D123E3D8C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 03:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhHIBcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 21:32:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232635AbhHIBcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 21:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628472703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6AtH3MREBeTH78AEq1clPuVC+0bJN9ncER27UcApork=;
        b=W3gapVLSBcx2yl+zS6Lfxv7CxjT03RiaECN9r560CyJv87tKs944U0o3mFtS4pQB2Gxvwm
        g9uEy+rTc0FYBe8/xMCNv1Ff01TxvzcmTOgqKRY9LrckU9+WXJTPhhCkw6HZmFWhWFAQRz
        QRlASRdFiMCBzL0k+PDweT9vMuTv8p0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-zrZvywSsOOmHaKkB74VnZg-1; Sun, 08 Aug 2021 21:31:42 -0400
X-MC-Unique: zrZvywSsOOmHaKkB74VnZg-1
Received: by mail-qv1-f72.google.com with SMTP id t9-20020a0562140c69b029033e8884d712so11421777qvj.18
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 18:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6AtH3MREBeTH78AEq1clPuVC+0bJN9ncER27UcApork=;
        b=I37VqDAF46ApHU3VGadvy/gZALVgZL/95JFD74K2afTK9QvPnAjONL5xtno/A6kcV7
         BJszqq9a19aBfrXE6QKSwS95W6Tuj7R+XSdEZSOsWeOwaA7/j5SicU9RmhzWPvUTH86v
         QlE6Kltyo6YDVbUh8JxCqlGPRkJgVCe2uoNWig/EGOjHiCIJvO2U4BaW1WYlNVdSPMl0
         Y1Qq9g8JFC8rF1EuyvsSV6Boh9HK/e0WnBKb1yEriGnHPcldol9gEedCOataInQMXn6B
         C+5O9+xdaNEz5BuxT3bUaTAuTPpPQ4NvSpQ74Deu6X8XPm3puWDAjuTv+IcMtWYq6DmH
         H2Sg==
X-Gm-Message-State: AOAM530ShdwImNWb7wOTpkz0L2Dft+Hxa4Zq4U3CuE40e+erMJOJP8lC
        M+i6c4lwtGubaDJ8U+EUoGo6shKZMbnrKGs6STOXLFOJsn0390X/NsedsR2EdtH0eK4+IewcOGk
        r2S7BPd6pdt7jw9uT
X-Received: by 2002:a0c:8525:: with SMTP id n34mr10231135qva.19.1628472701751;
        Sun, 08 Aug 2021 18:31:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIgCfPcKGMpHmQj25TTlQWsuOBm7l+AJ4fYG5P+sKutKG0eNQ0jB01NZo4YhWBaN4jVjul/g==
X-Received: by 2002:a0c:8525:: with SMTP id n34mr10231126qva.19.1628472701572;
        Sun, 08 Aug 2021 18:31:41 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id h2sm8768555qkf.106.2021.08.08.18.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 18:31:41 -0700 (PDT)
Subject: Re: bonding: link state question
To:     Willy Tarreau <w@1wt.eu>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <020577f3-763d-48fd-73ce-db38c3c7fdf9@redhat.com>
 <22626.1628376134@famine> <d2dfeba3-6cd6-1760-0abb-6005659ac125@redhat.com>
 <20210808044912.GA10092@1wt.eu>
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <79019b7e-1c2e-7186-4908-cf085b33fb59@redhat.com>
Date:   Sun, 8 Aug 2021 21:31:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210808044912.GA10092@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/21 12:49 AM, Willy Tarreau wrote:
> On Sat, Aug 07, 2021 at 08:09:31PM -0400, Jonathan Toppins wrote:
>> setting miimon = 100 does appear to fix it.
>>
>> It is interesting that there is no link monitor on by default. For example
>> when I enslave enp0s31f6 to a new bond with miimon == 0, enp0s31f6 starts
>> admin down and will never de-assert NO-CARRIER the bond always results in an
>> operstate of up. It seems like miimon = 100 should be the default since some
>> modes cannot use arpmon.
> 
> Historically when miimon was implemented, not all NICs nor drivers had
> support for link state checking at all! In addition, there are certain
> deployments where you could rely on many devices by having a bond device
> on top of a vlan or similar device, and where monitoring could cost a
> lot of resources and you'd prefer to rely on external monitoring to set
> all of them up or down at once.
> 
> I do think however that there remains a case with a missing state
> transition in the driver: on my laptop I have a bond interface attached
> to eth0, and I noticed that if I suspend the laptop with the link up,
> when I wake it up with no interface connected, the bond will not turn
> down, regardless of miimon. I have not looked closer yet, but I
> suspect that we're relying too much on a state change between previous
> and current and that one historically impossible transition does not
> exist there and/or used to work because it was handled as part of
> another change. I'll eventually have a look.
> 
> Willy
> 

I am likely very wrong but the lack of a recalculation of the bond 
carrier state after a lower notifies of an up/down event seemed 
incorrect. Maybe a place to start?

diff --git i/drivers/net/bonding/bond_main.c 
w/drivers/net/bonding/bond_main.c
index 9018fcc59f78..2b2c4b937142 100644
--- i/drivers/net/bonding/bond_main.c
+++ w/drivers/net/bonding/bond_main.c
@@ -3308,6 +3308,7 @@ static int bond_slave_netdev_event(unsigned long 
event,
                  */
                 if (bond_mode_can_use_xmit_hash(bond))
                         bond_update_slave_arr(bond, NULL);
+               bond_set_carrier(bond);
                 break;
         case NETDEV_CHANGEMTU:
                 /* TODO: Should slaves be allowed to

