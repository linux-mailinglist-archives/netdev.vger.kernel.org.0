Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CD840EF20
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 04:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhIQCQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 22:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhIQCQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 22:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED75660F50;
        Fri, 17 Sep 2021 02:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631844890;
        bh=nXX2BfXypFAmIM2hnBKDcky6p/EBCocItmJUXBVJ7mo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FaOBKXmPM9oCnm3R1RAf0fFpJmLqsdOvkfqULU/+kDrIvTNytqF7fdM97GYimQCfa
         RCk+WEvBAQAX2udMUEH+42F/87GMkkS5cz1HPuG5YGKelqE93xn1nXvEbLj8s9nopE
         U0nNmYG0oruylF9QPx6EPUGKNcMCieYkcnzLJnnMHWMIoFAHqSamXvPedStIASkecF
         AqdlMlG19FRVoKBZbrVNroTd1e7+Y3oL3nkWQg/w0hsjdPDQRwao3s1GY5wbEMLL+f
         9x65Zzt1z1Qy2g7pKuUfRRhAl9swn0VOmh+qNpFOLj/92V0q4SUIchyaYHMRbmKni/
         DNkYaNhZC2S7w==
Date:   Thu, 16 Sep 2021 19:14:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20210916191449.668dea06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916204409.1453878-1-cpp.code.lv@gmail.com>
References: <20210916204409.1453878-1-cpp.code.lv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 13:44:09 -0700 Toms Atteka wrote:
> +/**
> + * Parses packet and sets IPv6 extension header flags.
> + *
> + * skb          buffer where extension header data starts in packet
> + * nh           ipv6 header
> + * ext_hdrs     flags are stored here
> + *
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

This is not a valid kdoc format, please read
Documentation/doc-guide/kernel-doc.rst and double check for warnings
with scripts/kernel-doc -none.

> +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
> +			      u16 *ext_hdrs)
> +{

