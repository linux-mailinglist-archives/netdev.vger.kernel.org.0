Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881626E2648
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjDNO5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDNO5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:57:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8441710;
        Fri, 14 Apr 2023 07:57:29 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id xd13so12340712ejb.4;
        Fri, 14 Apr 2023 07:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681484248; x=1684076248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DM2mW2Rbzq80i13ESUhdjRuNie03MRT+cBj0ZCjad9Q=;
        b=O1urDIL0iVK8fIqb6jvRx//AnvMSlvAViqigw8GkIFRQwMcEzKFOmoRQ3ds/rp0tPQ
         t4BOdSyq1LGN70nqTn9T9piWqIBpvdoF/OCBhokMB7nudO/ZkyJQhV56FKGGn/OVvM60
         XtQgISR7pYEAjBh/GD9vy5vUjHOtGZwmxvVp2yfyoFZDoaTFHVMAfRepSpoSPpdjOyT+
         xVTBXPAxTZsDg1oMfLwruQs6X50IjE+v5ivPxZ2kJ/Wuqu3JR2+KuLrxbdB3WpP61gWY
         zMAnjrFpnTXYEtzPg+udbe+yMY/Z3gOmtg3gdpeNE2ua/t6fluoBV2tdJ5+CGc2xEFiU
         pvxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681484248; x=1684076248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DM2mW2Rbzq80i13ESUhdjRuNie03MRT+cBj0ZCjad9Q=;
        b=HgRof2d4GG8AN0qdu4MaqNoi8K4US6DwM/YBIMSmV/1QHvuusg3I3TNN/9L7Oj7at1
         D36z2mp1pGLPSlTkhowe7rDaSCOnUlweTKx8nPMQplPcPncvY6VUeDXSRRtxqxU2fuP2
         PFJMGBFI0lU1g8P0pBHtMkfxTknuSquT2baNVc5VKHOSsvkjC+oNQ0+HN4UD2nATFOKu
         OtQ448C7mK1NDAY8Db/R73FHJkeR0hYoLFCCzBVrr6sH5Vhi0TUBcdIBlROmy2wlQNmU
         S8UVvcLZ+PiQhln3+4/1lPsmbQd5oaApDCOVKqehjc3hH/w69yz9DAB7Uxo+h9q2Fw1h
         0H2g==
X-Gm-Message-State: AAQBX9cwqPKbgan0Z8e3m4uGZ7ClD9QeugWkHsuFOLPg5ZhmH+HSghzN
        ELVQYDlnIEw2q0blBYPFRYg=
X-Google-Smtp-Source: AKy350bHkOFUpBb3YsaKjCJ11CfDiHR+Lq4nnsJ+NGuM2lOCiYs75yLUnU3A5RILbGNYokF5dMCcIw==
X-Received: by 2002:a17:907:25c9:b0:94e:ef09:544c with SMTP id ae9-20020a17090725c900b0094eef09544cmr1860484ejc.10.1681484247950;
        Fri, 14 Apr 2023 07:57:27 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:b2ce])
        by smtp.gmail.com with ESMTPSA id gj19-20020a170906e11300b0094a83007249sm2602686ejb.16.2023.04.14.07.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 07:57:27 -0700 (PDT)
Message-ID: <e152d8f0-6bf9-f658-f484-f7a18055a664@gmail.com>
Date:   Fri, 14 Apr 2023 15:56:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH RFC] io_uring: Pass whole sqe to commands
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        davem@davemloft.net, dccp@vger.kernel.org, dsahern@kernel.org,
        edumazet@google.com, io-uring@vger.kernel.org, kuba@kernel.org,
        leit@fb.com, linux-kernel@vger.kernel.org,
        marcelo.leitner@gmail.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <20230406165705.3161734-1-leitao@debian.org>
 <ZDdvcSKLa6ZEAhRW@ovpn-8-18.pek2.redhat.com> <ZDgyPL6UrX/MaBR4@gmail.com>
 <ZDi2pP4jgHwCvJRm@ovpn-8-21.pek2.redhat.com>
 <44420e92-f629-f56e-f930-475be6f6a83a@gmail.com>
 <ZDlcXd4K+a2iGbnv@ovpn-8-21.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZDlcXd4K+a2iGbnv@ovpn-8-21.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 14:59, Ming Lei wrote:
[...]
>>> Will this kind of inconsistency cause trouble for driver? Cause READ
>>> TWICE becomes possible with this patch.
>>
>> Right it might happen, and I was keeping that in mind, but it's not
>> specific to this patch. It won't reload core io_uring bits, and all
> 
> It depends if driver reloads core bits or not, anyway the patch exports
> all fields and opens the window.

If a driver tries to reload core bits and even worse modify io_uring
request without proper helpers, it should be rooted out and thrown
into a bin. In any case cmds are expected to exercise cautiousness
while working with SQEs as they may change. I'd even argue that
hiding it as void *cmd makes it much less obvious.

>> fields cmds use already have this problem.
> 
> driver is supposed to load cmds field just once too, right?

Ideally they shouldn't, but it's fine to reload as long as
the cmd can handle it. And it should always be READ_ONCE()
and so.

>> Unless there is a better option, the direction we'll be moving in is
>> adding a preparation step that should read and stash parts of SQE
>> it cares about, which should also make full SQE copy not
>> needed / optional.
> 
> Sounds good.

-- 
Pavel Begunkov
