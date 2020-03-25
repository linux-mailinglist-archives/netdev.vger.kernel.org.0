Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC835192255
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCYIPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 04:15:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54063 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgCYIPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585124140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hOKCgDt3MdkDi+eEQM/u9xHMiA/ynm2nLfPeOZVBaHM=;
        b=ZLK1rRclR6XIIVfsjaLJzrCwQ2C+O1qiovpYWBrEOHmgDuJl9pRNtzgZZTLHuFcE+3E08w
        VtDdn5dNc+5gSDfJEUH9OtKrxQPl5Z1o5OjvSchlJIIMX2m8dDZe1X4ty1wBvsxVw0cIF5
        N78bar4vnVL4aPQDxAfzH91nm6Hgzzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-dnKYzcUZNe-hkbmv6mqokg-1; Wed, 25 Mar 2020 04:15:35 -0400
X-MC-Unique: dnKYzcUZNe-hkbmv6mqokg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFAB418B5F6A;
        Wed, 25 Mar 2020 08:15:33 +0000 (UTC)
Received: from [10.72.14.13] (ovpn-14-13.pek2.redhat.com [10.72.14.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41FE65DA7B;
        Wed, 25 Mar 2020 08:15:21 +0000 (UTC)
Subject: Re: [PATCH V7 7/8] vdpasim: vDPA device simulator
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200324041458.27384-8-jasowang@redhat.com>
 <202003251045.ncVINn70%lkp@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <26bc89b3-8e29-db25-18fc-64e309951a94@redhat.com>
Date:   Wed, 25 Mar 2020 16:15:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <202003251045.ncVINn70%lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/25 =E4=B8=8A=E5=8D=8810:25, kbuild test robot wrote:
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on vhost/linux-next]
> [also build test ERROR on linux/master linus/master v5.6-rc7 next-20200=
324]
> [if your patch is applied to the wrong git tree, please drop us a note =
to help
> improve the system. BTW, we also suggest to use '--base' option to spec=
ify the
> base tree in git format-patch, please seehttps://stackoverflow.com/a/37=
406982]
>
> url:https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-support/20=
200324-142634
> base:https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git  lin=
ux-next
> config: m68k-allyesconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.2.0
> reproduce:
>          wgethttps://raw.githubusercontent.com/intel/lkp-tests/master/s=
bin/make.cross  -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          GCC_VERSION=3D9.2.0 make.cross ARCH=3Dm68k
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot<lkp@intel.com>
>
> All errors (new ones prefixed by >>):


This is because VDPA_SIM selects VHOST_RING which selects VHOST_IOTLB=20
which depends on VIRTULAIZATION but not defined in m68k.

I think we should refine the vhost Kconfig and decouple it out of=20
VIRTUALIZATION.

Will send a new series with this shortly.

Thanks

