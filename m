Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8607D1D94BC
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgESKu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 06:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgESKu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 06:50:28 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E07C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 03:50:28 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c12so7364062lfc.10
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 03:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tP07PLA+nmU0tpKtqnR9kbRRJZcDtFD1PC9Hg3+2N4=;
        b=XnCkOC24HsEt7dXlix+LtdQcm/hEgpYSflqo1semBo6Tqw8SFGzT6EV8i3Ow99CMXF
         hXP+/cX6I5t3H5djZdfH63sDA9MJQ1tQY05cH/s1jMdP1z0bjbSU0QkBDLftlk7veb2B
         5jUgZOMkSCJZ/YFHHHDJWNIfSKKGPSk/e/A74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tP07PLA+nmU0tpKtqnR9kbRRJZcDtFD1PC9Hg3+2N4=;
        b=azV/fZoNIYuePR9fnl4M69L5a39nAGoqhv4D8y9gq0PWio0vAbUzLMhBCVtk05piqb
         2L/DdirS0s5CGkmhRMlncJeGUvgeK2jA6YqTGwS8RklNsi75ugi9PWBL0wAnMA/sHrHg
         3Nka3UwEFK3YA+VN839BOq1XTObe6RNAEgRdHq7PO880pHdmtficHE5LUop9y98DW4Wx
         odUdOeiblSkREJhDM+SXACLZ0xOlCFaYshdtXBaWGgGVFqb9p0P7HGtWGKarakMfyo1A
         jaPGVC0f4YTTLU6vsJ4NROPuZgQpOKPp4sCJ4w00l+Ek8f6y43aYRg/o+nEs+ToD9bpS
         w5Ww==
X-Gm-Message-State: AOAM533MNYd9Cc5fZfhSNXpFRXMzlpDJHJiFC+b2v3E6zw/E+qiqZZxz
        04K39pIBvewJfVvqMvmKb4em+pVA22S+qFvxWn/I3w==
X-Google-Smtp-Source: ABdhPJwlTbCsFKm8Rxzj+57YVWEGQ3Z1/eWpFCXrUojvdyh0dpzGZZOFhV2ryvjt5FExUp/51Z6C2X0DPGoTbn4nIg0=
X-Received: by 2002:a19:7e15:: with SMTP id z21mr14868588lfc.103.1589885426310;
 Tue, 19 May 2020 03:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho> <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho> <CAACQVJpAYuJJC3tyBkhYkLVQYypuaWEPk_+NhSncAUg2g7h5SQ@mail.gmail.com>
 <20200519073032.GE4655@nanopsycho> <CACKFLinpyX-sgkOMQd=uEVZzn1-+doJoV-t5NRRNrcnE+=tR3A@mail.gmail.com>
 <20200519094132.GG4655@nanopsycho>
In-Reply-To: <20200519094132.GG4655@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 19 May 2020 16:20:14 +0530
Message-ID: <CAACQVJreEC+0XhLAXpY5iPYL3R=Vpd-Bs-YXjRBKapDvfvzcng@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 3:11 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, May 19, 2020 at 10:41:44AM CEST, michael.chan@broadcom.com wrote:
> >On Tue, May 19, 2020 at 12:30 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Tue, May 19, 2020 at 07:43:01AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >> >On Tue, May 19, 2020 at 10:57 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >> >>
> >> >> I don't follow, sorry. Could you be more verbose about what you are
> >> >> trying to achieve here?
> >> >As mentioned below, hot_fw_reset is a device capability similar to roce.
> >> >Capability can be enabled or disabled on the device, if the device supports.
> >> >When enabled and if supported firmware and driver are loaded, user can
> >> >utilise the capability to fw_reset or fw_live_patch.
> >>
> >> I don't undestand what exactly is this supposed to enable/disable. Could
> >> you be more specific?
> >
> >Let me see if I can help clarify.  Here's a little background.  Hot
> >reset is a feature supported by the firmware and requires the
> >coordinated support of all function drivers.  The firmware will only
> >initiate this hot reset when all function drivers can support it.  For
> >example, if one function is running a really old driver that doesn't
> >support it, the firmware will not support this until this old driver
> >gets unloaded or upgraded.  Until then, a PCI reset is needed to reset
> >the firmware.
> >
> >Now, let's say one function driver that normally supports this
> >firmware hot reset now wants to disable this feature.  For example,
> >the function is running a mission critical application and does not
> >want any hot firmware reset that may cause a hiccup during this time.
> >It will use this devlink parameter to disable it.  When the critical
> >app is done, it can then re-enable the parameter.  Of course other
> >functions can also disable it and it is only enabled when all
> >functions have enabled it.
> >
> >Hope this clarifies it.  Thanks.
>
> Okay. So this is about the "allowing to be reseted from the outside".
> I see. For that I think it makes sense to have the devlink param.

> However, I think that it would be fine to find more suitable name and
> describe this properly in the docs.
>
I felt enable_hot_fw_reset is a self-descriptive name.

But to make it more common, is the name enable_live_fw_reset good?
or simply fw_reset?

Thanks.
