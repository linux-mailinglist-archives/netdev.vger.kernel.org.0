Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D283D7EE3
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhG0ULD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhG0ULA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:11:00 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB0DC061765
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:11:00 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id m13so190060iol.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pYkW4Ic29hcBsVSx/qwI1jAVDUeRP7Rfq+D9kuWaOQ8=;
        b=Xz+MUU3hQ0HLkkmPUF3HRE1EKCb5iubkK3JlqWLo7Cqx6xdhFov1LeSmYbbltp5+Ss
         AZXZknAk3fpOPAeRD/93n6QHLqGefW5yDtQ3DX6sCcL7sABJ3Jo5wXe5YdRrVP75W4aP
         lVlCAQxr5wXGJNd+0TjJA6W1FJH9kGAcSyOCtRgDQ5XAq3lunsoMmX3fQjWYfxm8QQPs
         n4v8JCtTraq1WTKCf3HDqtjoJ5bvE1Lqf4z5zzTjPqShp7h4qT2CnXDzbzNbsrcTYCf9
         zpqMidvrB7wFY8o9DQ/ies+Z27SNYsb9eVMHz/OMMYO8oEw58SP586YJOWXnb+JkmiT+
         b2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pYkW4Ic29hcBsVSx/qwI1jAVDUeRP7Rfq+D9kuWaOQ8=;
        b=RCasBuRSjzCL4wAvOoGIjrDSee4Bf7q+BL4gzxNvr9ATqtNb3blV/5Zo+AUE6epMBV
         iw5HK73awTmg4OxtmUUO7datu6FtDxfHALqnm3t/qHtw/GijRoXvlezZDXNUdKmUspGA
         W/l/KxuvxWubLDyzy1wMvuWLThlZsbH2JE6a8WcsN78jqTZH6qNtUDjq/A0lGBVjY/9o
         W0JSLY5Z408S2djTd/sk2LvDa5tYuFGoyO4w3T5DlHF26aHFxLKTO9WfUY0o8Fe4/Ead
         JJ+vRtUlKGeti3MhYpWEnH74kqcg3mIqSBxjXtAgDvMfvg1eSLCVEchikxVYDwCUBXQN
         0D1A==
X-Gm-Message-State: AOAM531qVWDROAQ/iar9NvDiteZbe5PpFVcLyUEmiBRJSgHNOQZi9Bne
        I/eKXVYYCrGRqZnw/O7snDbZ3v4uAETcmJr2otGWQw==
X-Google-Smtp-Source: ABdhPJyPN5lBwmUY/0+NCAByK+2k9DtCTFwNKOPNUV0gGf8Os9/8jXmz2yOsV1DVFh/4KemFBgpXMZpLJU+8G0ToouU=
X-Received: by 2002:a05:6602:134b:: with SMTP id i11mr10859001iov.81.1627416659698;
 Tue, 27 Jul 2021 13:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-6-gerhard@engleder-embedded.com> <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
In-Reply-To: <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 27 Jul 2021 22:10:48 +0200
Message-ID: <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN endpoint
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 1:41 AM Rob Herring <robh+dt@kernel.org> wrote:
> > +       compatible = "engleder,zynqmp-tsnep", "xlnx,zynqmp-zcu104-revC",
> > +                    "xlnx,zynqmp-zcu104", "xlnx,zynqmp";
>
> I don't think this will pass schema validation.

You are right. I did rerun the validation and now I see the error.

> In general, do we need a new top-level compatible for every possible
> FPGA image? Shouldn't this be an overlay?

All the devices I have dealt with so far had just a single FPGA image.
There were no dynamic selection of the FPGA image or partial
reconfiguration of the FPGA. So the FPGA image could be seen as part
of the schematics. In this case the FPGA image stuff shall be in the
device tree of the device. For me the question is: Does this combination
of evaluation boards with its own FPGA image form a new device?

The evaluation platform is based on ZCU104. The difference is not
only the FPGA image. Also a FMC extension card with Ethernet PHYs is
needed. So also the physical hardware is different.

From my point of view it is a separate hardware platform with its own
device tree. It's purpose is to show two tsnep Ethernet controllers in
action. So far it worked good for me to see the FPGA image as part of
the schematics like the list of devices on the SPI bus. No special handling
just because an FPGA is used, which in the end is not relevant for the
software because software cannot and need not differentiate between
normal hardware and FPGA based hardware.

But I also understand the view of just another FPGA image for an existing
hardware.

My goal is to get all necessary stuff, which is needed to run the evaluation
platform, into mainline. I must confess, I have not thought about using an
overlay. Is it right that overlays are not part of the kernel tree?

Gerhard
