Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AA81CBB3F
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgEHX27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:28:59 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:58820 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgEHX27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:28:59 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 0743329922;
        Fri,  8 May 2020 19:28:55 -0400 (EDT)
Date:   Sat, 9 May 2020 09:28:38 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
In-Reply-To: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr>
Message-ID: <alpine.LNX.2.22.394.2005090919460.8@nippy.intranet>
References: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 8 May 2020, Christophe JAILLET wrote:

> A call to 'dma_alloc_coherent()' is hidden in 
> 'sonic_alloc_descriptors()'.
> 
> This is correctly freed in the remove function, but not in the error 
> handling path of the probe function. Fix it and add the missing 
> 'dma_free_coherent()' call.
> 
> While at it, rename a label in order to be slightly more informative and 
> split some too long lines.
> 
> This patch is similar to commit 10e3cc180e64 ("net/sonic: Fix a resource 
> leak in an error handling path in 'jazz_sonic_probe()'") which was for 
> 'jazzsonic.c'.
> 
> Suggested-by: Finn Thain <fthain@telegraphics.com.au>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks.

Reviewed-by: Finn Thain <fthain@telegraphics.com.au>

> ---
> Only macsonic has been compile tested. I don't have the needed setup to
> compile xtsonic

I compile tested xtsonic.c. I didn't use an xtensa toolchain as there's 
probably no need: the new code already appears elsewhere in that file.
