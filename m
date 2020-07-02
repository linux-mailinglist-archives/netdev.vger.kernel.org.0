Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF17212E3D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgGBUwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBUwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:52:50 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE4AC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 13:52:50 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id a12so30375769ion.13
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 13:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uWY2f9KJp9LWUkodv4DCB0N4gy8I19NkMl7CBWJuU3M=;
        b=IQfZwjh73PWLRu9I7ZO5d0UEGNj1Lxfn50003heN2EEfVdj9/037cEDEA6aSpXJDC6
         hZQd+OJcouSKC5hWy7e8uF1LCDsAIsHq/Ncrhfc+5chRAww5+GTDUIj350PjmKB+LzAp
         6DLWaGOi8olSW2Ae5lEBpFOLqcpDSqbRa3r3D/fmNdvQL5bft7ctZNLXFcgHelNdV/Nk
         WgL2U/sFkRyn8LDxiSFf9icfA2m6FJv7csPMcqa5jDS4dANORze4hqjk+QgdnHMnGx+f
         4iBOCf2zXYG0U6zL/KkAAAgOm3oUnLt+V4L7zCyVBFkVJbqr8or2SojsNydUvIcRsQJO
         ZqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uWY2f9KJp9LWUkodv4DCB0N4gy8I19NkMl7CBWJuU3M=;
        b=fW5sZd0g/p75pwX+sAHgkwah/n3dwVLqjLCa9K1Mz5klfIK/egq9AEbs8zqRrRGgOG
         pQu+SLNqupj1ggva8nMgC2EEO7awXIngsKU4QAMDVbY5MHhfLlC+sM2vXkwmA72sPEIg
         2LupiaoDmexMSX9pJoIuamTu7HhkuSUirGQSVuhrZkJnlo9cjH8zPfPcBdFTdDYjrwkG
         cx8mFPghMjq8jtr+vHJb4+ndsQI8BIeyBgoszG+vDDSBRQnPt51sM85LIAbX9KZV/j8h
         G+lfNXfx/FdnyVwLqbrGv7lwRwBxLU9lA0d1ojwUAkvxzuqp+TpgmwdMi4jh9tGj3CW0
         zDPw==
X-Gm-Message-State: AOAM531BJlFiAbOlH3V60UEUEM5lgCiuT5zLO99q+nxQl/H3//a0X5vd
        qpUI7wgfHM92uShpFVli9kQLCi1mwTZ8ZX4DQpc=
X-Google-Smtp-Source: ABdhPJwY1/TEnOh4DARo+sUxhvajT3LqYO7mv5EPhJ0aDoStxUCxvtoyw+qG2bTf8Pe55919r5sdyEnWzAbhaPHYyOc=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr8877842iol.85.1593723169874;
 Thu, 02 Jul 2020 13:52:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200701184719.8421-1-lariel@mellanox.com> <20200701184719.8421-2-lariel@mellanox.com>
In-Reply-To: <20200701184719.8421-2-lariel@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 Jul 2020 13:52:38 -0700
Message-ID: <CAM_iQpWnk4ZjY3SVLb5aooEpSVBSpNQBHXifNgoCV8pP30EuaA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net/sched: Introduce action hash
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 11:47 AM Ariel Levkovich <lariel@mellanox.com> wrote:
>
> Allow setting a hash value to a packet for a future match.
>
> The action will determine the packet's hash result according to
> the selected hash type.
>
> The first option is to select a basic asymmetric l4 hash calculation
> on the packet headers which will either use the skb->hash value as
> if such was already calculated and set by the device driver, or it
> will perform the kernel jenkins hash function on the packet which will
> generate the result otherwise.
>
> The other option is for user to provide an BPF program which is
> dedicated to calculate the hash. In such case the program is loaded
> and used by tc to perform the hash calculation and provide it to
> the hash action to be stored in skb->hash field.
>
> The BPF option can be useful for future HW offload support of the hash
> calculation by emulating the HW hash function when it's different than
> the kernel's but yet we want to maintain consistency between the SW and
> the HW.

In previous discussion, people mentioned act_skbedit. If you have
a legitimate reason for adding a new action instead of simply extending
act_skbedit, you have to mention it here or in the cover letter.

Thanks.
