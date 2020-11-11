Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D193C2AE74F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 05:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgKKEMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 23:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgKKEMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 23:12:36 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40B7C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 20:12:36 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id y7so807033pfq.11
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 20:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2k6URzCfzzpL9VJdHAKuWPN+KAqMKyOJiRf2pxtrQd0=;
        b=ib95Og1V7CTvfY5ePmvuF6Ekpk+c1E2iu4D/b9g0tzYgajzlFA/xBWH+/tF13+WVb3
         MHa8d4tArf6c7HmSP6RWl3HDIsoOKqRfyrQJOdfFkyJzAMQkXzc+7Q8sTplCmEnTcsnE
         esYRRPCeyI3yL17pJ4HeneUCkg5sTbA575j9Amz+YUp9DKDjY7zxDWsTG4qGbtsEmEWj
         drGuMriBLRAjfalAupzaCBKAWyPM0RzVzZ9LriVNGGeAYpRzIY2lTUX+tTRyno28dofj
         8EJDobtMIQ9LH/DgjuZXzGZEBPuLZirhyn1krB5ec8frmwlbZBb4m8ktnoIxqHkUCZ6W
         lnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2k6URzCfzzpL9VJdHAKuWPN+KAqMKyOJiRf2pxtrQd0=;
        b=ozh+F4GiCxUj71SOBcb46ZXRw1UfWL5bzNDwRqP4Djx26AGwpkw1OC4iR82m5HzCvJ
         VYVC2OWNfk+mheLwuSPYeDWaEA7JsDamfmgw0o3DQ/9rhpFRhthNGXld/re7VPMAwEAr
         Kfoef5Xrt3LfxDmHRWejncBxxtDGe9GVQds2ZXkWJG3KpV3xQQzOcRDtPpvGoz76pcgb
         FEsk5wr5akQlGsRf8+5MN+rzH73AtxYXIeO6suJ8ekzCfB42uZ/6338uhoCWuIgQlLZO
         7SZnnQIRP+NKmvYk+lPkOlMDWLNz0Qmm+LtIofLV3pWo7iHHYKI2xATn8UYV2puflxUj
         u0hw==
X-Gm-Message-State: AOAM531FNfupLvEA4Sey/w0ER6fRgcKMlJcB/G0bnXs3Oqerpu9Mdfua
        62+iKQw0ET6d+jEq3DoDcH0=
X-Google-Smtp-Source: ABdhPJyghvBknt10Ae+O3c9GJYH/njd/pbrxEFOrjOONXDo+mDIGwCjsnicIUpBnmzWAONBIDPd82A==
X-Received: by 2002:a62:f252:0:b029:18a:deaf:37d0 with SMTP id y18-20020a62f2520000b029018adeaf37d0mr21148247pfl.48.1605067955978;
        Tue, 10 Nov 2020 20:12:35 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i10sm628537pjz.44.2020.11.10.20.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 20:12:34 -0800 (PST)
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>, vyasevich@gmail.com,
        netdev <netdev@vger.kernel.org>, UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder> <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder> <20201028184644.p6zm4apo7v4g2xqn@skbuf>
 <20201101112731.GA698347@shredder> <20201101120644.c23mfjty562t5xue@skbuf>
 <20201101144217.GA714146@shredder> <20201101150442.as7qfa2qh7figmsn@skbuf>
 <20201101153906.GA720451@shredder> <20201101161308.qt3i72e37qydtpwz@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d3f1b630-44b0-bf16-fbd0-bf56fb320e96@gmail.com>
Date:   Tue, 10 Nov 2020 20:12:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201101161308.qt3i72e37qydtpwz@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 8:13 AM, Vladimir Oltean wrote:
> On Sun, Nov 01, 2020 at 05:39:06PM +0200, Ido Schimmel wrote:
>> You also wondered which indication you would get down to the driver that
>> eventually needs to program the hardware to get the packets:
>>
>> "Who will notify me of these multicast addresses if I'm bridged and I
>> need to terminate L2 or L4 PTP through the data path of the slave
>> interfaces and not of the bridge."
>>
>> Which kernel entity you want to get the notification from? The packet
>> socket wants the packets, so it should notify you. The kernel is aware
>> that traffic is offloaded and can do whatever it needs (e.g., calling
>> the ndo) in order to extract packets from the hardware data path to the
>> CPU and to the socket.
> 
> Honestly, just as I was saying, I was thinking about using the
> dev_mc_add call that is emitted today, and simply auditing the
> dev_mc_add and dev_uc_add calls which are unnecessary (like in the case
> of non-automatic bridge interfaces), for example like this:
> 
> if (!(dev->features & NETIF_F_PROMISC_BY_DEFAULT))
> 	dev_uc_add(dev, static bridge fdb entry);
> 
> To me this would be the least painful way forward.

Vladimir, what do you think about re-posting this series with the DSA
ports operating in standalone or bridge mode with the bridge being
multicast aware, and tackle the termination of PTP frames on DSA ports
being bridged separately?

From what I could read there does not appear to be a problem with doing
RX filtering for standalone ports since we all agree that these
net_device should look like a regular NIC port with RX filtering capability.
-- 
Florian
