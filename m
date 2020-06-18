Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E511FFB03
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 20:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgFRS0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 14:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbgFRS0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 14:26:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF00C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:26:06 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x6so7067077wrm.13
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=alBJUmTooCDIi8Df/1SYUYyoE/vEWvV8KKKHznNtyfY=;
        b=mdllp+pKQ27kaudh9cheSlRetiRC3K3SY3B9PWvRmdvvMy9egh3+DdW8KZzg6/6nv5
         6qmHmDae++3ySECSw4uhN9aTaINECCI9J7ZCaWseLjpJIGrX0tTTSP6ky2P9jsCiSzeZ
         7oF0tJoxZ1Bf+0l0BtT6BG5rZ4wbXNNE83kZz7lqsykauyCtVQibf2wav38v9XOVyBC6
         6efn4ZujgrMH4L+Q4S706yF5NlizIKuPIyrAdo6W8C4z8Wly0rocsiAyRuj3RN7FfsEX
         ApZkpX8qoyvOcyDjr9Od3s56Vp0xoWfDkWUKHlSEL5IwpJK1JAHu9RZBp44z2LTncQyd
         MVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=alBJUmTooCDIi8Df/1SYUYyoE/vEWvV8KKKHznNtyfY=;
        b=cJHEyW+rvN0yhw5J0hRWDdYIP/g+ixASUHPyAjLWKXxLmMWYMO7uecUThv9EMWs9L6
         n5LOqitN6fCqt6ProHeoDMNFdegUblIRr/qMbs1OyfY/0seDNy/kX41Z//V5lJxPntsS
         wLLFUa/d9LtIKp2tXu+fZ2bN43Gi9Jha7TIRa++OoucUUZj6ej7lNOcg6pY1td6x3Zkq
         YzbKbAbzS7XpK7UNmW9ZV31thICa+t3S0jp9GAsCf5OfVPLC1Ed9Bm/relVKHWHi90A5
         YhoA+/4VrwSiODtipmskxIfKboXIKgZPydpz97L2HvPceABnGIWr7pknqi4ThA6Nu2m5
         Gw0w==
X-Gm-Message-State: AOAM533KcCTyAUp8Ki50p8pSAKBZTaQp4CnPJxVIqfoQfvzEL5+/2kuN
        QE0sR/VYdYEmDfqxZXLdrs4OY0Es
X-Google-Smtp-Source: ABdhPJxcB+HLXAE4COozgyzKBVs+eJ8IMQfC99M8dnER0LxMLdNno7BtdTfey+lsSMS3CDMnpjlC1g==
X-Received: by 2002:a5d:5492:: with SMTP id h18mr5758669wrv.330.1592504764971;
        Thu, 18 Jun 2020 11:26:04 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w10sm4493585wrp.16.2020.06.18.11.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 11:26:04 -0700 (PDT)
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
 <20200618081433.GA22636@laureti-dev>
 <20200618084554.GY1551@shell.armlinux.org.uk>
 <20200618090526.GA10165@laureti-dev>
 <20200618100143.GZ1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2ed4aa25-cbf7-ed90-f2fa-0b7fd32803b7@gmail.com>
Date:   Thu, 18 Jun 2020 11:26:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618100143.GZ1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2020 3:01 AM, Russell King - ARM Linux admin wrote:
> On Thu, Jun 18, 2020 at 11:05:26AM +0200, Helmut Grohne wrote:
>> On Thu, Jun 18, 2020 at 10:45:54AM +0200, Russell King - ARM Linux admin wrote:
>>> Why do we need that complexity?  If we decide that we can allow
>>> phy-mode = "rgmii" and introduce new properties to control the
>>> delay, then we just need:
>>>
>>>   rgmii-tx-delay-ps = <nnn>;
>>>   rgmii-rx-delay-ps = <nnn>;
>>>
>>> specified in the MAC node (to be applied only at the MAC end) or
>>> specified in the PHY node (to be applied only at the PHY end.)
>>> In the normal case, this would be the standard delay value, but
>>> in exceptional cases where supported, the delays can be arbitary.
>>> We know there are PHYs out there which allow other delays.
>>>
>>> This means each end is responsible for parsing these properties in
>>> its own node and applying them - or raising an error if they can't
>>> be supported.
>>
>> Thank you. That makes a lot more sense while keeping the (imo) important
>> properties of my proposal:
>>  * It is backwards compatible. These properties override delays
>>    specified inside phy-mode. Otherwise the vague phy-mode meaning is
>>    retained.
>>  * The ambiguity is resolved. It is always clear where delays should be
>>    configure and the properties properly account for possible PCB
>>    traces.
>>
>> It also resolves my original problem. If support for these properties is
>> added to macb_main.c, it would simply check that both delays are 0 as
>> internal delays are not supported by the hardware.  When I would have
>> attempted to configure an rx delay, it would have nicely errored out.
> 
> I think we'd want a helper or two to do the parsing and return the
> delays, something like:

Can you review Dan's patch series since he is attempting something that
may not end up solving Helmut's problem completely:

http://patchwork.ozlabs.org/project/netdev/list/?series=184052
-- 
Florian
