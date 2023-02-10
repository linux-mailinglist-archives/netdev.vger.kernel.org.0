Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F16691B15
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjBJJRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjBJJRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:17:39 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528125774A;
        Fri, 10 Feb 2023 01:17:38 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id a9so5295767ljr.13;
        Fri, 10 Feb 2023 01:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EPWp03w9tMexKpb9uuB1PcXg2CaC9rnzXR1zF7oiUes=;
        b=fvPvgukSB4NtQwfCIVYFMblUGyio7z0B+n0rSTURKLkXMkD5Fs3ss0ReBD8ZS3p+dq
         Z4liO+6E6klnVdCvlY+ZS7n3DFtmoKzEPZI4fMViZHVIdFALwGfNjV6D7bJFYsXfUdwV
         sgxOr3Jc7rUOCNUMpUNMeH6O+Pa46obZzoPapFOweDNAoH352KDj4hvsVCzBlV5lHrdq
         6ELINgXAPGO+4oO7I5XpGhKQokXaKt9cL7pm86lZAz1SMcOqQ71octKbmo1NR/OzeKam
         VLqw8o2fVyHLFxE5sQJl8DeL+0d4s6SWw0d5lbqNA9qCry7KaZarLhH4TCs9fWZle4gk
         //Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EPWp03w9tMexKpb9uuB1PcXg2CaC9rnzXR1zF7oiUes=;
        b=p60aQKQ5LIoldTvAHRD5NVcVFY1UX0wqSbBDmyIp3w+rJ4ntyt4swcwKtnqRQdnSRi
         txIRFLHV0qOu8IXKm08JGJl/M2xU8Kd+7dmwId7yINOXCb5PAgpIpODqHbc46l8H3BRs
         LbRC1/iXwc4J7wTL2N4GmRqAP+7Ot3jzvcBmvzhvpyQ7stMOZ3wlfrFmE5+W8H6k/mne
         AuEdqnnxX8PCMrd0pU2K3P4kT5Auq9BheKyfc0Kjhr4U3D+0zmpd0HpenL/i3Gs3Y00h
         JvWqKNNxwNa0VF3W/Pv1oltRcGP+WXnta2rE/xM+Eu6mAIP9JtYEA6C2lSabFBzazBNe
         AWRQ==
X-Gm-Message-State: AO0yUKWh2gcOQadYajfX95VfAyzeZ0ivzdnRO0x44w1+RjF21mLjt3VR
        1kwUrv9ZY9YkWv6SgWB8kMBN37y14zMFm4kZKP+k+79cP0mllw==
X-Google-Smtp-Source: AK7set8t0PInRfas05hOeFdy22vFvOxLhrTQh1DqNmO2aqAHCr95b3haFtIt7hA5FL4M1NVMCfn5ak3+SSnTeBNQDpQ=
X-Received: by 2002:a2e:9c5a:0:b0:290:2306:66ec with SMTP id
 t26-20020a2e9c5a000000b00290230666ecmr2389932ljj.193.1676020656589; Fri, 10
 Feb 2023 01:17:36 -0800 (PST)
MIME-Version: 1.0
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com> <20230209094825.49f59208@kernel.org>
 <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com> <20230209130725.0b04a424@kernel.org>
 <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
In-Reply-To: <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Fri, 10 Feb 2023 10:17:24 +0100
Message-ID: <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
To:     Michael Walle <michael@walle.cc>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ajay.Kathat@microchip.com,
        Claudiu.Beznea@microchip.com, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amisha.Patel@microchip.com, Thomas Haller <thaller@redhat.com>,
        Beniamino Galvani <bgalvani@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI,

Am Do., 9. Feb. 2023 um 22:19 Uhr schrieb Michael Walle <michael@walle.cc>:
>
> Am 2023-02-09 22:07, schrieb Jakub Kicinski:
> > On Thu, 9 Feb 2023 18:51:58 +0000 Ajay.Kathat@microchip.com wrote:
> >> > netdev should be created with a valid lladdr, is there something
> >> > wifi-specific here that'd prevalent that? The canonical flow is
> >> > to this before registering the netdev:
> >>
> >> Here it's the timing in wilc1000 by when the MAC address is available
> >> to
> >> read from NV. NV read is available in "mac_open" net_device_ops
> >> instead
> >> of bus probe function. I think, mostly the operations on netdev which
> >> make use of mac address are performed after the "mac_open" (I may be
> >> missing something).
> >>
> >> Does it make sense to assign a random address in probe and later read
> >> back from NV in mac_open to make use of stored value?
> >
> > Hard to say, I'd suspect that may be even more confusing than
> > starting with zeroes. There aren't any hard rules around the
> > addresses AFAIK, but addrs are visible to user space. So user
> > space will likely make assumptions based on the most commonly
> > observed sequence (reading real addr at probe).
>
> Maybe we should also ask the NetworkManager guys. IMHO random
> MAC address sounds bogus.

Maybe it would be a "workaround" with loading the firmware while
probing the device to set the real hw address.

probe()
  load_fw()
  read_hw_addr_from_nv()
  eth_hw_addr_set(ndev, addr)
  unload_fw()

mac_open()
  load_fw()

mac_close()
  unload_fw()


> I don't understand the "we load the firmware when the interface
> is brought up" thing. Esp. with network manager scanning in the
> background, the firmware gets loaded so many times.

Yes this is also an additional issue here.

I added Thomas and Beniamino as I hope one of them can help regarding
the network-manager questions.

>
> -michael
