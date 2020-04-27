Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560D41BB008
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgD0VMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgD0VMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:12:06 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DAAC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:12:05 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so22243522wrs.9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GNaMe1DhHJEhpbaiRVrEp64lovQYiRvz4mQuf4vIN+4=;
        b=bMf07Jy6xU2JUPBNuHWBUTXy80NfkTTbcvPqifgEhlxFuU9/4tQXnAXsAiVNtplMQE
         Ee7nmePIZZ9OYZucn5Fp5YLEZD2pFntGe8X+eczJDHeJUCshXFCPVwFZWW1jHaOIK+Pi
         cGZufIeNVhtQL91FyjYT+Q7BaNKaaI374yOBTjg++S0It0PmDor4LyTYacr7dRocEUhN
         n2zn51M6tIqENqjg4hvsanO2Dmnqs0LaN6IccnCP+//xjBEZUrMrGglEPInSJ8Nvm3/H
         +JdvecLrcCZBSJgmldkK5m4TROR4U5AyJPZeoIdEB4T/A8Ra8RQuixwfAnJE08vjyNvv
         R5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GNaMe1DhHJEhpbaiRVrEp64lovQYiRvz4mQuf4vIN+4=;
        b=NuHxQCwyN+s7izZFV6Gbuf97TAAPPtTplmlwV2tOG+sj7vnF3Iffj61oeGa6wAsDpK
         GnICi3odZZMHyyLwCn9n8wdOeptBMFNjWAEnKQJLszP+lpJlvQjmeLiESKRn+Ay4XuyQ
         291TcaVFeNI2m7cG+FTG4DyBcfruFe8BG7exYZFMe0TGCSiKoLgjfpR+ZAIwlWmeILb0
         0PhOfHcPgtTBOQW3U4zVyN/aC3m3yimh6j7T7JeURoU4yDBbJpI8FMnSifVib/2kgWHB
         e9OCvv5IsnOxRaYuhLkM5SumHdQn26F3oAXV4CnZlAANKQzuuR/7LWlFxOEtH0EIw1tO
         ZTvw==
X-Gm-Message-State: AGi0PuZGehjpnH1AyBM+GHYtjHlBbkuU1WSlhLkYYlJEsnzTRJyPcAPf
        +7oCbWwocQA1+f+P8HZpg65j625lfqU=
X-Google-Smtp-Source: APiQypKMhubuaxfjOiaRMxjqLCgMkDTko0daJpOPk+dwPIzWxB3c+ffHxREupIXNNQGa4V6j7o3x9w==
X-Received: by 2002:adf:e5c7:: with SMTP id a7mr30457760wrn.241.1588021923320;
        Mon, 27 Apr 2020 14:12:03 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ec08:2c60:7f09:a6e7:d003:387? ([2a01:e34:ec08:2c60:7f09:a6e7:d003:387])
        by smtp.gmail.com with ESMTPSA id r18sm19644542wrj.70.2020.04.27.14.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 14:12:02 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Charles DAYMAND <charles.daymand@wifirst.fr>,
        netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
 <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
 <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
 <297e210f-1784-44a9-17fb-7fbe8b6f9ec3@gmail.com>
 <CANn89iKA8MAef-XfkbLG3W+3=qUx4pqmKuWPBfrxAcupohLkyA@mail.gmail.com>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
Message-ID: <17fd01b4-8d4e-5c91-c51e-688a97c0da54@wifirst.fr>
Date:   Mon, 27 Apr 2020 23:12:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKA8MAef-XfkbLG3W+3=qUx4pqmKuWPBfrxAcupohLkyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric, Hello Heiner,

Just for a small follow-up on your questions and current status on our 
side for this strange topic:

  * As explained by Charles, the setup includes a mix of macvlan + vlan. 
So 802.1q frames are not a typo in the topic (in our real case, the 
second macvlan interface is sent to a network namespace, but it does not 
matter for the current issue).

  * We tested the same setup with other networking driver (bnx2, tg3) 
with tx-checksum enabled (exactly same configuration than the failing 
one on r8169 for checksum offloading), and it's perfectly working.

  * Packets are seen as valid by tcpdump on the sender (buggy) host.

  * Multicast *and* unicast packets are buggy. We detected it first on 
multicast (since the relevant hardware was sending RIP packets), but all 
tcp/udp packets are corrupted. ICMP packets are valid.

  * We expected as well a "simple" checksum failure, but it does not 
look so simple. Something, on our opinion probably the driver or 
hardware, is corrupting the packet.

  * Experimental patches from Heiner are not solving issue.

  * We have the same behavior on at least RTL8168d/8111d, 
RTL8169sc/8110sc and RTL8168h/8111h variants.


As proposed by Heiner, we will try to debug step by step packet path 
inside the kernel to find where it's become corrupted. But it looks time 
consuming for people like us, not really experts in driver development. 
If you have any tips or ideas concerning this topic, it could help us a lot.

Best regards,

-- 
Florent.
