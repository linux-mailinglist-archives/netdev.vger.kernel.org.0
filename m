Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74DC388215
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 23:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbhERVXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 17:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbhERVXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 17:23:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08127C061573;
        Tue, 18 May 2021 14:21:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso2294798pjp.5;
        Tue, 18 May 2021 14:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GE+xwhIJfN9hMwPjOsfpwIrqdc6j+pQ2t7L6vVowVvQ=;
        b=AxCxjE40Wc/+wwwfWTLvEooxBY43E0ETiHu3Iq4ZPKhBapo4X2MvUr5kONTIq8uaMw
         dJATjBLx+mflSI2JyTPBLdtfxno2r0USwEm9wB5CtbVAjrxRsNz8zQ1sGoYhDzoCkkUz
         wQdSZHH5OYmMO6jcrNS0wCy/br3BwlPV9LSXixbECuz0Rzh5tV+lLxxpqlneKAvRxCbv
         g7ATd33/1Fg4GNHBDROBWHgyBsMrc5WUwdLkw+h6OYAwVldAsWTnYNAl+2IFdjY2iEBU
         rnVGKgT10xkRLngafZdSb7K/slAdc1QOIoGjX8p+/Rh7mTo7izUIswXwEf4HivTSnUK1
         IK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GE+xwhIJfN9hMwPjOsfpwIrqdc6j+pQ2t7L6vVowVvQ=;
        b=V1S1GMQEdLDj9sbLesLrQcdod8CUoNzHSb5OqkQX/RxsHub/+dl0nswyFjDSWkS0Xc
         99FTMj/dQcWDc9kFFrJAFMk2+uE5WikKT2sI6QxNnr2Rf15fiqFMM+l27uIsUuO+WPwU
         Q10Ps0dm2fbVgm359rWqeDML26Ia5aNYP2HhsPIqfn9ecJiBxAqcvVg8Ion1v7sML2pn
         Ab9a/BMBm70Smb2rqQPqtkqIfk3UDg7IkBESIP7nfhy4esHwsJ1GgSkczdVxk7VLyZam
         zy0Kg+tGBm73R4P3yr19AiTlL6CyJYlKdQ5JkxYl7g9EFrfk+jtHKhLE91cFov2ctyss
         PXnA==
X-Gm-Message-State: AOAM5301W9CMe1Ah/pco+JxLnp7mzzUClLlhojnXQSCqWrTKwZ66IbN6
        BhAOkh7ProDLGhdiKwIgIbA+8vANR5zv1qjxdYs=
X-Google-Smtp-Source: ABdhPJy0YcWFW44jc5Q4FVfGvuMN44nrrDPmLoCuEfAaV1rsH4lQJOXpqjWb6BZ+mPvbqKjseMotKpG9MMDmkPY62U4=
X-Received: by 2002:a17:902:a60a:b029:f0:ad94:70bf with SMTP id
 u10-20020a170902a60ab02900f0ad9470bfmr6781209plq.31.1621372918575; Tue, 18
 May 2021 14:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch> <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch>
In-Reply-To: <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 18 May 2021 14:21:47 -0700
Message-ID: <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 12:56 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > > afterward, so udp_read_sock() should free the original skb after
> > > > done using it.
> > >
> > > The clone only happens if sk_psock_verdict_recv() returns >0.
> >
> > Sure, in case of error, no one uses the original skb either,
> > so still need to free it.
>
> But the data is going to be dropped then. I'm questioning if this
> is the best we can do or not. Its simplest sure, but could we
> do a bit more work and peek those skbs or requeue them? Otherwise
> if you cross memory limits for a bit your likely to drop these
> unnecessarily.

What are the benefits of not dropping it? When sockmap takes
over sk->sk_data_ready() it should have total control over the skb's
in the receive queue. Otherwise user-space recvmsg() would race
with sockmap when they try to read the first skb at the same time,
therefore potentially user-space could get duplicated data (one via
recvmsg(), one via sockmap). I don't see any benefits but races here.

Thanks.
