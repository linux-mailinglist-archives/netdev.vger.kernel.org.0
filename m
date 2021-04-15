Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609D1360F6A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhDOPv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbhDOPv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:51:58 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB60BC061574;
        Thu, 15 Apr 2021 08:51:33 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id j7so12306672plx.2;
        Thu, 15 Apr 2021 08:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZUkhDwjg9YvHrlde+pw0+QfaYkfI1Vi/cJAvb3EsHfM=;
        b=kMCCYwMthkw5pulcRfBV1kanqTcDkHORCJ3VuxY8teVwQojdC9JiyyJL6Rduz35Bn8
         StfmqYgJ9zYkgEVGCH/ZG6C8aGn/ZyoKBaS1JbafYT1XzoYakRND6uBWX1PtftS+EYR6
         QX5SX8VgfHelas5+i+xjY0KWx+UVG1FXdR06yJxt7RldNIoNAJYKp3DGlvM70D7SMOm5
         UHgVpzzTUg+YitOydXMTWbG+Jo+pdUxgGRprQjwoPdOqQ6RzTGyqbWqdeATMuaRCoIbb
         SxF+4LKY3Ttc51nE4jB5mIpz67zraSHwXve4UoGk4YUIjhBb1FcE0So692RmeMBgZgip
         UNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZUkhDwjg9YvHrlde+pw0+QfaYkfI1Vi/cJAvb3EsHfM=;
        b=OtQxbT+1q9dWi5TMkt8u/knbVbR2ogBcNVYvbQU4l+doZfdibuDJFzL/TRP1c5njS8
         aHZ1GCNIMMq7NcPWnblsSt1e886mULkvNm0Iov+EL5V7UoMe66YtD0p2o5dgy+ExbREA
         kmlc/pz0TO3IPJ4yR7L5vNFR7tr8W3Ww7Eq63Uyr5B+fzzgm/PUMdK2OLYW7W/RJ/PNl
         Y+CixFMFJ6QVmg32KPmI6PBvZCxPT3FgBIG9rG5Y4mjMZY+6OD0VUOrfQ3Q7zSpksKz7
         x4Do1wfZQlDe2cwaBHSjk8z3J2rjTEQm6z/rktY0Q/wdfdUNoe9skbaWw3fqgFFNl3Pw
         bIPQ==
X-Gm-Message-State: AOAM532PBvYlKjE65ibFr65bdptI3F02fqgVFtf5fQIfi0tG8vBD6jvP
        Dc2I5cGxDB6l7HNaJY7JI0p+KxrJSJBlEjZLo9HGDqh8wVE=
X-Google-Smtp-Source: ABdhPJx+/LRnzrkm0MUE3ufbwmi6tTEjrITCOPLICIUq2YHnIEfsg1biXqtpSdIEebDLd2hml5fI/GXg+6bkyWe/XwU=
X-Received: by 2002:a17:90a:e298:: with SMTP id d24mr4694555pjz.56.1618501893507;
 Thu, 15 Apr 2021 08:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com> <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
In-Reply-To: <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 15 Apr 2021 08:51:22 -0700
Message-ID: <CAM_iQpVc=0YtKLdEZNPDjA5H84UH50pZ4uFjQ1h=qO-+eUJn-Q@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 9:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> As I said earlier:
> "
> If prog refers such hmap as above during prog free the kernel does
> for_each_map_elem {if (elem->opaque) del_timer().}
> "

This goes back to our previous discussion. Forcing timer deletions on
prog exit is not what we want. The whole point of using a map is to
extend the lifetime of a timer, that is, as long as the map exists, the
timers within it could be still running too.

Thanks.
