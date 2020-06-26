Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B5720B59D
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgFZQFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgFZQFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 12:05:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29412075D;
        Fri, 26 Jun 2020 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593187521;
        bh=s7qO6k+iUBxTKFjW8u4jdcgshL82jyr/bNoTz2E3XYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tygRuCa0vOGnWUNy3naqITmtDptJ+SmL33dB1AkA4uT/5qktdJtLyfr4MOO5bcWRr
         o4RpJLzES8tSrqoviTT4hme/kGQiniVBKlSA5/gYAMV0ifpkZJ/CyTXceiPcR2w2KB
         i2w6+QdqYfd4aib8AJ41QiQnK3J7rGd6AU+m3dpc=
Date:   Fri, 26 Jun 2020 09:05:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v13 2/3] xen networking: add basic XDP support
 for xen-netfront
Message-ID: <20200626090519.7efbd06f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593171639-8136-3-git-send-email-kda@linux-powerpc.org>
References: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
        <1593171639-8136-3-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 14:40:38 +0300 Denis Kirjanov wrote:
> The patch adds a basic XDP processing to xen-netfront driver.
> 
> We ran an XDP program for an RX response received from netback
> driver. Also we request xen-netback to adjust data offset for
> bpf_xdp_adjust_head() header space for custom headers.
> 
> synchronization between frontend and backend parts is done
> by using xenbus state switching:
> Reconfiguring -> Reconfigured- > Connected
> 
> UDP packets drop rate using xdp program is around 310 kpps
> using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch.
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Still here:

drivers/net/xen-netfront.c: In function xennet_xdp_xmit_one:
drivers/net/xen-netfront.c:581:31: warning: variable tx set but not used [-Wunused-but-set-variable]
  581 |  struct xen_netif_tx_request *tx;
      |                               ^~
