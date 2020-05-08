Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7D31CB305
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgEHPgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgEHPgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:36:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C809C061A0C;
        Fri,  8 May 2020 08:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=JYdyu02dksbSjvmwcDV7qt06YZ68oFogfc0H7mUbdmw=; b=qjaMFrDyUaIDFFR/VB6EcmHWKy
        i7SNi7MXJSxWZd67zL2J2Gh5qxlCPOfUB/brJjc9qw0qCSj+PTbugVE9jz0KiQ2oqhxOOa8aTHUQ3
        ThGxZkMVHc76uL6GbcUHqnVe+rTIi7sL59bJ6sJz6aiCsH++7jcarqChqxpRdgsZYeVS8o0yd6Mnz
        6o3XSSDb1dwZLKBmGh1LxpTwE4WFuM/rtR3AP/6d+yxVs+OqH4P//yiYxaw74Q9XxEu9VqkFPaoA1
        3p7q9DDeka6ZIKq2wx1h4PJO2yBoVi5v5BL7kWCpFCNkfv+nhQ5AQ+dr/XVDRLLmJjiHT/JqVD5j9
        UeqibLWg==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53F-00046s-CU; Fri, 08 May 2020 15:36:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Add a __anon_inode_getfd helper
Date:   Fri,  8 May 2020 17:36:22 +0200
Message-Id: <20200508153634.249933-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Al,

this series (against your work.epoll branch), adds a new
__anon_inode_getfd helper, which exposes the functionality in
anon_inode_getfd minus installing the file descriptor.  This
allows to clean up a lot of the places that currently open code
the functionality.
