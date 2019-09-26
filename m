Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE95BED26
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbfIZIMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:12:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbfIZIMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 04:12:53 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDECB10DCC92;
        Thu, 26 Sep 2019 08:12:51 +0000 (UTC)
Received: from [10.72.12.101] (ovpn-12-101.pek2.redhat.com [10.72.12.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5601D60C80;
        Thu, 26 Sep 2019 08:12:23 +0000 (UTC)
Subject: Re: [PATCH V2 6/8] mdev: introduce virtio device and its device ops
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Cc:     "christophe.de.dinechin@gmail.com" <christophe.de.dinechin@gmail.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "idos@mellanox.com" <idos@mellanox.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
References: <20190924135332.14160-1-jasowang@redhat.com>
 <20190924135332.14160-7-jasowang@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F7DA@SHSMSX104.ccr.corp.intel.com>
 <2210d23d-38e4-e654-e53d-7867348de86a@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D590FE4@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6ba16bf8-8e8a-343a-335d-ab77d7cda195@redhat.com>
Date:   Thu, 26 Sep 2019 16:12:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D590FE4@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 26 Sep 2019 08:12:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/26 上午8:48, Tian, Kevin wrote:
>>>> +};
>>> I'm not sure how stable above ops are.
>> It's the kernel internal API, so there's no strict requirement for this.
>> We will export a version value for userspace for compatibility.
>>
>>
>>> Does it make sense if defining
>>> just two callbacks here, e.g. vq_ctrl and device_ctrl, and then let the
>>> vendor driver to handle specific ops in each category (similar to how
>>> ioctl works)?
>> My understanding is that it introduce another indirection, you still
>> need to differ from different command, and it's less flexible than
>> direct callback.
>>
>> What's the value of doing this?
>>
> I just thought doing so may provide better compatibility to the
> parent driver. Even when new op is introduced, a parent driver
> that was developed against the old set can still be loaded in the
> new kernel. It just returns error when unrecognized ops are
> routed through vq_ctrl and device_ctrl, if the userspace doesn't
> favor the exposed version value. But if above ops set is pretty
> stable, then this comment can be ignored.


This is really good point, we should keep it stable as a real transport. 
And when there's major changes, we should advertise through version then 
we can provide a new set of functions.

Thanks


>
> Thanks
> Kevin
