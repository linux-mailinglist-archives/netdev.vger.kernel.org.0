Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C329533D201
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbhCPKm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbhCPKm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 06:42:27 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15140C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:42:26 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mm21so71218206ejb.12
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=7vrGAYBiFolzOBfsFFI2U/sjQJkAIJNfnZpm/pIQbhc=;
        b=U1AZPUkLW1h/h3O1AGVuBHFkuxORnW3ewO30JIWFH3EGQ4Kg4DX/rcFiR9qxT4ISBD
         ubUE8DiHjbRCy3RNC8oPbva/ke+w3NEPqusI57LvpTdLYCAXn1WHgb8eTvA4siXB49/L
         2L9d9G7+OuNMINpR0/oqGBiUaMDchOHo3iF01NIQ8DqZg1g0peAh+NswFLOe1tGxACRY
         SX6zQ2ZnP6oC8jOgtDD/zbGhxFKPRk0XEFs6H0Qxbs28+mpcKnriSRgiO+KuGcdbdHuW
         stgLMoBudoIenIOmvAr15WUqoOVhQDc3AoHaVROoyNRLgzbhyfnWNiIMlocv9MLoutS5
         w2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=7vrGAYBiFolzOBfsFFI2U/sjQJkAIJNfnZpm/pIQbhc=;
        b=M0mWaYzdbRt/7EBfI9a/CRr89Tns9fPXjZMUqbVixPohYouE3Wnd8Tr0Y5n9hJIalE
         VNDK5vKDRFhVx9YsD4gkYf/Fgmc7owemnyNihmrwhG2V24X7gYjetb2apLnL/vSq8FUt
         0zDWvTKHHIXxttQdupJUiVqyT2Ab5wCU1j+zvBL33FFcCeGPugQq5DN481UcAMoImjGO
         31rEnL+YTpaApfJdHEamCNR+rr+hR31mGmgM+25OO8UwXGeZFMjiM8AlB9Jf/NUJQiTL
         WhZm9As4d8UaEx6n7t9kF+8oqcb0SD3pzuKkYIRvtNri84qBdgJMvVkKKbIadNwVislz
         yjfA==
X-Gm-Message-State: AOAM530hYXOuLZv7qMAkjniCR/lXm6PWfgX2OG6MUiwueh+UwWMpQMtC
        ml/tExoDSluBKvp/mdjt9/etIA==
X-Google-Smtp-Source: ABdhPJxhNXBFZIccli4yepAO7TqT1R1rev+9EwU5qzRtMxjhTn/qDaMTy2xwsTw+aObS2h6BU/LiJg==
X-Received: by 2002:a17:906:a86:: with SMTP id y6mr29434428ejf.354.1615891344823;
        Tue, 16 Mar 2021 03:42:24 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id f9sm10036063eds.41.2021.03.16.03.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 03:42:24 -0700 (PDT)
Date:   Tue, 16 Mar 2021 11:42:23 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210316104223.GA16688@netronome.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
 <YE3GofZN1jAeOyFV@shredder.lan>
 <20210315144155.GA2053@netronome.com>
 <YFBt19zVIH6Dgw8w@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFBt19zVIH6Dgw8w@shredder.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Tue, Mar 16, 2021 at 10:35:35AM +0200, Ido Schimmel wrote:
> Sorry for the delay. Was AFK yesterday

No problem at all.

...

> > > > As follow-ups we plan to provide:
> > > > * Corresponding updates to iproute2
> > > > * Corresponding self tests (which depend on the iproute2 changes)
> > > 
> > > I was about to ask :)
> > > 
> > > FYI, there is this selftest:
> > > tools/testing/selftests/net/forwarding/tc_police.sh
> > > 
> > > Which can be extended to also test packet rate policing
> > 
> > Thanks Ido,
> > 
> > The approach we have taken is to add tests to
> > tools/testing/selftests/tc-testing/tc-tests/actions/police.json
> > 
> > Do you think adding a test to tc_police.sh is also worthwhile? Or should be
> > done instead of updating police.json?
> 
> IIUC, police.json only performs configuration tests. tc_police.sh on the
> other hand, configures a topology, injects traffic and validates that
> the bandwidth after the police action is according to user
> configuration. You can test the software data path by using veth pairs
> or the hardware data path by using physical ports looped to each other.
> 
> So I think that extending both tests is worthwhile.

Thanks, we'll see about making it so.

> > Lastly, my assumption is that the tests should be posted once iproute2
> > changes they depend on have been accepted. Is this correct in your opinion?
> 
> Personally, I prefer selftests to be posted together with the
> implementation, regardless if they depend on new iproute2 functionality.
> In the unlikely case that the kernel patches were accepted, but changes
> were requested for the command line interface, you can always patch the
> selftests later.
> 
> Jakub recently added this section:
> https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-i-post-corresponding-changes-to-user-space-components
> 
> He writes "User space code exercising kernel features should be posted
> alongside kernel patches."
> 
> And you can see that in the example the last patch is a selftest:
> 
> ```
> [PATCH net-next 0/3] net: some feature cover letter
>  └─ [PATCH net-next 1/3] net: some feature prep
>  └─ [PATCH net-next 2/3] net: some feature do it
>  └─ [PATCH net-next 3/3] selftest: net: some feature
> 
> [PATCH iproute2-next] ip: add support for some feature
> ```

Thanks, we'll try to follow this in our next feature submission.

...
