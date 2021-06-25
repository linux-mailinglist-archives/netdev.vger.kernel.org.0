Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3338C3B49F7
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 23:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhFYVLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 17:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhFYVLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 17:11:22 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2308BC061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 14:09:00 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id q190so20603445qkd.2
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 14:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VLdRoc7Vi4IM7D6gRwT1nkjvCtkNEeCVWYhPl933Vi8=;
        b=zAzQQv0ICPE04oLtdKaTL0S7BzZmMRVFYbUN9B78/VHOQ0uVFTXu7ES2DzCrD0FeOv
         KCPu+AkqdaBO/tdT+uJoPHSQljVkLKP57DHiH0wSUuGx8JTMjmJ5RuCec9o0eI1ONbZN
         MDLVvikhWmf5vTPSfm5BUhHQRVyPJ3E7rf86/l40TpdiTVJ5bdR8Xg3f5H/BteSghjGr
         EFfB00opYK1mVVQdz0z0dNiW8P7OwD9wJ9DlgqPxCc1Nd/t9QHepOiq1A3fmlR/9zzwY
         6bKQ3jJzdAPz5+9m640Bq1RayXhj/g65+5gil7R0WXm06im0f/p643j1Cah4RrUnt3np
         QkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VLdRoc7Vi4IM7D6gRwT1nkjvCtkNEeCVWYhPl933Vi8=;
        b=UODMFDmLtT0OULs0AnTk4JD5QSpqOaBEansxzs/fit/ICWRMpg+mlqMe6FRaLfTgpm
         b01p7XQBjKVzyy9wNrWdI3iuSMIB8e5yZ/22/2WYdSVyUP7fXQTl1ZtUuC17ibkCJg2q
         p+JeyM+v1V0aW++xAPuiMTXe2y3zzMx6nrXqyjPZItgBxvQpUnLOAWH1xiHTW2ZbwyWB
         jLgw2L5NHckpYzBF1NYQFFmCMjSlujivFlx2W0l8NmIfVFYmtPVYsYbcFd6jjB2zoQUd
         Zng11lVQi+jHFJzHV/uRu65h9GyKmWsDchmFhrMjc+/hlZU2D8mS23BLtbJMs+rgMkS0
         IQpA==
X-Gm-Message-State: AOAM531LtVl67VxhhEMuwkQDQx3IKfDstRra4/haAJidtJjlrRpzvc7j
        h3buPCpYuyvaCsBDe+265huwmev0kwrwdbIFq2wL7DXQDzOGBQ==
X-Google-Smtp-Source: ABdhPJz8RXmAmiUSRCqk8ZuTiMA1aejnIwARA3yjPDjW1KEL3FTV/5h1khu/4jvBNS/zmARNAv0bmhgACYCS+wwOK58=
X-Received: by 2002:a05:620a:209b:: with SMTP id e27mr2603499qka.300.1624655339214;
 Fri, 25 Jun 2021 14:08:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210624082911.5d013e8c@canb.auug.org.au> <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
 <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain> <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
 <20210624185430.692d4b60@canb.auug.org.au> <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
 <20210625084114.4126dd02@canb.auug.org.au>
In-Reply-To: <20210625084114.4126dd02@canb.auug.org.au>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 25 Jun 2021 23:08:47 +0200
Message-ID: <CAPv3WKdDmQ-n9cT_f-PacQ78FmogZyUKFgAh86ye-vaPDz_oNQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

pt., 25 cze 2021 o 00:41 Stephen Rothwell <sfr@canb.auug.org.au> napisa=C5=
=82(a):
>
> Hi Marcin,
>
> On Thu, 24 Jun 2021 16:25:57 +0200 Marcin Wojtas <mw@semihalf.com> wrote:
> >
> > Just to understand correctly - you reverted merge from the local
> > branch (I still see the commits on Dave M's net-next/master). I see a
>
> Yes, I reverted the merge in linux-next only.

Would it be possible to re-integrate 'marvell-mdio-ACPI' branch along
with the 2 fixes that resolve the reported depmod issue?
c88c192dc3ea - net: mdiobus: fix fwnode_mdbiobus_register() fallback case
ac53c26433b5 - net: mdiobus: withdraw fwnode_mdbiobus_register

The first one is needed to apply the second without conflicts.

Best regards,
Marcin

>
> > quick solution, but I'm wondering how I should proceed. Submit a
> > correction patch to the mailing lists against the net-next? Or the
> > branch is going to be reverted and I should resubmit everything as v4?
>
> I see others have answered this.
>
