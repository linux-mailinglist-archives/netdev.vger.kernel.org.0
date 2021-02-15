Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA3231B5C6
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 08:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhBOH6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 02:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhBOH6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 02:58:12 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF00C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 23:57:32 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id l8so6258139ybe.12
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 23:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xRrCe72/CdWUDvsr0RGVjqqpypb4q7lznYDnnHmF084=;
        b=pSjla5YF0Fa48dyQsvdyPViGCk2Av/8w1S6nwtudRE3Sff8FTGB6X8vly+vbNR+5Rq
         Ylf7cR/+rnGuaB2XmF63neNKn6yV+Pc4vNk55JF3emkhTet75M5hnLS7Z7xZZ9MiP27H
         1bvlmoIpc6NjbITEWaXIZgwvEn4CQ7Hxlj6LSt0J9+wpf77+hQ/a9vCzLpSnKdkG2VnB
         14qRT9xG38UXBypOqy4PEw4tOU1J/2OY+mvLRKSf2JjRQrzsvtYKokHA+A9o23sE9vCx
         Ydk+FDMyei6NfGovROfZArTyGYnf0xXcnxGrABuJyHJ06GIO2yWkw91Foqa+Ki74e/Va
         zh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xRrCe72/CdWUDvsr0RGVjqqpypb4q7lznYDnnHmF084=;
        b=bYHc2JlHI3mg85I9t4DTZtFE7ZaAmarEFuvcO+5qHpaR6ddZ605kjWfwXbu5nCAPVk
         d1uQ3z5di3tBj+/UhxrfE4N5AtfoHD8Jg8b94htoKsxZhWVRc/b2HYH7MBT+90uWDG5J
         OgB0YLus+bG0Gv39DXMMwIlINNrBYQ/J2RSPGAzptTEk6+c0I7yCK2CuMkC2O0/DQaUe
         RMt+K044pqha1dxr2fzBdT4r2WWmTYmqTPwCw9WkTFqpoWIIQ+KmlvmOLFoxKloVvfxG
         oXVv/fhiQjvUIRp3OSKDFeiYOpy74ZE/SWHvflUvBOy2XulHHnf4Aln82BoO460lsMqj
         CUKw==
X-Gm-Message-State: AOAM533vzXkzkZ4J8rnVHkFqpk3XrKGFyk/k1JROVRxKrcTrYWfiop2S
        tBBmxgHEUQe3nzH9r14yVpuQ7zyn9+h/BhGGqPo=
X-Google-Smtp-Source: ABdhPJz1O+cpV52RAzgq76H4yycwKHlcm4jQ0kMs+6/Bl50qjIETHfwy15kfD5sCrOOcALdHGM0RLc8EVGhcwcLR3JE=
X-Received: by 2002:a25:9383:: with SMTP id a3mr21111797ybm.215.1613375851909;
 Sun, 14 Feb 2021 23:57:31 -0800 (PST)
MIME-Version: 1.0
References: <20210211211044.32701-1-borisp@mellanox.com> <20210211211044.32701-7-borisp@mellanox.com>
 <2dd10b2f-df00-e21c-7886-93f41a987040@gmail.com>
In-Reply-To: <2dd10b2f-df00-e21c-7886-93f41a987040@gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Mon, 15 Feb 2021 09:57:20 +0200
Message-ID: <CAJ3xEMg3GWNVjkixVVop9uhn958Opdq4ej0qktA11NS6GM9s-g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 06/21] nvme-tcp: Add DDP offload control path
To:     David Ahern <dsahern@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        Yoray Zack <yorayz@mellanox.com>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        benishay@nvidia.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 8:20 PM David Ahern <dsahern@gmail.com> wrote:
> On 2/11/21 2:10 PM, Boris Pismenny wrote:
> > @@ -223,6 +229,164 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
> >       return nvme_tcp_pdu_data_left(req) <= len;
> >  }

Hi Dave,

Thanks for the continuous feedback. Folks are out this week and it seems
for that few comments we will need to discuss internally, but anyway I will
address at least  some of the comments later today/tomorrow.

Or.

Or.
