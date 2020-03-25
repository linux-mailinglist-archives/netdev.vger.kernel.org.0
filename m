Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647C0191F97
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCYDOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:14:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:48090 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727262AbgCYDOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 23:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585106054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tlnvEiI040ACQ537mohs9KaGt5WE1E8quEggSdqcSkQ=;
        b=hMYo7AsFHTdsoGyeiDLi2aFT9wx2ExtrQYlAeLr/sCMXa8kfHpkDRpfEEn0mj9twl1cEAC
        t4gPeOaPRF17d7cp386bmIEHh9RhkcCErC8ZbG9fytdq7HaMT1AFhSkDSzXeTs+r4L29KL
        pSBAKha3fxW20S8A830UcwqbTatZTqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-arsdJjnLP0upUxzGWPsajQ-1; Tue, 24 Mar 2020 23:14:02 -0400
X-MC-Unique: arsdJjnLP0upUxzGWPsajQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 509FE100550D;
        Wed, 25 Mar 2020 03:14:01 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44E028AC30;
        Wed, 25 Mar 2020 03:13:55 +0000 (UTC)
Subject: Re: [PATCH V7 3/8] vringh: IOTLB support
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200324041458.27384-4-jasowang@redhat.com>
 <202003250217.stptJTnJ%lkp@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4032c9a2-a6c1-a041-fd59-81a8bf2fca46@redhat.com>
Date:   Wed, 25 Mar 2020 11:13:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <202003250217.stptJTnJ%lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/25 =E4=B8=8A=E5=8D=882:19, kbuild test robot wrote:
> Hi Jason,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on vhost/linux-next]
> [also build test ERROR on linux/master linus/master v5.6-rc7 next-20200=
324]
> [if your patch is applied to the wrong git tree, please drop us a note =
to help
> improve the system. BTW, we also suggest to use '--base' option to spec=
ify the
> base tree in git format-patch, please see https://stackoverflow.com/a/3=
7406982]
>
> url:    https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-suppor=
t/20200324-142634
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git l=
inux-next
> config: alpha-randconfig-a001-20200324 (attached as .config)
> compiler: alpha-linux-gcc (GCC) 9.2.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/=
sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          GCC_VERSION=3D9.2.0 make.cross ARCH=3Dalpha
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     alpha-linux-ld: drivers/vhost/vringh.o: in function `iotlb_translat=
e':
>     drivers/vhost/vringh.c:1079: undefined reference to `vhost_iotlb_it=
ree_first'


This is because VHOST now depends on VHOST_IOTLB, but it was still=20
selected by MIC or VOP.

Will fix this by switching to use "depends on" fro MIC and VOP

Thanks.


>>> alpha-linux-ld: drivers/vhost/vringh.c:1079: undefined reference to `=
vhost_iotlb_itree_first'
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

