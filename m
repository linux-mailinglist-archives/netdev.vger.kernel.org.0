Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8DF33C623
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhCOSuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhCOSuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:50:15 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CA6C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:50:15 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id x78so35543837oix.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qqRczoVpLTWzafBiI495RZCiImOete+xr0LFlQxmYZA=;
        b=Tqjb4A4pnReeEr32TXqBuecuc2zrW3emhPxv7IWHxt16bxaYjJLG6RT/M2ERXpAa4j
         K3EVtrmOU8tXJNg2oQ4ZSeZ44bO1QRZl5E7enWCUchZli1mfJGdhcRfr9g54NHnKjAfw
         Uc0jVdn0KCBOW0G2pK7ExJ65io9rNWCjYUr1CYbz49P2wKJepTosLU4kQg+eH4dcCMa2
         cHa8ClsPMZbNn4Uko446yks9H5V/WFhnzFKyQN2+k6Tknyf1Hx7l6F9uqWLP+qxYOo2r
         bwoloB+vXNH/L+Xivxx+dLcsIqPOswXYzi7ovuyy3l6uG5mb+JV0bV5g/KkHbdTS64at
         Bi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qqRczoVpLTWzafBiI495RZCiImOete+xr0LFlQxmYZA=;
        b=l3R9D8J5coGFG7o6+BoL5G/zmNTTM4eC6HBvMJI6DaUCXxbITdwZ8iyUWTUsRMxjLT
         QVMKV8WmwKanbgJuscF44OQG0iBdadHzFVzKvWH7YY1en0Em0AfWQOqMIs9QuD86f1G9
         3jUi/EVr6liLq6omeL2t8TCvhnkSpMPV4w35ttCsvSEBHUXzAXSgjj/wxWXyN2kTdlj4
         Ltx3+ap5ya6e8MPMBipXUW+mY7poCNtz7/W5DCXPPWVq5TA5Fbm3Y3Vo0JeI/Xqq8975
         sVAlgaBMdtt2Lp/PqaCd7J83EHCJDFn+n78Y0gcfQ/VF3DVPD0Z4CbY4o7WW6H2J94Am
         o14A==
X-Gm-Message-State: AOAM531h1/yBFguTsYaq+8uKy+czQAVU3/Ono28IsuoEduTzQBXaHq3i
        NJFU4i5MepfC0iStuUQUlOSa7/ilsio+w12o5RuDCHiqa3TXiQ==
X-Google-Smtp-Source: ABdhPJxLrQVFP3vGp8TXq8YnWbrQ3Y6JIsYDse4lKHGFM9KB75Ia050YjzXR1p0Eb46xQNhq7LrWPPUoxkoide8rWRo=
X-Received: by 2002:a54:4413:: with SMTP id k19mr396771oiw.72.1615834213868;
 Mon, 15 Mar 2021 11:50:13 -0700 (PDT)
MIME-Version: 1.0
From:   Naveen Mamindlapalli <naveen130617.lkml@gmail.com>
Date:   Tue, 16 Mar 2021 00:19:58 +0530
Message-ID: <CABJS2x7aQaJMC_B34dj+qeiCuAdHheZmSNDpaKpmwpYt4zzstg@mail.gmail.com>
Subject: tc flower offload rule priority
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am new to the tc subsystem and trying to understand tc rule
priorities for hardware offloading. I can see that the tc flower
classifier rules are added with a default priority value of 49152 (low
priority) and then the priority is increased for subsequent rules.
When offloading tc flower rules to HW that supports minimal flow
entries (for example: 128), it will be difficult to maintain the
priorities in the same way tc subsystem expects because there is no
one-to-one mapping between SW and HW.

Is it possible for the NIC driver to modify the default behaviour of
the tc subsystem by using the priority value range specified by the
NIC driver to fit the number of HW entries supported such that
one-to-one mapping can be maintained between tc subsystem priorities
and HW entries?

Thanks,
Naveen
