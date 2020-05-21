Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53C1DD58A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgEUSEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgEUSEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:04:05 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0743FC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:04:05 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id m18so9411629ljo.5
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Gg4b4CDCsETMIm4Edj1Xv31p6ZdZ0NWSz903G/X2Po=;
        b=C+6xQYv405ppXq81KjYUQtltgLKHhtWFV7DfKyUQgnD/o5JsMIaX3ld48tDI1ZlD7K
         U7kuhQvl7mdKFxmVsF/c3fYz37gu4oWx14U5jtAODWIsK4FqzsUCdodSWDq8PJADqJQN
         fxp/doyT7dYvEricBmr9oFTSOXixPbh/BPwNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Gg4b4CDCsETMIm4Edj1Xv31p6ZdZ0NWSz903G/X2Po=;
        b=Czb4/DpYMGKi/fY0YI0etVDm/jszn1iDPrz6f3vGyHq8YnMJ+4VeoOQMxLaGUPfTAY
         TcpFRDH/q/8LQ3dbaBz+LleFXKr5OkBar8bqv39CoRURJ+Q3+H3v8W5haxGWeJEa/GoY
         xvTs7q9uvNdYtahOW5NjwRPLa5M4dUMV82Y3TEX21nO0HIYnu6aCyk8vYV/eT7fTscrK
         WTTVhzh7YQoS6YWyGOjLCdHN63demBq5XSb+StId6yX630mbtbG7Zj2WcV9ukPbquZfq
         JCz0XM+OOEoyDZ46rMrNp7oJctXd8qznDMLoW9G6L3tO7+cOIX7hkP9c+BZLBfpnp5CV
         wljg==
X-Gm-Message-State: AOAM533zkIRZcL/jyfNzlurThSEHYFoTUnpnE3L63bRDXAwZi5pxfnHG
        OSQcnYf9O0HW08JgDsK6YOlNC1fbS6M=
X-Google-Smtp-Source: ABdhPJy6aeG+/qc6crTjB5NbKTLj89oP9ucLyQF3HRaiUbBjaVGHMcaIifE23kTz6Pmar4l49QINaw==
X-Received: by 2002:a2e:980d:: with SMTP id a13mr5820387ljj.277.1590084242308;
        Thu, 21 May 2020 11:04:02 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id y24sm2128925ljh.18.2020.05.21.11.04.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 11:04:01 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id g1so9391981ljk.7
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:04:01 -0700 (PDT)
X-Received: by 2002:a2e:9891:: with SMTP id b17mr3748342ljj.312.1590084240602;
 Thu, 21 May 2020 11:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200521152301.2587579-1-hch@lst.de>
In-Reply-To: <20200521152301.2587579-1-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 21 May 2020 11:03:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQa3GNytJDdN=RKzSKfGQdPBvso+2Lmi+BpOP=BA_n6A@mail.gmail.com>
Message-ID: <CAHk-=wiQa3GNytJDdN=RKzSKfGQdPBvso+2Lmi+BpOP=BA_n6A@mail.gmail.com>
Subject: Re: clean up and streamline probe_kernel_* and friends v4
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 8:23 AM Christoph Hellwig <hch@lst.de> wrote:
>
> this series start cleaning up the safe kernel and user memory probing
> helpers in mm/maccess.c, and then allows architectures to implement
> the kernel probing without overriding the address space limit and
> temporarily allowing access to user memory.  It then switches x86
> over to this new mechanism by reusing the unsafe_* uaccess logic.

I could not see anything to object to in this version. So Ack from me,
but obviously I'm hoping others will try to read it through as well.

              Linus
