Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D08352992
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbfFYK3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:29:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48588 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731567AbfFYK3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=03ojHgXKpRrzEADBxRtQ8YC8RIb84J9PztiNz1KmLWs=; b=r/XR7/xP6nyXRTnUY3y2v+YEK
        65bqRI45tLGykqbtovBBlOEpa/POnCsGZXJ9VKlizAcjRVNVxhXn9Clu423Ly+x/1uSblIAP6baao
        2dr6hPTSGnD7Rj75C8kTEJuUAZh2TvAzxTxe636gI5fza1jbBCK1QgWZ6xLlcOB+2cbruei5dJO96
        ushlCvQNRvUkIeffIaYJz6HG3AlHB10GCW9U7WbV+S0TLMDX6HZP9slfAYRtYyEWFErI6ZHUN7Cf/
        mrzyO9Uenwf/gDyMHOb9Ywz1SVjx0bt2N1pJbNBtusXJYzDF153QoDHfKmACDYb3D6+5dBjiD8Yz1
        GKadHXIaA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfihj-0005S9-O8; Tue, 25 Jun 2019 10:29:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: b43 / b43 legacy dma mask cleanups
Date:   Tue, 25 Jun 2019 12:29:28 +0200
Message-Id: <20190625102932.32257-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

below are a few cleanups for the DMA mask handling.  I came up with these
untested patches after looking through the code to debug the 32-bit pmac
30-bit dma issue involving b43legacy.
