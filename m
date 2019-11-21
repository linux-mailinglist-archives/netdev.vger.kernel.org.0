Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C3D105B1D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKUU1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:27:32 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38084 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUU1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:27:32 -0500
Received: by mail-io1-f67.google.com with SMTP id u24so3331690iob.5
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 12:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=SnK7qVKobjjCwRGLW+dbn/lzHsjSbO1HGvbDLFNO1Q8=;
        b=VvW4SdmPGW4ZeD0iX6JjOzOix6RNi/R/zcpm8fWrhh2ol6ir9OCwBYRL3jMUxjFTK2
         /zTDKDtLmPtHOwlpXzKnUj7RUebV5wcjZMFA4yioFPsc/o8nP0HwcKwwPqkJEF8gjX14
         sOSRSkI2llU8UMBpcLdxhgKTAoOEx7dcm9cTLxuvs1mk1sykNx8qCr/lHodUYmrxp5R7
         osZUmVsVvMgPHgsMIxmYkMzbdEnQRR22ZYWbzbnooSPrB14GHiq2FKBLArkomKHNhan+
         iCxRCVvONwGhgYKdCygzKS/lgVRPoifMtsXdZH/rJUqnPasa5qpzh0HeThGA2lyHElq2
         wttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=SnK7qVKobjjCwRGLW+dbn/lzHsjSbO1HGvbDLFNO1Q8=;
        b=RTqhavRHHlwYsYLb8GzbTTIZNznDPQanWCtTSoM7CJQC2pHqPbYoxwWmOBrzo2pEsC
         2rU5qwVikkNzaK7ImcUSp65WVUMnMXqrTn0Sr4NlxGj5Xp335AbE1oEkF+y3CQ7xsT01
         d5p5p4qrk6ENIztIlsLtfC6Piz6DN9h9OazztcWc6Djv7c3ED4i/4E+z0qVqLoctnqyQ
         Qth/mM0HXRdRMS02k7LY7QZsm+4Qu51tjwmc4TjyJko46P7nnhkoxH+umy1zcPQMFaMq
         ITj7fmWIWtPqKwpuZG1piMGKirwoR192LedHZD8ggkN50+goBOcQX+hh/VhkpWwtTZ4F
         FAmA==
X-Gm-Message-State: APjAAAVabAF/4EIUpOWSCHzPzecvYgk7tcjhYvGyrZwbcKqfjjoStyeM
        it8RmZYD0fOzwGga6TW+OPw=
X-Google-Smtp-Source: APXvYqzoiL56PKXhOSgRfcEHdQ7d3rQwRAgZYHMpcISoQY9o4emaGYgxmlLv0deDAq16Gxbo7f5h1w==
X-Received: by 2002:a5d:94ca:: with SMTP id y10mr9699943ior.104.1574368051282;
        Thu, 21 Nov 2019 12:27:31 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w75sm1702887ill.78.2019.11.21.12.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 12:27:30 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:27:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5dd6f32b2816_30202ae8b398a5b469@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQLX3U4uSASVeha54oZsgi6DhNuYSXyW6=uKuf=ijC5vdQ@mail.gmail.com>
References: <157435350971.16582.7099707189039358561.stgit@john-Precision-5820-Tower>
 <CAADnVQLX3U4uSASVeha54oZsgi6DhNuYSXyW6=uKuf=ijC5vdQ@mail.gmail.com>
Subject: Re: [net PATCH] bpf: skmsg, fix potential psock NULL pointer
 dereference
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Thu, Nov 21, 2019 at 8:28 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Report from Dan Carpenter,
> >
> >  net/core/skmsg.c:792 sk_psock_write_space()
> >  error: we previously assumed 'psock' could be null (see line 790)
> >
> >  net/core/skmsg.c
> >    789 psock = sk_psock(sk);
> >    790 if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
> >  Check for NULL
> >    791 schedule_work(&psock->work);
> >    792 write_space = psock->saved_write_space;
> >                      ^^^^^^^^^^^^^^^^^^^^^^^^
> >    793          rcu_read_unlock();
> >    794          write_space(sk);
> >
> > Ensure psock dereference on line 792 only occurs if psock is not null.
> >
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> 
> lgtm.
> John, do you feel strongly about it going to net tree asap?
> Can it go to net-next ? The merge window is right around the corner.

Agree we can send it to net-next, its been in the kernel for multiple
versions anyways.
