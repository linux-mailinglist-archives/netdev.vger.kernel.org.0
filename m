Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FEA1F47C7
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733255AbgFIUKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:10:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25110 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731802AbgFIUKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591733435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIBz2nM/i5kWg1owng6M9L0w19pJxveVwHk7hkV+/2c=;
        b=e9+9QHZhV4fHRbZyi7vKAUhcSm4x+DTeRBOQpb7SWRXEUxTrFTszQjTBEuVNDxmuBIt6VQ
        A0FSLrmXc+/0Ikpip0m+M5kXq2izr9LyjUZRX7wvCeREvRcSntcrUyLz6+r1LSQM4kJsRe
        QM2S3r+YIWmuWTTT09sCMK3XKmCYgMg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-1W2XOXo0P1i2_SrDPOjHsQ-1; Tue, 09 Jun 2020 16:10:30 -0400
X-MC-Unique: 1W2XOXo0P1i2_SrDPOjHsQ-1
Received: by mail-ed1-f69.google.com with SMTP id i93so8653986edi.4
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 13:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=rIBz2nM/i5kWg1owng6M9L0w19pJxveVwHk7hkV+/2c=;
        b=JM8U+pQt9t6jE2ZjkneOxZRTHfTdtpJNLhazzciI1c10CYU0NZNDu0E5RB25SMhCKC
         zh3BkOR+lXKH11p+0FoZsIxN0iUOn4RpwbIMjLXBRhX2rfQA3rPurYZajXOVRbS086hW
         ixCzJuASSdXIQepCQ+xcV6zxJXHKyYvn8T1P+82uzm+ZG60HQYxg+/oKpZpZnyU5OvSo
         P6aTCCHx1y3Cn9Pj/fl2m1DuHUh7xwfjGLAS8MXbjCh5r6I+lymuWvYu95QcCgRu9C0W
         +FfJNqKxEUKnCSO3z03IkW5UwGDD5RLWwcxUm1SQgbrBt+2t+JlXY+4GwLou257mffTJ
         pKgQ==
X-Gm-Message-State: AOAM5319Jl5BIz4RhPEOu/WI70bwz6yeL1j17hsULInUG3amwen8hlx8
        sFz+c1f2Qc82Ee/soPzMFJ0E8+p29CWth2gbIyDMN/U7QzcJYJT777QFnlq8hPjuDBfZiRpvorT
        2sB2UDt3J33uihLBy
X-Received: by 2002:a17:906:1841:: with SMTP id w1mr86272eje.21.1591733429076;
        Tue, 09 Jun 2020 13:10:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhzKST1N5AbWaZKuqZEg8N4xtlo13xa2B0900r3iNywVgyEJwUOyuKAHUumf2R7GN011qnRQ==
X-Received: by 2002:a17:906:1841:: with SMTP id w1mr86256eje.21.1591733428888;
        Tue, 09 Jun 2020 13:10:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v26sm13484784ejx.25.2020.06.09.13.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 13:10:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BBC65180654; Tue,  9 Jun 2020 22:10:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        brouer@redhat.com, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com
Subject: Re: [RFC PATCH bpf-next 0/2] bpf_redirect_map() tail call detection and xdp_do_redirect() avoidance
In-Reply-To: <20200609172622.37990-1-bjorn.topel@gmail.com>
References: <20200609172622.37990-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 09 Jun 2020 22:10:27 +0200
Message-ID: <87o8ps80gc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> Is this a good idea? I have only measured for AF_XDP redirects, but
> all XDP_REDIRECT targets should benefit. For AF_XDP the rxdrop
> scenario went from 21.5 to 23.2 Mpps on my machine.

I like it! I guess in the end the feasibility will depend on the quality
tail call detection, which I don't have any ideas for improving. I'm
sure someone else will, though :)

-Toke

