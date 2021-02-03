Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8959C30E32E
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 20:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhBCTXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 14:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhBCTXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 14:23:14 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37632C061573;
        Wed,  3 Feb 2021 11:22:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d13so429367plg.0;
        Wed, 03 Feb 2021 11:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wdux1NgAhUede5q+Qa7ndsJ+hJBl2N+NtbM5uRVRO9k=;
        b=IMP5qITpxUey3994OI8i3M927hg6jPIobRvRbTdplzHfRlngG2iXhimgqHvv8wc2db
         O2ptbpedxAb6lbwnzwVcdk/dm23OzRFEXCDV842upN/PHCxK24fMh1bvVYllq6aLovUG
         iWI0bCBQXKPYhXJm5lm4wRW1hPk0ddIvYP/Sscpy+lEtmvBkEaBl6zVaj4256kWjExFj
         963UNAzzMqoNqB+c9fk7eEZCX1ByZE00LWk47uUaRDNYNRzLImnjvDxK4MNZogQDOhzb
         vyTN2xvGEMO4lFbpKfWjzCuQ1CoaadqUOsqoacdKNkUlAWqBlE7f+O3Gphgo7rhFtNwy
         moOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wdux1NgAhUede5q+Qa7ndsJ+hJBl2N+NtbM5uRVRO9k=;
        b=fa/aelm8+NQW+qvUjac9pCPuOGHVXRk8OSeLlTqiO/vLpk6lA4xgaiaBwY3ytIf4A/
         zKahrwefPgeA9JzmSemgS7WQ1d6XHnoW5uyA8EAcq+kSaGwQ2VVsku20GrmGitrEC/4e
         ZE8Ot2NsCk/wBJsdott0SFP3rmHVW2Lo6ZXlellMMj1cgULbajRw+gDjRhYEO/IltmVF
         1CEbrNO1c33qvGVJqzWmRqVDi+jA3wGkqXcSnnaRv+HZq5/NsHusTp37B9n1xVQ2YO0x
         F2RUFdoGXh5klgDLBBekbdvlW5MQsyYbmY9iPos9xTf+6wNzVtUAF3rX2TmeWTHo6NOT
         7aHQ==
X-Gm-Message-State: AOAM532To1v7/B8zXpEhO9ZVYmoNax4Ww9leqyZLk6mnh4iTrzXtABwR
        ihxj/JjAZknc6rxssrLFAcOF3DJu62NemtReA7eKAnL1OUWDqA==
X-Google-Smtp-Source: ABdhPJyOGgPHBIaW8sv4ULqrmu46An8oDd3Ac0xOUE6Q9k8YUDd3xL7S0TCSSbTCfbJYsrIvz0MMM0axWpDh5FEpaYs=
X-Received: by 2002:a17:90a:8594:: with SMTP id m20mr4453779pjn.215.1612380153248;
 Wed, 03 Feb 2021 11:22:33 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com> <20210203174846.gvhyv3hlrfnep7xe@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210203174846.gvhyv3hlrfnep7xe@ast-mbp.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 3 Feb 2021 11:22:22 -0800
Message-ID: <CAM_iQpX-GDysSZTYr-2WsbqFP4VgG5ivcO1vwLvKVHkJ9hjodg@mail.gmail.com>
Subject: Re: [Patch bpf-next 00/19] sock_map: add non-TCP and cross-protocol support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 9:48 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Feb 02, 2021 at 08:16:17PM -0800, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently sockmap only fully supports TCP, UDP is partially supported
> > as it is only allowed to add into sockmap. This patch extends sockmap
> > with: 1) full UDP support; 2) full AF_UNIX dgram support; 3) cross
> > protocol support. Our goal is to allow socket splice between AF_UNIX
> > dgram and UDP.
>
> Please expand on the use case. The 'splice between af_unix and udp'
> doesn't tell me much. The selftest doesn't help to understand the scope either.

Sure. We have thousands of services connected to a daemon on every host
with UNIX dgram sockets, after they are moved into VM, we have to add a proxy
to forward these communications from VM to host, because rewriting thousands
of them is not practical. This proxy uses a UNIX socket connected to services
and uses a UDP socket to connect to the host. It is inefficient because data is
copied between kernel space and user space twice, and we can not use
splice() which only supports TCP. Therefore, we want to use sockmap to do
the splicing without even going to user-space at all (after the initial setup).

My colleague Jiang (already Cc'ed) is working on the sockmap support for
vsock so that we can move from UDP to vsock for host-VM communications.

If this is useful, I can add it in this cover letter in the next update.

Thanks.
