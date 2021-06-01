Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44807397953
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhFARnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhFARnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 13:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5027761042;
        Tue,  1 Jun 2021 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622569280;
        bh=2IFDrzvsvhbzI9SgMn3XalE8GIMt01IatSD60Qc5Gmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j0b+3rm95SfAaBVuhPEnN6N/bHDGpbZlvxz2MUhN1Y8tQzui/fmCb3FS0lS+GWJsQ
         o5SpVaWWiRcwHIMsgnYCMr1uyzecIfP0dNToJXvWZyviw0eAcBG6yr/PHYBXDPw5kI
         9paSMIESAuJs6QhCY7lixIZoZCJBJAKF//LiCQaOVIhwqO0K3WzdKCm47f0+Lbenu5
         cG1ACuHAogEa7+XnqlGLqgQ4LXIrv3D0Ogud3q1BT/+9UailhDuUfP5vXtYGj8zYOs
         JgP4t2aIfOSDQ+TPBNX6fOuo9VmG1RaNDA58ch6RfILS4S+yPLhdfRj/fi3cN7BLka
         Shwv9Yu7a6S2Q==
Date:   Tue, 1 Jun 2021 18:41:15 +0100
From:   Will Deacon <will@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>, ast@kernel.org,
        zlim.lnx@gmail.com, catalin.marinas@arm.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bpf: avoid unnecessary IPI in bpf_flush_icache
Message-ID: <20210601174114.GA29130@willie-the-truck>
References: <20210601150625.37419-1-yanfei.xu@windriver.com>
 <20210601150625.37419-2-yanfei.xu@windriver.com>
 <56cc1e25-25c3-a3da-64e3-8a1c539d685b@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56cc1e25-25c3-a3da-64e3-8a1c539d685b@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 07:20:04PM +0200, Daniel Borkmann wrote:
> On 6/1/21 5:06 PM, Yanfei Xu wrote:
> > It's no need to trigger IPI for keeping pipeline fresh in bpf case.
> 
> This needs a more concrete explanation/analysis on "why it is safe" to do so
> rather than just saying that it is not needed.

Agreed. You need to show how the executing thread ends up going through a
context synchronizing operation before jumping to the generated code if
the IPI here is removed.

Will
