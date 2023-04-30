Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A206F2887
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 12:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjD3K66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 06:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3K65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 06:58:57 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3464D269E;
        Sun, 30 Apr 2023 03:58:56 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id a1e0cc1a2514c-77115450b8fso1003699241.0;
        Sun, 30 Apr 2023 03:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682852335; x=1685444335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yRqbMK5ZOoBV7oEjfeaEkeOFx+akdbA76Qn7HPAVqQ=;
        b=dVMpPKQmYtWA6bJvjmz2oUs7Wz81r6A0Hf2HQ5ktdXKqC9/EssFIuc1FCvs5XK8G4/
         3ReRrdhMgAuyIZZiMhZ/viFQWa9qNKtsb8kRcr8BYqOftrfDLlB4GSN36KNthl8VMs8W
         rYiktJNrp7nRtqvsHpngoi920qwJe9Ka9aJGvaoj+O10qhJbFzoFdhh3hPjLNWRuzm37
         +DrX87nCscfqdK1r2aRCsZPSW1C5xcQYZbQzidGFRDnIgCCp2jsPcVcAULf2UAuiqUM6
         l9CcezKLCtX9SzM3NPYonxniXd91G2ZOBGl8X8z1vNljN7mfGFwPqvDmM+qI7YITX+XC
         8ESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682852335; x=1685444335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4yRqbMK5ZOoBV7oEjfeaEkeOFx+akdbA76Qn7HPAVqQ=;
        b=iF9xf6ndhs/q3LZgcxruShQW7seEXIQU1ahyhVwJSKONnOwnFDfFwR1lHCThk2lC/C
         qcFrBB80Xi0d9OVyTcXm9DiuICUqpHW28T7wiah3/Pe3WVRqdG3qHwLtaTKYEz6mb37l
         Y5j6vqMPonimY9EoJoL9XWUfFsZkoGjXY2hEVL1pS/2MJfcKny3jG9wY+xxJzICp4czO
         gnJqasKAXZIu0Y/bTDvxQushEcl3vqxcyW1vr4J6hhhKsSbAijFXPfRZ2Kb+6HNTFCox
         osD/yVYaDkn2V3HVGfEMSXvmqEyJ0HzBHR1JQUTWXhdc9DoiX9Bo2fHmoelhQM9nuRLT
         Nq1A==
X-Gm-Message-State: AC+VfDweUvMr3OT/S0fJylrZmmSrVFDxtsNnnwX6m5SlsAMYZwFVF/ce
        hwgiAcyXgFzJ+euvpu3LpMg4TVuwIA7Zmsdydxk=
X-Google-Smtp-Source: ACHHUZ7GMdfJ8slwBPsfUk71KrHUgsMc+fh9xNLqcaE7QzlNfL4EAdW411L/9EJySS4ALmov/ANNbaKnPRv9bB+Jg4w=
X-Received: by 2002:a67:f883:0:b0:42f:78d5:d987 with SMTP id
 h3-20020a67f883000000b0042f78d5d987mr4858393vso.1.1682852335098; Sun, 30 Apr
 2023 03:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230429020951.082353595@lindbergh.monkeyblade.net>
 <CAAJw_ZueYAHQtM++4259TXcxQ_btcRQKiX93u85WEs2b2p19wA@mail.gmail.com>
 <ZE0kndhsXNBIb1g7@debian.me> <CAAJw_Zvxtf-Ny2iymoZdBGF577aeNomWP7u7-5rWyn6A7rzKRg@mail.gmail.com>
In-Reply-To: <CAAJw_Zvxtf-Ny2iymoZdBGF577aeNomWP7u7-5rWyn6A7rzKRg@mail.gmail.com>
From:   Jeff Chua <jeff.chua.linux@gmail.com>
Date:   Sun, 30 Apr 2023 18:58:44 +0800
Message-ID: <CAAJw_ZvZdFpw9W2Hisc9c2BAFbYAnQuaFFaFG6N7qPUP2fOL_w@mail.gmail.com>
Subject: Re: iwlwifi broken in post-linux-6.3.0 after April 26
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux Networking <netdev@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 2:17=E2=80=AFAM Jeff Chua <jeff.chua.linux@gmail.co=
m> wrote:
>
> On Sat, Apr 29, 2023 at 10:07=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.=
com> wrote:
> >
> > On Sat, Apr 29, 2023 at 01:22:03PM +0800, Jeff Chua wrote:
> > > Can't start wifi on latest linux git pull ... started happening 3 day=
s ago ...
> >
> > Are you testing mainline?
>
> I'm pulling from https://github.com/torvalds/linux.git, currently at ...
>
> commit 1ae78a14516b9372e4c90a89ac21b259339a3a3a (HEAD -> master,
> origin/master, origin/HEAD)
> Merge: 4e1c80ae5cf4 74d7970febf7
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Apr 29 11:10:39 2023 -0700
>
> > Certainly you should do bisection.
>
> ok, will do.

Bisected!

ef3ed33dfc8f0f1c81ca103e6b68b4f77ee0ab65 is the first bad commit
commit ef3ed33dfc8f0f1c81ca103e6b68b4f77ee0ab65
Author: Gregory Greenman <gregory.greenman@intel.com>
Date:   Sun Apr 16 15:47:33 2023 +0300

    wifi: iwlwifi: bump FW API to 77 for AX devices

    Start supporting API version 77 for AX devices.

    Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
    Link: https://lore.kernel.org/r/20230416154301.e522ccefe354.If7628363fa=
feb7687163103e734206915c445197@changeid
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


I had to downgrade FW API to 75 to make it work again!

--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c    2023-04-30
18:27:21.719983505 +0800
+++ a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c    2023-04-30
18:27:25.749983446 +0800
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"

 /* Highest firmware API version supported */
-#define IWL_22000_UCODE_API_MAX        78
+#define IWL_22000_UCODE_API_MAX        75

 /* Lowest firmware API version supported */
 #define IWL_22000_UCODE_API_MIN        39


My h/w is Lenovo X1 with ...

00:14.3 Network controller: Intel Corporation Alder Lake-P PCH CNVi
WiFi (rev 01)


I've the following firmware .. I've tried 77, 78, 79, 81 .. .all not workin=
g

-rw-r--r-- 1 root root 1560532 Mar 14 08:05 iwlwifi-so-a0-gf-a0-72.ucode
-rw-r--r-- 1 root root 1563692 Mar  6 14:07 iwlwifi-so-a0-gf-a0-73.ucode
-rw-r--r-- 1 root root 1577460 Mar 14 08:05 iwlwifi-so-a0-gf-a0-74.ucode
-rw-r--r-- 1 root root 1641260 Mar  6 14:07 iwlwifi-so-a0-gf-a0-77.ucode
-rw-r--r-- 1 root root 1667236 Mar  6 14:07 iwlwifi-so-a0-gf-a0-78.ucode
-rw-r--r-- 1 root root 1672988 Mar  6 14:07 iwlwifi-so-a0-gf-a0-79.ucode
-rw-r--r-- 1 root root 1682852 Apr  5 08:22 iwlwifi-so-a0-gf-a0-81.ucode


# working dmesg attached ...
cfg80211: Loading compiled-in X.509 certificates for regulatory database
Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
iwlwifi 0000:00:14.3: Direct firmware load for
iwlwifi-so-a0-gf-a0-75.ucode failed with error -2
iwlwifi 0000:00:14.3: api flags index 2 larger than supported by driver
thermal thermal_zone1: failed to read out thermal zone (-61)
iwlwifi 0000:00:14.3: Sorry - debug buffer is only 4096K while you
requested 65536K
