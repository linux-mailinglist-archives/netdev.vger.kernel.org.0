Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701DC3DD227
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhHBIlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:41:10 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:39223 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhHBIlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:41:09 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1M28O9-1mCOFH3r1F-002aqF; Mon, 02 Aug 2021 10:40:58 +0200
Received: by mail-wm1-f53.google.com with SMTP id m19so9914427wms.0;
        Mon, 02 Aug 2021 01:40:58 -0700 (PDT)
X-Gm-Message-State: AOAM533kulorwX2PcfUeRC0u8B7N30vqSxV1bS6vRchyhjEsrrxG2jp+
        748EYmHtNrvQZXoE0oxHP3SN9orLh4FJA/Jq/pI=
X-Google-Smtp-Source: ABdhPJz5worb+3mDgS5BfVO7ARMLM4dzAlkpaueUK5XPmilhwkpYyqD2IgZhtv48MM0fLgUXIA9RUQdA6/gsZXu3Zf4=
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr15307818wmm.120.1627893658610;
 Mon, 02 Aug 2021 01:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000014105005c87cffdc@google.com> <20210801131406.1750-1-hdanton@sina.com>
 <6f05c1a9-801a-6174-048a-90688a23941d@nvidia.com>
In-Reply-To: <6f05c1a9-801a-6174-048a-90688a23941d@nvidia.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 2 Aug 2021 10:40:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0dX1GRDTUp50kW81dD-dUw_=H4sx6tyeCVJea-FOBCQA@mail.gmail.com>
Message-ID: <CAK8P3a0dX1GRDTUp50kW81dD-dUw_=H4sx6tyeCVJea-FOBCQA@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in br_ioctl_call
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+34fe5894623c4ab1b379@syzkaller.appspotmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        bridge@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:56wepSUXVz28L9Dna4gNb3O/IaR3lTv8C3dEgk5bPc/SRiGKmTN
 n7lA5HD4lBzKvygf95qcK2lEW63L0VUwlXWHafLNnQ/6NwMH13oqCdhXBY5Rq49Ms9UoVVp
 jJcfU+9kYaT88SaHLBkyMI+BLrdLtqUzhDGjqsnFl7nORGVtGBD+ZP/0YAc9aj7VZFVP8tp
 FBRymqzZ1wuwUAl8z/uuA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6g4JBgcJbPU=:eq3AJ28JQj2DfOYIw+XS9F
 wsH/BQYJnCECBopLQ7L+ZZRPQpKGwmvaJd3N8jlb9e/iQFy6jb7pkMd3yvGl6go836yAVHUOY
 oH/EXTNSG+uDZJNwjV/z7bmZCvSInUETMD+WKqDsijAxfaAeQKlGwQFHWUzIbaPNyDFXIyWa1
 6KFPu2g+H3LloCk52dGWVpmsgztye7qcsxvDoL9EJCwvxxJ5XKJAF69DzkUxOKGViKfrAmroC
 DAsz/IJUyh7mjIzx8grBjP1uXLXPTocZBAFkXQH4NADcKAH4xStD9Ijj7DLI0dehZEwt/m3oH
 qLAJqO41ZjtFnstHeOCnoKwBZ8so+hydoHY19yS8FupcQ9Xoz4g6WV59AwM5Qcb5NUk/R3Fo6
 819UeTdPPYbjb3KmMNd+t2xhb9KzuawhuBlZYRpZPaaYO2DEbIf8hkT+nB+uub790VEH74WHb
 YE5UpHhsgnLoTCTrb4QvVRl3dgKhQ5wsG7K05df41bvD5zEw4YohwsGR06N1HhON0vJ1H9buj
 YUOboChnqYvrijcwFeE50mfWR5f7KWvTcsRvjMkVWgwlN/RJhBm98tEV7FF17KZZKqYLw1cRZ
 GZ/j2axGXmmou0dWdWHuv37hhNdHCEsIRPwY7c1twPVoMEnBrF/eEdcLJ1AaCb5KsFJRIGCFx
 RrH/90YeGFfR5jVo4vkRZM6r6ZG4z0TuM/J0O5iEpJsJpcuyUG72DAF9cEvCY3aLd2MveV48a
 keU6lTgk+dnY2PdrWkelbzXSkKfei9ureMAbMd1WRey+BMsKLMKU6XHeywzNY0D12i9BOtqMf
 22aebCPHq40Oq1n9V0dW9pVO5gVlt5VlbsuxWKZGQSGMtDhDMe9CbhGD+3jKorjUB2oyuz/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 10:30 AM Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> On 01/08/2021 16:14, Hillf Danton wrote:
> > On Sun, 01 Aug 2021 03:34:24 -0700
> >> syzbot found the following issue on:
>
> Thanks, but it will need more work, the bridge ioctl calls were divided in two parts
> before: one was deviceless called by sock_ioctl and didn't expect rtnl to be held, the other was
> with a device called by dev_ifsioc() and expected rtnl to be held.
> Then ad2f99aedf8f ("net: bridge: move bridge ioctls out of .ndo_do_ioctl")
> united them in a single ioctl stub, but didn't take care of the locking expectations.
> For sock_ioctl now we acquire  (1) br_ioctl_mutex, (2) rtnl and for dev_ifsioc we
> acquire (1) rtnl, (2) br_ioctl_mutex as the lockdep warning has demonstrated.

Right, sorry about causing problems here.

> That fix above can work if rtnl gets reacquired by the ioctl in the proper switch cases.
> To avoid playing even more locking games it'd probably be best to always acquire and
> release rtnl by the bridge ioctl which will need a bit more work.
>
> Arnd, should I take care of it?

That would be best I think. As you have already analyzed the problem and come
up with a possible solution, I'm sure you will get to a better fix
more quickly than
I would.

Thanks,

       Arnd
