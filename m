Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8747D6C33FA
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjCUOWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjCUOWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:22:36 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B927E4D61B;
        Tue, 21 Mar 2023 07:22:33 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id c10so6795595qtj.10;
        Tue, 21 Mar 2023 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679408552;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wz3BNwM3t347dW9MrDDlDaF/UKc2l3vuI9j2nicbfoc=;
        b=fSCtNQpTzD0m2A2W2OKX3pfAubzbWRnb2RAUBIq8PYZPjT8FVSHXe8J8ypoxE6eVN4
         goqJwEyk21Zz10AmCEwuYOZOzHuWt4N0K2WZuzSv0+paEAV6IpxMkfoK7AGDYVHmhbJN
         FCtS12QypMqOM4EggWhcZ/feYU9VGQe3xgAUkgU+KWibhU21cC619pruLNBYJRO+vDm4
         kYLDWKwB5K3SmlGWfG+ejKQLHzW7qD1S7N0lQvfjIHSI5jAybIa3PlHlaoLflY/f13Ep
         vYx4ltn12qB5DvYf7NsnBHqypri5XIV3VI37Mk6rV9uZf1uuLNi22giLPgPVeQe+7zr0
         x4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679408552;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wz3BNwM3t347dW9MrDDlDaF/UKc2l3vuI9j2nicbfoc=;
        b=YmHD0gsJFdKXB7StrRcIXQAdO2VgyxCgfTxg0VCobXM+7ooqYCeE/3529RTwC/Po9b
         Z9ldVuIiOTGDNwtUyAOGQ9nc5y0xtsMq6RM4rlFHoTmGufLslBwK4tiu/dUfwpuY6fhd
         j57AiBEeyX9Gw89L+RUy7cvaiLaW3mSsarzJatHet7Gjp95c1KEpDlPDC/41zgqt53fc
         mA5MUqyqSQX81wG+U4UCjeRku1ehjpDsndaLv1rd8VgCmo44i2h1dm63eOe3dVxr8OJ+
         ebyvtPB66uUI2lCpsEHj6c4M5e+TVA012q04Zr48XUQeTaL+MYo/SsdSdqI1QAGdNw5R
         WMzg==
X-Gm-Message-State: AO0yUKVvBM9CR3AwA5ifrWElUJxN6Lj3rlyt42Px/MkX0AbcJ+f6iHHU
        TuBnYVKJng4/cJNLiULnmIRzfNLjFzk=
X-Google-Smtp-Source: AK7set8Cy/DQI/DUDlA+l6xElzRo7iUEHmfLTC4HEXDOFP/qOoOXhpEF+Xwo/iqIonTKdBodRD0/Jg==
X-Received: by 2002:a05:622a:18e:b0:3b8:6930:ee6 with SMTP id s14-20020a05622a018e00b003b869300ee6mr60125qtw.21.1679408552766;
        Tue, 21 Mar 2023 07:22:32 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id dp10-20020a05620a2b4a00b00745af48838bsm9460372qkb.5.2023.03.21.07.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 07:22:30 -0700 (PDT)
Date:   Tue, 21 Mar 2023 10:22:29 -0400
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
Message-ID: <6419bda5a2b4d_59e87208ca@willemb.c.googlers.com.notmuch>
In-Reply-To: <2040079.1679359126@warthog.procyon.org.uk>
References: <6413675eedcfa_33bc9d208e9@willemb.c.googlers.com.notmuch>
 <641361cd8d704_33b0cc20823@willemb.c.googlers.com.notmuch>
 <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-4-dhowells@redhat.com>
 <811534.1678992280@warthog.procyon.org.uk>
 <2040079.1679359126@warthog.procyon.org.uk>
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
> > David Howells wrote:
> > > Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > > 
> > > > The commit message mentions MSG_SPLICE_PAGES as an internal flag.
> > > > 
> > > > It can be passed from userspace. The code anticipates that and checks
> > > > preconditions.
> > > 
> > > Should I add a separate field in the in-kernel msghdr struct for such internal
> > > flags?  That would also avoid putting an internal flag in the same space as
> > > the uapi flags.
> > 
> > That would work, if no cost to common paths that don't need it.
> 
> Actually, it might be tricky.  __ip_append_data() doesn't take a msghdr struct
> pointer per se.  The "void *from" argument *might* point to one - but it
> depends on seeing a MSG_SPLICE_PAGES or MSG_ZEROCOPY flag, otherwise we don't
> know.
> 
> Possibly this changes if sendpage goes away.

Is it sufficient to mask out this bit in tcp_sendmsg_locked and
udp_sendmsg if passed from userspace (and should be ignored), and pass
it through flags to callees like ip_append_data?
> 
> > A not very pretty alternative would be to add an an extra arg to each
> > sendmsg handler that is used only when called from sendpage.
> > 
> > There are a few other internal MSG_.. flags, such as
> > MSG_SENDPAGE_NOPOLICY. Those are all limited to sendpage, and ignored
> > in sendmsg, I think. Which would explain why it was clearly safe to
> > add them.
> 
> Should those be moved across to the internal flags with MSG_SPLICE_PAGES?

I would not include that in this patch series.

