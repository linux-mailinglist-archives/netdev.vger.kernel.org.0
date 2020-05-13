Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8E1D1ADC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389392AbgEMQR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387541AbgEMQR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:17:59 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400BAC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:17:59 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g16so14718471eds.1
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y5fECBTmpQhsAZTvaek3WaiP6WwedZB41pWrMS8HIJQ=;
        b=b2BP4Zfej6fy15hMuOOTr4x1ySeq/7XOrnaC6tUnNbYRtXJvjXoZh2bLCYG6+9aPYr
         ueek2rYxtjRVxRev9LQPuwINJNoSBEy2ODB/MHGuw/N8JviIQu1T8tC8mFdLFevOnKG4
         HPLAwXPBFyMI/ceBYbe6yhKmld1aWgwjkD1faYqgnXZOChzxorHpj4vq+HNwDG6R0nEF
         kDosYKiZqDynDQzCfak3obrVqG7FaCR2UR6nBYE3fGxLMNhOeqiA1wtyOByz7s86h8m2
         aQB8l8dw3+tMD5XdUqLXqS29eotUFwRtTrjytDVzCW9sMFl7HBNGFjjbkFE3Pk490O2q
         fbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y5fECBTmpQhsAZTvaek3WaiP6WwedZB41pWrMS8HIJQ=;
        b=bHdDUu3c8yC2daxvNu+hQ6nualp9gJW+GRj7bvV3YOnxablcCCgHakK2lqGM8q505b
         SXrPcIOBniKj+8rlFue44/mwTCK106qu3z9xwZhyhfXRuLdFt8S5t8IupPc+lFhHAbmM
         ldXcrpfgtHenoAmGXhPYYSHRB3gNVSPK6FjkORXX5R4/abhTYMptu4ZwFXnwrYjPJ7fv
         pc4Daqd0wUjiAyaXIgtPvjMGjIv2BB6XlID/d9iJuVBUqfSzgPeTwqlxqbvz8X2dba+h
         Ngo676XQF47WabwQ2FA1UTxtdbPmaTqjoVrg/+6ziKFEgHgcZW0VA2qHeR9x8ooi7MBZ
         kFLA==
X-Gm-Message-State: AOAM531vSPwgzWTa9kutO7vA6ianSt6tn2aJCd+v4gcahET6IZ+9MPLx
        fuIcdiu09SYfHpgK0qRCGEsz+zTF/MILJwP2Zsg=
X-Google-Smtp-Source: ABdhPJxmcbGv7nRJXf0zPKiuTQvX8RblDkGx4sHIuHt3fNVmwep7SuCBuPB4Vv/ahBEtKk281J7a6R3BEj9QiMURj64=
X-Received: by 2002:a50:8dc2:: with SMTP id s2mr409304edh.318.1589386677859;
 Wed, 13 May 2020 09:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200513153717.15599-1-dqfext@gmail.com> <5d77da58-694a-7f9c-53fb-9d107e271d40@gmail.com>
In-Reply-To: <5d77da58-694a-7f9c-53fb-9d107e271d40@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 13 May 2020 19:17:46 +0300
Message-ID: <CA+h21hr_TyWQyvGukXqS0SocmvOBWUp6keghuhZh6HSaxAGb8A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: set CPU port to fallback mode
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 at 18:49, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/13/2020 8:37 AM, DENG Qingfang wrote:
> > Currently, setting a bridge's self PVID to other value and deleting
> > the default VID 1 renders untagged ports of that VLAN unable to talk to
> > the CPU port:
> >
> >       bridge vlan add dev br0 vid 2 pvid untagged self
> >       bridge vlan del dev br0 vid 1 self
> >       bridge vlan add dev sw0p0 vid 2 pvid untagged
> >       bridge vlan del dev sw0p0 vid 1
> >       # br0 cannot send untagged frames out of sw0p0 anymore
> >
> > That is because the CPU port is set to security mode and its PVID is
> > still 1, and untagged frames are dropped due to VLAN member violation.
> >
> > Set the CPU port to fallback mode so untagged frames can pass through.
>
> How about if the bridge has vlan_filtering=1? The use case you present
> seems to be valid to me, that is, you may create a VLAN just for the
> user ports and not have the CPU port be part of it at all.
>

What Qingfang is doing is in effect (but not by intention) removing
the front panel port sw0p0 from the membership list of the CPU port's
pvid. What you seem to be thinking of (VLAN of which the CPU is not a
member of) does not seem to be supported in DSA at the moment.

As a fix, there's nothing wrong with the patch actually, I don't even
know how it would work otherwise. DSA doesn't change the pvid of the
CPU port when the pvid of a slave changes, because 4 slave ports could
have 4 different pvids and the CPU port pvid would keep changing.
Fallback mode should only apply on ingress from CPU, so there's no
danger really.

Thanks,
-Vladimir
