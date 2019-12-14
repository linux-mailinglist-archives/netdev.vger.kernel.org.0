Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B673211F2C0
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 17:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfLNQTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 11:19:12 -0500
Received: from mail.grenz-bonn.de ([178.33.37.38]:34800 "EHLO
        mail.grenz-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfLNQTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 11:19:12 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Dec 2019 11:19:12 EST
Received: from cg-notebook.local (unknown [IPv6:2001:41d0:1:c648:b055:ea5:64df:98e7])
        by ks357529.kimsufi.com (Postfix) with ESMTPSA id 0DF1C6212D
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 17:11:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=grenz-bonn.de;
        s=201905; t=1576339876;
        bh=CUvSEgjhNSvUFgYHjMDohd2C6OISeVevWxWvCAOQqTc=;
        h=From:To:Subject:Date:From;
        b=ceyQfhKyTmF9drpZfss2Sx3FjCvlS8dY0P4NqfHIVj7yZDM6NbiuJ1R+7eOp4vukP
         5/0lEj02nd/gq3/55+qlrdzqNlJ3+6dti/N1T194WyLhFL8TChdkRS094xsTWUCF11
         zYa35S5dfXYo9Ci7KjYcu6yMC38jjEl0N0Zr8mRGTABscWsoRvJuYtOidkTgR8IP/5
         7Y9yJXxDH59skCh8kb25iVKvZu+mdwdam7C9nU8O2sOv+5OeIURgvAGa1EnB241K/s
         53O10tVoZMU1mHUj/d/X8rPlEF0ZbZ9Hhlhil2n4UbeYznVv/mX3qDlmUaU8yiBRWV
         tFAJREF0hyI+A==
From:   Christoph Grenz <christophg+lkml@grenz-bonn.de>
To:     netdev@vger.kernel.org
Subject: IPv6 Destination Options question
Date:   Sat, 14 Dec 2019 17:11:15 +0100
Message-ID: <5975583.vpC7qLWE0j@cg-notebook>
User-Agent: KMail/5.1.3 (Linux/5.4.0cgnotebook; KDE/5.18.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm playing around with Mobile IPv6 and noticed a strange behaviour in the 
Linux network system when using IPv6 destination options:

I'm able to send destination options on SOCK_DGRAM and SOCK_RAW sockets with
sendmsg() and IPV6_DSTOPTS ancillary data. The sent packets also look correct 
in Wireshark.

But I'm not able to receive packets with destination options on a socket with 
the IPV6_RECVDSTOPTS socket option enabled. Both a packet with a Home Address 
Option and a packet with an empty destination options header (only containing 
padding) won't be received on a socket for the payload protocol.

Only a SOCK_RAW socket for IPPROTO_DSTOPTS receives the packet.

I tested this on a vanilla 5.4.0 kernel and got the same behaviour. Activating 
dyndbg for everything in net/ipv6 didn't produce any relevant output in dmesg.

Is this expected behaviour or a bug? Or do I maybe need some other socket 
option or a xfrm policy to receive packets with destination options?

Best regards
Christoph

