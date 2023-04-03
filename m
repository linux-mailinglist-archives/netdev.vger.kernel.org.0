Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94A46D4615
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjDCNqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbjDCNqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:46:33 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD4330CF;
        Mon,  3 Apr 2023 06:46:32 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id ga7so28335643qtb.2;
        Mon, 03 Apr 2023 06:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680529591; x=1683121591;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmBfHIegQyI1FRFG7cpgsbaaSUI++p7T5PaE/RkUk90=;
        b=aZAY6OIApLntdoao50EqoWIIO78Bd6VomixfHjKViIWPqX9L5HsySoUqj9WkCqTOo6
         +YAEn+5eyrJX85NpSFKwhQTkgFkgZ6HUb0PoGHuhOSYoyfnnMjHH/8dJ5sKtzRC3z7Ll
         EwVVngSnBy1NB4hrEWHD54MDD6sSG0OYyRORtk+GZqbWqP3Mke7SLfSt6Tf6QYste1th
         GuSr5YLq24iuIUL5lOQShiylIg4whh+j0V4slhAPA423iFofpjctOb+VSvoTv49PmNYl
         6IktRcEXJU1oxwL6IcbgJi2RW0Bycc0zvP7r0WX2Lxp/0qhEzH0gLD2ex455Zu6kMl2b
         rEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529591; x=1683121591;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lmBfHIegQyI1FRFG7cpgsbaaSUI++p7T5PaE/RkUk90=;
        b=SVD8l4azqxKOXxeUAsjbFEuQvC76Fz+6cvhcLurzRu9g6KdLOZWyayGc6140TaRvBL
         3EmRC7EpgqVQh/rv50HGRw3eLshi774BpYFABeb+wQnYMPC6qWJuGe5ixbAOD6a38fKI
         XmAR40AuGdQIbAFSOSta5HrizbF8emBgz3d97ttCg3QmckqBPJOk2Owj20yz8w3ISJz5
         D2CWiqQfYEZd2WUmWNcuWxTO0xf2CulD0hGJ0c0BH17P9QtvnJ8e2s505YzZkJUUemp/
         atswsBW/AjpdmjTYPdt1saVOwgR0kvNoyWCI0wVNip+1qImmqNzugIKXyubEBzFyZ6Kv
         C7LA==
X-Gm-Message-State: AAQBX9eby+kKzIeJwr4yK1BfA8RABVebDlKLfWszZLyOgrfEAZqutc3/
        fBxpS1z1MU+5c9ROkIINuQ+0eHZaP4A=
X-Google-Smtp-Source: AKy350bRUIG8K9LjvA1b9EuTwsk3AQLD39qLhO6S6LUfgGDpNedlRhLzUDv7B2/uoLhMI5WTUiFchA==
X-Received: by 2002:a05:622a:1104:b0:3e4:e9e4:5d0e with SMTP id e4-20020a05622a110400b003e4e9e45d0emr45040970qty.50.1680529591144;
        Mon, 03 Apr 2023 06:46:31 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id c70-20020a379a49000000b00746ae84ea6csm2814958qke.3.2023.04.03.06.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:46:30 -0700 (PDT)
Date:   Mon, 03 Apr 2023 09:46:30 -0400
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
Message-ID: <642ad8b66acfe_302ae1208e7@willemb.c.googlers.com.notmuch>
In-Reply-To: <1818504.1680515446@warthog.procyon.org.uk>
References: <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch>
 <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-16-dhowells@redhat.com>
 <1818504.1680515446@warthog.procyon.org.uk>
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
> > > +	} else if ((flags & MSG_SPLICE_PAGES) && length) {
> > > +		if (inet->hdrincl)
> > > +			return -EPERM;
> > > +		if (rt->dst.dev->features & NETIF_F_SG)
> > > +			/* We need an empty buffer to attach stuff to */
> > > +			initial_length = transhdrlen;
> > 
> > I still don't entirely understand what initial_length means.
> > 
> > More importantly, transhdrlen can be zero. If not called for UDP
> > but for RAW. Or if this is a subsequent call to a packet that is
> > being held with MSG_MORE.
> > 
> > This works fine for existing use-cases, which go to alloc_new_skb.
> > Not sure how this case would be different. But the comment alludes
> > that it does.
> 
> The problem is that in the non-MSG_ZEROCOPY case, __ip_append_data() assumes
> that it's going to copy the data it is given and will allocate sufficient
> space in the skb in advance to hold it - but I don't want to do that because I
> want to splice in the pages holding the data instead.  However, I do need to
> allocate space to hold the transport header.
> 
> Maybe I should change 'initial_length' to 'initial_alloc'?  It represents the
> amount I think we should allocate.  Or maybe I should have a separate
> allocation clause for MSG_SPLICE_PAGES?

The code already has to avoid allocation in the MSG_ZEROCOPY case. I
added alloc_len and paged_len for that purpose.

Only the transhdrlen will be copied with getfrag due to

    copy = datalen - transhdrlen - fraggap - pagedlen

On next iteration in the loop, when remaining data fits in the skb,
there are three cases. The first is skipped due to !NETIF_F_SG. The
other two are either copy to page frags or zerocopy page frags.

I think your code should be able to fit in. Maybe easier if it could
reuse the existing alloc_new_skb code to copy the transport header, as
MSG_ZEROCOPY does, rather than adding a new __ip_splice_alloc branch
that short-circuits that. Then __ip_splice_pages also does not need
code to copy the initial header. But this is trickier. It's fine to
leave as is.

Since your code currently does call continue before executing the rest
of that branch, no need to modify any code there? Notably replacing
length with initial_length, which itself is initialized to length in
all cases expect for MSG_SPLICE_PAGES.

Just hardcode transhdrlen as the copy argument to __ip_splice_pages.
> I also wonder if __ip_append_data() really needs two places that call
> getfrag().
> 
> David
> 


