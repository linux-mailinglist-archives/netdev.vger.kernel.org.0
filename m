Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83387254917
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgH0PUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbgH0LdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 07:33:00 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CFFC0611E1
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:14:22 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id c8so4531827edn.8
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rR/ph2VvMg5ZiBr5sVTI3jrSSv6HVNuaEkn+S4aeeQY=;
        b=ATisAjY/goNwufEYBicR+E0bH7QlH6TaKXu7L80VulWcU7j9r8Rm7jCoMpBClk+tbG
         juC0IbNLYpko1hIGHVmSxnsGhU/pZGhBfKj3KeVXkVW6UlwnCcnFD2fx4JFK5UaWvp9N
         D9zLQk49kZ5ML3MlYuV5HJugMQS2dW3lIv7jAHbXi1r/Mxu9Ui9IMk4dcq8EYABYQqt7
         J5XXseuodE/2exCRG2HJftURi08jZEAy/Tkgg05t5VmnalHKoHi2W2kE3kHbkFIM+yd+
         74zcnMkY5C5OywAO4ZCkX86duU1DWqO5HEquN6bfX5J05hYCZ9cNuMqg9SvoAfeCs3jY
         hn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rR/ph2VvMg5ZiBr5sVTI3jrSSv6HVNuaEkn+S4aeeQY=;
        b=UYDWUIhLECPpeZnKVjororRMIR5J1HVryO0KjG7xam9om45NUQj6ggf0erqSgULl/F
         PE1mk1/6YAt2ou4WlonyKRGIg47eIgg8BL40KuL8gC28GWsUQ0T5EvxWON4nP6rEuGhN
         FBWsV9dGHCR7ULLe8RHzdI3UWOerjjXxIqbPzBlDPMMT7BGnY68vdcFGpYT4eiJfFLEN
         iyo5BavRVc5RW/DtuZG+NxopMLE67K3FfjZEY5oke3vWFzMx15VshjeWLkqvPZYqP4NK
         VsUfTyI2SqN4y9xaY4U2g6Z+Xaf8VEtBKSK2lruqQbv0JBPisz/0ro4EITgYfo1QJmNR
         7pcw==
X-Gm-Message-State: AOAM530p+aRQMlM6V34zr7aW3QW1NEeCqdpgBveVzf1hDF2zivUO30WO
        pGNv4de9zvFymqALqwqy53I=
X-Google-Smtp-Source: ABdhPJz/bN/OUl+6x9t9Ao1LlRNPllubJJLmvmnvxLurr6SM1fiPZfcc870P6GcmVoIbtmMAAuYbkg==
X-Received: by 2002:a50:d6c1:: with SMTP id l1mr4503027edj.228.1598526859049;
        Thu, 27 Aug 2020 04:14:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:88d6:516:4510:4c1f? (p200300ea8f23570088d6051645104c1f.dip0.t-ipconnect.de. [2003:ea:8f23:5700:88d6:516:4510:4c1f])
        by smtp.googlemail.com with ESMTPSA id p9sm1563411eji.103.2020.08.27.04.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 04:14:18 -0700 (PDT)
Subject: Re: powering off phys on 'ip link set down'
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>
Cc:     Lasse Klok Mikkelsen <Lasse.Klok@prevas.se>
References: <9e3c2b6e-b1f8-7e43-2561-30aa84d356c7@prevas.dk>
 <7a17486d-2fee-47cb-eddc-b000e8b6d332@gmail.com>
 <4adfeeab-937a-b722-6dd8-84c8a3efb8ac@prevas.dk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <adcbe6fc-6adc-4138-a5d1-77e811f4c0eb@gmail.com>
Date:   Thu, 27 Aug 2020 13:14:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4adfeeab-937a-b722-6dd8-84c8a3efb8ac@prevas.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2020 13:00, Rasmus Villemoes wrote:
> On 27/08/2020 12.29, Heiner Kallweit wrote:
>> On 27.08.2020 12:08, Rasmus Villemoes wrote:
>>> Hi,
>>>
>>> We have a requirement that when an interface is taken down
>>> administratively, the phy should be powered off. That also works when
>>> the interface has link when the 'ip link set down ...' is run. But if
>>> there's no cable plugged in, the phy stays powered on (as can be seen
>>> both using phytool, and from the fact that a peer gets carrier once a
>>> cable is later plugged in).
>>>
>>> Is this expected behaviour? Driver/device dependent? Can we do anything
>>> to force the phy off?
>>>
>> This may be MAC/PHY-driver dependent. Which driver(s) do we talk about?
> 
> It's a Marvell 88e6250 switch (drivers/net/dsa/mv88e6xxx/).
> 
>> Also it may depend on whether Runtime PM is active for a PCI network
>> device. In addition WoL should be disabled.
> 
> The datasheet does mention WoL, but it's either not hooked up in the
> driver or at least default disabled, ethtool says
> 
>      Supports Wake-on: d
>      Wake-on: d
> 
> Thanks,
> Rasmus
> 

Maybe your question refers to something that was changed in 5.4 with
the following commit:
95fb8bb3181b ("net: phy: force phy suspend when calling phy_stop")
