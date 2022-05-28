Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03785536B4B
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 08:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbiE1GgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 02:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiE1GgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 02:36:11 -0400
Received: from mail-relay.contabo.net (mail-relay.contabo.net [207.180.195.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBEE15FF5
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 23:36:10 -0700 (PDT)
Received: from pxmg2.contabo.net (localhost.localdomain [127.0.0.1])
        by mail-relay.contabo.net (Proxmox) with ESMTP id AAE29104BA0
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 08:36:08 +0200 (CEST)
Received: from m2731.contaboserver.net (m2731.contabo.net [193.34.145.203])
        by mail-relay.contabo.net (Proxmox) with ESMTPS id 7B190104DC6
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 08:36:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mkio.de;
        s=default; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eJc6rTlCkOpe1x0vMXeWPL0Zz35uG7oFYSiKvjEjHgk=; b=kr0mwdYo2hy1GorRTTtwSflAwG
        brwFje9QD7gEyKQa7NzcyAsbhoKaywEGspqJkkDKP5r/KUiXZ2hTUaWEJTfVv1bl+SU8kB33kjBt5
        dMJeE+GJAo4MZlHA0tMFdYC1s6znh96fvc4RNmJCGRSOY3fNQ/WZXAN/HzFQb6C4/8Nz2yMNa/LLn
        7L3XguoodzsfsS5WQmmuIA2v2E+cnz0BxbvIkHB5y3/3ITP/3vtE72NFTVN9sc55B9bDCe0MGbikc
        m8Sk/vaMRW+xusF6U3WKDyO6iihpmQwMsKoN1VT6BZA8BLhN9luq96G6UOG/8iRTYcWsWwXEXjKRS
        r6PtnA8Q==;
Received: from [78.43.218.139] (port=44768 helo=localhost)
        by m2731.contaboserver.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <mk@mkio.de>)
        id 1nuq3S-009Bsm-WA;
        Sat, 28 May 2022 08:36:07 +0200
Date:   Sat, 28 May 2022 08:35:56 +0200
From:   Markus Klotzbuecher <mk@mkio.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: cpsw_switch: unable to selectively forward multicast
Message-ID: <YpHCzCTAx5sBCyDi@e495>
References: <Yo33QJ1FXGBv2gHZ@e495>
 <Yo6aCiAOwZT6IiPR@lunn.ch>
 <YpBzDaZOzUYG0U/9@e495>
 <YpDS9Vg4Z+sdAfIp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpDS9Vg4Z+sdAfIp@lunn.ch>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - m2731.contaboserver.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mkio.de
X-Get-Message-Sender-Via: m2731.contaboserver.net: authenticated_id: mk@mkio.de
X-Authenticated-Sender: m2731.contaboserver.net: mk@mkio.de
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 03:32:37PM +0200, Andrew Lunn wrote:
>On Fri, May 27, 2022 at 08:43:25AM +0200, Markus Klotzbuecher wrote:
>> Hi Andrew,
>> 
>> thank you for your feedback.
>> 
>> On Wed, May 25, 2022 at 11:05:14PM +0200, Andrew Lunn wrote:
>> >On Wed, May 25, 2022 at 11:30:40AM +0200, Markus Klotzbuecher wrote:
>> >> Hi All,
>> >> 
>> >> I'm using multiple am335x based devices connected in a daisy chain
>> >> using cpsw_new in switch mode:
>> >> 
>> >>              /-br0-\          /-br0-\         /-br0-\
>> >>             |       |        |       |       |       |
>> >>         ---swp0    swp1-----swp0    swp1----swp0    swp1
>> >>             |       |        |       |       |       |
>> >>              \-----/          \-----/         \-----/
>> >>                #1               #2              #3
>> >> 
>> >> The bridge is configured as described in cpsw_switchdev.rst
>> >> [1]. Regular unicast traffic works fine, however I am unable to get
>> >> traffic to multicast groups to be forwarded in both directions via the
>> >> switches.
>> >
>> >Do you have listens reporting they are interested in the traffic via
>> >IGMP? Do you have an IGMP quirer in your network? Without these, IGMP
>> >snooping will not work.
>> 
>> The userspace application running on each device in the chain calls
>> setsockopt + IP_ADD_MEMBERSHIP and peer devices receive IGMP packets
>> such as
>> 
>>  7 10.399981403 192.168.178.51 ? 224.0.0.22   IGMPv3 62 Membership Report / Join group 239.253.253.239 for any sources
>>  8 10.399981403 192.168.178.51 ? 224.0.0.22   IGMPv3 56 Membership Report / Join group 239.253.253.239 for any sources
>> 
>> and corresponding bridge mdb records appear for swpX and br0
>> subsequently. Shouldn't this suffice for multicast to work or do I
>> really need an additional IGMP querier? I realize that these mdb
>> entries will expire, however multicast traffic isn't forwarded even
>> temporarily and manually adding the same entries as 'permanent' didn't
>> help either.
>
>Hi Markus
>
>You should have a quierer, in order to have reliable IGMP
>snooping. However, that is a secondary issues, since it should work
>with permanent mdb entries.

Ok, good to know, thank you!

>Unfortunately, i don't know the cpsw driver, so you need the TI guys
>to help you.

Markus


