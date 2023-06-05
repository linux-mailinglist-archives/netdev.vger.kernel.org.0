Return-Path: <netdev+bounces-8221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2533072326E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F0691C20DBD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B5C27701;
	Mon,  5 Jun 2023 21:43:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D6ABE59;
	Mon,  5 Jun 2023 21:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CE7C433D2;
	Mon,  5 Jun 2023 21:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686001391;
	bh=5HzfDaos2gHWA5t5fP2JiSVL31TkDrfMwMD9Z2fS7FI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nd68DrdcNj7pdRdzf+OO9+76+SwTAQJh7bsFNvZLw96RUlvFA3hSWzKmfsvLbBh/P
	 uL9xxLb4HvXhIM+1ZnQKgdiFRlPZk8/Pu1pewsJMaSbCntTnym9EYMaR5hbXlTLjtA
	 hdOVRRvm7BlLClkp4Z6nI7t1PI5Kr2rwFJtkJktFgeJGp359mdloNC6FoEs7Z6Xd2B
	 V6xwm5FRLyGZXlXdmHd9tYNZ7YqAIRzw1KyKz+LWC+Y/2q5yPQicIGJNJRpILP09kV
	 RiivbvwbrCZU+V01M+P+SmHb/ePhk4+yUkGivUByBbbbHuJGpii2VvjquZJz8t2ID1
	 Dc/9+enk2oTuQ==
Date: Mon, 5 Jun 2023 14:43:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, netdev@vger.kernel.org, magnus.karlsson@intel.com,
 bjorn@kernel.org, tirthendu.sarkar@intel.com, simon.horman@corigine.com
Subject: Re: [PATCH v3 bpf-next 13/22] xsk: report zero-copy multi-buffer
 capability via xdp_features
Message-ID: <20230605144310.4793f953@kernel.org>
In-Reply-To: <20230605144433.290114-14-maciej.fijalkowski@intel.com>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
	<20230605144433.290114-14-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Jun 2023 16:44:24 +0200 Maciej Fijalkowski wrote:
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index 639524b59930..c293014a4197 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -24,6 +24,8 @@
>   *   XDP buffer support in the driver napi callback.
>   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
>   *   non-linear XDP buffer support in ndo_xdp_xmit callback.
> + * @NETDEV_XDP_ACT_ZC_SG: This feature informs if netdev implements
> + *   non-linear XDP buffer support in AF_XDP zero copy mode.
>   */
>  enum netdev_xdp_act {
>  	NETDEV_XDP_ACT_BASIC = 1,
> @@ -33,8 +35,8 @@ enum netdev_xdp_act {
>  	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
>  	NETDEV_XDP_ACT_RX_SG = 32,
>  	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> -
> -	NETDEV_XDP_ACT_MASK = 127,
> +	NETDEV_XDP_ACT_ZC_SG = 128,
> +	NETDEV_XDP_ACT_MASK = 255,

This is auto-generated, you need to make a change to 
  Documentation/netlink/specs/netdev.yaml
then run ./tools/net/ynl/ynl-regen.sh to regenerate the code
(you may need to install python-yaml or some such package).

