Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297007C823
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfGaQGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:06:01 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42216 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 12:06:01 -0400
Received: by mail-yw1-f66.google.com with SMTP id z63so25160574ywz.9
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 09:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fRRqwkpcI53teRjcOkCo/u4yNvkJ3n0LBJJNlhIbQKs=;
        b=P3jTJ/Wx48996sLijiWGaUjfbi/B/kCcMzSSuKiU019fryrueyi8hgODOU+xLAoy0D
         YQuL9F5OvtJm02BhWy+w5navYIeYstp6V+l18UOO4aB0iuPJVD8hoc1sdrUaaXNrVgzc
         l9FV0Crx/OlP6BgCeJ5WZE++YYZ+QxuE/3OrVPToJn+iWQ5xMOoBtgE3wSwPjhBVDAgI
         NWPOP6y79ZJQMEdsY8hRAhzfQre2pvIbGGOi5olgXBuZT/X/Uou24Ex7ed8K9L/93tyM
         FA8qMaXy7Qlzn4jwO+mKuZwufKiCeFOzc0wbauHUDOyuMz1Wsf4k25gf/Yl2DsG9jutU
         h/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fRRqwkpcI53teRjcOkCo/u4yNvkJ3n0LBJJNlhIbQKs=;
        b=V4cJwE8/gef5Ciy8U0EoP8Ym+pG7IjGKyxBAVoCgSn8mrc9xgF/V9jJJD3IxsC6Um9
         UFYZNVIkMGRoFxg0SSUUIRe1vZ+8ux6Fkm7hfwnErCQuKOBn4xsoobzxq9AJ+an60GGK
         jqmk6yhDFpuiAjqBnWJvuqaXoyADYETSTU73d5Rf5OPt3XNmCjOi2C8dYGghG0m2T4D0
         0eYrjQ6/R74B7LaW+O9M0czaPzmyuVg1s+7JjrlAPNSyrI9jkeNFtRjFnDuiQr47Kk4M
         l2ObiGQo9k5j5TS/7xRWl5u/6zmM9SmbW/Himvyri4Ohcj0hVOjrep0NBpRJz+/tSaWE
         u3Qw==
X-Gm-Message-State: APjAAAWDBep4i4ncvKiPnBSNKc02e92kaX/7J3AxzFn870NRWoCrg0wd
        DfQUTOjE8zU9e5OA0JyMGQyp5eUD
X-Google-Smtp-Source: APXvYqyVO1+UKk3HucxaYF3kFFSB9R3X9aoUqXGDiZ00UnSpo5iuWs3Du7MYEHFSsZ+jkMXImWblLw==
X-Received: by 2002:a81:4f8f:: with SMTP id d137mr75743911ywb.122.1564589159510;
        Wed, 31 Jul 2019 09:05:59 -0700 (PDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id s188sm15606045ywd.7.2019.07.31.09.05.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:05:58 -0700 (PDT)
Received: by mail-yw1-f52.google.com with SMTP id g19so24520911ywe.2
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 09:05:58 -0700 (PDT)
X-Received: by 2002:a0d:cc48:: with SMTP id o69mr70364492ywd.389.1564589158227;
 Wed, 31 Jul 2019 09:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190731122203.948-1-hslester96@gmail.com>
In-Reply-To: <20190731122203.948-1-hslester96@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 31 Jul 2019 12:05:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTScqD4bMpm6n13ETFVEvSKnk_rRUzspzs9HB6B5Un101Dw@mail.gmail.com>
Message-ID: <CA+FuTScqD4bMpm6n13ETFVEvSKnk_rRUzspzs9HB6B5Un101Dw@mail.gmail.com>
Subject: Re: [PATCH 1/2] bnxt_en: Use refcount_t for refcount
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 8:22 AM Chuhong Yuan <hslester96@gmail.com> wrote:
>
> refcount_t is better for reference counters since its
> implementation can prevent overflows.
> So convert atomic_t ref counters to refcount_t.
>
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 8 ++++----
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> index fc77caf0a076..eb7ed34639e2 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> @@ -49,7 +49,7 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
>                         return -ENOMEM;
>         }
>
> -       atomic_set(&ulp->ref_count, 0);
> +       refcount_set(&ulp->ref_count, 0);

One feature of refcount_t is that it warns on refcount_inc from 0 to
detect possible use-after_free. It appears that that can trigger here?

>         ulp->handle = handle;
>         rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
>
> @@ -246,12 +246,12 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
>
>  static void bnxt_ulp_get(struct bnxt_ulp *ulp)
>  {
> -       atomic_inc(&ulp->ref_count);
> +       refcount_inc(&ulp->ref_count);
>  }
