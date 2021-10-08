Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E2D42650F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 09:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhJHHOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 03:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhJHHOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 03:14:41 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBD7C061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 00:12:47 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 188so9572315vsv.0
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 00:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hO1svIqys2HkhaxDZ9Wcyx50oob50bi/Hy4Yt7QrAUA=;
        b=b5LtqnNbtRzAuKCIZNXgXAtAMKAd/ET+gG5Svms4lEc4fuql9fAgNFOr0WZZ0c6CGE
         a17/FMVxfS6wWtKry/PwWwtATNhlaM7Y+RNWKw18Bedhc7MWFhK9XI3KLWZgLcATrZRy
         ZnJrY3Ymfg0IBcKMCiQ3HGgvIYZqBzB+iUOUCDqPela8fM4/NGDKCvZp5tmHQndDRDow
         HmIP+UfX+bWPvGCpcDGvYLL2Fkx6Goy1KKR/+DhH63/rUcImAvgjkMEjamto5Gy0Log8
         UmC1+LEKgifA33Mcy5UB2mS0kzDQddObtvub6S1nO7+Nwikpg913Ewy614prGljToXTW
         ZbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hO1svIqys2HkhaxDZ9Wcyx50oob50bi/Hy4Yt7QrAUA=;
        b=JST+D+VJY8LNNOJ88vW+pGtcFbgH6rPrOyHNB1hakJSfxOMLyCo4o8XcERrB4mheHa
         R0XH31ed8a96z6FaLyCx8jaW63IQE7ZrC6Za4fc/M+8BrvU+6orczCuEIJW6w7U/Y4Ik
         9WnZPU7OllspmR9yubsOwRzftWxMPabaCPVJT+dmiwpTZ6xp5SkTny9SRcCfKfmiyHp1
         jPxrcYNgNKXNRQd6t2po6vywr6EoPBpKl2bUSzBbz784nIK6HgEctkJg0QfFXWMU3pLp
         KrUP423Oszuzq457xLXpmL+uZPDcUHP1CnO6cNsm8HW8DfDVjBn0OiB6Wd4iTL0QDiV9
         cYiw==
X-Gm-Message-State: AOAM531D3yENwTULMeedYYSAyxnCwxLFYox16gHrD9XyIfxSGZ9PMdk/
        iSsx9tE+XqKwy71wCE69WnO6ja6lDGhKnlrnb/4=
X-Google-Smtp-Source: ABdhPJzvfqakRhO3oiIAUtPDLJnZYi29bQnwtN/LBffTDuVAud6ysYxPkqX7YdxQ1a3rIx3WW5hr8WzVmkxlDFe6bJU=
X-Received: by 2002:a05:6102:664:: with SMTP id z4mr8555644vsf.20.1633677166308;
 Fri, 08 Oct 2021 00:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <1633454136-14679-1-git-send-email-sbhatta@marvell.com>
 <1633454136-14679-3-git-send-email-sbhatta@marvell.com> <20211005181157.6af1e3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupNJC7EJAir+0iN6p4UGR0oU0by=N2Hf+zWaj2U8RrE4A@mail.gmail.com> <20211006064027.66a22a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006064027.66a22a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 8 Oct 2021 12:42:34 +0530
Message-ID: <CALHRZupD4Rb3d2hAtzoA5rtgqqFayXiYhAKUbgcpv0myVGpvPw@mail.gmail.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-pf: Add devlink param to vary cqe size
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Oct 6, 2021 at 7:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 6 Oct 2021 12:29:51 +0530 sundeep subbaraya wrote:
> > We do use ethtool -G for setting the number of receive buffers to
> > allocate from the kernel and give those pointers to hardware memory pool(NPA).
>
> You can extend the ethtool API.

I will rework on this patch. Is it okay I drop this patch in this
series and send only patches 1 and 3 for v3?

Thanks,
Sundeep
