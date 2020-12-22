Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE93B2E0BA5
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgLVO0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbgLVO0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:26:10 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60854C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:25:30 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g20so18521488ejb.1
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w0ZoW1YtNnNvY2+areMW2gfi6KMKObUc38gUPhTuopQ=;
        b=f+FnVZOBPLtOTEXet8hkD/XtcWq4kPOPWi9OBffjf+DJ1F47c9ynXidjBvNV2Q/cfh
         Kwje3xDXmlwnibGTNuyx8wCVSyaIEU/jzI69kga59ByaqtcDd7pNKym44ICggoE2L8A7
         BjWJj0PLZoELkv2/VTeznojSHc78xZGGxzy5rygLlyhCV8pIzf/UjmJg1k89P+HWFzFY
         seUZ/yaMmzsNFMao4CCbvqpMGfQjyC2Q75u0fQ7RUT9tVk5I+Xad6q0jv0HfJ7vt8BPY
         7rKOxNX7609a+UIVxNocXzWP13r4nhLRtjU8i5MFKYlOcCXm6udTn+zT89xFizG4Xwtf
         HAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w0ZoW1YtNnNvY2+areMW2gfi6KMKObUc38gUPhTuopQ=;
        b=OJ4XWsklnjzMYzj0oyypIhxrnMm6WsAoAapERUdBZ0EvZYbGHgFHl0oDXqbItnPCgm
         U/8EIhwaHj+9bu0LNXpxe0xzW4PzPWMaIqI6xZ5+qF6eWJeN9gV0KGRvm0k2GoctiBaY
         5VuVzCiwLW+SYL+4iR9uQNm75pAIxpD8/uzRNEXKOBb7c4ern1Jf0WXPIKhsv34Jh68m
         zlS4i2yJT9pQ1qw41fm8jZmGEyRC2H9vqDiUkYcA9j2J7T36u4ZunkewZXFGpM39H4M7
         Z8DvU1OZkfJNuK3UM0AfBRK21CG38e58uoq/UsnCgVpfVGWVt3EvnERLD2FubXdrfd5C
         3/0A==
X-Gm-Message-State: AOAM530I6fYP34sL5wewB59fj0V4pOpLO7DzzB9PqWN6tQ4o5gAqh9Rh
        y6mEh5rXAajlh11YHcE/YiuJdtgpgssf7P5vnd8=
X-Google-Smtp-Source: ABdhPJxzwTJ6k3Z63MMFK8Crq80JHefJXNDH11QJGkVz82rtNyFtQcidVrk6WPbfnx0XZXXJ8RLBzRd/nthPLuCQoIs=
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr19812860ejb.11.1608647129124;
 Tue, 22 Dec 2020 06:25:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608065644.git.wangyunjian@huawei.com> <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com> <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com>
In-Reply-To: <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 09:24:53 -0500
Message-ID: <CAF=yD-KCs5x1oX-02aDM=5JyLP=BaA7_Jg7Wxt3=JmK8JBnyiA@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg fails
To:     Jason Wang <jasowang@redhat.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 11:41 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/22 =E4=B8=8A=E5=8D=887:07, Willem de Bruijn wrote:
> > On Wed, Dec 16, 2020 at 3:20 AM wangyunjian<wangyunjian@huawei.com>  wr=
ote:
> >> From: Yunjian Wang<wangyunjian@huawei.com>
> >>
> >> Currently we break the loop and wake up the vhost_worker when
> >> sendmsg fails. When the worker wakes up again, we'll meet the
> >> same error.
> > The patch is based on the assumption that such error cases always
> > return EAGAIN. Can it not also be ENOMEM, such as from tun_build_skb?
> >
> >> This will cause high CPU load. To fix this issue,
> >> we can skip this description by ignoring the error. When we
> >> exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
> >> the case we don't skip the description and don't drop packet.
> > the -> that
> >
> > here and above: description -> descriptor
> >
> > Perhaps slightly revise to more explicitly state that
> >
> > 1. in the case of persistent failure (i.e., bad packet), the driver
> > drops the packet
> > 2. in the case of transient failure (e.g,. memory pressure) the driver
> > schedules the worker to try again later
>
>
> If we want to go with this way, we need a better time to wakeup the
> worker. Otherwise it just produces more stress on the cpu that is what
> this patch tries to avoid.

Perhaps I misunderstood the purpose of the patch: is it to drop
everything, regardless of transient or persistent failure, until the
ring runs out of descriptors?

I can understand both a blocking and drop strategy during memory
pressure. But partial drop strategy until exceeding ring capacity
seems like a peculiar hybrid?
