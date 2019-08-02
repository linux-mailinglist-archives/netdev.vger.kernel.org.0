Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFFC7EC99
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 08:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733177AbfHBG1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 02:27:18 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44794 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfHBG1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 02:27:18 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so149682180iob.11
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 23:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zvIDVzoPDgG/aq/EQ3dYifbv7SfSzx7aC6Xx6sD5m38=;
        b=MKMWMOVCkD1Zaxkk4RAuMcPlVwyQhgW7ZKtm0vO6/2T3vLpHitnyQeMODQUWXomC95
         nArS6madZDOUt1U2x6ubGJ4MhGX2nkce2zLJjdFz44UkTqt8d3tRFw+ynsiW27ZKyY5V
         M6VXomjSCBABWhy8cIXZP+IId4F5iTyuGlbfvlRAz5Pd5i/5I55cOZxjcX1Ft5ecksX0
         nGYDDd/Hc4uUwZxwY6+PdyDjkOAz3Jk0zghMlfiOd2WXPacAHfw4Imxaxqpdwmmmkdtw
         y2xf6NeOYllMWFKj0JSlLb57Uumj5LLDLVpFJKgvh0FxBZGUMq/gEEdZVCqsGsIciHXb
         RZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zvIDVzoPDgG/aq/EQ3dYifbv7SfSzx7aC6Xx6sD5m38=;
        b=mUDhy/LEfNgJa5OT24E+hd/ptottt9B4+dvsXrU7HwvjODiD64JnSATTqNUHTpeDiB
         PZRRkmTjA/VOJ6tJJyiBjjcYKLtj5+7t5YyNANpYUNYJgyUBqek8O8iQpqsMLlIV9GFb
         xXo4o5c4WSfnP9feHIqLcMKZB+bxLwEAup5yTMEvDjUTAelnHnJDAttq9oyWOS82i0mj
         4dq/zf4DoQXpa+0sf/qJ1wOJ0FvnEnZLXQlKrjD9wnqiqDDH0Db9lVzGN8zYurF+922J
         MqdArznC4WiDVGr7QpWB/r4U1KM17dLLSsWiaJOF/+hRJ0XHvKzK8Dmpo0BgxLqDtViv
         kWjA==
X-Gm-Message-State: APjAAAWhq2ZQfhU9YAIFFG1fYHbCcPtxJHhIhxgzhLro8Gog1XYtFG67
        9zQNZ2xqHODJmqxgfO0jFQvuKVSDhTYAyxEWCMo=
X-Google-Smtp-Source: APXvYqx3ii10SYThSbVKuNtowITpmhldxKeokyDoP9dQ40Q9dPUgUmS5pmg18Q9SbjL9QnMqevZP7NsDm1uHRBuGhSo=
X-Received: by 2002:a02:c65a:: with SMTP id k26mr2606920jan.18.1564727237300;
 Thu, 01 Aug 2019 23:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com>
In-Reply-To: <20190801081133.13200-1-danieltimlee@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 1 Aug 2019 23:26:41 -0700
Message-ID: <CAH3MdRWYpXj8Yb9TM_VefMHLE=wvM5E04hY=0aMWUVRziCxaeg@mail.gmail.com>
Subject: Re: [v2,0/2] tools: bpftool: add net attach/detach command to attach
 XDP prog
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 1:33 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, bpftool net only supports dumping progs attached on the
> interface. To attach XDP prog on interface, user must use other tool
> (eg. iproute2). By this patch, with `bpftool net attach/detach`, user
> can attach/detach XDP prog on interface.
>
>     $ ./bpftool prog
>     ...
>     208: xdp  name xdp_prog1  tag ad822e38b629553f  gpl
>       loaded_at 2019-07-28T18:03:11+0900  uid 0
>     ...
>     $ ./bpftool net attach id 208 xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     enp6s0np1(5) driver id 208
>     ...
>     $ ./bpftool net detach xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     ...
>
> While this patch only contains support for XDP, through `net
> attach/detach`, bpftool can further support other prog attach types.

new bpftool net subcommands are added. I guess doc and bash
completion needs update as well.

>
> XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.
>
> ---
> Changes in v2:
>   - command 'load/unload' changed to 'attach/detach' for the consistency
>
> Daniel T. Lee (2):
>   tools: bpftool: add net attach command to attach XDP on interface
>   tools: bpftool: add net detach command to detach XDP on interface
>
>  tools/bpf/bpftool/net.c | 160 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 159 insertions(+), 1 deletion(-)
>
> --
> 2.20.1
>
