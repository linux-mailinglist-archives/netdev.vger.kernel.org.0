Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F09D49F18B
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345729AbiA1CzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345672AbiA1Cy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:54:58 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E179AC061756;
        Thu, 27 Jan 2022 18:54:57 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id n17so6153522iod.4;
        Thu, 27 Jan 2022 18:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5RICZwL9u/zTAxmOUojjtjT6pAJD/gLwWHz+0dS4t0I=;
        b=Mc6srME6Bkt2Matuu2y8fgrRpiX+sWi5bqd/b8qB17EWTT+/xlC+254JGrqsEWpAbA
         70Wb71FoxF2YeH1GwQ2qrp64IrLa6BOSeASJcCGhq+sDF9aLkJULMuC4s7wDF65Wcuf8
         TMhulDitop0kfz3XPUkmsmi43c38Xn1hN/tnTbsPDwkEp1OWeLr5ZlD0hHrI3FoMqpbT
         xwAFtFvuBYJXc2r5VXZmOgA/ET75zmFbBp4fw0V6fb5hEzDbP0UNx5dVXYC3M9qmPs5X
         mQkvkUIQMoenPhfNTRgkK+1R5q0YajbLj5MBQPTSu2z88Jb5wOj9S0Z0V05G5qgBQ3s/
         FZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5RICZwL9u/zTAxmOUojjtjT6pAJD/gLwWHz+0dS4t0I=;
        b=TM4RKG/mkRdMvlDnMwN6cl5I00SjbCfrpV5MyQDk1q70FuIX41YTZGo0M4Op8yUn10
         ET4GNSxiSAvpiY1iM4vSvKgks4RewdY/BXsn+KE3SqvpiRuTYV0/kKWuJ4gFjvqn45Ad
         9IXJd9V9RRrjtaEMFajRNPf4pdnxBWKyI9hEwtLZd6TzH0hxz3PAPqhpKqUX220ypCM4
         6StlmEdzjeKNPE3Xy0vM17Nef5hZBnPNnArj25Ll++wNbYlGzbdSiV4JoiSb2KU5imBe
         LGOEgUGVrPKekWs6t1D93GX0byCGbIVxPprZqIEpfQ1SWHnWCTwI9cCcAbB5zjnRYLsj
         Jn6Q==
X-Gm-Message-State: AOAM5325F5hqwPloRrCMjvHaYotzgcl9HM7mGYwXMbleiX/x4Tj538yL
        8ro8MD3oE9j/K1td7lI26As=
X-Google-Smtp-Source: ABdhPJw/JCnqr2FK1HDAssAXm/vgnxqXNk2E+XaA1AGalDUq8hK311nXmz2QK/yla3R3nHLOjkKRRQ==
X-Received: by 2002:a02:aa09:: with SMTP id r9mr3585057jam.199.1643338497409;
        Thu, 27 Jan 2022 18:54:57 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id t7sm11524793ilu.37.2022.01.27.18.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:54:57 -0800 (PST)
Date:   Thu, 27 Jan 2022 18:54:50 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <61f35afaeb9fa_738dc2086f@john.notmuch>
In-Reply-To: <20220125081717.1260849-1-liuhangbin@gmail.com>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
Subject: RE: [PATCH bpf 0/7] selftests/bpf: use temp netns for testing
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> There are some bpf tests using hard code netns name like ns0, ns1, etc.
> This kind of ns name is easily used by other tests or system. If there
> is already a such netns, all the related tests will failed. So let's
> use temp netns name for testing.
> 
> The first patch not only change to temp netns. But also fixed an interface
> index issue. So I add fixes tag. For the later patches, I think that
> should be an update instead of fixes, so the fixes tag is not added.

For the series. Thanks for cleaning this up.

Acked-by: John Fastabend <john.fastabend@gmail.com>
