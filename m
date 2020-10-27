Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D639229C201
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819241AbgJ0R2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:28:44 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:33280 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1819229AbgJ0R2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 13:28:42 -0400
Received: by mail-io1-f43.google.com with SMTP id p15so2428210ioh.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 10:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2rBY+rxllMAuu6X633d3gx4owrRmPzJZZ3hvHn7KU2E=;
        b=kGk1MJx8womcscOt80gl1emc/j3xWfmrwfTGGd1CBZDDit59Unc3fLzojGWWrjHmS7
         SthwnNeaQeOu9YACzMxlr1YOC2VuEYDMo9CU/tNsmYVKRg4V6fwNr66rXDxKvKctN9Hp
         cMBbHTF3CaZ28S/Lx1CPnAQgwcBvwxTZBHNtsVu2kaY0t0zdepoQFHTZcaxi6ZTuJutZ
         fthBXwaIYL+cKRKb7jzcQcJhe/C1qX6rxqCku8zvy3a9KkLEAAXMta2WMrKsDBZHpdD7
         cn+tL6QMv8KWzQgaf985zFfLLKd0oyXPeTi88om/U1gE308pYtECcqh08cGEJd6lrIOV
         BptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2rBY+rxllMAuu6X633d3gx4owrRmPzJZZ3hvHn7KU2E=;
        b=tp+SvletOW3TmsihdSya0QhciAM+P5JukxUT55V4gTHa2ge+vpaiNVjlQWlsmLdd+o
         GjpIhKu+9uY9trK/7YoSomjFbHT6mXSsrXI50G/Xyq4dzEot7P2kvFICi8/lq79IKqj7
         7vxA4pUjDhNHtQsV9pMlOl6eL07NYe/6ibi8a9uwC4fnOQl4bogqEd3W/xqPQ3XYaipP
         B/PJ91GdlATUAYN7MNVuMZJcn/EotRSyAne3buYMRCRTllrz0+YnyG4F5sFrFzMS33rv
         6H6VEZDh1ewsKKDbIc1GuaphEFJdmBYZ8ovVbcUXbsSGDmxLPmbZU91UHrD/R5mkBH2M
         ygHg==
X-Gm-Message-State: AOAM533UzXyt8yUyLrSe+k+mZDDc5P6sRT6b/1mNr+iPfQxiWQ2NIuia
        j03yV8mabE81VuP+ir8xLhjfPhZTTWd4YykW1nU=
X-Google-Smtp-Source: ABdhPJwF0J8FAW1b5tB3Pt93UOHmQmLbrnuDlzoQYPct1foEEG8szH0TenwMfzmGUUNb6MyshLswAYy7mYCbgkC1f24=
X-Received: by 2002:a5e:8d15:: with SMTP id m21mr2990445ioj.134.1603819721070;
 Tue, 27 Oct 2020 10:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
In-Reply-To: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Oct 2020 10:28:29 -0700
Message-ID: <CAM_iQpVBpdJyzfexy8Vnxqa7wH0MhcxkatzQhdOtrskg=dva+A@mail.gmail.com>
Subject: Re: [PATCH v2 net] net/sched: act_mpls: Add softdep on mpls_gso.ko
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 4:23 AM Guillaume Nault <gnault@redhat.com> wrote:
>
> TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
> packets. Such packets will thus require mpls_gso.ko for segmentation.

Any reason not to call request_module() at run time?
