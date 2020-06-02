Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234801EB5FC
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgFBGt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:49:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25031 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725298AbgFBGtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 02:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591080594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bu0T+XX3zpxmrtUQpa6bWw9hSGRZ91a0waCrW1m0YCc=;
        b=bsFkyKFBFSxbOpAducEx1DO0Ob4weE+BOg+TOShFt0uNu+B2AQ0D1RV+lrNlkZLNlauvxf
        7fbdDv36Gi5zU/HLktPlVco87/m+WKR2ocQ3xLGW8W1EWxdCld5GdYBkP8PNIXJDHnJeRg
        Dt1PoYin6k27tylZIzbRFI0o5xY3Xlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-6RfTK8paN_-AGPhOM4Y3IA-1; Tue, 02 Jun 2020 02:49:51 -0400
X-MC-Unique: 6RfTK8paN_-AGPhOM4Y3IA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85DC064AD8;
        Tue,  2 Jun 2020 06:49:49 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27A4F5C1D6;
        Tue,  2 Jun 2020 06:49:40 +0000 (UTC)
Subject: Re: [PATCH 4/6] vhost_vdpa: support doorbell mapping via mmap
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com
References: <20200529080303.15449-5-jasowang@redhat.com>
 <202006020308.kLXTHt4n%lkp@intel.com>
 <20200602005007-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bd7dde11-b726-ee08-4e80-71fb784fa549@redhat.com>
Date:   Tue, 2 Jun 2020 14:49:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602005007-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/2 下午12:56, Michael S. Tsirkin wrote:
> On Tue, Jun 02, 2020 at 03:22:49AM +0800, kbuild test robot wrote:
>> Hi Jason,
>>
>> I love your patch! Yet something to improve:
>>
>> [auto build test ERROR on vhost/linux-next]
>> [also build test ERROR on linus/master v5.7 next-20200529]
>> [if your patch is applied to the wrong git tree, please drop us a note to help
>> improve the system. BTW, we also suggest to use '--base' option to specify the
>> base tree in git format-patch, please seehttps://stackoverflow.com/a/37406982]
>>
>> url:https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-doorbell-mapping/20200531-070834
>> base:https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git  linux-next
>> config: m68k-randconfig-r011-20200601 (attached as .config)
>> compiler: m68k-linux-gcc (GCC) 9.3.0
>> reproduce (this is a W=1 build):
>>          wgethttps://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # save the attached .config to linux build tree
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kbuild test robot<lkp@intel.com>
>>
>> All errors (new ones prefixed by >>, old ones prefixed by <<):
>>
>> drivers/vhost/vdpa.c: In function 'vhost_vdpa_fault':
>>>> drivers/vhost/vdpa.c:754:22: error: implicit declaration of function 'pgprot_noncached' [-Werror=implicit-function-declaration]
>> 754 |  vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> |                      ^~~~~~~~~~~~~~~~
>>>> drivers/vhost/vdpa.c:754:22: error: incompatible types when assigning to type 'pgprot_t' {aka 'struct <anonymous>'} from type 'int'
>> cc1: some warnings being treated as errors
>>
>> vim +/pgprot_noncached +754 drivers/vhost/vdpa.c
>>
>>     742	
>>     743	static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
>>     744	{
>>     745		struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
>>     746		struct vdpa_device *vdpa = v->vdpa;
>>     747		const struct vdpa_config_ops *ops = vdpa->config;
>>     748		struct vdpa_notification_area notify;
>>     749		struct vm_area_struct *vma = vmf->vma;
>>     750		u16 index = vma->vm_pgoff;
>>     751	
>>     752		notify = ops->get_vq_notification(vdpa, index);
>>     753	
>>   > 754		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>>     755		if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
>>     756				    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
>>     757				    vma->vm_page_prot))
>>     758			return VM_FAULT_SIGBUS;
>>     759	
>>     760		return VM_FAULT_NOPAGE;
>>     761	}
>>     762	
> Yes well, all this remapping clearly has no chance to work
> on systems without CONFIG_MMU.


It looks to me mmap can work according to Documentation/nommu-mmap.txt. 
But I'm not sure it's worth to bother.

Thanks


>
>
>

