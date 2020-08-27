Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6326253B2E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgH0AuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgH0AuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:50:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2559AC0613ED;
        Wed, 26 Aug 2020 17:50:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id nv17so1723078pjb.3;
        Wed, 26 Aug 2020 17:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=01YFLAfnv3/LfrQ6AMD8+CvxGlBa3HTAm4LPxhm+Idg=;
        b=B+6UCaLJsBl1hMKapCRgSQ6Hwd2zFxjYus6Y15XT4Cy9iuC8ij/N26dD3haZb+kVkp
         Q13NM075KRBNz2OfKiS7OD00MMpazEN/zLVx3ipNB1BkhkPJIKpnB2ekxbJ9YebgcZzn
         ZuIJMANcMnPpHYPgx1iWWi06PvRjJwLWlFxCJsJyrfrZliFoc8lGJrG+kg4v+wa7QXJ8
         +p2eNUTfwZe3P43Gl0ThINYRBvwEhRpQzpB0PF9UUfob6rsAwrtKFKXDd0gfMzNb1Ojj
         YpiXAKz4EjEnaCAtbSC8Z+s6jdNhMVPFCNIavFy5HJEVDvWykUVfYwbEeriI85pTqCYQ
         YHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=01YFLAfnv3/LfrQ6AMD8+CvxGlBa3HTAm4LPxhm+Idg=;
        b=PfuH5RRICPzfNudKvONBjMd3T9YhRRkkhtPuUdaSD6w1L+zshkt3UX/vCHjq48gob6
         Bq78xcRI3qZpl+qEsdWa8yb5CAfKSBgP2xTMQ4yA3FKMBLujo4eMed2k29UQB7lvv03N
         VA56Nocw5l9ynLZpAPFaLWzydo25TWLbTBrAH28Ri7iTJCaufyb8efAuaVMzAixDNHyu
         bEWV2Qoa1pqpxK+aYe/htsXxi/4Z/AcoWaoKytP59sZzqRicWSIRvVYwX6w3u1H0wNsa
         zaiA48PA7EO1QVMpbFukgKowIMMMWVoHQyEp3lBaPzFes/eA6pceMVPj4ZKCcCF46shD
         9FdA==
X-Gm-Message-State: AOAM530PXCvhYmSyCgfnaCOJXfd8BGiznrmJV9yfLqd7dzqTtRmLC0hI
        p4lPy+34mosY9QkdVrN0xCY=
X-Google-Smtp-Source: ABdhPJyWvL6MEsyGNAUHVPFOU5eGcHfZh0/qeMDJL3X6V0nlT7oVAouiH6CJpFg5RGEU7VyhfouOeg==
X-Received: by 2002:a17:90a:c704:: with SMTP id o4mr8207536pjt.146.1598489417589;
        Wed, 26 Aug 2020 17:50:17 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id z23sm209360pgv.57.2020.08.26.17.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 17:50:16 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:50:10 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20200827005010.GA46897@f3>
References: <20200826232735.104077-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200826232735.104077-1-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-27 07:27 +0800, Coiby Xu wrote:
> This fixes commit 0107635e15ac
> ("staging: qlge: replace pr_err with netdev_err") which introduced an
> build breakage of missing `struct ql_adapter *qdev` for some functions
> and a warning of type mismatch with dumping enabled, i.e.,
> 
> $ make CFLAGS_MODULE="QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 \
>   QL_IB_DUMP=1 QL_REG_DUMP=1 QL_DEV_DUMP=1" M=drivers/staging/qlge
> 
> qlge_dbg.c: In function ‘ql_dump_ob_mac_rsp’:
> qlge_dbg.c:2051:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
>  2051 |  netdev_err(qdev->ndev, "%s\n", __func__);
>       |             ^~~~
> qlge_dbg.c: In function ‘ql_dump_routing_entries’:
> qlge_dbg.c:1435:10: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Wformat=]
>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>       |         ~^
>       |          |
>       |          char *
>       |         %d
>  1436 |        i, value);
>       |        ~
>       |        |
>       |        int
> qlge_dbg.c:1435:37: warning: format ‘%x’ expects a matching ‘unsigned int’ argument [-Wformat=]
>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>       |                                 ~~~~^
>       |                                     |
>       |                                     unsigned int
> 
> Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h      | 20 ++++++++++----------
>  drivers/staging/qlge/qlge_dbg.c  | 24 ++++++++++++++++++------
>  drivers/staging/qlge/qlge_main.c |  8 ++++----
>  3 files changed, 32 insertions(+), 20 deletions(-)
> 
[...]
> @@ -1632,6 +1635,8 @@ void ql_dump_wqicb(struct wqicb *wqicb)
> 
>  void ql_dump_tx_ring(struct tx_ring *tx_ring)
>  {
> +	struct ql_adapter *qdev = tx_ring->qdev;
> +
>  	if (!tx_ring)
>  		return;

Given the null check for tx_ring, it seems unwise to dereference tx_ring
before the check.

Looking at ql_dump_all(), I'm not sure that the check is needed at all
though. Maybe it should be removed.

Same problem in ql_dump_rx_ring().

>  	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
> @@ -1657,6 +1662,8 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
>  void ql_dump_ricb(struct ricb *ricb)
>  {
>  	int i;
> +	struct ql_adapter *qdev =
> +		container_of(ricb, struct ql_adapter, ricb);

Here, davem would point out that the variables are not declared in
"reverse xmas tree" order.
