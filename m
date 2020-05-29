Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945151E803A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgE2O37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgE2O37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 10:29:59 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54EDC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 07:29:58 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id k5so2819960lji.11
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 07:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9u0uFNB7ZJrCyALKgjRqGLnzcswECA60KRpcNOS/ygs=;
        b=Ln7jL8vNE0MiXdzhlQhQVy0lS+fP3wz9cTC5bcsz86ko62Gcp2FZNAVKsXAegjJC3+
         S/mUOP6hoOfOAiGXQRm2PRuMJEASkQoam0EvogP+C3Xjf97naVDAAOhySxH1p+DqtacY
         zB/DX99C7tw4kIyOTJy7Bh2GJfPvgeTQakQpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9u0uFNB7ZJrCyALKgjRqGLnzcswECA60KRpcNOS/ygs=;
        b=kznghYTu3+RBTTjk/k1MkiPcHbPa8RWWeWk9tFmvfYiMyA82p1mAXodV/blqFvQCIr
         SK+ko+Du2RnM3eg6LLR5UwQPohWL8HhuJteaYhcYtbNZkuYcxjtK9j8/LJCJjNlV5TIh
         XSmHbJ/7SVhIKhQPBdGlWjAbmMghdp2ukhh+Z17cfDjs+4KKNQCb/RdrRfvcUn92UvkI
         WT9AbcbLW25rAzlVFRWlXc9gVw8dLO9TUUZEspwqjT1O5spccy9p3XzMpcn+aduqYMWd
         yO7XpIdswlonUgMtqF2UCvwefpe8Goc5Q/6DDJec76SyRdYExLEZDSElkTa+SuueBXBk
         XqOg==
X-Gm-Message-State: AOAM531hLYQppncw3rTyTeF8KBN7rZ7f1+uaZsm6FV+Fv36iBzCIVwXa
        EHR2rwWh60xxWVBJAO/IRVx/uqoPB4wo6jrX/USQGsn6
X-Google-Smtp-Source: ABdhPJzlO3T9WiF+EBEQtalQhQcLrVxi0dy/PnbsOw6CxB1ARRp43kspKWIRIBgeWAYcZw2O2PsJAlMUjKiDx9YPUmc=
X-Received: by 2002:a2e:8154:: with SMTP id t20mr4350316ljg.326.1590762597054;
 Fri, 29 May 2020 07:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200524045335.GA22938@nanopsycho> <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho> <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho> <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho> <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
 <20200527141608.3c96f618@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAACQVJqs9=PJ5UBrW9R9UmVYX1jqkJvZWj3j6FmVB9S5mOn+mg@mail.gmail.com> <20200528120551.689251bf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200528120551.689251bf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Fri, 29 May 2020 19:59:45 +0530
Message-ID: <CAACQVJoi-KKxxWZxoRx-tyn=88TWxA5D_dqcW0yEG+4GDEj6pw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:35 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 28 May 2020 07:20:00 +0530 Vasundhara Volam wrote:
> > > > The permanent value should be the NVRAM value.  If the NVRAM value is
> > > > false, the feature is always and unconditionally disabled.  If the
> > > > permanent value is true, the feature will only be available when all
> > > > loaded drivers indicate support for it and set the runtime value to
> > > > true.  If an old driver is loaded afterwards, it wouldn't indicate
> > > > support for this feature and it wouldn't set the runtime value to
> > > > true.  So the feature will not be available until the old driver is
> > > > unloaded or upgraded.
> > >
> > > Setting this permanent value to false makes the FW's life easier?
> >
> > It just disables the feature.
> >
> > > Otherwise why not always have it enabled and just depend on hosts
> > > not opting in?
> >
> > We are providing permanent value as a flexibility to user. We can
> > remove it, if it makes things easy and clear.
>
> I'd think less knobs means less to understand for the user and less
> to test for the vendor. If disabling the feature doesn't buy FW
> anything then perhaps it can just serve the purpose of setting the
> default?
>
> > > > > > 3. Now enable the capability in the device and reboot for device to
> > > > > > enable the capability. Firmware does not get reset just by setting the
> > > > > > param to true.
> > > > > >
> > > > > > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> > > > > > value true cmode permanent
> > > > > >
> > > > > > 4. After reboot, values of param.
> > > > >
> > > > > Is the reboot required here?
> > > >
> > > > In general, our new NVRAM permanent parameters will take effect after
> > > > reset (or reboot).
> > > >
> > > > > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > > > > > pci/0000:3b:00.1:
> > > > > >   name allow_fw_live_reset type generic
> > > > > >     values:
> > > > > >       cmode runtime value true
> > > > >
> > > > > Why is runtime value true now?
> > > > >
> > > >
> > > > If the permanent (NVRAM) parameter is true, all loaded new drivers
> > > > will indicate support for this feature and set the runtime value to
> > > > true by default.  The runtime value would not be true if any loaded
> > > > driver is too old or has set the runtime value to false.
> > >
> > > Okay, the parameter has a bit of a dual role as it controls whether the
> > > feature is available (false -> true transition requiring a reset/reboot)
> > > and the default setting of the runtime parameter. Let's document that
> > > more clearly.
> > Please look at the 3/4 patch for more documentation in the bnxt.rst
> > file. We can add more documentation, if needed, in the bnxt.rst file.
>
> Ack, I read that, but it wasn't nearly clear enough. The command
> examples helped much more.  I think the doc should be expanded.
Thank you for looking into it. I will soon send out the next version
of patchset with expanded documentation and param is split into two
with better renaming.

Thanks.
