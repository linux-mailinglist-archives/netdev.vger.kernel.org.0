Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898BC689970
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjBCNFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjBCNFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:05:52 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15A62CFD8;
        Fri,  3 Feb 2023 05:05:50 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s13so1931531pgc.10;
        Fri, 03 Feb 2023 05:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5w+nYoWjzuliDhSGVPTUj9Z+BoFlBQYJcan2JoWEXcs=;
        b=ZQz2LnvEUQNIE/f4fkfZTvHfkfiIs34elkVJyvVX8ZDfvMdQ3Fnh3lT6rxu4F3PTfM
         uF1JhQ6IvLHnb0AKTzBZV48Y0I1BihfaFSEjJo2jI1+1iZyAuFsTQ7/fsKndNzAFsKxr
         VdvhSVyw02H1BhHw+nwxJUUJoi02ROA2CkItfGU79/M+U49xOWif7GvJG/y6ksPygxXA
         TeEVUaONJzU/fF9d89pmamWP+8kYJcDlYoq9iFwlOZTd1hrE1TtpzJM4CBTUUbTHe2HS
         AeegXgMyYExLa9u7rQmjJZOQdMtwpR1XCzkdoIhbcwF/ysvP7Tzg9d7N+YwxejdtGJsI
         IgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5w+nYoWjzuliDhSGVPTUj9Z+BoFlBQYJcan2JoWEXcs=;
        b=Jb7SE+5QjFss76rGVQr6Iokav+PhB0eV4gSl2i9npHijzSnY/VeIEvkByqB2bvoN7U
         u9CkoKwIlChRJn5QIEy8EtR9YldgxfpGHPqV737x0GCAA3Hj+kgjLZvjhg4IFKOyVzS9
         uV91/NjQ+v3lDqx7fvC79HpaFEOqtpuArSe7S0NHqwE+OucRAK0e2w3M+q78fsG5XMXu
         /rbw6MLw/AnALlwqtGq5lYVuDlGtKEnFTR76z7RhdX3syTMuokQAlC6R5JKKtueLvTpC
         t8H0ca5YvGv0YAIQDgGRt+sQfC+NzLJr9Jtq0k1Jb1jxkNfuB7cHzcmn4/3//4EVdOaw
         oylQ==
X-Gm-Message-State: AO0yUKXiEheIs6eIt86hvLyh1th2u8w5VAX/zIwlIkfms2s10oxyK2Gq
        dgmAwONDVzzraZM+1gXph3fDBkUGvWG8+ANXg+U=
X-Google-Smtp-Source: AK7set89BQi2I5AisOwWpSQfAQCmcr7aHQAQBKKe7iYnnEkfq1/zW6ewBeZrLVGafe9/Co/j5nhFpQT1U0tdNPkPOGg=
X-Received: by 2002:a05:6a00:10c1:b0:593:aa4e:e956 with SMTP id
 d1-20020a056a0010c100b00593aa4ee956mr2309848pfu.21.1675429550181; Fri, 03 Feb
 2023 05:05:50 -0800 (PST)
MIME-Version: 1.0
References: <20230202024417.4477-1-dqfext@gmail.com> <ec42f238-8fc7-2ea4-c1a7-e4c3c4b8f512@redhat.com>
In-Reply-To: <ec42f238-8fc7-2ea4-c1a7-e4c3c4b8f512@redhat.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 3 Feb 2023 21:05:41 +0800
Message-ID: <CALW65ja+P+E0fjEsZfm1XWb_dn_snuRoFA5i_i+_1K9j0+wi7Q@mail.gmail.com>
Subject: Re: [PATCH net] net: page_pool: use in_softirq() instead
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

On Fri, Feb 3, 2023 at 7:15 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
> How can I enable threaded NAPI on my system?

dev_set_threaded(napi_dev, true);

You can also enable it at runtime by writing 1 to
/sys/class/net/<devname>/threaded, but it only works if the driver
does _not_ use a dummy netdev for NAPI poll.

> I think other cases (above) are likely safe, but I worry a little about
> this case, as the page_pool_recycle_in_cache() rely on RX-NAPI protection.
> Meaning it is only the CPU that handles RX-NAPI for this RX-queue that
> is allowed to access this lockless array.

The major changes to the threaded NAPI is that instead of scheduling a
NET_RX softirq, it wakes up a kthread which then does the polling,
allowing it to be scheduled to another CPU. The driver's poll function
is called with BH disabled so it's still considered BH context.

> We do have the 'allow_direct' boolean, and if every driver/user uses
> this correctly, then this should be safe.  Changing this makes it
> possible for drivers to use page_pool API incorrectly and this leads to
> hard-to-debug errors.

"incorrectly", like, calling it outside RX-NAPI?
