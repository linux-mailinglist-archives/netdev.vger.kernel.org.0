Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0771675CF
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbgBUIbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:31:22 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34657 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgBUIbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 03:31:21 -0500
Received: by mail-lj1-f196.google.com with SMTP id x7so1327372ljc.1
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 00:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FFQje1M1A7U1I64GsMso5PY+ZAZ2Zo81JUXOG0rTgLI=;
        b=g+T8ocO1DQVNdW1OO6QR8D67rH6yki1sgPU+6PQVtUP8cU22O4usG9Jn8r9idkxNXi
         3M5C9oWtGtKkNivZBCWSt7QzJUzPEWJ9S6NZMuoGGpYdyokV5VaZfJ80M9ebg0vLmDUK
         Tsqs6+/7GducYR8VCa6c1L6WIleBzsdb4Rnyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FFQje1M1A7U1I64GsMso5PY+ZAZ2Zo81JUXOG0rTgLI=;
        b=aLbI4ljtSIwOGwCc0LRekM0h1K9CFcpgH7A4PKLVVt5u2voqEp+pw+iRV1HewttqJU
         Xjf6LcuaDGVflU2szRK42xgI03IaCCJiiF8LhCPB0tAM19ZkPB4nFfK4CqpoAH2AAPwL
         s21xevjZ1Z1t+a/HPvdriu2ydGfbq941yr4aMJqrt8EfV7jJKdZSoj9qIf73OM2ptun6
         JlTempThe2NmAN1WjhKOMLxblkG2L+VtczeBrbBfB/hlmjKlqYSyUsuQA0zAMEzI25rU
         gGrQwzYfHa5LecqKrs/kKNlboB0K4lsbrfaz5i8yySOOc+bIYGZiWr6/Ub87+pr3XRrp
         xeXQ==
X-Gm-Message-State: APjAAAU6rfFTLyl3KeDOpV+9KTU9Dpjn1pU7qkRvlkszmfXIkeW6IOFG
        1nA2B0/btdL5nWnjAuRfbe17Hw==
X-Google-Smtp-Source: APXvYqxiFW9ZBPNa3PK3tbw4I38N8AKPpIyl8nzWl3mi1oCo1HTpeppOmYg6mC75upAYsRN1ruiwBA==
X-Received: by 2002:a2e:93c9:: with SMTP id p9mr20786031ljh.136.1582273879131;
        Fri, 21 Feb 2020 00:31:19 -0800 (PST)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m3sm1196972lfl.97.2020.02.21.00.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 00:31:18 -0800 (PST)
Subject: Re: [PATCH net] net: netlink: cap max groups which will be considered
 in netlink_bind()
To:     David Ahern <dsahern@gmail.com>, David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, christophe.leroy@c-s.fr, rgb@redhat.com,
        erhard_f@mailbox.org
References: <20200220144213.860206-1-nikolay@cumulusnetworks.com>
 <20200220.160255.1955114765293599857.davem@davemloft.net>
 <30fda8d9-0020-0fa7-d00d-42acdf44f245@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <509c952b-483f-3a35-6d6b-4655a8b513be@cumulusnetworks.com>
Date:   Fri, 21 Feb 2020 10:31:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <30fda8d9-0020-0fa7-d00d-42acdf44f245@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/02/2020 04:55, David Ahern wrote:
> On 2/20/20 5:02 PM, David Miller wrote:
>>
>>> Dave it is not necessary to queue this fix for stable releases since
>>> NETLINK_ROUTE is the first to reach more groups after I added the vlan
>>> notification changes and I don't think we'll ever backport new groups. :)
>>> Up to you of course.
> 
> RTNLGRP_NEXTHOP was the first to overflow; RTNLGRP_NEXTHOP = 32.
> 
> Apparently my comment about overflowing the groups was only in the
> iproute2 commit (e7cd93e7afe1a0407ccb94b9124bbd56b87b8660)
> 

While that is true, RTNLGRP_MAX == (__RTNLGRP_MAX - 1) == RTNLGRP_NEXTHOP == 32
which is fine. You just can't bind to the group via netlink_bind() but the loop
is capped at 32 again and the test_bit() shouldn't access anything beyond because
it's a strict less than.
