Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290F5AF2DE
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 00:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfIJWRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 18:17:54 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:36974 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfIJWRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 18:17:54 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 181CC104B
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 15:17:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 181CC104B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1568153874;
        bh=AzqHe4Zk3hV5iasQ9liR3A9xmq3ifWcsJBFcQOBGHD4=;
        h=To:From:Subject:Date:From;
        b=hWav/RoyGJoNy+Fnp7tC2YMOKU4RsPKc1Qr6qIjGWo8cf8VzJUDGpiW2sqH55J3gq
         r9lgvoiGn5u7/bsG4XGH+iXA3wBDV+XRLbYL31YT43A32IQ3m6beDRNLahgwZKHXyI
         Ppef8XhjcGByUyy+CmYOBpGBi2BpNS/ScqRCFccU=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Strange routing with VRF and 5.2.7+
Organization: Candela Technologies
Message-ID: <91749b17-7800-44c0-d137-5242b8ceb819@candelatech.com>
Date:   Tue, 10 Sep 2019 15:17:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today we were testing creating 200 virtual station vdevs on ath9k, and using
VRF for the routing.

This really slows down the machine in question.

During the minutes that it takes to bring these up and configure them,
we loose network connectivity on the management port.

If I do 'ip route show', it just shows the default route out of eth0, and
the subnet route.  But, if I try to ping the gateway, I get an ICMP error
coming back from the gateway of one of the virtual stations (which should be
safely using VRFs and so not in use when I do a plain 'ping' from the shell).

I tried running tshark on eth0 in the background and running ping, and it captures
no packets leaving eth0.

After some time (and during this time, my various scripts will be (re)configuring
vrfs and stations and related vrf routing tables and such,
but should *not* be messing with the main routing table, then suddenly
things start working again.

I am curious if anyone has seen anything similar or has suggestions for more
ways to debug this.  It seems reproducible, but it is a pain to
debug.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

