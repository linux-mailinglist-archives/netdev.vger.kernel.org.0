Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A972AE3AE
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732314AbgKJWus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKJWus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 17:50:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DDC220780;
        Tue, 10 Nov 2020 22:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605048647;
        bh=WcboRWl77JWuNzjg4I9C64dxGXdRBQo6lbR/ydIN3RA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RBeviLq2IcezpX/bHnESfoisdefgA6FWEdHXUeN7mhgcNl562iTpOs8HTYkO5hWAT
         CTgwn+lkzPOR2gWc0ttow4O8DwiC8xHFkCHpJ47ws3WHAxhIBr8RzvbdgskueFyXCc
         7vf3BslIPWcaX2t9B57NB+Vmo/3Mx7vS7PE/jVOw=
Date:   Tue, 10 Nov 2020 14:50:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next,v2,1/5] vrf: add mac header for tunneled packets when
 sniffer is attached
Message-ID: <20201110145045.22dfd58e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107153139.3552-2-andrea.mayer@uniroma2.it>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-2-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 16:31:35 +0100 Andrea Mayer wrote:
> Before this patch, a sniffer attached to a VRF used as the receiving
> interface of L3 tunneled packets detects them as malformed packets and
> it complains about that (i.e.: tcpdump shows bogus packets).
> 
> The reason is that a tunneled L3 packet does not carry any L2
> information and when the VRF is set as the receiving interface of a
> decapsulated L3 packet, no mac header is currently set or valid.
> Therefore, the purpose of this patch consists of adding a MAC header to
> any packet which is directly received on the VRF interface ONLY IF:
> 
>  i) a sniffer is attached on the VRF and ii) the mac header is not set.
> 
> In this case, the mac address of the VRF is copied in both the
> destination and the source address of the ethernet header. The protocol
> type is set either to IPv4 or IPv6, depending on which L3 packet is
> received.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>

Please keep David's review tag since you haven't changed the code.
