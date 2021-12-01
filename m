Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EAD465829
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 22:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343835AbhLAVNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 16:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240571AbhLAVNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 16:13:02 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C9FC061574;
        Wed,  1 Dec 2021 13:09:40 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id o1so51831804uap.4;
        Wed, 01 Dec 2021 13:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLswCNaB0dvmiFI+RfcOFXjnesbwmPDUqOC4Q2nOO8Y=;
        b=XEuQXfKk+XKSRnMgWtSpsrrSdYL/VGKiZIzzbKz4rmU1spbHgjho8OpdBVDLYNqQjq
         XK/nCQySM6jIwWE7qSrCdTv0Y60OLTA4FHHhngZnT/EM2ErQHkmo0GTu6/E9d7ijqOgU
         E6dmFeFOjCp4O7LdB5WydQ8Of0/yGexAE3D2h/SdHOL1R4Mo1pSjzBY44pr74eQW0MEG
         kH+0BDW2KvvliuFwVaz44J8mC8qNhO0RBeaImUDcEJ3mcxmxcnUwdKQxWF7HFqz5Eob4
         t7Obi+PhgLq0Okjt26elAVcd/eSM+LEx2T3J+ZW9JYcrqmsvSYUM5NqDKXxmkk6wA0qm
         aybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLswCNaB0dvmiFI+RfcOFXjnesbwmPDUqOC4Q2nOO8Y=;
        b=Ce5ZovL4GFZyE9JUFiwfW7elTtdgfy85pMWfnEe8Fg7b5esfHkiIqVgBF9JM8Mazvj
         Dsu5tkGmdQb7vUj+O4FHA7kjQXgyIuFAoLKsf+gWeyXDYa85Sk4bHsR3kBsdmI5Mraju
         Pexk5lDqrffEiR9CIfTEOtq4sRtUoGtbRH10OhFGvJ/YbzjtcR9UdHHVpJBv+j2XfwHB
         t4KekZYPjqnH5VTyoXNpCWLrvUk3GkQDX0DT1LTIj2KtW/aEwekjWP/rnRNkRk68HS0O
         pXAxStL24HuxaUiBjA5Bq2uYhpTwjiNQVIM+4RvACOUsTjftxlUvqUjt9ExLAHcxgoiV
         jBKg==
X-Gm-Message-State: AOAM533F2do5s16Bo68tv/cH2KLOitpKK05fbyp9hOlgL+p5xq0dIrjS
        H8dKuZc/r8sorla1HenEo08iECc5Afz7L1cE38E=
X-Google-Smtp-Source: ABdhPJxnc3aVhuPC7POprq58/+lsjDQx8r+uxpPRh4KBjMOGWlRH73k5R2gPyh9IhTCawg403hbsQhcCr2OdVq6L4Ac=
X-Received: by 2002:a67:c29a:: with SMTP id k26mr11284962vsj.32.1638392979882;
 Wed, 01 Dec 2021 13:09:39 -0800 (PST)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-10-ricardo.martinez@linux.intel.com>
 <CAHNKnsTAj8OHzoyK3SHhA_yXJrqc38bYmY6pYZf9fwUemcK7iQ@mail.gmail.com> <5755abe9-7b3c-0361-4eea-e0c125811eae@linux.intel.com>
In-Reply-To: <5755abe9-7b3c-0361-4eea-e0c125811eae@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 2 Dec 2021 00:09:28 +0300
Message-ID: <CAHNKnsTARNNeiCBtDxmiMx2gUkKDb-V3e+xtfgsc-imeWv0CLA@mail.gmail.com>
Subject: Re: [PATCH v2 09/14] net: wwan: t7xx: Add WWAN network interface
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 9:06 AM Martinez, Ricardo
<ricardo.martinez@linux.intel.com> wrote:
> On 11/6/2021 11:08 AM, Sergey Ryazanov wrote:
>> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez wrote:
>>> +#define IPV4_VERSION           0x40
>>> +#define IPV6_VERSION           0x60
>>
>> Just curious why the _VERSION suffix? Why not, for example, PKT_TYPE_ prefix?
>
> Nothing special about _VERSION, but it does look a bit weird, will use
> PKT_TYPE_  as suggested

I checked the driver code again and found that these constants are
really used to distinguish between IPv4 and IPv6 packets by checking
the first byte of the data packet (IP header version field).

Now I am wondering, does the modem firmware report a packet type in
one of the BAT or PIT headers? If the modem is already reporting a
packet type, then it is better to use the provided information instead
of touching the packet data. Otherwise, if the modem does not
explicitly report a packet type, and you have to check the version
field of the IP header, then it seems Ok to keep the names of these
constants as they are (with the _VERSION suffix).

-- 
Sergey
