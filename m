Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3888B489D1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFQRPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:15:49 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38291 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQRPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:15:49 -0400
Received: by mail-pl1-f193.google.com with SMTP id f97so4354962plb.5
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=DgOicHKWVUzDMqvZ9egverk9UhTEZ7cuxcnhjeTk4Ys=;
        b=HpL20dTkbtvYY6ekwYl9D2Q8F5lOGzABCnOu3i8uN7kPopJJBSpvYhmOeVVTyxmNuK
         fusdVPDMtKcmUVgXG1hI6ZhDF/WhdU3P7tzNa3iG063WXtQImR2/IfluuK5TjglRWBtL
         YuTMOssEAoLebnwmCDdTHznecg5fPfopuYGCj2cR6jiyvP44gkdjUayvg6s3MkX6e9/Y
         acM9ZsNlHM9NugdVnnR9Ag93Uuw2d+UhS8HM9TxN0Y8IjlcIeDFPc1L5AzCjY8fz3hNx
         R4WfNN2d/Peme8aintrOvRg+vZicePglfGDAQhVkdyJ8rqCZMTNUfP/ILbThwvxJspDh
         iTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=DgOicHKWVUzDMqvZ9egverk9UhTEZ7cuxcnhjeTk4Ys=;
        b=iA/IaB5HQH8CzzxuJcvMfJm8z+Op4rDPXXKAyTQeM06Qg931kF924HdXQ14RGPrZGz
         mmekpMKLgh+038hGwxRjstRf9vTQDgtdhRjf1JOHbSdvckNWuqzsukH/S+9s6rqQhQRS
         HHsurEb+95sFp6ZgQm9PGZTGJjap8eC0pLKEv7l8fireBXH6srGdWof9aZne19Zpj2UF
         gTXj78Smxy0sOZf5rKjiyXm4q2K+jhEInmZ2oAcriRcnGGfGkDLLvw5TIgaQ13s9p5xN
         +1kVX5mXQpaELqvNDXPgSvaQWDOWyef248j2dnwlOyJ60j8OZCbLSn/K5t9m+1dyGmde
         Rdjw==
X-Gm-Message-State: APjAAAU62KJr/udwQdEGQBUwknVfCly8R49sA14owBFf5nl6UjjDSx53
        VuC3e5p02sHG9IwI3Kg0zPg=
X-Google-Smtp-Source: APXvYqzeQ1iXHsczH8nYvuF9lOKISI/b2B/vqymGJeIjNjb3jE63CYuHJocc7uwMuG4ptNZ+XnHsog==
X-Received: by 2002:a17:902:aa88:: with SMTP id d8mr97613679plr.73.1560791748459;
        Mon, 17 Jun 2019 10:15:48 -0700 (PDT)
Received: from [172.26.125.68] ([2620:10d:c090:180::1:e1dd])
        by smtp.gmail.com with ESMTPSA id k22sm9329709pfg.77.2019.06.17.10.15.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:15:48 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Bruce Curtis" <brucec@netflix.com>
Subject: Re: [PATCH net 3/4] tcp: add tcp_min_snd_mss sysctl
Date:   Mon, 17 Jun 2019 10:15:46 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <DDC9B07B-14FD-41D4-A6F8-725957CEA023@gmail.com>
In-Reply-To: <20190617170354.37770-4-edumazet@google.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-4-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 Jun 2019, at 10:03, Eric Dumazet wrote:

> Some TCP peers announce a very small MSS option in their SYN and/or
> SYN/ACK messages.
>
> This forces the stack to send packets with a very high network/cpu
> overhead.
>
> Linux has enforced a minimal value of 48. Since this value includes
> the size of TCP options, and that the options can consume up to 40
> bytes, this means that each segment can include only 8 bytes of payload.
>
> In some cases, it can be useful to increase the minimal value
> to a saner value.
>
> We still let the default to 48 (TCP_MIN_SND_MSS), for compatibility
> reasons.
>
> Note that TCP_MAXSEG socket option enforces a minimal value
> of (TCP_MIN_MSS). David Miller increased this minimal value
> in commit c39508d6f118 ("tcp: Make TCP_MAXSEG minimum more correct.")
> from 64 to 88.
>
> We might in the future merge TCP_MIN_SND_MSS and TCP_MIN_MSS.
>
> CVE-2019-11479 -- tcp mss hardcoded to 48
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Tyler Hicks <tyhicks@canonical.com>
> Cc: Bruce Curtis <brucec@netflix.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
