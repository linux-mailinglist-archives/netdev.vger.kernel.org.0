Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD1762D816
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbiKQKfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239583AbiKQKfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:35:03 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9941BE0;
        Thu, 17 Nov 2022 02:35:02 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id k8so3116099wrh.1;
        Thu, 17 Nov 2022 02:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1tIES8M5p31Pz85hKfNgDWDSrA68rOOdtctNl9gU1lc=;
        b=PRqNXSwzvw5iJSs7ru7DeKpofb6jxzL+Z53vX5WEn/O5fMjy7Amvc/HX/j9fk7ozNg
         iFh1NSmBKISw7UnbsD4L+VYOG1RZ/OG//Xcpko1p5NtCp7nbvoHSdfVJgtVOR8HMxSZn
         WXsh0P+YRnB99yraWPA3dmb68YO61JQDXx60gqXfNmqLUZAKn3iYVucSYU09QMqQqDLA
         8ZjRLT7lhzwpWtlc+qnTh3lFsBUjNIkSpqrSXdMAZxfDojGVTrhqSz706sUQjhDMQL7N
         I4wvb4fW5u2PqhJz2wOqxBfNF5NxHgY42cg5NynWcTiJKN1lCTySQZJi8lM2EzzYpbgF
         s7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tIES8M5p31Pz85hKfNgDWDSrA68rOOdtctNl9gU1lc=;
        b=IkOzLkzxY4l5aVi7NehC0XUcIKm4ZoNiNj96MuQBl8BWFl6Rddi99PhtF0rhM5UNhb
         1vvuEeGxUZpzR8BZOMM5/g6WOyv/12JMHVdczYdttjlQ2Nxu+jFp5jykYc3t+hWoUqGI
         TgEqYAL3ZCpwPaJe6IT+Pz9jf390MAeQ3B9fmzGm8R9f3CG2Qu/bSx0MxNNfLfhbrsc6
         dFRD0kqLp6rD3O7Agh4Ol3bXGResvz32L2hoYyAVJTLzH9WaNCAlrdY8rYoiamPerJyC
         1J5VcqpSWvqWxZm4fhHxG1QdgZSaxljFJq4xLk8uzrs0iIhV0cJlXofTeWWe8J9R9Kmm
         IV3g==
X-Gm-Message-State: ANoB5pkzh2Sf+9Myl+BrcI8zipVpxjpbvEfhmVrKOJ3/fGis1VHyzz4U
        TND20bv2JZ7dkkjg8rebSg8=
X-Google-Smtp-Source: AA0mqf76uIFuiYDNh3PBXTnttr8pYQJIqwCARGBPlN4ZwMF+FcncsG5R8fLAeu8e2zSszihRZoP1ng==
X-Received: by 2002:adf:f8c5:0:b0:241:b408:f170 with SMTP id f5-20020adff8c5000000b00241b408f170mr1098387wrq.42.1668681301350;
        Thu, 17 Nov 2022 02:35:01 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k1-20020a5d6281000000b0022ae0965a8asm604269wru.24.2022.11.17.02.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 02:34:59 -0800 (PST)
Date:   Thu, 17 Nov 2022 13:34:57 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: uninitialized variable in
 rxrpc_send_ack_packet()
Message-ID: <Y3YOUQM/ldDe/sgC@kadam>
References: <Y3XmQsOFwTHUBSLU@kili>
 <3475095.1668678264@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3475095.1668678264@warthog.procyon.org.uk>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 09:44:24AM +0000, David Howells wrote:
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > The "pkt" was supposed to have been deleted in a previous patch.  It
> > leads to an uninitialized variable bug.
> 
> Weird.  I don't get a compiler warning and the kernel doesn't crash, despite
> transmitting millions of acks.
> 
> If I disassemble the built code, I see:
> 
>    0xffffffff81b09e89 <+723>:   xor    %edi,%edi
>    0xffffffff81b09e8b <+725>:   call   0xffffffff811c0bc1 <kfree>
> 
> I'm not sure why it's sticking 0 in EDI, though.

We disabled GCC's check for uninitialized variables.  It could be that
you have the .config to automatically zero out stack variables.

CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y

regards,
dan carpenter

