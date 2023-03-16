Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC2E6BD876
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 20:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCPTAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 15:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCPTAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 15:00:52 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE4834F5B;
        Thu, 16 Mar 2023 12:00:51 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id jl13so1904279qvb.10;
        Thu, 16 Mar 2023 12:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678993250;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8gdgFdzn2VZfw/BOlLO7/M7CDem1fHQVxoPtn1UlLE=;
        b=jBdn34TgfBJzkLpA7N96EBsZA3inde37taBEDqzQap+c/HgIara6ivAxhZmdI9s07W
         Z0rUyrKfVMfVi9gzZQpswhHl+uk8/VEc6lwHTpcRq1fVt2XB/r+AMXEg9MAx6xfWgxdW
         5p1YsPr8MsQYP1lyLACo08vn8VbZAOCOCGp5YU6QYwiTNDylua4ZmPdS/3qf17tOylF6
         sEyiiF5OTkHg5fkgNNZkeDAnjuNHJFwiQpDbNl5r7U9YKlMF4TkUJVsWSRIYg0dWRGJ1
         kdL+7ufedElax5aZhj27uHt4gVHmq8wlff0i+R9yOgASnqCYQ2C3OoltbEIXxIDOzthV
         oeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678993250;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N8gdgFdzn2VZfw/BOlLO7/M7CDem1fHQVxoPtn1UlLE=;
        b=MW+xWCAbNulm24vnrXZj34nKPsQuhyrLYOlWacX41n0c5pucVJr9CHD3gkJ4jxzEWK
         djNVcwWKTucihtM5j+3pxbChBT6H9YoTvoIGgdmEV+RDDBBG4OzELWg4prXVe2RMTUFy
         97/PWPoMT6AoyBzD9XqvgdLc+ocX6DMob9ZCP7ZSZ9OZn34tBJkqVvBH7lizmD6uAajd
         HjyS7PU3HvSyTRsZKcma7/PV4Hv4oM0vANdidj/itGGiTwQ1z2wF9HFy2EYwBmUxE/jV
         wZMivuL8clhKwN6priv5TVWjAIs39c7x1JON0tmWJ1sex7bhWL6WLtdomS2Qk0PILloi
         jjcg==
X-Gm-Message-State: AO0yUKXvEFdufuHJ/S2ZHAWvPFcJ35rutgzNyfB5/MTCgrPkbJ3m/S3X
        1PPqOUOM2fcxUuihn4MCqFmZXwypBTo=
X-Google-Smtp-Source: AK7set9HVg6/x3f+ic5yQ+uP2gWUBHqmvBXFAjkjzROHUiUGIBghCoAnWktz2gfaZsbhbTJuHb+/XQ==
X-Received: by 2002:a05:6214:d88:b0:5a3:cbc6:8145 with SMTP id e8-20020a0562140d8800b005a3cbc68145mr27795909qve.19.1678993249518;
        Thu, 16 Mar 2023 12:00:49 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id c18-20020a05620a269200b007343fceee5fsm136266qkp.8.2023.03.16.12.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 12:00:47 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:00:46 -0400
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <6413675eedcfa_33bc9d208e9@willemb.c.googlers.com.notmuch>
In-Reply-To: <811534.1678992280@warthog.procyon.org.uk>
References: <641361cd8d704_33b0cc20823@willemb.c.googlers.com.notmuch>
 <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-4-dhowells@redhat.com>
 <811534.1678992280@warthog.procyon.org.uk>
Subject: Re: [RFC PATCH 03/28] tcp: Support MSG_SPLICE_PAGES
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells wrote:
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> 
> > The commit message mentions MSG_SPLICE_PAGES as an internal flag.
> > 
> > It can be passed from userspace. The code anticipates that and checks
> > preconditions.
> 
> Should I add a separate field in the in-kernel msghdr struct for such internal
> flags?  That would also avoid putting an internal flag in the same space as
> the uapi flags.

That would work, if no cost to common paths that don't need it.

A not very pretty alternative would be to add an an extra arg to each
sendmsg handler that is used only when called from sendpage.

There are a few other internal MSG_.. flags, such as
MSG_SENDPAGE_NOPOLICY. Those are all limited to sendpage, and ignored
in sendmsg, I think. Which would explain why it was clearly safe to
add them.

