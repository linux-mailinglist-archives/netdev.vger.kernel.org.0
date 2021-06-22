Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D473AFE7C
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFVH6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhFVH6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:58:03 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D85CC061574;
        Tue, 22 Jun 2021 00:55:48 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w31so16405849pga.6;
        Tue, 22 Jun 2021 00:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7xvaoK29cQI4qjauQSst3YfwzuyBu/bNqlntJ7vGyMM=;
        b=dOF8BXmAduwGnx+rnd8It1JnF/E30uDMvrhVptvtPu/hHFO0nm9gq8bw/JGlqgjlQY
         FmxOthJYrZrwm4jYOauo9SK+ixz0RWz3/laRzD/t5SFZXdCWK3UutNeIM+WuRepRZLiR
         uSuLF8Cjm6RCzSw7bElgGwtt0MtkPz0D459BV9MHEK8nsQ7Yoc9vmth62h/8eNy9ItkV
         gXYvwop9w7o0ztoV5THkhCZzojkVhtKfqWED/KDXll1nK5JVzsnwN7du4xoLKJ3S5tcd
         RsimQs1zLIXJUcJsloOxyc84qB4nsEUZ+rhf2Y8yv6qTOC1cGzFwzjpTz9+ZGVCC7TcN
         +4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7xvaoK29cQI4qjauQSst3YfwzuyBu/bNqlntJ7vGyMM=;
        b=AeLYA7T65+mrc5ZuZTjq0D7LdVSmvAnZlYZFzdXo3JiUJa1UTmicqZ+uTn2XChSlQn
         j0Fg0n96Pq4rd6W9iBfmOYEUnGOm4qVTB/YEGuPAhiBO0PAh1tLTEkn7/aboNU0fKUzu
         y+9JJIR6m2gCT61mOxI7dWnGZl/+TkhdF0VrIBM27PZ/Fd2GTqywCut1ms8zzy+scOr0
         +pQanm9U6VCv774DXIblyGCfsdmW0uZxk8XKBP44uTxT6uNRFB/n1LtQIS0IRGGeURh7
         dSrc+adGlOG/h8irUP80Vky58wvUU8xlX3XUPKh2m5nzGImcNdNh4A/XqcBI1qcy+TeR
         3jyg==
X-Gm-Message-State: AOAM531iVH+olByTB/4fECIKTYJB/cgyYakZLcl4sfEvFpH03xzqr+W5
        FjwF0LhjEoCmcDriyxPVdxU=
X-Google-Smtp-Source: ABdhPJxI1SgB52smWHu7aInkBaStnGfwhvOES28tfLR6ZE/vi5kagHD7lmuAgAZ+JKvN6K9xMqANrw==
X-Received: by 2002:a63:65c5:: with SMTP id z188mr2607540pgb.174.1624348547535;
        Tue, 22 Jun 2021 00:55:47 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id c6sm9510959pfb.39.2021.06.22.00.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 00:55:47 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:55:42 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 04/19] staging: qlge: add qlge_* prefix to avoid namespace
 clashes
Message-ID: <YNGXfu/wGcKTuJYA@d3>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-5-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621134902.83587-5-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-21 21:48 +0800, Coiby Xu wrote:
> This patch extends commit f8c047be540197ec69cde33e00e82d23961459ea
> ("staging: qlge: use qlge_* prefix to avoid namespace clashes with other qlogic drivers")
> to add qlge_ prefix to rx_ring and tx_ring related structures.

There are still many struct, defines and enums in qlge.h which don't
have a prefix or mix ql_ and qlge_, some of which conflict with other
instances elsewhere in the kernel.
ex: QL_ADAPTER_UP

I think they should all be changed, not just the ones have a conflict
today.
