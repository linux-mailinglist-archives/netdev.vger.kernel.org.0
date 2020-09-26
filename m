Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05606279C07
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbgIZTGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730085AbgIZTGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 15:06:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7607C0613CE;
        Sat, 26 Sep 2020 12:06:19 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so3021858ejf.6;
        Sat, 26 Sep 2020 12:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jdpNmVsYSzBKZ7GyovDeybfaKyQkmyb4kGF9kkOcdDM=;
        b=D19epkDfDKlx8L/z/kV+eTgTDZZiVLmVHtmUiCCF1gXlgkM5zW7hyCqHqQGojt/JMh
         RvWcHV7bJdyI5SL0GXE/bj2cyCW7Lgt9OS+Ys1cr0uGJ+yh4MYRYTOXStDDZSBEty5BP
         H2+ur3WMnhfwSs+ncnUBaMIHMHl6CG8QE3PGjTzL9aCItS+f//QmvEKCQwc+iI8mHC7p
         qo1F6BmB73C+Gfg7APwEdg0DSllb10bpk4hz3QwSwIVtXmDkFugNTg7ybECkAA/biSKX
         SVmFw7Kls7oI0YCzBlDv0Glt2nFxRtWUtTf+DtkO6fnMavYwBKZPHImd+tzRHsZVqoSd
         nURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jdpNmVsYSzBKZ7GyovDeybfaKyQkmyb4kGF9kkOcdDM=;
        b=SLNgR7xVLv7Xj8yvM6+G9Zdxoi7gDcL2QaGe67WTWpchVuv5KR2iJ0Wc7+UXOVwyVT
         8jUv/N7SW21iNBhsI774K1MvbprSqFf072+pb/zbuFyN1xhGb6v7Ziuqk+etH9LU0PPt
         bgrw8mdwSCnJPO2hvD4y2u/Puz6jTTNOzHuwp/0/YnP9M6tLFIThY/WjnWUYo3I4iNJw
         froygDYE92G98usRzHbA2odz7Z6BIAqQn7pxrgtDr2eFQorX8kixaU1DLEFqiDFzBF1+
         JmPU6yrnRlDhuhTve8GB/TromzErucK+yA1d1xjqnI+Corzr76l6m/3r+Wq2xK6VsUMY
         NrlA==
X-Gm-Message-State: AOAM531Z4Ss3QNJhB1lvqtCzRey25cWFj768G3VD2Ofq9P5kar1v7ury
        gPhL/pvJHTGa4OXBbMf/u9A=
X-Google-Smtp-Source: ABdhPJyHbX7K+XDLfQ6ZN4OZPMiwHyINJ15cteuDctCsccljAKyOSrNOr6kpMYOWGSC8LQ8op/nhGw==
X-Received: by 2002:a17:907:118c:: with SMTP id uz12mr8391381ejb.321.1601147178579;
        Sat, 26 Sep 2020 12:06:18 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id z4sm4940667ede.65.2020.09.26.12.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 12:06:18 -0700 (PDT)
Date:   Sat, 26 Sep 2020 22:06:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, hongbo.wang@nxp.com
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
Message-ID: <20200926190615.fgzmrnxdo7doc5dt@skbuf>
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com>
 <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
 <20200924233949.lof7iduyfgjdxajv@skbuf>
 <20200926112002.i6zpwi26ong2hu4q@soft-dev3.localdomain>
 <20200926123716.5n7mvvn4tmj2sdol@skbuf>
 <20200926185536.ac3nr6faxwvcaese@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926185536.ac3nr6faxwvcaese@soft-dev3.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Sat, Sep 26, 2020 at 08:55:36PM +0200, Horatiu Vultur wrote:
> No, you will always have 4 Type-Group values regardless of number of
> entries per row(1, 2 or 4).

I think this one phrase explains it for me.

> I am not sure that I understand what you want to achive with this or
> something is still wrong.

What I want to achieve is that I need to port the VCAP IS1 and ES0
constants to new hardware I can't test, and I had no idea how to do that
because I didn't understand the relationship between what was in the
documentation and what was in the code. Now I do, thanks.

-Vladimir
