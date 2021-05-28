Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E35E393BD3
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 05:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhE1DMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 23:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbhE1DMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 23:12:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1601BC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 20:11:02 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r11so3125726edt.13
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 20:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=95ovB6mTl7unMYoP9NBE1G6j4ilgAKOEVr/KalCHM70=;
        b=ftL2S4RcCxB8zP1xz37/HlN8LOJqNtdf+TWIE/PzfqqY/v8OFLsK4yuPwRXYeTJu+t
         YfKeqQfPqGzkxg+x3ORJ6KZR7mjoMCpZhr4pjTxucOHmIO2IaZ9+7l9eOdLsnquZBalu
         rXoEI0R8WJR1BVHYYENxcXqE5ur6nFyk03THB6WO5VBpl61ivQfnd2R3j7VvHA/Ze52F
         vm8HW3GAovh8pzdPhKgH2ESLp1f3guKR3400RuV8PL+scP1EALjBukwSNs4e966nIPhI
         Dh0Z5znqILCuzN9qUoNGeCyk4+EN22QRsNAfFYU3XYy/8zWT3u9nlCFbId3bpEZSBrJY
         +AHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=95ovB6mTl7unMYoP9NBE1G6j4ilgAKOEVr/KalCHM70=;
        b=sFrdLbZtxNo053q/Kd2If2xW/xAmHlCtbg3IEnRZY48vFa06iEGOmqKKvtFKG/VrZw
         R7lNTA2Z8FZqftadys76cdl0kXY9cZuI4V1NZTJGRJAbGPThvS/yZ0F//IOqMMvDbVvO
         GSYE89ApjjrwCkDCAC+JlpwP5sJ4DnbVD7N35dQ086oynr8gnAdFuHLjwNCP/5EP+mtV
         BCwJLHQ2whf4qeBaShBULI0w9XPY8zjmKk4O216qdnZ69NZrIXz2nuyRzd57vldCSwRQ
         N5A7xWHrhol33V6Rxm/juvyrJjbpbjv6skNhHcjwV1rhIFGkIIESSogdRbhIyyVeHwT2
         c7zw==
X-Gm-Message-State: AOAM533DFy56GWnrcsllD1F/GJQS9ScM1MFH9CZhjlREkGBDxLNdeOwW
        79KLeCxikxdvrWOI6S9yOVImQsrijj0BT52kQEKDmBSrKA==
X-Google-Smtp-Source: ABdhPJyH4BzfWPIE7jZQJvXQcS6awX2OGahW6eCLQJo3LGQSsV7ghk8tANbxW7hsA9utyUgEbjmSjrX+ariNFOwxSQg=
X-Received: by 2002:a05:6402:128d:: with SMTP id w13mr7465577edv.253.1622171459983;
 Thu, 27 May 2021 20:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210527073643.123-1-xieyongji@bytedance.com> <20210527110730.7a5cc468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527110730.7a5cc468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 28 May 2021 11:10:49 +0800
Message-ID: <CACycT3tHi8zHJZu+OPVFs3Bk-M6sUx-fQz6aJ+hGSHLWd2Rh8w@mail.gmail.com>
Subject: Re: Re: [PATCH v2] virtio-net: Add validation for used length
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 2:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 27 May 2021 15:36:43 +0800 Xie Yongji wrote:
> > This adds validation for used length (might come
> > from an untrusted device) to avoid data corruption
> > or loss.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
> This does not apply to net nor net-next.

Will send v3. Thanks for the reminder.

Thanks,
Yongji
