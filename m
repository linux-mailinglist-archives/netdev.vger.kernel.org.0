Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87896D0D28
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjC3RwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjC3RwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:52:04 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A223CDC8;
        Thu, 30 Mar 2023 10:52:03 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id x8so14622239qvr.9;
        Thu, 30 Mar 2023 10:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680198723; x=1682790723;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4IR9SAM3kCBb7sI+E1m5cavLGwgTgCiGLAf0/i0xTGs=;
        b=o7CzjEeQkNqDVNYK9ZnwI2yCezVyErPe1bfsZYKe324dISFuAjnC9kXBtg1xMLfdbf
         5eIhKSt8RhpS0p4Ik5nSvdwuQQ2J5AZAqXsFhSzgtDm/CUBlq6rUQnGdtkPiXQ908d0g
         JrNT4/HXtOupKtl4CcG91+u6pcUNImv8gngeCfB76s9stPqOejEnl87S90EWoaHtQ08J
         +e9ZsfIt1JjLI+oFXe58W1NSYR1RkrWd8GsGchwWZHisJS1jUPWAgg+ftSMt7pUmXoVf
         I92ZsAVjDQYvANzw1rk3HXfZL+erRw9vAj2mTQF4A/31YdbXsyZuh4MaMQGXP+16MSvy
         OB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680198723; x=1682790723;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4IR9SAM3kCBb7sI+E1m5cavLGwgTgCiGLAf0/i0xTGs=;
        b=SqMT8JtQjLtZugviocfMDZ1EFV7L2raqHODJKipib8sK+fx3XirvKPjspr+K6yDX6c
         f1wJYcGu+/FRH00mHH6HRIH/qy4e0zhSupCPIIpiIhPML6qAXwuyqZYIJNACBCYBAwvm
         33KcYaQDjOkKqtT/YPM8NbhHryFpxVrwhN++LE9qIzp/OkuGnz0CoA8Az0J8DMiHdwNq
         Oe4sUPtNZ6qFtbuQSF+s/EfOWa7BDEQPIA4k2V3U71uldVcchIfLvRJdXsOaZ6RvZbIA
         c/xJMrYj2QOr3n4vf1NWO1xNGjk0sg/C9qBJgoks/wWpLXEaH66g1iQ/EYWvuBumL+oG
         rQng==
X-Gm-Message-State: AAQBX9fEswe1VX0p3o48zHEWN1hbsxg/EJ6jg2r5eAUf50IF9VU8P2Fl
        ei3p3vCBHnl/h2AnjbmtbbQ=
X-Google-Smtp-Source: AKy350Z8Mtc2vYf4x+x2ABACFrvEg6sLt6QSC1cYwtcxUxIYKqmd/KO0J/rRV8HKQmERsmUh/XLC0w==
X-Received: by 2002:a05:6214:b64:b0:5b8:1f61:a20 with SMTP id ey4-20020a0562140b6400b005b81f610a20mr45046940qvb.35.1680198722777;
        Thu, 30 Mar 2023 10:52:02 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id z6-20020a0cfec6000000b005dd8b9345a0sm5617916qvs.56.2023.03.30.10.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 10:51:57 -0700 (PDT)
Date:   Thu, 30 Mar 2023 13:51:56 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     David Howells <dhowells@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <6425cc3c9d750_21f56920832@willemb.c.googlers.com.notmuch>
In-Reply-To: <854582.1680188845@warthog.procyon.org.uk>
References: <64259c7b2b327_21883920818@willemb.c.googlers.com.notmuch>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-5-dhowells@redhat.com>
 <854582.1680188845@warthog.procyon.org.uk>
Subject: Re: [RFC PATCH v2 04/48] net: Declare MSG_SPLICE_PAGES internal
 sendmsg() flag
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
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> 
> > No need to modify __sys_sendmmsg explicitly, as it ends up calling
> > __sys_sendmsg?
> > 
> > Also, sendpage does this flags masking in the internal sock_FUNC
> > helpers rather than __sys_FUNC. Might be preferable.
> 
> I was wondering whether other flags, such as MSG_BATCH should be added to the
> list.  Is it bad if userspace sets that in sendmsg()?  AF_KCM, at least, looks
> at it.

That flag was added exactly for AF_KCM. A process that explicitly
sets it might experience bad behavior (increased latency), but
there are no legacy AF_KCM applications that precede the flag.
