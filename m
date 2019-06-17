Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4008549520
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfFQWY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:24:26 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39783 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfFQWYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:24:25 -0400
Received: by mail-io1-f65.google.com with SMTP id r185so19079731iod.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S1aAdGqQIsqZs6vrnw34A3XRhoax+juyZW8Op02FC3o=;
        b=QSbWsdRbcVVe0icF5omLUyFIep5IQ8OiWNpaXK/yma614vqWx8TQIxoefe5T0I05ig
         UNOaqab/xqGkLcn0wRwILe8PG+6Z90wlLovuvusO/RpdPfjXlIUs7vETX8GQGvKZJxtM
         htiRPUkXS7brA/gM1M844E45T2wRGRjYgGqmW1MfnRiEG38sbW+nnrjmxdlvd/6h7wE6
         SYZqMhwPJ2625O2qFt148kSU6BID1ea5w4LYLW+XKBKooJfvj1xeCBwW8J4CyjJVQEld
         3/tG0sgBJFzAUEFyb7g25DmtcGT68oUMduTFk6+nejouGj34yc6xzgQudT1D8rrx7yyI
         M0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S1aAdGqQIsqZs6vrnw34A3XRhoax+juyZW8Op02FC3o=;
        b=RCmTbXWbsAfydHy9el5LRkPMsd+5i6MpjLLloiAxA/BX8lHacNfYjQ17ScbMQNLgAt
         pf02vJfuUcAu2beQeXuDFFg6L/VBcokszn+7GcvgJ19i3zchdefLzwjpms+BgZe2oJUm
         Gkqo62OVvJM+n6BUxDsU2eDl5mZFTm3MSEzB2Tz5UC/Mtyf6buKSM2Yrz71Lx72arTM/
         Iyt+MxoF0N5Ghnp9+l41zoEfrQr2P8nwjQFTB//8IXTiolFyT70LRYSlraBMR+mowE2K
         5jdC0Dp7tORJY834A2EFvUv2m32QFtZu1ejCgtk40iLR5L1rRB+atIPsw99vQGUNd/yC
         pGcg==
X-Gm-Message-State: APjAAAWPOv+L4EFkf3YsMz6FPaPwgkN67UynO0NZEEl9X3lMTvm2K4a4
        +UcdDzSE/NY765DLgyBRMvI=
X-Google-Smtp-Source: APXvYqzdxl6Z9F7xwnimvgBB35XaQ70YOWAM0GT1ZjwzP2204BYVyGLofA1YmObSjxu+b0vWwpUdsQ==
X-Received: by 2002:a6b:7b07:: with SMTP id l7mr14640936iop.225.1560810265097;
        Mon, 17 Jun 2019 15:24:25 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id 20sm13542564iog.62.2019.06.17.15.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 15:24:24 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
References: <20190611161031.12898-1-mcroce@redhat.com>
 <11cdc79f-a8c9-e41f-ac4d-4906b358e845@gmail.com>
 <CAGnkfhwH-4+Ov+QRBZaQaHnnbTczpavuV8_yJBg=GOHSLD0pQw@mail.gmail.com>
 <CAGnkfhz940SbWpKau0j13rzqH7Zw7BKTStuCcSeg9EQBLeaEOg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b4f39729-d208-8a71-6f6d-f05f00b7ec2b@gmail.com>
Date:   Mon, 17 Jun 2019 16:24:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAGnkfhz940SbWpKau0j13rzqH7Zw7BKTStuCcSeg9EQBLeaEOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 4:20 PM, Matteo Croce wrote:
> 
> I looked for every occourrence of netns_switch():
> 
> bridge/bridge.c:                        if (netns_switch(argv[1]))
> include/namespace.h:int netns_switch(char *netns);
> ip/ip.c:                        if (netns_switch(argv[1]))
> ip/ipnetns.c:   if (netns_switch(argv[0]))
> lib/namespace.c:int netns_switch(char *name)
> lib/utils.c:    if (netns_switch(nsname))
> misc/ss.c:                      if (netns_switch(optarg))
> tc/tc.c:                        if (netns_switch(argv[1]))
> 
> the ones in {ss,tc,bridge,ip}.c are obviously handling the '-n netns'
> command line option.
> my question here is: should the VRF association be reset in all these cases?
> If we need to reset, we should really call vrf_reset() from netns_switch().
> If don't, I can add the missing vrf_reset() in ipnetns.c but I'm
> curious to know what can happen to change netns and keep VRF
> associations belonging to another netns.
> 

The VRF reset is needed on a netns exec - ie., running a command in a
network namespace.

Any netns_switch that only involves sending a netlink command in a
different namespace does not need the reset.
