Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3392A79F8
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfIDEgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:36:41 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43688 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfIDEgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 00:36:41 -0400
Received: by mail-io1-f65.google.com with SMTP id u185so37438249iod.10
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 21:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=i3nrnc8bpije9pcN7CPRHPjjWKBl4gCtCGiAd73YqlU=;
        b=ET9ad8G0BDrQoRuHyNDLV2a4PUyeMDM1XhEvi0gWMCR+VRkfPiWDTbovhhKhWbbTFH
         GYMiw367lYujfojv6ddmuHqbtpZ2WMjSPvXwOd+6Z+hTMRz9dudsFfj19qCKyW/Oz9xh
         xj9S4ih+Rp97jqL6k+dVapoft6LOg+78rOr2yqYZfXlV9Wj5ju+LNJLh/mD1/s8qEOvF
         cNhr1/1Ha9wPEB12tkdhG1w8MNtGznR0JgauvPLDpHPZzxywl9hLcaNZ00bCSPLl6e4D
         fj/RgwvkizAeEFi5A6EtZ5vm6HUapVkPz+d1mTsicuzD9csFHc/LPBtVlbV1MS1HHMdo
         gKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=i3nrnc8bpije9pcN7CPRHPjjWKBl4gCtCGiAd73YqlU=;
        b=Qc/irv9YZDhh56c1AeX/vvxIX1uPmp+uVOP0FjBbSDGMH7UN44aOVLsgLpYh4zZLyG
         wxGpM9DoDMu4IG/g4t5kT+9Sbm2k71AOoEXTYGZ2ehEblotVgsqEP0pj508Suc4erpU0
         6L3aw3gEBN3Sos2Sj45r6a/mXmqvetLaGHO10qUrd9Lt8FWnuq4J+zZb6l1pvB7MfllS
         SRKlo/8LLmqVioKFjCehKMuPedzEuh4Ry83rqpMyGe4Rchvd3o5HwbHmNvW7FGQA3lFO
         zz6yev9F9m6eAl8swtVxxU6avgcwyoFDpmL3zOgJaY+j1iZgIJDsiOr8d3bmAiwbT0cE
         Hkyg==
X-Gm-Message-State: APjAAAWZn11i4R/CpPZ4C7Y2M6wKqd8i4DZBG4oDJGMnB7cht4TEUbuP
        QqPVs8hCcjP7jQ9COxNgziE=
X-Google-Smtp-Source: APXvYqxZTSkW0Hqa2dNGMTAvI6z5POOD/KWtWYSdRgfR/+dDdDuSaKNMjFd1N3NJajTu5mRI9Y0FGQ==
X-Received: by 2002:a5d:974d:: with SMTP id c13mr225532ioo.87.1567571800889;
        Tue, 03 Sep 2019 21:36:40 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s201sm25365110ios.83.2019.09.03.21.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 21:36:40 -0700 (PDT)
Date:   Tue, 03 Sep 2019 21:36:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Message-ID: <5d6f3f4af03ab_de32af1eb5fc5b4b7@john-XPS-13-9370.notmuch>
In-Reply-To: <8579889b-7ad4-4d37-0141-db0b3d5d4b2a@mellanox.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
 <8579889b-7ad4-4d37-0141-db0b3d5d4b2a@mellanox.com>
Subject: Re: [PATCH net-next 0/5] net/tls: minor cleanups
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Boris Pismenny wrote:
> On 9/3/2019 7:31 AM, Jakub Kicinski wrote:
> > Hi!
> >
> > This set is a grab bag of TLS cleanups accumulated in my tree
> > in an attempt to avoid merge problems with net. Nothing stands
> > out. First patch dedups context information. Next control path
> > locking is very slightly optimized. Fourth patch cleans up
> > ugly #ifdefs.
> >
> > Jakub Kicinski (5):
> >   net/tls: use the full sk_proto pointer
> >   net/tls: don't jump to return
> >   net/tls: narrow down the critical area of device_offload_lock
> >   net/tls: clean up the number of #ifdefs for CONFIG_TLS_DEVICE
> >   net/tls: dedup the record cleanup
> >
> >  drivers/crypto/chelsio/chtls/chtls_main.c |  6 +-
> >  include/net/tls.h                         | 48 +++++++++-----
> >  net/tls/tls_device.c                      | 78 +++++++++++------------
> >  net/tls/tls_main.c                        | 46 ++++---------
> >  net/tls/tls_sw.c                          |  6 +-
> >  5 files changed, 85 insertions(+), 99 deletions(-)
> 
> LGTM
> 
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> 

Also LGTM. primarily reviewed the tls_{main|sw}.c pieces

Reviewed-by: John Fastabend <john.fastabend@gmail.com>
