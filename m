Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87724D094
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 10:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgHUIcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 04:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgHUIcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 04:32:06 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9A2C061385;
        Fri, 21 Aug 2020 01:32:05 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t11so570638plr.5;
        Fri, 21 Aug 2020 01:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KMEAgxnLavJYQ3i7i0cZ9PJqwCosdeDVQ11vARt76rw=;
        b=rCloECpYonB62tNgFfIMULBA2l11JvstqurZvSoGX36qItHs8DIN1qsnEfoVaTaES+
         IGdSc4WgHoKYgJbeYmtL6DxV3M7Ifjnbt23iDuSa3BA7Szy2838CCveQQs/XElpWznN8
         alcOACr6VrPT9+DmM8ROYMm5EqY+Lno+QZ6omVbihWH1N0SwX+qjrNAPiHoNOly44DkK
         Hub0pOmgLfn+T62btisPy5NXMhDEqtt9ATNtdjQsfZ6fpnLyLnPZTenRV9yWkHRoATjJ
         Uewm1JxRSh83BjAYUUJVCrs396P6orRjfC0nh/pkBFgMKUplbZFsnmJw1vRLI2KXNHCf
         SFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KMEAgxnLavJYQ3i7i0cZ9PJqwCosdeDVQ11vARt76rw=;
        b=YRizbMu+ZimRXzIbPpDAmwsf27GStFf+CwWdYFRggjKAwl8ukBxnSixS/FOsYtAcF4
         CdGH0WbqK7NugCJTbDv3+gbD7wq7G4gEOvx1n7EtQAy5ESWPVR4C8yvVXnAJvYKjx5uK
         P73Aw8zpPC6rLnA7owRZoM0Ci71hHgeRdEh6kJPj2cjOTosgt3iEI/UDZkxw5rfuH/7N
         aAX+Qdtu0X4rsaNqnFIkWgm0+sJsFZf64QehfyaMYU+gZFQwoPj16ZLWS7jdWTyh99Ez
         woPBz4S+bglTG0eJ3PrZcdVzKIvfZYREwqGv9Cu3wjE+yoOowj/Z07jberuda/DG3IIS
         JjgA==
X-Gm-Message-State: AOAM533qSzuzfqKak3n5RJPYzS6N3Txw5sQk0o5eiYiVrvZmldKzjKR9
        OMGp9vq+1rJEJQu090oyj08=
X-Google-Smtp-Source: ABdhPJx3Io9I5JNxZKonQPoNMYC4/SzjvqW41agp76wDFbPJkY6smg0PkhIQ/Qjnk3DdOkmyGNYFGw==
X-Received: by 2002:a17:90a:1a42:: with SMTP id 2mr1569913pjl.16.1597998725448;
        Fri, 21 Aug 2020 01:32:05 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id x23sm1617741pfi.60.2020.08.21.01.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 01:32:04 -0700 (PDT)
Date:   Fri, 21 Aug 2020 17:31:59 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20200821083159.GA16579@f3>
References: <20200821070334.738358-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821070334.738358-1-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-21 15:03 +0800, Coiby Xu wrote:
> This fixes commit 0107635e15ac
> ("staging: qlge: replace pr_err with netdev_err") which introduced an
> build breakage with dumping enabled, i.e.,
> 
>     $ QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 QL_REG_DUMP=1 \
>       QL_IB_DUMP=1 QL_DEV_DUMP=1 make M=drivers/staging/qlge
> 
> Fixes: 0107635e15ac ("taging: qlge: replace pr_err with netdev_err")
			^ staging
> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h      | 42 ++++++++++++++++----------------
>  drivers/staging/qlge/qlge_dbg.c  | 36 +++++++++++++--------------
>  drivers/staging/qlge/qlge_main.c |  4 +--
>  3 files changed, 41 insertions(+), 41 deletions(-)
> 
[...]
> @@ -1615,7 +1615,7 @@ void ql_dump_qdev(struct ql_adapter *qdev)
>  #endif
>  
>  #ifdef QL_CB_DUMP
> -void ql_dump_wqicb(struct wqicb *wqicb)
> +void ql_dump_wqicb(struct ql_adapter *qdev, struct wqicb *wqicb)
>  {

This can be fixed without adding another argument:

	struct tx_ring *tx_ring = container_of(wqicb, struct tx_ring, wqicb);
	struct ql_adapter *qdev = tx_ring->qdev;

>  	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
>  	netdev_err(qdev->ndev, "wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
> @@ -1630,7 +1630,7 @@ void ql_dump_wqicb(struct wqicb *wqicb)
>  		   (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
>  }
>  
> -void ql_dump_tx_ring(struct tx_ring *tx_ring)
> +void ql_dump_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
>  {

This can be fixed without adding another argument:
	struct ql_adapter *qdev;

	if (!tx_ring)
		return;

	qdev = tx_ring->qdev;

... similar comment for the other instances.
