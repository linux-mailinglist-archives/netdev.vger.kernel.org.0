Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0F322E73
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhBWQMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbhBWQMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 11:12:22 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3761DC06174A;
        Tue, 23 Feb 2021 08:11:40 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x129so4337567pfx.7;
        Tue, 23 Feb 2021 08:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LupjWLkRUOq+CiPsIGPEup0J7yFrkHdOXthev84cAN8=;
        b=msrwyp8/10qWFaWV+seEtedLa6l55XeaIG7sHc3PceJpDJQ3ujkK+1g2IrJ3ttipSq
         SbjNQpm1naE41eNLkJZ62Rvb8PyJeS1n92eiqSLVOTvLynGkqUlXV0YsI8VBJqTPV6Kk
         aTT14B+00rLsZC0dOZCA2KBp1TuVnCVz9pPAvu0ot8qr25mLzAr67u4f7XJxVFLPILCD
         8QyWcFJVU59oSiyi7zlfiBz+3N7gCxvyaQLZVP5IIBsn+cVgQkJT0u9MwHLU0p/ctP/E
         ssrHQwat8k6JAT0AT4FIoU3HINErHBR7e3en2AlzQ6iyayAFGLpIVmE8UjAAZVOcrDl3
         BiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LupjWLkRUOq+CiPsIGPEup0J7yFrkHdOXthev84cAN8=;
        b=rxjaZzwdNIzMlDeMBW7x4sKZcM2faYB8Fo/ojdVY6axyRtAs4T0xuO4uDjyQKpr0e2
         2Cdbx/8QeBb9oD+VnrSebTt61C2iME3ngk98Fgk5wCqdbNNh9C7zfjLSFv7uc+WFKJxV
         RmTx+J4Yw/e9qklkXA72HNrASidcfXcOA6Nfi0giv1FcLhPyFGoJ959UbWmTUk85C6XB
         JgBM7D9uK92dCYddTSXRrOZsQkpBekKKOjrNysfA66GkkxMj69yT4pDWmSx6PXxHLKNm
         YgunUD0x/AvJuJ1Eu2gLlzM3bRyHQgdJlqrytEzak5/ggBPY+kOtuV1Kl4YeODNSLBba
         /VDA==
X-Gm-Message-State: AOAM532mdGSoYH8u3p3w4Ggg/oV7DVnSZh1SwSP0GPVqdGtCzRqhJj/a
        B1ibiiEzGoRzlvE8k9d3yOE=
X-Google-Smtp-Source: ABdhPJx1KhBoDX46FEgvuyi7wjsYLghYVyibp9XH5t2NCEv6aStSgIjIwLeNjhZ8aDjzeIlG6eHQIg==
X-Received: by 2002:a62:ae18:0:b029:1ed:ac95:d8cb with SMTP id q24-20020a62ae180000b02901edac95d8cbmr9539294pff.69.1614096699775;
        Tue, 23 Feb 2021 08:11:39 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u9sm3755812pje.20.2021.02.23.08.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 08:11:39 -0800 (PST)
Date:   Tue, 23 Feb 2021 08:11:36 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
Message-ID: <20210223161136.GA5894@hoboy.vegasvil.org>
References: <20210220065654.25598-1-heiko.thiery@gmail.com>
 <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com>
 <20210223142726.GA4711@hoboy.vegasvil.org>
 <CAEyMn7Za9z9TUdhb8egf8mOFJyA3hgqX5fwLED8HDKw8Smyocg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEyMn7Za9z9TUdhb8egf8mOFJyA3hgqX5fwLED8HDKw8Smyocg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 04:04:16PM +0100, Heiko Thiery wrote:
> It is not only the PHC clock that stops. Rather, it is the entire
> ethernet building block in the SOC that is disabled, including the
> PHC.

Sure, but why does the driver do that?

Thanks,
Richard
