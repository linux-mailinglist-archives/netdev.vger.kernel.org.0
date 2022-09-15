Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87A5B9C98
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiIOOJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIOOJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:09:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC549C1C9
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663250949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WnsmCKBZOViaiAYIsu2tkTrtpVAp4dwvNdfKqNOsR44=;
        b=Jmxo6qEKUWvDz6Z6Xp6CB15xVOSIHeEpwtM8Xb40fnVQROYdIcw3yFqNU/uu1R00pSddXS
        0VvoRWLL8DmluMAzetD7OTrRvtvdkuwCrtdgI8XR0bKKSvo3iXjltLamXd2KUrQcix7FCE
        0/t+iDj3/x6MxK4EIlwhjHA66+g6oRI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-sV1PacvrNKCHVbpIraMi1Q-1; Thu, 15 Sep 2022 10:09:07 -0400
X-MC-Unique: sV1PacvrNKCHVbpIraMi1Q-1
Received: by mail-qt1-f200.google.com with SMTP id g21-20020ac87d15000000b0035bb6f08778so9267586qtb.2
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WnsmCKBZOViaiAYIsu2tkTrtpVAp4dwvNdfKqNOsR44=;
        b=w/NW2Fb0+qnPViGyKThP2mbgYSaPnDOdec32+dFhIpxAugBZ8ZrRUfHRD+gyTKmw+I
         3wgf+FmQtUWoNoPRHxI5e37xUkMwVM69p57YOpTJ5qzT1ojSQZMOgrm4IbFFcM6Ot+Q7
         7pwWIkn4MMiChU94duJ9akUvjgAX+KwpB/toHb7vzBCAxYL2lv018scqGALS5JnGFgki
         hgh9GXDaF4ULZQq5rZDVxBeJy6W7ayth8Tsg/NXhFVYOF15rtAglTFvRWkVz5VX6ynsh
         GBkTzNrkR/B/+4eRlUYYC8EiAEu5KVsPsAeBphLNSeqaOybwfEQbiMVOMUtdPUmW7jad
         vdSw==
X-Gm-Message-State: ACgBeo3Vyva0KCpQDxHv2bRae0N1yMq0LSZaoGgR0I1wtVzQogKfmo0+
        BvqwVcZPCoCeRkq1PQTZil8rEViRo9iCKXx3l00hmvHAhsQhdo9m4ybb+f11OjCKUTTXE/uLqK8
        JsQ5gIKs22gbQv3ZS
X-Received: by 2002:a05:6214:ca9:b0:4aa:a2ac:2a8f with SMTP id s9-20020a0562140ca900b004aaa2ac2a8fmr36121724qvs.102.1663250947285;
        Thu, 15 Sep 2022 07:09:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4tMxX4dl1fpz9jTNwrocqpCM7RrfNXiscJv/OlIT9y1FdZuHUCQwBgG5lyarL11fJUf/y9KQ==
X-Received: by 2002:a05:6214:ca9:b0:4aa:a2ac:2a8f with SMTP id s9-20020a0562140ca900b004aaa2ac2a8fmr36121689qvs.102.1663250947033;
        Thu, 15 Sep 2022 07:09:07 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id cc19-20020a05622a411300b0031e9ab4e4cesm460511qtb.26.2022.09.15.07.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 07:09:06 -0700 (PDT)
Message-ID: <970039e7-1c13-e6d7-cb70-53af92eb9958@redhat.com>
Date:   Thu, 15 Sep 2022 10:09:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net] selftests/bonding: add a test for bonding lladdr
 target
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20220915094202.335636-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220915094202.335636-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/22 05:42, Hangbin Liu wrote:
> This is a regression test for commit 592335a4164c ("bonding: accept
> unsolicited NA message") and commit b7f14132bf58 ("bonding: use unspecified
> address if no available link local address"). When the bond interface
> up and no available link local address, unspecified address(::) is used to
> send the NS message. The unsolicited NA message should also be accepted
> for validation.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>

> ---
>   .../selftests/drivers/net/bonding/Makefile    |  1 +
>   .../drivers/net/bonding/bond-lladdr-target.sh | 65 +++++++++++++++++++
>   2 files changed, 66 insertions(+)
>   create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
> 
> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
> index ab6c54b12098..d209f7a98b6c 100644
> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
> @@ -2,5 +2,6 @@
>   # Makefile for net selftests
>   
>   TEST_PROGS := bond-break-lacpdu-tx.sh
> +TEST_PROGS += bond-lladdr-target.sh
>   
>   include ../../../lib.mk
> diff --git a/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh b/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
> new file mode 100755
> index 000000000000..89af402fabbe
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
> @@ -0,0 +1,65 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Regression Test:
> +#   Verify bond interface could up when set IPv6 link local address target.
> +#
> +#  +----------------+
> +#  |      br0       |
> +#  |       |        |    sw
> +#  | veth0   veth1  |
> +#  +---+-------+----+
> +#      |       |
> +#  +---+-------+----+
> +#  | veth0   veth1  |
> +#  |       |        |    host
> +#  |     bond0      |
> +#  +----------------+
> +#
> +# We use veths instead of physical interfaces
> +sw="sw-$(mktemp -u XXXXXX)"
> +host="ns-$(mktemp -u XXXXXX)"
> +
> +cleanup()
> +{
> +	ip netns del $sw
> +	ip netns del $host
> +}
> +
> +trap cleanup 0 1 2
> +
> +ip netns add $sw
> +ip netns add $host
> +
> +ip -n $host link add veth0 type veth peer name veth0 netns $sw
> +ip -n $host link add veth1 type veth peer name veth1 netns $sw
> +
> +ip -n $sw link add br0 type bridge
> +ip -n $sw link set br0 up
> +sw_lladdr=$(ip -n $sw addr show br0 | awk '/fe80/{print $2}' | cut -d'/' -f1)
> +# sleep some time to make sure bridge lladdr pass DAD
> +sleep 2
> +
> +ip -n $host link add bond0 type bond mode 1 ns_ip6_target ${sw_lladdr} \
> +	arp_validate 3 arp_interval 1000
> +# add a lladdr for bond to make sure there is a route to target
> +ip -n $host addr add fe80::beef/64 dev bond0
> +ip -n $host link set bond0 up
> +ip -n $host link set veth0 master bond0
> +ip -n $host link set veth1 master bond0
> +
> +ip -n $sw link set veth0 master br0
> +ip -n $sw link set veth1 master br0
> +ip -n $sw link set veth0 up
> +ip -n $sw link set veth1 up
> +
> +sleep 5
> +
> +rc=0
> +if ip -n $host link show bond0 | grep -q LOWER_UP; then
> +	echo "PASS"
> +else
> +	echo "FAIL"
> +	rc=1
> +fi
> +exit $rc

