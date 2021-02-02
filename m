Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F206930C942
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbhBBSNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238023AbhBBSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:10:43 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C2AC06178A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 10:10:02 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id c3so10910838ybi.3
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 10:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWQWMpQ1iUqXAuM6iMemQjw0YP2w3Y/0NiHfP2vB73w=;
        b=iJ/dTbF2EfUN5aP/5P9akEpw53P46bf+KKTWPVYy3Cjx87R0uaTD2eMXEi+riPIbRy
         rt5CBWMMe+b8G3QNw8G3mtVBLcXUyw+qZDni7MQqBqJJAZyatmg+W2ATO32+AB/z7RJs
         znFup8ui+7FrskxnUgTRLTE4Q47ZI2fQXHN0hY3qtZ05X/pT5gPr8ZcHpuZQGnz/XK96
         aQBW9y2aSAG6j+yy4YpPI7wMbEJS3S1NIOmiX3oehp5GKfIcIvRlxu0TPROj2xPTQjtO
         Z5xQXz/S9KjOVxHkzDYLnx+AdHHgkaxIH4FalcfwF/v9zcLl7rsyYkhwnd9UtljoGdsk
         OC+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWQWMpQ1iUqXAuM6iMemQjw0YP2w3Y/0NiHfP2vB73w=;
        b=gluU/uNclUOuaQIvXRXCMTXZC2rebM/gStAPGs84OdvieGtkLyupNfVHNBF0yoyOWU
         DmlQ0Srgen3PvQexmRN/oh77Rkx2Bxq9fzkakZ/HpdlWh7XtZYNF4dYs0qQK65enhgz1
         TXxzz/UJWQWAJmJEVyH/mslGhVBgRi0qHO3fsyCjbA/eUh2yji4dEko2K+CeeX3t9Gpc
         rY87tcpnmiR6kQ3UytAdAMDS8he5mCDn4jKZGv8WGcuotLSXdK+xdKsCu02v58VGiV+r
         KmL76YUC1qyDwegSNihVnm8Ow3We8tCo6wFUxZ5eK2CsA680UUjAfJlsYMM4yysIDVOB
         Pg0g==
X-Gm-Message-State: AOAM533K8qgq+KFy+jRkI1vlNg1dptjMuu963M4sVANq+36vXaaGeX++
        MhsCT5Lb18nYRAdlj7itDG/EFJm6728lz8GEio4=
X-Google-Smtp-Source: ABdhPJzcYBuKOmQdKrYJHwMIJBFsgUdt4Xgpb2L7VEOt4yzfgzVPHSpPjSNyPDdHccYL8mGIYqRfgijbhNb66bBEq6c=
X-Received: by 2002:a25:858e:: with SMTP id x14mr34144460ybk.257.1612289401908;
 Tue, 02 Feb 2021 10:10:01 -0800 (PST)
MIME-Version: 1.0
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-7-borisp@mellanox.com>
 <20210201173719.GB12960@lst.de>
In-Reply-To: <20210201173719.GB12960@lst.de>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 2 Feb 2021 20:09:50 +0200
Message-ID: <CAJ3xEMgnWKFkN3EOksLeqRMS+Ku-8oxOqwt1COkYwq5i1UYyJg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 06/21] nvme-tcp: Add DDP offload control path
To:     Christoph Hellwig <hch@lst.de>
Cc:     Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        Sagi Grimberg <sagi@grimberg.me>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        axboe@fb.com, Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 7:39 PM Christoph Hellwig <hch@lst.de> wrote:
>> +static
>> +int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>
> Please use the same coding style as the rest of the file, and not some
> weirdo version.

ack
