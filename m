Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D60A39CC05
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 03:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFFBFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 21:05:33 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:43939 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhFFBFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 21:05:33 -0400
Received: by mail-ej1-f52.google.com with SMTP id ci15so20449730ejc.10;
        Sat, 05 Jun 2021 18:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K3QT/luiltDMXGTueO6/nzzVpvGtP3BJwTP9aroO22g=;
        b=CBQWE+ojexCOCiPljOBPeHtDH+SIinzvpdwG+W50KMiNz/fFVT7KmL5O8OZ/j38G+O
         P5lEPRQv8uAkvb0ElV5I2yQlgQGen47Um6m2pnfLZ8qVxSv2MJhhE+euZ7aaNoHsUV9B
         iIcsJdSIkGSxQPHZexpmBji/zB6IxKljx3gaH/FFY7Ljzx2OhhxjxOUg+1NFHf2l5jPW
         YrtY5xdKdGvdQRhfZt2ru+DHtZrI/VcRWgH9D7Ooz1lMfnlG0sD0u/7XIq/bZ1CJVRWu
         6ou+US5HRhuSFCr0Sor2dZRcAi+8+8P/vB0je6ifJmUz/P7boUdI8myF9jDxpH+VPE4V
         TZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K3QT/luiltDMXGTueO6/nzzVpvGtP3BJwTP9aroO22g=;
        b=dyDAwg8JmPqF9jEoMf8HIGvzrsed+GmFNJW/8Pwsr0clgZOntiC21kM5Mo/90jT/kZ
         2GDevtkWQr1eeTDMwLi6OwAK7KIfyXYr8S1GpqmpZyMdzypvNZvPLjf+EItSrp8Vh7Ol
         3bTOu8+9HXpdvr0gKkoDDJJpl2DdLcpbTY8ujM0ipJ6SJ+WIjjKxA3FhhRgKv+mZ8+oO
         EXxX6h9fgBvAfxqOkVAyVj0yv/bTnNYkUhW6kOWQOsvtoWBrvyqfJJQ5IreDgMzQp0lU
         By/YhUCTOdJtiCYsT2yNvOzxqUDWsuEzM9xC4DXat0/xZKYB0UPNmnUVZpZTDh6roj5r
         jjYQ==
X-Gm-Message-State: AOAM533bgxN+7LTppBQ78WdQU+03s/8bdn+l7HJ8tsLu9+56crO7htVJ
        Unpkr1aAhZPOm74qafbZRTFbOjVN9Og=
X-Google-Smtp-Source: ABdhPJwXNc9xuCFOiEpzcS74zzbJpZTODFy3nZ6of8PG5Gua1S8YfClWrMsumJFBnGqtxZYxsckMgw==
X-Received: by 2002:a17:906:7d0:: with SMTP id m16mr11410853ejc.319.1622941363548;
        Sat, 05 Jun 2021 18:02:43 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id q9sm5497406edw.51.2021.06.05.18.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 18:02:43 -0700 (PDT)
Date:   Sun, 6 Jun 2021 04:02:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next v2] net: mscc: ocelot: check return value after
 calling platform_get_resource()
Message-ID: <20210606010242.ymvkn2ccdg5ypaji@skbuf>
References: <20210605023148.4124956-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605023148.4124956-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 10:31:48AM +0800, Yang Yingliang wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
