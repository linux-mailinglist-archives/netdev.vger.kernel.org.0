Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9262C3835
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgKYEnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgKYEnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:43:16 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E737BC0613D4;
        Tue, 24 Nov 2020 20:43:03 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id l17so1288723pgk.1;
        Tue, 24 Nov 2020 20:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WgwvIE+SYJNhqADKQZurakSjkdWc52Z6zNoc9HGWK/E=;
        b=u+gTAkG7TRnXQQyxFbV4O/o++vcK3Je5QsfaGcBDaaDf1H+hl1GwQhy8MMHAb3SPzq
         H06w+2QpAjMOQR+6E+yK189WGcRtUQj7fUDFSm+SIqqENspIReOTxNAy0mflASfMfsK1
         IH0Lqjo3GsJweS/gfEMGJn177FF6XlIhrI73BLExxDkvQjcs1ebYtklrKk9ueB5GSBZZ
         soBOKjVvCp+iM32y0xjIM8OfwHLpwuEwxnJRfTBxs4h/S2KdLfM5NxavMldYPzHt/z/5
         2NRtuONGmq3A1SgSE+F4Q8en3KPvpH7otic+cKDltC/gylbtEMTO4uFU//G+sedbHSPw
         uvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WgwvIE+SYJNhqADKQZurakSjkdWc52Z6zNoc9HGWK/E=;
        b=cBUBiVJYw/z5y8A/9Q78DP6n5uRb1wq5UbcZ+Yu7zew/SDlKuzGcl4Cox9Spp72cri
         JMGL3tqvKqYq+wveGHrKS7K8Rffglxoy6ywYiyjzFYi5AWviJ1RXYQZI+QEGS7tQWSgm
         93eIWWe46zwq8DgMXOajIBmRUWAA8L7e/xTey7HzS6zQlQUGuKKVjYMpOLls+7x0J+G+
         +beXspUjvpZW9YwQic8fZQkCo2oHu3Nv6USgZlbSC29p8kqsVBtyldjsTiCwA4a3mVL7
         eoH3MFZE3vBR8GrtKG7Buif+NfaH9K6GCbM9rf7Br2TT3TkAK4sQ2vURcqKnUl9lNP0Y
         lxIA==
X-Gm-Message-State: AOAM532IqBUdkndrp4iQ3ptgJdZDW5GxeOzF8GXvyfaIRJT0n85EFd1J
        Y9XfVotB3fTgyTb6M8170GM=
X-Google-Smtp-Source: ABdhPJwpT35k8tzGkp7unYNbt9QDIr3R8n8s1F35Y7VWvmB6cP19Xflh8P7ICspTdg9F8JP2GuZ2uw==
X-Received: by 2002:a62:864a:0:b029:197:ad58:4184 with SMTP id x71-20020a62864a0000b0290197ad584184mr932183pfd.55.1606279383324;
        Tue, 24 Nov 2020 20:43:03 -0800 (PST)
Received: from f3 (ag097173.dynamic.ppp.asahi-net.or.jp. [157.107.97.173])
        by smtp.gmail.com with ESMTPSA id j10sm830146pji.29.2020.11.24.20.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 20:43:02 -0800 (PST)
Date:   Wed, 25 Nov 2020 13:42:57 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 127/141] staging: qlge: Fix fall-through warnings for
 Clang
Message-ID: <20201125044257.GA142382@f3>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <673bd9f27bcc2df8c9d12be94f54001d8066d4ab.1605896060.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <673bd9f27bcc2df8c9d12be94f54001d8066d4ab.1605896060.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 12:39 -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/staging/qlge/qlge_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 27da386f9d87..c41b1373dcf8 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -1385,6 +1385,7 @@ static void ql_categorize_rx_err(struct ql_adapter *qdev, u8 rx_err,
>  		break;
>  	case IB_MAC_IOCB_RSP_ERR_CRC:
>  		stats->rx_crc_err++;
> +		break;
>  	default:
>  		break;
>  	}

In this instance, it think it would be more appropriate to remove the
"default" case.
