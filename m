Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012C04C0E62
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 09:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbiBWIld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiBWIlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:41:32 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36CA60D8F;
        Wed, 23 Feb 2022 00:41:04 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id u7so15992165ljk.13;
        Wed, 23 Feb 2022 00:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=9b1HVsojboQfokDHRf6eoAxjmKnPdoUTHloBjMfMN0I=;
        b=n4oeCie4e9JgX4lIDH7g4gOm8UDlE5WbJbUx9faT/ukECA6YIt1okz6ault6htyU7/
         Fwyu9YzXEnfC4XgTyaQs65sWRajFo1uXUwykGQfv6pyNBdr7ydH87wgV4eL23fGL0XrE
         GFhHsAoot134PCxj7R4DK74PdQOSPjCaRd+X/yh4WSjqYkJfuhl+5Q+nvyBg1cRcS06c
         QixHgGRKLlX+6haogzQeSMI4leJsO5mBseEF5sQoALvriD9B5OtYXiQz8p3KB13EUEwe
         d2u7CKDoQoDvvmGfSWhCtLP0CS5BiOnP5lZRtK48ozT9KJttmUqWbqx64bTmHFf1WRoP
         iYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9b1HVsojboQfokDHRf6eoAxjmKnPdoUTHloBjMfMN0I=;
        b=10AyCriS6Fa8WXkBUcHeytzMhp4Qj7eg5N8gVT8r2o94zObUZaXsu0yNPBtaWn2knV
         XSakgIar7m1VA4wmkEcSSD9ZQDc5ghm5Ws7r3iKnaf+E8j4BxFQ3h7MXcznTHEXPtHts
         Cfg04PwH3h3XnPsO00m5CbjanlHKKRvLIhZiU4hZlcG4rTh4gxTcq6AJtk3kGqTaGxT/
         cDIN1Zk/oP+tSx4kONAxXrFTc1elud7IBrNctorhYBIZqVmgH6BS55OWP242bkV7vPV+
         y7AWhRLPnzCt1QUkLpdOG3/d8vpklvzWUBfkeruwgd+BkhR+dvSTsPygL9pUx5tfRNOv
         Qmig==
X-Gm-Message-State: AOAM532MlHg2L6tpchvjjlnCk4NvkqRxNgI7rzuUsCtgwoK+hON+PSVj
        o0aGwlMxhvxOlK5lv5+8ciOOUKjLK3xjuXv8gA8=
X-Google-Smtp-Source: ABdhPJw+wy6hx52xkZV0dN0kRBGYEhCPd2uQDJcmwKeWB5sF5PJ22LcsceCBzFHTV3r3mh2LiIsCAw==
X-Received: by 2002:a2e:91d7:0:b0:245:fce2:4551 with SMTP id u23-20020a2e91d7000000b00245fce24551mr13968389ljg.446.1645605663309;
        Wed, 23 Feb 2022 00:41:03 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id o18sm770984ljp.104.2022.02.23.00.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 00:41:02 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
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
Subject: Re: [PATCH net-next v4 0/5] Add support for locked bridge ports
 (for 802.1X)
In-Reply-To: <20220222111523.030ab13d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
 <20220222111523.030ab13d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 23 Feb 2022 09:40:59 +0100
Message-ID: <86y222vuuc.fsf@gmail.com>
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

On tis, feb 22, 2022 at 11:15, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 22 Feb 2022 14:28:13 +0100 Hans Schultz wrote:
>> This series starts by adding support for SA filtering to the bridge,
>> which is then allowed to be offloaded to switchdev devices. Furthermore
>> an offloading implementation is supplied for the mv88e6xxx driver.
>> 
>> Public Local Area Networks are often deployed such that there is a
>> risk of unauthorized or unattended clients getting access to the LAN.
>> To prevent such access we introduce SA filtering, such that ports
>> designated as secure ports are set in locked mode, so that only
>> authorized source MAC addresses are given access by adding them to
>> the bridges forwarding database. Incoming packets with source MAC
>> addresses that are not in the forwarding database of the bridge are
>> discarded. It is then the task of user space daemons to populate the
>> bridge's forwarding database with static entries of authorized entities.
>> 
>> The most common approach is to use the IEEE 802.1X protocol to take
>> care of the authorization of allowed users to gain access by opening
>> for the source address of the authorized host.
>> 
>> With the current use of the bridge parameter in hostapd, there is
>> a limitation in using this for IEEE 802.1X port authentication. It
>> depends on hostapd attaching the port on which it has a successful
>> authentication to the bridge, but that only allows for a single
>> authentication per port. This patch set allows for the use of
>> IEEE 802.1X port authentication in a more general network context with
>> multiple 802.1X aware hosts behind a single port as depicted, which is
>> a commonly used commercial use-case, as it is only the number of
>> available entries in the forwarding database that limits the number of
>> authenticated clients.
>> 
>>       +--------------------------------+
>>       |                                |
>>       |      Bridge/Authenticator      |
>>       |                                |
>>       +-------------+------------------+
>>        802.1X port  |
>>                     |
>>                     |
>>              +------+-------+
>>              |              |
>>              |  Hub/Switch  |
>>              |              |
>>              +-+----------+-+
>>                |          |
>>             +--+--+    +--+--+
>>             |     |    |     |
>>     Hosts   |  a  |    |  b  |   . . .
>>             |     |    |     |
>>             +-----+    +-----+
>> 
>> The 802.1X standard involves three different components, a Supplicant
>> (Host), an Authenticator (Network Access Point) and an Authentication
>> Server which is typically a Radius server. This patch set thus enables
>> the bridge module together with an authenticator application to serve
>> as an Authenticator on designated ports.
>> 
>> 
>> For the bridge to become an IEEE 802.1X Authenticator, a solution using
>> hostapd with the bridge driver can be found at
>> https://github.com/westermo/hostapd/tree/bridge_driver .
>> 
>> 
>> The relevant components work transparently in relation to if it is the
>> bridge module or the offloaded switchcore case that is in use.
>
> You still haven't answer my question. Is the data plane clear text in
> the deployment you describe?

Sorry, I didn't understand your question in the first instance. So as
802.1X is only about authentication/authorization, the port when opened
for a host is like any other switch port and thus communication is in
the clear.

I have not looked much into macsec (but know ipsec), and that is a
crypto (key) based connection mechanism, but that is a totally different
ballgame, and I think it would for most practical cases require hardware 
encryption.
