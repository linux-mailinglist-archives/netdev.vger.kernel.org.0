Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAFE95BD0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfHTJ7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:59:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40131 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbfHTJ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:59:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so2071708wmj.5;
        Tue, 20 Aug 2019 02:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:references:user-agent:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=F1+ICetoX/eiRFLoq+UTPBwiKyXIjoQ44kEZZ2m8xvY=;
        b=O2bCgeCfYdukzldCAcZ8kBMnl7zg5hSM2sb4fpSOM1lRE19YcgAd+UT8XLDBT8uV79
         mPiTV1/sRxa5g5BuF9hMzWUmlR8ZnpUbtpgZOiAFXUnbTxQnXyzgC3sge0f/0AuxeNwD
         UicFlJ61bKcshTMgUBFgLOBmK6dNvLKPV7gu43X0LRnMrDgXKV0T2KQV3qpVx4cLgBhK
         HXbR62I1MjwZGd4t9sHl3Dk4wP6IvMxQN53RyH0/oOnYtWdNB892IORgjksY0k9nhKjT
         9Jbi/vgXFb75fxtVw3hf0MIyjKqYl8GF11MuwN790AXD/V74tnUtydAFQTVppD8JmyYb
         qmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:user-agent:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=F1+ICetoX/eiRFLoq+UTPBwiKyXIjoQ44kEZZ2m8xvY=;
        b=AjpmWKQd+6A54Z0Q2SRtnyx6q/oxeqq+MaN88pwlh4Q0DG97wiT0AmyVBc5EOxrhs4
         hCw9YTJaXTJrqlIsZ26CPUD/SRG0pwczAlzrKZsaY9Vu8tHdvUvNbnpJ2l1wOSIbx6+2
         mmhy2Bf272w2ZiPsoXLcCuHfpdxkeraHB5y9lUW+y/+IyiZSW2vI8foLRQANRIX2iBA5
         5nqAmrhVPPqCX//ZrhnHjUpLE7xZJXlWm83rXPVK1MJCRUz1+yzgQj8ol/6Ijhaol6WD
         QwF/bQwrpsIdgEqsDxEQRUCkGghUeOSsv4YWRenyQ4c5GGX8IJr+47pDdxkR9JuAJhKx
         +Tnw==
X-Gm-Message-State: APjAAAWpCjEOFQAFU8EnOeyTUlnN/Cn4K0OZpYKa5QCprAY51wBe3UTl
        V8LMLqvjQAE98eIg8+L8RTpcdE8c
X-Google-Smtp-Source: APXvYqw2renjH9hgp1/Dmv8kHndVYmEaZ+b9hLg4+gxVnOz3naxSViwHfk0iXEXVwYR0jaGtBGBTLA==
X-Received: by 2002:a7b:cb8e:: with SMTP id m14mr25721808wmi.10.1566295138439;
        Tue, 20 Aug 2019 02:58:58 -0700 (PDT)
Received: from ptitpuce ([2a01:e35:8b6a:1220:78d4:cf6a:d1cb:d093])
        by smtp.gmail.com with ESMTPSA id a141sm2834058wmd.0.2019.08.20.02.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 02:58:57 -0700 (PDT)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
References: <20190802065905.45239-1-parav@mellanox.com> <20190808141255.45236-1-parav@mellanox.com> <20190808170247.1fc2c4c4@x1.home> <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com> <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com> <20190813085246.1d642ae5@x1.home> <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com> <20190813111149.027c6a3c@x1.home> <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com> <20190814100135.1f60aa42.cohuck@redhat.com> <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com> <20190814150911.296da78c.cohuck@redhat.com> <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com> <20190814085746.26b5f2a3@x1.home> <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com> <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-agent: mu4e 1.3.2; emacs 26.2
To:     Parav Pandit <parav@mellanox.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia\@nvidia.com" <cjia@nvidia.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
In-reply-to: <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Date:   Tue, 20 Aug 2019 11:58:55 +0200
Message-ID: <m1o90kduow.fsf@dinechin.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Parav Pandit writes:

> + Dave.
>
> Hi Jiri, Dave, Alex, Kirti, Cornelia,
>
> Please provide your feedback on it, how shall we proceed?
>
> Hence, I would like to discuss below options.
>
> Option-1: mdev index
> Introduce an optional mdev index/handle as u32 during mdev create time.
> User passes mdev index/handle as input.
>
> phys_port_name=mIndex=m%u
> mdev_index will be available in sysfs as mdev attribute for udev to name the mdev's netdev.
>
> example mdev create command:
> UUID=$(uuidgen)
> echo $UUID index=10 > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> example netdevs:
> repnetdev=ens2f0_m10	/*ens2f0 is parent PF's netdevice */
> mdev_netdev=enm10
>
> Pros:
> 1. mdevctl and any other existing tools are unaffected.
> 2. netdev stack, ovs and other switching platforms are unaffected.
> 3. achieves unique phys_port_name for representor netdev
> 4. achieves unique mdev eth netdev name for the mdev using udev/systemd extension.
> 5. Aligns well with mdev and netdev subsystem and similar to existing sriov bdf's.
>
> Option-2: shorter mdev name
> Extend mdev to have shorter mdev device name in addition to UUID.
> such as 'foo', 'bar'.
> Mdev will continue to have UUID.
> phys_port_name=mdev_name
>
> Pros:
> 1. All same as option-1, except mdevctl needs upgrade for newer usage.
> It is common practice to upgrade iproute2 package along with the kernel.
> Similar practice to be done with mdevctl.
> 2. Newer users of mdevctl who wants to work with non_UUID names, will use newer mdevctl/tools.
> Cons:
> 1. Dual naming scheme of mdev might affect some of the existing tools.
> It's unclear how/if it actually affects.
> mdevctl [2] is very recently developed and can be enhanced for dual naming scheme.
>
> Option-3: mdev uuid alias
> Instead of shorter mdev name or mdev index, have alpha-numeric name alias.
> Alias is an optional mdev sysfs attribute such as 'foo', 'bar'.
> example mdev create command:
> UUID=$(uuidgen)
> echo $UUID alias=foo > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> example netdevs:
> examle netdevs:
> repnetdev = ens2f0_mfoo
> mdev_netdev=enmfoo
>
> Pros:
> 1. All same as option-1.
> 2. Doesn't affect existing mdev naming scheme.
> Cons:
> 1. Index scheme of option-1 is better which can number large number of mdevs with fewer characters, simplifying the management tool.

I believe that Alex pointed out another "Cons" to all three options,
which is that it forces user-space to resolve potential race conditions
when creating an index or short name or alias.

Also, what happens if `index=10` is not provided on the command-line?
Does that make the device unusable for your purpose?


--
Cheers,
Christophe de Dinechin (IRC c3d)
