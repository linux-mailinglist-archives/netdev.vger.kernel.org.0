Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00EF2A12BB
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgJaBnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaBnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 21:43:49 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F200208B6;
        Sat, 31 Oct 2020 01:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604108628;
        bh=KQQSNR8mRoZCF4R0ohl2yrwofzaakjvyplnnGi5BPb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DDj9Ypv/F6XT/beC8DRFcMdc5iB/zbkO3m45+/z9TtQdv16TYBqCAmZW5wVxccLcS
         dCOQt9gdh8G1H0a64ywLD5+4/XQCF9Fi4xsx6ON6wf2vl0ZGIQFMTx8zxChMHWx/oX
         BdncgBifiasDiXYAaj200QaJJC3OT0YAhuCWyRuY=
Date:   Fri, 30 Oct 2020 18:43:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     willemdebruijn.kernel@gmail.com, madalin.bucur@oss.nxp.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] dpaa_eth: fix the RX headroom size alignment
Message-ID: <20201030184347.4a8ad004@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5b077d5853123db0c8794af1ed061850b94eae37.1603899392.git.camelia.groza@nxp.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
        <5b077d5853123db0c8794af1ed061850b94eae37.1603899392.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 18:41:00 +0200 Camelia Groza wrote:
> @@ -2842,7 +2842,8 @@ static int dpaa_ingress_cgr_init(struct dpaa_priv *priv)
>  	return err;
>  }
> 
> -static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
> +static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
> +				    enum port_type port)

Please drop the "inline" while you're touching this definition.

The compiler will make the right inlining decision here.
