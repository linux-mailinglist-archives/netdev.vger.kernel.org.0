Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67F83F243B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 02:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhHTAvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 20:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbhHTAvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 20:51:25 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06045C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 17:50:48 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id z18so15671985ybg.8
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 17:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E2ryeNIAmRPtS8I26OcS5h0NOdZm9kmoQUHVGL5W7K8=;
        b=tfUq4cDsNfBm9JbU4nHtguxXxbAp/zCcuvyuAscWp8l3dQ2PbSQ2XSV54hdiVBJKmM
         s7aDuThAApBsiZ9/xSvjvvRX1zuly22dXqa/iwU0NRTQKdkqwyEkHSKieJO1MA2xt6B+
         +2WbqBDj0YTrXNd+VIReq8lZR9BuxdgDoq6dOD/ssaIdBra2pY6XGwRDS403Kxu8uMTM
         GBGhckxx19jMG8MWSgc/NNd7qvB2evqdm8iI/lQHhNbL23+LDzI7kFSSt+ocDQNMpMku
         PY9a7Ai0dvpVNFXXPXIoEZPWghPg1o4/chWa7E/GaNzhh42IDhPaufPe5Xbyn+IZA+Jy
         PYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E2ryeNIAmRPtS8I26OcS5h0NOdZm9kmoQUHVGL5W7K8=;
        b=fxBJuBPXzB4lTlm3JeNHkSE+DONMalumb2q6snFU5bjiGLGymwY3LMWQ0HjITOJlKs
         GnQHvT2B15kBYRRToWpc4KAi+GVlK9eFLftK/9Oupu6/REr7tZYFDcI46qK61kkbFcL7
         nuGo3TmEaie28NkNtdXSh04tS40y88a1SAwLwJsLTs3RiK0Ob82G14OEQP9z7VWszVXN
         2btYdN77XXdrkLluKLnqVSygr1c02EJBXsess5cpsDbb2QheZX7mVA3AzZyEHIxSv+7q
         rWOIREtycduTiJvRYjTkMPheLMlxHlSdW/WvhpaCQFiNf23qEPRyvC8aDDSnaqXArzuM
         /pbA==
X-Gm-Message-State: AOAM533gpnFmBfrGE0zhX5EdU++w3gEwf445gsSvXuOB5HqIVgyjXCxZ
        xEXGRjuoMxAPQnoKKVfdskCZEAFjNft885dXDt9J6Q==
X-Google-Smtp-Source: ABdhPJw8yUGynFm9Gus6LKV/cqw3Ux1PfgYMpTbdETfUrQYiQo81WdPhd4zNG34xWyxWrjnw7FpQdQQrp7BSRG4XAZI=
X-Received: by 2002:a25:bdc6:: with SMTP id g6mr21081115ybk.310.1629420646955;
 Thu, 19 Aug 2021 17:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk> <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <20210819112246.k2om3r7der3xnxq6@skbuf>
In-Reply-To: <20210819112246.k2om3r7der3xnxq6@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 19 Aug 2021 17:50:10 -0700
Message-ID: <CAGETcx80bUnDQJCozCy3Q6KfPzMBL26Wmxem7ELoJZO8hZFVPg@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 4:23 AM Vladimir Oltean <vladimir.oltean@nxp.com> w=
rote:
>
> On Wed, Aug 18, 2021 at 08:28:44PM -0700, Saravana Kannan wrote:
> > On Wed, Aug 18, 2021 at 3:18 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.d=
k> wrote:
> > >
> > > Hi Saravana,
> > >
> > > On 8/18/21 4:46 AM, Saravana Kannan wrote:
> > > > On Tue, Aug 17, 2021 at 3:31 PM Vladimir Oltean <olteanv@gmail.com>=
 wrote:
