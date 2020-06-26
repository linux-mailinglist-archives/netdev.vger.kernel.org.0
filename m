Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7648B20B593
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgFZQEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgFZQEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 12:04:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E7D52053B;
        Fri, 26 Jun 2020 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593187444;
        bh=ldibBulTHlmXlu5Btv5fBdLjsBo9nKBad9345ktiWw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JIvyfNE6tCLjEnpCZEy3nS5Yq1Y9//KhByGpJ8f6mN5CNTo3EiPeP63cUeiu4QvGI
         ypQ+lpjBkO9Tb19kywv3yhkBESOLKEvbXa4poO6v+FNwsPjkmAE3hADs63aHKXhfje
         tNGjaLUigddIfgu0KcAfmWEByj+xZW+qsGkC75yw=
Date:   Fri, 26 Jun 2020 09:04:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v11 2/3] xen networking: add basic XDP support
 for xen-netfront
Message-ID: <20200626090402.0f2228de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593167674-1065-3-git-send-email-kda@linux-powerpc.org>
References: <1593167674-1065-1-git-send-email-kda@linux-powerpc.org>
        <1593167674-1065-3-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 13:34:33 +0300 Denis Kirjanov wrote:
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

W=1 C=1 produces this warning:

drivers/net/xen-netfront.c: In function xennet_xdp_xmit_one:
drivers/net/xen-netfront.c:581:31: warning: variable tx set but not used [-Wunused-but-set-variable]
  581 |  struct xen_netif_tx_request *tx;
      |                               ^~
