Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CFD36F338
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 02:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhD3Aq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 20:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhD3Aq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 20:46:26 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E753CC06138B;
        Thu, 29 Apr 2021 17:45:37 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id d19so33451115qkk.12;
        Thu, 29 Apr 2021 17:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xqlg0NQkL0tit0JFyT2/uizC4Jo87izc4FKzhw46Z50=;
        b=Iu8H0cQXdM9Kn0DUDnk7IsuEf62oE35eCHT0rAMvUFXC03eWwDVVPJS6zdktxC89d1
         KzlHC2dB4fJh6B8R+uMQ0iOpJ0WNgsH2ulzVyLIi+3tNwBQ8okMcoTH81e3UgbRBHlsj
         KYl25rmMT6kB0OriRibFIBNIY1WR1gbNTa19aHyvFchgfYDL4AAZeKQh6phZmcliPZmc
         dJP637ULyKhH+bWG/buWS9jkRP0Bulnwx0P4iTeKuwSXq0CZY1a7tQxHMx1GtKsB+nmL
         NYmtYKHt+lOdjRQ7KyB5ra6PxH4E3Qj/mOFOnylwJXjHCRKauM+9TKoc8k/fmA02rJGf
         RF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xqlg0NQkL0tit0JFyT2/uizC4Jo87izc4FKzhw46Z50=;
        b=svP7wn3JvHRsLJajVfYUz4Ztag1+z5WgKbVVKA+ByLDMccUVQRTqA9E4chqvVgBelL
         EzXiViBFDdS3ShbPtIDbEI93OGyxjSQ9tHXSso8P4wlszlS2ivHkFP3/EXCKvD7550hv
         tkDt6itp/XDCdyV1M8vtnruuD9cqc5cLNAD+BHxJ3QK1RsrDCrTO0Tp150WfIukLFZ9b
         i631xf8FFIOnk15rBw2RMVX8hMmetKyskwc8m3CzWg+WFxQoPGWpBXRQ6Z5PCf2VYFqY
         LXAloLpvBs1ANOENFD6T/2kDqrqq/LDeiszznmTsv1a2UbJUkEHNelQdLqusXIXxuY6F
         /AUQ==
X-Gm-Message-State: AOAM532mUaWT1+S7VkzDTg5YqVYJxlAFguKeeYBrU4/QAaqzMrMQtBoP
        e/8Mg0Jbj4pid19XaXNFjF5eYVThdLQ=
X-Google-Smtp-Source: ABdhPJx2iIe8EJOjWv0URjED6dvU978H0cHgGdNKi/jSbC1A69kqZOTpCFSyLdPR1Vvy5c7XwGaX0g==
X-Received: by 2002:a05:620a:2947:: with SMTP id n7mr2636170qkp.450.1619743536729;
        Thu, 29 Apr 2021 17:45:36 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:14fb:c088:46f:2a8:ad2])
        by smtp.gmail.com with ESMTPSA id q28sm233766qkm.15.2021.04.29.17.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 17:45:36 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 3745FC028B; Thu, 29 Apr 2021 21:45:34 -0300 (-03)
Date:   Thu, 29 Apr 2021 21:45:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, vyasevich@gmail.com,
        nhorman@tuxdriver.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, dingxiaoxiong@huawei.com
Subject: Re: [PATCH net-next] sctp: Remove redundant skb_list null check
Message-ID: <YItTLq2SoEno830E@horizon.localdomain>
References: <1619691589-4776-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619691589-4776-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 06:19:49PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The skb_list cannot be NULL here since its already being accessed
> before. Remove the redundant null check.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
