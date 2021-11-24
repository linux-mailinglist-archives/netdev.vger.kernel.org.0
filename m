Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4913845D164
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbhKXXwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:52:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236890AbhKXXwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:52:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A03C61058;
        Wed, 24 Nov 2021 23:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637797773;
        bh=Pt/De46FFK05c86NMGl/s/ATYJD2SLPkoI3+Mtvv01M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qIFvh/vg6i+bM7BVj+leKel4IjvU5v+027U0BOGJL/TeSIPHA9midtCwPE962CHDI
         ERRH+VhytbRHsIBuCNl7Pox1JLbfqUjB9CL4IXCgavD2jofadOIyUKSgDnmdd1wBCe
         JHw/0rgfxNlwmAVuSfLRKosN/KpLTRXkjRMlMBZSc6F1QV46qI31GK++O0NPbnfeAF
         EZySMD76sp+aP0G4MZdP8J4mlyrxOE/3hCGLN7u4QTZssolJRuD3mMRpQ6+E4TthI+
         Q94R47BeMBig+Au9Vl7oPJwffIF1w0bkFeLQ2d8hkydcrplP0eLWody3qiv/K4iF67
         lhYTzNSAhYlqA==
Date:   Wed, 24 Nov 2021 15:49:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 08/12] iavf: Refactor iavf_mac_filter struct
 memory usage
Message-ID: <20211124154931.5d33dc33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124171652.831184-9-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-9-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:16:48 -0800 Tony Nguyen wrote:
> -	bool is_new_mac;	/* filter is new, wait for PF decision */
> -	bool remove;		/* filter needs to be removed */
> -	bool add;		/* filter needs to be added */
> +	struct {
> +		u8 is_new_mac:1;    /* filter is new, wait for PF decision */
> +		u8 remove:1;        /* filter needs to be removed */
> +		u8 add:1;           /* filter needs to be added */
> +		u8 is_primary:1;    /* filter is a default VF MAC */
> +		u8 padding:4;
> +	};

Why did you wrap it in a struct? Just curious.
