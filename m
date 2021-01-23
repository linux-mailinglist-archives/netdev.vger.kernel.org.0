Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F363012EE
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbhAWEIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbhAWEIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 23:08:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2C4323B2F;
        Sat, 23 Jan 2021 04:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611374844;
        bh=fNz+kycpiXaSUvF+S8wdSoP0lq2z6erSUd+eJATp7VQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YhQemgcFl6RxF3Zex+9TPCsGDTPaD27UDWk0kmYE0s/DWAJD1qeRf/PHbiXvdc+2Z
         p5I5raSt6rgJz6vhGwO/85xcFAkbbU6Z7jDNHEDyUkDrRoOmn8Wwu0cnXOS2PAcxkx
         g3d87d8cgO3CxaKIhiBoSh99p/dSmE6Rs+ZijKUE+S+Mhi0fvmY+XmmXgvNNtO1WJi
         E53WyhlrCELzi1uP1d2tcdyDGb1WfvMfa4L35ZsKRHRi+ltsp+BQLctQwfxj89Tex+
         snnnB9P0mnzMj5atON9L0DPiqzr26cD1ZeP9BydN46ZPJoFx0X+tydOd1WAVpEusf5
         t2krOLiA/Y5eA==
Date:   Fri, 22 Jan 2021 20:07:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for
 receive zerocopy.
Message-ID: <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
        <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 16:41:48 -0800 Arjun Roy wrote:
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index 768e93bd5b51..b216270105af 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
>  	__u64 copybuf_address;	/* in: copybuf address (small reads) */
>  	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
>  	__u32 flags; /* in: flags */
> +	__u64 msg_control; /* ancillary data */
> +	__u64 msg_controllen;
> +	__u32 msg_flags;
> +	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */

Well, let's hope nobody steps on this landmine.. :)

Applied, thanks!
