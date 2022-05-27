Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E4C535D39
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350564AbiE0JLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344759AbiE0JLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:11:03 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CB31312B1;
        Fri, 27 May 2022 02:07:58 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id i23so4291928ljb.4;
        Fri, 27 May 2022 02:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=QhJy8vAsWRk7rBxT10iDy/5PmoVr3qcRU2Dxdwypg2w=;
        b=BFYKpQ+8HJ031Pci0GGoXTHAK52LstG0U+QTzwaDWYuNKuqt6XQOmyKDhqE4LpIweq
         ddrtnQYze5cmPDF816qSS+xaUlDY24jUhRklTLRJHNb2kludEKx1hdd5wHhWDvb08gKa
         LevUQgwVi8mn9T5XFFOnNVtGY5dWJcNmqREqpjXCUPLR2x7Th55wEZ7xPmUQy6fu7u+S
         Z9eoeDMEgDTOLUUV3N+I0yEY9OH9OxbB4lxErfv89muikeeaq6/+/ETll0ovphhOM4S1
         p1BK0EiffcXwJjrp0h/wVqqXZkykAy0GzEo9y6Ws9EoOijhpHwJauuKDRNeNQL0lCu1j
         qYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QhJy8vAsWRk7rBxT10iDy/5PmoVr3qcRU2Dxdwypg2w=;
        b=Yui6kY0lFPyE6eakMJplHu7mCsciVgebp0xKXqzF1WOcVLYjNFts6/qMgrjoboInee
         zCCh1qJ/Q/YeFQ/SGF71S4Obn0QFIAUq4W42Z7IJ00PC9vV96/tcycFOzRcIKtsfzeCy
         +qDt5mSsEMkRlO/yB3vKR7e52BmSMJ9xPcYYfuajEU2e33nKCitiFNxkir5aq6HEBQgN
         AN6ZJ6Iy18gycIi1l5QCXDtTCUnrNYyGQT2E0M0q2JEyODdjZR7L9iVddN0cEENVKFQf
         RQ/02c2Ifl+OJ3JZgr431sdkxH8nywo6f8D4d9eGvtUc3uSK+NnS6uq7VMdYk4vjm18U
         c/VQ==
X-Gm-Message-State: AOAM532t43qXpmYb1NzB20iQarDeCqzC1TQXXN8HYqy92PfqO+87oKPC
        HRJHRzOQYtWzm07fZQ1D9XoSgnOjCwmwYA==
X-Google-Smtp-Source: ABdhPJz3dOSfuDx2uiYcak6q55G0/yRusHjmQ01zeaTTpiKKJVdkc3yPqv08H48DT8wHs1EdQCIjOg==
X-Received: by 2002:a05:651c:160b:b0:255:3884:7940 with SMTP id f11-20020a05651c160b00b0025538847940mr1469961ljq.379.1653642473217;
        Fri, 27 May 2022 02:07:53 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id b9-20020a056512070900b0047862287498sm783205lfs.208.2022.05.27.02.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 02:07:52 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 4/4] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
In-Reply-To: <Yo+OYN/rjdB7wfQu@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-5-schultz.hans+netdev@gmail.com>
 <Yo+OYN/rjdB7wfQu@shredder>
Date:   Fri, 27 May 2022 11:07:50 +0200
Message-ID: <86pmjz2vix.fsf@gmail.com>
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

