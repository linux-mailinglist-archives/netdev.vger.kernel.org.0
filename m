Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFD6D0D0F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjC3Rq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjC3Rq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:46:56 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BF1EC4A;
        Thu, 30 Mar 2023 10:46:52 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id t19so19250766qta.12;
        Thu, 30 Mar 2023 10:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680198411; x=1682790411;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMEUe6qirxhUGYqDUV527Cg0IXRczKbZPem5CQH2SRM=;
        b=LOdhm6zXTRmHE3Ehrf6yEqqMTuUaAEtD63od9/aRUc+Ot0L+YvYdImFrJnV060rDJC
         YvCXSCg7IonLi6kybFDwcT7fovxXp5f6RsXg4WpMr0PygIU0nsIDdnIoK8Epfk7E9Bs1
         oJCIl+gZV7IycXxYj26utcOtRq9P5UEiER6KEt1PsZCHH1edvD+t6cdDhJIOpIFnF5hd
         3MJWSkyq/q0qJ4ds+bUmuTQwBGJv0/uCsZsybmBbdre6WuSAskt3h7KI1866NcC85RZ3
         yaEdCyIEWQn239IlxRZdmZt2IniPQbTMipYG43GTwHedzNpCOXxMectAvQhNGI7NlFIl
         eLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680198411; x=1682790411;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pMEUe6qirxhUGYqDUV527Cg0IXRczKbZPem5CQH2SRM=;
        b=Ji8L/alqf1EyD5tA5FRdQ96h5yUC0YUB752Xgb5jhqE4FxYM1XA88Y6OkUccrMifCq
         S+UyLh7FcFprKLrHyrMTvX/OEXuS4AfV1LCWQoR5oqYEvAhqX+w+LllASna9rzJxgIEw
         ENOrIFlKGMi/o4Ue5WpXUIQlFMILDTXdA7fjOApfs6WGQrXm57pen2P1Eyc2+VhknkLt
         sUwrzSv+PQ+jW3sxSFNf+mwzo7ejc04z//OJ0Td47QzUjiGpXfNUuBI9w7fNZ1j8SHto
         rFKslIEKAbh9hS1xojLA/WN+Fn+UzwyUrDgDV//GWxPB2XNimU0xAja2xaDvXWgs4kKI
         r33Q==
X-Gm-Message-State: AAQBX9foX/7eQJuwRygrpFoJMO1XECohaBNTAODoxRkg+oOlAiZdUd8t
        6n+117reqEr7buV8UwzifY8=
X-Google-Smtp-Source: AKy350YlNHw1f7seFH1iAbg2SQmDIpZYoD+JGXjW64hJRcJ8Ekejwr7Y7YBrMm3S/ICA9UDucPqB5A==
X-Received: by 2002:a05:622a:1345:b0:3b9:e4cf:ce2d with SMTP id w5-20020a05622a134500b003b9e4cfce2dmr11700185qtk.16.1680198411666;
        Thu, 30 Mar 2023 10:46:51 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id r4-20020ac87944000000b003e38c9a2a22sm7377qtt.92.2023.03.30.10.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 10:46:41 -0700 (PDT)
Date:   Thu, 30 Mar 2023 13:46:39 -0400
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
Message-ID: <6425caff220cd_21f5692082f@willemb.c.googlers.com.notmuch>
In-Reply-To: <838854.1680187186@warthog.procyon.org.uk>
References: <64259aca22046_21883920890@willemb.c.googlers.com.notmuch>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-17-dhowells@redhat.com>
 <838854.1680187186@warthog.procyon.org.uk>
Subject: Re: [RFC PATCH v2 16/48] ip, udp: Support MSG_SPLICE_PAGES
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
> > > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > 
> > A non-RFC version would require the same for ipv6, of course.
> 
> I missed the fact that ipv6 had it's own version of __ip_append_data() despite
> sharing tcp_sendmsg().  Could __ip_append_data() and __ip6_append_data() be
> shared?  I guess that the v6_cork, the flowi6 and the ipcm6_cookie might
> prevent that.

We haven't been able to unify them before. As this series is
complex enough as is, I would not attempt to include it.

If it grows the code, maybe it'll be an incentive to take
another look afterwards.
