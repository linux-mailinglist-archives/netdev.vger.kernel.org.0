Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74C91C40AC
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgEDRBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729459AbgEDRBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 13:01:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DAFF206D7;
        Mon,  4 May 2020 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588611690;
        bh=mEIMvEeemT9qFPg6WFXv7L2Ou2lEHMX+SClo7n1fkh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2BygdSsFh85R9fAHagGynYsW4TX6sYVTu+7YqhxiotGbO13ggVCuL1iUIFm3mCOnr
         Q4cKHGq7/9wKuwY2yz13s+yWWLDes1Vi1SOBQzfWLaI8K0TxcsRf/xxgOvmgyDn7CL
         NQHTTugxIZCjssiCo3oUd3RgmTOp/3O6Dhx0tY7k=
Date:   Mon, 4 May 2020 10:01:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wu000273@umn.edu
Cc:     davem@davemloft.net, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kjlu@umn.edu
Subject: Re: [PATCH] nfp: abm: fix a memory leak bug
Message-ID: <20200504100128.06221170@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200502224259.1477-1-wu000273@umn.edu>
References: <20200502224259.1477-1-wu000273@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 May 2020 17:42:59 -0500 wu000273@umn.edu wrote:
> From: Qiushi Wu <wu000273@umn.edu>
> 
> In function nfp_abm_vnic_set_mac, pointer nsp is allocated by nfp_nsp_open.
> But when nfp_nsp_has_hwinfo_lookup fail, the pointer is not released,
> which can lead to a memory leak bug. Fix this issue by adding
> nfp_nsp_close(nsp) in the error path.
> 
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>

Fixes: f6e71efdf9fb1 ("nfp: abm: look up MAC addresses via management FW")
Acked-by: Jakub Kicinski <kuba@kernel.org>
