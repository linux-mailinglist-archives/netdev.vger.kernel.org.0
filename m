Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148CC487669
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbiAGLYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiAGLYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:24:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B67C061245;
        Fri,  7 Jan 2022 03:24:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518A161215;
        Fri,  7 Jan 2022 11:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1E9C36AE0;
        Fri,  7 Jan 2022 11:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641554649;
        bh=lS3K+/8eH/hW2rM5DBnjQgNBWnfsEKjwtRKohwXDT/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xTSf+xG1jRpuWw9UMZ6P6VfSj13FImWS4aDczypiLoS2WS20KVO+kqsL92aWOXWT8
         576NdvXxwy+wrd9Z49kUtCTP5ykfZL/UlEQDjpT1pXcyhtBkxlHwnaGyXtTOrsf3oj
         SxrLTlwmbKvYgQ2EJhZ5stdBu+M+GEHy4yoG7x6E=
Date:   Fri, 7 Jan 2022 12:24:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aayush Agarwal <aayush.a.agarwal@oracle.com>
Cc:     stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14] phonet: refcount leak in pep_sock_accep
Message-ID: <Ydgi0qF/7GwoCh96@kroah.com>
References: <20220107105332.61347-1-aayush.a.agarwal@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107105332.61347-1-aayush.a.agarwal@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 02:53:32AM -0800, Aayush Agarwal wrote:
> From: Hangyu Hua <hbh25y@gmail.com>
> 
> commit bcd0f9335332 ("phonet: refcount leak in pep_sock_accep")
> upstream.
> 
> sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
> invoked in subsequent failure branches(pep_accept_conn() != 0).
> 
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> Link: https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Aayush Agarwal <aayush.a.agarwal@oracle.com>
> ---
>  net/phonet/pep.c | 1 +
>  1 file changed, 1 insertion(+)

What about releases 5.15.y, 5.10.y, 5.4.y, and 4.19.y?  Is this also
relevant for those trees?

thanks,

greg k-h
