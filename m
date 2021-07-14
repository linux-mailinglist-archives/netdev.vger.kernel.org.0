Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A9B3C821A
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbhGNJzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:55:25 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:38404
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238954AbhGNJzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:55:25 -0400
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 5966D40562
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 09:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626256351;
        bh=80zXfnJOV6lMeG5E5RjQ3UMMrg6S4mJKlz3aPhaJln4=;
        h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type;
        b=MJVL1E7f4cVZn4DDpqfig9e7WeOFR2h5wX3mWyojjMstVHRgeT+2zOuyhAWD2Mjfb
         Q2acS3cd4pvgag/CKj8/1X086KYgM9AYPx5GXB9HOSfizTX5SyVA2DMGi2BJ+G7gkA
         O9xmo+1DU8StsHz8oxXOHi2eXjOp0kGBlyYZmIvpXkmy1aP7JqwyNmTiQFosB4XHYy
         d5xzeMt3GO69Vb52Q5z+AO+by0L7TeHOYtgdZ1DejBTiMbtLqaDrNNRFOaSvsQX0vc
         bPmfKXlFJgvIpCvj5z47sb7WRLOGwWRSCre14M3usXAY12ji7EsnibQBhK2UH+Gqb1
         5MDZKh2rf4nqA==
Received: by mail-ej1-f70.google.com with SMTP id g6-20020a1709063b06b029051a448bab28so567416ejf.17
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=80zXfnJOV6lMeG5E5RjQ3UMMrg6S4mJKlz3aPhaJln4=;
        b=ettegTDgbs0KIJ2GQ6PVU+EyqrXzUMoeL7T4/cptA5TsGUgmPr90XNOzRIdBKWjAPH
         Y4u2Q2Zo1UUlN8N+3fu5hWMf8Ys4vLYDKmGwycrtl+0pGncElRmqKRirW0TALwDHQ44j
         VISdIkCRxg7LODvtEtpGOTgAa9bMlAj6hF8AwiVsrenwcWBCbHz46ewClXKJLDqyLDYO
         qfLhdHwlYOdKcIgkgN3qFg1rTkpINHSygLVRonK07NxWdcOCWO2xuNhKWoB7zDpcGxH8
         TcgmHA5qMtcUueK36ZElaE78a1ASdQPixfAjiL7O+eNWml3tz/u8do99AUOYV0PT5BRS
         cAhQ==
X-Gm-Message-State: AOAM533uorS8Jac5QXWyS+OFbmQCbZOPqzhqlgw3U/QzsWuR4H1CTx3j
        ZAYX4TyYACtXWRGnEagLgjLznp005uCxGbNwx1xn+Ksl0JjhN3VPDtnULV115HxcpIljCVQRea3
        lYyCdN7OQSvsx4qFkybsNUpOJzy9lt1vVKvSkNOoAyPDy40LXGg==
X-Received: by 2002:a17:906:17c2:: with SMTP id u2mr2167081eje.117.1626256351024;
        Wed, 14 Jul 2021 02:52:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6o86w5XcTXx0rweh1OQO8vQJqb2pD8eu/0VlUBpbyR5Fo/OYq0Lk+k1MJzySGibta0hOHd2nc95S32JqueFc=
X-Received: by 2002:a17:906:17c2:: with SMTP id u2mr2167061eje.117.1626256350762;
 Wed, 14 Jul 2021 02:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
 <20210712133500.1126371-2-kai.heng.feng@canonical.com> <3947d70a-58d0-df93-24f1-1899fd567534@intel.com>
 <CAAd53p79BwxPGRECYGrpCQbSJz8NY2WrG+AJCuaj89XNqCy59Q@mail.gmail.com> <16e188d5-f06e-23dc-2f71-c935240dd3b4@intel.com>
In-Reply-To: <16e188d5-f06e-23dc-2f71-c935240dd3b4@intel.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 14 Jul 2021 17:52:18 +0800
Message-ID: <CAAd53p5Pyk80c0FjmqF9cjicNF8t0eTC7Y3BP-rWqW3O53K1Mg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/3] e1000e: Make mei_me active when
 e1000e is in use
To:     "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
Cc:     Sasha Neftin <sasha.neftin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        AceLan Kao <acelan.kao@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        devora.fuxbrumer@intel.com, alexander.usyskin@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 5:06 PM Ruinskiy, Dima <dima.ruinskiy@intel.com> wrote:
>
> On 14/07/2021 9:28, Kai-Heng Feng wrote:
> >> I do not know how MEI driver affect 1Gbe driver - so, I would suggest to
> >> involve our CSME engineer (alexander.usyskin@intel.com) and try to
> >> investigate this problem.
> >> Does this problem observed on Dell systems? As I heard no reproduction
> >> on Intel's RVP platform.
> >> Another question: does disable mei_me runpm solve your problem?
> >
> > Yes, disabling runpm on mei_me can workaround the issue, and that's
> > essentially what this patch does by adding DL_FLAG_PM_RUNTIME |
> > DL_FLAG_RPM_ACTIVE flag.
> >
> > Kai-Heng
> Hi, Kai-Heng,
>
> If the goal of the patch is to essentially disable runpm on mei_me, then
> why is the patch touching code in the e1000e driver?

We can put the workaround in e1000e, mei_me or as PCI quirk.
But since the bug itself manifests in e1000e, I think it's more
appropriate to put it here.

To be more specific, it doesn't disable runtime suspend on mei_me, it
makes mei_me the power supplier of e1000e.
So when e1000e can be runtime suspended (i.e. no link partner), mei_me
can also get runtime suspended too.

>
> I agree with Sasha Neftin; it seems like the wrong location, and the
> wrong way to do it, even if it currently works. We need to understand
> what causes runpm of mei_me to adversely affect LAN Rx, and for this we
> need the involvement of mei_me owners.

I think it's the right location, however I totally agree with your
other arguments.
There are many users already affected by this bug, so if a proper fix
isn't available for now, the temporary workaround can help here.

Kai-Heng

>
> --Dima
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
