Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B519C27BFC2
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgI2IkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI2IkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:40:24 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6589CC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:40:24 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id f15so3157350uaq.9
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AXj/2yxnGnqCJt2X6VbEHmHDtztk3H2f7Rx1q9RXDZI=;
        b=BQOT5WZ3Z+bOTnWz8gvG12jKNxVN59x2UlU8MSp+/urX8FyRHPSz1Vjv0aV/bXeKh1
         qUeLnj6QJBE673kmQDSxu4mwrjTHsJdWbtVsOmFFjXcRjYKFli6woTYF2wKzUamEr7gf
         3eYd2cZiXZjLXBWCAc2pGxXa/WM961m8Y0l6iChOO4hZmwsziiXDaMFCieMqn1PTmi8Q
         i4S3N1bHKw6wUtUYJ1lLhaHViCQQ7bUp/0iwJl3URLuAnXprBvNkCROuPbvNAjE99WoQ
         yZLBV0JD+pnh4/lEKwF9jy2e47YzklkZLR2qpJ51q1cc5MT/2YYC2ssOW0uBTLpEM5TK
         erzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AXj/2yxnGnqCJt2X6VbEHmHDtztk3H2f7Rx1q9RXDZI=;
        b=r5TZb95HuktCd/f0CQPqgbKQyTHJ8hoXenpNO8WiJDhMIF8irJmB7JHrfEMUo0qjrY
         HTE+Vpg8hc2X+nO+imRGSI+K4PrqQwlSwvzihMt26MzycvFW8/RoJwgYqSEO2AwQQ8SF
         whsDaIJl8oqhahQkNDxmp3WLDC4Gw4I5fNy5MvVIBLCEmno5iMLZazUMtA/RIXxDjxpN
         qnatNqK5PXqV6obcD4UjC7VE0Up3lLTk7UV/WaoxxsGrJtvLfx2LnUvCbulus2QrBLm/
         kCpZmWPKK8BPeOC74FJQf0iXhnIm/YmEZo/86CN4WqtujWuTJXGlaghxlrIW0YJz9fDM
         /Yaw==
X-Gm-Message-State: AOAM531aTyeEYLkZzvInBocjc3pVtT864tsoVPKATwZTPWXi9Bx2k4zq
        grj54sCotdcmq3ScrNHFSmj+HfXLKVMZVQ==
X-Google-Smtp-Source: ABdhPJy7AjchKJe0lv4X7dSG/0DipzPOzHWXPq+010rAVfBHFnilbgwoOJ4tVPiejPzZ2jTCUsRkKw==
X-Received: by 2002:ab0:4425:: with SMTP id m34mr2904766uam.19.1601368822884;
        Tue, 29 Sep 2020 01:40:22 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id h27sm1471041vko.38.2020.09.29.01.40.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 01:40:22 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id w11so469424vsw.13
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:40:21 -0700 (PDT)
X-Received: by 2002:a67:8a8a:: with SMTP id m132mr2059005vsd.14.1601368821464;
 Tue, 29 Sep 2020 01:40:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 29 Sep 2020 10:39:46 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfjMQXLN6nvTu+P8r1eUt=Sw56GDqwGG+tuKK3pF5U9jQ@mail.gmail.com>
Message-ID: <CA+FuTSfjMQXLN6nvTu+P8r1eUt=Sw56GDqwGG+tuKK3pF5U9jQ@mail.gmail.com>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 4:00 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Open vSwitch and Linux bridge will disable LRO of the interface
> when this interface added to them. Now when disable the LRO, the
> virtio-net csum is disable too. That drops the forwarding performance.
>
> Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