On tor, maj 26, 2022 at 17:27, Ido Schimmel <idosch@idosch.org> wrote:
> On Tue, May 24, 2022 at 05:21:44PM +0200, Hans Schultz wrote:
>> Verify that the MAC-Auth mechanism works by adding a FDB entry with the
>> locked flag set. denying access until the FDB entry is replaced with a
>> FDB entry without the locked flag set.
>> 
>> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>> ---
>>  .../net/forwarding/bridge_locked_port.sh      | 42 ++++++++++++++++---
>>  1 file changed, 36 insertions(+), 6 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
>> index 5b02b6b60ce7..50b9048d044a 100755
>> --- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
>> +++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
>> @@ -1,7 +1,7 @@
>>  #!/bin/bash
>>  # SPDX-License-Identifier: GPL-2.0
>>  
>> -ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
>> +ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan locked_port_mab"
>>  NUM_NETIFS=4
>>  CHECK_TC="no"
>>  source lib.sh
>> @@ -94,13 +94,13 @@ locked_port_ipv4()
>>  	ping_do $h1 192.0.2.2
>>  	check_fail $? "Ping worked after locking port, but before adding FDB entry"
>>  
>> -	bridge fdb add `mac_get $h1` dev $swp1 master static
>> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
>>  
>>  	ping_do $h1 192.0.2.2
>>  	check_err $? "Ping did not work after locking port and adding FDB entry"
>>  
>>  	bridge link set dev $swp1 locked off
>> -	bridge fdb del `mac_get $h1` dev $swp1 master static
>> +	bridge fdb del `mac_get $h1` dev $swp1 master
>>  
>>  	ping_do $h1 192.0.2.2
>>  	check_err $? "Ping did not work after unlocking port and removing FDB entry."
>> @@ -124,13 +124,13 @@ locked_port_vlan()
>>  	ping_do $h1.100 198.51.100.2
>>  	check_fail $? "Ping through vlan worked after locking port, but before adding FDB entry"
>>  
>> -	bridge fdb add `mac_get $h1` dev $swp1 vlan 100 master static
>> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
>>  
>>  	ping_do $h1.100 198.51.100.2
>>  	check_err $? "Ping through vlan did not work after locking port and adding FDB entry"
>>  
>>  	bridge link set dev $swp1 locked off
>> -	bridge fdb del `mac_get $h1` dev $swp1 vlan 100 master static
>> +	bridge fdb del `mac_get $h1` dev $swp1 vlan 100 master
>>  
>>  	ping_do $h1.100 198.51.100.2
>>  	check_err $? "Ping through vlan did not work after unlocking port and removing FDB entry"
>> @@ -153,7 +153,8 @@ locked_port_ipv6()
>>  	ping6_do $h1 2001:db8:1::2
>>  	check_fail $? "Ping6 worked after locking port, but before adding FDB entry"
>>  
>> -	bridge fdb add `mac_get $h1` dev $swp1 master static
>> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
>> +
>>  	ping6_do $h1 2001:db8:1::2
>>  	check_err $? "Ping6 did not work after locking port and adding FDB entry"
>>  
>> @@ -166,6 +167,35 @@ locked_port_ipv6()
>>  	log_test "Locked port ipv6"
>>  }
>
> Why did you change s/add/replace/? Also, from the subject and commit
> message I understand the patch is about adding a new test, not changing
> existing ones.
>

Sorry, I might have lost a bit track of the kernel selftests, as for
internal reasons there has been a pause in the work. I will remove the
changes to the previous tests, and I hope it will be fine.

>>  
>> +locked_port_mab()
>> +{
>> +	RET=0
>> +	check_locked_port_support || return 0
>> +
>> +	ping_do $h1 192.0.2.2
>> +	check_err $? "MAB: Ping did not work before locking port"
>> +
>> +	bridge link set dev $swp1 locked on
>> +	bridge link set dev $swp1 learning on
>> +
>> +	bridge fdb del `mac_get $h1` dev $swp1 master
>
> Why the delete is needed? Aren't you getting errors on trying to delete
> a non-existing entry? In previous test cases learning is disabled and it
> seems the FDB entry is cleaned up.
>

I guess you are right.

>> +
>> +	ping_do $h1 192.0.2.2
>> +	check_fail $? "MAB: Ping worked on locked port without FDB entry"
>> +
>> +	bridge fdb show | grep `mac_get $h1` | grep -q "locked"
>> +	check_err $? "MAB: No locked fdb entry after ping on locked port"
>> +
>> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
>> +
>> +	ping_do $h1 192.0.2.2
>> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
>> +
>> +	bridge fdb del `mac_get $h1` dev $swp1 master
>
> bridge link set dev $swp1 learning off
>

noted.

>> +	bridge link set dev $swp1 locked off
>> +
>> +	log_test "Locked port MAB"
>> +}
>>  trap cleanup EXIT
>>  
>>  setup_prepare
>> -- 
>> 2.30.2
>> 
