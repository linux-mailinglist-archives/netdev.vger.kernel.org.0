Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6907E42C81C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 19:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhJMR4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 13:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhJMR4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 13:56:12 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4A2C061570;
        Wed, 13 Oct 2021 10:54:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t11so2347203plq.11;
        Wed, 13 Oct 2021 10:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3iTUUJhLly6k9XqLDlZXpNA+psd6TBjuOvHbBbNFnmI=;
        b=UXl0/0+efMnCEbjRvxKazXEpMNlKZyVGipOuZdhvO6p517UTZwIIO7c4n09w2a7hwi
         jhfYAZhLQLwTjHN6/T01lB4TIZcDmv2pzMIUVD0TJyIeV6A2+3JzZtUYkL88GUD21qdB
         56QXIxyUAY+ehJxEGgvWpwFLmG25kYy8L87r5p8DCQE9gMvwZzW1wBrTPsl1ElWVxMln
         iuvDLUTzVNFk2xDJCpp1gAiypPYUm5t7sQsSsJzkLS4EOsaFO7ZHEBzdCAko/59h6ef1
         jaL1weh0pypQuaKQVj48BjCc72DQ4/Wi4IWpy40SrkvTM13CIecNF+hiTa5SIKLqH05h
         d2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3iTUUJhLly6k9XqLDlZXpNA+psd6TBjuOvHbBbNFnmI=;
        b=EAMQZ/uAetdHrHneKOhvnH2h8hHmzuwnuUqRByDY9zVWqi6FQnN3EIS782CnV2DdFR
         ceL83aFRad539YcDXGSdjJQNc38vvyF40wOl/xIDxtqKnF/vBtbrlceL158tUwL4RPgy
         bogbe8AKiDS2dz1rvWo2IBVEW2D088wbxz1cCJ5UOUMIykew8vIi3p3G0imEb0zkhW2q
         nrIxfU6mVS1upCeCjylMaLqgeRYrbohMJ+ZI8Jq60K9C5QrFlVvbMz2Dxw+yTArqQMSB
         EBVWGOQnG+OuOkVgbm/w8SVIPR3srxL9ocWzJ1PJ74xX+KeCb3vzx2l0Y3d7NZQksMUT
         eG3w==
X-Gm-Message-State: AOAM531VPP6FZwS68Y2oJvwCQet7Nw0vH0w5wENF43MpdGoRZaWrvQaH
        cpeenzqfVIj4mWTN9zx843GIStNL4+0=
X-Google-Smtp-Source: ABdhPJwUj2pRK3kUWWmi7TFWKS0IC/u+4HG4VDLAMizNq2FFW0hlXo7WA8KeuohleQLYdnAgdWxIyQ==
X-Received: by 2002:a17:902:e74a:b0:13f:3538:fca0 with SMTP id p10-20020a170902e74a00b0013f3538fca0mr621780plf.22.1634147648070;
        Wed, 13 Oct 2021 10:54:08 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j6sm181590pgq.0.2021.10.13.10.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 10:54:07 -0700 (PDT)
Date:   Wed, 13 Oct 2021 10:54:05 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20211013175405.GB24542@hoboy.vegasvil.org>
References: <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
 <20210930143527.GA14158@hoboy.vegasvil.org>
 <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
 <20211007201927.GA9326@hoboy.vegasvil.org>
 <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
 <20211011125815.GC14317@hoboy.vegasvil.org>
 <ca7dd5d4143537cfb2028d96d1c266f326e43b08.camel@oss.nxp.com>
 <20211013131017.GA20400@hoboy.vegasvil.org>
 <646d27a57e72c88bcba7f4f1362d998bbb742315.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <646d27a57e72c88bcba7f4f1362d998bbb742315.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 03:28:12PM +0200, Sebastien Laveze wrote:
> On Wed, 2021-10-13 at 06:10 -0700, Richard Cochran wrote:
> > That means no control over the phase of the output signals.  Super.
> 
> You have. There's just a small conversion to go from and to the low-
> level hardware counter. (Which also needs to be done for rx/tx
> timestamps btw) 
> When programming an output signal you use this offset to have the right
> phase.

I have an i210 with 2 periodic output channels.  How am I supposed to
generate signals from two different virtual PTP clocks?

Thanks,
Richard
