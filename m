Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3DB4DDD36
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiCRPqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiCRPqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:46:51 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B8EDBD2D;
        Fri, 18 Mar 2022 08:45:29 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id e16so536702lfc.13;
        Fri, 18 Mar 2022 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=w9yc5QCXnoNRlnxAIpP6dQxCkCMVrsMOMCyEys6TQis=;
        b=T2qHWC580J0XVLFbwGxYKtYvqDl7Fg+++QEHEAJ08FnAgvnWRvbH9tCpVG3QOVmLk/
         yFwG/XGkPnhcxMaWLjTEA7ICqKHju9w1x216TK4uT0H2Zpc1+UAB6COEozAQXivxEcxW
         Qx26zGBeD0BWVZEBFDjQLntzuP0Tjjapln8HbiI6GQU9dAzYuQFfJu8dpZsUpXrke9KA
         lvX9Rt4KwKGT7dklcPUwVMztOoljO/CQUhdsTPgevwTyVYYk1K9843AujWQBFlfTo7jq
         g+X3Kg8zWYBkd8uAub/wUAy6WTeQk7NNUC6FsdmCXyCKLLSJVgVT93v3RMe20R1Mcsla
         IEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=w9yc5QCXnoNRlnxAIpP6dQxCkCMVrsMOMCyEys6TQis=;
        b=RjIz3QBJNx85diBsiypj0qnbnX91p4TKyajeGrA4Cw6PWTj/KVjApyt8PhWOXnACub
         TSF5qrIUU1sRpWbADyOk8o6lq2GRYAcQvywfcESxO0ZxTVAPjaPEeqGeayk2A3x3LPMI
         OnUi1XwKMo7KahvjbXkQltLXSesq56slCkSffl/SdDs+nm+4UGRPHrj5OQn5hvIKHDN+
         JhUxjC6kqiUOGMIIIjji/SeC+WFJbEpJw0Mim+fzqRBVIMpSn7FSwfeOSk3K3nd44Hs+
         RbyEptb4YFTTdc06puI1TqFufccDuf/DmWX0iMkE0n2JVhiRPFceZlH9lrhtD44DlY7t
         gpZA==
X-Gm-Message-State: AOAM532c3fYyRiGNQpJ5IK+9SQjg7iSpcKc6/67xv6k69AbEqhUEYliq
        QSGJYxL54H2LhmlHROH96aZvTIu/2b9anw==
X-Google-Smtp-Source: ABdhPJxF2o8DhY6wJ2+kUMh9mDmviFUNVcIg4BQrGQ/w5QcqsP4a5IOaIfUpvUKf1rVSyZoGXmXrFA==
X-Received: by 2002:a05:6512:b03:b0:448:1e7c:8859 with SMTP id w3-20020a0565120b0300b004481e7c8859mr6505378lfu.110.1647618327540;
        Fri, 18 Mar 2022 08:45:27 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id u2-20020a2e9f02000000b00244c5e20ee9sm1028484ljk.23.2022.03.18.08.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 08:45:27 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/4] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
In-Reply-To: <YjNMS6aFG+93ejj5@shredder>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-5-schultz.hans+netdev@gmail.com>
 <YjNMS6aFG+93ejj5@shredder>
Date:   Fri, 18 Mar 2022 16:45:24 +0100
Message-ID: <86mthnw9gr.fsf@gmail.com>
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

On tor, mar 17, 2022 at 16:57, Ido Schimmel <idosch@idosch.org> wrote:
> On Thu, Mar 17, 2022 at 10:39:02AM +0100, Hans Schultz wrote:
>> Verify that the MAC-Auth mechanism works by adding a FDB entry with the
>> locked flag set. denying access until the FDB entry is replaced with a
>> FDB entry without the locked flag set.
>> 
>> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>> ---
>>  .../net/forwarding/bridge_locked_port.sh      | 29 ++++++++++++++++++-
>>  1 file changed, 28 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
>> index 6e98efa6d371..2f9519e814b6 100755
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
>> @@ -170,6 +170,33 @@ locked_port_ipv6()
>>  	log_test "Locked port ipv6"
>>  }
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
>> +	ping_do $h1 192.0.2.2
>> +	check_fail $? "MAB: Ping worked on port just locked"
>> +
>> +	if ! bridge fdb show | grep `mac_get $h1` | grep -q "locked"; then
>> +		RET=1
>> +		retmsg="MAB: No locked fdb entry after ping on locked port"
>> +	fi
>
> bridge fdb show | grep `mac_get $h1 | grep -q "locked"
> check_err $? "MAB: No locked fdb entry after ping on locked port"
>
>> +
>> +	bridge fdb del `mac_get $h1` dev $swp1 master
>> +	bridge fdb add `mac_get $h1` dev $swp1 master static
>
> bridge fdb replace `mac_get $h1` dev $swp1 master static
>
Unfortunately for some reason 'replace' does not work in several of the
tests, while when replaced with 'del+add', they work.

>> +
>> +	ping_do $h1 192.0.2.2
>> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
>> +
>> +	log_test "Locked port MAB"
>
> Clean up after the test to revert to initial state:
>
> bridge fdb del `mac_get $h1` dev $swp1 master
> bridge link set dev $swp1 locked off
>
>
>> +}
>>  trap cleanup EXIT
>>  
>>  setup_prepare
>> -- 
>> 2.30.2
>> 
