Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FDB6D6ABB
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbjDDRgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbjDDRgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:36:36 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC6C5FD9;
        Tue,  4 Apr 2023 10:36:14 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id ny16so923460qvb.4;
        Tue, 04 Apr 2023 10:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680629773; x=1683221773;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Z1DSaq3VFchGKzMkuppKkMuZ02nBNd6ugtDdxGTU1k=;
        b=f5gX2wkqrAoiMblcAQuuJb8lAFGg23a2sQHkp6HtVaJg8FDt2ejL5nTg1wHkUJvrui
         jaaEEnLdaxr69bom2j9BD9wRgQgSArQP7KUL22iOL2NM0bGEsqBXBZoWgyeNW0KpnlVq
         SMjoGHIMxlFjMmWnwdLP0cisFpmszR0uefaLEboVei3ol7U8Jp3PmQRh091YPdIvxgol
         4Kled2XQqKbOunVH9s6yqb8iQbezNK7IJUKeSSWqqmzsoP8AF9wHC1hhM0IijQXpG3oy
         ATKK/WTaFZGvkz26pkXdfYEjGwkkH2dWTsgLjOINF2TZHj3Z3qLrFIqs9JEP+DqBHFS3
         aTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680629773; x=1683221773;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4Z1DSaq3VFchGKzMkuppKkMuZ02nBNd6ugtDdxGTU1k=;
        b=q6HGaXmPQEYOnJB4/pQPqMimABzl76TrYq3+uAdFR6nTRK1phKJoQtDmV2LXxxnAXm
         I5gyfJJ/rk4VRHpXrhlDADzgbJSQUequqiRGgO3iGbwkiKb0RYcmlWWcLqM8NnpBOUlT
         2F/XClj9MYe8mYc6LsIMyaZYPIeN6tcnY3rNliEbvILTh0/VzULwrCd0aDyki+36y3Vn
         Nj7rq5h/I9bcVWrNqChatfO9IlqG8asWQTSV4Lfzm0LJm/eXar6R6f2poOyQ5zdbgcr7
         ly4wIdVc9dJEjVyuesfpsJIg7/1ARu3u/8CcD+xUXREqVULs+hPQF4C0D46s4MrifWDE
         csoQ==
X-Gm-Message-State: AAQBX9fyVrqRmCFI2226+X6El2l9En2HEx1mSYcqr9+vrrbbC0JXfs28
        TbxFNT9K0BqJEXbLmX3/xDY=
X-Google-Smtp-Source: AKy350Z23k8fMVTzMdrsIJFMN4WdkO04DiDvcgHJCEHpVKeNB/JKhOJwLjldeAZHPeYbENi695HiOA==
X-Received: by 2002:a05:6214:e6b:b0:5ba:852:272c with SMTP id jz11-20020a0562140e6b00b005ba0852272cmr4398157qvb.8.1680629773236;
        Tue, 04 Apr 2023 10:36:13 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id kr22-20020a0562142b9600b005e45f6cb74bsm836386qvb.79.2023.04.04.10.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 10:36:12 -0700 (PDT)
Date:   Tue, 04 Apr 2023 13:36:12 -0400
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
Message-ID: <642c600c428d2_339347208d8@willemb.c.googlers.com.notmuch>
In-Reply-To: <2688906.1680628610@warthog.procyon.org.uk>
References: <642c5731a7cc5_337e2c208b0@willemb.c.googlers.com.notmuch>
 <642ad8b66acfe_302ae1208e7@willemb.c.googlers.com.notmuch>
 <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch>
 <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-16-dhowells@redhat.com>
 <1818504.1680515446@warthog.procyon.org.uk>
 <2258798.1680559496@warthog.procyon.org.uk>
 <2688906.1680628610@warthog.procyon.org.uk>
Subject: Re: [PATCH v3 15/55] ip, udp: Support MSG_SPLICE_PAGES
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
> > > Okay.  How about the attached?  This seems to work.  Just setting "paged" to
> > > true seems to do the right thing in __ip_append_data() when allocating /
> > > setting up the skbuff, and then __ip_splice_pages() is called to add the
> > > pages.
> > 
> > If this works, much preferred. Looks great to me.
> 
> :-)
> 
> > As said, then __ip_splice_pages() probably no longer needs the
> > preamble to copy initial header bytes.
> 
> Sorry, what?  It only attaches pages extracted from the iterator.

Ehm indeed. Never mind.
