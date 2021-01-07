Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A152EC757
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbhAGAbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAGAbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 19:31:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 296A722E03;
        Thu,  7 Jan 2021 00:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609979458;
        bh=5hjQiVmQ1AQGHvadHeoWnhLAPazVLDC2EFggvzvWRF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cYF3/ZLg7oQEjxZcuLJb37TOi1b9nEZYqkngw8lgl7UBgBE6XvkrkkOEfHgQ7HO6N
         dyrQlTtub4fFJ+OrJC7ZLnfSI7EXU7mo8UpwShPHhJTIpxgWTffaPVNQeYNlYuWp/F
         00XA4oI9WclQ9CIBfxpxlFdVM8cdmR0PsXqK7Uk1u+aK6YaU0ga+CheHQLfY5HHMoa
         38W9ZI6MKsbekr6wE6Eui9iQl7d0M7iKw7tfDxCDScb2flhbhvag/rL8B81M+gecy/
         +e3PfIgAnyx5i82XRknQZ3sRCBCmmH1DbRyHMN61GoMWDmsSUETbDvzk1Lw4p0YCpJ
         PGq5kQnf1laSw==
Date:   Wed, 6 Jan 2021 16:30:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sysctl: cleanup net_sysctl_init()
Message-ID: <20210106163056.79d75ffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106204014.34730-1-alobakin@pm.me>
References: <20210106204014.34730-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 06 Jan 2021 20:40:28 +0000 Alexander Lobakin wrote:
> 'net_header' is not used outside of this function, so can be moved
> from BSS onto the stack.
> Declarations of one-element arrays are discouraged, and there's no
> need to store 'empty' in BSS. Simply allocate it from heap at init.

Are you sure? It's passed as an argument to register_sysctl()
so it may well need to be valid for the lifetime of net_header.
