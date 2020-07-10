Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8D621AF65
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgGJGZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJGZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:25:19 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC02CC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 23:25:18 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z24so5120994ljn.8
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 23:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fJADAGo8BCSaNwcMA6bjTyugTx7Seg5BcqdE39Q2Eeg=;
        b=UWldodlEyULNe/3pbzWNfTVNbqWIShOjOaUtBA/0d+qGJ52I7KKZ7Ko9+fOyBconBU
         XLO95dupZCxlEjEUBhxCpy7ftEp35msLI79FhlGTr9A2dVCzYo3phKKIlW9S8JUZB7jy
         f8eGBDYjGQOLGnPt1UewAbGM6nJ8YCtlY5HBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fJADAGo8BCSaNwcMA6bjTyugTx7Seg5BcqdE39Q2Eeg=;
        b=meYqcJbP0cwWkjN2qolFmtL27bmbr4LLbbA82zWCne+F20c0cNvTobKKYA0gkpgvHr
         7/NbQjEMBf4Bi5YXKjfTTs9nsYmSeXIzfRSQVe63gL+9ebHMJA3atVFSCG6cshqeZayA
         fAGc2l8NPk0NnsyAgDoAN+uwM02xW/TEfSQENqgM4BMU3xWKri23zMgnrVEFFT7CpuZS
         eBzrTCB0S2mNaAIJYNVvixfGsUBElmZ5JNHD7HKVAlcUD+D6vK5g/fKaQ9mjlQkrdX9z
         7Muq44YehBFrNAlgQZyWIyt7M8RSMp9kqSGvPgyMr+Fb+9NH7g7Hxw4vgyfLDe+Q1YT/
         LPeg==
X-Gm-Message-State: AOAM531kOOocDpgEoVTsoJZwxG4EIYhktzWjUmVeG9k1jvJ7RC2rezGT
        lhmiFIpP/06ywMnc2+P5EtLOkMxOqI524TFo8v0AHA==
X-Google-Smtp-Source: ABdhPJzpvq6xWRd1TBrxtIxelL1RkOGU+RMBAwHBRGZgXGYL73TJWrgERM+3jAEnEeVS+Ju2Vl9TgnGkNi++57p2bWw=
X-Received: by 2002:a2e:7401:: with SMTP id p1mr16461774ljc.366.1594362316882;
 Thu, 09 Jul 2020 23:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
 <20200709212652.2785924-7-jacob.e.keller@intel.com> <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Fri, 10 Jul 2020 11:55:05 +0530
Message-ID: <CAACQVJoRcxtLTL_sTfh-tE4peTA58aK+xKic4BwaP-F3n8nfmg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 5:56 AM Jakub Kicinski <kubakici@wp.pl> wrote:
>
> On Thu,  9 Jul 2020 14:26:52 -0700 Jacob Keller wrote:
> > The flash update for the ice hardware currently supports a single fixed
> > configuration:
> >
> > * Firmware is always asked to preserve all changeable fields
> > * The driver never allows downgrades
> > * The driver will not allow canceling a previous update that never
> >   completed (for example because an EMP reset never occurred)
> > * The driver does not attempt to trigger an EMP reset immediately.
> >
> > This default mode of operation is reasonable. However, it is often
> > useful to allow system administrators more control over the update
> > process. To enable this, implement devlink parameters that allow the
> > system administrator to specify the desired behaviors:
> >
> > * 'reset_after_flash_update'
> >   If enabled, the driver will request that the firmware immediately
> >   trigger an EMP reset when completing the device update. This will
> >   result in the device switching active banks immediately and
> >   re-initializing with the new firmware.
>
> This should probably be handled through a reset API like what
> Vasundhara is already working on.
Yes, please go through the discussions happening on "[RFC v2 net-next]
devlink: Add reset subcommand." mail thread. I am waiting for Moshe
pachset for 'devlink dev reload' before further efforts.


>
> > * 'allow_downgrade_on_flash_update'
> >   If enabled, the driver will attempt to update device flash even when
> >   firmware indicates that such an update would be a downgrade.
> > * 'ignore_pending_flash_update'
> >   If enabled, the device driver will cancel a previous pending update.
> >   A pending update is one where the steps to write the update to the NVM
> >   bank has finished, but the device never reset, as the system had not
> >   yet been rebooted.
>
> These can be implemented in user space based on the values of running
> and stored versions from devlink info.
>
> > * 'flash_update_preservation_level'
> >   The value determines the preservation mode to request from firmware,
> >   among the following 4 choices:
> >   * PRESERVE_ALL (0)
> >     Preserve all settings and fields in the NVM configuration
> >   * PRESERVE_LIMITED (1)
> >     Preserve only a limited set of fields, including the VPD, PCI serial
> >     ID, MAC address, etc. This results in permanent settings being
> >     reset, including changes to the port configuration, such as the
> >     number of physical functions created.
> >   * PRESERVE_FACTORY_SETTINGS (2)
> >     Reset all configuration fields to the factory default settings
> >     stored within the NVM.
> >   * PRESERVE_NONE (3)
> >     Do not perform any preservation.
>
> Could this also be handled in a separate reset API? It seems useful to
> be able to reset to factory defaults at any time, not just FW upgrade..
