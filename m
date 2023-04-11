Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BC16DDE7F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjDKOvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjDKOvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:51:14 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7C0DE;
        Tue, 11 Apr 2023 07:51:13 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id fc12so4666894qtb.5;
        Tue, 11 Apr 2023 07:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681224672; x=1683816672;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHMCzwM6PDLhVkTQMZnMhtpmr/ubBhgQvLDgMQf1SOU=;
        b=eWJTQS0/ZEm7ZmaPAMa9oqA9wx0EPBV6l2uuwG6yIKqt1a06KRUxVLwWRWyMxAuE5Y
         dGcp39rEcvsbQdIl6zuG+tA8hzve7Ip/lS2I/SPm3my4GXlkmuOrFBcFyHhw5MiQaxI5
         ouNwprfsZ/zrSN54YLKJFfk0CfVceIVDumgsojvLaG+W30EONVwx6HzUF5/sC5/1vhG9
         /NIY/8e4qUCdGbPorHVAUl5qktHHwVotkdewfS3QvtKFir37S/emsfdxD7RmN0MzvvvS
         i02eMSq3lD27ogjCSxQiDOKcpOM0Mknt8DHlSnC17kAe2yTB80OX0gfiwymIMnLr7J1w
         +FMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681224672; x=1683816672;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XHMCzwM6PDLhVkTQMZnMhtpmr/ubBhgQvLDgMQf1SOU=;
        b=X6N1IPq9i6AsDZg5rh3v7D0420YGM1846OfPhZ3EEsa8Z3TYiduWsLxmifcx4TdFDJ
         vurvuA+IuoB1sMW1COfe8iBtZOFNUGD3+Kwem0j7FrW/UXemxFY8Kl/Fo1e+I5WpiA05
         D+QTOj8S4yHQbE6ZYX6JA8D1jzJFgOLbdu46QLOo3B+EnUwhX1sqmDfdDFvkwdpt6odh
         0GT5g/SzG4LrIgdED/zM+wZHRG8TxuqGWHdTFvSU0Wa9Bech4pAGa4hPqGv65O1n3I0H
         CWASbcMpiYf2KuhzyBpFzoJIsr480tpE5X5e/6btkUycYH/mqHE/EdbDKOZlp3deoE/W
         YeUw==
X-Gm-Message-State: AAQBX9eGx4LGOTV+b0Rbqi4fVn31NE1/VfWMHGntQQM1qTCKlg0dfntN
        ksE1QcKpdFh+bMgEEtxVV18=
X-Google-Smtp-Source: AKy350Y70yOUSwGBZYXj/TXH4vYBKCrUiGGiU0kdtk3VRctAr80kkFd917fwKzl/B7V6SYpgOgS7lw==
X-Received: by 2002:ac8:5fd1:0:b0:3e6:4fab:478f with SMTP id k17-20020ac85fd1000000b003e64fab478fmr22841516qta.43.1681224672436;
        Tue, 11 Apr 2023 07:51:12 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id h2-20020ac87442000000b003e3914c6839sm3646662qtr.43.2023.04.11.07.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 07:51:11 -0700 (PDT)
Date:   Tue, 11 Apr 2023 10:51:11 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
Message-ID: <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
In-Reply-To: <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
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
> On 4/11/23 8:36?AM, David Ahern wrote:
> > On 4/11/23 6:00 AM, Breno Leitao wrote:
> >> I am not sure if avoiding io_uring details in network code is possible.
> >>
> >> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
> >> in the TCP case) could be somewhere else, such as in the io_uring/
> >> directory, but, I think it might be cleaner if these implementations are
> >> closer to function assignment (in the network subsystem).
> >>
> >> And this function (tcp_uring_cmd() for instance) is the one that I am
> >> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
> >> -> SIOCINQ.
> >>
> >> Please let me know if you have any other idea in mind.
> > 
> > I am not convinced that this io_uring_cmd is needed. This is one
> > in-kernel subsystem calling into another, and there are APIs for that.
> > All of this set is ioctl based and as Willem noted a little refactoring
> > separates the get_user/put_user out so that in-kernel can call can be
> > made with existing ops.
> 
> How do you want to wire it up then? We can't use fops->unlocked_ioctl()
> obviously, and we already have ->uring_cmd() for this purpose.

Does this suggestion not work?

> > I was thinking just having sock_uring_cmd call sock->ops->ioctl, like
> > sock_do_ioctl.
 
> I do think the right thing to do is have a common helper that returns
> whatever value you want (or sets it), and split the ioctl parts into a
> wrapper around that that simply copies in/out as needed. Then
> ->uring_cmd() could call that, or you could some exported function that
> does supports that.
> 
> This works for the basic cases, though I do suspect we'll want to go
> down the ->uring_cmd() at some point for more advanced cases or cases
> that cannot sanely be done in an ioctl fashion.

Right now the two examples are ioctls that return an integer. Do you 
already have other calls in mind? That would help estimate whether
->uring_cmd() indeed will be needed and we might as well do it now.
