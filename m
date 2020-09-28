Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9639827B2AA
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgI1REP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgI1REO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:04:14 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE32C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:04:14 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x123so1596847pfc.7
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zkAI/vKjtDEmKWN3VOw6cB9mPuv7jx0kBhXMQShGYaM=;
        b=qPZI9WAiVxtGA9QX4DXo94Y2FpDLQNsvDZ5wmdONMdINxVtpK4134lxn2iIYc9pFeZ
         EA9EldbM+JOnHHa1SUSWqlDOqNEgQboWDZYtUsVnmlM2ccReVu07QelvwQVFvMiGQxu6
         xdzgITFsbhZVbyAbRq3U3i7n15SDmTBk8rHKD8KbvYesNB7Jydxh99npwvBazBzeVUU5
         ERxCYVtOmd5KvhZJnVNgrvkTdJ6OE0QhoeaReEgVpScppVZfTfIj3FzGtej6YCvobQWS
         zgQJSoq1LyxRelh4HtE1bW+3o+SrzK8VA6IJm494fQpTrUJ1FaFJ30A2VpBLW1GdiRhu
         wCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zkAI/vKjtDEmKWN3VOw6cB9mPuv7jx0kBhXMQShGYaM=;
        b=NgRZ2nI8ZwposMkc+OOtmax89VqDwARG6TboUoSMuu6u5OEpdiT3AG8M1mIM6/TAvc
         QflBRp4VgGuaMcuhsz8CYhWpA5ToHwF+l4ENgwjDARerM9fIb9DTmDuuspzuiMWpQHQC
         yOgbnoH31kQeW704aKQObv2JnSPxjd78lgRaZdowDFISqd9yC/dWyRq1WsssPy6iDw81
         VQRX4Q5aRGq9F6HJ0e5S2UWIm5Qzx4wCY9ekzFC5lnWeG9eBvskwb+ysWvNOKVzrBWE/
         sMr8nDwFoFgPPT8pJ7Zt0/khFqTrwV1+wHn5w7nB9m+jHqDLVrbFzAoIQcIBNGfqhyPA
         qcqg==
X-Gm-Message-State: AOAM531pqwSQrXJ9cdO0Zwg+CcIVmCm5rAGxx7ZirsA77yHqr1NertIK
        dDp0XAEDDhFjrYFL+R6vkD0dQ/4uDT4bLPA=
X-Google-Smtp-Source: ABdhPJwFbRwfEmfdI+ONZ4Q5Kad/Bhijk0P43s8UGk5JZFnswgqYNDQOg1G3IgPshT+GrCV6OqCjqQ==
X-Received: by 2002:a62:242:0:b029:14f:8e68:e7c6 with SMTP id 63-20020a6202420000b029014f8e68e7c6mr352246pfc.54.1601312654047;
        Mon, 28 Sep 2020 10:04:14 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id n3sm2007275pgf.11.2020.09.28.10.04.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Sep 2020 10:04:12 -0700 (PDT)
Date:   Mon, 28 Sep 2020 22:34:04 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Loic Poulain <loic.poulain@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath11k@lists.infradead.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the mhi tree
Message-ID: <20200928170403.GA2222@Mani-XPS-13-9360>
References: <20200928184230.2d973291@canb.auug.org.au>
 <20200928091035.GA11515@linux>
 <87eemmfdn3.fsf@codeaurora.org>
 <20200928094704.GB11515@linux>
 <87a6x9g89a.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6x9g89a.fsf@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 07:45:37PM +0300, Kalle Valo wrote:
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> 
> > On Mon, Sep 28, 2020 at 12:34:40PM +0300, Kalle Valo wrote:
> >> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> >> 
> >> > On Mon, Sep 28, 2020 at 06:42:30PM +1000, Stephen Rothwell wrote:
> >> >> Hi all,
> >> >> 
> >> >> After merging the mhi tree, today's linux-next build (x86_64 allmodconfig)
> >> >> failed like this:
> >> >> 
> >> >> drivers/net/wireless/ath/ath11k/mhi.c:27:4: error: 'struct
> >> >> mhi_channel_config' has no member named 'auto_start'
> >> >>    27 |   .auto_start = false,
> >> >>       |    ^~~~~~~~~~
> >> >> drivers/net/wireless/ath/ath11k/mhi.c:42:4: error: 'struct
> >> >> mhi_channel_config' has no member named 'auto_start'
> >> >>    42 |   .auto_start = false,
> >> >>       |    ^~~~~~~~~~
> >> >> drivers/net/wireless/ath/ath11k/mhi.c:57:4: error: 'struct
> >> >> mhi_channel_config' has no member named 'auto_start'
> >> >>    57 |   .auto_start = true,
> >> >>       |    ^~~~~~~~~~
> >> >> drivers/net/wireless/ath/ath11k/mhi.c:72:4: error: 'struct
> >> >> mhi_channel_config' has no member named 'auto_start'
> >> >>    72 |   .auto_start = true,
> >> >>       |    ^~~~~~~~~~
> >> >> 
> >> >> Caused by commit
> >> >> 
> >> >>   ed39d7816885 ("bus: mhi: Remove auto-start option")
> >> >> 
> >> >> interacting with commit
> >> >> 
> >> >>   1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")
> >> >> 
> >> >> from the net-next tree.
> >> >> 
> >> >> I applied the following merge fix patch, but maybe more is required.
> >> >> Even if so, this could be fixed now in the net-next tree.
> >> >> 
> >> >> From: Stephen Rothwell <sfr@canb.auug.org.au>
> >> >> Date: Mon, 28 Sep 2020 18:39:41 +1000
> >> >> Subject: [PATCH] fix up for "ath11k: register MHI controller device for QCA6390"
> >> >> 
> >> >> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >> >
> >> > Sorry, I forgot to submit a patch against net-next for fixing this while merging
> >> > the MHI change.
> >> 
> >> Try to notify the ath11k list (CCed) whenever changing MHI API so that
> >> we (ath11k folks) can be prepared for any major changes.
> >> 
> >
> > Okay sure, will do!
> 
> Thanks. It's important that ath11k is taken into account while making
> changes to MHI, otherwise there can easily be regressions.
> 

I completely agree. Actually I thought about holding that patch till next
release and making the ath11k change together but somehow I applied that
patch blindly, my bad :(

> I was looking at commit ed39d7816885 ("bus: mhi: Remove auto-start
> option") and noticed this in the commit log:
> 
>     This is really up to the MHI device(channel) driver to manage the state
>     of its channels.
> 
> So does this mean we have to make changes in ath11k to accomodate this?

Nope. The change is needed in the MHI client driver like qrtr which is already
taken care: https://lkml.org/lkml/2020/9/28/30

Will make sure to include ath11k list for any future API changes.

Thanks,
Mani

> I haven't tested linux-next yet.
> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
