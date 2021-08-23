Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37663F4BC3
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhHWNe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhHWNeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:34:25 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598E9C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 06:33:42 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id j9so9635450qvt.4
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 06:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+i7ftpgcAy6juUqrZQfkVnQ/sNvqoHPFnUsAUO0x4ik=;
        b=bUO7IaUt9wfvoXicoSfWvNK5GhmYubg9q26ENc3ga+LFE3vqz/Fp1+HGuirrNQ/s/9
         rqUo+yfXTDUxO+E5g3TsmjBZdfYgPgsZbr1m+nHWouONgg+/t9h7swAOJO4WhVO2+SF/
         cbDf+1QOAXYizeNFK+JBkX5NQhoIu1CvWojJ5sEMf+075serfTQ2kYrUxOAUV4aZaxHl
         M0AETKXh6J+hV1bcsSA+Jaapsuye3VHURqqEF9PKEHMcst7EZaLyVLg0H22f4ThD4bGN
         gvyBeiuaivgxTtc4OnBPPW6X2v1mSpm7kB9ASg+FMG5YoGCu0EQTDjdaQJI8E02xivg5
         zsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+i7ftpgcAy6juUqrZQfkVnQ/sNvqoHPFnUsAUO0x4ik=;
        b=YGNzBthxXwHsqEpqILHJ9NItKIRrHS1YM/NTQVktKTzqhEdymnCdDZfut+HUpTlJud
         heIXCYfJxpJh2da34oX3wOGhhT1N8QKXwfRcySjvaQrAbW3/bybSF48ML3bX9sm9kmIk
         G+9YeokGuPBt4xttbm1j/oBzUPddyI00mn03w7tVAiIiknJ/WOSJuQonoWF2Vl4CtbzJ
         2+9immNoTiBsBcDqleZfMAaS7txOKXgkmii/vmy2TgWhJwhbPIdMP/zdSWRZ8W9BtV0C
         nqk95P005uzWpo65JE+BQvbmIE1ltT9K6YakTCAtlZfTYinTrrFH+c5UIkhDKo0t3pfT
         pNpQ==
X-Gm-Message-State: AOAM531XXmoEQynUHSlG0GQbrra1SP8FUsc/2tlAQ2QEztJXgyWx3zra
        VOAZ2Fv5vgN+asOc5DkmrJ+R/w==
X-Google-Smtp-Source: ABdhPJz0YGX9lWSXuoSKnQ/jyr3rhNQEaCoAyF53Ew9VGSRBCOzUKpcfs5ON6tDJnLJ/S8abz7QWmQ==
X-Received: by 2002:a05:6214:2123:: with SMTP id r3mr33266735qvc.19.1629725621588;
        Mon, 23 Aug 2021 06:33:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id v128sm8736482qkh.27.2021.08.23.06.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 06:33:40 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIA56-003Gpi-1k; Mon, 23 Aug 2021 10:33:40 -0300
Date:   Mon, 23 Aug 2021 10:33:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shai Malin <smalin@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
        malin1024@gmail.com, RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] qed: Enable RDMA relaxed ordering
Message-ID: <20210823133340.GC543798@ziepe.ca>
References: <20210822185448.12053-1-smalin@marvell.com>
 <YSOL9TNeLy3uHma6@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSOL9TNeLy3uHma6@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> +RDMA
> 
> Jakub, David
> 
> Can we please ask that everything directly or indirectly related to RDMA
> will be sent to linux-rdma@ too?
> 
> On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > Enable the RoCE and iWARP FW relaxed ordering.
> > 
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> >  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > index 4f4b79250a2b..496092655f26 100644
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn *p_hwfn,
> >  				    cnq_id);
> >  	}
> >  
> > +	p_params_header->relaxed_ordering = 1;
> 
> Maybe it is only description that needs to be updated, but I would
> expect to see call to pcie_relaxed_ordering_enabled() before setting
> relaxed_ordering to always true.
> 
> If we are talking about RDMA, the IB_ACCESS_RELAXED_ORDERING flag should
> be taken into account too.

Why does this file even exist in netdev? This whole struct
qed_rdma_ops mess looks like another mis-design to support out of tree
modules??

Jason
