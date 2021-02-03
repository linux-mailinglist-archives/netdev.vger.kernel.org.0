Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00F030E412
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhBCUav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhBCUas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:30:48 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57290C0613ED;
        Wed,  3 Feb 2021 12:30:08 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id s24so751248iob.6;
        Wed, 03 Feb 2021 12:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wFjeCmd7uwrlvqvLPlufFHfHxqZnxa5Hn6c4hScQlNE=;
        b=ERktb6XZPwM5K4q6V4fmCKD93UgjapeTUZZiNd+LFMR9EuUUcktlOQsONIrL78EDV7
         AK0S0gBv9b9y86bNH3bTZ5wu+mjPoERPRq7/D98tIhM2h/liyU8mpkbaLEWkzMG16Jcn
         U/h3TP8wA65okqC40l5cKADqXgNOIMp8PqTkcnpjjEma+st+1GAZ49Rz3TnfCRUjmpTx
         4KZkj+8SAEX5M2y2bwJ5y1XVfjywca5mmex4wc03ykqlS4A6IWGTPHc1tB+ncfwnMG+t
         vBpzXimlAzNZQMo9SaPMsKkp8ATRFoVwKoVg7WTpcPiWaOGyCWB3EDUiN4WPRD5q3YUJ
         ejxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wFjeCmd7uwrlvqvLPlufFHfHxqZnxa5Hn6c4hScQlNE=;
        b=AdE+l1MwPC91y2JKoJgWU0x0Y2AG4I/Q5uFgeHpA8crBDyokn9Hii4dIjE2tKudsx1
         IcPrwLr812NwgyxMaSJflhNOOY4+GzFnSraOCCYEfNavy5EBbWMQx6I50Qr1LJFKGq/A
         6AVQ9atBE97iZlXoSKwICpLpYAtT+KO6bsw+2B02L3bKP2oi3xau6MXkKa0c886gZfK6
         wc3wAROwd+NZDSqSwML+usmcBwgsVm2PmcGMXqRbFCiTnhf1Y5O+X/Q8Hq/VXUO/Eh2z
         yV03B697GggCAnywNtcc1ppiK7oyZ/+Y67nAT2riggMcCW+j4gWJXs1xBtHod/df6slP
         HF4Q==
X-Gm-Message-State: AOAM530xneoBu5byu/b4bsrsGtUmyMKJ22uteGJsQ4sU53QA/QJCrsyM
        D6jwtQ5b/xq7jyWSKq3FmUU=
X-Google-Smtp-Source: ABdhPJyrBUgQMD7fIy4RqPlhIg8KsMzQ8JD82A5gRi94EvR4XH7id9cNN3L1QJD3SWyPGMHkgZl+rw==
X-Received: by 2002:a6b:ed0f:: with SMTP id n15mr3896782iog.94.1612384207741;
        Wed, 03 Feb 2021 12:30:07 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id d9sm1473037ilo.20.2021.02.03.12.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 12:30:06 -0800 (PST)
Date:   Wed, 03 Feb 2021 12:29:57 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Message-ID: <601b07c5c8345_4b70c208f2@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpX-GDysSZTYr-2WsbqFP4VgG5ivcO1vwLvKVHkJ9hjodg@mail.gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203174846.gvhyv3hlrfnep7xe@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpX-GDysSZTYr-2WsbqFP4VgG5ivcO1vwLvKVHkJ9hjodg@mail.gmail.com>
Subject: Re: [Patch bpf-next 00/19] sock_map: add non-TCP and cross-protocol
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, Feb 3, 2021 at 9:48 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Feb 02, 2021 at 08:16:17PM -0800, Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Currently sockmap only fully supports TCP, UDP is partially supported
> > > as it is only allowed to add into sockmap. This patch extends sockmap
> > > with: 1) full UDP support; 2) full AF_UNIX dgram support; 3) cross
> > > protocol support. Our goal is to allow socket splice between AF_UNIX
> > > dgram and UDP.
> >
> > Please expand on the use case. The 'splice between af_unix and udp'
> > doesn't tell me much. The selftest doesn't help to understand the scope either.
> 
> Sure. We have thousands of services connected to a daemon on every host
> with UNIX dgram sockets, after they are moved into VM, we have to add a proxy
> to forward these communications from VM to host, because rewriting thousands
> of them is not practical. This proxy uses a UNIX socket connected to services
> and uses a UDP socket to connect to the host. It is inefficient because data is
> copied between kernel space and user space twice, and we can not use
> splice() which only supports TCP. Therefore, we want to use sockmap to do
> the splicing without even going to user-space at all (after the initial setup).

Thanks for the details. We also have a use-case similar to TCP sockets
to apply policy/redirect to UDP sockets so will want similar semantics to
how TCP skmsg programs work on egress.

> 
> My colleague Jiang (already Cc'ed) is working on the sockmap support for
> vsock so that we can move from UDP to vsock for host-VM communications.

Great. The host-VM channel came up a few times in the initial sockmap work,
but I never got around to starting.

> 
> If this is useful, I can add it in this cover letter in the next update.
> 

Please add to the cover letter. I'll review the series today or
tomorrow, I have a couple things on the TODO list for today that
I need to get done first.

> Thanks.

Thanks for doing this work.
