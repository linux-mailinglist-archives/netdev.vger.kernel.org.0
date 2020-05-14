Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3084D1D3363
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgENOqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgENOpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:45:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B0BC061A0C;
        Thu, 14 May 2020 07:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=C0JBBAGMh2Gx0cshhc8L2hDMgoxO3l9OvKF0uYNu6cU=; b=XPlupVEtP9/4WQjK/Bft2etU2g
        WHs6jN/HKq3bN/5mcFIKrd23FQAbM8XycA2qeGhe03WZ5Yi3PFblmWtl3xLK2fGMZrjMKix3allNB
        TR8bhtLoZtGFK/u7lxr6sdZKldbCE7YySuMy5nNdd4+yja3sHng9MRruDiBnQjt59Ap+tqB75xp3N
        H3fxDQjB/AqZXOw67PU9d2sQG+Ah3Gx9ZNDYbonPF55zqQoODGhkTjAZpoKMTl0hjc/4wqiW4cUuq
        LCHqPqkMz5yCTEeG8DZLhKJY/2GA1MSDap4JI7aWUHhaW0Rc6yFdS9fmpYMgESWAt9ZYvi6edxbDt
        BilkmdWw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZF7B-0004cx-8q; Thu, 14 May 2020 14:45:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: move the SIOCDELRT and SIOCADDRT compat_ioctl handlers
Date:   Thu, 14 May 2020 16:45:31 +0200
Message-Id: <20200514144535.3000410-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

this series moves the compat_ioctl handlers into the protocol handlers,
avoiding the need to override the address space limited as in the current
handler.
