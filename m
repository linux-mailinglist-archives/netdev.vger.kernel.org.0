Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88AF1CE56A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbgEKUZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbgEKUZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:25:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9913DC061A0C;
        Mon, 11 May 2020 13:25:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF1D612848D5A;
        Mon, 11 May 2020 13:25:32 -0700 (PDT)
Date:   Mon, 11 May 2020 13:25:31 -0700 (PDT)
Message-Id: <20200511.132531.1067573616053698778.davem@davemloft.net>
To:     bhsharma@redhat.com
Cc:     netdev@vger.kernel.org, bhupesh.linux@gmail.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        manishc@marvell.com, irusskikh@marvell.com
Subject: Re: [PATCH v2 0/2] net: Optimize the qed* allocations inside kdump
 kernel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589191902-958-1-git-send-email-bhsharma@redhat.com>
References: <1589191902-958-1-git-send-email-bhsharma@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 13:25:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Mon, 11 May 2020 15:41:40 +0530

 ...
> Since kdump kernel(s) run under severe memory constraint with the
> basic idea being to save the crashdump vmcore reliably when the primary
> kernel panics/hangs, large memory allocations done by a network driver
> can cause the crashkernel to panic with OOM.
> 
> The qed* drivers take up approximately 214MB memory when run in the
> kdump kernel with the default configuration settings presently used in
> the driver. With an usual crashkernel size of 512M, this allocation
> is equal to almost half of the total crashkernel size allocated.
> 
> See some logs obtained via memstrack tool (see [1]) below:
>  dracut-pre-pivot[676]: ======== Report format module_summary: ========
>  dracut-pre-pivot[676]: Module qed using 149.6MB (2394 pages), peak allocation 149.6MB (2394 pages)
>  dracut-pre-pivot[676]: Module qede using 65.3MB (1045 pages), peak allocation 65.3MB (1045 pages)
> 
> This patchset tries to reduce the overall memory allocation profile of
> the qed* driver when they run in the kdump kernel. With these
> optimization we can see a saving of approx 85M in the kdump kernel:
>  dracut-pre-pivot[671]: ======== Report format module_summary: ========
>  dracut-pre-pivot[671]: Module qed using 124.6MB (1993 pages), peak allocation 124.7MB (1995 pages)
>  <..snip..>
>  dracut-pre-pivot[671]: Module qede using 4.6MB (73 pages), peak allocation 4.6MB (74 pages)
 ...

Series applied to net-next, thanks.
