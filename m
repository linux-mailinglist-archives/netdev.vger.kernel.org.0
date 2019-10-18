Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAAEDD55E
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbfJRXab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:30:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35554 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRXaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:30:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id w2so6916811qkf.2
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kPo84uuvsU82fPWFgCTCe4gD9PA/i6CkH/J2a3NU3IM=;
        b=PiEXCNw8O8FdTB9ylL5qSWgWLYT+2WNjCKvFOfgseO0cJ9KDZiOn3r/bwWRfzF9dQE
         z2VkL/sD9KUZrL7gxnCeFCPJiqengm/SRYS/5P83wGR9dBs/qPzQGF5gzmFlnjPGV8nC
         D4w/31yyF97juSTPZ9SBtt0eF2aqC9j8RlXcj/AhSdpxvWHtX0XYtStn0/k0jpMuxdH4
         iQomI+QdJjM6BbswlA/zgA0/+FtDlTmvy4WJpKpaUFN6n9etSKaJg8/U6obMU/GLMbGd
         0UVjUEShUeEukISGg70hZBr4wt9i9t+eO9MgRldepAJx8rfoCPLtZQQkgvHBEzsNba2v
         v7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kPo84uuvsU82fPWFgCTCe4gD9PA/i6CkH/J2a3NU3IM=;
        b=Um1kmoF2OLEAJ1Xsz39XggoM4PKXMapaFuoUp+ul9bI1nunoXgRzupg+LvGSbOX66W
         46oduuLihY4glT0+orl5SyXGE8+R5WteI82oY+8bp4+e5f80qv8I8XNmTksBlqRZ6+T7
         ByqE2wvhwJOP5Nf3UHQMhcq+F5Ir4hdbO9SoiJl4RCebqthEI1BgIcu4Ukxmlgfau+nT
         kUxPqZtQ9fVwtSz1GXVZaa4eblLXcUMfCWhh1kH3GLnuADBtgFX0TsMjLgG4+WhdUqja
         D7ebjtRHG65clqHBb56M+rdelMKx/InZdQDjmr3oVWJ8q1/tNyxLxbYy1xWLYZngdp/H
         MoUQ==
X-Gm-Message-State: APjAAAVBKlBTg/QQ2Rn8UdRlyOQCHHzppdcZd5zCn+OzEavS029KbA7c
        ApFjVUeHo1hF4OLW/Jz8Tr6h2mrbAiqC2lrv5jKQsjVB+ho=
X-Google-Smtp-Source: APXvYqwrh0doay0tg1eXtS1IvCjk9uQmcZrxWcWjQ3+grPC2ou+Qsv8cA2H/ZpF+tvOEXbsVA7GE/0QP/wLmDNdFb60=
X-Received: by 2002:a37:4b4f:: with SMTP id y76mr11399213qka.147.1571441429902;
 Fri, 18 Oct 2019 16:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-2-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-2-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:29:54 -0700
Message-ID: <CALDO+SYs-iWumfh7tZOECCjfxD1GqRSvaYrjmP8TG_wZHHO4UQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 01/10] net: openvswitch: add
 flow-mask cache for performance
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:51 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The idea of this optimization comes from a patch which
> is committed in 2014, openvswitch community. The author
> is Pravin B Shelar. In order to get high performance, I
> implement it again. Later patches will use it.
>
> Pravin B Shelar, says:
> | On every packet OVS needs to lookup flow-table with every
> | mask until it finds a match. The packet flow-key is first
> | masked with mask in the list and then the masked key is
> | looked up in flow-table. Therefore number of masks can
> | affect packet processing performance.
>
> Link: https://github.com/openvswitch/ovs/commit/5604935e4e1cbc16611d2d97f50b717aa31e8ec5
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---
LGTM
Acked-by: William Tu <u9012063@gmail.com>