> > > >>
> > > >> Hi Alvin,
> > > >>
> > > >> On Tue, Aug 17, 2021 at 09:25:28PM +0000, Alvin =C5=A0ipraga wrote=
:
> > > >>> I have an observation that's slightly out of the scope of your pa=
tch,
> > > >>> but I'll post here on the off chance that you find it relevant.
> > > >>> Apologies if it's out of place.
> > > >>>
> > > >>> Do these integrated NXP PHYs use a specific PHY driver, or do the=
y just
> > > >>> use the Generic PHY driver?
> > > >>
> > > >> They refuse to probe at all with the Generic PHY driver. I have be=
en
> > > >> caught off guard a few times now when I had a kernel built with
> > > >> CONFIG_NXP_C45_TJA11XX_PHY=3Dn and their probing returns -22 in th=
at case.
> > > >>
> > > >>> If the former is the case, do you experience that the PHY driver =
fails
> > > >>> to get probed during mdiobus registration if the kernel uses
> > > >>> fw_devlink=3Don?
> > > >>
> > > >> I don't test with "fw_devlink=3Don" in /proc/cmdline, this is the =
first
> > > >> time I do it. It behaves exactly as you say.
>
> Sorry for the delay, I wanted to reconfirm what I said (hint, I was wrong=
).
>
> In my case, whatever I do, I cannot get the driver core enforce a device
> link between the ethernet-switch and the PHY.
>
> So I cannot actually see the same issue. What I was seeing was in fact
> stupid testing on my part (it was working with the PHY driver as
> built-in, it was working, then I made it a module, it broke, I forgot to
> switch it back to module, then I thought it's broken while the PHY is
> built-in).

Sorry, this email is too "messy" for me and I joined this thread
halfway through. So if everything is working fine for you with
fw_devlink=3Don, I'd rather not dig into this. Too much stuff to do.

I'd be nice if you had put the boot logs, the DT file and the shell
command stuff into separate files and attached them. I guess I could
do that myself, but that's going to happen only when I get around to
it :)

>
> > > >>
> > > >>>
> > > >>> In my case I am writing a new subdriver for realtek-smi, a DSA dr=
iver
> > > >>> which registers an internal MDIO bus analogously to sja1105, whic=
h is
> > > >>> why I'm asking. I noticed a deferred probe of the PHY driver beca=
use the
> > > >>> supplier (ethernet-switch) is not ready - presumably because all =
of this
> > > >>> is happening in the probe of the switch driver. See below:
> > > >>>
> > > >>> [   83.653213] device_add:3270: device: 'SMI-0': device_add
> > > >>> [   83.653905] device_pm_add:136: PM: Adding info for No Bus:SMI-=
0
> > > >>> [   83.654055] device_add:3270: device: 'platform:ethernet-switch=
--mdio_bus:SMI-0': device_add
> > > >>> [   83.654224] device_link_add:843: mdio_bus SMI-0: Linked as a s=
ync state only consumer to ethernet-switch
> > > >>> [   83.654291] libphy: SMI slave MII: probed
> > > >>> ...
> > > >>> [   83.659809] device_add:3270: device: 'SMI-0:00': device_add
> > > >>> [   83.659883] bus_add_device:447: bus: 'mdio_bus': add device SM=
I-0:00
> > > >>> [   83.659970] device_pm_add:136: PM: Adding info for mdio_bus:SM=
I-0:00
> > > >>> [   83.660122] device_add:3270: device: 'platform:ethernet-switch=
--mdio_bus:SMI-0:00': device_add
> > > >>> [   83.660274] devices_kset_move_last:2701: devices_kset: Moving =
SMI-0:00 to end of list
> > > >>> [   83.660282] device_pm_move_last:203: PM: Moving mdio_bus:SMI-0=
:00 to end of list
> > > >>> [   83.660293] device_link_add:859: mdio_bus SMI-0:00: Linked as =
a consumer to ethernet-switch
> > > >>> [   83.660350] __driver_probe_device:736: bus: 'mdio_bus': __driv=
er_probe_device: matched device SMI-0:00 with driver RTL8365MB-VC Gigabit E=
thernet
> > > >>> [   83.660365] device_links_check_suppliers:1001: mdio_bus SMI-0:=
00: probe deferral - supplier ethernet-switch not ready
> > > >>> [   83.660376] driver_deferred_probe_add:138: mdio_bus SMI-0:00: =
Added to deferred list
> > > >>
> > > >> So it's a circular dependency? Switch cannot finish probing becaus=
e it
> > > >> cannot connect to PHY, which cannot probe because switch has not
> > > >> finished probing, which....
> > > >
> > > > Hi Vladimir/Alvin,
> > > >
> > > > If there's a cyclic dependency between two devices, then fw_devlink=
=3Don
> > > > is smart enough to notice that. Once it notices a cycle, it knows t=
hat
> > > > it can't tell which one is the real dependency and which one is the
> > > > false dependency and so stops enforcing ordering between the device=
s
> > > > in the cycle.
> > > >
> > > > But fw_devlink doesn't understand all the properties yet. Just most=
 of
