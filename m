Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C75931A5C5
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 21:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhBLUCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhBLUCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 15:02:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7E164DA1;
        Fri, 12 Feb 2021 20:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613160092;
        bh=fq1xOvv9upjkBoe1ZhLZk0VsS7g2RuUuMzZOXY/+XNg=;
        h=Date:From:To:Cc:Subject:From;
        b=QAKBp6Fmwh6fgalaOtW80Jn6ywdpwteCp9zY5qssNwxsTWefYbOhWtMObiiMcH2HG
         kBoAxlshL89AAWLjRplMUmsmpZwyJq3n1se0sEdUBBoHkJKP23lwo1nrzd5dV45pnm
         G+0LY3ljuesNqoZIzNp56rIUHUx75zFUrYQwsuDdxZUHepZEd+fixZdLPUSd/QvVZt
         9guNOW04+07MKB/V3SVjo59P7JaGdGLAKkBMXZTMOGQ7GG1GGcxwYJpl35jGPw1zRb
         t8jrsiC1U0PWc9UMcTHLbmvFLtRNDu82u5z0kkwskLaI9BK3k5NFsq6CnkWGg05G9h
         Uz+8E4IegyYaQ==
Date:   Fri, 12 Feb 2021 14:01:29 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [bug report] octeontx2-af: cn10k: Identical code for different
 branches
Message-ID: <20210212200129.GA281901@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In file drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c, function rvu_dbg_init()
the same code is executed for both branches:

2431         if (is_rvu_otx2(rvu))
2432                 debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
2433                                     rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
2434         else
2435                 debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
2436                                     rvu, &rvu_dbg_rvu_pf_cgx_map_fops);

This issue was introduced by commit 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")

What's the right solution for this?

Thanks
---
Gustavo
