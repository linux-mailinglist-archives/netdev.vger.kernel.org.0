Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D75855EDD5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiF1T3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiF1T2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:28:50 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F5D381A2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 12:26:17 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 136so7768830pfy.10
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 12:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RZfDjKtOuj09lgIaPNLgdLuWW2OqPIBAAaOMl71QkGc=;
        b=afUjvtBZuciqKQ343qcfWC3FaNvjRcGVVYpwtN91XA99Dm9z1YTtIMpEWidMVzTDTA
         yiR2LpmOBVa5jry/NRJ4OPPy1WnZ4dytPKcVs7wBregvv+vn4xF3FUJ7IEZ907SWCB8t
         Lf/uuq5keCdgDOz2ZpiZ7mpBkzSZn/V2EMBRo36CEY56QJbp+c+Ft0Z/328MF7qAdv1W
         engj7/ZSAFecZm4SsfrzX3nSLO4F5be2Qo1y26WkS+LnAi12x7+HFh3PX46OaDwYHRvT
         q2zhywQrU8e75ZoHnyvmO4tdNxR+hgrbBcYIuOGU62JSeddTqbU5Np3DPmJe6KhYcCTY
         u9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RZfDjKtOuj09lgIaPNLgdLuWW2OqPIBAAaOMl71QkGc=;
        b=XiiRTkrpk+Ul3uIyQMJ6Mu/p45vdbboExnUgVjzaew4WDv3MbO/DRLV+KePUzmmzrH
         PYeswV0ywb2wpsHFOTNJbLcBxBoVN6BN1tbBVc2ymAqoEA7WV2KmUHL+gZL7yoT4zN5i
         ZekLyESqA9/5Uv0R6YGUBqsWWFNFtm6x1AFtN+PVWKsThBE9lyZdZokW8kROZR+GjNRO
         MEnUTpykYcZv2Ga4rddRL3SvkODdUmTImUysE5OuI7/R5p9sKFTVkiEfu9lAmxoF+pPk
         mCGt0DuZZgDPkBIlm5zMQU6ZLgk7YoB0FdQ6Haldm/3yrrLznNZsZQTVKUhvJaNsAjvD
         a3Xg==
X-Gm-Message-State: AJIora/GYIuyZhVTYnhUS6YtjcBufYXDdJOiNQW9SZhfw0EB45lCeDBv
        HZKYRXjUPiHEUNNsm4LM5MjcWg==
X-Google-Smtp-Source: AGRyM1vOqpBEFnmUUlVqbxSpYXW4QC7ILtAEqTdini3pp0DMQk7OqmKFghFLBsqoEdNiyHJe2LWztQ==
X-Received: by 2002:a62:29c2:0:b0:527:ab6a:c310 with SMTP id p185-20020a6229c2000000b00527ab6ac310mr6203732pfp.12.1656444376719;
        Tue, 28 Jun 2022 12:26:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::165b? ([2620:10d:c090:400::5:f46f])
        by smtp.gmail.com with ESMTPSA id jf20-20020a170903269400b0015e8d4eb25fsm9617300plb.169.2022.06.28.12.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 12:26:16 -0700 (PDT)
Message-ID: <31f47d42-ce33-b732-b7ba-098f6174efad@kernel.dk>
Date:   Tue, 28 Jun 2022 13:26:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: For 5.20 or 5.19? net: wire up support for
 file_operations->uring_cmd()
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd2ad505-4d1c-ff13-de87-b4b3d397e159@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bd2ad505-4d1c-ff13-de87-b4b3d397e159@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 1:09 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> I'm wondering what happened to you patch passing file_ops->uring_cmd()
> down to socket layers.
> 
> It was part of you work in progress branches...
> 
> The latest one I found was this:
> https://git.kernel.dk/cgit/linux-block/commit/?h=nvme-passthru-wip.2&id=28b71b85831f5dd303acae12cfdc89e5aaae442b
> 
> And this one just having the generic parts were in a separate commit
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-fops.v7&id=c2ba3bd8940ef0b7d1c09adf4bed01acc8171407
> vs.
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-fops.v7&id=542c38da58841097f97f710d1f05055c2f1039f0
> 
> I took this:
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-fops.v7&id=c2ba3bd8940ef0b7d1c09adf4bed01acc8171407
> adapted it on top of v5.19-rc4 and removed stuff that was not really needed.
> 
> Even if it's not used in tree, it would be good to have uring_cmd hooks in
> struct proto_ops and struct proto, so that out of tree socket implementations
> like my smbdirect driver are able to hook into it.
> 
> What do you think?

We need to just finalize a format for this, don't think it'll be too
complicated. But for in-kernel users first and foremost, not for some
out of tree code! I've got various things I'd like to use it for
internally too. For example, returning number of bytes left in a socket
post receive rather than just a flag telling you there's more data.

-- 
Jens Axboe

