Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5812AE4DE
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgKKAYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:24:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgKKAYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 19:24:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BCA82068D;
        Wed, 11 Nov 2020 00:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605054283;
        bh=s1Zg0hprqCYUkA+OIWnlihh4pH5ZlZvPCOuL/OtRjCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NM9GjpY5yGYgsk8YYYZO0gEz3noMQ2NB1Ddod8Re8b5tsHRf4ZK9FfQHxKgln/V0b
         iY9O+spY2DZs/htP0LYhJyCMwDIE75q8pTTOkyMFfum6nL6KNZrNi+HGcE4yPP0q/m
         uAKWBCzqiT058FDse5EUVZyoJywlQfXIu0K7X9jQ=
Date:   Tue, 10 Nov 2020 16:24:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: tag_dsa: Unify regular and ethertype DSA
 taggers
Message-ID: <20201110162442.14c064cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110091325.21582-1-tobias@waldekranz.com>
References: <20201110091325.21582-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 10:13:25 +0100 Tobias Waldekranz wrote:
> +/**
> + * enum dsa_code - TO_CPU Code
> + *
> + * A 3-bit code is used to relay why a particular frame was sent to
> + * the CPU. We only use this to determine if the packet was trapped or
> + * mirrored, i.e. whether the packet has been forwarded by hardware or
> + * not.
> + */
> +enum dsa_code {
> +	DSA_CODE_MGMT_TRAP     = 0,
> +	DSA_CODE_FRAME2REG     = 1,
> +	DSA_CODE_IGMP_MLD_TRAP = 2,
> +	DSA_CODE_POLICY_TRAP   = 3,
> +	DSA_CODE_ARP_MIRROR    = 4,
> +	DSA_CODE_POLICY_MIRROR = 5,
> +	DSA_CODE_RESERVED_6    = 6,
> +	DSA_CODE_RESERVED_7    = 7
> +};

You need to describe the values, otherwise W=1 builds will generate
warnings.
