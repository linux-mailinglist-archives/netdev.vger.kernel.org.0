Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B81B432A43
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJRXVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRXVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 19:21:49 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8035CC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 16:19:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a25so5367335edx.8
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 16:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WIyrb6H8uXc5CpgxRZdTvrH029u7SI+SbfPAaiQhROI=;
        b=Dg1Ya2oKPYXd+RZaOkQNYB7KEuQ9bdmt2/cNrVUbpau2zc5h+1T/V7vvTxOmET4C34
         njyUxiGUp6RsPzgfxhjoxgTqz9R5T9nMeCUfJFF2VIGwpZpN+8sK/UiLlFj/lbQOuIgk
         YZXhIzOhBPtnr+i7Dn7wR7YbYIgRW/Gng3N8N4CGh+azTcJm/xsH6llSo0uFzBxNXfB/
         KCVmWgG0IEySl5n0z+mV5fkT1sL6SRhLVRqz6fLJ/dFDY2Xm4G3X9Vfvi2s61xXyhrMU
         jSnGet4W8ZUJ2MXo5ID2rLVxyAAPpzEaF/1omIImUEGccJL4LD3NfA9eNBzLu9gKIB7d
         qUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WIyrb6H8uXc5CpgxRZdTvrH029u7SI+SbfPAaiQhROI=;
        b=CLBWKcu1eb0jiGpJFFX2FCLSwIV7H3WN60LglTUolzSS0pI3Zq5zv0mLS9h1XzPY22
         Cs2AW6cxSQjd+EUoq79eAP9z8uohE3lKlvoLQS+QJg/o2n+fbHFq0T1w5exnlgsf2HwX
         4tjFxaptnKrmPkgTwMGLKH1K405uZaNWPdaqm181ZnriJ7geEYeKUJPvu2V/m3Vwgu8V
         qrU7LHkutup+KeCm2GXwHUP1NdSfS/XfL6hYdzO09H5v43P6jJ44xRtGsMmDAaytEJb6
         3u/twe4xUSzhnm30M2+qgrScFGtcCOxhyxxjiXMz71B8AAcCXFDt29nSuS82J8+IVmoa
         bo1g==
X-Gm-Message-State: AOAM533dexbI8xj2gM8CE8auiTmEBmePHY9ZkAsb5WVsINOmrAsaXyRY
        K42StBC/BXGpHyvrNZ8BlEY=
X-Google-Smtp-Source: ABdhPJzXXnOtATPUwyBXZA8FzGdr02gkFlC9xFjN4VnL5QvYGNFHGH7mOGl21DcCmoG8MJmYo6Fc8Q==
X-Received: by 2002:a17:906:2bd5:: with SMTP id n21mr34683246ejg.337.1634599176174;
        Mon, 18 Oct 2021 16:19:36 -0700 (PDT)
Received: from skbuf ([188.25.174.251])
        by smtp.gmail.com with ESMTPSA id m9sm10288199edl.66.2021.10.18.16.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 16:19:35 -0700 (PDT)
Date:   Tue, 19 Oct 2021 02:19:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io
Subject: Re: [PATCH net-next 4/6] ethernet: fec: use eth_hw_addr_gen()
Message-ID: <20211018231934.r5vsnfbx7fwqujkt@skbuf>
References: <20211018211007.1185777-1-kuba@kernel.org>
 <20211018211007.1185777-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018211007.1185777-5-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 02:10:05PM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
