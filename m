Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FBE7EB13
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 06:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbfHBEQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 00:16:03 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43569 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731101AbfHBEQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 00:16:03 -0400
Received: by mail-pg1-f195.google.com with SMTP id r22so7773970pgk.10
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 21:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vrw6OYJsWLjp309gunnnPWhv9UhyhI2DiwbJqag314w=;
        b=VxQBTnWHrisKFe5GYMOwsqQm80WhNPPx6ZIvvBL/ND82yftRR0KyUiSbBjzd47AZCH
         HnwbocW1MCwNyCaO41eaxIpenidXWnKykuH8gRHFoB/5foBrQa12ekgEXlOrQ2LeukON
         uXiUgZ0M2XBC13XjjF0zQpiG/6XJQo8V/P6COjSOqzgsGfIKMPFz++0q21Q7qLz6n/LN
         Pmov+7ggLkyUPu5trUx506t3thnb3XYo7cPtfm6GyAcNjTz7E0Nq8bihh+oDuC54WAnJ
         6lCPb5KHX4cyRGJ9Cm/DwTioLNG3g1mAygmz8pOtKGro19o1OwX/P9sAYkFEGf9Xn8Mf
         p5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vrw6OYJsWLjp309gunnnPWhv9UhyhI2DiwbJqag314w=;
        b=f46VrbuacvocGpYb7DMXfK11akFJa+VPb2aIwbjCMZ1U40K09PGIoKczVRUUMZDIxL
         3aWQBSrozNJe4rR6ip5EwtpTfQtWTp5b5bbWaZI5+aNSR17VGXyI6ZK3ggwXbVGklfnj
         5x8VMxy9AQDOYicStoV7T8xZV9wfy6O4je6FU1wQfokcD6arI4y2wg78aKYBvcZFOEOe
         SMKn7HD6Jql1Thk5WR5aL+sujxoP89+frpBX3cs6tyLZJAvAkPTUNalprI18/Xw0+OZ6
         XHVDg8/8TV7c/I3FSPU8C/QZLbllO5wpWK0hNCjFqy8dkMJj/JtPoLxJtZClT1uLwiqw
         gq6Q==
X-Gm-Message-State: APjAAAXcMmGTp7ONqwPgd39hgVaVMp8v9pjYFGjKt6nEpYsHhBPziPal
        DfiujwEkxteaPsEUyBCgPpzUePww
X-Google-Smtp-Source: APXvYqxTTHZe8VAfO6dadr2DteNRaRLJRkCV1PTJnbzYp87jSYT92JAXrev08Aru5/Sb3M6HQBe86w==
X-Received: by 2002:a63:6eca:: with SMTP id j193mr46434720pgc.74.1564719362535;
        Thu, 01 Aug 2019 21:16:02 -0700 (PDT)
Received: from [172.27.227.205] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id i123sm100981500pfe.147.2019.08.01.21.16.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 21:16:01 -0700 (PDT)
Subject: Re: [PATCH net] ipv4/route: do not check saddr dev if iif is
 LOOPBACK_IFINDEX
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190801082900.27216-1-liuhangbin@gmail.com>
 <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
 <20190802041358.GT18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <209d2ebf-aeb1-de08-2343-f478d51b92fa@gmail.com>
Date:   Thu, 1 Aug 2019 22:16:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190802041358.GT18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 10:13 PM, Hangbin Liu wrote:
> On Thu, Aug 01, 2019 at 01:51:25PM -0600, David Ahern wrote:
>> On 8/1/19 2:29 AM, Hangbin Liu wrote:
>>> Jianlin reported a bug that for IPv4, ip route get from src_addr would fail
>>> if src_addr is not an address on local system.
>>>
>>> \# ip route get 1.1.1.1 from 2.2.2.2
>>> RTNETLINK answers: Invalid argument
>>
>> so this is a forwarding lookup in which case iif should be set. Based on
> 
> with out setting iif in userspace, the kernel set iif to lo by default.

right, it presumes locally generated traffic.
> 
>> the above 'route get' inet_rtm_getroute is doing a lookup as if it is
>> locally generated traffic.
> 
> yeah... but what about the IPv6 part. That cause a different behavior in
> userspace.

just one of many, many annoying differences between v4 and v6. We could
try to catalog it.
