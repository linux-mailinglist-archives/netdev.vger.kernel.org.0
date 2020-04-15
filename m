Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032541AB06B
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 20:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411719AbgDOSPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 14:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406366AbgDOSPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 14:15:09 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67411C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 11:15:09 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w4so6118486edv.13
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 11:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YoqgOvbUZ0S1Js2dwQ52UtRAoAWzj4gOTpTfcMlLZ4s=;
        b=H6bn3okQcE6zmr9NLK6GFTsB1SJ5DfzRhD2MK0f6rwKpB76V5afkf5IOFQqE2NK3Re
         9UlADwNG+xP88ubgeZnRstOC3opB4BIdZre3XzXnuQeZZIK9i38FjPBuj0/Owj3ZqnH/
         Ttx3XiQzYj2uglvFu3DSL6iVTm4XqurG/glK6+ixA8cC5puFFnSrnknxqpIPj3zqMqZS
         9+4idIonBNB72+wrCeNQY9WKmG07h/j1oQOljEC++YtTpnOff//yD7jleDqHSuZmEq16
         oAQrhe6EDMbuXSaO6DwnUkHQVbGyJTWsUAt5OzUmRy8klPEpv5wOVZgjUlTjxtV3iDwb
         2n9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YoqgOvbUZ0S1Js2dwQ52UtRAoAWzj4gOTpTfcMlLZ4s=;
        b=Cg/MCQMQ7ozAv5xBR92NdD+PdxxB/rjWM5sFgvhN2L4VJqGz+Oj5PfC0GkiPGm9Riz
         BfoUDLLneFuqG4T7zhXb6VXT0dDlUUYfsOS/EvOyO+9PM+UeYOg7Q6624ec9lA74ii8P
         JLUBaHNRj7UUsoEUNY1RKLenfZZaqho5H53REHMiayndI6/rFo21YWaVZffBklIHyl/N
         w/3T24nWt2SWf1Mi3cEP1J1YvSdKSDFbGZ39rOBLsZUqrsYs0SYGpnWkAV3Zb1x/HR3p
         De9NwYryJjPim4DamvUbfR4zxEwETdS8PSB9Gnp3WxiD9aHLFnQ+mBabvimFIQBknBxb
         3kqw==
X-Gm-Message-State: AGi0PubY/NgSEZ23Nz10s4GT326S0i7DtWw9W8o5HFwsi0gC3LyiNGKl
        nWQh4wu6FrYpImh+IC1rwNkcsVaI1fbqX7tc4xIo7Q==
X-Google-Smtp-Source: APiQypIDviznmbh0DP1Y4MZjPXa7z/wZLS4rvbUsfMPqOuBliZNC9ftJCdxqxuF/xHtbgMW6Dh6epTogfWcURpt/U4Y=
X-Received: by 2002:a50:d1d7:: with SMTP id i23mr27363639edg.118.1586974508030;
 Wed, 15 Apr 2020 11:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
 <c658ea46-7d67-3218-f565-9b9c1a6b4ee2@solarflare.com>
In-Reply-To: <c658ea46-7d67-3218-f565-9b9c1a6b4ee2@solarflare.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 15 Apr 2020 21:14:57 +0300
Message-ID: <CA+h21hotSTzuj3mG53eGGy9i5pFSpb6RV51Kdo2xxeYUU9r-cw@mail.gmail.com>
Subject: Re: Correct tc-vlan usage
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edward,

On Wed, 15 Apr 2020 at 21:13, Edward Cree <ecree@solarflare.com> wrote:
>
> On 15/04/2020 18:59, Vladimir Oltean wrote:
> > My problem is that the VLAN tags are discarded by the network
> > interface's RX filter:
> >
> > # ethtool -S eno2
> >      SI VLAN nomatch u-cast discards: 1280
> >
> > and this is because nobody calls .ndo_vlan_rx_add_vid for these VLANs
> > (only the 8021q driver does).
> You could try creating the VLAN interfaces anyway; no traffic will hit
>  them, because the tc rule popped the VLAN, but they'll call the ndo.
> Idk if that'll actually work though... and it'd still be possible to
>  TX through the VLAN devices, which you don't want.
>
> -ed

That is what I'm already doing. I'm keeping the VLAN subinterfaces
down and it works. It seems like misuse though...

Thanks,
-Vladimir
