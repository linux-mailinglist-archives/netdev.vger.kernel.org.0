Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDCA6AF84
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbfGPTBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:01:46 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41785 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfGPTBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:01:45 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so21532849eds.8;
        Tue, 16 Jul 2019 12:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Np3WkPZiSmEyIIL9cuGmzDJH3HAqVF26+WisTX76KYs=;
        b=lBVmOyHmvagQ+7D10ct9/vFRLpBv+NupfsB3FodRqjO5Q4hVzwAa/36coN7H4bNPqw
         hOfCiA4RmuF/M8JxTO0kgCoo3ViF9ppRHk7UPfM2boKjFXJ8kmVmM5F7fu+m0YVMlFZs
         KYEbwbGClQFy4bhYAlguqrAZ142VAU+VcQ1ggBKHavfDwPN2IgKeXxVcfJCbkY/kuFM7
         Fo94WooHWsmil/UbQUaIGrQYWAMKzBz4UOM8KSXcposO6ppMHjbrS37dMWigCxKiGrBY
         37B9xoNQxREM+1ahocc4Z1DfXbGRDb/OFFi/yxocnQ2Fd5WRe5C4TJLUeaj12JYwOdKe
         bzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Np3WkPZiSmEyIIL9cuGmzDJH3HAqVF26+WisTX76KYs=;
        b=tRqbrOPhszMwwUxtsvp6dD/XmDRh3lsIHNLfSF7fZB1QCMHnpPGlEmKd4SfH8jVS6b
         NHSWVT4xQdjbvVMuWcV1lDwcxYgUtk4H3ng5ymzHvcmiRPsE384Vn27MfG6RVTftt09L
         RbNXoD8SzFd4W04oe6LTHqmvTKlLEpxLEijreV2WUPUcdDtQF1rItpWXar97Av06wZIE
         XLWfwttDGmSZN8WprQnu8WMIizd8AhbfkGa64IpHQZo9mGOacwIqXSBV0okHaXLeiVqt
         ggnnd4GcckOFuQWO7yJSI3+rUiE17Yoh52Z/wBHH1bdwTpULc3GfaW975vJixNKYLI4Y
         q0YQ==
X-Gm-Message-State: APjAAAW1EbL5u15J44nu3WOYOCl8U6wLk3O7ZFoa0MpIdhKn+ucVzMgT
        FR2FBqlV8X56x6vQOQGksvHx6ZHihgZ7cwTp9mE=
X-Google-Smtp-Source: APXvYqy4SGxRA/RSeLqL+0hmvbLC0eQKEDvkry0t2d/SumMjlti+1WhV0V2RYxnci9fOvv57R97Z94J0XG2pBa4vkRo=
X-Received: by 2002:a17:906:b301:: with SMTP id n1mr26467468ejz.246.1563303703733;
 Tue, 16 Jul 2019 12:01:43 -0700 (PDT)
MIME-Version: 1.0
References: <1563291785-6545-1-git-send-email-cai@lca.pw> <20190716165136.GC37903@archlinux-threadripper>
In-Reply-To: <20190716165136.GC37903@archlinux-threadripper>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 16 Jul 2019 21:01:06 +0200
Message-ID: <CAF=yD-JixO-3HbxFn6BHa5aJY-dJTrNq4sWKneP4XA=xxU8Qnw@mail.gmail.com>
Subject: Re: [PATCH net v2] skbuff: fix compilation warnings in skb_dump()
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>, joe@perches.com,
        clang-built-linux@googlegroups.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 6:53 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Tue, Jul 16, 2019 at 11:43:05AM -0400, Qian Cai wrote:
> > The commit 6413139dfc64 ("skbuff: increase verbosity when dumping skb
> > data") introduced a few compilation warnings.
> >
> > net/core/skbuff.c:766:32: warning: format specifies type 'unsigned
> > short' but the argument has type 'unsigned int' [-Wformat]
> >                        level, sk->sk_family, sk->sk_type,
> > sk->sk_protocol);
> >                                              ^~~~~~~~~~~
> > net/core/skbuff.c:766:45: warning: format specifies type 'unsigned
> > short' but the argument has type 'unsigned int' [-Wformat]
> >                        level, sk->sk_family, sk->sk_type,
> > sk->sk_protocol);
> > ^~~~~~~~~~~~~~~
> >
> > Fix them by using the proper types.
> >
> > Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")
> > Signed-off-by: Qian Cai <cai@lca.pw>
>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks Qian.
