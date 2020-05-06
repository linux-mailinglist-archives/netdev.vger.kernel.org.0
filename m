Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A181C672B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEFFEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:04:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37371 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgEFFEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 01:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588741482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KpOKeTMlwPUqZw3AKWDidisP5BlFEm8fe5D0lqvFmu4=;
        b=jBGMTfJ/M+jJ0AA5iDC7rSc5aM30aXMomjTwFIZqHfop9eVh6Qe5f8uAeBDbzj+igmcrKm
        MJA9qks51W1MYXjoloqQbzo8h8eL571Ph1vjOgrEjWIXvmG5k3ZCWTEJi6tlGDv+nV78QT
        +3KLvaPpAI61qe8xR2msdITW02tvXKA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-nQn7II-XPrWGBJaP5IN93w-1; Wed, 06 May 2020 01:04:41 -0400
X-MC-Unique: nQn7II-XPrWGBJaP5IN93w-1
Received: by mail-qk1-f200.google.com with SMTP id a83so495403qkc.11
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 22:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KpOKeTMlwPUqZw3AKWDidisP5BlFEm8fe5D0lqvFmu4=;
        b=ksgluKUc8F/uTmE2mWKZ6UPinWcsp0Smvk3GXDIWTejG2Ow9BSKlVTHgsdWPE4JXmf
         uXZ0n1RS3IBy4Vv+SER411OYnBd/gMkst1Ezj0pcAwtKcR1em64xWG0GeNZZIg/Bw6OT
         cr5OzHGWDMxC7K7BnQPyXGaYkSYL8qz4vQGtYalfzTKclfUh0vit4y6KduOzOArHp2KL
         tWUmIHV8jphWO9MSlKDngUyY3cWBQAVNlSWiodm+/c99l8Y7sj/6OCofR0SK1zdPJVAr
         kGzqlf2JLwZFEX733mrX+pD4DvZ/TwpYed+tWGg+P4z3bXdLnijVE8LXjMAElE/IxE14
         Pkug==
X-Gm-Message-State: AGi0PuaG0vbA2u1RgEDhin/9av9rvZP5cinOMPSRzSTDRrwwJNK/HgdG
        tLblk6f1a7+S7bFc0M1C9WRsXl/RV2EDNht5h6friUAd/6yXJ/JUgr8f7Q+gixOgxpUBCc8aL8j
        zE0k1+BZ4Oph4TYgDBb0kxT7+Y0DjO2CE
X-Received: by 2002:a05:6214:1242:: with SMTP id q2mr6188941qvv.198.1588741480449;
        Tue, 05 May 2020 22:04:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypKVGmiq75u5vfcC1Iokiaz06crzjYhtEhd9qQagiN7lp4ZFJMlbiJrqHX9jd7sPmdUaT01LbgKV0sF/zJSstwU=
X-Received: by 2002:a05:6214:1242:: with SMTP id q2mr6188915qvv.198.1588741480169;
 Tue, 05 May 2020 22:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <1588705481-18385-1-git-send-email-bhsharma@redhat.com>
 <1588705481-18385-2-git-send-email-bhsharma@redhat.com> <20200505.142439.1075452616982863931.davem@davemloft.net>
In-Reply-To: <20200505.142439.1075452616982863931.davem@davemloft.net>
From:   Bhupesh Sharma <bhsharma@redhat.com>
Date:   Wed, 6 May 2020 10:34:28 +0530
Message-ID: <CACi5LpP+47EEO4YS6TCPPA4-xeu6phXV2uz=8bfWdfggwC73Kg@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: qed*: Reduce RX and TX default ring count when
 running inside kdump kernel
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Bhupesh SHARMA <bhupesh.linux@gmail.com>,
        kexec mailing list <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        manishc@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, May 6, 2020 at 2:54 AM David Miller <davem@davemloft.net> wrote:
>
> From: Bhupesh Sharma <bhsharma@redhat.com>
> Date: Wed,  6 May 2020 00:34:40 +0530
>
> > -#define NUM_RX_BDS_DEF               ((u16)BIT(10) - 1)
> > +#define NUM_RX_BDS_DEF               ((is_kdump_kernel()) ? ((u16)BIT(6) - 1) : ((u16)BIT(10) - 1))
>
> These parenthesis are very excessive and unnecessary.  At the
> very least remove the parenthesis around is_kdump_kernel().

Thanks a lot for the review.
Sure, will fix this in the v2.

Regards,
Bhupesh

