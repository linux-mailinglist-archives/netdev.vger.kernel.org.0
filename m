Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF824D3D35
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiCIWmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiCIWmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:42:37 -0500
X-Greylist: delayed 592 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 14:41:38 PST
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80993122216
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:41:38 -0800 (PST)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E4EA0241DBF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 22:31:46 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.178])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6CBB3A0073;
        Wed,  9 Mar 2022 22:31:45 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2FD2DB00087;
        Wed,  9 Mar 2022 22:31:45 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A880913C2B0;
        Wed,  9 Mar 2022 14:31:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A880913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1646865104;
        bh=H8OnCADPdI063oHQz4NML5NvEHcESHDXM9mqxM4BpDk=;
        h=From:Subject:To:Cc:Date:From;
        b=FEU6mT1/jIytkUvYKP+xY0O/DQ19MWZPLhHb6Q48XPEBANqAf7To8OcMSTR5zS9RF
         3LGelHBBDq8tQyQWWuxvMZKJ1iQEp9r3IaBaS6bKFntqCiv6W5pJudOaSGJ9/xB/IV
         GUP9bw18GO3ySFzuu2Ne4/ILYNZaVNyIJs735GM0=
From:   Ben Greear <greearb@candelatech.com>
Subject: vrf and multicast problem
To:     netdev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>
Organization: Candela Technologies
Message-ID: <1e7b1aec-401d-9e70-564a-4ce96e11e1be@candelatech.com>
Date:   Wed, 9 Mar 2022 14:31:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1646865105-FRPM6SBB7ubS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[resend, sorry...sent to wrong mailing list the first time]

Hello,

We recently found a somewhat weird problem, and before I go digging into
the kernel source, I wanted to see if someone had an answer already...

I am binding (SO_BINDTODEVICE) a socket to an Ethernet port that is in a VRF with a second
interface.  When I try to send mcast traffic out that eth port, nothing is
seen on the wire.

But, if I set up a similar situation with a single network port in
a vrf and send multicast, then it does appear to work as I expected.

I am not actually trying to do any mcast routing here, I simply want to send
out mcast frames from a port that resides inside a vrf.

Any idea what might be the issue?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

