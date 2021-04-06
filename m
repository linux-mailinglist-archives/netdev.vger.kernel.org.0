Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE7354A9B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 03:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbhDFBuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 21:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242189AbhDFBuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 21:50:17 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D758C06174A;
        Mon,  5 Apr 2021 18:50:10 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id z12so2545195plb.9;
        Mon, 05 Apr 2021 18:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eowwc3RTaC+FslHD4Qh04BdYDZupvDIB3d1BWbq0KkQ=;
        b=hYESA+HWCG79Jwc7bhgy4xSr59ByZRrDvtvRCAj1p2zA2UBTQvhZQsZKXVLSKBZxTP
         xQHnefJfwfLXq1FoShve71fs8UB75vCZd+yvIICm2GCqahOnw0jQgBy+5wtZAAUotlhY
         d/m5Z8GCRNdnUuKV/BKE6yf5/QKKJKsgastv5IVIlEGiUDmtWh4z0RHAj003HtvAER7H
         F3EACvkF6YBiJiVXECLq8w6sUUY0L4Dqxs4LXIo/7T6S0Y8/6fJYcDc9VJ3iZfCDJrXZ
         XR6boO8zabi/bg14+pmBg52ZQnQhuXAc3GnSvT5CWz83aQTuZQEDGCikBHuIVYT+caJK
         /h2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eowwc3RTaC+FslHD4Qh04BdYDZupvDIB3d1BWbq0KkQ=;
        b=CZ22oFXsTZj0xG+6Nu6eGEBg7QkTzTXDpFLkS/oa7800Wk6uDrYocVWV8r6VyN/WFz
         ZRRURQ9J1FaFMnULb/KW6dSXE+lUiAx3LwAFggoFJfAwinhiVuyOpe9MRp9lo7pYtiRD
         OfCnytcs/e6wiCzxHzvD4JnHc+3GngQssHqOZWHSIjBLV4dUKA5igicEOuVkw9IDXm9v
         Y5JCV/zVqgc9xxCO6eJ5Ab3FzmxmZ3OceNwdfbyQCH0xUktruXXUjKWT0GmwGorI5N7/
         QEPZR0m9utluyjRbkqjvrhtgwVnB1/oiuCuzKbQiiAeVuKRBJmxn/CbK5Nm5iKig/RRE
         ma8g==
X-Gm-Message-State: AOAM533XY/1vMWoSKayUb/0a8Jaw5GYGcdmP8H9YtH4zJpIGEvA4TZoc
        we1/7nRVGPaEkfylsvPYIrQ8o2H2/E/9Xsqfhy0=
X-Google-Smtp-Source: ABdhPJxZ/l4tgfJvTf8QzJwOEoTbtfTwski+LA7UnDuNujUz1LWfnLHLP/dCrgtjpcl04zdwZVv0RshNFzinnP04c8M=
X-Received: by 2002:a17:90a:31cd:: with SMTP id j13mr1979538pjf.231.1617673809892;
 Mon, 05 Apr 2021 18:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch> <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com> <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 5 Apr 2021 18:49:58 -0700
Message-ID: <CAM_iQpU+YD9AcX_77kqmQkqKMuOtnRh5xoGcz9dRRJTe1OnpBQ@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Hillf Danton <hdanton@sina.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Jike Song <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 3, 2021 at 5:23 AM Jiri Kosina <jikos@kernel.org> wrote:
>
> I am still planning to have Yunsheng Lin's (CCing) fix [1] tested in the
> coming days. If it works, then we can consider proceeding with it,
> otherwise I am all for reverting the whole NOLOCK stuff.
>
> [1] https://lore.kernel.org/linux-can/1616641991-14847-1-git-send-email-linyunsheng@huawei.com/T/#u

I personally prefer to just revert that bit, as it brings more troubles
than gains. Even with Yunsheng's patch, there are still some issues.
Essentially, I think the core qdisc scheduling code is not ready for
lockless, just look at those NOLOCK checks in sch_generic.c. :-/

Thanks.
