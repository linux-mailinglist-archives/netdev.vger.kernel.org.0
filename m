Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAED82DD82C
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgLQSVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQSVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:21:19 -0500
Date:   Thu, 17 Dec 2020 10:20:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608229239;
        bh=lopp1baHdbxZu/0OjsahYIxemeNxg8EJ4PxKfBGb5Kk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=nxMHBu55Hz/THJg9MBoluBeLK7SaHb+ut23C1aF3Jyy9IyjeWtZNj3GOjrol00Olw
         3D7bdF+ZqXZT+JS8dD0julR19FwvWCoAesXFjbg/0GHyLnQhXHX755rS0cROZtTtXe
         wyiS1kwDDFyxLE72QFr/PKVQ3p5tJhv4q7BXgKJPhxrukBL0zEXQuDpuuxU40LFeOH
         n9IvhfNy6dYFTM8BeG9IoMLBRSxAH03lujo2mEkbn1ofylZnqvldY2Nw/ZwPVD2NQk
         UVKvnQpZ968M0/BYAjFkg4GAOUEL9roC57GvQNlTlDQ9X/kQOqSVyrC1vV01floYsn
         OyL7DFXOxDfOw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Ulisses Alonso =?UTF-8?B?Q2FtYXLDsw==?= <uaca@alumni.uv.es>
Subject: Re: [PATCH net 2/2] docs: networking: packet_mmap: don't mention
 PACKET_MMAP
Message-ID: <20201217102037.6f5ceee9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1fc59ef61e324a969071ea537ccc2856adee3c5b.1608051077.git.baruch@tkos.co.il>
References: <425a2567dbf8ece01fb54fbb43ceee7b2eab9d05.1608051077.git.baruch@tkos.co.il>
        <1fc59ef61e324a969071ea537ccc2856adee3c5b.1608051077.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 18:51:17 +0200 Baruch Siach wrote:
> Before commit 889b8f964f2f ("packet: Kill CONFIG_PACKET_MMAP.") there
> used to be a CONFIG_PACKET_MMAP config symbol that depended on
> CONFIG_PACKET. The text still refers to PACKET_MMAP as the name of this
> feature, implying that it can be disabled. Another naming variant is
> "Packet MMAP".
> 
> Use "PACKET mmap()" everywhere to unify the terminology. Rephrase the
> text the implied mmap() feature disable option.

Should we maybe say AF_PACKET mmap() ?

> -In Linux 2.4/2.6/3.x if PACKET_MMAP is not enabled, the capture process is very
> -inefficient. It uses very limited buffers and requires one system call to
> -capture each packet, it requires two if you want to get packet's timestamp
> -(like libpcap always does).
> +In Linux 2.4/2.6/3.x non mmap() PACKET capture process is very inefficient. It

We can drop the references to versions. Kernels older than 2.4 are
prehistoric, and we have 4.x and 5.x now.

> +uses very limited buffers and requires one system call to capture each packet,
> +it requires two if you want to get packet's timestamp (like libpcap always
> +does).

Would it be possible to avoid re-flowing the existing text. IMHO it's
okay if we end on a short line, and it makes the diff easier to review.

> -In the other hand PACKET_MMAP is very efficient. PACKET_MMAP provides a size
> -configurable circular buffer mapped in user space that can be used to either
> -send or receive packets. This way reading packets just needs to wait for them,
> -most of the time there is no need to issue a single system call. Concerning
> -transmission, multiple packets can be sent through one system call to get the
> -highest bandwidth. By using a shared buffer between the kernel and the user
> -also has the benefit of minimizing packet copies.
> +In the other hand PACKET mmap() is very efficient. PACKET mmap() provides a

While at it - "on the other hand"?

> +size configurable circular buffer mapped in user space that can be used to
> +either send or receive packets. This way reading packets just needs to wait for
> +them, most of the time there is no need to issue a single system call.
> +Concerning transmission, multiple packets can be sent through one system call
> +to get the highest bandwidth. By using a shared buffer between the kernel and
> +the user also has the benefit of minimizing packet copies.
>  
> -It's fine to use PACKET_MMAP to improve the performance of the capture and
> +It's fine to use PACKET mmap() to improve the performance of the capture and
>  transmission process, but it isn't everything. At least, if you are capturing
>  at high speeds (this is relative to the cpu speed), you should check if the
>  device driver of your network interface card supports some sort of interrupt

