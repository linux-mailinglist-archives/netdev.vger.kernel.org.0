Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18AA6788B5
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjAWUw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjAWUw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:52:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5AD83ED
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:52:55 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kt14so33896054ejc.3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=B2jTAb1oXTdAbsv/PhUQDA2t9OjmC3jlZ/Up7f/pWKU=;
        b=jW0s0g1XxO9KGNdD27NZOr1vjxGztnyb5NhxReZlz9dD7/M2h9FIK48bR9CozFDiM6
         K+sgZQ25C5KZKfKjhujaErIzOJb2X3v5S5LSh6AJfLraCTqTj+/a98USghcJe3oNcqJi
         a22GpVNLvhMRESCtMZw8MWemWWHyAkDA1mEeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2jTAb1oXTdAbsv/PhUQDA2t9OjmC3jlZ/Up7f/pWKU=;
        b=6X+nDAgaSxTgeWJsQtYOwqmgzWtNbtyTXJ0TfRK1g+bAtC1CffYJYEFgWqBwJuUsTA
         cXmcHaBFCJWnlHOje4bGMxeDPsBZUdNOqffI2cnnBfS7bhuADoQ7lP4brW1YaTXFLS7L
         6bwxAPtyUkubAc0SBC//N62vS8JkdDCjqhx7gDesNO4UftI1R4/56u5kkt9Vkow9sh+c
         zvWOs4odGZLeMAwFViXa7ksYkXnoXIMpCjexZ58GcTTreFuoOLEtKAadAfy+yTAEpelB
         K0KyfVYyH70pG2e/3xOL5zj+0PiD3wDT82U7hEK4uRGgNtGLAwoccTfTPhBcvP8CDrec
         UCQw==
X-Gm-Message-State: AFqh2koNkEFtrOvTe2OTxjA7PhGgH07NDoI9DI77exuYTpYIHqHn0epW
        yz2ltPizcXXJqjH1Ltx+T6cquw==
X-Google-Smtp-Source: AMrXdXtOL2cJ4qtQ+2T5p1tUsKu06PtI+IV4rmGD+Pr640npJ8at3e1sR9sZgTKDqoGlg3SX7iTagw==
X-Received: by 2002:a17:906:71a:b0:7c1:6344:84a with SMTP id y26-20020a170906071a00b007c16344084amr27992626ejb.5.1674507173564;
        Mon, 23 Jan 2023 12:52:53 -0800 (PST)
Received: from cloudflare.com (79.191.179.97.ipv4.supernova.orange.pl. [79.191.179.97])
        by smtp.gmail.com with ESMTPSA id l3-20020a17090615c300b008566b807d8asm18519099ejd.73.2023.01.23.12.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 12:52:53 -0800 (PST)
References: <20221221-sockopt-port-range-v4-0-d7d2f2561238@cloudflare.com>
 <20221221-sockopt-port-range-v4-1-d7d2f2561238@cloudflare.com>
 <Y87IRq1ITGcWIh3F@unreal>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net-next v4 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Date:   Mon, 23 Jan 2023 21:48:06 +0100
