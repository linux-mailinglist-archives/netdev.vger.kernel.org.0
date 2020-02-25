Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB216F260
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgBYWCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgBYWCH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 17:02:07 -0500
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BABEF2467B;
        Tue, 25 Feb 2020 22:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582668126;
        bh=ASA6axefWklSU78pWejTSwer0ZOaWKFTnH47gYDjOZA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CTCD9kg9XuK/5B5/i8D8A/5G6NN6eG+R/lePr4JYYbypdV7FZygukNX4N2vScKNMR
         AcowiA3TsPtPrp9pjfqln0aJMCgno1iOeRyF4hIx8g2f5Ai/mJTN4X1rrllv43N8WQ
         yeXIAeDINI5iDpqzRb+S/V40752h2KdAmsoPsWz0=
Received: by mail-qk1-f182.google.com with SMTP id 11so763049qkd.1;
        Tue, 25 Feb 2020 14:02:06 -0800 (PST)
X-Gm-Message-State: APjAAAXovnpnqOnxO6TIMLj1I1Q7o6ie4wdbK3YAQfHoY7wP6QY/+mQF
        ty23BTDM2NQtFgs0W1Isrn4f1OKezLZdVWydnw==
X-Google-Smtp-Source: APXvYqw5XKZGdHCXY9u0tVRDbjlPaa0iutz4jC8T9d3E9Z8AVXYJLUY39qJiOoxuGit3bif1zq9Awqp6HaEj5QU++i0=
X-Received: by 2002:ae9:f205:: with SMTP id m5mr1310560qkg.152.1582668125762;
 Tue, 25 Feb 2020 14:02:05 -0800 (PST)
MIME-Version: 1.0
References: <20200218171321.30990-1-robh@kernel.org> <20200218171321.30990-7-robh@kernel.org>
 <20200218172000.GF1133@willie-the-truck>
In-Reply-To: <20200218172000.GF1133@willie-the-truck>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 25 Feb 2020 16:01:54 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJn1kG6gah+4318NQfJ4PaS3x3woWEUh08+OTfOcD+1MQ@mail.gmail.com>
Message-ID: <CAL_JsqJn1kG6gah+4318NQfJ4PaS3x3woWEUh08+OTfOcD+1MQ@mail.gmail.com>
Subject: Re: [RFC PATCH 06/11] iommu: arm-smmu: Remove Calxeda secure mode quirk
To:     Will Deacon <will@kernel.org>
Cc:     "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:20 AM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Feb 18, 2020 at 11:13:16AM -0600, Rob Herring wrote:
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Robin Murphy <robin.murphy@arm.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: iommu@lists.linux-foundation.org
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> > Do not apply yet.
>
> Pleeeeease? ;)
>
> >  drivers/iommu/arm-smmu-impl.c | 43 -----------------------------------
> >  1 file changed, 43 deletions(-)
>
> Yes, I'm happy to get rid of this. Sadly, I don't think we can remove
> anything from 'struct arm_smmu_impl' because most implementations fall
> just short of perfect.
>
> Anyway, let me know when I can push the button and I'll queue this in
> the arm-smmu tree.

Seems we're leaving the platform support for now, but I think we never
actually enabled SMMU support. It's not in the dts either in mainline
nor the version I have which should be close to what shipped in
firmware. So as long as Andre agrees, this one is good to apply.

Rob
