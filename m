Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A2E69974D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjBPOYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjBPOYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:24:54 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524B12110
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:24:22 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 0985db29;
        Thu, 16 Feb 2023 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=default;
         bh=67NCvAwUmG6L6k4BRKVLVvglRWo=; b=Lp2gN/OrlU9AY4TNfOK2h479R1/y
        HHmsM0k5yW9piunC91iP3UYfeTFKB+wWpv5TFQGdeCchSTUtYVr+dwNAl/rBBBI+
        pDASpCoKLmW7zKoZEbb3koUAV2U8EtBX+AQwDHTlluXaSoZhAUNs/2EFu5khH3if
        jbEwIzPQ9SB5aO8=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; q=dns; s=
        default; b=IRXG8HqOuQmWrLjdq+W58iSXg+3+Ib41TfBkrvkcj6hQbYNWYLGTb
        T3Dd0flBDtNGu96bhxIBKlbCrp+eE3CWnyDQTZ8gkKhsQxmyda5EZnznwOmkt8H1
        gUtn9ZGiqNhoox3D/l0O3HRidVXGDglHt2KQqigg6cO4yRdYKCNGdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1676557459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSXJ24c6d3cpALGUKtMlC3OrveUj/2j3wnSeu/IqyI0=;
        b=IH6FwKt2nvROOfnW4vvgRsyLwJLlJPr/fHWL8I49My+8mmYrc+g6x6RsY9I6Fv0Z3DZ0e8
        fe6ACgkCsjjopdg3fYC90qTySsvXTDonvCWSocPLb5uwsdDYud92PxZeJP5MEUwgedbTA/
        5H+FzuERhb6ln4g1TPnif6uSWMwHFTs=
Received: from [192.168.0.2] (host-87-15-216-95.retail.telecomitalia.it [87.15.216.95])
        by ziongate (OpenSMTPD) with ESMTPSA id cd88eb43 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 16 Feb 2023 14:24:19 +0000 (UTC)
Message-ID: <9f12a869-04b0-60a3-c773-082b80d5df35@kernel-space.org>
Date:   Thu, 16 Feb 2023 15:24:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: mv88e6321, dual cpu port
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <20230110222246.iy7m7f36iqrmiyqw@skbuf> <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf> <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
 <20230216125040.76ynskyrpvjz34op@skbuf>
From:   Angelo Dureghello <angelo@kernel-space.org>
In-Reply-To: <20230216125040.76ynskyrpvjz34op@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Vladimir,

thanks, it works.

Attaching the final script (dts as avobe) if you want to
double check, and in case of any interest.

On 16/02/23 1:50 PM, Vladimir Oltean wrote:
 > On Thu, Feb 16, 2023 at 12:20:24PM +0100, Angelo Dureghello wrote:
 >> Still data passes all trough port6, even when i ping from
 >> host PC to port4. I was expecting instead to see port5
 >> statistics increasing.
 >
 >> # configure the bridge
 >> ip addr add 192.0.2.1/25 dev br0
 >> ip addr add 192.0.2.129/25 dev br1
 >
 > In this configuration you're supposed to put an IP address on the fec2
 > interface (eth1), not on br1.
 >
 > br1 will handle offloaded forwarding between port5 and the external
 > ports (port3, port4). It doesn't need an IP address. In fact, if you
 > give it an IP address, you will make the sent packets go through the br1
 > interface, which does dev_queue_xmit() to the bridge ports (port3, port4,
 > port5), ports which are DSA, so they do dev_queue_xmit() through their
 > DSA master - eth0. So the system behaves as instructed.
#!/bin/sh
#
# Configuration:
#                                       +---- port0
#              br0 eth0  <->   port 6  -+---- port1
#                                       +---- port2
#
#                                       +---- port3
#              br1 eth1  <-> --------- -+-----port4
#                                       +---- port5
#
# tested, port4 ping, data passes always from port 6
#

ip link set eth0 up
ip link set eth1 up

# bring up the slave interfaces
ip link set port0 up
ip link set port1 up
ip link set port2 up
ip link set port3 up
ip link set port4 up
ip link set port5 up

# create bridge
ip link add name br0 type bridge
ip link add name br1 type bridge

# add ports to bridge
ip link set dev port0 master br0
ip link set dev port1 master br0
ip link set dev port2 master br0

ip link set dev port3 master br1
ip link set dev port4 master br1
ip link set dev port5 master br1

# configure the bridge
ip addr add 192.0.2.1/25 dev br0
ip addr add 192.0.2.129/25 dev eth1

# bring up the bridge
ip link set dev br0 up
ip link set dev br1 up

Many thanks !
-- 
Angelo Dureghello


