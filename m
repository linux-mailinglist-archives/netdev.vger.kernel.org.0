Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F02C16F853
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgBZHHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:07:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgBZHHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:07:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582700831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLHUhWBg2bX55RLm9LOQN5uKB1n7VPXQRgofoNBrx+M=;
        b=PFAF1JRrygPzYSquUIYfGFa3VkVN7USI83kwtdYDQgO/RposhYzrKTLc4EcR9u5itU59cX
        GHC+kkKRaxsNiZb24vRsSjrRoSUvl/h/5QhgvcoFOKke2+LiNPfIuZYmWgvy1Gloj9yn4o
        0+p+25PlmAaWafG5nn5abahN93hrBls=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Li1dFNCNMryYbSuRePMO3A-1; Wed, 26 Feb 2020 02:07:10 -0500
X-MC-Unique: Li1dFNCNMryYbSuRePMO3A-1
Received: by mail-qt1-f199.google.com with SMTP id r30so3159961qtb.10
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 23:07:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yLHUhWBg2bX55RLm9LOQN5uKB1n7VPXQRgofoNBrx+M=;
        b=q4jeojdqdyVLvcWuvvy3yFAlB+AUUzsZKxYa67dPrd8zNmR7ppFTzAOYhkwsWs7aQq
         F+ajPtJYXbiGfi4OpOJH3WWizd76dEoEgI3jdwQFKeACIgxX+wqR9WAetdUZ/K+iDeBN
         VwKG9netZLNhDiARcNdEQPV9X2RDDiPw925g9YgZdWurv39M4A4uMX5CJymcZrHOyHGc
         ghSPX3sm491HlqhvQerAv32zrcKA0Avsr8AzMy/Vi+BaKk2bVsdShcTzK10wgUiBYggP
         Qpp7I96qQWKZj2gSFd/+TCfCD3BbY9wzOPSmaji7yuyxLCg1J5LH+51ulP3kfqNO50sF
         DBJA==
X-Gm-Message-State: APjAAAUNU60zUnS+u+LhmKPUAAKy4Ia7uPoIXpiGc6BD3ov+I2FPrA3S
        mmF/Lr4tFddxJy4rYOYr0Y/c72lbZzsD83ZAVos87R80qXC3Z43yDCNkcsEvUy80VBMh0f7+3in
        LVmOOHikQzmLV1zH7
X-Received: by 2002:ac8:138b:: with SMTP id h11mr2963185qtj.153.1582700829734;
        Tue, 25 Feb 2020 23:07:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqzRnsWXs8mPrL7JMlDtrOoeTV7tmTs8XtmTA7fhSUFrpj3NwQESvgWoh3J242eLFGFIEu91CA==
X-Received: by 2002:ac8:138b:: with SMTP id h11mr2963165qtj.153.1582700829424;
        Tue, 25 Feb 2020 23:07:09 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id s2sm658710qkj.59.2020.02.25.23.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 23:07:08 -0800 (PST)
Date:   Wed, 26 Feb 2020 02:07:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226015113-mutt-send-email-mst@kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
> Another issue is that virtio_net checks the MTU when a program is
> installed, but does not restrict an MTU change after:
> 
> # ip li sh dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
> state UP mode DEFAULT group default qlen 1000
>     link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
>     prog/xdp id 13 tag c5595e4590d58063 jited
> 
> # ip li set dev eth0 mtu 8192
> 
> # ip li sh dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
> state UP mode DEFAULT group default qlen 1000

Well the reason XDP wants to limit MTU is this:
    the MTU must be less than a page
    size to avoid having to handle XDP across multiple pages

however device mtu basically comes from dhcp.
it is assumed that whoever configured it knew
what he's doing and configured mtu to match
what's going on on the underlying backend.
So we are trusting the user already.

But yes, one can configure mtu later and then it's too late
as xdp was attached.


> 
> 
> The simple solution is:
> 
> @@ -2489,6 +2495,8 @@ static int virtnet_xdp_set(struct net_device *dev,
> struct bpf_prog *prog,
>                 }
>         }
> 
> +       dev->max_mtu = prog ? max_sz : MAX_MTU;
> +
>         return 0;
> 
>  err:


Well max MTU comes from the device ATM and supplies the limit
of the underlying backend. Why is it OK to set it to MAX_MTU?
That's just asking for trouble IMHO, traffic will not
be packetized properly.


> The complicated solution is to implement ndo_change_mtu.
> 
> The simple solution causes a user visible change with 'ip -d li sh' by
> showing a changing max mtu, but the ndo has a poor user experience in
> that it just fails EINVAL (their is no extack) which is confusing since,
> for example, 8192 is a totally legit MTU. Changing the max does return a
> nice extack message.

Just fail with EBUSY instead?

-- 
MST

