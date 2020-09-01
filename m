Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DD42591F7
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgIAO57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgIAO54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:57:56 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C6EC061244;
        Tue,  1 Sep 2020 07:57:56 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w20so1566379iom.1;
        Tue, 01 Sep 2020 07:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yRdwCQYWLWUYD6ZttodlfuSxdtjBUQxn+XNGerSDtP8=;
        b=EtaFk03tzFwc5tMH+rsxUSik8g5VJPPMvtx7M/eykf/pdLY84+Saka4JNpUYX9rEd7
         Q5LAlX/krsv7FtUzuQB6zcJyGR8HeC10zgYf80u762uJ2yDTmoV9SVvy1F3HShRYJ6yI
         akO9VdSeu+H6SkRmw0bPOoNuCRmagy+KkAX2ba/EcIIiify1pZfjY4HjMClyKRZ521FP
         Rp96phfXdtEnDyfl0anZeHOyft166Eu+XarYvgsxxCLkhtHUjG7tje//NFOGEtHFfa6a
         lgklnX6QB9+fyJnjD/CLQbNIPfrA9TfTybR6mIJMx6gREgzej+ZQ6JwkZtf1eMe+5use
         NFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yRdwCQYWLWUYD6ZttodlfuSxdtjBUQxn+XNGerSDtP8=;
        b=h1Mb/HPvCuYKDpCjG4RfMsDLOYc57AwBswCgjdLwjzf9nLDmwKsRsus31DjKOhNQZq
         lAk1b/sLMe82UiIKg3O3IOApPmH7RKGS5BTvaqZKzKvsia7AInEVQbGAZHPFr5Sbaxj2
         UwC6qSGWEXkVj75BCzfWUaAp2B0zkTlF/Zbp2exlKhYyWCqy/1N+z7Wgk1GpvRFWK7SH
         CPURVTcWvPx/a5uJrD9QNy8gK5LujytplfxYMHH4JYNAirzkx+/QPwzR2yvqJJO8m5Hh
         kT1dE06g+/3lvQFxF92Txz1VrC9hOW2BsyZiGUbvCQ82PYGzCM2mZNUBUmWpZK70yqI3
         X0sQ==
X-Gm-Message-State: AOAM530rNSsidg5vbA8zwKf9l33jbHZe2ulVqYLhK6IyQHewj6cein2w
        ua8F4PcR0xXqNaIGbkYO7Nk=
X-Google-Smtp-Source: ABdhPJz5bVWB/XcnZwbiI+pPNVRovMYhKxzkM0mN3BvGS5MXTNMu9yOT9AnUL2uMpI21paadlqf3kg==
X-Received: by 2002:a05:6602:1589:: with SMTP id e9mr1746626iow.85.1598972275182;
        Tue, 01 Sep 2020 07:57:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:883e:eb9e:60a1:7cfb])
        by smtp.googlemail.com with ESMTPSA id u25sm633459iob.51.2020.09.01.07.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 07:57:54 -0700 (PDT)
Subject: Re: [PATCH] net: ipv6: fix __rt6_purge_dflt_routers when forwarding
 is not set on all ifaces
To:     Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>
References: <20200901065758.1141786-1-brianvv@google.com>
 <CANn89iKA5Ut4AcZfsZi3bVpE33_pqgO=E1RhBzePUeBDn6gznQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52832405-fa37-38fb-b8fb-d7bd7a0d1d52@gmail.com>
Date:   Tue, 1 Sep 2020 08:57:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKA5Ut4AcZfsZi3bVpE33_pqgO=E1RhBzePUeBDn6gznQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 1:56 AM, Eric Dumazet wrote:
> On Tue, Sep 1, 2020 at 8:58 AM Brian Vazquez <brianvv@google.com> wrote:
>>
>> The problem is exposed when the system has multiple ifaces and
>> forwarding is enabled on a subset of them, __rt6_purge_dflt_routers will
>> clean the default route on all the ifaces which is not desired.
>>
>> This patches fixes that by cleaning only the routes where the iface has
>> forwarding enabled.
>>
>> Fixes: 830218c1add1 ("net: ipv6: Fix processing of RAs in presence of VRF")

are you sure that is a Fixes tag for this problem? looking at that
change it only handles RA for tables beyond the main table; it does not
change the logic of how many or which routes are purged.



