Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DB2146F97
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgAWR0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:26:08 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38385 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgAWR0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:26:07 -0500
Received: by mail-ed1-f67.google.com with SMTP id i16so4105786edr.5
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 09:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NPtBbX3ITZ/WPJ1gvGpgf1pUCSUHUonaL+ATctxLmho=;
        b=m65X3dAO+pNAo7+vlJQ4avreAMMqoH1kZcyFoeaKc0ClfHIpbyZ1n8P69MwpYsRyj7
         Ec+y6AFD+ZNc2qBh3A1YFHSaAfKgE+e1JJXFmj1Z8Sq3shZqu6BuQQyD/5Q5HIyaJaZv
         lHlo37pPVfIk3Z2CJdYmC3OjnSaHVVbbcIosiQjxYDgrmEF8j/3MYC10a0BFXfTpowaR
         0EdbEN98ii6K/sfjvp/w+2uT32+sTxmdNq0l6dM2F45iGjj83kBNPgB3rt64K78qgdp/
         eqKtl3LJs3TbzGY9b+CrkmzlZX7zwBWgt7Ih9Tp8WyILXVnD8zvVVXw9pLC0O7gNxAZj
         ajdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NPtBbX3ITZ/WPJ1gvGpgf1pUCSUHUonaL+ATctxLmho=;
        b=FiadGdjRsSUnOIpHwAJ8C4R5AYhgMMz7KRBU1upbFZ/JOOHDWsui7W0qDvldD/pqg0
         f6rLV4rfm/SBTBUjUGYwbrxnTljB3k2YhWjFxCynX06ppifXaN9zpKLAuzbWXVvG78Pu
         2WfkDKeJpyD+Fo6cKa0B4hjDjdmkm68dnARvUMZmo9hNY4AzJyjCFYYVUulDcIkCfodP
         ioCXexaUfEH8M3Z+5yr1HPW8DlNWb0ZsQp9pcn0Wm3eiRJV3XXbxhNUp8y4xjZYx5vEN
         199+JbAcHH/TqeE7xQtmihEaQFvmj98ZJIOSSzx2/MZVnReczq6ncTbMgjnyEUbvUKdY
         +xkQ==
X-Gm-Message-State: APjAAAX1BeJk0sD1Z+QxQOrfIH2mDhhBpaxzJlMl55q6CcW3X4sCQiwy
        CIU5rVNo0jfpy/I53wuADJc86Lz3stY8UtD+ia2GPQ==
X-Google-Smtp-Source: APXvYqxAL2tEdR4AwfKHmxd+EN02Z3C1YOYqXzBY6bXNprRGOpMiSyxNAlnFaTl4UvYPSTjKB5IQfEPIl9jMtywMhJE=
X-Received: by 2002:a05:6402:6d2:: with SMTP id n18mr8040293edy.100.1579800365583;
 Thu, 23 Jan 2020 09:26:05 -0800 (PST)
MIME-Version: 1.0
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk>
 <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net>
In-Reply-To: <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Thu, 23 Jan 2020 09:25:54 -0800
Message-ID: <CAMOZA0K-0LOGMXdFecRUHmyoOmOUabsgvzwA35jB-T=5tzV_TA@mail.gmail.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 7:48 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Luigi Rizzo <lrizzo@google.com> writes:
> >
> >> Add a netdevice flag to control skb linearization in generic xdp mode.
> >> Among the various mechanism to control the flag, the sysfs
> >> interface seems sufficiently simple and self-contained.
> >> The attribute can be modified through
> >>      /sys/class/net/<DEVICE>/xdp_linearize
> >> The default is 1 (on)
>
> Needs documentation in Documentation/ABI/testing/sysfs-class-net.
>
> > Erm, won't turning off linearization break the XDP program's ability to
> > do direct packet access?
>
> Yes, in the worst case you only have eth header pulled into linear sectio=
n. :/
> In tc/BPF for direct packet access we have bpf_skb_pull_data() helper whi=
ch can
> pull in up to X bytes into linear section on demand. I guess something li=
ke this
> could be done for XDP context as well, e.g. generic XDP would pull when n=
on-linear
> and native XDP would have nothing todo (though in this case you end up wr=
iting the
> prog specifically for generic XDP with slowdown when you'd load it on nat=
ive XDP
> where it's linear anyway, but that could/should be documented if so).

There was some discussion on multi-segment xdp
https://www.spinics.net/lists/netdev/msg620140.html
https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi=
-buffer01-design.org

with no clear decision as far as I can tell.

I wanted to point out that linearization might be an issue for native
xdp as well
(specifically with NICs that do header split, LRO, scatter-gather, MTU
> pagesize ...)
and having to unconditionally pay the linearization cost (or disable
the above features)
by just loading an xdp program may be a big performance hit.

cheers
luigi


>
> Thanks,
> Daniel
