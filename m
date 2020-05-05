Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014E41C4B31
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEEA7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEA7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 20:59:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0F0C061A0F;
        Mon,  4 May 2020 17:59:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id y6so258697pjc.4;
        Mon, 04 May 2020 17:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6SbvvHuG282tx1BJXlB+6W9tHbbfB/CsKsZjXwYQB6M=;
        b=H2EZzlddBSJ/4wSnvCWrD/5pmqfHRjtoU2walwps612vPPqT7uMyEJ86JL3FVoSx+I
         6uXIMCMBupDAKTQ90ldWxmffdz6hgMDY/Zde4Dv50VLvuJIkqhQAj+QJWnXTsoKNiQvJ
         +9RicTZtk4GQ7HvW0MvOlAkprJ17ELegTle9iH6XcDgZdGFdmw/cRbAivDgo5ru9c+7B
         z3pfpBEjCObqRWexhsU7oC14nTO3NM8yVpeHfJvPaCKzgJuE5NpYWuRcqHBE+jglpOmU
         iU3VVCj6D5VnAwyRnFSUF2DK1EY/7iovh+Q3vX54/McqcTZ0uOIDnIm6bRnCnxJw2421
         mkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6SbvvHuG282tx1BJXlB+6W9tHbbfB/CsKsZjXwYQB6M=;
        b=AJ4gB3OYY6XmDmK53g68kWq9Naen5VcJnplZHKJF1y8d3EotGu19VDni9K7/gHdWnd
         oRPDDWtY7tBg889iDsVmclYd33gewsKH7iRPnQE6xLzEvtbX9LczqwYd7EpuJl+hxulp
         nqMFpD6JlTk/n1u/jEjO3EVmbUL24qUkabmkCx2M60QSPPGH/nRdwBV1jlVK83ZZX+9K
         Tcq7Y9l4vCGUyRjlKD/gLJ5IGNhxAca1UfJS3aShVwr01wioJ6ZDCRI/3QuTdRhHrsxz
         SThTKhQuryMoe5ZUBVkH3+sn7Rt7OM72vj96bRyMXNOpiL53BxJ5G40xw716msIRah/B
         TFZQ==
X-Gm-Message-State: AGi0PuYEy3j02QCQKM6mTxiAoUGbU7kf8L654vjfPpYOs/0Ou5pj39m6
        uOgETBjSU++eR/JJH4ApZyk=
X-Google-Smtp-Source: APiQypKbwxQiSORcx46GjsuCviMeM8k4EtYU9bCm15TH/WlUMld56J2/s0aSYu2NQt5AqJ5mLiYsCA==
X-Received: by 2002:a17:902:23:: with SMTP id 32mr712614pla.40.1588640354849;
        Mon, 04 May 2020 17:59:14 -0700 (PDT)
Received: from localhost ([162.211.220.152])
        by smtp.gmail.com with ESMTPSA id a21sm298853pfk.39.2020.05.04.17.59.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 17:59:14 -0700 (PDT)
Date:   Tue, 5 May 2020 08:59:08 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH] net: rtw88: fix an issue about leak system resources
Message-ID: <20200505005908.GA8464@nuc8i5>
References: <79591cab-fe3e-0597-3126-c251d41d492b@web.de>
 <20200504144206.GA5409@nuc8i5>
 <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de>
 <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:03:59AM -0700, Brian Norris wrote:
> (Markus is clearly not taking the hint, but FYI for everyone else:)
> 
> On Mon, May 4, 2020 at 8:00 AM Markus Elfring <Markus.Elfring@web.de> wrote:
> > > BTW, In the past week, you asked me to change the commit comments in my
> > > 6 patches like this one. Let me return to the essence of patch, point
> > > out the code problems and better solutions will be more popular.
> >
> > I would appreciate if various update suggestions would become nicer somehow.
> 
> Markus is not really providing any value to the community. Just search
> for his recent mail history -- it's all silly commit message
> nitpicking of little value. He's been blacklisted by a number of
> people already:
> 
> https://lkml.kernel.org/lkml/20190919112937.GA3072241@kroah.com/
> 
> Some people continue to humor him, but it's mostly just a waste of
> their time, as this has been going on for years. Just look at searches
> like this, and tell me whether they produce anything useful:
> 
> https://lkml.kernel.org/lkml/?q=%22markus+elfring%22&o=5000
>
Brian, Thanks very much for your reminder, These comments have always
bothered me. Now I can put it on my blacklist. Thank you very very much!

BR,
Dejin

> Brian
