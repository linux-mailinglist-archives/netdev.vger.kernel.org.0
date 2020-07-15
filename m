Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F902204CE
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 08:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgGOGMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 02:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgGOGMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 02:12:22 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19B5C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 23:12:21 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v8so1070871iox.2
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 23:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iWfB3CRvTTbfsUokGOaacR6jqWzdU7uPLeMgijYvuqk=;
        b=Ioryhkx+a+1GPDPfC3qjwAKTPljFwbVwWJ2TomTwHvQGrHu2LIwY4EelDm4B96F4nC
         X/bmhG9uFCLK0omA4zJimu+XV7jXQ1+7ufrGdQY1GKJ7NwaYCs8UXSOebBjug8xV9Ygf
         lI0AUvxey5PlExCMK1ESX9VJSuJRDFDX1893QZhKbuZ66WFhw1u9lDBsxGs0n/W23KNW
         13heAF58WaicTaEscqXJjVN+hTmcKCHIAbTNrfMUDI6/R3DHx8qYCoQFiCL6OEOvx7XL
         x4jvCSauuRVjdeJDoi/jTuW+79i4zekIr+Aw8iZv42z9w58l/iGtE23cI3u293/oGvUR
         mRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iWfB3CRvTTbfsUokGOaacR6jqWzdU7uPLeMgijYvuqk=;
        b=Xs1kg/ndrLYgXe+8PyDtAoxjr1MAXVIFWrEt3leaYdtHn34iyqnAY4Lwyk42ke/raa
         F94zDBQMEF/gzisU7Y5SSTeBVJGr0QX+sySM2fid1OPK2pqT5LkqWo76pmZVX/t4PUtc
         USOIY4WN/ZngIIblJliM5F6ZXns262mJ1pjQ9gurchrubiXawbjPsitTfQyA0Crnw+g7
         S627iQTEomyjBnlMDr+zCbXndzGq0xPiQPZereUTtG1jkDbwypIUJ1Xmcfh54OIV8uk7
         4U4NxyCx9DuD2hWgPv2xK5JURryW9sCSXezwkmPDmfQMy0NY7ItP8ubyzUgpif+meT8x
         FaJg==
X-Gm-Message-State: AOAM532bc8A2oi7U6B6IM+CCUbjLpC4WEFle0XwNUzgljwAdIASQPT6b
        fZCg1uqQhoDiicrBM2V5CBySfZIE9eL0FA+crqdyMEKT
X-Google-Smtp-Source: ABdhPJx999ZNNxtxmqko6ZAUBx3V05D8YtCn5ta+wn3tcNuK61/K0AKzP0TsvbYKKJCxWnuxTj+WqOv/Cq4MH7nG/B8=
X-Received: by 2002:a02:5d49:: with SMTP id w70mr10251417jaa.16.1594793541254;
 Tue, 14 Jul 2020 23:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200711212848.20914-1-lariel@mellanox.com> <20200711212848.20914-3-lariel@mellanox.com>
 <CAM_iQpXy-_qVUangkd-V8V_shLRMjRNUpJkrWTZ=xv3sYzzaKQ@mail.gmail.com> <b4099188-cd5d-cbca-001b-3b0e4b2bb98a@mellanox.com>
In-Reply-To: <b4099188-cd5d-cbca-001b-3b0e4b2bb98a@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 14 Jul 2020 23:12:10 -0700
Message-ID: <CAM_iQpWfwOLKufZ4sJk9BP-BMcynmt327WRdNRC5vrGQ=7sT1g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net/sched: Introduce action hash
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 8:17 PM Ariel Levkovich <lariel@mellanox.com> wrote:
>
> On 7/13/20 6:04 PM, Cong Wang wrote:
> > On Sat, Jul 11, 2020 at 2:28 PM Ariel Levkovich <lariel@mellanox.com> wrote:
> >> Allow user to set a packet's hash value using a bpf program.
> >>
> >> The user provided BPF program is required to compute and return
> >> a hash value for the packet which is then stored in skb->hash.
> > Can be done by act_bpf, right?
>
> Right. We already agreed on that.
>
> Nevertheless, as I mentioned, act_bpf is not offloadable.
>
> Device driver has no clue what the program does.

What about offloading act_skbedit? You care about offloading
the skb->hash computation, not about bpf.

Thanks.
