Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7965E530D10
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiEWK1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiEWK1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:27:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 481AB45528
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653301624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PQk+7rW1KHrpPCrFUi3+ly+iMyDJ3LafNtMVWnd05zg=;
        b=egFx2XnNFbzxMDV0VZ/JVpiKsOk46adLDMS9n/42mnfAsvnJrWp70urbwQ6N3wRxhBdpGd
        JTNnwSHCw4VIzXcPeiWOIOch1/NM1bFR7u6SR8lP079CsbVGFzjdX1T+dkAjLDgYTJhIqY
        F5xdE0lUb7Nr27sKGKJ3anv+buHNomY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-a-vx9HYYPAC5a5eRDawdLw-1; Mon, 23 May 2022 06:27:03 -0400
X-MC-Unique: a-vx9HYYPAC5a5eRDawdLw-1
Received: by mail-qt1-f199.google.com with SMTP id a18-20020ac85b92000000b002f3c5e0a098so11209897qta.7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PQk+7rW1KHrpPCrFUi3+ly+iMyDJ3LafNtMVWnd05zg=;
        b=vKo7jpVg2Qr9UGZi1XIioeMVPKkYOTjpSki34WNw//jhXmSzrEEVur5MG4jzZIhLfp
         ZvocDYq2KlERmdTmYX/pYGlRqk/8NiDSSq5ef2eiB00mDt52Pc4a6nyzuRkE9K5sTH1s
         reG90//vUoENYcA6VsH5Fit3TEpPkN9sAX9gOtbYW3NouFLHQBnjA/F1+Hh55EmwirFq
         0HF3BMyGG2ILr/rp49nQWRMuMni0qRgKM5xp3US//aX4PWQxvCaoGIqPthk0gQGVR7Q8
         SuhU5ytDNfITO5BBQF6391RKmObUSJtzHjbD5Cp9VAhjYhIG3EbHN6nL+K+FKva/XpVw
         IhoQ==
X-Gm-Message-State: AOAM5322a69kH+U1nu2RX4DfPRjMhxy8hH6FV1fGcPlk0RMl6AyCT6Mz
        Khjq5/zIzM4gqtKL7uUrOfoON4GZUBoyuDNKVNINm+r53ef62rNhBri8GTNiRjmfQcC+jwYddEZ
        C7VHL2PojiUuzaIEa
X-Received: by 2002:a05:620a:11b6:b0:6a3:2569:7a4f with SMTP id c22-20020a05620a11b600b006a325697a4fmr13087724qkk.666.1653301621337;
        Mon, 23 May 2022 03:27:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAINHF+Idj85HABajS5ILYnCkCC1a6nQrZSRpJKsF7JdFMy26kOhPbKyOAkmAXQ/C5w4e8rQ==
X-Received: by 2002:a05:620a:11b6:b0:6a3:2569:7a4f with SMTP id c22-20020a05620a11b600b006a325697a4fmr13087711qkk.666.1653301621066;
        Mon, 23 May 2022 03:27:01 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id h15-20020a05620a10af00b0069fd57d435fsm4150081qkk.101.2022.05.23.03.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:27:00 -0700 (PDT)
Date:   Mon, 23 May 2022 12:26:54 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Gautam Dawar <gautam.dawar@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [mst-vhost:vhost 26/43] drivers/vhost/vdpa.c:1003:3-9: preceding
 lock on line 991 (fwd)
Message-ID: <20220523102654.dzcrab3u4mxftgtu@sgarzare-redhat>
References: <alpine.DEB.2.22.394.2205201835450.2929@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2205201835450.2929@hadrien>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 06:37:01PM +0200, Julia Lawall wrote:
>Please check whether an unlock is needed before line 1003.

Yep, I think so. Same also for line 1016.

I just saw that there is already a patch posted to solve this problem:
https://lore.kernel.org/netdev/89ef0ae4c26ac3cfa440c71e97e392dcb328ac1b.1653227924.git.christophe.jaillet@wanadoo.fr/

Thanks for the report,
Stefano

