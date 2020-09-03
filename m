Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F1E25B77F
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 02:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgICAF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 20:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgICAF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 20:05:56 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA50C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 17:05:56 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g13so797619ioo.9
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 17:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bz1RD5px35qT4x2nQsiuCyiowCBtoalxrTpRRlsvbDc=;
        b=UA9qMl8O1YsxCxw6j1CjBsXojqiAdYof4yY3J2IC/4V/Hm9mdauUd7Budfrt1OhKW7
         bzGzpZJS2B72M2e7m8qRz+CVhTwP6gHGzr1spVGiRUkogPLraB9LdoxKgJrmNDFA/pts
         TNW2LmsdMyJK+lXQCHRwxW9/E4x+/PQcKvOsft7lfkgRQXX9bnoPjThTO61Ah9OI53Vc
         qyJbm6yAG6IbMQZyGxbH2dfNWw5IkOrsU/dPHAr98JYOOdQlgMVmmacmbCyl9Xs7kDZu
         1Nl5JjHB/lvFcvLdCRxCRx/XllUttDQRtduHObD0BVLp+M+iCMjhMD1wRelu9AmhIHoB
         w+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bz1RD5px35qT4x2nQsiuCyiowCBtoalxrTpRRlsvbDc=;
        b=DuvXGEvVvwD1vMuUYSg5vFEAInvxBadYC0plv+jY+MydvBKwplG5COXDvDlyYLWTHd
         RhWyrxX+PYUgNUL9BAYOKQE9V29shmeJKroP3PeZp040XgxnhD5xbpXjUSU0FhdKFTT4
         ThwTs6InJl5FIQQ78VrnMnmGkXse2CMTLKx5xSTuhPuodghMXmv80XskP8y62dmP1QU9
         T5lxjh9kvjRugG5QUoctficteUrbFYznZlYcTq2a4FjpdvU7sl2W22dtBDrhMq1rpDF5
         LmG0Luql+ciaibpmF2IRvpAgclbjnXblKFeNt7nKu1QhRHa9HyhzBEgutMROuXrkJmiv
         jkKA==
X-Gm-Message-State: AOAM53009nMLBU8+R3i0ZjJ5cddeHkHzPvo0yxoYyo1HSdCRzcopQA+1
        Ht1pS8C6L8dWeb6p+C9mxPHQkWv8yro0jxEzt7nHYg/05Qf+cg==
X-Google-Smtp-Source: ABdhPJwbw2GXV211L/AaXhihn/yk+neQ53jqzTCDzpZhfjYH1NLopbk1oDkbgKn6jd0pOA1j3PpuR7vmFKxwkTwwXV8=
X-Received: by 2002:a5e:a909:: with SMTP id c9mr742714iod.56.1599091555416;
 Wed, 02 Sep 2020 17:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com> <20200901215149.2685117-6-awogbemila@google.com>
In-Reply-To: <20200901215149.2685117-6-awogbemila@google.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 2 Sep 2020 17:05:44 -0700
Message-ID: <CAL9ddJeq_rOUOj=NAd5FmdCBQNRdr3_9X0yzXB0Kj7y+1NfN3A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/9] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
To:     netdev@vger.kernel.org
Cc:     Kuo Zhao <kuozhao@google.com>, Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > +       if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
> +               dev_info(&priv->pdev->dev, "Device report stats on.\n");
> +               gve_set_do_report_stats(priv);
> +       }
>  }
oh no, I realize I forgot to replace this with an ethtool stat as
promised. Will change this in v3.
