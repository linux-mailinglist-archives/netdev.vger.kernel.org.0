Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C89743BD6D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 00:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbhJZWwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 18:52:45 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:41196
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230233AbhJZWwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 18:52:44 -0400
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B9E253F19E
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 22:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635288618;
        bh=sOzNLS53TAFKLgxzOh/gf4V4t3blNgwULiltnWEPGMo=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=ggYBtcYQubCCqPso9IwLxp2u6DUMw3jZDhBURG9IzkywMa73N5p+6xoGi9hzDcrsE
         wiKinxLtTCTank1mmCkE23GHHYstEHjG+MMQm1JYaHzV4XKc0GYkp4GQzsCZ8e3OCX
         uY5ywqD1hi5AA+jQzSweCPgSUNYUysZ7EcStyRBG2+XL6hT8MYuFZZ61tMUPVRysmF
         qj6K1rM1IxvUmUc34OmoWOqULAMppNAMr2XPEb78Gu7JFG8c/FrimNtvIkLvD+3l2q
         A24GwvN7n/9iAKymuMJ61o5m68kd82a41dT43EpiOf4Ksx1z1ppy0/X5EwjILM39gx
         aaaWnSlaf/CNA==
Received: by mail-oo1-f69.google.com with SMTP id f21-20020a4abb15000000b002b766ff48feso348677oop.20
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 15:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOzNLS53TAFKLgxzOh/gf4V4t3blNgwULiltnWEPGMo=;
        b=50shYtmRs2tzjyxTD2kSZ03O4gFyzVW5abwO5OUrmEjE1ogh8vE93dZ85m8O9Hpa37
         KYAz3w9Vk6fBvFSjVjUEIilaWBi5af/Lsvk/g0icZzwjOTja4As0kWGNC9afwRuIJZ3b
         qdy0LCkUIw6HJeRXJIBE2aI6JT5Uao835VNjVZvItGzYUhuAWFJR6qX+tmQUqtUGWsXb
         RNWY89KnsoFUzYdI1gS/SwK+Ej1VC5F7pvhi9jiZ3cEvZZXn+9LJVpLme3RqbpnnGIPD
         hq0kM1mPo84TGdBHCmqQ4jnsCxdqeKej2iIzV6sQPvK/NmcNVZhwAg/oBcWmN16oN4VH
         X4ng==
X-Gm-Message-State: AOAM530jMfaQfIqnGGUdHLNJEB4a+DlnJzM0ft88yauP+j021iKSOhOU
        9VsmNE7joqzpM96ybYV7zyABYu5m9JvH3E5UA1143DzAKpYTS0xruYMGi9gXNT6wbE26XMuJonu
        WDRI6I4lzSC5Zr4fl1iXy71FCafV04v5DvXOvnzGTwXZntlzV2A==
X-Received: by 2002:a9d:7b49:: with SMTP id f9mr22036760oto.11.1635288617530;
        Tue, 26 Oct 2021 15:50:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV2yNIRx9YHLCbw6IWJF7ib5jZpqmK1ebG462GAQN5fW/dna9VhsgWtWnSzFGmM1pgg+IIrfpuqUQizSC0wCc=
X-Received: by 2002:a9d:7b49:: with SMTP id f9mr22036739oto.11.1635288617200;
 Tue, 26 Oct 2021 15:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211026065112.1366205-1-kai.heng.feng@canonical.com> <04ed8307-ab1f-59d6-4454-c759ce4a453b@intel.com>
In-Reply-To: <04ed8307-ab1f-59d6-4454-c759ce4a453b@intel.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 27 Oct 2021 06:50:05 +0800
Message-ID: <CAAd53p69k-2PVw5RpJOAbe=oBh11U_UqzsyMjxHFbo7xqNBDsQ@mail.gmail.com>
Subject: Re: [PATCH v2] e1000e: Add a delay to let ME unconfigure s0ix when
 DPG_EXIT_DONE is already flagged
To:     Sasha Neftin <sasha.neftin@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 4:48 PM Sasha Neftin <sasha.neftin@intel.com> wrote:
>
> On 10/26/2021 09:51, Kai-Heng Feng wrote:
> > On some ADL platforms, DPG_EXIT_DONE is always flagged so e1000e resume
> > polling logic doesn't wait until ME really unconfigures s0ix.
> >
> > So check DPG_EXIT_DONE before issuing EXIT_DPG, and if it's already
> > flagged, wait for 1 second to let ME unconfigure s0ix.
> >
> > Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v2:
> >   Add missing "Fixes:" tag
> >
> >   drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> > index 44e2dc8328a22..cd81ba00a6bc9 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -6493,14 +6493,21 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
> >       u32 mac_data;
> >       u16 phy_data;
> >       u32 i = 0;
> > +     bool dpg_exit_done;
> >
> >       if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
> > +             dpg_exit_done = er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE;
> >               /* Request ME unconfigure the device from S0ix */
> >               mac_data = er32(H2ME);
> >               mac_data &= ~E1000_H2ME_START_DPG;
> >               mac_data |= E1000_H2ME_EXIT_DPG;
> >               ew32(H2ME, mac_data);
> >
> > +             if (dpg_exit_done) {
> > +                     e_warn("DPG_EXIT_DONE is already flagged. This is a firmware bug\n");
> > +                     msleep(1000);
> > +             }
> Thanks for working on the enablement.
> The delay approach is fragile. We need to work with CSME folks to
> understand why _DPG_EXIT_DONE indication is wrong on some ADL platforms.
> Could you provide CSME/BIOS version? dmidecode -t 0 and cat
> /sys/class/mei/mei0/fw_ver

$ sudo dmidecode -t 0
# dmidecode 3.2
Getting SMBIOS data from sysfs.
SMBIOS 3.4 present.
# SMBIOS implementations newer than version 3.2.0 are not
# fully supported by this version of dmidecode.

Handle 0x0001, DMI type 0, 26 bytes
BIOS Information
        Vendor: Dell Inc.
        Version: 0.12.68
        Release Date: 10/01/2021
        ROM Size: 48 MB
        Characteristics:
                PCI is supported
                PNP is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                Boot from CD is supported
                Selectable boot is supported
                EDD is supported
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Serial services are supported (int 14h)
                Printer services are supported (int 17h)
                ACPI is supported
                USB legacy is supported
                BIOS boot specification is supported
                Function key-initiated network boot is supported
                Targeted content distribution is supported
                UEFI is supported
        BIOS Revision: 0.12

$ cat /sys/class/mei/mei0/fw_ver
0:16.0.15.1518
0:16.0.15.1518
0:16.0.15.1518

> >               /* Poll up to 2.5 seconds for ME to unconfigure DPG.
> >                * If this takes more than 1 second, show a warning indicating a
> >                * firmware bug
> >
