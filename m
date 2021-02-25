Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF813248E3
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhBYCct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 21:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbhBYCcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 21:32:47 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6F1C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 18:32:07 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id m188so3907761yba.13
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 18:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NMfNkP48zunwQ3Fi9n66BBv1xWA1dAc/5maNOnvI6mk=;
        b=uNt7bVaYkAIZokZVOOraklMIOiSzPsETX4E0prV5dqfWySvu5Dk+qPX+po+x32/JUi
         DQ8/oGNNIB9DcWsYTTrgmGi44hJ8bMs35j9dFLn5wZKIP7qFwBaGeWt71mfi0l59nFbd
         IuZI4gbEiKmQuTacwzw+PNdBhFo4upvNls1K+rg1gx/P0LRfmy8REACZVU4P1SX4mgjk
         QWceX9t5/y1XlXWWxyFMXxtF1ac7FCJGn8O8xR5ZC++QIIJFhn4cbcniIeiDmF93G+ul
         g9Xt199O2+h2x5zzbulgrFlAYjiWQ1rj5etm/xjaxJokMn8spnl/abRzW+NNgw70TSBM
         uHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NMfNkP48zunwQ3Fi9n66BBv1xWA1dAc/5maNOnvI6mk=;
        b=HRbX1pj2Ysv9nghFhcMuUjgVlFRpgSuBBnJ3y+Pk7kSy+3PptHvVON6VKIdnNS/QPo
         2UnAxOtFF34PVmH9zBtjv2PXQ4gY5WdkQgl59uoH82GagQ6AV9eCIgJZ5anp0Ntto+xi
         +w/9XQ3d8C47KMiLj3m7MYx+36noCM6yQOFzwpMpSjINoaKWXeGKacyJb/IA+5mqOW6k
         O+XAH3Ohzq5jyd98gyPfofWTPjAopShFRNpLYynD/PdqPwokgMWb7G1lEluRQpX/fAGj
         MgLqk0pxOShtTVXErG4LqNOv1dlhFrcThBq+XmoN6inke2b6W/jno0EzKJmbl2FZTlqi
         aHiQ==
X-Gm-Message-State: AOAM531IwqvBiYTMI6nu1heOjoofkDGwlnBuq3e8OdWrsRcWVgSj+fmS
        8Ij+eDLpAuVnL8fqbgvS0aKVDIdTjVOrnQ3pJDjV0g==
X-Google-Smtp-Source: ABdhPJzsRkjx1ERxdbYrp/INIY/YZ94hT9Meac9+TtSnMkCieXpmh1HqbdPUZ+cgOpx+fxF/i7oNUjDZXSE6tve5shA=
X-Received: by 2002:a25:bb8f:: with SMTP id y15mr916499ybg.139.1614220326658;
 Wed, 24 Feb 2021 18:32:06 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 24 Feb 2021 18:31:55 -0800
Message-ID: <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 25 Feb 2021 01:22:08 +0000 Alexander Duyck wrote:
> > Yeah, that was the patch Wei had done earlier. Eric complained about th=
e extra set_bit atomic operation in the threaded path. That is when I came =
up with the idea of just adding a bit to the busy poll logic so that the on=
ly extra cost in the threaded path was having to check 2 bits instead of 1.
>
> Maybe we can set the bit only if the thread is running? When thread
> comes out of schedule() it can be sure that it has an NAPI to service.
> But when it enters napi_thread_wait() and before it hits schedule()
> it must be careful to make sure the NAPI is still (or already in the
> very first run after creation) owned by it.

Are you suggesting setting the SCHED_THREAD bit in napi_thread_wait()
somewhere instead of in ____napi_schedule() as you previously plotted?
What does it help? I think if we have to do an extra set_bit(), it
seems cleaner to set it in ____napi_schedule(). This would solve the
warning issue as well.
