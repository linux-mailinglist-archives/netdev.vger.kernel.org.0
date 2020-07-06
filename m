Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1315B215FA0
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGFTsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgGFTsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:48:17 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00B8C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 12:48:16 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k23so40604213iom.10
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 12:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j7gd7rjNllwDaYGD2ly7SO5/dMdtTZlv8exIAYJkBDE=;
        b=j4hWXrJ1dHuyws6mhOwXa5VM2hDr9tCmb6eATfUhnSy9si3PjeriR6YBg7z5kde5Lr
         8yfqkN5c4HIlOYHqJD35PJ7L/t2kvq4JTyLpIlVSLBLXoQzJZllDHleeWoNWZSUjGpou
         H1nsAlqDO3uinYhIw5sLBV+BWRdCH6M3D6pLDka9uWQX6UhiYUihlcCm4vnzn6Ki5Z2C
         C7YLw3AOEY66E8ZzJ0zVup+E080QEkioFdmLCMF2wFu4Enwem64o7K98f95O/w5yFcNq
         IVNjkqPpSyhoUsCsl3Dz6Scy5iAaGjghzp3q8kNimCLq7LXrAO8hOJ2N7X1eQx1+oJ2d
         eA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j7gd7rjNllwDaYGD2ly7SO5/dMdtTZlv8exIAYJkBDE=;
        b=mJsfi4pR9FDjjICeFVQ/sxTe4xt1Y9e9xpn5foHoj7lV9ssI/ud/y0/9aLYgXsNOpN
         YrdFwniNi9kmXvJutr4pKg8dNZ3lm1NcK0XNKp/IlWN/Fi8/UgRXYUbeXf+rRpLPIFjm
         DLsioxlZjqPkI6K+rsULXCa16mZFBX4fO3hemeV+7FCNojjmKwdSKu6yEgtyts9QjhOR
         7FlLgxZFJPTxFFVhfyDRtNYxYuikXDMlEUy5R7jDbS/yy5NNCjcAN0K+I0WRZTNP4gB3
         iy1SqXvj0UbsFM5DnxW6uq8oH3pYV3hmzhIrURcJ3iTx+MGwBOfe2FqWLY+ujiimANbF
         nA1g==
X-Gm-Message-State: AOAM53137sh3uJ1UXzRCcmYRkwF+wxRe1snI+gIVS48KNDl3rNIdeJ+x
        BcHmDDI9Upp4/F/j1D/VBQMHz7zSB62EX5bMEmM=
X-Google-Smtp-Source: ABdhPJxLIxab0F1IwqpxbS3f9cKKzh8mmxwh2WcBgK9WR81Bv6FDMIH+Qsr23LrOG5L4msKzOMnMz6jn8dig7V9txyU=
X-Received: by 2002:a02:c948:: with SMTP id u8mr4432615jao.124.1594064896371;
 Mon, 06 Jul 2020 12:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
In-Reply-To: <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 6 Jul 2020 12:48:05 -0700
Message-ID: <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
> The function tcf_qevent_handle() should be invoked when qdisc hits the
> "interesting event" corresponding to a block. This function releases root
> lock for the duration of executing the attached filters, to allow packets
> generated through user actions (notably mirred) to be reinserted to the
> same qdisc tree.

Are you sure releasing the root lock in the middle of an enqueue operation
is a good idea? I mean, it seems racy with qdisc change or reset path,
for example, __red_change() could update some RED parameters
immediately after you release the root lock.

Thanks.
