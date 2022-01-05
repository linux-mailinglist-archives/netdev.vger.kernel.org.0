Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0304856A9
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241916AbiAEQaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:30:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241912AbiAEQaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 11:30:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641400200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rhnD07g5paab63PHzRXGLYnd5v81Kd5rTKW8UNX8YzA=;
        b=e6bBLqi+YXpoWSheJOVl1CMQwQ90ZFCvC5gZqVCxKkdPoagUmLN3JFP7Rhet80x76kGooA
        IHa4p8ODgdO6oOpVtq57hpSOUJDCOQGBPTcqFvOtBF2NE6S34HJtYyPgF2qZz/NHWEf+qi
        B71PzXkvCUh34aZtvJYXIrWcUJUHBh4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-BPFSxRYMOECMq1R6mAhtyQ-1; Wed, 05 Jan 2022 11:29:58 -0500
X-MC-Unique: BPFSxRYMOECMq1R6mAhtyQ-1
Received: by mail-wr1-f70.google.com with SMTP id s23-20020adf9797000000b001a24674f0f7so12792713wrb.9
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 08:29:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rhnD07g5paab63PHzRXGLYnd5v81Kd5rTKW8UNX8YzA=;
        b=n6D1RqQyMh+/XHpSA0FaawIqbvfyFvruK8lP4mZsbEKxv1Dr/OswW3cA8C/lptQ71I
         FUwBkn2zl2cFhPOG7uoxn1g6hIB681QDDHUYbrMwWjcj8UGP6ACf8eOQeTgwBUDZrzfY
         PNaCnqHl+EXENrV3ScTaal8h2HURFRGR3TJDLlmCDoANzgYp8khZEboNm6kilIxw8Nb9
         cZOtVIT669m4iB5CvviArLfx69NauWVg8s+Brsa8GafQ75J6v3AxW+ElZSg6TJnyOyle
         nwthwOeyizmBTA3pAH4yzA5Hgh0V9KFabIeh6Lw/6N/zrSgfK7ENX5P8SCUsawBQJ3q+
         bLQA==
X-Gm-Message-State: AOAM533POSJkUGbYG4q/26lcTDAHQlAQjo607ns/+03ON6JS2Zsu4LPP
        fFabR3dq1Bs3AqmZ97vkkwtylpbYjGxereLjAQSva4rY56dEAS0Jqh1jm9pqNW4vXHrmK/VppA0
        tDX4JEQjdYp079F7s
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr3586729wmh.57.1641400197390;
        Wed, 05 Jan 2022 08:29:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPDF6neFuUdFAnSW7wX+PzCMUmHGZBZQTAzn+vyEAucDG2YwTrWOXDSAP/c6zHSePEyzkGKQ==
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr3586720wmh.57.1641400197214;
        Wed, 05 Jan 2022 08:29:57 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id f6sm3583912wmq.6.2022.01.05.08.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 08:29:56 -0800 (PST)
Date:   Wed, 5 Jan 2022 17:29:54 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     James Carlson <carlsonj@workingcode.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] ppp: ensure minimum packet size in ppp_write()
Message-ID: <20220105162954.GB17823@pc-1.home>
References: <20220105114842.2380951-1-eric.dumazet@gmail.com>
 <20220105131929.GA17823@pc-1.home>
 <dbde2a45-a7dd-0e8a-d04c-233f69631885@workingcode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbde2a45-a7dd-0e8a-d04c-233f69631885@workingcode.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 10:30:09AM -0500, James Carlson wrote:
> On 1/5/22 08:19, Guillaume Nault wrote:
> > On Wed, Jan 05, 2022 at 03:48:42AM -0800, Eric Dumazet wrote:
> >> From: Eric Dumazet <edumazet@google.com>
> >>
> >> It seems pretty clear ppp layer assumed user space
> >> would always be kind to provide enough data
> >> in their write() to a ppp device.
> >>
> >> This patch makes sure user provides at least
> >> 2 bytes.
> >>
> >> It adds PPP_PROTO_LEN macro that could replace
> >> in net-next many occurrences of hard-coded 2 value.
> > 
> > The PPP header can be compressed to only 1 byte, but since 2 bytes is
> > assumed in several parts of the code, rejecting such packets in
> > ppp_xmit() is probably the best we can do.
> 
> The only ones that can be compressed are those less than 0x0100, which
> are (intentionally) all network layer protocols.  We should be getting
> only control protocol messages though the user-space interface, not
> network layer, so I'd say it's not just the best we can do, but indeed
> the right thing to do by design.

Well, I know of at least one implementation that used to transmit data
by writing on ppp unit file descriptors. That was a hack to work around
some other problems. Not a beautiful one, but it worked.

