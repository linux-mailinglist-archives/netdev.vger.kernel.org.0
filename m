Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A781E32CF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391390AbgEZWmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390982AbgEZWmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:42:43 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F385208C3;
        Tue, 26 May 2020 22:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590532963;
        bh=JxtB6rN2MFc35JmKtN6LHPec0j8+CGkXuMONcwMZQLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mihX7iUpUZdn0OefUh7GVr/2GSvwyEAHdVUd89Du/ckQRRWP09NU+cI+bvW/otP2G
         4BVS0pqRjIYB2N8SBImdYV9V1WoF3Kd6EdjOJnTkvljW0YmpAxgNCg4P9BnRoO7gEM
         zanAo8Wqi+uCGEHTauM4Xhy3JCsMlzXvcj8+5rAE=
Date:   Tue, 26 May 2020 15:42:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net v2] cxgb4/chcr: Enable ktls settings at run time
Message-ID: <20200526154241.24447b41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526140634.21043-1-rohitm@chelsio.com>
References: <20200526140634.21043-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 19:36:34 +0530 Rohit Maheshwari wrote:
> Current design enables ktls setting from start, which is not
> efficient. Now the feature will be enabled when user demands
> TLS offload on any interface.
> 
> v1->v2:
> - taking ULD module refcount till any single connection exists.
> - taking rtnl_lock() before clearing tls_devops.

Callers of tls_devops don't hold the rtnl_lock.

> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
