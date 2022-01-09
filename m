Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5EB488A58
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbiAIP4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 10:56:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231327AbiAIP4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 10:56:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641743765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J7V1ZXHLUPXbLKGQxjrSNZfe50jHyedl6dKQf1BF2XY=;
        b=EGktbMueKP0SVx1fWmMEbA42yVQtr7zCltyhkObZM2wNgMVVLezyxUmKuIWaE+b5e7KpBX
        veMTIB5qqKPKFZJmZABODsRHXnPjlySNn4mjaKhcoUnrS6S4KEwCexCZsFhATBpx8tpTcx
        Msn13Mgb9eDhfqyvV+hnez2ESFOUBqM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-ICzA_w0iNI6FW1ImuvUWDA-1; Sun, 09 Jan 2022 10:56:04 -0500
X-MC-Unique: ICzA_w0iNI6FW1ImuvUWDA-1
Received: by mail-wm1-f69.google.com with SMTP id s17-20020a7bc0d1000000b00348737ba2a2so905518wmh.2
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 07:56:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J7V1ZXHLUPXbLKGQxjrSNZfe50jHyedl6dKQf1BF2XY=;
        b=h5SXydvKBqxH3y4EoKWqtyPDTDeh5bKjSWWO25UBGSFOBkx25QhPNbjt6VydYUj6B1
         B42c/9Cb2meWbxCkOar7W1hVAeZbKKsZSLOjqFIs9Ud63RCTaG6T6yKtLgtXn0zdDcnW
         hJv+xUkPO9M1W8yIiOY63pKN+Rl/DvvlgJIcXauy4jV/+/Ta6il8i7w6DaqxGvutkDkG
         n/RQKdyHK7aIUzePXdGv+XglpT7QNj6NrbOf1ZxQ3GOMvAUPsG/CBN8B3TKgwhBPxYRX
         Luz9qzURxm4kqJ3p2oJByWF8er24U19CRizc/2gt7fR0WuHUsrdazEm+DMh2YsgDmK2F
         5+yw==
X-Gm-Message-State: AOAM532U3jsyvZhWxHzU2eR6JOI64IOvFjv+ocF3gLYwAnC4hd8pEstW
        G8FPQTWEaxiq1F7hS66SOBmJAoxpHIJAWQ72wiiHvOewgDIzme5CcDor38nJT0sPYpfYjWo97Ot
        i0rJNa5HpbQsalxPZ
X-Received: by 2002:a7b:c7da:: with SMTP id z26mr12392520wmk.52.1641743763212;
        Sun, 09 Jan 2022 07:56:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNEi79CRxQjFDs1Tr8AJ4vn/QoN3V9wwHj33+A6h0wLfeFHwE/3phbm0G7DptlIOkNkq64eA==
X-Received: by 2002:a7b:c7da:: with SMTP id z26mr12392505wmk.52.1641743762966;
        Sun, 09 Jan 2022 07:56:02 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107e:c07a:cd29:1c16:894b:6b07])
        by smtp.gmail.com with ESMTPSA id c8sm4697313wmq.34.2022.01.09.07.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 07:56:02 -0800 (PST)
Date:   Sun, 9 Jan 2022 10:55:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Eli Cohen <elic@nvidia.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [mst-vhost:vhost 30/44]
 drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast to
 restricted __le16
Message-ID: <20220109105546-mutt-send-email-mst@kernel.org>
References: <202201082258.aKRHnaJX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202201082258.aKRHnaJX-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 08, 2022 at 10:48:34PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> head:   008842b2060c14544ff452483ffd2241d145c7b2
> commit: 7620d51af29aa1c5d32150db2ac4b6187ef8af3a [30/44] vdpa/mlx5: Support configuring max data virtqueue
> config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220108/202201082258.aKRHnaJX-lkp@intel.com/config)
> compiler: powerpc-linux-gcc (GCC) 11.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=7620d51af29aa1c5d32150db2ac4b6187ef8af3a
>         git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>         git fetch --no-tags mst-vhost vhost
>         git checkout 7620d51af29aa1c5d32150db2ac4b6187ef8af3a
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/vdpa/mlx5/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> >> drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast to restricted __le16
> >> drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast from restricted __virtio16
> 
> vim +1247 drivers/vdpa/mlx5/net/mlx5_vnet.c

Eli? I sent a patch for this - ack?

>   1232	
>   1233	static int create_rqt(struct mlx5_vdpa_net *ndev)
>   1234	{
>   1235		__be32 *list;
>   1236		int max_rqt;
>   1237		void *rqtc;
>   1238		int inlen;
>   1239		void *in;
>   1240		int i, j;
>   1241		int err;
>   1242		int num;
>   1243	
>   1244		if (!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_MQ)))
>   1245			num = 1;
>   1246		else
> > 1247			num = le16_to_cpu(ndev->config.max_virtqueue_pairs);
>   1248	
>   1249		max_rqt = min_t(int, roundup_pow_of_two(num),
>   1250				1 << MLX5_CAP_GEN(ndev->mvdev.mdev, log_max_rqt_size));
>   1251		if (max_rqt < 1)
>   1252			return -EOPNOTSUPP;
>   1253	
>   1254		inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + max_rqt * MLX5_ST_SZ_BYTES(rq_num);
>   1255		in = kzalloc(inlen, GFP_KERNEL);
>   1256		if (!in)
>   1257			return -ENOMEM;
>   1258	
>   1259		MLX5_SET(create_rqt_in, in, uid, ndev->mvdev.res.uid);
>   1260		rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
>   1261	
>   1262		MLX5_SET(rqtc, rqtc, list_q_type, MLX5_RQTC_LIST_Q_TYPE_VIRTIO_NET_Q);
>   1263		MLX5_SET(rqtc, rqtc, rqt_max_size, max_rqt);
>   1264		list = MLX5_ADDR_OF(rqtc, rqtc, rq_num[0]);
>   1265		for (i = 0, j = 0; i < max_rqt; i++, j += 2)
>   1266			list[i] = cpu_to_be32(ndev->vqs[j % (2 * num)].virtq_id);
>   1267	
>   1268		MLX5_SET(rqtc, rqtc, rqt_actual_size, max_rqt);
>   1269		err = mlx5_vdpa_create_rqt(&ndev->mvdev, in, inlen, &ndev->res.rqtn);
>   1270		kfree(in);
>   1271		if (err)
>   1272			return err;
>   1273	
>   1274		return 0;
>   1275	}
>   1276	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

