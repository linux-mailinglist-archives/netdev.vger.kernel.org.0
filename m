Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D6883B01
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHFVYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:24:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50086 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfHFVYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:24:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DF2113402CEC;
        Tue,  6 Aug 2019 14:24:40 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:24:39 -0700 (PDT)
Message-Id: <20190806.142439.750986288608590840.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 00/10] Support tunnels over VLAN in NFP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:24:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Sun,  4 Aug 2019 16:09:02 +0100

> This patchset deals with tunnel encap and decap when the end-point IP
> address is on an internal port (for example and OvS VLAN port). Tunnel
> encap without VLAN is already supported in the NFP driver. This patchset
> extends that to include a push VLAN along with tunnel header push.
> 
> Patches 1-4 extend the flow_offload IR API to include actions that use
> skbedit to set the ptype of an SKB and that send a packet to port ingress
> from the act_mirred module. Such actions are used in flower rules that
> forward tunnel packets to internal ports where they can be decapsulated.
> OvS and its TC API is an example of a user-space app that produces such
> rules.
> 
> Patch 5 modifies the encap offload code to allow the pushing of a VLAN
> header after a tunnel header push.
> 
> Patches 6-10 deal with tunnel decap when the end-point is on an internal
> port. They detect 'pre-tunnel rules' which do not deal with tunnels
> themselves but, rather, forward packets to internal ports where they
> can be decapped if required. Such rules are offloaded to a table in HW
> along with an indication of whether packets need to be passed to this
> table of not (based on their destination MAC address). Matching against
> this table prior to decapsulation in HW allows the correct parsing and
> handling of outer VLANs on tunnelled packets and the correct updating of
> stats for said 'pre-tunnel' rules.

Series applied, thanks John.
