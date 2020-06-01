Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9091EA065
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 10:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgFAI6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 04:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFAI6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 04:58:23 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FFEC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 01:58:22 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c11so7177609ljn.2
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 01:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GeWOD0rEiNE3biMnBSTXn0BpAA5TUIjGyRINumfdZkE=;
        b=MoVFuD1z96bI2zMWahs1zdS03PtMNckhsquUqKmyrbTLqPDZ1Ru0xBpYgTQtAun2e6
         GrrQSthcqgCRAVv2MATdYgcMP5sEKtFsj1yzWCIiKnpZ7rNA5Q4kWy2taGH0HN+/Ukia
         /QYuaU35k8Kw+xgT3WE3Q9ukb4UbCZLZ+e8UI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GeWOD0rEiNE3biMnBSTXn0BpAA5TUIjGyRINumfdZkE=;
        b=L6dwio1/OSo2wZp20owe3Wqp40umwnVNVVwh+P0wTvMluLtvn6sF5pDKHhtQcSkAUg
         qe8CuXtGkJLGpkL9B55HCR3TgvFc95luW034PVgNXQpq1wmwHE0UUioGNHIgpqgMM8S5
         QoOPB48+XATtkkNu5sBiIhv0eIh2l02/l3/xvd0QNlQmOnZtXZtlqeCBWV4gd/hlqo8G
         3x05s43bxmJpWFkDK1mYAA3FM2TxCxWW4sRwCrLbCDhgFLPgFxQ/W8wUaSZvddWXWYyp
         XioLklE9nv8+rI3WAgRF6AP3MrY5cKINJ0kXhCDsQOStvUQW2Y2o8/vjHXH2JY7r7x0+
         RvBA==
X-Gm-Message-State: AOAM531nFlG1mizfEGw+Yb2D+hIKRI9Tpln8iGmgRU8NPablrc/KupFz
        RTArw+uLIgbaAEybp0cTyfHmJSTIsQAY7wh5RqyKhg99
X-Google-Smtp-Source: ABdhPJyY9/RkHzsO+kMywmM6/7hArNN/v6GWivo4j4FziBuOz3ysDTUGdNuFVqhms34cELEKYbkE9gACePdMivlSjrs=
X-Received: by 2002:a2e:7c02:: with SMTP id x2mr10531273ljc.316.1591001900790;
 Mon, 01 Jun 2020 01:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho> <20200601064323.GF2282@nanopsycho>
In-Reply-To: <20200601064323.GF2282@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 1 Jun 2020 14:28:09 +0530
Message-ID: <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 12:13 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Jun 01, 2020 at 08:18:19AM CEST, jiri@resnulli.us wrote:
> >Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >>Live device reset capability allows the users to reset the device in real
> >>time. For example, after flashing a new firmware image, this feature allows
> >>a user to initiate the reset immediately from a separate command, to load
> >>the new firmware without reloading the driver or resetting the system.
> >>
> >>When device reset is initiated, services running on the host interfaces
> >>will momentarily pause and resume once reset is completed, which is very
> >>similar to momentary network outage.
> >>
> >>This patchset adds support for two new generic devlink parameters for
> >>controlling the live device reset capability and use it in the bnxt_en
> >>driver.
> >>
> >>Users can initiate the reset from a separate command, for example,
> >>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
> >>device.
> >>Where ethX or dev is any PF with administrative privileges.
> >>
> >>Patchset also updates firmware spec. to 1.10.1.40.
> >>
> >>
> >>v2->v3: Split the param into two new params "enable_live_dev_reset" and
> >
> >Vasundhara, I asked you multiple times for this to be "devlink dev reload"
> >attribute. I don't recall you telling any argument against it. I belive
> >that this should not be paramater. This is very tightly related to
> >reload, could you please have it as an attribute of reload, as I
> >suggested?
>
> I just wrote the thread to the previous version. I understand now why
> you need param as you require reboot to activate the feature.

Okay.
>
> However, I don't think it is correct to use enable_live_dev_reset to
> indicate the live-reset capability to the user. Params serve for
> configuration only. Could you please move the indication some place
> else? ("devlink dev info" seems fitting).

Here we are not indicating the support. If the parameter is set to
true, we are enabling the feature in firmware and driver after reboot.
Users can disable the feature by setting the parameter to false and
reboot. This is the configuration which is enabling or disabling the
feature in the device.

>
> I think that you can do the indication in a follow-up patchset. But
> please remove it from this one where you do it with params.

Could you please see the complete patchset and use it bnxt_en driver
to get a clear picture? We are not indicating the support.

Thanks.

>
>
> >
> >Thanks!
> >
> >
> >>"allow_live_dev_reset".
> >>- Expand the documentation of each param and update commit messages
> >> accordingly.
> >>- Separated the permanent configuration mode code to another patch and
> >>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
> >>
> >>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
> >>- Update documentation files and commit messages with more details of the
> >> feature.
> >>
> >>Vasundhara Volam (6):
> >>  devlink: Add 'enable_live_dev_reset' generic parameter.
> >>  devlink: Add 'allow_live_dev_reset' generic parameter.
> >>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
> >>  bnxt_en: Update firmware spec. to 1.10.1.40.
> >>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
> >>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
> >>
> >> Documentation/networking/devlink/bnxt.rst          |  4 ++
> >> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
> >> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
> >> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
> >> include/net/devlink.h                              |  8 +++
> >> net/core/devlink.c                                 | 10 ++++
> >> 10 files changed, 175 insertions(+), 36 deletions(-)
> >>
> >>--
> >>1.8.3.1
> >>
