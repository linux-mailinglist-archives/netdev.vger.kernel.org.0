Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D6375D24
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 00:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhEFWXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 18:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230149AbhEFWXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 18:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F537613B5;
        Thu,  6 May 2021 22:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620339737;
        bh=Pl4Nc2bJYjn/SVHW8muq4kyY44aB+yCSVGCuxuNvFUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eH95wkZAXB7soK9mkx2OkK7vqeNuvyUwwWthib0NEkfMqZ+tit+3r5hylLj3cmHFj
         KasxWTjgo2SAX2kUrlpETL1M4Iy3+USdmagh84MNK+0lTSJtkLuGuX3Suuh5gxACUq
         XYL6eGZyKRI+CW83YEBK2lzJWHJCHX2HSUzSkDXmExXjlyZyAieqxsESh2RoupPO61
         bU3b/5vpApVa3Hb2xZIMobViRChPwMSbISCzb93KXZqEz1VlhMKub9vmqXhaD6ua8w
         yHiD+/Ne9MjfR6qfFW6zOwXcwjazhSLpBbQUnruBiw8TbDHLDElu6z/ERymX7NlIlP
         IvrzhvRN6g1hQ==
Date:   Thu, 6 May 2021 15:22:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20210506152216.6f31a7cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210506183053.24430-1-cpp.code.lv@gmail.com>
References: <20210506183053.24430-1-cpp.code.lv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 May 2021 11:30:53 -0700 Toms Atteka wrote:
> +/**
> + * Parses packet and sets IPv6 extension header flags.
> + *
> + * skb          buffer where extension header data starts in packet
> + * nh           ipv6 header
> + * ext_hdrs     flags are stored here

This is not a valid kdoc comment. Please fix.

> + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> + * is unexpectedly encountered. (Two destination options headers may be
> + * expected and would not cause this bit to be set.)
> + *
> + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> + * preferred (but not required) by RFC 2460:
> + *
> + * When more than one extension header is used in the same packet, it is
> + * recommended that those headers appear in the following order:
> + *      IPv6 header
> + *      Hop-by-Hop Options header
> + *      Destination Options header
> + *      Routing header
> + *      Fragment header
> + *      Authentication header
> + *      Encapsulating Security Payload header
> + *      Destination Options header
> + *      upper-layer header
> + */
> +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh, u16 *ext_hdrs)