> > > > them and I'm always trying to add more. So when it only understands
> > > > the property that's causing the false dependency but not the proper=
ty
> > > > that causes the real dependency, it can cause issues like this wher=
e
> > > > fw_devlink=3Don enforces the false dependency and the driver/code
> > > > enforces the real dependency. These are generally easy to fix -- yo=
u
> > > > just need to teach fw_devlink how to parse more properties.
> > > >
> > > > This is just a preliminary analysis since I don't have all the info
> > > > yet -- so I could be wrong. With that said, I happened to be workin=
g
> > > > on adding fw_devlink support for phy-handle property and I think it
> > > > should fix your issue with fw_devlink=3Don. Can you give [1] a shot=
?
> > >
> > > I tried [1] but it did not seem to have any effect.
> > >
>
> I applied the phy-handle patch, and here are my boot logs.
>



> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
> [    0.000000] Linux version 5.14.0-rc5+ (tigrisor@skbuf) (aarch64-linux-=
gnu-gcc (Linaro GCC 7.5-2019.12) 7.5.0, GNU ld (Linaro_Binutils-2019.12) 2.=
28.2.20170706) #440 SMP Thu Aug 19 13:48:11 EEST 2021
> [    0.000000] Machine model: NXP Layerscape LX2160ABLUEBOX3
> [    0.000000] fw_devlink_setup: fw_devlink_flags =3D 0x120
> [    0.000000] efi: UEFI not found.
> [    0.000000] [Firmware Bug]: Kernel image misaligned at boot, please fi=
x your bootloader!

Snipped the logs

> [   19.389542]     TERM=3Dlinux
> INIT: version  booting
> Fuse filesystem already available.
> Mounting fuse control filesystem.
> Starting udev
> [   19.720832] udevd[480]: starting version 3.2.9
> [   19.756177] udevd[481]: starting eudev-3.2.9
> [   19.902508] fsl_dpaa2_eth dpni.3 dpmac10: renamed from eth2
> [   19.908092] net eth2: renaming to dpmac10
> [   19.984284] fsl_dpaa2_eth dpni.4 dpmac17: renamed from eth1
> [   19.989997] net eth1: renaming to dpmac17
> [   20.020231] fsl_dpaa2_eth dpni.2 dpmac9: renamed from eth3
> [   20.025849] net eth3: renaming to dpmac9
> [   20.079989] fsl_dpaa2_eth dpni.0 dpmac5: renamed from eth4
> [   20.085493] net eth4: renaming to dpmac5
> [   20.127996] fsl_dpaa2_eth dpni.5 dpmac18: renamed from eth0
> [   20.133603] net eth0: renaming to dpmac18
> [   20.166859] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Som=
e data may be corrupt. Please run fsck.
> [   20.206953] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null). Quota mode:=
 none.
