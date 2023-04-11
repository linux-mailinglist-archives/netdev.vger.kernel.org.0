Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC1F6DDF8A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDKPYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjDKPYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:24:45 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6DF123;
        Tue, 11 Apr 2023 08:24:43 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id ge18so5041308qtb.0;
        Tue, 11 Apr 2023 08:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681226682; x=1683818682;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXyHbn8vqx3duAmA7aO60G+cH/xRA7Lcwdw8hJ0DVXI=;
        b=EdDmHx3FYf3+emNktgNiXCUF/kIlsXYm505gplgfFKjcSHXn3Ca1bBhSEjlBDD/AS0
         3WlbDMipKwKaYS0ocLQYvrUEDdX8QjnVzL791UHr9cBXCx382RTCkegs40YeWCZwGWIU
         Yh3GvYj286NqIJIP+WDUTvF+QjHLKDnfFIr9TPLc9pr8/68zGr5c3NZXem5t1wileEjK
         Z9V4hIQLXi3i5m54KZqn1JV5FGRLCmsHrFT0mYbhke93b0gELdSpaSIF4Jjci6bVZnLN
         lHYGGUfvypaiKI2FqY1gzRkYqDFjwe6s+cGv0+cZ7KuMQI+R/fMx+xIlbjaG0ShjAo1l
         vGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681226682; x=1683818682;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LXyHbn8vqx3duAmA7aO60G+cH/xRA7Lcwdw8hJ0DVXI=;
        b=Wr7i2tU+i5ikPN0YQDHNPqdpZABmQ2Fq/ww7yKelNoFs+pvTffeAEN6M/xMvHst4Oj
         UwAxQWFpRwlTV02jU91snyMbiSbNdvB7lkquA6d7ISbTojcsOYHlNGBbcxjgx/ydmmAR
         PIt9LgPhXbxTLHatVa2yt9jSe1kGt26qUDUkS6EB6j5fcFOJpunxFPpa5PXJHR42QFZX
         lbuKXFT1COaNg7i5AnXpKDGSR4sgNl2uRTNytN7rdS5Gay3mtCKQoWSCn2D/8sX1hO27
         ePBMe5qdmRSNLCeqwp1wGJulMZKndP1KLirZnulL/aIFFIoBTY0JJ37tCcBrCFhq3Sse
         pCnw==
X-Gm-Message-State: AAQBX9d2db71MVnqY+Ui6CnQFHAqtoaZ/E5JaoY3Z3epNbOINqIqkx/x
        id4PzG3yS10lCMgNRtcMIc0=
X-Google-Smtp-Source: AKy350Zg8zFvj5oW+0Brk2yYqZSTD9N+WMiY7yjXe01TEP13/O6FYy4nmpkcUXb9ZfQykty2jgU7XA==
X-Received: by 2002:ac8:5c43:0:b0:3e1:59e8:7451 with SMTP id j3-20020ac85c43000000b003e159e87451mr18105398qtj.14.1681226682197;
        Tue, 11 Apr 2023 08:24:42 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id fp32-20020a05622a50a000b003e69d6792f6sm1871810qtb.45.2023.04.11.08.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:24:41 -0700 (PDT)
Date:   Tue, 11 Apr 2023 11:24:41 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
Message-ID: <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
In-Reply-To: <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
 <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
 <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
 <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jens Axboe wrote:
> On 4/11/23 9:00?AM, Willem de Bruijn wrote:
> > Jens Axboe wrote:
> >> On 4/11/23 8:51?AM, Willem de Bruijn wrote:
> >>> Jens Axboe wrote:
> >>>> On 4/11/23 8:36?AM, David Ahern wrote:
> >>>>> On 4/11/23 6:00 AM, Breno Leitao wrote:
> >>>>>> I am not sure if avoiding io_uring details in network code is possible.
> >>>>>>
> >>>>>> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
> >>>>>> in the TCP case) could be somewhere else, such as in the io_uring/
> >>>>>> directory, but, I think it might be cleaner if these implementations are
> >>>>>> closer to function assignment (in the network subsystem).
> >>>>>>
> >>>>>> And this function (tcp_uring_cmd() for instance) is the one that I am
> >>>>>> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
> >>>>>> -> SIOCINQ.
> >>>>>>
> >>>>>> Please let me know if you have any other idea in mind.
> >>>>>
> >>>>> I am not convinced that this io_uring_cmd is needed. This is one
> >>>>> in-kernel subsystem calling into another, and there are APIs for that.
> >>>>> All of this set is ioctl based and as Willem noted a little refactoring
> >>>>> separates the get_user/put_user out so that in-kernel can call can be
> >>>>> made with existing ops.
> >>>>
> >>>> How do you want to wire it up then? We can't use fops->unlocked_ioctl()
> >>>> obviously, and we already have ->uring_cmd() for this purpose.
> >>>
> >>> Does this suggestion not work?
> >>
> >> Not sure I follow, what suggestion?
> >>
> > 
> > This quote from earlier in the thread:
> > 
> > I was thinking just having sock_uring_cmd call sock->ops->ioctl, like
> > sock_do_ioctl.
> 
> But that doesn't work, because sock->ops->ioctl() assumes the arg is
> memory in userspace. Or do you mean change all of the sock->ops->ioctl()
> to pass in on-stack memory (or similar) and have it work with a kernel
> address?

That was what I suggested indeed.

It's about as much code change as this patch series. But it avoids
the code duplication.
