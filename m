Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7268042A71D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbhJLO1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhJLO13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:27:29 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC56C06161C;
        Tue, 12 Oct 2021 07:25:26 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q205so23873242iod.8;
        Tue, 12 Oct 2021 07:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KWoitxVyZQwdxlDZZv3M7By9k6ofLJtF2jYta+4n3Zk=;
        b=Imf2/G83txERMJQehqzzYvI0tNQYw7bfd9h2WoZYMFnlg9mg5JHvYyUY7hHFo+MXa/
         Y1+6Yl2P6KflD6N50aBlKgKDEmxxE1qiZesQAcbkAKdZvGcv7hsIiROEZPne59sKaWl7
         c6LjoZSo+pHYt8DlQjCecugHVQsG9V0h8WwFgrOHxjAQdXYDGR7qvWhUkjAsm8tznXVB
         +huY843oj3198wQBPoZRUVc321c9u0h7WhlpuqQtt7+mE3S2VDEkv4TRw24TK67CWMsr
         3UL/hRYdhKWapc8adW+0hP7JCdB28xvhMmgshb616ElSAYi0OOfkac97WoG4F6s0pqPV
         tMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KWoitxVyZQwdxlDZZv3M7By9k6ofLJtF2jYta+4n3Zk=;
        b=bmh2Jzeqd/PtM9ZilF54VqUAA1I91PN0VOx6MSRvRfRWL+cJ+wfT1X9U/c4orBmFGK
         vepd2ES7AEYg3Yq/z+HZkep4AWykClQE1LBJ/MsEkax7urx7uqrlwzPTxD/X3DgOzYMT
         8Gq1hqSMwamJMcCl0fCjcRMne2Mh1BHXWMNJM9D42YpOpOX5P2q6vJb6IvdeeeS/b6Xp
         hiaMi7brdw5ok3uSVDf/G5L8jZZ6QsoMylWQE41GHOAU1/ZYY/YcK7XSWmuk3LEA9JYS
         3zZ9aVQxW+TRocpsGsg3BXXpJxQsXq1Q6QRDTLnAYb/2Rle6yjxKTyqCqdpEGY4QfY3C
         89Ug==
X-Gm-Message-State: AOAM531WU6s0buL5LJoMM+xpl6c29jSHyryMKOlP9MWQSlEECKDbRgdr
        1zvJFyKAlpX89SsJxbZLpaMVH248oDT43A==
X-Google-Smtp-Source: ABdhPJwTSk7HiXzt6GRsTNLO6nHwe2Icfv+ybOnR5Q5DNWCKwMgSY24OW2RO3Wkco+Hs8OZXC6seDg==
X-Received: by 2002:a5d:968b:: with SMTP id m11mr23525880ion.83.1634048719603;
        Tue, 12 Oct 2021 07:25:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id c5sm5005122ilq.71.2021.10.12.07.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 07:25:19 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net, neigh: Enable state migration between
 NUD_PERMANENT and NTF_USE
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-3-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <90cf9c84-54f0-b42f-3c6b-95b6a5e2e82e@gmail.com>
Date:   Tue, 12 Oct 2021 08:25:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211011121238.25542-3-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 6:12 AM, Daniel Borkmann wrote:
> Currently, it is not possible to migrate a neighbor entry between NUD_PERMANENT
> state and NTF_USE flag with a dynamic NUD state from a user space control plane.
> Similarly, it is not possible to add/remove NTF_EXT_LEARNED flag from an existing
> neighbor entry in combination with NTF_USE flag.
> 
> This is due to the latter directly calling into neigh_event_send() without any
> meta data updates as happening in __neigh_update(). Thus, to enable this use
> case, extend the latter with a NEIGH_UPDATE_F_USE flag where we break the
> NUD_PERMANENT state in particular so that a latter neigh_event_send() is able
> to re-resolve a neighbor entry.
> 

...

> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Roopa Prabhu <roopa@nvidia.com>
> ---
>  include/net/neighbour.h |  1 +
>  net/core/neighbour.c    | 22 +++++++++++++---------
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

