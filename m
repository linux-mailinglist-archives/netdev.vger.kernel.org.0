Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7833862C8B5
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 20:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiKPTFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 14:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiKPTFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 14:05:41 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C08663CCD
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 11:05:38 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id h206so13958827iof.10
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 11:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SgUDQ7fTMcbpfISs13tUVTWzG6QDssJGORk5OuaL/yY=;
        b=nR55EZhOqEj19+779f1OZuF0PouFIFHXSbVqbRu9EiJIB35cign6f0EvzeFXFLoeG0
         7Qui6tca/Xi3oH/0OPBm4wcmoM+1bm00nJZcgi3fq3PfKQdzpXeBNUWDck5dwchFsCe9
         KUqa0VmQO3ANmCGsiImCN9I5qjyN5xHv/gWX4ENGTz+YRBBRBHUINvyXyYVoHK9sTa/8
         +YwTeLlhOs6B2fY2EyF1WETqzIuS30INxqh6KRwFrgyptMBepoeQgsS6FXEgKqUuj46i
         SvjDVxC4xCHhfqKsG00+LAZM/t76JGLobvhA+z5qfkkUaVA8mrgFiMpjck2pHkQXb//Q
         Cj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SgUDQ7fTMcbpfISs13tUVTWzG6QDssJGORk5OuaL/yY=;
        b=C8pLU0aiz5a8+pT6T/Tq6fAjXFinXXi+Q8pVr4mx23sQ11YPGOcdr80M3tZrZv2PR8
         jYP4XPmpoorotaClxVwMgBYofrDG/ucDKszAce/Rh7scmewlIWjiXK1WKE7hK7JvMN/Z
         iCfa2awtVrs8LBKV7FvcV5yIghQ1GTt880nejgG3JjQBCargPU4TmQ1KNZboCKHpCsE6
         EQbOuWvV6y0y/SqGUYku461j67nntWLNJUlDfzW1sTuBsjIBwiyoUFgf9KyTTjrXjusm
         zGdsFVNLWOwXx/TshREErn07fSKekVjKCNFEHFzYokcIQr6Nl8pS6JdWzEtVj6Yxbbzt
         w5pQ==
X-Gm-Message-State: ANoB5pljFDJP/+q4my2b8Go8GKbJlxmeWSsUY7bcT32RWCGeyIZ5ka5c
        qlNxQAi6D/gyDvy84s1eXSYsmg==
X-Google-Smtp-Source: AA0mqf5++B/DzRkeZGi5+AUv0ysMrhFaKRlFr4MA+ugGjtPYDeJMoHYitzwJo7uTTE48NUTSmZN9fg==
X-Received: by 2002:a05:6602:88e:b0:6a0:d590:f5d with SMTP id f14-20020a056602088e00b006a0d5900f5dmr10659410ioz.179.1668625537519;
        Wed, 16 Nov 2022 11:05:37 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o10-20020a92d38a000000b0030258f9670bsm4107038ilo.13.2022.11.16.11.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 11:05:36 -0800 (PST)
Message-ID: <efa34cc0-b458-ea84-c23a-1ea8f46603be@kernel.dk>
Date:   Wed, 16 Nov 2022 12:05:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [RFC PATCH v3 2/3] io_uring: add api to set napi busy poll
 timeout.
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
References: <20221115070900.1788837-1-shr@devkernel.io>
 <20221115070900.1788837-3-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221115070900.1788837-3-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 12:08 AM, Stefan Roesch wrote:
> This adds an api to register the busy poll timeout from liburing. To be
> able to use this functionality, the corresponding liburing patch is needed.

Kind of related to the previous question, but I think we should just add
a single REGISTER opcode for this, and define a struct with the delay
setting. Add necessary padding for that, check padding for non-zero and
EINVAL if set. Then patch 3 can just add that struct field.

The IORING_REGISTER_NAPI can then also return the current settings by
just copying it back. That makes it a get/set API as well.

Patch 1 would be unaffected, this just changes patch 2+3 for the
io_uring API.

-- 
Jens Axboe
