Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8F92CDD31
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbgLCSSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgLCSSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:18:05 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E03C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 10:17:25 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id y5so3053530iow.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 10:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pSh2mdC7u3jYyuadkXEKxhnw2EdBMqG74YREkWtGxzs=;
        b=pH5KLWJOYLAYoMpUZBNfHMaZ5E2mGJcez938N7fELV0yceC8u+BNwqR7KSgii3lU+z
         EUWF118GMrbQo/MbiQ7arjsoMXJiDqn+eHgnALl3putfca4BgyAhZqt7BqfEoQpexKrH
         Y+nUBHeaCZOkBcvtQmA3gD8IiJ1f1qdt52paVWsZ/d5MYMW4LZEj90ljQeHABpmsQbF0
         d/BTSRMfauF6XXNec03vsqrJR/POOfYFWFqpwFsrCj4jA3a+Tc5SMHW1sFpFklBDElWG
         4Fd12OXzSnrahS/tICth1iwzKYhnlWY6xW1KVC5D0FgSBmERwEUS0vxbR9HVnorgldSA
         692A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pSh2mdC7u3jYyuadkXEKxhnw2EdBMqG74YREkWtGxzs=;
        b=oFcRwLDPoaeZpfZqqCgeTjhYuVfjjjXcRSFJuqA5bgAqDejfyOMxgnTaDqbvcD9hCI
         cDzfgQLJxssI4wGVRaWsj7BKesJTC1sbLCC/VjEnJsCXKfUcul1ElUncZ7I3KYLCnLnN
         Bo7Whou/35CIPO3Ftvv7yxAEaPSIK/6YcuKY0CoXEAmAqEag5vnzwV2Ki4uhhySSPyqm
         eQkHq+YnE/ceWhkmDNejZPqnUsvLGdoJ5cgl+6H5qmrWTh1pOGIo/q91I29lomyMm9bh
         BEO9ikkHpaVjmYKWeoAPNVqDTYJ24HkIAwyIFNzVMVkoXk36qy3y1IgppaXj9JXODUo9
         vBiw==
X-Gm-Message-State: AOAM533M/ynia/BNqHjXlbBDqEm1wKzuUd+2CHznOOB72L5L1jJDvdS/
        3P+VDNkTfTeuoqf+3RiIn83nEx1JpyBSzq7BqKc=
X-Google-Smtp-Source: ABdhPJyg/h0QFwwgOB+1ZRPRQC6BIM5BtZbrbcjKV3BOlb9QFX08SmcT8oKyWiopJzSjFpalytaB/ORjp1CAq6DlKL8=
X-Received: by 2002:a5d:964a:: with SMTP id d10mr507706ios.5.1607019444940;
 Thu, 03 Dec 2020 10:17:24 -0800 (PST)
MIME-Version: 1.0
References: <20201202182413.232510-1-awogbemila@google.com>
In-Reply-To: <20201202182413.232510-1-awogbemila@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 3 Dec 2020 10:17:14 -0800
Message-ID: <CAKgT0UcOWkxAEqa+_T-QQiF_jgyozGe=U_vx_L3kzc1LsQ-Q5Q@mail.gmail.com>
Subject: Re: [PATCH net-next v9 0/4] GVE Raw Addressing
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 10:24 AM David Awogbemila <awogbemila@google.com> wrote:
>
> Patchset description:
> This  patchset introduces "raw addressing" mode to the GVE driver.
> Previously (in "queue_page_list" or "qpl" mode), the driver would
> pre-allocate and dma_map buffers to be used on egress and ingress.
> On egress, it would copy data from the skb provided to the
> pre-allocated buffers - this was expensive.
> In raw addressing mode, the driver can avoid this copy and simply
> dma_map the skb's data so that the NIC can use it.
> On ingress, the driver passes buffers up to the networking stack and
> then frees and reallocates buffers when necessary instead of using
> skb_copy_to_linear_data.
> Patch 3 separates the page refcount tracking mechanism
> into a function gve_rx_can_recycle_buffer which uses get_page - this will
> be changed in a future patch to eliminate the use of get_page in tracking
> page refcounts.
>
> Changes from v8:
> Patch 4: Free skbs that are not sent in gve_tx().
>
> Catherine Sullivan (3):
>   gve: Add support for raw addressing device option
>   gve: Add support for raw addressing to the rx path
>   gve: Add support for raw addressing in the tx path
>
> David Awogbemila (1):
>   gve: Rx Buffer Recycling
>
>  drivers/net/ethernet/google/gve/gve.h         |  39 +-
>  drivers/net/ethernet/google/gve/gve_adminq.c  |  89 ++++-
>  drivers/net/ethernet/google/gve/gve_adminq.h  |  15 +-
>  drivers/net/ethernet/google/gve/gve_desc.h    |  19 +-
>  drivers/net/ethernet/google/gve/gve_ethtool.c |   2 +
>  drivers/net/ethernet/google/gve/gve_main.c    |  11 +-
>  drivers/net/ethernet/google/gve/gve_rx.c      | 364 +++++++++++++-----
>  drivers/net/ethernet/google/gve/gve_tx.c      | 202 ++++++++--
>  8 files changed, 577 insertions(+), 164 deletions(-)
>
> --
> 2.29.2.576.ga3fc446d84-goog
>

Other than the few nits with counters being u32 values I didn't really
see much else.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
