Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B974A2AFD
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 02:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352041AbiA2BbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 20:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352031AbiA2BbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 20:31:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4293CC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 17:31:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99B36615EB
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 01:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67C3C340E7;
        Sat, 29 Jan 2022 01:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643419883;
        bh=I7LewSz807hFj1Npn0eoh/y7rN4f6b0t9MIW7u36PoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V9u+jOuq+02sC2BfLB74wUrKDH/AXgM+mNskXB77toM+1XgAvE745jURPBQeHwC3W
         NHIG+Yuu+it9C06uRoR1eLKJARvRXEbAVa3Hz5cHn2UZspqH0UkKsiTCJZM2ceh927
         tp1xWuMuQKJ5znpewIngsIs4GXyNC8uqMAw/eMceIN3H/F9t0pbZZWB0PXsbUzXtut
         0VKipkfzcZoBGQj4i5yPhr0eeezx+QC0KQrXUiaLEVtC5hxKl5QeB423l0vZTMqx5r
         qc6h+FtYhFEtiZYky5swNbc2CRaALGvqAs4k/Q745rPjqE4CBMqfRvLDLoyDkaJqBO
         mW9MQKkVuQvTw==
Date:   Fri, 28 Jan 2022 17:31:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH net-next 1/2] uapi: ioam: Insertion frequency
Message-ID: <20220128173121.7bb0f8b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220126184628.26013-2-justin.iurman@uliege.be>
References: <20220126184628.26013-1-justin.iurman@uliege.be>
        <20220126184628.26013-2-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 19:46:27 +0100 Justin Iurman wrote:
> Add the insertion frequency uapi for IOAM lwtunnels.
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  include/uapi/linux/ioam6_iptunnel.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/uapi/linux/ioam6_iptunnel.h b/include/uapi/linux/ioam6_iptunnel.h
> index 829ffdfcacca..462758cdba14 100644
> --- a/include/uapi/linux/ioam6_iptunnel.h
> +++ b/include/uapi/linux/ioam6_iptunnel.h
> @@ -30,6 +30,15 @@ enum {
>  enum {
>  	IOAM6_IPTUNNEL_UNSPEC,
>  
> +	/* Insertion frequency:
> +	 * "k over n" packets (0 < k <= n)
> +	 * [0.0001% ... 100%]
> +	 */
> +#define IOAM6_IPTUNNEL_FREQ_MIN 1
> +#define IOAM6_IPTUNNEL_FREQ_MAX 1000000

If min is 1 why not make the value unsigned?

> +	IOAM6_IPTUNNEL_FREQ_K,		/* s32 */
> +	IOAM6_IPTUNNEL_FREQ_N,		/* s32 */

You can't insert into the middle of a uAPI enum. Binary compatibility.

>  	/* Encap mode */
>  	IOAM6_IPTUNNEL_MODE,		/* u8 */
>  

