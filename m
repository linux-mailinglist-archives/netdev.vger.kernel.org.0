Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3AC2511
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732296AbfI3QZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:25:54 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40015 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732008AbfI3QZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:25:54 -0400
Received: by mail-ed1-f67.google.com with SMTP id v38so9188413edm.7
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CxG8kXi7I1Xc2GBdZk1kesgGjFu6SiDGkpUBUpUE2+c=;
        b=Ieyss//Vh3Pvev9wKBYvnhW7NCeykNNPlpo4V2itUo8GN1nWdNi1InwQQEVMscJNqs
         mjvGCERHSzG87GH0IcRTb5fYAWUiDGvdXB9XBYpJEzowONemjtdyfbwjSKBKj0FNeH2+
         YfYXkog4nRFdnd0tIHZ2lHomRQ5yUocKtH05M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CxG8kXi7I1Xc2GBdZk1kesgGjFu6SiDGkpUBUpUE2+c=;
        b=lIcN40FjTwFY1VzYPSPjouEMkWjSOg74ZY0eeKdX4cM5nO8r4ecXeXpS3h2LmYGCPt
         nAUt9EPWeFd59nDyOqemNaunyUwPqi+KTuxoc2XNYZo/V9Lkd68lFDtsr0vPzt2dCCXT
         vqgAxfVbfyVOnONuN8kmUzV+mr8miEBSdkfmIgrHFSWHB4b3FMZeai5SkTRfyUsqNRoA
         nzgrrwgGhFT+LpGysw8OvUXm62vs+T0TcsoHiAqnTMULscvYNDPY8Ksjf+bUkm4KUQHK
         Z6imI92nzJI3h/nWcmM1L3lgDmy+aFhSFQDDFnkyfm1zwphiKYojqP7Bm7hvtkod1WDC
         0ngw==
X-Gm-Message-State: APjAAAUllugppu3AYwgDF6k5O97hjFR0zCWqqydiEwI4k9qXERy5Kd+X
        NmMNGBSu3aI5JWaskr3UwfWodu3a5TdxDqaxyIIX2Q==
X-Google-Smtp-Source: APXvYqzSe4PSynskYspsk3x+FY2vldbSwf3wFOJ3Tl0p/lbV01zkpU6CY1so3G51cAJGd4DVY8ar9GHDw0DQvIYtXYU=
X-Received: by 2002:a17:906:52d8:: with SMTP id w24mr19592342ejn.6.1569860752203;
 Mon, 30 Sep 2019 09:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com> <20190930165706.1650087c@cera.brq.redhat.com>
In-Reply-To: <20190930165706.1650087c@cera.brq.redhat.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 30 Sep 2019 09:25:41 -0700
Message-ID: <CAJieiUi0s_qcbHJneeLjRm71kBi0tvo199cwOyQmdOVaqoomMQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 net-next v2 0/2] support for bridge fdb and neigh get
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 7:57 AM Ivan Vecera <ivecera@redhat.com> wrote:
>
> On Sat, 28 Sep 2019 13:22:08 -0700
> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>
> > From: Roopa Prabhu <roopa@cumulusnetworks.com>
> >
> > This series adds iproute2 support to lookup a bridge fdb and
> > neigh entry.
> > example:
> > $bridge fdb get 02:02:00:00:00:03 dev test-dummy0 vlan 1002
> > 02:02:00:00:00:03 dev test-dummy0 vlan 1002 master bridge
> >
> > $ip neigh get 10.0.2.4 dev test-dummy0
> > 10.0.2.4 dev test-dummy0 lladdr de:ad:be:ef:13:37 PERMANENT
> >
> >
> > v2 - remove cast around stdout in print_fdb as pointed out by stephen
> >
> >
> > Roopa Prabhu (2):
> >   bridge: fdb get support
> >   ipneigh: neigh get support
> >
> >  bridge/fdb.c            | 113 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  ip/ipneigh.c            |  72 ++++++++++++++++++++++++++++--
> >  man/man8/bridge.8       |  35 +++++++++++++++
> >  man/man8/ip-neighbour.8 |  25 +++++++++++
> >  4 files changed, 240 insertions(+), 5 deletions(-)
> >
>
> Works great. Thanks, Roopa.
>
> Tested-by: Ivan Vecera <ivecera@redhat.com>

Thanks for testing Ivan!.
