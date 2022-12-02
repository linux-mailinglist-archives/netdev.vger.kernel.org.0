Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD9640977
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiLBPdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiLBPdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:33:00 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B1332B82
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 07:32:59 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id b2so3256397iof.12
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 07:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DMazUwGeXC3k3VrQL0sR/hr+FNzTpmCMzMV5BNmUUyE=;
        b=CD1SIj94Z26Visw9nu73ao2601cqsvVbusMcW/352UNp6MtrNXQ5spiaxV+sxGASJO
         tUgwWijOe2sfPbPzy5h2xY4ttMkxPEtN4lHQmmhoQMIoRAGPZjT8cLrnYDV6kFVJahUg
         7AhoQG6ku7jP9pb7qBnqBDHudNuBC9NWsTpgk1I3Yns6pgIklZT2maTLOhlGJsHBKijx
         wQgHDZ0o/I3oswsI1HWhy1o2QPoN4wiHO+e8mOrJraNOYwU/n6IYhMeoY4lDxf4Zuch1
         0BHG73x8e7MTLdb+3UBdUPa52ZI7grlviux5/tKlTs0P0huaLkKC7BIdCXhB6E1qEAQe
         wIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DMazUwGeXC3k3VrQL0sR/hr+FNzTpmCMzMV5BNmUUyE=;
        b=3BnP4ViqbV/z+SXsNDphoSc+9pS6T6bDAGMHl/ht/q35rerk4hSlA6mjqkC8DI+xEu
         063AHkcJuiDdj8ANVSHVCHu21XMDik2zdub6ZOv0L1JqEDfQ1ePK6NBhKk2D23P4IBUR
         JH30r4kjH8OWTdZsIZ1P343dzxe09/DH8++SljOJFQIRERPoOOTHyObjdbm5zOEH6AsN
         6aAw2qVxFeZgfYRzHYfKQfbu7K9b9j7N4tHJTEhZqj7XihN1Fbgnskmqu7heQBQ8/7CG
         c3GwFPJiWJPzhMsKr7NMyFsJ7/JYuJWYwYPR1pGbMr/+MmuTU48zYKupXEqG8oUmLly8
         glFA==
X-Gm-Message-State: ANoB5pmWyqfB8bbWcz+rLHGgKjATAhSwa7S3ap4G+8VS7IBtLPOUoZK6
        b1qewxiEZFp9g2QlbLn5gg04OvdjCMc98Q==
X-Google-Smtp-Source: AA0mqf5t4ZlRhWeHPnv7dzNdNmHGofJLza5CMTcDEnz0RMK6yx7ro5ifgAegc/wC9rz55hsixbWDiQ==
X-Received: by 2002:a6b:e00a:0:b0:6df:d2f3:71f8 with SMTP id z10-20020a6be00a000000b006dfd2f371f8mr5066343iog.131.1669995179154;
        Fri, 02 Dec 2022 07:32:59 -0800 (PST)
Received: from ?IPV6:2607:fea8:1b9f:f88c::349? ([2607:fea8:1b9f:f88c::349])
        by smtp.gmail.com with ESMTPSA id v12-20020a056638008c00b0036374fc6523sm2829548jao.24.2022.12.02.07.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 07:32:58 -0800 (PST)
Message-ID: <7e15f5c4-a9ea-ce26-12e8-1cd1d356fabd@gmail.com>
Date:   Fri, 2 Dec 2022 10:32:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: Multicast packet reordering
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com>
 <Y4oBxuq2BXDk4lSC@lunn.ch>
From:   Etienne Champetier <champetier.etienne@gmail.com>
In-Reply-To: <Y4oBxuq2BXDk4lSC@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 02/12/2022 à 08:46, Andrew Lunn a écrit :
> On Thu, Dec 01, 2022 at 11:45:53PM -0500, Etienne Champetier wrote:
>> Hello all,
>>
>> I'm investigating random multicast packet reordering between 2 containers
>> even under moderate traffic (16 video multicast, ~80mbps total) on Alma 8.
> Have you tried plain unicast UDP?

Just did on Fedora 37, and same results, if I don't enable RPS I get a bit of reordering from time to time
for i in {1..10}; do
   iperf -s -u --port $((5000+i)) -i 1 &
done
iperf -c 127.0.0.1 -u -i 1 -b 2G -l 1316 -P 10 --incr-dstport -t0

> There is nothing in the UDP standard which says UDP has to arrive in
> order. Your application needs to handle reordering. So your time might
> be better spent optimizing your application for when it happens.

I a big believer in fixing where things are broken, but it's not always the easiest path (or even possible).

I'm in the video industry and working on an "appliance" that host multiple applications each as separate containers.
Some applications are from our R&D, some from third party. The default protocol that everyone supports
to pass video around is MPEG TS over udp multicast, and this requires reliable network (no drops/no reordering).
A good number of those application supports RTP, which has a reorder buffer and optionally FEC,
but sadly not all, and having third party implement new features can take years.

When running all applications on separate separate servers reordering has never been an issue,
ie physical NIC and switch do a better job at keeping packets in order than virtual interface it seems.

I understand if we trade off non strict ordering for performance, but is it the case ?
I'm fine enabling RPS and calling it a day, I was mostly looking for comments if it's expected Linux behavior.

Etienne

> 	Andrew
