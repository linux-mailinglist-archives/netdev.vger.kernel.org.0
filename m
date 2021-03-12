Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C3A338411
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCLCxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhCLCx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 21:53:28 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DEFC061574;
        Thu, 11 Mar 2021 18:53:28 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id y20so5905934iot.4;
        Thu, 11 Mar 2021 18:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3r2VmurgsZAdK+mJ/SSuYF0DS4iZlEJSrc+E9dLuQLw=;
        b=WMBIg04QmQOavkO2RGio47QGbtUWuB/YTAjHEpShOqSl0D10HYLGZDVeyOm6yT2QEa
         yiBL+G3ItjoJOr2nPTjKSWW7XQn0w5/WKkVwEvydsLFLEuRFRstpPAIi/9OtVnWOgC4W
         BFTuocVS47QR0KLlJ2X5ivBlfj5VLti/7mXcUpuwtl4omkeXe5AaetjAIufeLuC0YSjr
         g8vfm7HhiK+QYf2oV4XCWWBWdCOcBd3jMs/4ORBIvBOQZxr/93fHBUHqEDR/5rWMghRb
         4Ekrbeabdy/3qAcQ8dkb3tSy90TqP9gcjaufsj+GhJ9OAb84/noIh8MnIJbyBg4GqlEZ
         UBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3r2VmurgsZAdK+mJ/SSuYF0DS4iZlEJSrc+E9dLuQLw=;
        b=t36LDTOpSCZNm+RU/7MsMXjWqnpD+HSdfc70Qr5ej06sPNaFsjo7jlQhC/NifthDiZ
         mmRtAd/NFHuYb1gtnnJ/6eUjXSSJeoN/EduZIn4JpLUhuZaY0c7DlEpq7ku5ig0j9S/0
         mRUts1c1IkvLdsAkCUrVE6STXOzf+t9Yb1NMixHRwwvBZ/yqFx7sSwwr6Cft04K/h85i
         w5g5kIHJeaAZ83ubJi7JOGbsHdeu74SFP/c532sJxo+AfPi9HwyXlvE7HlD92H025tZ3
         68zU6qyXWliItMBdbtLjZ4v3zQhOUd/9ec58XO8oTp+OZj0B682vt+g8Os1jLVnSBw9G
         q26Q==
X-Gm-Message-State: AOAM530WmTBAodQnhix7PRwewUopSoCl5vtMzfx8nnHnSitb1FO4cYaO
        TlTHli8d6eZKHaMlQdFA0g1A2BtGJCbV6VLHovI=
X-Google-Smtp-Source: ABdhPJxVIUgAKs03auIcdOplshnX6MKD+0QQ6cYavZhwX6ZokUV7aSSkmZejE50Sf5kZZqECq9Or+iMRrVBA9Z9xpVA=
X-Received: by 2002:a6b:f909:: with SMTP id j9mr8705979iog.138.1615517607777;
 Thu, 11 Mar 2021 18:53:27 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520> <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com> <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
 <20210311232059.GR2356281@nvidia.com>
In-Reply-To: <20210311232059.GR2356281@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Mar 2021 18:53:16 -0800
Message-ID: <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 3:21 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Mar 11, 2021 at 01:49:24PM -0800, Alexander Duyck wrote:
> > > We don't need to invent new locks and new complexity for something
> > > that is trivially solved already.
> >
> > I am not wanting a new lock. What I am wanting is a way to mark the VF
> > as being stale/offline while we are performing the update. With that
> > we would be able to apply similar logic to any changes in the future.
>
> I think we should hold off doing this until someone comes up with HW
> that needs it. The response time here is microseconds, it is not worth
> any complexity

I disagree. Take a look at section 8.5.3 in the NVMe document that was
linked to earlier:
https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4a-2020.03.09-Ratified.pdf

This is exactly what they are doing and I think it makes a ton of
sense. Basically the VF has to be taken "offline" before you are
allowed to start changing resources on it. It would basically consist
of one extra sysfs file and has additional uses beyond just the
configuration of MSI-X vectors.

We would just have to add one additional sysfs file, maybe modify the
"dead" device flag to be "offline", and we could make this work with
minimal changes to the patch set you already have. We could probably
toggle to "offline" while holding just the VF lock. To toggle the VF
back to being "online" we might need to take the PF device lock since
it is ultimately responsible for guaranteeing we have the resources.

Another way to think of this is that we are essentially pulling a
device back after we have already allocated the VFs and we are
reconfiguring it before pushing it back out for usage. Having a flag
that we could set on the VF device to say it is "under
construction"/modification/"not ready for use" would be quite useful I
would think.
