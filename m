Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B924A6853
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 00:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiBAXBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 18:01:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234815AbiBAXBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 18:01:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643756470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZQsFy9xaSL/C+8tHxnl069hXf8XB97MOyjVaLm6KWA=;
        b=gPL4po6fTkOJxZ3jS15cGUu9Hk4q4r600itP89dn9uTHPjB3reWGyPK9Nv3NSjGTak+ciJ
        bCocr7JzzMNLljAZnH/TsI2y7nXpgRyw8O0Jj/SqFxjk7UoVPDh+63/z03cEbLg2E+8Sr0
        ZPwrUK+Y8pA2PRi98IohowQrzW8UNIw=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-n_gIf7J6Nb6fpckIRTPKUg-1; Tue, 01 Feb 2022 18:01:09 -0500
X-MC-Unique: n_gIf7J6Nb6fpckIRTPKUg-1
Received: by mail-oo1-f71.google.com with SMTP id h19-20020a4a6f13000000b002e3c2ae2affso7460535ooc.3
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 15:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZZQsFy9xaSL/C+8tHxnl069hXf8XB97MOyjVaLm6KWA=;
        b=OMAKT+mdK1SX6TVX1QNU+f7IPj/d2Rn2HfQ+R9aHB+6Toscs80KM3s7fogKBIbOL8c
         pvnAwqPOWk2ebPqHwfw4gX5b7Fu4+JvUYGMdU3fUurkc3MIdHQKFVlX/Dy+fFBjHrvjB
         2oB8iHgCOEqjKxUiQBaJBSMlN9jGkErjY1DIlqegCDlYZkO6dWpYZ370wuTfBVwjHTzV
         rtvzcEBad7uWf+bKpVZlkn/vDlH1dMhh0wG9NyNGGibPjip8OAurwvQw2LUHgtbHeErb
         P1kUQ0uRjycuZn0IEAg5a/E+ZDqG3Clkq9/8PgaGxO3Y5Jj4TDIr5g/vD8F/yD56/nw8
         b5LQ==
X-Gm-Message-State: AOAM531pq4ug7KW0wDEa25WA41thMKf8s84nM8l2iVhx+m5bIldOeN7s
        Aw6JhZ3OfLnamN9OGbMKDuX3A9jFIjdkIgXQwLVqhEecp9MZZe0Jovn4TPOZqt71lyTeAd079Cp
        Ch3N1V3NhfBhKa5Qk
X-Received: by 2002:a05:6808:20a7:: with SMTP id s39mr2718312oiw.306.1643756468633;
        Tue, 01 Feb 2022 15:01:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcB506OEAhqOJI745n4wG5GysVpVVMM9JD8hrzIrz8J+sFhUk3i/Fjf/mS8Hij0DFXWZZ5bQ==
X-Received: by 2002:a05:6808:20a7:: with SMTP id s39mr2718298oiw.306.1643756468405;
        Tue, 01 Feb 2022 15:01:08 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bf15sm1581295oib.32.2022.02.01.15.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 15:01:08 -0800 (PST)
Date:   Tue, 1 Feb 2022 16:01:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Message-ID: <20220201160106.0760bfea.alex.williamson@redhat.com>
In-Reply-To: <87sft2yd50.fsf@redhat.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
        <20220130160826.32449-11-yishaih@nvidia.com>
        <874k5izv8m.fsf@redhat.com>
        <20220201121325.GB1786498@nvidia.com>
        <87sft2yd50.fsf@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Feb 2022 13:39:23 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Feb 01, 2022 at 12:23:05PM +0100, Cornelia Huck wrote:  
> >> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> >>   
> >> > From: Jason Gunthorpe <jgg@nvidia.com>
> >> >
> >> > v1 was never implemented and is replaced by v2.
> >> >
> >> > The old uAPI definitions are removed from the header file. As per Linus's
> >> > past remarks we do not have a hard requirement to retain compilation
> >> > compatibility in uapi headers and qemu is already following Linus's
> >> > preferred model of copying the kernel headers.  
> >> 
> >> If we are all in agreement that we will replace v1 with v2 (and I think
> >> we are), we probably should remove the x-enable-migration stuff in QEMU
> >> sooner rather than later, to avoid leaving a trap for the next
> >> unsuspecting person trying to update the headers.  
> >
> > Once we have agreement on the kernel patch we plan to send a QEMU
> > patch making it support the v2 interface and the migration
> > non-experimental. We are also working to fixing the error paths, at
> > least least within the limitations of the current qemu design.  
> 
> I'd argue that just ripping out the old interface first would be easier,
> as it does not require us to synchronize with a headers sync (and does
> not require to synchronize a headers sync with ripping it out...)
> 
> > The v1 support should remain in old releases as it is being used in
> > the field "experimentally".  
> 
> Of course; it would be hard to rip it out retroactively :)
> 
> But it should really be gone in QEMU 7.0.
> 
> Considering adding the v2 uapi, we might get unlucky: The Linux 5.18
> merge window will likely be in mid-late March (and we cannot run a
> headers sync before the patches hit Linus' tree), while QEMU 7.0 will
> likely enter freeze in mid-late March as well. So there's a non-zero
> chance that the new uapi will need to be deferred to 7.1.


Agreed that v1 migration TYPE/SUBTYPE should live in infamy as
reserved, but I'm not sure why we need to make the rest of it a big
complicated problem.  On one hand, leaving stubs for the necessary
structure and macros until QEMU gets updated doesn't seem so terrible.
Nor actually does letting the next QEMU header update cause build
breakages, which would probably frustrate the person submitting that
update, but it's not like QEMU hasn't done selective header updates in
the past.  The former is probably the more friendly approach if we
don't outrage someone in the kernel community in the meantime.  Thanks,

Alex

