Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9733E9B0B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhHKWtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhHKWtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 18:49:12 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48427C061765;
        Wed, 11 Aug 2021 15:48:48 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t3so4684286plg.9;
        Wed, 11 Aug 2021 15:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3QWerOwIoMoliiuZEQY4ok5aiRh/0+SPJLswyrjqFs=;
        b=P7hcE+cFFL2dFWDUucIDURvOUoZ77NYkmd8c09a6SQfy1sZFmijIFCfz8lxVaiIQjz
         ThrqAfYY4Gllsha74PmkTaOaVbgFbpdNgLF77H2zxlhOvEN9X3kqdf9Mzr6ZTOzjEBuU
         sYhcA71VTvMJSXv/AUHsWU34iqKUAdMfIfw4LanJQTZhrj0Di9pOMkBqrTfJQUgmunr5
         nbB56hUA0nwEUIIUOWxAJagJjm6IgLiPzLdBJSU6xCEEOMARgdcfJKjo3ycKOCTeFYBY
         xvGpKLY/7ojg1AOwKU2xtr0GpXqF/wlWz4BYq3bsPC+aE4Z1P2Sohlw25mCjDqRDlzMT
         GivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3QWerOwIoMoliiuZEQY4ok5aiRh/0+SPJLswyrjqFs=;
        b=Gl6aukk1cFjX+xPAq22NxazCKOKgN4QgSJKsTEiKBM9+nATEu6saup1vpb0ZQPX1M3
         DGAeIXGxRn/H4Z+LOo0I9Lw078hgwE60azr2ijycpXu47c4ifCEiyuQ1glwkPeuSadJL
         1RQ13UxGBQ80IzQHqMe28a8FxCjapLY7VS42gQNXwdgmZCU6s0ivBSJyuoG1dQ7b31oP
         7rTPW/EpQfwPJvb8HIwPLP/I6Mbn8ylP5hQR6109cIhv83irVFe1Blnp19zFKJtKzZbN
         H/IgNksmjH1gVjGBhWJeeYfBsAdf/qPjMKk25k/kFSo7iv7wzxc3ID5+wE3jp+LYEk92
         JpPg==
X-Gm-Message-State: AOAM533oJHuTWF0c95ZvGDJb6mkxKe56hEBuXaqRFXusWGx02hx5sHXn
        01Mzdy9KgNjSwq3xNh9Poh2XY+G4XKQammFYOfE=
X-Google-Smtp-Source: ABdhPJx6C6gS/q5ivt+4K341xf8Dq5nrq68P9QTEusGl/rNbAorhBYHInJgwVWsVoZYSSQtKP+zfwprSFdyJuWx0wmM=
X-Received: by 2002:a17:902:a503:b029:12b:2429:385e with SMTP id
 s3-20020a170902a503b029012b2429385emr1051035plq.64.1628722127847; Wed, 11 Aug
 2021 15:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
 <20210805185750.4522-3-xiyou.wangcong@gmail.com> <20210811212257.l3mzdkcwmlbbxd6k@kafai-mbp>
In-Reply-To: <20210811212257.l3mzdkcwmlbbxd6k@kafai-mbp>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 11 Aug 2021 15:48:36 -0700
Message-ID: <CAM_iQpUorOGfdthXe+wkAhFOv8i2zFhBgF0NUBQEBMkGYTavuw@mail.gmail.com>
Subject: Re: [Patch net-next 02/13] ipv4: introduce tracepoint trace_ip_queue_xmit()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 2:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
> Instead of adding tracepoints, the bpf fexit prog can be used here and
> the bpf prog will have the sk, skb, and ret available (example in fexit_test.c).
> Some tracepoints in this set can also be done with bpf fentry/fexit.
> Does bpf fentry/fexit work for your use case?

Well, kprobe works too in this perspective. The problem with kprobe
or fexit is that there is no guarantee the function still exists in kernel
during iteration. Kernel is free to delete or rename it. With tracepoint,
even if ip_queue_xmit() were renamed, the same tracepoint must
remain in the kernel.

Thanks.
