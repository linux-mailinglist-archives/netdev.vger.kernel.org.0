Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033D51D05B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 22:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfENUPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 16:15:10 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41097 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfENUPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 16:15:09 -0400
Received: by mail-lj1-f196.google.com with SMTP id k8so415251lja.8
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 13:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=evUJ73BNRpNMChjJ0udr79nRnFaauyNKnbrQ2DObhvY=;
        b=D6/iPMQbhzRS0aI7BTNFpNB4YoUJADt8Ti1/WfMtLQfUfXn5OafIHLBBhNXTlYZ1gz
         DYcNbg5JBhwVoZHLv0rcd7NyqRXROADjGWcRkBwpY9RhO78pKHNaqFdKzvAISH+G7hDs
         UJmfU0Iv/aFLQNAXyTg8RS7DJllIsw5rtKzme3fPWTpr5TCOhqM18ZPPWoDxCm8IHsv4
         W7CNYby0lDONJO+pCSibHDriKKBTjzJDNXumCGsVpG8PTygW8nPjXcLcst171WO+y+aO
         CKblkE1azP1KM65xkBWfPvyG+9SesG7RtNcvc/S3F/6DK0hAy9Xpyweh6Y1IOwh8iqG+
         wzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=evUJ73BNRpNMChjJ0udr79nRnFaauyNKnbrQ2DObhvY=;
        b=qgvZOKlImBw72wVVZ4XS6CnGX48A3tkhW+meot78KGUeTGloHf0ItHF2woo/YMc10+
         wDdGtajn+o+Nhvol2naH7GKNONz/U5H4cDo/43b2DHheiadG+khX8eEsTIsi8/bcn27p
         713Ua02BlHUMoyy7QCzTSJE68tHmZY41J49MZGm1z9eKZdeyQoCLoMRr+qHtR5vCdnn9
         coXIQKQ/6io7+r5RIHnD5Cy/JQMk7sZNkMdaA0+mvlWmXzrrT20Bc4YnZzW5aQadaEdI
         A3MEl/NbYHptXaZiR3kZPEJVh4P63vfU9XFRZC0kEN6OKYwSkAURUASsbrxcZcnPP+P8
         5v1w==
X-Gm-Message-State: APjAAAWOa8CV0pwcrz68gWcuFAqzE4duDOizYmvJ3r0u/ne1ihyBa8Q2
        75i4C2PPLFOFUB8FutO4OR1YwnUR2mLQ9SXEZjV77g==
X-Google-Smtp-Source: APXvYqwXW/RjbA2gJfiYMd/owlxSn2vSUQfsqIoqP/GB/V8/8cJJ06qIyvKsgMjoAY14AAb4sCv9JdUYXSYqoVCmXHc=
X-Received: by 2002:a2e:80d5:: with SMTP id r21mr6619410ljg.43.1557864907702;
 Tue, 14 May 2019 13:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190514114412.30604-1-leon@kernel.org> <20190514114412.30604-3-leon@kernel.org>
In-Reply-To: <20190514114412.30604-3-leon@kernel.org>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Tue, 14 May 2019 13:14:56 -0700
Message-ID: <CALzJLG8R-MMef5_y37p=dh4iOG2Bt7=AKNq+3+uTg5=cgbDRRg@mail.gmail.com>
Subject: Re: [PATCH mlx5-next 2/2] net/mlx5: Set completion EQs as shared resources
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 4:44 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Yishai Hadas <yishaih@mellanox.com>
>
> Mark completion EQs as shared resources so that they can be used by CQs
> with uid != 0.
>
> Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 +++
>  include/linux/mlx5/mlx5_ifc.h                | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>

Hi leon,

I see the patch is marked for mlx5-next,
As we spoke earlier, let's push this directly to rdma-next and skip
mlx5-next, we will need to reset the branch soon, so let's keep it
clean.

Thanks,
Saeed
