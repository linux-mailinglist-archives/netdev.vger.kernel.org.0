Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFA357F79
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfF0Jnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 05:43:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40655 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfF0Jnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 05:43:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so1744265wre.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 02:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=LPhI4FnAB8rYALzYGcAglm2VXpvRQrNy2JZPV5HKb9M=;
        b=jCaQVdmMAZbe2sPxH8qKssiBdJNbD90EemzVHvlBBVE39NkWxTuu1mzC0w76xuvA/B
         Ybkwnx+pQctkcI/yF1sJcqynfnXob7EnQRVy1a6A5Dr4y2DLbu7Ae4qk6UEoOVxx4hjG
         75S4EaK51y/feMRvCK3Y2M0djCzvmZ7IwGru2q+5v1WOZD+unS1I54QnT5m0hGu6dLqu
         Hws1Ezu6C3mAWqOALyYVKMs12WfteEOa4wZxpbi9nSKy7omjf5hzyANl8xTXU6BddoCc
         P2zeBO/34Y0DXAr47gSmYyKzairoY0xLy/bWJKtYi5hXity/+8SR01dLfDWYkvL1lN04
         gvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=LPhI4FnAB8rYALzYGcAglm2VXpvRQrNy2JZPV5HKb9M=;
        b=PHcxPeJ+CKQOT/VT+2G5g+Vs80gJMutbOd/DCtwiBvFxHHHUKlaASrNiX2x6L7+B0y
         G7D1rZlJtwPrC9molMrcInQUMfgDEyTlCUihTcN464v6S/c0MFp85wgT4D0k/G9P6aW1
         0XLrCpIIY9tpsTfyguGW6CqV2W+pVClrHWmD0ETmGhzBrRAlSyxkFSsvLShiBBZGCPXb
         Vt7IMC2ybtAj8Tn29roYL1oABRJmeAGJzB2euiRi4peApnE0THlMC9jAXSAH2Ksdkcqq
         5+5Qci6AH4JRE9XDvvY6W1j4Sthg7v7tahMWLrHC7JO54ZSkTGpWSMjVNpUagkOGeqFL
         o61w==
X-Gm-Message-State: APjAAAUjmuKk6Yek9F8zjeMoT6gRjYgjTQh6vuEu0m/p177HkUDGqHFz
        ud3iBIeaeZ0dH5MBOQDZxq7ewdGXGN4=
X-Google-Smtp-Source: APXvYqw9Hk+sQA5fXIlMdEnCT7a4M8flf5jEEjxQiPcaw80Qlnvpd57yYiFYM9sJEZkwusR+mzuvqw==
X-Received: by 2002:a5d:56c1:: with SMTP id m1mr2624273wrw.26.1561628608936;
        Thu, 27 Jun 2019 02:43:28 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id o185sm3892191wmo.45.2019.06.27.02.43.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 02:43:28 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:43:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [RFC] longer netdev names proposal
Message-ID: <20190627094327.GF2424@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all.

In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
netdevice name length. Now when we have PF and VF representors
with port names like "pfXvfY", it became quite common to hit this limit:
0123456789012345
enp131s0f1npf0vf6
enp131s0f1npf0vf22

Since IFLA_NAME is just a string, I though it might be possible to use
it to carry longer names as it is. However, the userspace tools, like
iproute2, are doing checks before print out. So for example in output of
"ip addr" when IFLA_NAME is longer than IFNAMSIZE, the netdevice is
completely avoided.

So here is a proposal that might work:
1) Add a new attribute IFLA_NAME_EXT that could carry names longer than
   IFNAMSIZE, say 64 bytes. The max size should be only defined in kernel,
   user should be prepared for any string size.
2) Add a file in sysfs that would indicate that NAME_EXT is supported by
   the kernel.
3) Udev is going to look for the sysfs indication file. In case when
   kernel supports long names, it will do rename to longer name, setting
   IFLA_NAME_EXT. If not, it does what it does now - fail.
4) There are two cases that can happen during rename:
   A) The name is shorter than IFNAMSIZ
      -> both IFLA_NAME and IFLA_NAME_EXT would contain the same string:
         original IFLA_NAME     = eth0
         original IFLA_NAME_EXT = eth0
         renamed  IFLA_NAME     = enp5s0f1npf0vf1
         renamed  IFLA_NAME_EXT = enp5s0f1npf0vf1
   B) The name is longer tha IFNAMSIZ
      -> IFLA_NAME would contain the original one, IFLA_NAME_EXT would 
         contain the new one:
         original IFLA_NAME     = eth0
         original IFLA_NAME_EXT = eth0
         renamed  IFLA_NAME     = eth0
         renamed  IFLA_NAME_EXT = enp131s0f1npf0vf22

This would allow the old tools to work with "eth0" and the new
tools would work with "enp131s0f1npf0vf22". In sysfs, there would
be symlink from one name to another.
      
Also, there might be a warning added to kernel if someone works
with IFLA_NAME that the userspace tool should be upgraded.

Eventually, only IFLA_NAME_EXT is going to be used by everyone.

I'm aware there are other places where similar new attribute
would have to be introduced too (ip rule for example).
I'm not saying this is a simple work.

Question is what to do with the ioctl api (get ifindex etc). I would
probably leave it as is and push tools to use rtnetlink instead.

Any ideas why this would not work? Any ideas how to solve this
differently?

Thanks!

Jiri
     
