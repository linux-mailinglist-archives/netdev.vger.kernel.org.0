Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E41E7DD95
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbfHAOP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:15:56 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51321 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731665AbfHAOPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:15:53 -0400
Received: by mail-wm1-f44.google.com with SMTP id 207so64841905wma.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hQiPzWxvnpkWNbMqkCMWGKGOuScBFYwQeSI9ij30x08=;
        b=GhCwRnvdds8KBtN4iFv2W3DVlt3DWvoYZRd/CsXZllkwiS8Nhzt1yCo6ymxP0u7xBh
         eCYZ/u7NHnDg9jnRKv3rB7lxPOhTkEeS7FVlmosef9csr8tAiic9tJ3WmSAnRFUo21Yz
         Nz5tT3MEbQbpRDbX/ILlyihRmA3QPla26sthk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hQiPzWxvnpkWNbMqkCMWGKGOuScBFYwQeSI9ij30x08=;
        b=MSMHqth8w5nfqeiq/rlKxf4MPKvaT7IEj7XBfSuWuFH1YWRRlGh4PySBvx+BieDGny
         DbRYlTF831j8u9aAI809KYrdXFYPLbM4FRL1r5CkYnXeLw6XsqfJDLb/ek39OZ6U+hrO
         I1kdIfdCeYuiqGLym9wS6ED9Ei8IeMiEXr5b7dKg2fr6qtSU6XzBtCFR4uVzruCTH4D5
         blcUrYq6VAeiQpnrUDLZWV+8t7yRvmXJ2e8PqUGUctVYV52Y6CAojFrDJJWosOu+90ih
         TrXyXTNnNK/bO8LXhM+DnEQDOnm7tSAV40ng9SF+deR3mOfv1MEkbzAu9zCRJFsiflHe
         zcyA==
X-Gm-Message-State: APjAAAUni0E/QxWLCzAkvGry4soPRf88kXQFsGT8gCutiD6eexadhQRX
        boqwJln/x0jvni3GLRGqfOGBOQ==
X-Google-Smtp-Source: APXvYqxxyd2Wb9fIVKQBcKG+WjYh5rblDgprq4d8CFxvcGy/4zK1RDOxxUSnPUjNSc10FnhtRO7hZg==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr119513943wmh.55.1564668951053;
        Thu, 01 Aug 2019 07:15:51 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d16sm66277305wrv.55.2019.08.01.07.15.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 07:15:50 -0700 (PDT)
Subject: Re: [net-next,rfc] net: bridge: mdb: Extend with multicast LLADDR
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, idosch@mellanox.com,
        andrew@lunn.ch, allan.nielsen@microchip.com
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, petrm@mellanox.com,
        tglx@linutronix.de, fw@strlen.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1564663840-27721-1-git-send-email-horatiu.vultur@microchip.com>
 <f758fdbf-4e0a-57b3-f13d-23e893ba7458@cumulusnetworks.com>
 <1db865a6-9deb-fbd2-dee6-83609fcc2d95@cumulusnetworks.com>
Message-ID: <696c9bcc-f7e3-3d22-69c4-cdf4f37280a9@cumulusnetworks.com>
Date:   Thu, 1 Aug 2019 17:15:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1db865a6-9deb-fbd2-dee6-83609fcc2d95@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/08/2019 17:11, Nikolay Aleksandrov wrote:
> On 01/08/2019 17:07, Nikolay Aleksandrov wrote:
>> Hi Horatiu,
>> Overall I think MDB is the right way, we'd like to contain the multicast code.
>> A few comments below.
>>
>> On 01/08/2019 15:50, Horatiu Vultur wrote:
> [snip]
>>>
>>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>>> Co-developed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
>>> Signed-off-by: Allan W. Nielsen <allan.nielsen@microchip.com>
>>> ---
>>>  include/linux/if_bridge.h      |  1 +
>>>  include/uapi/linux/if_bridge.h |  1 +
>>>  net/bridge/br_device.c         |  7 +++++--
>>>  net/bridge/br_forward.c        |  3 ++-
>>>  net/bridge/br_input.c          | 13 ++++++++++--
>>>  net/bridge/br_mdb.c            | 47 +++++++++++++++++++++++++++++++++++-------
>>>  net/bridge/br_multicast.c      |  4 +++-
>>>  net/bridge/br_private.h        |  3 ++-
>>>  8 files changed, 64 insertions(+), 15 deletions(-)
>>>
>>
>> Overall I don't think we need this BR_PKT_MULTICAST_L2, we could do the below much
>> easier and without the checks if you use a per-mdb flag that says it's to be treated
>> as a MULTICAST_L2 entry. Then you remove all of the BR_PKT_MULTICAST_L2 code (see the
>> attached patch based on this one for example). and continue processing it as it is processed today.
>> We'll keep the fast-path with minimal number of new conditionals.
>>
>> Something like the patch I've attached to this reply, note that it is not complete
>> just to show the intent, you'll have to re-work br_mdb_notify() to make it proper
>> and there're most probably other details I've missed. If you find even better/less
>> complex way to do it then please do.
>>
>> Cheers,
>>  Nik
> 
> Oops, I sent back your original patch. Here's the actually changed version
> I was talking about.
> 
> Thanks,
>  Nik
> 
> 
> 

The querier exists change is a hack just to get the point, I'd prefer
to re-write that portion in a better way which makes more sense, i.e.
get that check out of there since it doesn't mean that an actual querier
exists. :)

