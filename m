Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF03B6D389F
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjDBO4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjDBO4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:56:53 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65007295;
        Sun,  2 Apr 2023 07:56:52 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id k12so690049qvo.13;
        Sun, 02 Apr 2023 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680447412; x=1683039412;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=atds8gSClqlNHaxVTY/u8jWQRo/FCkzxGm1dMixJaaM=;
        b=B/By7XhjU69AY0lqHx25qllp0doybNw50wUiGKlqOp010V9jcCzstlJZiVKM8a5lyU
         5gv75rX9n0NSqTu3b2k/FoQLZi1j8BjfiD69pzhdPSOwAau+JYwlPWAuKiePY+EoO/dV
         hheJK+8ZD9CcKKPa/0LnI3fVDfy9nq8tkX/ZzYZrrSdR+ui1PkzTWvtEabpt2wg/ba9X
         poR9Hsf2rYQM0yMWnpaYXTgLCjLb/6tkPrmBkNU5YJPgvdgx50whJR1udUbGkE4RFOvc
         gMSC61tu6eezoJY0zWVh4pn/3OIU/vL2cArywyxMk/P1wml+3m8YF2fjKdQrXzuSxmTr
         5+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680447412; x=1683039412;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=atds8gSClqlNHaxVTY/u8jWQRo/FCkzxGm1dMixJaaM=;
        b=lUHVOkSzjoBobtpu1Hcbh/23uFUtgAuvi9+QTCT+um9c3oBHrRKPBENmtuQmk2IZ3l
         y8OZr+AOFIw7Y/jTrjIS4kJgAzKrfYgaRv488YOHbKr4IYX/ZtYZaWxvZNph0T1Im2uc
         oP7EWz4Pgz75aO/Rkm1LWmODqgVQ5dzqSQpiSni+30Ae4yCtsGVdOAnXwrwkve+893FJ
         ha/MdWJ31joDtjYKNCMrT1iwGuHoeFP6mxEY9VaNaZ4Rz3fpoigfG7TTgHnvfmKCrrJs
         1rT7pymxuSjkDE13NitPoNZ23DQkpUgxO5C80M23sgc9YPgiFsVm9+3B6TG+M04/NJFi
         yVzw==
X-Gm-Message-State: AAQBX9cjo63LB8FhCtXRTM5pS+EG47XdtkTop4Pv3nWX0Ubt2cnuHWzt
        jIXAVfClwvmu3wURHYMobkY=
X-Google-Smtp-Source: AKy350a4rkwDBTQMVluJtKUgqOxCwrYsf5coqfb0RWcqcMAYP5IbUbp///HoN0WpAm/c1TL6UVdubA==
X-Received: by 2002:ad4:5b87:0:b0:5a5:f1eb:fc67 with SMTP id 7-20020ad45b87000000b005a5f1ebfc67mr49357634qvp.52.1680447411816;
        Sun, 02 Apr 2023 07:56:51 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id x23-20020a05620a0b5700b00746b79101b6sm2080331qkg.67.2023.04.02.07.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 07:56:51 -0700 (PDT)
Date:   Sun, 02 Apr 2023 10:56:51 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <642997b31bf8f_2d2a202088e@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230331160914.1608208-4-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-4-dhowells@redhat.com>
Subject: RE: [PATCH v3 03/55] net: Declare MSG_SPLICE_PAGES internal sendmsg()
 flag
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

David Howells wrote:
> Declare MSG_SPLICE_PAGES, an internal sendmsg() flag, that hints to a
> network protocol that it should splice pages from the source iterator
> rather than copying the data if it can.  This flag is added to a list that
> is cleared by sendmsg and recvmsg syscalls on entry.

nit: comment not longer matches implementation: recvmsg
 
> This is intended as a replacement for the ->sendpage() op, allowing a way
> to splice in several multipage folios in one go.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org

Aside from that

Reviewed-by: Willem de Bruijn <willemb@google.com>
