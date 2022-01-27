Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCD149D781
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbiA0Bf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiA0Bf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:35:56 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86DEC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:35:55 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id s5so2431387ejx.2
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GVE97pjYi4gXDMbuBRSRMxS1wVu4ENITueD1TfQJKco=;
        b=jBu+XIjqe7MAXwFNphEUcDL/u61Tw2ezGFawqlkCv3uRngzq2QfCd59ZUFwTtjZgeQ
         Iz1k9NAoxUIWvVzc7MqrEDMdW6FYZ5cvAb0NCDW5L+IhcR7zFnQLDJej/FAeZHlLUyce
         Iummv7sjFpwt+x9lX1YiMI3xhaRAWCSijaosWVdukOtWrjuwh6UlPl3H+Pg7618tnNM6
         89EWcoU+xwgIKYxX3zj8+x5qOCkgpxrtBInyjYPqs+EqVXj8hAGTcbD4LLsvXNx3ibtv
         xPmlen6mBWUYpMB0VlZaORkJGUtLKHJq7t9NwlHomURusFDiG81yDn/9lmW84xWdZAI2
         EoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GVE97pjYi4gXDMbuBRSRMxS1wVu4ENITueD1TfQJKco=;
        b=pk8T7ehj4S/v6DbOyf5nYzJ/O4NX67bxriEVxqMs8rpjE9cXDlqFrwu20M5Y6njZMD
         o2Gn2iVT01YeJ3R8s5muvai2z8iywBrzhEHAJLrMAKSVb4EaC0qwfOYWy+gP/ZwayxXb
         JKhYaGgBypM+bwQbNILkKusOx8bHlq3Nc+JR0eOTSNXPIH8bpHuZ50cAm+WVkpt/ucLL
         jhl1HZp9SpSUyZVesbT5paiK34hUEWcnRS+b8ErzhzvIKtX/zxg2LtfvyUgrY3JZz9sS
         AfbAnJhKthXC4WhaLgOS03OZMsUGgDmLqcDSdnG0Vqa1rHOGI0sf9ns/Pv/fYkSnMByl
         5qsA==
X-Gm-Message-State: AOAM5308yN+mi/pIGV2M5CNZf5kdfHRhd1HT+BSPVWVk4ZsOn+RM+Hof
        G199pdUZzCpHMK9Fw9KTNWsaRw5+5qpYidYXWu4=
X-Google-Smtp-Source: ABdhPJzTFmqtL0/46/IrXdKtdM+sMmIXTycD+7HlkHZsH05BPaDB5L0yrQj6/xPZsks1Wqtz744TLGJ7ccy3FG90tKY=
X-Received: by 2002:a17:907:948a:: with SMTP id dm10mr1141500ejc.61.1643247354362;
 Wed, 26 Jan 2022 17:35:54 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-2-xiangxia.m.yue@gmail.com> <87k0fn2pht.fsf@intel.com>
 <CAMDZJNX=gEL0z13QA65Aw11Cp5Mik4HLtMLZUYO0-mppuKsuyg@mail.gmail.com> <CAM_iQpWcqPEhX6QMDycJWSkvKhhSs7OGmgqEi+yUj0BMDAWk3w@mail.gmail.com>
In-Reply-To: <CAM_iQpWcqPEhX6QMDycJWSkvKhhSs7OGmgqEi+yUj0BMDAWk3w@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 27 Jan 2022 09:35:17 +0800
Message-ID: <CAMDZJNW3HgjBhtOUZtX3eOL9fmQjOwxbUwOw5VxiSYBk2qQXiw@mail.gmail.com>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 3:59 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Dec 29, 2021 at 9:03 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > Yes, I think this is key. In k8s, we can not control the priority of
> > applications in Pod. and I think 2/2 patch
>
> Why not? Please be more specific.
I mean the priority of skb can be set via the socket from
applications. the application is running for a long time,
There are so many applications in the company. we can't ask them to do
that. there is a lot of workload.
> > can provide more mechanisms to select queues from a range.
>
> Well, you just keep ignoring eBPF action which provides
> literally infinitely more choices than yours. So, you want more
> choices but still refuse using eBPF action, what point are you
> trying to make?
Maybe I can answer your question in another thread. In brief, this
patch is only enhanced the tc-skbedit.
> Thanks.



-- 
Best regards, Tonghao
