Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986392F4F4A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbhAMPyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbhAMPyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:54:31 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69F0C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:53:50 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q2so3410263iow.13
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vRYjBPkiArGo3R/o0AwlTsrRfUJpqMwJ0l0SU9uqms=;
        b=EJthBFWY3RAkgeMdLGEgJdD8/6CSc0Ci7eAE6oA8iVAHLAb1z/IwHHJNBV5OG1M+fH
         2YYMt8MLVAzyI5R6Re9V8QtiUxDvg9yTU0FCUlpaJzE+QYYWBHyM0+yyLeY//aEqNFMn
         i510QZ8NKzS0v7vcnqm0cB0ubWZAFuIPilLfoqy0BaFTff2OiTVIWcqGOyleplwCZsr0
         jCBMVHx7Df8srWPe7Vi7pmB6YtiFI79aEzSPGHWAVhB2h07Dh1qRfv16rRYWGzo9p/78
         oxPOyDzv5AsTMeLfsIx1BJ1S+Hq2pStmplKckLFc9FfiHpw3hvVXceZqITjPvu0BxemW
         0KRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vRYjBPkiArGo3R/o0AwlTsrRfUJpqMwJ0l0SU9uqms=;
        b=QxJe1ySu4NiNlRnHtocJASyOKbKsJUtf3K5gkYuiKoHHxTVJWXvx4lckObIRGiGH7V
         qgq5sATA9VfLJ60DqzznpWMcwGjF0h7KL/9DmaHYUqxoNgW4tCVxVIrbEvMmTjiZVrMn
         /Th+MBSvHoJwGE0BcnOAHEDPud5aKOReAJb+aDmNkZIqknZP4nABo8h7RmlshRqlDkyP
         p38PhX74TtH7uQcue/WGpqEzWGl/e/jYboS1hwnrsDXhdgXMaIUt9ilL5UhMUW4jzpV9
         cpdHTnKmU4kCBTpZjKhfrEqfy4Lr/NvdytFeChcdJCj5GjRC1l2L84QMhD9ZQYeND0f7
         LPbA==
X-Gm-Message-State: AOAM5338FeuX2ANUDklGeDhPNUEPZeeuGBgxWY2kRzV2dSxDhJcvRsOL
        xRycA6UanA5qAyJSsQMJ1KrsRGpl8VnwzM0Cyo/+zw==
X-Google-Smtp-Source: ABdhPJx9ODMBPNE7UbqKKAKO7f+6mSGuMyqBZ1c3IMDLrFUJW8TiNm0bG46VRgOQTp0Y3g3Ng9s1NDOOfC4C23i88Lo=
X-Received: by 2002:a05:6e02:42:: with SMTP id i2mr2969693ilr.68.1610553230047;
 Wed, 13 Jan 2021 07:53:50 -0800 (PST)
MIME-Version: 1.0
References: <20210113051207.142711-1-eric.dumazet@gmail.com>
 <2135e96c89ce3dced96c77702f2539ae3ce9d8bb.camel@redhat.com> <CANn89iKU9RbxGsMt1t1+o+bQGEE8xz=yv=gadzH3Vua33+=3cg@mail.gmail.com>
In-Reply-To: <CANn89iKU9RbxGsMt1t1+o+bQGEE8xz=yv=gadzH3Vua33+=3cg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Jan 2021 16:53:38 +0100
Message-ID: <CANn89iKOiZhOZ1jstMyzfx6KsjfcNmNJ4EFxq=ZbweQyjRtv0w@mail.gmail.com>
Subject: Re: [PATCH net] Revert "virtio_net: replace netdev_alloc_skb_ip_align()
 with napi_alloc_skb()"
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 4:51 PM Eric Dumazet <edumazet@google.com> wrote:
>

> To be clear, I now think the revert is not needed.
>
> I will post instead a patch that should take care of the problem both
> for virtio and napi_get_frags() tiny skbs

Then later, we might change things so that the sk_buff cache being
changed by Alexander Lobakin
can also be used for these allocations.
