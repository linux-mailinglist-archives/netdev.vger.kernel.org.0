Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E913C1A9E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 22:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhGHUl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 16:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhGHUl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 16:41:58 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBCCC061574;
        Thu,  8 Jul 2021 13:39:15 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q2so9788787iot.11;
        Thu, 08 Jul 2021 13:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=c6gagiw90tH2rjIzHfPvJXOduAFDPhRqwu04EI2P9G4=;
        b=GU5e8d4KVB4Ibd0bC/K/BXQw6FG9JOmXzqRvZhXwSqW3uQYfGrEHM+R1r8h4GZFpiA
         vVblnYz75FXsYXSRa8mckqJGIseBYRTi0F0BrTw9o0jJp/c+/ltG3vgO9cvJwJ1ARzSl
         XQh2IecjGAFErSAxgAPesYgw42T7HPZFUz7y3TOoLRXgn8MtuQSXE6muGHH32Uc6Xc65
         jOjcSEhlgA9OwrPGsvGjkgH+sUDOmNPg4DGQo13sJeRcWHXzwt0yR/0Q+c2NjcmU9FME
         aah7K6CKUmCySxiuZpoTxBtlgHkGJqOt0ubq0BsrX/Ikxv1fTLGiNAjtxEuD4pJUO6HX
         r0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=c6gagiw90tH2rjIzHfPvJXOduAFDPhRqwu04EI2P9G4=;
        b=meNVcVorYGbFIisUCJX9YJnC/B7aKYOr8g/AbQgeUs2wBf3RXLzPj5llbWNji/agC5
         XffWSgjzOIIYaSJdrYC4fx2Jlg74ZcqTVOXwMN1312k0dBVjahd8PoZLoMGG7Jop6cuX
         p2QASJ5TyuDtRRzXrG9uF3Ih51C0w3/xQDeDj/q+LhnNN6Aa1NlJqoiaBFfhGkbV5PKN
         a8dlAbjZHZ9SAXBZg7mNvmpcTvSiZZq+5V/D3wpsrUiPllUU3F+CMIhWjukYUEgKN/i+
         IYItFvaPaAsWN+FCyEutZjG5EjhQQuCILlQO6R3JANYDFxdeqNLFGY+3B1POUkwRc44Z
         64Zw==
X-Gm-Message-State: AOAM533L8d5ecRLp8fSdr86n/UoC4ADNGveYA06D1WtZl5ZQ1efZFqfD
        C+M14MfzdmW+G2Jo6ijyF1RuvkD3PwO2Ew==
X-Google-Smtp-Source: ABdhPJy+ViBaw90/0xFm8oyZMYHOYpTbHCbt/CKMKVLAYCcb1yEGQ+rb180UWlyDk6b3FAmAA2WnBw==
X-Received: by 2002:a02:8521:: with SMTP id g30mr28654360jai.113.1625776753192;
        Thu, 08 Jul 2021 13:39:13 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id h10sm1732926ioe.43.2021.07.08.13.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 13:39:12 -0700 (PDT)
Date:   Thu, 08 Jul 2021 13:39:04 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <60e76268e64fc_653a42085b@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWXDY=YeNS_Kn6eWZc-0MHF3Cr0fwFzGESYvtOJt0eD0A@mail.gmail.com>
References: <20210706163150.112591-1-john.fastabend@gmail.com>
 <20210706163150.112591-2-john.fastabend@gmail.com>
 <CAM_iQpWXDY=YeNS_Kn6eWZc-0MHF3Cr0fwFzGESYvtOJt0eD0A@mail.gmail.com>
Subject: Re: [PATCH bpf v3 1/2] bpf, sockmap: fix potential memory leak on
 unlikely error case
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Tue, Jul 6, 2021 at 9:31 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > If skb_linearize is needed and fails we could leak a msg on the error
> > handling. To fix ensure we kfree the msg block before returning error.
> > Found during code review.
> 
> sk_psock_skb_ingress_self() also needs the same fix, right?

Yep.

> Other than this, it looks good to me.

I'll do another spin to get the other one as well. Mind as well
fix both cases at once.

> 
> Thanks.


