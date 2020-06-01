Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A0F1EA17C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgFAKEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgFAKEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:04:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13596C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 03:04:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u13so10126508wml.1
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 03:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZDodPDZC5EinEulQLl4To9fNwp40f7QtokELOFRqRTY=;
        b=rZntTuiIu63gB+HxJ6AXk/2QaCz78zYu+k6sHRcvhHpgB7mgnglHmM/0lxyn+QbEgK
         OH4QSB6XVc0A9/oEI4+QdyFgSVaypRIAu1ZAL+3SJ+F7eJ7HXIHqXM9XTC+cAHAUbKoJ
         USGgK1iR0CurChjcGVXVGcrpmgsydT1wldqhpqZynSnvWDHd3FBgUEl0TFpDeo95QRJS
         K0gq9GAkfhBS+PPqAPNKQCCT/dQHABFoBY7GpGUMcDqpKCHc8qhMy4sg9q2+IGEkcPRS
         z4TQK1udPmnX9tlrEr7qHHiZr/0lDvNzFbGq0bcvDI86KEroEKCiE9XRMDd4w+wv/uuZ
         dMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZDodPDZC5EinEulQLl4To9fNwp40f7QtokELOFRqRTY=;
        b=Qd+6ZnezrrsWFv2sUKsUEa6vJF+FRc/ZA4KJHQkAgtfBx0uVcpVwbc9N5cPpQW/c7B
         J1kLAE67YcoVesyZCPk+SdLMr6pq30Ll8WITgfwRu9Mjo0b4knr5/X6jqNnQRV0OpXE+
         5hOq5MsCNIsx0BcfKiOY9H1N7DHHIVfRyO74YP8+5/QHwpVqzFfnJGJtXox8Ab5dT+iI
         UOwE6/5eU5aLwtWOkdU6xUl+jFt7VQsyBWBBmOK7DBX9yvJyV4He4etnYbykvNoDdbDw
         QPMnCgX7DTQ2Lof7JdFXicFw2Aj0otQPlHAdTxPWROcMiAxkJG3K4SBQk6q79WCrvBTv
         09xw==
X-Gm-Message-State: AOAM531dvjsQdusOwbdgHjYvYRt5tKtZ7wBAVO4cWlnE9aCw/6pLycI3
        L5sDkJWaaqpSaCnU6YpygkYsPg==
X-Google-Smtp-Source: ABdhPJyiMEkDQruMLefkDqMD/0GrUiNDVCkEpSYfD0ghAc5EtUQ5BgsmNSZkx5QzWVxXhG3SZbIleA==
X-Received: by 2002:a1c:9a47:: with SMTP id c68mr20102638wme.19.1591005852728;
        Mon, 01 Jun 2020 03:04:12 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id y80sm13861724wmc.34.2020.06.01.03.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 03:04:12 -0700 (PDT)
Date:   Mon, 1 Jun 2020 12:04:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601100411.GL2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho>
 <20200601064323.GF2282@nanopsycho>
 <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 10:58:09AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, Jun 1, 2020 at 12:13 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Jun 01, 2020 at 08:18:19AM CEST, jiri@resnulli.us wrote:
>> >Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >>Live device reset capability allows the users to reset the device in real
>> >>time. For example, after flashing a new firmware image, this feature allows
>> >>a user to initiate the reset immediately from a separate command, to load
>> >>the new firmware without reloading the driver or resetting the system.
>> >>
>> >>When device reset is initiated, services running on the host interfaces
>> >>will momentarily pause and resume once reset is completed, which is very
>> >>similar to momentary network outage.
>> >>
>> >>This patchset adds support for two new generic devlink parameters for
>> >>controlling the live device reset capability and use it in the bnxt_en
>> >>driver.
>> >>
>> >>Users can initiate the reset from a separate command, for example,
>> >>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
>> >>device.
>> >>Where ethX or dev is any PF with administrative privileges.
>> >>
>> >>Patchset also updates firmware spec. to 1.10.1.40.
>> >>
>> >>
>> >>v2->v3: Split the param into two new params "enable_live_dev_reset" and
>> >
>> >Vasundhara, I asked you multiple times for this to be "devlink dev reload"
>> >attribute. I don't recall you telling any argument against it. I belive
>> >that this should not be paramater. This is very tightly related to
>> >reload, could you please have it as an attribute of reload, as I
>> >suggested?
>>
>> I just wrote the thread to the previous version. I understand now why
>> you need param as you require reboot to activate the feature.
>
>Okay.
>>
>> However, I don't think it is correct to use enable_live_dev_reset to
>> indicate the live-reset capability to the user. Params serve for
>> configuration only. Could you please move the indication some place
>> else? ("devlink dev info" seems fitting).
>
>Here we are not indicating the support. If the parameter is set to
>true, we are enabling the feature in firmware and driver after reboot.
>Users can disable the feature by setting the parameter to false and
>reboot. This is the configuration which is enabling or disabling the
>feature in the device.
>
>>
>> I think that you can do the indication in a follow-up patchset. But
>> please remove it from this one where you do it with params.
>
>Could you please see the complete patchset and use it bnxt_en driver
>to get a clear picture? We are not indicating the support.

Right. I see.

There is still one thing that I see problematic. There is no clear
semantics on when the "live fw update" is going to be performed. You
enable the feature in NVRAM and you set to "allow" it from all the host.
Now the user does reset, the driver has 2 options:
1) do the live fw reset
2) do the ordinary fw reset

This specification is missing and I believe it should be part of this
patchset, otherwise the behaviour might not be deterministic between
drivers and driver versions.

I think that the legacy ethtool should stick with the "ordinary fw reset",
becase that is what user expects. You should add an attribute to
"devlink dev reload" to trigger the "live fw reset"



>
>Thanks.
>
>>
>>
>> >
>> >Thanks!
>> >
>> >
>> >>"allow_live_dev_reset".
>> >>- Expand the documentation of each param and update commit messages
>> >> accordingly.
>> >>- Separated the permanent configuration mode code to another patch and
>> >>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
>> >>
>> >>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
>> >>- Update documentation files and commit messages with more details of the
>> >> feature.
>> >>
>> >>Vasundhara Volam (6):
>> >>  devlink: Add 'enable_live_dev_reset' generic parameter.
>> >>  devlink: Add 'allow_live_dev_reset' generic parameter.
>> >>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
>> >>  bnxt_en: Update firmware spec. to 1.10.1.40.
>> >>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
>> >>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
>> >>
>> >> Documentation/networking/devlink/bnxt.rst          |  4 ++
>> >> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
>> >> include/net/devlink.h                              |  8 +++
>> >> net/core/devlink.c                                 | 10 ++++
>> >> 10 files changed, 175 insertions(+), 36 deletions(-)
>> >>
>> >>--
>> >>1.8.3.1
>> >>
