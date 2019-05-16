Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212D120D11
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfEPQcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:32:48 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:35412 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfEPQcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:32:48 -0400
Received: by mail-qk1-f175.google.com with SMTP id c15so2671244qkl.2
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 09:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appleguru.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sNULc9LftB44W2Iv6y2pLvz98UIco3dfz8kKHtwH93Q=;
        b=DKBXUR2wqnuD72MIOLMRSswoI82bascRFl5Vq2cQ8rvIIzkgnvFVVuV83TU+Ml0JlO
         +Spqis8eC0OuxWtxREoQ0GKk1pTOVYQsSzh/gJsXsBH/V5SEecqk1mbA5xIDud2NhdhZ
         aLbdpCK2zFB7xYPbqTCk1wC/my8vvxRF39r1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sNULc9LftB44W2Iv6y2pLvz98UIco3dfz8kKHtwH93Q=;
        b=n1AHsfwrfWbxZCxpoVaXFb1ApwLRv8X2bKJ3iJ3uuBtXqB8F3ZSA5uj8fWWfdrDh6g
         3ypc1AQYH1MtcmPQpJVBg0Bce5VZQUserZEteLCsP4TiHKOTCWuUXsdigZOxVKdJEeTv
         l+dXag4DBhGQsKH7k60RGLIr4IJwGOicZCAFy+voRR1OcudAqfs4Xf+Tf6hkhCnWmOjB
         dcPNnHr8hwFCpRwLgf6zh5qbq+hZ4AybAXWyVG670o+ko90Bjc8reV1gRlfHrdWBwRVX
         nZLR4ZNnlonGI+cBAwgvx80e8dUjkg9VbhlJzkANVcsu24x5F25Ce634Okoi6Qpwuy6U
         XY2Q==
X-Gm-Message-State: APjAAAVQKC4i/IQGdwleToZoh81z4Hyjc+rJViicX66iWECTqjshMF5c
        +d/s02SnC9XzOZj3Cz1TZTrUfzBDJzqdEg==
X-Google-Smtp-Source: APXvYqxnTpy/SXnLPEwmnzzg57cCST9yJ1CzcVctvB64RVe2PvxCu3RVS80u6XZMFhQ7sza/g06WAw==
X-Received: by 2002:a05:620a:1012:: with SMTP id z18mr39372110qkj.205.1558024367327;
        Thu, 16 May 2019 09:32:47 -0700 (PDT)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com. [209.85.160.182])
        by smtp.gmail.com with ESMTPSA id j10sm2630209qth.8.2019.05.16.09.32.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 09:32:46 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id h1so4689955qtp.1
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 09:32:46 -0700 (PDT)
X-Received: by 2002:aed:2471:: with SMTP id s46mr43407208qtc.144.1558024366210;
 Thu, 16 May 2019 09:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
 <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com> <18aefee7-4c47-d330-c6c1-7d1442551fa6@gmail.com>
In-Reply-To: <18aefee7-4c47-d330-c6c1-7d1442551fa6@gmail.com>
From:   Adam Urban <adam.urban@appleguru.org>
Date:   Thu, 16 May 2019 12:32:35 -0400
X-Gmail-Original-Message-ID: <CABUuw67crf5yb0G_KRR94WLBP8YYLgABBgv1SFW0SvKB_ntK4w@mail.gmail.com>
Message-ID: <CABUuw67crf5yb0G_KRR94WLBP8YYLgABBgv1SFW0SvKB_ntK4w@mail.gmail.com>
Subject: Re: Kernel UDP behavior with missing destinations
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric, thanks. Increasing wmem_default from 229376 to 2293760 indeed
makes the issue go away on my test bench. What's a good way to
determine the optimal value here? I assume this is in bytes and needs
to be large enough so that the SO_SNDBUF doesn't fill up before the
kernel drops the packets. How often does that happen?

On Thu, May 16, 2019 at 12:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/16/19 9:05 AM, Eric Dumazet wrote:
>
> > We probably should add a ttl on arp queues.
> >
> > neigh_probe() could do that quite easily.
> >
>
> Adam, all you need to do is to increase UDP socket sndbuf.
>
> Either by increasing /proc/sys/net/core/wmem_default
>
> or using setsockopt( ... SO_SNDBUF ... )
>
