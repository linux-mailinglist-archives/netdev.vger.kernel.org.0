Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF791AB4F9
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 02:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405341AbgDPAyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 20:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405328AbgDPAyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 20:54:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A8EC061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 17:54:36 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id j20so7344492edj.0
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 17:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzMDorCv1GZID9zsmGcg6OddhqYx722MVsuJ8PCoquU=;
        b=PQbQU4mx+Y47Kp0VmJmY4pdmkyIFeOBpm/PuEBSauBtddR5AErvLkCUxYdB5QBq+Bl
         hkSP5lJlqOjR6sKAAc+32Cg2e5kqRXpCMz9orUD/QAFTm2fIM2IpvXHQkVIn6FAEqQOR
         he4mBko7bQTN6Ponzq1pQyRnUmWxWkRdsyIqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzMDorCv1GZID9zsmGcg6OddhqYx722MVsuJ8PCoquU=;
        b=oJu78xMx/q1eUyJNpiBfWl8W//rZ09JyQgQm6P+U34G1+0xXYSDMOR6mS6HwFZNwit
         Pp1xOo21h2o3yUja3w5783H1Efe4OAoaaB3+exHJ2b6zl3ox9Ry466q3sIQUFc9IPEKM
         XMOMI8S8xivGSUzOKYEwnMiZY/o6EH4imdpWilE6kGq3wfXprIeh18TL8u/zNeSLPWh/
         1Aq0Qh/j/WQAdoCKffrC3nKSWXEMXh0FE4d9W3/Q4je4T/pYG6FleO1atGWCOWxYx9QR
         X6G1LFpVQHwlnXh+tXy2viTb5CQQnEVtkSMOCkncfEAd1zbTvZlVYNpPisekOIqkk7CP
         PFdg==
X-Gm-Message-State: AGi0PuYuOEbSyVlspAMUwVCpYRIkJ3lHsqKu82fsf8+3ctoqygiLvikq
        taNuNvEJQ83FcuADK9Ua2nNBD/+GYHzGIA==
X-Google-Smtp-Source: APiQypL9izHnCmKdlkJiw7Lx/75+5DEjng/qIq0BFSmfIQRzHf2DJl4ZBSprPkTWzIroO5PB6TJoQA==
X-Received: by 2002:aa7:cf83:: with SMTP id z3mr13489109edx.65.1586998474370;
        Wed, 15 Apr 2020 17:54:34 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id y7sm1568653edr.92.2020.04.15.17.54.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 17:54:34 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id re23so44453ejb.4
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 17:54:34 -0700 (PDT)
X-Received: by 2002:a2e:870f:: with SMTP id m15mr4867889lji.16.1586998009252;
 Wed, 15 Apr 2020 17:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200414123606-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200414123606-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Apr 2020 17:46:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
Message-ID: <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
Subject: Re: [GIT PULL] vhost: cleanups and fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, ashutosh.dixit@intel.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        eli@mellanox.com, eperezma@redhat.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>, hulkci@huawei.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        matej.genci@nutanix.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        yanaijie@huawei.com, YueHaibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 9:36 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> virtio: fixes, cleanups

Looking at this, about 75% of it looks like it should have come in
during the merge window, not now.

              Linus
