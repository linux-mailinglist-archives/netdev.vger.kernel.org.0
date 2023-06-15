Return-Path: <netdev+bounces-11143-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0373731B3F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:25:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1228E2813C9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63139174D6;
	Thu, 15 Jun 2023 14:25:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E86168A2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:25:10 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD3E1FFA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:25:08 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f8cc04c2adso20013095e9.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686839107; x=1689431107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YnRaEq/R+qqN1l7MGLXRX4Jh2MLTeQ4xQu8xZjVF/9E=;
        b=noOMb35ytk+HSd7Sg7wpxWDhOqSYGWdXJ1rDSk0c9X/IZBV4KKQPOSTUPqjUnWYxPP
         pwIBnqTXLACqrH4kXUWkEioaJ3k+577u5bA5fZ7e9Ngr7K0ctQxKXtHPjDqVS1Cy/1tX
         X2L4wpGgPAxCsCAJUlAsQnTVCJSicdZb9Lp35b4SllE5FAln2tH/a/9lumdApRtSdUHB
         cWUMV10MSSClyOgvTosV1zEkcK/2Tnmm/x6t4w5aM36Ey5J9stGpw6Z5MNZbj0mzE1eV
         zU8nWLgf53oKIvcy8SZo2cJy8Npxbyq7IyyO675lDngEHZzx23kB6x42PzsEZrtJnphS
         sa6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686839107; x=1689431107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnRaEq/R+qqN1l7MGLXRX4Jh2MLTeQ4xQu8xZjVF/9E=;
        b=jyR60cBBw1wrmKoIaZLQIek4Vl3MEHkCaL87LaKAh0zm8fLZIPy5BJv026xzF7MN6Q
         fcQvlDnWLtPnicX3JOl3Vd/iwdQcCPZODf2d3ArPSmoYhLSWZ2gMbVpw1PQPQ+csLWvw
         lpoZXuAVZwY0irkhbZJliCyjpg8VGV/gQ3v+6LsDeT0E4WRF00mZEcoUi7qLdN0GK2P2
         jbufweJE6KgAFtcVRMdsUk5yQ0OXhyJIEjIjjuOXvkxSmzGplEbEu64kYqfUCaHD6KDC
         LCXRR1YyhwNcStrbHzuL/BaTVxDNJtgV0Ujp8lISoaLqNbYTPjJRSGGCuHurcSkv4AMV
         PGJw==
X-Gm-Message-State: AC+VfDwrvJ+ZwEw+7FWiJPLSRdjj3p/9i2PEwW1kOZhh3AHmMcuNcAGH
	qP305hGJbXwUXTrXIQAdk9xBKA==
X-Google-Smtp-Source: ACHHUZ6/POVDebMNcxTEAlIgxHE9CAAQgcjr+eY2tthAxS4zMPp+MzA34nBwadH7vsqmMHlo1hEzlg==
X-Received: by 2002:a05:600c:255:b0:3f6:53a:6665 with SMTP id 21-20020a05600c025500b003f6053a6665mr16182726wmj.19.1686839106865;
        Thu, 15 Jun 2023 07:25:06 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0acc00b003f195d540d9sm20654630wmr.14.2023.06.15.07.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 07:25:04 -0700 (PDT)
Date: Thu, 15 Jun 2023 17:25:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Simon Horman <horms@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andre Guedes <andre.guedes@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Kauer <florian.kauer@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jithu Joseph <jithu.joseph@intel.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Vedang Patel <vedang.patel@intel.com>,
	intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH RFC net] igc: Avoid dereference of ptr_err in
 igc_clean_rx_irq()
Message-ID: <278e2ad2-847d-44a5-9bfe-46e11f4fea80@kadam.mountain>
References: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The original code is okay.  Passing zero to ERR_PTR() is intentional.

On Thu, Jun 15, 2023 at 11:45:36AM +0200, Simon Horman wrote:
> In igc_clean_rx_irq() the result of a call to igc_xdp_run_prog() is assigned
> to the skb local variable. This may be an ERR_PTR.
> 
> A little later the following is executed, which seems to be a
> possible dereference of an ERR_PTR.
> 
> 	total_bytes += skb->len;


There is an IS_ERR() check in igc_cleanup_headers() which prevents
this.  Sort of tricky to see.  Do you have the cross function database
set up?  If so then Smatch shouldn't warn about this dereference.

> 
> Avoid this problem by continuing the loop in which all of the
> above occurs once the handling of the NULL case completes.
> 
> This proposed fix is speculative - I do not have deep knowledge of this
> driver.  And I am concerned about the effect of skipping the following
> logic:
> 
>   igc_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
>   cleaned_count++;
> 
> Flagged by Smatch as:
> 
>   .../igc_main.c:2467 igc_xdp_run_prog() warn: passing zero to 'ERR_PTR'

Linus once complained to me that this check is bogus and passing zero to
ERR_PTR() is fine and an intended use case.  But actually this test
does really find a lot of bugs.  I think for new warnings it is less
than 10% false positives.  But we fix the bugs so warnings which are
over three month old are probably 97% false positives.

regards,
dan carpenter


