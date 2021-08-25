Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC13F6D4F
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 04:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbhHYCJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 22:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbhHYCJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 22:09:02 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B7FC061757;
        Tue, 24 Aug 2021 19:08:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j187so19961479pfg.4;
        Tue, 24 Aug 2021 19:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w9co/Z3JPFE7W47WAwwudJGkR309x+OS12nqwpHf8Y8=;
        b=KcTYKsZI4og0V07s0t/UEUL5/aCBPQvJO80104Uqe1nWqW4s2B/6gO/Aqf9WpFydRm
         Lk905uu8rLSokyCH6RSoA/9qeKpceNOwiQYQr+AV+Ln+YxR5sHyoHyODTIyrax6u/faZ
         qX73Bn0pm+H9Rx0dSfw3oimlg6HZfaiom8yKEzU/2kZWh+1gsf4iC+NIRZHSXrKOl5pZ
         Ke4CEMoQCvz9U4D0+3ytjrsk2wXPoMDrWJIk+HW2UZ59h95oM98hlYo7TxO7+IYd47C4
         STyqBWq+1zQaq/Zq1IWkdKLjroVxwtXNwHEqNGJfqrBpQKciY37m6LU5r+3YshYceyYv
         qGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w9co/Z3JPFE7W47WAwwudJGkR309x+OS12nqwpHf8Y8=;
        b=t7m0O+nb8TqZaOxbS1QtH3mNqCHub3FB3JgZnuPD3LqQyb4PZ05LnDKWEVZhpUvz93
         gU+rRp4UisHeYxv2Yj8l+RBMF29dVYGNNpzIo8+b3F/j6VVMdtDbfaL4zeNU515lJxsn
         4BqWVbZvvF+CjgSkh6ebtyHrVPSO6Vw/zb9VFRum+EZQgkJjoU+7nBcAV8ADk51epS5k
         86cat9QK+QXuV7ygU37pDRfIXAQGSkN2QrPwVkrzDK/+xqYB7iI+nOuEQtRTqepDVqCb
         h6skw53cXiM2PRDXqwOZkvQv8vrV1cG/wUXGIcInK9njkenowaCilxd/r9AMhg3Rv+BW
         i3yw==
X-Gm-Message-State: AOAM530fOFL5djLKMDE48//lVsSKHP2s8wpIm/srAkVeEtbOhl1Ju4ZO
        id+9PZnewX8O6tMPAX2llmU=
X-Google-Smtp-Source: ABdhPJx16wW1ttpl7E5qo06Nx9PsX8rFidufdQRkMkUHx6+dDKFDBx8u4hMUrHK5gpJN19nWx0JOPQ==
X-Received: by 2002:aa7:8746:0:b0:3e3:e45:f726 with SMTP id g6-20020aa78746000000b003e30e45f726mr33052339pfo.47.1629857297543;
        Tue, 24 Aug 2021 19:08:17 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w2sm3559244pjq.5.2021.08.24.19.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 19:08:16 -0700 (PDT)
Date:   Tue, 24 Aug 2021 19:08:14 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Andrei Pistirica <andrei.pistirica@microchip.com>,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [RFC PATCH] net: macb: Process tx timestamp only on ptp packets
Message-ID: <20210825020814.GB25797@hoboy.vegasvil.org>
References: <20210824101238.21105-1-harini.katakam@xilinx.com>
 <20210824140542.GA17195@hoboy.vegasvil.org>
 <CAFcVECKXOVwpsR=bEUmTXZpSQTjez1fjf1X9bXV_sFCe_U3_qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcVECKXOVwpsR=bEUmTXZpSQTjez1fjf1X9bXV_sFCe_U3_qA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 08:59:20PM +0530, Harini Katakam wrote:
> Yes, there is no SW overhead because the  skb check ensures timestamp
> post processing is done only on requested packets. But the IP
> timestamps all packets
> because this is a register level setting, not per packet. That's the
> overhead I was referring to.

But the IP block time stamps the frames in silicon, no?

I don't see how that is "overhead" in any sense of the word.

Thanks,
Richard