>
>julia
>
>---------- Forwarded message ----------
>Date: Fri, 20 May 2022 17:35:29 +0800
>From: kernel test robot <lkp@intel.com>
>To: kbuild@lists.01.org
>Cc: lkp@intel.com, Julia Lawall <julia.lawall@lip6.fr>
>Subject: [mst-vhost:vhost 26/43] drivers/vhost/vdpa.c:1003:3-9: preceding lock
>    on line 991
>
>CC: kbuild-all@lists.01.org
>BCC: lkp@intel.com
>CC: kvm@vger.kernel.org
>CC: virtualization@lists.linux-foundation.org
>CC: netdev@vger.kernel.org
>TO: Gautam Dawar <gautam.dawar@xilinx.com>
>CC: "Michael S. Tsirkin" <mst@redhat.com>
>CC: Jason Wang <jasowang@redhat.com>
>
>tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
>head:   73211bf1bc3ac0a3c544225e270401c1fe5d395d
>commit: a1468175bb17ca5e477147de5d886e7a22d93527 [26/43] vhost-vdpa: support ASID based IOTLB API
>:::::: branch date: 10 hours ago
>:::::: commit date: 10 hours ago
>config: arc-allmodconfig (https://download.01.org/0day-ci/archive/20220520/202205201721.rGqusahl-lkp@intel.com/config)
>compiler: arceb-elf-gcc (GCC) 11.3.0
>
>If you fix the issue, kindly add following tag as appropriate
>Reported-by: kernel test robot <lkp@intel.com>
>Reported-by: Julia Lawall <julia.lawall@lip6.fr>
>
>
>cocci warnings: (new ones prefixed by >>)
>>> drivers/vhost/vdpa.c:1003:3-9: preceding lock on line 991
>   drivers/vhost/vdpa.c:1016:2-8: preceding lock on line 991
>
>vim +1003 drivers/vhost/vdpa.c
>
>4c8cf31885f69e Tiwei Bie    2020-03-26   980
>0f05062453fb51 Gautam Dawar 2022-03-30   981  static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>4c8cf31885f69e Tiwei Bie    2020-03-26   982  					struct vhost_iotlb_msg *msg)
>4c8cf31885f69e Tiwei Bie    2020-03-26   983  {
>4c8cf31885f69e Tiwei Bie    2020-03-26   984  	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>25abc060d28213 Jason Wang   2020-08-04   985  	struct vdpa_device *vdpa = v->vdpa;
>25abc060d28213 Jason Wang   2020-08-04   986  	const struct vdpa_config_ops *ops = vdpa->config;
>a1468175bb17ca Gautam Dawar 2022-03-30   987  	struct vhost_iotlb *iotlb = NULL;
>a1468175bb17ca Gautam Dawar 2022-03-30   988  	struct vhost_vdpa_as *as = NULL;
>4c8cf31885f69e Tiwei Bie    2020-03-26   989  	int r = 0;
>4c8cf31885f69e Tiwei Bie    2020-03-26   990
>a9d064524fc3cf Xie Yongji   2021-04-12  @991  	mutex_lock(&dev->mutex);
>a9d064524fc3cf Xie Yongji   2021-04-12   992
>4c8cf31885f69e Tiwei Bie    2020-03-26   993  	r = vhost_dev_check_owner(dev);
>4c8cf31885f69e Tiwei Bie    2020-03-26   994  	if (r)
>a9d064524fc3cf Xie Yongji   2021-04-12   995  		goto unlock;
>4c8cf31885f69e Tiwei Bie    2020-03-26   996
>a1468175bb17ca Gautam Dawar 2022-03-30   997  	if (msg->type == VHOST_IOTLB_UPDATE ||
>a1468175bb17ca Gautam Dawar 2022-03-30   998  	    msg->type == VHOST_IOTLB_BATCH_BEGIN) {
>a1468175bb17ca Gautam Dawar 2022-03-30   999  		as = vhost_vdpa_find_alloc_as(v, asid);
>a1468175bb17ca Gautam Dawar 2022-03-30  1000  		if (!as) {
>a1468175bb17ca Gautam Dawar 2022-03-30  1001  			dev_err(&v->dev, "can't find and alloc asid %d\n",
>a1468175bb17ca Gautam Dawar 2022-03-30  1002  				asid);
>a1468175bb17ca Gautam Dawar 2022-03-30 @1003  			return -EINVAL;
>a1468175bb17ca Gautam Dawar 2022-03-30  1004  		}
>a1468175bb17ca Gautam Dawar 2022-03-30  1005  		iotlb = &as->iotlb;
>a1468175bb17ca Gautam Dawar 2022-03-30  1006  	} else
>a1468175bb17ca Gautam Dawar 2022-03-30  1007  		iotlb = asid_to_iotlb(v, asid);
>a1468175bb17ca Gautam Dawar 2022-03-30  1008
>a1468175bb17ca Gautam Dawar 2022-03-30  1009  	if ((v->in_batch && v->batch_asid != asid) || !iotlb) {
>a1468175bb17ca Gautam Dawar 2022-03-30  1010  		if (v->in_batch 
>&& v->batch_asid != asid) {
>a1468175bb17ca Gautam Dawar 2022-03-30  1011  			dev_info(&v->dev, "batch id %d asid %d\n",
>a1468175bb17ca Gautam Dawar 2022-03-30  1012  				 v->batch_asid, asid);
>a1468175bb17ca Gautam Dawar 2022-03-30  1013  		}
>a1468175bb17ca Gautam Dawar 2022-03-30  1014  		if (!iotlb)
>a1468175bb17ca Gautam Dawar 2022-03-30  1015  			dev_err(&v->dev, "no iotlb for asid %d\n", asid);
>a1468175bb17ca Gautam Dawar 2022-03-30  1016  		return -EINVAL;
>a1468175bb17ca Gautam Dawar 2022-03-30  1017  	}
>a1468175bb17ca Gautam Dawar 2022-03-30  1018
>4c8cf31885f69e Tiwei Bie    2020-03-26  1019  	switch (msg->type) {
>4c8cf31885f69e Tiwei Bie    2020-03-26  1020  	case VHOST_IOTLB_UPDATE:
>3111cb7283065a Gautam Dawar 2022-03-30  1021  		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
>4c8cf31885f69e Tiwei Bie    2020-03-26  1022  		break;
>4c8cf31885f69e Tiwei Bie    2020-03-26  1023  	case VHOST_IOTLB_INVALIDATE:
>3111cb7283065a Gautam Dawar 2022-03-30  1024  		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
>4c8cf31885f69e Tiwei Bie    2020-03-26  1025  		break;
>25abc060d28213 Jason Wang   2020-08-04  1026  	case VHOST_IOTLB_BATCH_BEGIN:
>a1468175bb17ca Gautam Dawar 2022-03-30  1027  		v->batch_asid = asid;
>25abc060d28213 Jason Wang   2020-08-04  1028  		v->in_batch = true;
>25abc060d28213 Jason Wang   2020-08-04  1029  		break;
>25abc060d28213 Jason Wang   2020-08-04  1030  	case VHOST_IOTLB_BATCH_END:
>25abc060d28213 Jason Wang   2020-08-04  1031  		if (v->in_batch && ops->set_map)
>a1468175bb17ca Gautam Dawar 2022-03-30  1032  			ops->set_map(vdpa, asid, iotlb);
>25abc060d28213 Jason Wang   2020-08-04  1033  		v->in_batch = false;
>a1468175bb17ca Gautam Dawar 2022-03-30  1034  		if (!iotlb->nmaps)
>a1468175bb17ca Gautam Dawar 2022-03-30  1035  			vhost_vdpa_remove_as(v, asid);
>25abc060d28213 Jason Wang   2020-08-04  1036  		break;
>4c8cf31885f69e Tiwei Bie    2020-03-26  1037  	default:
>4c8cf31885f69e Tiwei Bie    2020-03-26  1038  		r = -EINVAL;
>4c8cf31885f69e Tiwei Bie    2020-03-26  1039  		break;
>4c8cf31885f69e Tiwei Bie    2020-03-26  1040  	}
>a9d064524fc3cf Xie Yongji   2021-04-12  1041  unlock:
>a9d064524fc3cf Xie Yongji   2021-04-12  1042  	mutex_unlock(&dev->mutex);
>4c8cf31885f69e Tiwei Bie    2020-03-26  1043
>4c8cf31885f69e Tiwei Bie    2020-03-26  1044  	return r;
>4c8cf31885f69e Tiwei Bie    2020-03-26  1045  }
>4c8cf31885f69e Tiwei Bie    2020-03-26  1046
>
>-- 
>0-DAY CI Kernel Test Service
>https://01.org/lkp
>

