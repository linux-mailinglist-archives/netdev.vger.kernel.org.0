Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9A12A7166
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733015AbgKDXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733001AbgKDXVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:21:36 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB96EC0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:21:35 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so299719ejb.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 15:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IkxbaeAsRvfPNMaiW0gFtiCQOBmoS4GNd3nY4Wwz8Hk=;
        b=nbBwJZMY+xrKg6w6NoyyZ8wH6PRrpWDJMwjQmqe2WQUKuJO5hUA4CVT37Q2bT3zk6M
         XXGYTpqF1YDiy5XaStqn2/wwlKmEE4KiWnngd9Hg4pwEnL3nDkVgzYAWjotLvVSgC8RI
         OHRURM5VZ+ERQIF6Zw6htdalcHKNqqZ5XS6xWz/S3YRSMU2iC+YP3iut1T2hy68jS+YE
         L1nTzHri580AMi64MfXaRmO1YeFLTfHm4V1xZh5k6V5MQdopCu5nARpraa1dfQ7trQzf
         +6RvDh4gvwQHvyG3b9jdZ9wWt+STGKccdgYSKelxfhKJOayGBw+tSbjtTiFw+2KIRg8M
         qiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IkxbaeAsRvfPNMaiW0gFtiCQOBmoS4GNd3nY4Wwz8Hk=;
        b=O/YdJJ3omoaQZ31qcwWIUCBCiXcnQKqMPwyQdUzXXPDnidaxKLUdrgzEw7JwqODKKd
         PUqFFshlACuB/sCfb4YvAec/TIXkMZjsZ8c9pmp4vjxgWb7jZeOk3F0qVvc5SLc4sf6o
         mI8jIxsMTx5eacJGQ6Eu7rtTOyxN+2XD8pZq7PpxR9fQwwrsxZr6u209lNVzgjhTz4Ze
         JvNVn2LPEp6Zv0aou0KwcgJl71Eo+NUXSuRyHHozEolgfSLbwiIoookLaRMFROtyCY8x
         jbINPiaL8L3cFzIivF8gl2Wl6sYaIpOfY78Yz6YRHsk5Z7bEM16FI363UEoNiGJ0yJ7A
         r7eA==
X-Gm-Message-State: AOAM5300Fwf826SlDSntg6VU/VBr7GHVN2mqFwHpCJsCJO1kB4L0hJMh
        0sp+hoJGHNeNL8KcL4yNSH7yeQu12fi4Io3UTEThwiY9YDY=
X-Google-Smtp-Source: ABdhPJxvb/hNG9Gu9hrl82xWn1tmJIgoueWGEVMCGBlWcYM3JxH/JkmRoeh47/b7BtcC3eHP9KumYl6m1HGAoVQj2Mk=
X-Received: by 2002:a17:906:d92c:: with SMTP id rn12mr427071ejb.472.1604532094560;
 Wed, 04 Nov 2020 15:21:34 -0800 (PST)
MIME-Version: 1.0
References: <20201101201542.2027568-1-leon@kernel.org> <20201101201542.2027568-7-leon@kernel.org>
 <20201103154525.GO36674@ziepe.ca>
In-Reply-To: <20201103154525.GO36674@ziepe.ca>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 4 Nov 2020 15:21:23 -0800
Message-ID: <CAPcyv4jP9nFAGdvB7agg3x7Y7moHGcxLd5=f5=5CXnJRUf3n9w@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 06/11] vdpa/mlx5: Connect mlx5_vdpa to
 auxiliary bus
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Netdev <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David M Ertman <david.m.ertman@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 7:45 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
[..]
> > +MODULE_DEVICE_TABLE(auxiliary, mlx5v_id_table);
> > +
> > +static struct auxiliary_driver mlx5v_driver = {
> > +     .name = "vnet",
> > +     .probe = mlx5v_probe,
> > +     .remove = mlx5v_remove,
> > +     .id_table = mlx5v_id_table,
> > +};
>
> It is hard to see from the diff, but when this patch is applied the
> vdpa module looks like I imagined things would look with the auxiliary
> bus. It is very similar in structure to a PCI driver with the probe()
> function cleanly registering with its subsystem. This is what I'd like
> to see from the new Intel RDMA driver.
>
> Greg, I think this patch is the best clean usage example.
>
> I've looked over this series and it has the right idea and
> parts. There is definitely more that can be done to improve mlx5 in
> this area, but this series is well scoped and cleans a good part of
> it.

Greg?

I know you alluded to going your own way if the auxiliary bus patches
did not shape up soon, but it seems they have and the stakeholders
have reached this consensus point.

Were there any additional changes you wanted to see happen? I'll go
give the final set another once over, but David has been diligently
fixing up all the declared major issues so I expect to find at most
minor incremental fixups.
