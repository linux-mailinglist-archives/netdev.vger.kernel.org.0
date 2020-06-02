Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED691EB4C7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 06:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgFBE50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 00:57:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55317 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726260AbgFBE5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 00:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591073842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gchTFiwviKMDwZXWqMwug6HrHP15DUCH03zQ9j5rpHE=;
        b=h4aCWA5qKx+pDzn/2TRzQ+7mrIR88SOCz+W7NSasr0xx3PB04ad4Wj4h6Mz9sCZ0r6p4wr
        kqxo2QvIgs6V/niea5WXXOC2W98DOZJTvm12anJqF4UyJUAFEQzi5bYGVHHwUbV4ioN5AI
        pNE300h+sbj7njvBXfQc+Ot3rbdhAyY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-WuhR1PH9OFaJ79_1VIdtaQ-1; Tue, 02 Jun 2020 00:57:00 -0400
X-MC-Unique: WuhR1PH9OFaJ79_1VIdtaQ-1
Received: by mail-wr1-f72.google.com with SMTP id d6so879723wrn.1
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 21:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gchTFiwviKMDwZXWqMwug6HrHP15DUCH03zQ9j5rpHE=;
        b=mk4oaqNdYd6VFoCpZvtnap+4DNNu2nlOihxEIdp8Z/xZQIehumcPsIT+tiVq0Ytqjb
         LzEIhhbPxYXt8MHJnuXfIJMuxGoX5EhWsGdlmFe+E6MUaTbSRMqyA8dY3w1+4ZQj+NUk
         jLmKOj3ZhU61KdgnMyiuqxb9nW5AkUh7UEd+8gWYt7TlgGTfwdzsrQLKOPzjnZObNRU6
         EkPvsK4g6vvQigcj+eWfGs/gGppVUGm/l2gVKhYpp0i52CxtskAbdHUGdHc0psBCd668
         nSqZ/HEt9W069d1/qzFOuTTofR0ct0mSQcA8bwX5oE1kfWYS4vhyD8oDDXcTIUPi0iO+
         K5UQ==
X-Gm-Message-State: AOAM530j8LQF8YR9dn2KC58+83XT+XkBrTXfOeR0RrP1R8nH9v9A1QeA
        Uyy0otMoq9F8g5fWjjuqkuW4qrBHqKUh7olgapkIzpp2S9ukrs4jrgrJ92E1pbDGuBUfszMw8vk
        3Pv4UJrG/unt4aFRr
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr2320509wmh.8.1591073818233;
        Mon, 01 Jun 2020 21:56:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwezYypzZbKEY1d6YwmBv/8PZj3UfnzO1aXl2q6kGlCaJNGq8F3H+NRcEoRO1KXyF9lWjuqqA==
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr2320484wmh.8.1591073818026;
        Mon, 01 Jun 2020 21:56:58 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id x205sm1900586wmx.21.2020.06.01.21.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 21:56:57 -0700 (PDT)
Date:   Tue, 2 Jun 2020 00:56:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com
Subject: Re: [PATCH 4/6] vhost_vdpa: support doorbell mapping via mmap
Message-ID: <20200602005007-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-5-jasowang@redhat.com>
 <202006020308.kLXTHt4n%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006020308.kLXTHt4n%lkp@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 03:22:49AM +0800, kbuild test robot wrote:
> Hi Jason,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on vhost/linux-next]
> [also build test ERROR on linus/master v5.7 next-20200529]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-doorbell-mapping/20200531-070834
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> config: m68k-randconfig-r011-20200601 (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> drivers/vhost/vdpa.c: In function 'vhost_vdpa_fault':
> >> drivers/vhost/vdpa.c:754:22: error: implicit declaration of function 'pgprot_noncached' [-Werror=implicit-function-declaration]
> 754 |  vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> |                      ^~~~~~~~~~~~~~~~
> >> drivers/vhost/vdpa.c:754:22: error: incompatible types when assigning to type 'pgprot_t' {aka 'struct <anonymous>'} from type 'int'
> cc1: some warnings being treated as errors
> 
> vim +/pgprot_noncached +754 drivers/vhost/vdpa.c
> 
>    742	
>    743	static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
>    744	{
>    745		struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
>    746		struct vdpa_device *vdpa = v->vdpa;
>    747		const struct vdpa_config_ops *ops = vdpa->config;
>    748		struct vdpa_notification_area notify;
>    749		struct vm_area_struct *vma = vmf->vma;
>    750		u16 index = vma->vm_pgoff;
>    751	
>    752		notify = ops->get_vq_notification(vdpa, index);
>    753	
>  > 754		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>    755		if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
>    756				    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
>    757				    vma->vm_page_prot))
>    758			return VM_FAULT_SIGBUS;
>    759	
>    760		return VM_FAULT_NOPAGE;
>    761	}
>    762	

Yes well, all this remapping clearly has no chance to work
on systems without CONFIG_MMU.



> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


