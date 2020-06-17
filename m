Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46D71FD3A5
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgFQRnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:43:08 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796D6C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:43:08 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r2so3838516ioo.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QT6WSQDmzbQ8+KA4mZdFN+xUX8rOtARru6XnQJoZ3bE=;
        b=irduzZBSNljjyq6uniDACQsk049aYi+B+k8MOZPrC3bqq1QW1rv5UlhCHHG/Ewws4D
         uYcK5JCKoSMlPM9WB/XoIHbrpuGT8Zhk0fuvrFjAXZuBra6BBnTL04tT2N80w6PaybjG
         pPIuM/uWET/LkxO250TNIwt1Flti7LMJhiouPh9k/rR0+cW0RopMpGVR6VWA/icb8lto
         sWdc9cI+818pzCPW3UdOrNvv0GYNSjGb0zkdKSq+ZMWZobbuIpF7lUnM5+0J/ucNwATM
         ZeCf1ef2ET7gKnNOU48qDixIiL52TdxigSxcH0nLgFKgjg9tXa+JXlitvZkqO8qQ4DmY
         BQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QT6WSQDmzbQ8+KA4mZdFN+xUX8rOtARru6XnQJoZ3bE=;
        b=kBua7/dfxi3uwxkCX5r9SStG03HdHYu3zIPbFpJlCFzexBJZdumuFgSZqGXogMB5q9
         xnq+YS/R9KJ3Ll5ee+p3Sm46NslJaec+A0vGqBd6Fe/L3NTzaBRMp5Y/5MURA0K0Kj/Z
         6+pLlAzRd6pZKI4TOVkAQ1rVlxxMDYvyjo5VPb9phFRa6q4EoWGmTpO5z252q5ULXFlp
         rgPO2vijy9nTCCbC6F8W3pnprKX/kMsBJNLSB+vHkRxClb7MieQTFutdEgppfQb+ViDw
         vhdxCV4dOwPN/8hlGXPr+we+BRbaNc1hBY50XPZUGAJYzcvSzQlAji5a5L3pSUCMEaFi
         /jTg==
X-Gm-Message-State: AOAM5317+RwY/TRI33t7PySh00yJq8q6S3+uDRRPvP19SSgA5IftUAuv
        XVsWeoN6t02KhIGTUwt8MPPxJsjrOyzjzN+p4E0=
X-Google-Smtp-Source: ABdhPJyl1npdBYCezEKDtOXDOxoFdkUHm42txpIALLWs6DmTLgfQGbeVBRJxoSz9eAPmBIdG8DZNDAHhf1r2pK+kkvA=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr519371iol.85.1592415787875;
 Wed, 17 Jun 2020 10:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CAMArcTUmqCqyyfs+vNtxoh_UsHZ2oZrcUkdWp8MPzW0tb6hKWA@mail.gmail.com>
 <CAM_iQpWM5Bxj-oEuF_mYBL9Qf-eWmoVbfPCo7a=SjOJ0LnMjAA@mail.gmail.com>
 <CAMArcTV6ZtW24CscBUt=OdRD4HdFnAYEJ-i6h5k5J8m0rfwnQA@mail.gmail.com>
 <CAM_iQpVpiujEgTc0WEfESPSa-DmqyObSycQ+S2Eve53eK6AD_g@mail.gmail.com> <CAMArcTV6YQPC6uo2NHER41H++XnCG+LW7ZXDgvF_snYmMZON3Q@mail.gmail.com>
In-Reply-To: <CAMArcTV6YQPC6uo2NHER41H++XnCG+LW7ZXDgvF_snYmMZON3Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 17 Jun 2020 10:42:56 -0700
Message-ID: <CAM_iQpXT2L8TA=W-FEaD=G_0FEZMG3GWJfEDEXY5fY0TJWMkdw@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 8:03 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> I agree with that.
> And, do you have any plan to replace netif_addr_lock_bh() with
> netif_addr_lock_nested()?
> (Of course, it needs BH handling code)
> I'm not sure but I think it would be needed.

Yeah, I agree it's needed. I have a patch now and will send it
out after some testing.

Thanks.
