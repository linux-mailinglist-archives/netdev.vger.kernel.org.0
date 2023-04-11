Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2816DDE96
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjDKOzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjDKOyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:54:55 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4A146AF
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:54:51 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7606d7cc9bdso2756439f.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681224891;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n1/uakkZjv9cQF6P7up1HAscrfLZ1PckVlhhE3kXYRA=;
        b=i2M7Gt5eHTm8Zs3MHrk2JXdsmGkyZeCGjw4sJo9A0tJ26iSzx4aGtypYqkuS6DYNUz
         lv1RUSJkcY1cOnuVLJs4ky1/FBfMdyPk/UbAr++vHYTxtv9pREyb/taP47PWOFzlSuMd
         u2X+Rt6tRRnnS6EJ6xBsDnWIVJG5kzFKGBG5C34Rf8brfoKsgQR70flgDtlaTr4hkMtK
         40GCjDp8pq2KkGHK2ikm830ZQw/BPjREs1RKfJNSmVi1XbgCbldOvyTDewUFzkQmuKs/
         AERVqGet/CWXA1fCNIa0kcXhEBm1pVqsYVUPejuHM9u2J0G9iMPDz/RN2vBo+F8bg4R/
         zszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681224891;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n1/uakkZjv9cQF6P7up1HAscrfLZ1PckVlhhE3kXYRA=;
        b=qboULyBfLv48MsVict17zjR0JQwMsZnsHgVNyh/oAaFGAUhLCv3KNzykaTD6xw1UEi
         Hkxz6sJP9HS7f+pFTBl/S9PY/7Ruw87f6xatx3VXv2uJZN656yv80Mndb+6oYz3Izpe3
         +LIl+AHRw/3AkBHEEONaNxCkSgEjim/EmjoNx4gkwdsRbfsNV1BKoR7ewgv+BpJMC1dy
         WiXL7Aumd0T+A9UCgAAzXj/cCDsciBkBeBlMXhDhmnDdimerzW0EPU6if3mapAWG/vpB
         wlsa25KMAw0m/VcjcYn0bwBUa0tX7k6Cz3GDBvbdO1RIUjRYRMcGMUq0yxdVIXNlHSZ5
         ZO/Q==
X-Gm-Message-State: AAQBX9cAjnSd9ebthAv0wrh+vq35js5+P0tgQCeGShYQ/n0N2IdGRunF
        ff+XFWeGN2/iI0Inuj/jYCLTCA==
X-Google-Smtp-Source: AKy350ZNd1GN2qGTn8k0KmKiar/rBVtqQ95KVwEH4VZ0jhuU+wlCTFTF5pf6yJ2PAMLuldmKwNN0IA==
X-Received: by 2002:a6b:8d84:0:b0:740:7d21:d96f with SMTP id p126-20020a6b8d84000000b007407d21d96fmr4946123iod.1.1681224890937;
        Tue, 11 Apr 2023 07:54:50 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y32-20020a029523000000b0040bd91e4803sm980367jah.155.2023.04.11.07.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 07:54:50 -0700 (PDT)
Message-ID: <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
Date:   Tue, 11 Apr 2023 08:54:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 8:51?AM, Willem de Bruijn wrote:
> Jens Axboe wrote:
>> On 4/11/23 8:36?AM, David Ahern wrote:
>>> On 4/11/23 6:00 AM, Breno Leitao wrote:
>>>> I am not sure if avoiding io_uring details in network code is possible.
>>>>
>>>> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
>>>> in the TCP case) could be somewhere else, such as in the io_uring/
>>>> directory, but, I think it might be cleaner if these implementations are
>>>> closer to function assignment (in the network subsystem).
>>>>
>>>> And this function (tcp_uring_cmd() for instance) is the one that I am
>>>> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
>>>> -> SIOCINQ.
>>>>
>>>> Please let me know if you have any other idea in mind.
>>>
>>> I am not convinced that this io_uring_cmd is needed. This is one
>>> in-kernel subsystem calling into another, and there are APIs for that.
>>> All of this set is ioctl based and as Willem noted a little refactoring
>>> separates the get_user/put_user out so that in-kernel can call can be
>>> made with existing ops.
>>
>> How do you want to wire it up then? We can't use fops->unlocked_ioctl()
>> obviously, and we already have ->uring_cmd() for this purpose.
> 
> Does this suggestion not work?

Not sure I follow, what suggestion?

>>> I was thinking just having sock_uring_cmd call sock->ops->ioctl, like
>>> sock_do_ioctl.
>  
>> I do think the right thing to do is have a common helper that returns
>> whatever value you want (or sets it), and split the ioctl parts into a
>> wrapper around that that simply copies in/out as needed. Then
>> ->uring_cmd() could call that, or you could some exported function that
>> does supports that.
>>
>> This works for the basic cases, though I do suspect we'll want to go
>> down the ->uring_cmd() at some point for more advanced cases or cases
>> that cannot sanely be done in an ioctl fashion.
> 
> Right now the two examples are ioctls that return an integer. Do you 
> already have other calls in mind? That would help estimate whether
> ->uring_cmd() indeed will be needed and we might as well do it now.

Right, it's a proof of concept. But we'd want to support anything that
setsockopt/getsockopt would do. This is necessary so that direct
descriptors (eg ones that describe a struct file that isn't in the
process file table or have a regular fd) can be used for anything that a
regular file can. Beyond that, perhaps various things necessary for
efficient zero copy rx.

I do think we can make the ->uring_cmd() hookup a bit more palatable in
terms of API. It really should be just a sub-opcode and then arguments
to support that. The grunt of the work is really refactoring the ioctl
and set/getsockopt bits so that they can be called in-kernel rather than
assuming copy in/out is needed. Once that is done, the actual uring_cmd
hookup should be simple and trivial.

-- 
Jens Axboe

