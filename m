Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887761634F6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBRV3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgBRV3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 16:29:24 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D00962173E;
        Tue, 18 Feb 2020 21:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582061364;
        bh=AeaVF7cdx9bjVEI17/6VTUhvG6l0HOjiZgrtcvd3irs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WZ4TP1cmZJaBma+E9WEjaNvqCPFvch/YA8GyJ9yxL7tlEcKmLScZzMk0U1FdMRBUA
         XRcOufLhxdCPKmcRQ580jpBdYsThsGgL+E5SK65nOwixKLgeSAo++BwVEubkLlDs+x
         72PKBWgOh9LpAHxBbPqz3KJeGUYuzX4Z5heRFaIs=
Date:   Tue, 18 Feb 2020 13:29:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, andrew@lunn.ch,
        brouer@redhat.com, dsahern@kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200218132921.46df7f8b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 01:14:29 +0100 Lorenzo Bianconi wrote:
> Introduce "rx" prefix in the name scheme for xdp counters
> on rx path.
> Differentiate between XDP_TX and ndo_xdp_xmit counters
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Sorry for coming in late.

I thought the ability to attach a BPF program to a fexit of another BPF
program will put an end to these unnecessary statistics. IOW I maintain
my position that there should be no ethtool stats for XDP.

As discussed before real life BPF progs will maintain their own stats
at the granularity of their choosing, so we're just wasting datapath
cycles.

The previous argument that the BPF prog stats are out of admin control
is no longer true with the fexit option (IIUC how that works).
