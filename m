Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B308D06C8
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfJIEz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:55:59 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46312 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbfJIEz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:55:59 -0400
Received: by mail-lj1-f194.google.com with SMTP id d1so1014458ljl.13
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 21:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dmPKr131nIsNPoeVpe8TkHDELaEVw6Q7baEshbiRmj4=;
        b=Naorriegbb1b5jyd0y2aq6geF/UNE6hTuPngQi/70qkPRasS4umjEV44UrfXIsBUuD
         WQlO5rmkOf5wU41396gEJZe1cWJqBe9klYMrVYB4EektDiL1/JLZoTlUgsBABGaymV/x
         S/HOBk3r6Gn9rDH99Z5EWBVo/2m6+PrKzFBvE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dmPKr131nIsNPoeVpe8TkHDELaEVw6Q7baEshbiRmj4=;
        b=NRUtQ5vXCo0AgFRLql2PhDNnyUiLDUgPGhNrBpMYUEd2sYHSznh68cH5w2wKvZSKk1
         1ZiKu+96mXtSd9pohD1lksSLcHKT8S4djy22ADzPCqwbdnz578pbgLhgyhgBdQNM2rwp
         MCS7+/Pfm5cb7lTKnT3sSj58MGtAfdgLbBqVhire6K15s1Hvl3PaGbM9jFvA5N4rxHqX
         L+bq0F+IsVs2ODpA+pgIZOoShvAByFh58UjFk0b7sEm6bwBp7UqOlB+1j3XOzyW8VRLe
         +Acz6M+oKTgZydzXPqus/aElTYjLm3Sav+8kXsIDmVKjChEVnjKqMw+gRoXYDRWTod+X
         sEQQ==
X-Gm-Message-State: APjAAAX5YApTvUxVHardz3lB6NPZsQJNjMe8XuaGP3LwycYwvcVLT4/0
        rORA9jPhBFoH/tIkzXEFoIG1RUwuholZInSaPq9lnA==
X-Google-Smtp-Source: APXvYqxRYbJlzsodphQIGeavL//YU3n8hbr7EXdMFwJDNZkIM288TrAHRJNBp5u6oIIIOf/fy/nTdfRQLkvuFYPOYFI=
X-Received: by 2002:a2e:584b:: with SMTP id x11mr1078601ljd.90.1570596957294;
 Tue, 08 Oct 2019 21:55:57 -0700 (PDT)
MIME-Version: 1.0
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
 <1567137305-5853-15-git-send-email-michael.chan@broadcom.com> <20191007095623.GA2326@nanopsycho>
In-Reply-To: <20191007095623.GA2326@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 9 Oct 2019 10:25:45 +0530
Message-ID: <CAACQVJrBLsdnQKcOzWD5UNydFGoBHus1V_2Xxm=yL1zMb_KBQA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 14/22] bnxt_en: Add new FW devlink_health_reporter
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Ray Jui <ray.jui@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>, ayal@mellanox.com,
        Moshe Shemesh <moshe@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 3:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Fri, Aug 30, 2019 at 05:54:57AM CEST, michael.chan@broadcom.com wrote:
> >From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >
> >Create new FW devlink_health_reporter, to know the current health
> >status of FW.
> >
> >Command example and output:
> >$ devlink health show pci/0000:af:00.0 reporter fw
> >
> >pci/0000:af:00.0:
> >  name fw
> >    state healthy error 0 recover 0
> >
> > FW status: Healthy; Reset count: 1
>
> I'm puzzled how did you get this output, since you put "FW status" into
> "diagnose" callback fmsg and that is called upon "devlink health diagnose".
>
> [...]
Jiri, you are right last line is output of diagnose command. Command
is missing here.

$ devlink health diagnose pci/0000:af:00.0 reporter fw
 FW status: Healthy; Reset count: 0

>
> >+static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
> >+                                   struct devlink_fmsg *fmsg)
> >+{
> >+      struct bnxt *bp = devlink_health_reporter_priv(reporter);
> >+      struct bnxt_fw_health *health = bp->fw_health;
> >+      u32 val, health_status;
> >+      int rc;
> >+
> >+      if (!health || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
> >+              return 0;
> >+
> >+      val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
> >+      health_status = val & 0xffff;
> >+
> >+      if (health_status == BNXT_FW_STATUS_HEALTHY) {
> >+              rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
> >+                                                "Healthy;");
>
> First of all, the ";" is just wrong. You should put plain string if
> anything. You are trying to format user output here. Don't do that
> please.
>
> Please see json output:
> $ devlink health show pci/0000:af:00.0 reporter fw -j -p
>
> Please remove ";" from the strings.
Okay, I will send a patch for removing ";"

>
>
> Second, I do not understand why you need this "FW status" at all. The
> reporter itself has state healthy/error:
> pci/0000:af:00.0:
>   name fw
>     state healthy error 0 recover 0
>           ^^^^^^^
>
> "FW" is redundant of course as the reporter name is "fw".
>
> Please remove "FW status" and replace with some pair indicating the
> actual error state.
Okay, I can rename to "Status description" so that "FW" name will not
be repeated.

>
> In mlx5 they call it "Description".
>
>
> >+              if (rc)
> >+                      return rc;
> >+      } else if (health_status < BNXT_FW_STATUS_HEALTHY) {
> >+              rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
> >+                                                "Not yet completed initialization;");
> >+              if (rc)
> >+                      return rc;
> >+      } else if (health_status > BNXT_FW_STATUS_HEALTHY) {
> >+              rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
> >+                                                "Encountered fatal error and cannot recover;");
> >+              if (rc)
> >+                      return rc;
> >+      }
> >+
> >+      if (val >> 16) {
> >+              rc = devlink_fmsg_u32_pair_put(fmsg, "Error", val >> 16);
>
> Perhaps rather call this "Error code"?
Okay.

>
>
> >+              if (rc)
> >+                      return rc;
> >+      }
> >+
> >+      val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
> >+      rc = devlink_fmsg_u32_pair_put(fmsg, "Reset count", val);
>
> What is this counter counting? Number of recoveries?
> If so, that is also already counted internally by devlink.
"Reset count" is the counter that displays the number of times
firmware has gone for
reset through different mechanisms and devlink is one of it. Firmware
could have gone
for a reset through other tools as well.

Driver gets the information from firmware health register, when
diagnose command is invoked.

>
> [...]
