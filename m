Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9795F286FA0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgJHHiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJHHiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:38:13 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2344C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 00:38:12 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dn5so4793545edb.10
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 00:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7k08qwQfpMwLrbStV7qsIbcIjDaV+hjvgw+XZD6Qe5c=;
        b=hO3HikQGtQ2Glry45pwdFfYKBL3G/BFeYiZ4ZrFTX1i26VTBTwDrvp7Z7eeSOCWfUN
         RLFGiHATP63YeXTRMVeAq/Wdj1owvOmlpmZDzqimdcNvNofGf+f/bAKMGhe7PZJUMq5z
         CG9VlV8pMYis1juIxkqxfapI+2ipJX2+X1TNs6JsE5qZnb47VeZOtIdNDWJc2gajT3Jo
         iqAUN6TaPJ1PLwBudZmOOU1WqrMOaKADTs7ZIXTR58wE6fknEI4bZIfXVEBls70ROb1k
         OYI/izeoLMIh6L5LoFwnzU9RXrG7xs1CIJwkbnunL5HH2qvZ5bMTb2s4JmNPVlXKBrII
         IztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7k08qwQfpMwLrbStV7qsIbcIjDaV+hjvgw+XZD6Qe5c=;
        b=FUlBdlprATUFKfP/eHc+OVP4qxIqkkojcQ1Rovv6kU0D4qMXQhYLF4lugRvZPTSXBf
         7fAe05o7BA2Hg+vFbAu8yoF4SNhiTIpOsIy6J1rUaEc8BCvH5+uYEyewVDJ8THUFjaG2
         /4s3SgEfhVpXsWvpjRdsiqFSisKwY4SWOEhHbzzRR5/PTEf+gIxgLreBSP8ndvBVTDB2
         Q+2DHiJwcnc1dT8oh+hjahAO5XhULcFaeq3W6OjEhmZslB+9nHRpHNTKMMepSEw/njpn
         MmwQSXnMfQ29FpUno57LNY/8n8X/NuUUKo1j3wLS+k1JhNeTUEwL1zQ4ONUcnynv8iEt
         Ub/g==
X-Gm-Message-State: AOAM531J0xqP6iNo3a0ug1+NKG3+mMSoEXzBaLZfYyFRQSNVwhRX1K6c
        PDBxBnOVhfccWdOpxmjEmJuRBSqPkNXWgBiN+rXy0A==
X-Google-Smtp-Source: ABdhPJwo4QUttfuSvz/gaCdR7TaB0KqZkh/iGI19y/GuT1erD6lrNXGl7aYlQ9066o9yHo6Bp3GCOo2Ucv40oJu/kYc=
X-Received: by 2002:a05:6402:31b3:: with SMTP id dj19mr7828444edb.210.1602142691429;
 Thu, 08 Oct 2020 00:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal> <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal> <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal> <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal> <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
 <20201008070032.GG13580@unreal>
In-Reply-To: <20201008070032.GG13580@unreal>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 8 Oct 2020 00:38:00 -0700
Message-ID: <CAPcyv4jUbNaR6zoHdSNf1Rsq7MUp2RvdUtDGrmi5Be6hK_oybg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 12:01 AM Leon Romanovsky <leon@kernel.org> wrote:
[..]
> All stated above is my opinion, it can be different from yours.

Yes, but we need to converge to move this forward. Jason was involved
in the current organization for registration, Greg was angling for
this to be core functionality. I have use cases outside of RDMA and
netdev. Parav was ok with the current organization. The SOF folks
already have a proposed incorporation of it. The argument I am hearing
is that "this registration api seems hard for driver writers" when we
have several driver writers who have already taken a look and can make
it work. If you want to follow on with a simpler wrappers for your use
case, great, but I do not yet see anyone concurring with your opinion
that the current organization is irretrievably broken or too obscure
to use.
