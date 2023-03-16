Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197C06BD3F8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjCPPiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjCPPhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:37:43 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B051CE192D
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:35:36 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id k17so972647iob.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzBQqD5oNF8UUtseeo3BUimRkPmp5gb2nKVkX6vVqCg=;
        b=GneqZmGdPLZAUXcKbyte5Cfqo+KwXTdsJl7LvrC8eZ7DKkns/Xf6bhZJtnD02tfjx6
         bMuo6zjcY88sIL21sghgMcfZuVbEXs70NYfTzoob7lMPRXk1wUlZ3MOnLayEey4gFHMe
         3KXwzpWxmjl0d/4hoRC9IpmhhjE++WIANUihjF+/pMjN8nho6bCUXo1G2TISftmYaqQU
         fD6D4/bEMEqoitmBVZrIvvxjUETDkHfTrDQ+3SQWI0AqlK4ifkih5494saXa5fXIdXUr
         NvaNERVCgYcJpnUsJgKGTrUWtnhLZjnzu3juhmbydyFcn5ywxWE06iM/nXGFb0sR7rK+
         d/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzBQqD5oNF8UUtseeo3BUimRkPmp5gb2nKVkX6vVqCg=;
        b=6b0Dkx0Sx4qOeaEymXLfbjr5QNcfKhoDEwTuE5pNb5jfG689yfUN3igbDeiQMGtPGB
         CZtbhOQAoR1ziAvvBiY8yHoXUHCIAcVxPcK9asGyvMza4lna6aX0/ffRDlUqzV4qpnKu
         YRavJOfifdEvBQxSvM1/XkbBi2hOTxFoytuz2BSoHIju3Z2A30UOnei3iu017BCIO9HN
         3GkArhvibICBpbE/n6MVm91mSkIagOzaNayEqW24tOctKKCSsdftbIRuEmMH7JgYqQu8
         aDOzJxq9bxeOp+/fKKLZkXAzd00S2zl4XXZ+RaU0nN2dHyokx/H5jp5Ki4GReIU4kfF1
         BW3Q==
X-Gm-Message-State: AO0yUKX90SEtVDWKOZa8YDam9Cg/LbTqxbLusu+VtSA0PgEOyxVE9wN0
        HTeYL/Sl43bDd9/n6Lffkg4x3IhvhnoKvQ5nzbB4yg==
X-Google-Smtp-Source: AK7set/O/dWMabeSU2g/gwjZxrlhQo0Z1lUMrT7SrdR+nfEOA3lnViu93quaURgamvGHQUi1CQ2fTo3b6Pf6nT4TlLg=
X-Received: by 2002:a6b:b793:0:b0:752:f038:6322 with SMTP id
 h141-20020a6bb793000000b00752f0386322mr3211558iof.0.1678980861792; Thu, 16
 Mar 2023 08:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com> <20230316011014.992179-2-edumazet@google.com>
 <641333d07c6b0_3333c72088e@willemb.c.googlers.com.notmuch>
In-Reply-To: <641333d07c6b0_3333c72088e@willemb.c.googlers.com.notmuch>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Mar 2023 08:34:10 -0700
Message-ID: <CANn89iLWoJEp+GsBvHqDDB8sogpq78Rkare8c+msNqjwG1EWrA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/9] net/packet: annotate accesses to po->xmit
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 8:20=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:

> We could avoid the indirect function call with a branch on
> packet_use_direct_xmit() and just store a bit?
>


Sure, I can add this in a separate patch, unless you want to implement
this idea.