> Starting tcf-agent: OK
>
> lx2160abluebox3 login: root
> root@lx2160abluebox3:~# ls -la /sys/bus/mdio_bus/devices/
> total 0
> drwxr-xr-x 2 root root 0 Jan  1  1970 .
> drwxr-xr-x 4 root root 0 Jan  1  1970 ..
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008b96000:00 -> ../../../d=
evices/platform/soc/8b96000.mdio/mdio_bus/0x0000000008b96000/0x0000000008b9=
6000:00
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008b96000:01 -> ../../../d=
evices/platform/soc/8b96000.mdio/mdio_bus/0x0000000008b96000/0x0000000008b9=
6000:01
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008b96000:02 -> ../../../d=
evices/platform/soc/8b96000.mdio/mdio_bus/0x0000000008b96000/0x0000000008b9=
6000:02
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008b96000:08 -> ../../../d=
evices/platform/soc/8b96000.mdio/mdio_bus/0x0000000008b96000/0x0000000008b9=
6000:08
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008b97000:00 -> ../../../d=
evices/platform/soc/8b97000.mdio/mdio_bus/0x0000000008b97000/0x0000000008b9=
7000:00
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008b97000:08 -> ../../../d=
evices/platform/soc/8b97000.mdio/mdio_bus/0x0000000008b97000/0x0000000008b9=
7000:08
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008c17000:00 -> ../../../d=
evices/platform/soc/8c17000.mdio/mdio_bus/0x0000000008c17000/0x0000000008c1=
7000:00
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008c27000:00 -> ../../../d=
evices/platform/soc/8c27000.mdio/mdio_bus/0x0000000008c27000/0x0000000008c2=
7000:00
> lrwxrwxrwx 1 root root 0 Jan  1  1970 0x0000000008c2b000:00 -> ../../../d=
evices/platform/soc/8c2b000.mdio/mdio_bus/0x0000000008c2b000/0x0000000008c2=
b000:00
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.0-base-t1:01 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.0/mdio_bus/spi1.0-base-t1/spi1.0-base-t1:01
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.0-base-t1:02 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.0/mdio_bus/spi1.0-base-t1/spi1.0-base-t1:02
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.0-base-t1:03 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.0/mdio_bus/spi1.0-base-t1/spi1.0-base-t1:03
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.0-base-t1:04 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.0/mdio_bus/spi1.0-base-t1/spi1.0-base-t1:04
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.0-base-t1:05 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.0/mdio_bus/spi1.0-base-t1/spi1.0-base-t1:05
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.0-base-t1:06 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.0/mdio_bus/spi1.0-base-t1/spi1.0-base-t1:06
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.2-base-t1:01 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.2/mdio_bus/spi1.2-base-t1/spi1.2-base-t1:01
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.2-base-t1:02 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.2/mdio_bus/spi1.2-base-t1/spi1.2-base-t1:02
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.2-base-t1:03 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.2/mdio_bus/spi1.2-base-t1/spi1.2-base-t1:03
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.2-base-t1:04 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.2/mdio_bus/spi1.2-base-t1/spi1.2-base-t1:04
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.2-base-t1:05 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.2/mdio_bus/spi1.2-base-t1/spi1.2-base-t1:05
> lrwxrwxrwx 1 root root 0 Jan  1  1970 spi1.2-base-t1:06 -> ../../../devic=
es/platform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1=
.2/mdio_bus/spi1.2-base-t1/spi1.2-base-t1:06
> root@lx2160abluebox3:~# ls -la /sys/bus/mdio_bus/devices/spi1.0-base-t1\:=
01
> spi1.0-base-t1:01/
> root@lx2160abluebox3:~# ls -la /sys/bus/mdio_bus/devices/spi1.0-base-t1\:=
01/
> total 0
> drwxr-xr-x  4 root root    0 Jan  1  1970 .
> drwxr-xr-x 10 root root    0 Jan  1  1970 ..
> lrwxrwxrwx  1 root root    0 Mar  9 12:35 driver -> ../../../../../../../=
../../../../../../../bus/mdio_bus/drivers/NXP C45 TJA1103
> lrwxrwxrwx  1 root root    0 Mar  9 12:35 of_node -> ../../../../../../..=
/../../../../../../../firmware/devicetree/base/soc/i2c@2000000/i2c-mux@77/i=
2c@7/i2c-mux@75/i2c@0/spi@28/ethernet-switch@0/mdios/mdio
> @0/ethernet-phy@1
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_dev_flags
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_has_fixups
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_id
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_interface
> drwxr-xr-x  2 root root    0 Mar  9 12:35 power
> drwxr-xr-x  2 root root    0 Mar  9 12:35 statistics
> lrwxrwxrwx  1 root root    0 Mar  9 12:35 subsystem -> ../../../../../../=
../../../../../../../../bus/mdio_bus
> -rw-r--r--  1 root root 4096 Jan  1  1970 uevent
> root@lx2160abluebox3:~#
> root@lx2160abluebox3:~# ls -la /sys/bus/spi/devices/spi1.0/
> total 0
> drwxr-xr-x  7 root root    0 Jan  1  1970 .
> drwxr-xr-x  6 root root    0 Jan  1  1970 ..
> lrwxrwxrwx  1 root root    0 Mar  9 12:36 driver -> ../../../../../../../=
../../../../bus/spi/drivers/sja1105
> -rw-r--r--  1 root root 4096 Mar  9 12:36 driver_override
> drwxr-xr-x  4 root root    0 Jan  1  1970 mdio_bus
> -r--r--r--  1 root root 4096 Mar  9 12:36 modalias
> drwxr-xr-x 10 root root    0 Jan  1  1970 net
> lrwxrwxrwx  1 root root    0 Mar  9 12:36 of_node -> ../../../../../../..=
/../../../../firmware/devicetree/base/soc/i2c@2000000/i2c-mux@77/i2c@7/i2c-=
mux@75/i2c@0/spi@28/ethernet-switch@0
> drwxr-xr-x  2 root root    0 Mar  9 12:36 power
> drwxr-xr-x  3 root root    0 Jan  1  1970 ptp
> drwxr-xr-x  2 root root    0 Mar  9 12:36 statistics
> lrwxrwxrwx  1 root root    0 Jan  1  1970 subsystem -> ../../../../../../=
../../../../../bus/spi
> lrwxrwxrwx  1 root root    0 Mar  9 12:36 supplier:fsl-mc:dpni.4 -> ../..=
/../../../../../../../../virtual/devlink/fsl-mc:dpni.4--spi:spi1.0
> -rw-r--r--  1 root root 4096 Jan  1  1970 uevent
> INIT: Id "S0" respawning too fast: disabled for 5 minutes                =
                                                                           =
                                                        c
