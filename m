Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23A125B404
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 20:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgIBSmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 14:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgIBSmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 14:42:49 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FB2C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 11:42:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g14so36489iom.0
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 11:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=826YgR/nKGa+GAiMIpnqw+d+pR8FqUhFuVBY4fYrJm8=;
        b=DxiTUZASjsoYLx3LruMZsz39RDmOVpcMcJ1qPnTkfyNtevpJ2JdXOzSbEU8Xy6WXyc
         g1uQCDYyuTMgkW6g7koacmbA0twD96fbX0xQUPnNIE5TRQAeQUEpcZotQFoqoahiR8YH
         UeW84usOrP4eLeeuUkIIjnDvoxj/YG+Do9sQ4g+MB3gdyRn3hj/gIO6bbcSDTXNcQfj5
         hsZ09CpBUaKuq4bNAishixg2tjDQTUe8zZn0jJUXDzB2tQD/NsUVGu6TZ4ZdN7D9CZyQ
         Z6cK95KN9GTLS4bNMaunqltmNLsG/IXmqwT6bcn0C0UVoYNJkS97CoIyN13SuGRTMQEG
         etqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=826YgR/nKGa+GAiMIpnqw+d+pR8FqUhFuVBY4fYrJm8=;
        b=hs4MGt4/zDmUgKMrlTwrXGX9u5K2HJrjGj76wLpKkEF6Y0/hjvenfQDSK1xcLPKw2o
         1i0RaMKb4DMGjN82CKmOAKKPgJGH2rqi8vHA5g3eoqJVTkIMiN8igXSeDfcn6aZwZpxp
         +Yy6kUGe210Lx4TO1lTiZar18srNkWPgMm7mFzU9w3KPdrel6Zhj0LIDEpoPJav7LxkO
         MiPrHbnbMud0VQp6XNVSioiaY9QSxRnEcCNhnDn0sK1UzJr3PuZMBKTXHjv0/ZD/ysav
         tr39x56u50DWapy1H0/1a1QtNmob9/VllM0cKxqpldTV8jl9XPw8lYLt6VunKg2sf+fx
         RJOQ==
X-Gm-Message-State: AOAM532sJkKUElbFbU/sj4lPpwKSJ5txNjCqN+dUjPrhHZVK9VK/+DMC
        1nZGLWv2uMBJLHyCjSLgCOHz0y2lk+jxHHA+TXScKQ==
X-Google-Smtp-Source: ABdhPJxWN0BiZxQ4BN7bJw8KixL8NdXqC8lBg4UaGsdHvnVyhQDLuDS2Q3ULvoe4Yj+ZuHPdq5MoKiKoAbArv5MoPkw=
X-Received: by 2002:a5e:9e0a:: with SMTP id i10mr4533381ioq.41.1599072168063;
 Wed, 02 Sep 2020 11:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
 <20200901215149.2685117-5-awogbemila@google.com> <20200901173410.5ce6a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901173410.5ce6a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 2 Sep 2020 11:42:37 -0700
Message-ID: <CAL9ddJciz2MD8CYqdbFLhYCKFk=ouHzzEndQwmcfQ-UqNNgJxQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/9] gve: Add support for dma_mask register
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 5:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  1 Sep 2020 14:51:44 -0700 David Awogbemila wrote:
> > From: Catherine Sullivan <csully@google.com>
> >
> > Add the dma_mask register and read it to set the dma_masks.
> > gve_alloc_page will alloc_page with:
> >  GFP_DMA if priv->dma_mask is 24,
> >  GFP_DMA32 if priv->dma_mask is 32.
>
> What about Andrew's request to CC someone who can review this for
> correctness?
I didn't realize I needed to CC someone. How may I find suitable reviewers?

>
> What's your use case here? Do you really have devices with 24bit
> addressing?
I don't think there is a specific 24-bit device in mind here, only
that we have seen 32-bit addressing use cases where the guest ran out
of SWIOTLB space and restricting to GFP_DMA32 helped.. so we thought
it would be natural for the driver to handle the 24 bit case in case
it ever came along.
