Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE684C0DEB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 08:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbiBWIAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiBWIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:00:11 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943627804A;
        Tue, 22 Feb 2022 23:59:42 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id bn33so23368603ljb.6;
        Tue, 22 Feb 2022 23:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Ubrw+ZDagpKqchc9nEqG4/IhR0XOEwvwWfaGS8w0bPI=;
        b=NsUjsj9C9+wZTdQqvrfMMvSP9T3mo7HyPzUPj7Pc14q7FQi0XIR49ZZAkRFHroK/c8
         SkbI3OuUO95RJMaffYEbNdAEZQ1c01WHvidP+7cAomt8PYshgHzZTRnrjxHSBHlff9wu
         LLl0z1uV42OD0u9cRA2u5usRnnZ6cx/JYSFRjqIxIsW8RddRJchhf6bLg4dKyI8bofFI
         CNoEpz+XllQ1Od5nbo82jD0Q38WF3aWCjpEpjly2tw3jcMQkATztiZbn3lx5yRGvt6L2
         i8J+RQpxcU/8YjfYRvWcMjmmiYWr+ePYD7Xu1zwi9JZk7F8+yiLaCOVDA5kNujb4I9p+
         THnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ubrw+ZDagpKqchc9nEqG4/IhR0XOEwvwWfaGS8w0bPI=;
        b=xrx5TEC2fOfoCILiX8hqpDUFzY6bL4tpITbxvUUdyVO5FrBj3kT3Q1DqidPoKBIogw
         IMmttzRLYuzDnkNPBbsUspy3a9KeifDnxueFm975qLMfsn9v0DUe+lUX+c4/H8azNREe
         isL0CHzo00ObDAVIRhL37O/B4m7Dv0OvoWOIyPVVjYtYZYOPKGlm91VJtL8atPCgnl6u
         91PazAq3OkTXVDrZ0Yre3F/ZD+1m2c00WWpzrAXWAGedVGUXTcx8ntI6m3fEnDrUpfKO
         vEZGoyGmoglzzFfoF7BjEOx8JN9Gx327LQJCQWMK7U4blRTJ0qQI6Pdw0MJLwTbALKEA
         TU2Q==
X-Gm-Message-State: AOAM531Slk7P5BevPbff0u4uisRMOUld/7q9sMXdRyfROG/mfWKN0d20
        bjhQK/kTaCzcpXXIHzb6nUY0dB6gVfEKEEc7+eo=
X-Google-Smtp-Source: ABdhPJyXRP4VOqNt80QMu1PrIa8l/0eknyoXn+CWjrbe3izSD4hCTEurZbgz2rhVvmwQvgYfP8Igaw==
X-Received: by 2002:a2e:8955:0:b0:246:133b:673c with SMTP id b21-20020a2e8955000000b00246133b673cmr20040110ljk.380.1645603180752;
        Tue, 22 Feb 2022 23:59:40 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k21sm2015561ljc.129.2022.02.22.23.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 23:59:40 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v4 5/5] selftests: forwarding: tests of locked
 port feature
In-Reply-To: <YhUWvhkhRVY+/Osd@shredder>
References: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
 <20220222132818.1180786-6-schultz.hans+netdev@gmail.com>
 <YhUWvhkhRVY+/Osd@shredder>
Date:   Wed, 23 Feb 2022 08:59:37 +0100
Message-ID: <861qzuxbbq.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tis, feb 22, 2022 at 19:00, Ido Schimmel <idosch@idosch.org> wrote:
> On Tue, Feb 22, 2022 at 02:28:18PM +0100, Hans Schultz wrote:
>> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
>> new file mode 100755
>> index 000000000000..a8800e531d07
>> --- /dev/null
>> +++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
>> @@ -0,0 +1,180 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
>> +NUM_NETIFS=4
>> +CHECK_TC="no"
>> +source lib.sh
>> +
>> +h1_create()
>> +{
>> +	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
>> +	vrf_create "vrf-vlan-h1"
>> +	ip link set dev vrf-vlan-h1 up
>> +	vlan_create $h1 100 vrf-vlan-h1 198.51.100.1/24 ::ffff:c633:6401/64
>
> Hi,
>
> Why did you change it from 2001:db8:3::1/64 to ::ffff:c633:6401/64? It
> was actually OK the first time...

I used an online converter (https://iplocation.io/ipv4-to-ipv6) to
convert 198.51.100.1 into an 'equivalent' ipv6 address even though I
know they are of different spaces.

>
> Anyway, looking at locked_port_vlan() I see that you are only testing
> IPv4 so you can just drop this address:
>
> vlan_create $h1 100 vrf-vlan-h1 198.51.100.1/24
>
> Same for $h2
>
> LGTM otherwise. Feel free to add my tag to the next version
>
>
>> +}
