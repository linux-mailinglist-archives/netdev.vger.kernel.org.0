Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72D961406D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 23:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJaWIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 18:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJaWIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 18:08:34 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E80A117C
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:08:31 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id sc25so32800616ejc.12
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=AUFZ27KO58pY4DGyCP23/k/Mkp601j4ArNtp1x4g8JM=;
        b=TcWK6Y98534y0LVy30JAamoKv4jpN6P0MFCKq1nfrYvQcURKtvef5NxVpPEPQm5irY
         I3I7UGnwa5YPUawzeicEnDYu9xJS298kKpGFgCtffRSTe3bDSvCRqGjFZA8gOvP15Lpu
         ZpiCq3iSXwRsmt0HIaC5LhUy7CHIXXHEj57yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUFZ27KO58pY4DGyCP23/k/Mkp601j4ArNtp1x4g8JM=;
        b=wqovkFHJyp0hkBfaRq95KbqdIjROTrce8/1Sn3NNki34wZDupofYGQsXnfiSRzI/6z
         lnvhOEzhjuqCbForDUe9cHy85vjKh1Eakxf0ZK9Mbsq5wGmUenvpKQw2OR3Hg4+/coLt
         7uEKae55dG2/aodq0K5+QxCAbMDnGSvi6nY6vYDqoqTqGhldC+uqZMKvHUxKCsbelF96
         XMVAHrRsC5iztnpHBcHzN3eM7rRVjJX2Z/oQq0TVcD912O2bqvGdi5Gd4DAgI/3VKsh3
         F9qTtANRYec8ZgLOujbjUhr/esVvJIzMEtlXq7ihIAC7bvoetbeFMtReFeyPs+y+GaKs
         PQNg==
X-Gm-Message-State: ACrzQf2ZVVTdIOl0S8m/X5K+nwY5W+Po8j1ohaicw5ThrmaCFWB6TdiP
        7XGsKSNe5Hgk7BzNRIUsliTgqg==
X-Google-Smtp-Source: AMsMyM7PuvWTMk5C3OXlIc4FX6Dj85mzgawZwH0QaGYEwimBDSI82JQK2C8gQt52ZAS6b3HQRhTdlA==
X-Received: by 2002:a17:906:9c83:b0:779:c14c:55e4 with SMTP id fj3-20020a1709069c8300b00779c14c55e4mr14970590ejc.619.1667254109667;
        Mon, 31 Oct 2022 15:08:29 -0700 (PDT)
Received: from cloudflare.com (79.191.56.44.ipv4.supernova.orange.pl. [79.191.56.44])
        by smtp.gmail.com with ESMTPSA id ud24-20020a170907c61800b0077f324979absm3445992ejc.67.2022.10.31.15.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:08:29 -0700 (PDT)
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com> <87eduxfiik.fsf@cloudflare.com>
 <Y1wqe2ybxxCtIhvL@pop-os.localdomain>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Date:   Mon, 31 Oct 2022 23:03:09 +0100
In-reply-to: <Y1wqe2ybxxCtIhvL@pop-os.localdomain>
Message-ID: <87bkprprxf.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 12:16 PM -07, Cong Wang wrote:
> On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
>> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
>> > On 10/17, Cong Wang wrote:
>> >> From: Cong Wang <cong.wang@bytedance.com>
>> >
>> >> Technically we don't need lock the sock in the psock work, but we
>> >> need to prevent this work running in parallel with sock_map_close().
>> >
>> >> With this, we no longer need to wait for the psock->work synchronously,
>> >> because when we reach here, either this work is still pending, or
>> >> blocking on the lock_sock(), or it is completed. We only need to cancel
>> >> the first case asynchronously, and we need to bail out the second case
>> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
>> >
>> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
>> >> Reported-by: Stanislav Fomichev <sdf@google.com>
>> >> Cc: John Fastabend <john.fastabend@gmail.com>
>> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
>> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>> >
>> > This seems to remove the splat for me:
>> >
>> > Tested-by: Stanislav Fomichev <sdf@google.com>
>> >
>> > The patch looks good, but I'll leave the review to Jakub/John.
>> 
>> I can't poke any holes in it either.
>> 
>> However, it is harder for me to follow than the initial idea [1].
>> So I'm wondering if there was anything wrong with it?
>
> It caused a warning in sk_stream_kill_queues() when I actually tested
> it (after posting).

We must have seen the same warnings. They seemed unrelated so I went
digging. We have a fix for these [1]. They were present since 5.18-rc1.

>> This seems like a step back when comes to simplifying locking in
>> sk_psock_backlog() that was done in 799aa7f98d53.
>
> Kinda, but it is still true that this sock lock is not for sk_socket
> (merely for closing this race condition).

I really think the initial idea [2] is much nicer. I can turn it into a
patch, if you are short on time.

With [1] and [2] applied, the dead lock and memory accounting warnings
are gone, when running `test_sockmap`.

Thanks,
Jakub

[1] https://lore.kernel.org/netdev/1667000674-13237-1-git-send-email-wangyufen@huawei.com/
[2] https://lore.kernel.org/netdev/Y0xJUc%2FLRu8K%2FAf8@pop-os.localdomain/
