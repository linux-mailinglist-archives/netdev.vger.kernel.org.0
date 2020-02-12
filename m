Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C16515A1E1
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 08:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgBLHZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 02:25:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36941 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbgBLHZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 02:25:01 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so876629wru.4
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 23:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6q5CBZnT2fqK6UKnMzQpy65VqZFiKnaX8ZDZ2ozdm3o=;
        b=gtWr3yAn5TLHnEjy3xEpdfT/ik5MIvrrZo825UHo7D4fRgyZL/SEDQPVF0utfcSNDz
         XzTDpSDgh4FLDpwRZkVk12WnA5KonQA1Cy0n2DiZYL8WQb965keQJRgN4xkv9+MuAxon
         re/zNrWeIHC6bqMYg0Z6tKWgUpHg6MlubNV3hXYFgZVbFkMme/6xZXlv8ZDPeEzcBDyB
         VBjLBGFk5tjWlqC64u1oLmWYQZ6rqiZS6G0hmtGOw0iuhxrxosB2SUhhKm4LqpOef+5Q
         wb1AemNYJ+ZnqVZZRW7OEk3PABWMJii8BD68rmLusvvlMOlW7jW0pgylDKFQAwr4uo8J
         uaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6q5CBZnT2fqK6UKnMzQpy65VqZFiKnaX8ZDZ2ozdm3o=;
        b=NMnqlKsjbZqRpoS/svdhbxfg50/IBklXV9dd9F0YcWaCI7Jtdl4j1f9QUub8gOVMJj
         RGceaUwR3NFD9Dcv1ZX1WIGw6WKc4o6RhSciEun47DGbRyIgy2vilDhetMXq5NpAkkcr
         P6k28/fPI5JmkeTv4nwCxmH+efBHzYp32ywWAE10lscYPvp7Pk5ah8nZXi0R4cHGQnOh
         mT3ewsOpZMgEufe3Gs56o0+CykPzwRsuEK9TLxyySjaXO8IKSTRGqraNYM9OOZ/EfS2C
         DOMAvInJ6GTD10fgS68lk0jOlNGaRUAYUTF2CpJMrSs5vb7zjlFLNLheDiUKO93E6G0K
         UWVQ==
X-Gm-Message-State: APjAAAUMQ6EuLBbaxKHzxD7Ir8Dsagy/ciECxIzIHcs7xgoeBk4af2tp
        ORnHJRx9SABFg3FEWVv3kNIVZQ==
X-Google-Smtp-Source: APXvYqxrPPLRwafrUoEY5MzUjd3nW28m3SUN1B0r6ZvN8w4UtYlOOICU7qGXFEyBl06oPcD2EEiNaA==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr14388125wrh.371.1581492295752;
        Tue, 11 Feb 2020 23:24:55 -0800 (PST)
Received: from localhost (ip-89-177-128-209.net.upcbroadband.cz. [89.177.128.209])
        by smtp.gmail.com with ESMTPSA id l132sm7421525wmf.16.2020.02.11.23.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 23:24:55 -0800 (PST)
Date:   Wed, 12 Feb 2020 08:24:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: objagg: Replace zero-length arrays with
 flexible-array member
Message-ID: <20200212072454.GA22610@nanopsycho>
References: <20200211205356.GA23101@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211205356.GA23101@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 11, 2020 at 09:53:56PM CET, gustavo@embeddedor.com wrote:
>The current codebase makes use of the zero-length array language
>extension to the C90 standard, but the preferred mechanism to declare
>variable-length types such as these ones is a flexible array member[1][2],
>introduced in C99:
>
>struct foo {
>        int stuff;
>        struct boo array[];
>};
>
>By making use of the mechanism above, we will get a compiler warning
>in case the flexible array does not occur last in the structure, which
>will help us prevent some kind of undefined behavior bugs from being
>inadvertenly introduced[3] to the codebase from now on.
>
>This issue was found with the help of Coccinelle.
>
>[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>[2] https://github.com/KSPP/linux/issues/21
>[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
>Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
