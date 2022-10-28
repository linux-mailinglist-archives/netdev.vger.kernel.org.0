Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306AC611ABC
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 21:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiJ1TQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 15:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiJ1TQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 15:16:16 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED931E5752;
        Fri, 28 Oct 2022 12:16:13 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id hh9so4067093qtb.13;
        Fri, 28 Oct 2022 12:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/zUA55j6bGaAW55rrgaZLNo/FwpCg98UOwh1INpdeN0=;
        b=LMLdME8Lv7krlJpfH8Xm6UzyPc2KpjaAKY/n04D1qzMTEpS3uBfEFN9bweRLx0T1fg
         befV6z5RdwuIzTE+ubZZ6kfV5vAFNx309nR5zQsEMvNMwsuH0XGpwTOBcRNQ/CwiLvy8
         MtvoEAJZIbhuv+N3FMD/fVpIgztK0fvZhb8mTjdQzmjo6FNLj5PDvEhInBR2uQlmgr7n
         32mN8e0cEuVr/Z5B65FzevO7t+Y2w3hGsUErmOAdK2rX+AR8+PX2tbLqxQypA9HuDjzN
         RT6PSvzoz2ZcAlsxgUKo+7+V3mD+ZMgwofGzeI22vBP32WYr7KQzJ5pAQ+MGILDiQwVg
         wd4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zUA55j6bGaAW55rrgaZLNo/FwpCg98UOwh1INpdeN0=;
        b=ujDGjayN84jr5uS2laU9xC+rQWF4bKIYdBdqwskiZ++Qo52r5t9iOCAsOBAhWLxT+5
         GMqRq+uTXLBeS7KwzlQPKE9KMVdePCcWzPuZidErLiaNZyix0h8mUQ6re8LfAK8zuVTW
         br38UHNhURTSKLBb4983kvBZ2Lb62E5v6qertefQ2v7+bPsc7sJ4oDtaKNWVPb9LbF+i
         008C41BbhVi9OPcEHBdIidaOqeOUqXpxeM7z2F4t4Mh6nUSD36FArJo7acBvHPaCzlDX
         rupRwFZ0WPodnzrAdsOlxmsJOxyL+mYwdfR2Ga6LFnp4X3kr8CSitwCblApLibNcQsqf
         C8ig==
X-Gm-Message-State: ACrzQf3VfONJvQoNWFXI7+61eQ1xEUkW7SX/w93P/rjhvvlhgX3v9Azy
        6N6nxdcHwwtR2K4SHMDzRiNyvDnwdk0=
X-Google-Smtp-Source: AMsMyM41qWc5QGKLa8un2aIngZEBaA4kTawbQtZTQGQGtOQU5d5BTR7ZBzzUNor+UPcYaB28lqSiKA==
X-Received: by 2002:a05:622a:350:b0:39a:286b:1b21 with SMTP id r16-20020a05622a035000b0039a286b1b21mr870771qtw.427.1666984573016;
        Fri, 28 Oct 2022 12:16:13 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:309e:e758:a2c9:d68c])
        by smtp.gmail.com with ESMTPSA id o8-20020a05620a2a0800b006eeaf9160d6sm3540613qkp.24.2022.10.28.12.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 12:16:12 -0700 (PDT)
Date:   Fri, 28 Oct 2022 12:16:11 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Message-ID: <Y1wqe2ybxxCtIhvL@pop-os.localdomain>
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com>
 <87eduxfiik.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eduxfiik.fsf@cloudflare.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
> > On 10/17, Cong Wang wrote:
> >> From: Cong Wang <cong.wang@bytedance.com>
> >
> >> Technically we don't need lock the sock in the psock work, but we
> >> need to prevent this work running in parallel with sock_map_close().
> >
> >> With this, we no longer need to wait for the psock->work synchronously,
> >> because when we reach here, either this work is still pending, or
> >> blocking on the lock_sock(), or it is completed. We only need to cancel
> >> the first case asynchronously, and we need to bail out the second case
> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
> >
> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> >> Reported-by: Stanislav Fomichev <sdf@google.com>
> >> Cc: John Fastabend <john.fastabend@gmail.com>
> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> >
> > This seems to remove the splat for me:
> >
> > Tested-by: Stanislav Fomichev <sdf@google.com>
> >
> > The patch looks good, but I'll leave the review to Jakub/John.
> 
> I can't poke any holes in it either.
> 
> However, it is harder for me to follow than the initial idea [1].
> So I'm wondering if there was anything wrong with it?

It caused a warning in sk_stream_kill_queues() when I actually tested
it (after posting).

> 
> This seems like a step back when comes to simplifying locking in
> sk_psock_backlog() that was done in 799aa7f98d53.

Kinda, but it is still true that this sock lock is not for sk_socket
(merely for closing this race condition).

Thanks.