> lass/mdio_bus/
> total 0
> drwxr-xr-x  2 root root 0 Jan  1  1970 .
> drwxr-xr-x 70 root root 0 Jan  1  1970 ..
> lrwxrwxrwx  1 root root 0 Jan  1  1970 0x0000000008b96000 -> ../../device=
s/platform/soc/8b96000.mdio/mdio_bus/0x0000000008b96000
> lrwxrwxrwx  1 root root 0 Jan  1  1970 0x0000000008b97000 -> ../../device=
s/platform/soc/8b97000.mdio/mdio_bus/0x0000000008b97000
> lrwxrwxrwx  1 root root 0 Jan  1  1970 0x0000000008c17000 -> ../../device=
s/platform/soc/8c17000.mdio/mdio_bus/0x0000000008c17000
> lrwxrwxrwx  1 root root 0 Jan  1  1970 0x0000000008c27000 -> ../../device=
s/platform/soc/8c27000.mdio/mdio_bus/0x0000000008c27000
> lrwxrwxrwx  1 root root 0 Jan  1  1970 0x0000000008c2b000 -> ../../device=
s/platform/soc/8c2b000.mdio/mdio_bus/0x0000000008c2b000
> lrwxrwxrwx  1 root root 0 Jan  1  1970 fixed-0 -> ../../devices/platform/=
Fixed MDIO bus.0/mdio_bus/fixed-0
> lrwxrwxrwx  1 root root 0 Jan  1  1970 spi1.0-base-t1 -> ../../devices/pl=
atform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1.0/md=
io_bus/spi1.0-base-t1
> lrwxrwxrwx  1 root root 0 Jan  1  1970 spi1.0-pcs -> ../../devices/platfo=
rm/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1.0/mdio_b=
us/spi1.0-pcs
> lrwxrwxrwx  1 root root 0 Jan  1  1970 spi1.2-base-t1 -> ../../devices/pl=
atform/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1.2/md=
io_bus/spi1.2-base-t1
> lrwxrwxrwx  1 root root 0 Jan  1  1970 spi1.2-pcs -> ../../devices/platfo=
rm/soc/2000000.i2c/i2c-0/i2c-9/i2c-10/10-0028/spi_master/spi1/spi1.2/mdio_b=
us/spi1.2-pcs
> root@lx2160abluebox3:~# ls -la /sys/class/mdio_bus/spi1.0-base-t1/
> total 0
> drwxr-xr-x 10 root root    0 Jan  1  1970 .
> drwxr-xr-x  4 root root    0 Jan  1  1970 ..
> lrwxrwxrwx  1 root root    0 Mar  9 12:37 device -> ../../../spi1.0
> lrwxrwxrwx  1 root root    0 Mar  9 12:37 of_node -> ../../../../../../..=
/../../../../../../firmware/devicetree/base/soc/i2c@2000000/i2c-mux@77/i2c@=
7/i2c-mux@75/i2c@0/spi@28/ethernet-switch@0/mdios/mdio@0
> drwxr-xr-x  2 root root    0 Mar  9 12:37 power
> drwxr-xr-x  4 root root    0 Jan  1  1970 spi1.0-base-t1:01
> drwxr-xr-x  4 root root    0 Jan  1  1970 spi1.0-base-t1:02
> drwxr-xr-x  4 root root    0 Jan  1  1970 spi1.0-base-t1:03
> drwxr-xr-x  4 root root    0 Jan  1  1970 spi1.0-base-t1:04
> drwxr-xr-x  4 root root    0 Jan  1  1970 spi1.0-base-t1:05
> drwxr-xr-x  4 root root    0 Jan  1  1970 spi1.0-base-t1:06
> drwxr-xr-x  2 root root    0 Mar  9 12:37 statistics
> lrwxrwxrwx  1 root root    0 Jan  1  1970 subsystem -> ../../../../../../=
../../../../../../../class/mdio_bus
> -rw-r--r--  1 root root 4096 Jan  1  1970 uevent
> -r--r--r--  1 root root 4096 Mar  9 12:37 waiting_for_supplier
> root@lx2160abluebox3:~# ls -la /sys/class/mdio_bus/spi1.0-base-t1/spi1.0-=
base-t1\:01/
> total 0
> drwxr-xr-x  4 root root    0 Jan  1  1970 .
> drwxr-xr-x 10 root root    0 Jan  1  1970 ..
> lrwxrwxrwx  1 root root    0 Mar  9 12:35 driver -> ../../../../../../../=
../../../../../../../bus/mdio_bus/drivers/NXP C45 TJA1103
> lrwxrwxrwx  1 root root    0 Mar  9 12:35 of_node -> ../../../../../../..=
/../../../../../../../firmware/devicetree/base/soc/i2c@2000000/i2c-mux@77/i=
2c@7/i2c-mux@75/i2c@0/spi@28/ethernet-switch@0/mdios/mdio
> @0/ethernet-phy@1
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_dev_flags
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_has_fixups
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_id
> -r--r--r--  1 root root 4096 Mar  9 12:35 phy_interface
> drwxr-xr-x  2 root root    0 Mar  9 12:35 power
> drwxr-xr-x  2 root root    0 Mar  9 12:35 statistics
> lrwxrwxrwx  1 root root    0 Mar  9 12:35 subsystem -> ../../../../../../=
../../../../../../../../bus/mdio_bus
> -rw-r--r--  1 root root 4096 Jan  1  1970 uevent
>
> As you can see, there was no provider/consumer relationship enforced
> between the PHY at spi1.0-base-t1\:01 and the ethernet-switch.

So the only thing that's "not working" right now is that you are
saying the fw_devlink phy-handle patch doesn't seem to have an impact?

To make it easy for me, can you give me the name of this node in DT?
There are too many MDIOs and SPIs and PHY for me to keep track in my
head.

Since this isn't explicitly breaking anything, I'll get around to this
when I have time.

-Saravana
