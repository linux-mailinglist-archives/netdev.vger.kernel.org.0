Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180B12D6E30
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394993AbgLKCoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 21:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731217AbgLKCol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 21:44:41 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838B8C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 18:44:01 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id o11so6988239ote.4
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 18:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0tDJteBxsHXuPyW1+tQBCz8KaIIo5H8mUeLrXX+9d1k=;
        b=oehVFYK/Qnp+XElR2S2D5ykPhtvCwvJF6NP74vU//hm/BkNyBjSmZt+wqRr+O/GdRU
         gsZlh7pbfyOp/l9haNSTaUGBwpA0sIvADwHKHxSAsaAEAvwjfasQujYXL4cWXykhv1VH
         wotwYznBRCIOMrWRZ74qSIBONYD49m8dDvUJxSDrRtbDISVdoI7PFWXcPM6pkkxX4919
         3VQn1yDLW5uT/p/H8vlS7Tw58+STGqMxlHnbUJ24TgT2mnAX08YQ6SS1lt9ZPTrhcwCh
         2VI4cQVXrwA3N0orJQ9huVtktQ2xmg1G6mE6yvXvxNXMvgMLDNTWqxQcm6S6PHc44Cjp
         aDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0tDJteBxsHXuPyW1+tQBCz8KaIIo5H8mUeLrXX+9d1k=;
        b=pweFJOlZXHr7xSpaarqLmaRDUly4wEj9drY5INuMkLo31/hn/C4JMLzozYkjxBmi/9
         LiiloSLfbWR/amjS3o88Vb2SXjmdMrk5kWxSW9MlEZ4tTFOLfIWmzN/hCgMjfay03qgd
         TciKmfzCjsEXF26RdkaIK5W+p4YQFl8zvfXz6NBJMmVSyZ1K3S/BIxf5Sdk8sdF27jU/
         f0GMQ1HqkveMEhWwdaAfibsZp+1NAL1Il683sCz5s1zE8055nSHlU6967cbucYVgaowM
         HHeHMQjUdlebUfWlJAtedw0ZfvrI0Q4aNPpvVL3KDqeivfQcUSMzpr4btdeQ6lRaH7+e
         30LQ==
X-Gm-Message-State: AOAM532XwOnh+6LkJg4YJzYHS+U8HaemxpeRBJlBejtEdbhFX0nMhdS/
        7NxdtRAfeR5EWPoq4pzP2ys=
X-Google-Smtp-Source: ABdhPJwfTjxk6Deev7ECfhrA/aCwgb8wvbJAowJk+Tc/HXZ6uCkkUAAyuIOpUMGAm0s58mkbgY7bWg==
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr8198842oto.90.1607654640782;
        Thu, 10 Dec 2020 18:44:00 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:6139:6f39:a803:1a61])
        by smtp.googlemail.com with ESMTPSA id d62sm1474713oia.6.2020.12.10.18.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 18:43:59 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
 <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
 <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
 <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
 <ab298844-c95e-43e6-b4bb-fe5ce78655d8@gmail.com>
 <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
 <20201210180108.3eb24f2b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5cadcfa0-b992-f124-f006-51872c86b804@gmail.com>
Date:   Thu, 10 Dec 2020 19:43:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210180108.3eb24f2b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/20 7:01 PM, Jakub Kicinski wrote:
> On Wed, 9 Dec 2020 21:26:05 -0700 David Ahern wrote:
>> Yes, TCP is a byte stream, so the packets could very well show up like this:
>>
>>  +--------------+---------+-----------+---------+--------+-----+
>>  | data - seg 1 | PDU hdr | prev data | TCP hdr | IP hdr | eth |
>>  +--------------+---------+-----------+---------+--------+-----+
>>  +-----------------------------------+---------+--------+-----+
>>  |     payload - seg 2               | TCP hdr | IP hdr | eth |
>>  +-----------------------------------+---------+--------+-----+
>>  +-------- +-------------------------+---------+--------+-----+
>>  | PDU hdr |    payload - seg 3      | TCP hdr | IP hdr | eth |
>>  +---------+-------------------------+---------+--------+-----+
>>
>> If your hardware can extract the NVMe payload into a targeted SGL like
>> you want in this set, then it has some logic for parsing headers and
>> "snapping" an SGL to a new element. ie., it already knows 'prev data'
>> goes with the in-progress PDU, sees more data, recognizes a new PDU
>> header and a new payload. That means it already has to handle a
>> 'snap-to-PDU' style argument where the end of the payload closes out an
>> SGL element and the next PDU hdr starts in a new SGL element (ie., 'prev
>> data' closes out sgl[i], and the next PDU hdr starts sgl[i+1]). So in
>> this case, you want 'snap-to-PDU' but that could just as easily be 'no
>> snap at all', just a byte stream and filling an SGL after the protocol
>> headers.
> 
> This 'snap-to-PDU' requirement is something that I don't understand
> with the current TCP zero copy. In case of, say, a storage application

current TCP zero-copy does not handle this and it can't AFAIK. I believe
it requires hardware level support where an Rx queue is dedicated to a
flow / socket and some degree of header and payload splitting (header is
consumed by the kernel stack and payload goes to socket owner's memory).

> which wants to send some headers (whatever RPC info, block number,
> etc.) and then a 4k block of data - how does the RX side get just the
> 4k block a into a page so it can zero copy it out to its storage device?
> 
> Per-connection state in the NIC, and FW parsing headers is one way,
> but I wonder how this record split problem is best resolved generically.
> Perhaps by passing hints in the headers somehow?
> 
> Sorry for the slight off-topic :)
> 
Hardware has to be parsing the incoming packets to find the usual
ethernet/IP/TCP headers and TCP payload offset. Then the hardware has to
have some kind of ULP processor to know how to parse the TCP byte stream
at least well enough to find the PDU header and interpret it to get pdu
header length and payload length.

At that point you push the protocol headers (eth/ip/tcp) into one buffer
for the kernel stack protocols and put the payload into another. The
former would be some page owned by the OS and the latter owned by the
process / socket (generically, in this case it is a kernel level
socket). In addition, since the payload is spread across multiple
packets the hardware has to keep track of TCP sequence number and its
current place in the SGL where it is writing the payload to keep the
bytes contiguous and detect out-of-order.

If the ULP processor knows about PDU headers it knows when enough
payload has been found to satisfy that PDU in which case it can tell the
cursor to move on to the next SGL element (or separate SGL). That's what
I meant by 'snap-to-PDU'.

Alternatively, if it is any random application with a byte stream not
understood by hardware, the cursor just keeps moving along the SGL
elements assigned it for this particular flow.

If you have a socket whose payload is getting offloaded to its own queue
(which this set is effectively doing), you can create the queue with
some attribute that says 'NVMe ULP', 'iscsi ULP', 'just a byte stream'
that controls the parsing when you stop writing to one SGL element and
move on to the next. Again, assuming hardware support for such attributes.

I don't work for Nvidia, so this is all supposition based on what the
patches are doing.
