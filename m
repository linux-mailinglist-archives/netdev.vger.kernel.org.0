Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6C1483564
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiACRM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:12:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52826 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiACRMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:12:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2FD761169;
        Mon,  3 Jan 2022 17:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D1EC36AED;
        Mon,  3 Jan 2022 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641229944;
        bh=uhzW4lvNDD6+3QU4kFJO1P9RzyroNM4hVqwkOjyflFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M2C4rtgqdlCu80hsauE4XK+QHhJS7coc0dG8D+GRHVmz+dhBJhEe420k0mRD4iAEI
         xOWmfPnKDsIyz77uSNyGOUws/sy3crm7/DAd1KEF9GjPq08NNiSjb6U54ynMJrIWHy
         f/OZpQCx2j47wmbEe4n8yBwdimxTuceHV2Qp2Y1Silre2Bm0PZYlmwXPZK3b/4cdrD
         DfOuOSgp3sHu6qu8n7mFOCGgt/J9td/TAUPxJeivcuxGpoW93XWc5mon48pw3oBf0f
         fyKZYCkUoa8DQPXitZLAEk96xKCJ4pGtaluKai+8pBlNSgpvCyZw5DFVqHUeRiCO96
         Qrp9IL1RHhqLg==
Date:   Mon, 3 Jan 2022 09:12:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH] scsi: qedf: potential dereference of null pointer
Message-ID: <20220103091222.194ef58f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <DM6PR18MB30344528373170A95E67B50CD2499@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
        <DM6PR18MB30344528373170A95E67B50CD2499@DM6PR18MB3034.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jan 2022 04:58:41 +0000 Saurav Kashyap wrote:
> > QEDF_TERM_BUFF_SIZE,
> >  		&term_params_dma, GFP_KERNEL);
> > +	if (!term_params)
> > +		return;  
> 
> <SK> Adding message about failure before returning will help in debugging.

Memory allocations produce a pretty detailed splat.
