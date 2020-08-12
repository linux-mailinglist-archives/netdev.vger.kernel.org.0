Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA15F2422F2
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 02:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgHLAC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 20:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHLACZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 20:02:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD71C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 17:02:25 -0700 (PDT)
Received: from localhost (50-47-103-195.evrt.wa.frontiernet.net [50.47.103.195])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D034211E48246;
        Tue, 11 Aug 2020 16:45:38 -0700 (PDT)
Date:   Tue, 11 Aug 2020 17:02:23 -0700 (PDT)
Message-Id: <20200811.170223.1397578654908672695.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     gnault@redhat.com, netdev@vger.kernel.org, pmachata@gmail.com,
        roopa@cumulusnetworks.com, dsahern@kernel.org, akaris@redhat.com
Subject: Re: [PATCH net] Revert "vxlan: fix tos value before xmit"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806025241.GO2531@dhcp-12-153.nay.redhat.com>
References: <20200805101807.GN2531@dhcp-12-153.nay.redhat.com>
        <20200805.121110.1918790855908756881.davem@davemloft.net>
        <20200806025241.GO2531@dhcp-12-153.nay.redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 16:45:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu, 6 Aug 2020 10:52:41 +0800

> The rough steps are setting vxlan tunnel on OVS. set inner packet tos to
> 1011 1010 (0xba) and outer vxlan to 1111 1100(0xfc). The outer packet's tos
> should be 0xfe at latest as it inherit the inner ECN bit. But with RT_TOS(tos)
> We actually got tos 0x1e as the first 3 bits are omitted.
> 
> Now here is detailed testing steps:

This explains why we need to revert the RT_TOS() change.

I'm asking what testing you did on the original change that added
RT_TOS(), which we reverted, and which didn't fix anything.

I want to know how we got into this situation in the first place,
adding a change that only added negative effects.

Thank you.

