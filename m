Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DF61C4876
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgEDUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgEDUkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:40:36 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDC9C061A0E;
        Mon,  4 May 2020 13:40:36 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s18so338054pgl.12;
        Mon, 04 May 2020 13:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s+heEemOwQyNdJSgJMIwGaJYB57zeWGbT4EXnqibXcw=;
        b=GGGcXixmHB4vgU64zEUJ10UmaUBE4ReUmUIJlCLPmHrQdED/jWsBwFOUN89B/CYz2q
         BIvQU8IOKPyVo539jSSPrZbG3OYK1NXUgkBAxM7mWsErIXjpLLEXtt9LN5FcKSZqZFI4
         jXv543acGB/mRQJOl7XvFR9wv7M7N6i5dykcj6SZGzi4xdasZhwHjQ4hIU/ctDHlxQF2
         gPRRRUgedkbCzI7MayYZc8hA9hA1sQ5GVVGpGCFcaQpcowyDEL20/QloFxI8AOeyROmN
         /O7KvsmsgqUrt2I3isktFt6F+AEGa6kbYSLWeraKxuagIw/diAXx5TaXhdXH7qaaU1BY
         m1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s+heEemOwQyNdJSgJMIwGaJYB57zeWGbT4EXnqibXcw=;
        b=gGyjvo02YCn86frZuKS4N1/U3YgzMDBC9rWyB2bQrcSWpXsHDsUB8u2psnlgncX8Ce
         jwwSWRD3cqrYcse5i8NBGL1Kbkn4kptkRLq660YyL1/+G/ULSjV9WNV+PNoqE1Amco+G
         LXN2ZQPG9hswoEqG0wtg/vdvbRP5KDYttzVKLQbb4sQfi1vb1Z5wq5nr1ImRvYGB+Za/
         q0haD6lE9hZZYUQHZwUEuFbyng1DO9Gk9jEKRwo2qOADpht5avWtqHuYdejUpqVMvPef
         gk5gE53L55doKEtusquX2soPCsGjTEWXJ6QRl642PDsVb17pRfnHRRJihKKVpIiGDpNX
         20AQ==
X-Gm-Message-State: AGi0PuYKgvWlXsJeDMgYPP5FhhirGDNoF0qt25BrH9ve2/syD973Czlb
        J9IS3h5qpm6I8HDQCZreJqGQxfvO
X-Google-Smtp-Source: APiQypLt3FPzlmP0eYw50z+9hZxKllxEHDumFk6zWFN0z810q1huBOe8cSLoX0iLTVzlgK11zybc3g==
X-Received: by 2002:a63:5b41:: with SMTP id l1mr89071pgm.88.1588624835641;
        Mon, 04 May 2020 13:40:35 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a26sm8334780pgd.68.2020.05.04.13.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 13:40:34 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: Do not leave DSA master with NULL
 netdev_ops
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, allen.pais@oracle.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200504201806.27192-1-f.fainelli@gmail.com>
 <CA+h21ho50twA=D=kZYxVuE=C6gf=8JeXmTEHhV30p_30oQZjjA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b32f205a-6ff3-e1db-33d1-6518091f90b4@gmail.com>
Date:   Mon, 4 May 2020 13:40:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21ho50twA=D=kZYxVuE=C6gf=8JeXmTEHhV30p_30oQZjjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 1:34 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Mon, 4 May 2020 at 23:19, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> When ndo_get_phys_port_name() for the CPU port was added we introduced
>> an early check for when the DSA master network device in
>> dsa_master_ndo_setup() already implements ndo_get_phys_port_name(). When
>> we perform the teardown operation in dsa_master_ndo_teardown() we would
>> not be checking that cpu_dp->orig_ndo_ops was successfully allocated and
>> non-NULL initialized.
>>
>> With network device drivers such as virtio_net, this leads to a NPD as
>> soon as the DSA switch hanging off of it gets torn down because we are
>> now assigning the virtio_net device's netdev_ops a NULL pointer.
>>
>> Fixes: da7b9e9b00d4 ("net: dsa: Add ndo_get_phys_port_name() for CPU port")
>> Reported-by: Allen Pais <allen.pais@oracle.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
> 
> The fix makes complete sense.
> But on another note, if we don't overlay an ndo_get_phys_port_name if
> the master already has one, doesn't that render the entire mechanism
> of having a reliable way for user space to determine the CPU port
> number pointless?

For the CPU port I would consider ndo_get_phys_port_name() to be more
best effort than an absolute need unlike the user facing ports, where
this is necessary for a variety of actions (e.g.: determining
queues/port numbers etc.) which is why there was no overlay being done
in that case. There is not a good way to cascade the information other
than do something like pX.Y and defining what the X and Y are, what do
you think?
-- 
Florian
