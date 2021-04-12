Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1802F35B9F4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 07:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhDLFy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 01:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhDLFyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 01:54:13 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAA5C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 22:53:55 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g38so13750535ybi.12
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 22:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ovcdU1cRGnxHBiQJvXjk0OZF64ypG2ZjxHd5P+fKhHQ=;
        b=mExK27/irpuQjlI1nMuYb2LWqdLd9TKRJwNaf0M8CwW28267enGfEzMX04IDELlixI
         oNDTI3rWInMYFhzZEK6zQjAzvkDzgfsu411uF8nEodOGRnYGoy/BroRKCFOIHkLOymMh
         f5uL7DTqwLnlaxevJQII/p8iw63HBTh1VM1x53nVM81xlyfLqLQnX1L5YUG4wga8Krgz
         GA51gte/74XCKYgXPplGMez1OOfDhVCTC0/5MyNsl9QNmQmKMbv4Hy5tfqDuem11GgUu
         iVhxgp/+I6leByKPJ5qzAV08aSHUMIm3uEMNI2dYgYL5ERfZdFtSZuY8p85LtAk6Vo1v
         prMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ovcdU1cRGnxHBiQJvXjk0OZF64ypG2ZjxHd5P+fKhHQ=;
        b=GlZ50SrF9dvxs4MHoEV+PIajK7q5SI8yP8CgbATutgNtCF8+HrjE4Krh15DSxqG6dE
         2lAFBk5ZTbm+d1crmWGrImf6V9EVfzDbxSAbZvgq21U6c+SqalYEtLvJX5DHxT8wN2ud
         n4e1q3ksCaPE60NaE6/0uQEKlkEs/nS4mUxBMMJ5xmjsZUxY+GyZ2wUA1YIWEjIYfUcp
         dZ0Uh9M3paW+uixvFWKcfpXxXCB1s8fdgCHmqlElcjqcm3DJ2mEP+QMeRxjr0eMEUjCP
         P3DonAOq3Uu7ChsGyHnD+bVTOWp5wT29I8oj2SVTHwMzeMFWK9dfp61FtVRHGHp1zhJS
         EwAg==
X-Gm-Message-State: AOAM533/JNXlwh+Htfe5BIeY8SFMBqLRO7DQfzdp1/QlSEntqH3/UPvz
        om6xYff/CNYHI/mtmjzHMSxXe0hJBGyYnxGPBuRYkQ==
X-Google-Smtp-Source: ABdhPJxR28RIQsIm4NqgV0cEW+Clgm/HojoJ44KSVUWBy77y/taBT+koxfnThEFVuG6Hh/lNKM6migN0yXC3CSh6Uog=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr35148273ybc.234.1618206834669;
 Sun, 11 Apr 2021 22:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
 <20210411134329.GA132317@roeck-us.net> <CANn89iJ+RjYPY11zUtvmMkOp1E2DKLuAk2q0LHUbcJpbcZVSjw@mail.gmail.com>
 <0f63dc52-ea72-16b6-7dcd-efb24de0c852@roeck-us.net> <CANn89iJa8KAnfWvUB8Jr8hsG5x_Amg90DbpoAHiuNZigv75MEA@mail.gmail.com>
 <c1d15bd0-8b62-f7c0-0f2e-1d527827f451@roeck-us.net> <CANn89iK-AO4MpWQzh_VkMjUgdcsP4ibaV4RhsDF9RHcuC+_=-g@mail.gmail.com>
 <ad232021-d30a-da25-c1d5-0bd79628b5e1@roeck-us.net> <CANn89iLZyvjE-wUxfJ1FtAqZdD3OroObBdR9-bXR=GGb1ZASOw@mail.gmail.com>
In-Reply-To: <CANn89iLZyvjE-wUxfJ1FtAqZdD3OroObBdR9-bXR=GGb1ZASOw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 12 Apr 2021 07:53:43 +0200
Message-ID: <CANn89i+g2uiYNUCvXH4YKQqPeSw+Ad4n6_=r3DBZTdHS8hBkMQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 7:48 AM Eric Dumazet <edumazet@google.com> wrote:
>

> give a verdict.
>
> Please post the whole strace output.
>
> Thanks.

Also please add -tt option to strace so that we have an idea of time
delays just in case.

Thanks.
