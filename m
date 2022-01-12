Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA98F48CE6E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiALWcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiALWcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:32:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691DEC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0715B61B08
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E5CC36AE5;
        Wed, 12 Jan 2022 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642026734;
        bh=emzu/R2hEoistkZMTvh51LVr+9ZaphQ1/yTm3WssweQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O5FEGkwXDUIwmpFlDYnx8JnMumkKWX8j5Mj3Ak/cs3ZBqyeXvHVwEORXLZMjQcU5l
         vxnIIypdB36LX7p+XkGMeZkwvHtIlrj+cvPkSaOHTkVpPWSi/c+DmlPdHeY0jtBTaL
         7FKhvHGudw4T3V2Ijm7inIlEG/iKAxqEyuUUcDRXuCW74dI62yyCwxNa8JFZh9CjnQ
         e/7yOiRzQe8i2WRUnXlT3FFTDsVkQyFjr0lWgY3wecW3g8+o4oogf4yNhWFqsIEjOY
         ZaSJki/CSmxYj6h1VtS6BbepRC8xFNcvmzM8zoWqJNs0DvnNJQkevENXv4nJdYDuhe
         eljAOhHodPMvQ==
Date:   Wed, 12 Jan 2022 14:32:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 7/8] net/funeth: add kTLS TX control part
Message-ID: <20220112143213.0ad3c9c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110015636.245666-8-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
        <20220110015636.245666-8-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Jan 2022 17:56:35 -0800 Dimitris Michailidis wrote:
> +static inline int fun_ktls_init(struct net_device *netdev)
> +{
> +	return -ENOTSUPP;

ENOTSUPP is best avoided - EOPNOTSUPP is the proper error code which
can be returned to user space if needed. But you should make this
function void since the return value is ignored, anyway.