In-reply-to: <Y87IRq1ITGcWIh3F@unreal>
Message-ID: <87sfg1vuqj.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 07:47 PM +02, Leon Romanovsky wrote:
> On Mon, Jan 23, 2023 at 03:44:39PM +0100, Jakub Sitnicki wrote:
>> Users who want to share a single public IP address for outgoing connections
>> between several hosts traditionally reach for SNAT. However, SNAT requires
>> state keeping on the node(s) performing the NAT.
>> 
>> A stateless alternative exists, where a single IP address used for egress
>> can be shared between several hosts by partitioning the available ephemeral
>> port range. In such a setup:
>> 
>> 1. Each host gets assigned a disjoint range of ephemeral ports.
>> 2. Applications open connections from the host-assigned port range.
>> 3. Return traffic gets routed to the host based on both, the destination IP
>>    and the destination port.
>> 
>> An application which wants to open an outgoing connection (connect) from a
>> given port range today can choose between two solutions:
>> 
>> 1. Manually pick the source port by bind()'ing to it before connect()'ing
>>    the socket.
>> 
>>    This approach has a couple of downsides:
>> 
>>    a) Search for a free port has to be implemented in the user-space. If
>>       the chosen 4-tuple happens to be busy, the application needs to retry
>>       from a different local port number.
>> 
>>       Detecting if 4-tuple is busy can be either easy (TCP) or hard
>>       (UDP). In TCP case, the application simply has to check if connect()
>>       returned an error (EADDRNOTAVAIL). That is assuming that the local
>>       port sharing was enabled (REUSEADDR) by all the sockets.
>> 
>>         # Assume desired local port range is 60_000-60_511
>>         s = socket(AF_INET, SOCK_STREAM)
>>         s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>>         s.bind(("192.0.2.1", 60_000))
>>         s.connect(("1.1.1.1", 53))
>>         # Fails only if 192.0.2.1:60000 -> 1.1.1.1:53 is busy
>>         # Application must retry with another local port
>> 
>>       In case of UDP, the network stack allows binding more than one socket
>>       to the same 4-tuple, when local port sharing is enabled
>>       (REUSEADDR). Hence detecting the conflict is much harder and involves
>>       querying sock_diag and toggling the REUSEADDR flag [1].
>> 
>>    b) For TCP, bind()-ing to a port within the ephemeral port range means
>>       that no connecting sockets, that is those which leave it to the
>>       network stack to find a free local port at connect() time, can use
>>       the this port.
>> 
>>       IOW, the bind hash bucket tb->fastreuse will be 0 or 1, and the port
>>       will be skipped during the free port search at connect() time.
>> 
>> 2. Isolate the app in a dedicated netns and use the use the per-netns
>>    ip_local_port_range sysctl to adjust the ephemeral port range bounds.
>> 
>>    The per-netns setting affects all sockets, so this approach can be used
>>    only if:
>> 
>>    - there is just one egress IP address, or
>>    - the desired egress port range is the same for all egress IP addresses
>>      used by the application.
>> 
>>    For TCP, this approach avoids the downsides of (1). Free port search and
>>    4-tuple conflict detection is done by the network stack:
>> 
>>      system("sysctl -w net.ipv4.ip_local_port_range='60000 60511'")
>> 
>>      s = socket(AF_INET, SOCK_STREAM)
>>      s.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
>>      s.bind(("192.0.2.1", 0))
>>      s.connect(("1.1.1.1", 53))
>>      # Fails if all 4-tuples 192.0.2.1:60000-60511 -> 1.1.1.1:53 are busy
>> 
>>   For UDP this approach has limited applicability. Setting the
>>   IP_BIND_ADDRESS_NO_PORT socket option does not result in local source
>>   port being shared with other connected UDP sockets.
>> 
>>   Hence relying on the network stack to find a free source port, limits the
>>   number of outgoing UDP flows from a single IP address down to the number
>>   of available ephemeral ports.
>> 
>> To put it another way, partitioning the ephemeral port range between hosts
>> using the existing Linux networking API is cumbersome.
>> 
>> To address this use case, add a new socket option at the SOL_IP level,
>> named IP_LOCAL_PORT_RANGE. The new option can be used to clamp down the
>> ephemeral port range for each socket individually.
>> 
>> The option can be used only to narrow down the per-netns local port
>> range. If the per-socket range lies outside of the per-netns range, the
>> latter takes precedence.
>> 
>> UAPI-wise, the low and high range bounds are passed to the kernel as a pair
>> of u16 values in host byte order packed into a u32. This avoids pointer
>> passing.
>> 
>>   PORT_LO = 40_000
>>   PORT_HI = 40_511
>> 
>>   s = socket(AF_INET, SOCK_STREAM)
>>   v = struct.pack("I", PORT_HI << 16 | PORT_LO)
>>   s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
>>   s.bind(("127.0.0.1", 0))
>>   s.getsockname()
>>   # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
>>   # if there is a free port. EADDRINUSE otherwise.
>> 
>> [1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116
>> 
>> v3 -> v4:
>>  * Clarify that u16 values are in host byte order (Neal)
>> 
>> v2 -> v3:
>>  * Make SCTP bind()/bind_add() respect IP_LOCAL_PORT_RANGE option (Eric)
>> 
>> v1 -> v2:
>>  * Fix the corner case when the per-socket range doesn't overlap with the
>>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
>
> Please put changelog after "---" trailer, so it will be stripped while
> applying patch.

I've put the changelog above the "---" on purpose. AFAIK, it is (was?)
preferred by netdev maintainers to keep the changelog in the
description.

Do you know if this convention is now a thing of the past? I might have
missed something.
