Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C53B60BFE
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfGET4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:56:36 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37913 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGET4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:56:36 -0400
Received: by mail-yb1-f194.google.com with SMTP id j199so2560239ybg.5
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 12:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k1XFLtemOwoEObUq1r+BdYwHkBNPzTPyRVxA9pXsoUw=;
        b=Zu4aM99vW3xRu522B3FeGl7VInAgLQ9lcXcobb4M8bYXIFBKW0hRg0+LZ7Pj4VYrKn
         z2xv4bA3fCTQHOm6e+cE3BKf43LcD3vfDMoPR14SYDZk4+SzcGZONH6WBQxg9TJ1X2pA
         4HFoFHLRfjOh7jVoLevMeS4nl7LPEUZkh3qwavrN/Nd5wswXHlYsXj/pV1AKoJ5BkbJp
         yGTZZYlbujD2/Yp/K5AyNt6EfPhLXA5jmjDLX7KL290QBpqELChoTZdOHS8gb3ziIn04
         89SHCR9eL2bM1Y5lhVIhsjg2GIvpYxvgnssTM2HWxSkBWhN4+z7L0bMkOZjJI9tVSxVp
         3Y7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k1XFLtemOwoEObUq1r+BdYwHkBNPzTPyRVxA9pXsoUw=;
        b=ltGSSgKRPoV7S/athErnYzr/1oLVBPTkLbrEkC4H0SgOSHQPK3/uif1N+Aeh4w7nVz
         d9AGbvrcdpPD9i5g+ba4OBww17OnQoRNc5M2mzrq6ABDUe6qxBD1r7299lx2aAezuGKa
         OY563OShzdl1zg0ROyIwRXu0ggY4f5s+H5CMSuwVkVv1sN79EXegpmGhFylhKab1KCCj
         dbKeNOPoKFK6G0PoWfIVh/eW/othcza2AyjnExWWjBoioovNJAZSNT4sRPxrmEzDUBbS
         eSGkHMqZoyHSEgYUq9C4GL1HUPQtWGyZWqypT4/QzRyhdibterflqdy5Du2/tcWxFL3w
         Pknw==
X-Gm-Message-State: APjAAAVX3Vj1rc3KuBfNqtlbAXsDy09/g3xEiZkTRpxOg/TOX+4bl+08
        JzOor0aEHGykh7A5IBMmxQS1fO4I
X-Google-Smtp-Source: APXvYqyTwTPAXEbtLpx697wEwaVMSQJ4xhBs85yhMuBDXvQycJOKCA07j6+YMLjtZOCl4T7H3Z11KA==
X-Received: by 2002:a25:cfcd:: with SMTP id f196mr3513903ybg.344.1562356594631;
        Fri, 05 Jul 2019 12:56:34 -0700 (PDT)
Received: from mail-yw1-f41.google.com (mail-yw1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id x138sm406962ywg.4.2019.07.05.12.56.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 12:56:33 -0700 (PDT)
Received: by mail-yw1-f41.google.com with SMTP id z197so2722505ywd.13
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 12:56:33 -0700 (PDT)
X-Received: by 2002:a81:6a05:: with SMTP id f5mr3548533ywc.368.1562356593443;
 Fri, 05 Jul 2019 12:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <1562326994-4569-1-git-send-email-debrabander@gmail.com>
In-Reply-To: <1562326994-4569-1-git-send-email-debrabander@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 5 Jul 2019 15:55:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfYC_gP3ACV7E0M-i8zVXbmnrfu_+AE4j4QrVDTDPJscg@mail.gmail.com>
Message-ID: <CA+FuTSfYC_gP3ACV7E0M-i8zVXbmnrfu_+AE4j4QrVDTDPJscg@mail.gmail.com>
Subject: Re: [PATCH] selftests: txring_overwrite: fix incorrect test of mmap()
 return value
To:     Frank de Brabander <debrabander@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 7:44 AM Frank de Brabander <debrabander@gmail.com> wrote:
>
> If mmap() fails it returns MAP_FAILED, which is defined as ((void *) -1).
> The current if-statement incorrectly tests if *ring is NULL.
>
> Signed-off-by: Frank de Brabander <debrabander@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Fixes: 358be656406d ("selftests/net: add txring_overwrite")

Thanks Frank. Please mark future networking patches as [PATCH net] or
[PATCH net-next].
