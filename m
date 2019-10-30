Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6053EA532
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfJ3VMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:12:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60300 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:12:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uB/ttCoq5Iteycq7BZ4GHcsjNmFlWaU9Pnqx8IZNFhs=; b=LV8IOTKfV+r3NpIzxE6a2OKr/
        21GPJZJAo8oxOxngdzMF+t75XSybq09LD6bzW/7PbHQqTQKvVFL/h1+9/+HnryM+7+c7Zflp1dd2N
        +lapxpA5JpvBoNowsEmp/FkUoMNvf2LWo8LBi6sAogpV9EGPe+GVLCVDdytsLQRRKtSnFY5DbFMBm
        djsBZjuXI+ybtRay+EqBuh+qCTfpWsAImc18TxU6HH2ZrDjQvDrk/t3ScqNzuaDCew8HJh7EfOtys
        75GwI+lKa4Z+YVBXsztjDcXZXPw0GLu02ojuxt7IsUUev1DkEx2zkHpxXC/tI11aE47p6jp9umsip
        gc656+5xw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPvGi-0007ci-MX; Wed, 30 Oct 2019 21:12:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: ioc3_eth DMA API fixes
Date:   Wed, 30 Oct 2019 14:12:29 -0700
Message-Id: <20191030211233.30157-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave and Thomas,

please take a look at this series which fixes DMA API usage in the ioc3
ethernet driver.  At least the first one is a nasty abuse of internal
APIs introduced in 5.4-rc which I'd prefer to be fixed before 5.4 final.
