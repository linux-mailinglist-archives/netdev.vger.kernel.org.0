Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9CD1E369F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgE0DhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgE0DhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:37:23 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57A3C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:37:22 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id r125so13564739lff.13
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fS6PMy/B05N08xrMkpjBfBmpPsKPC4zTRLqWBH4zjsU=;
        b=cWBN7qv01u38/QHVIEQ+xAgaZ/x9EEyEpJhPxSD3SH9fcw6XYdW+eCBCQIb+uQgHlM
         j7tNWeFR1aB7uhtcRy40wNjuonTLA6crsidzAi5DYKyb7Nq8EBlbFEo+8Oc634m21soS
         fcRJlFl8TIJvQ6b4PylxFS672EybqoUeAMUz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fS6PMy/B05N08xrMkpjBfBmpPsKPC4zTRLqWBH4zjsU=;
        b=ZfX/yjTqlNvmeCiGxJxieK9Z5bzugnEpyuqk5KjLpe1WWePMMApucCEJO+BoMhsVnu
         Fmprjp+q+JgJv6lfKyncBzeE4m2VZxItVJPFokchbbtnwKcQA8X0jSyw2S/RnA+LyJB+
         jhu50G2GdWbJix4w3fZJnZ9Y0RB3ODkryGqf01lfPw+q+my3eVeNNL8lQy2R+Ye1lEhS
         +huTLuDLmXRaIlIrHiIhAszbKgVJVTY8eKqZXDg8zE3s62tpmk2NQQqRod+5/s/XHhnb
         tUppRGuJEiud0ZaZ+n/qv/E/JzdaW/jRRy98c+mcFE4Cy2iMatF0Y4kZKzkeqazsu25Z
         hRpA==
X-Gm-Message-State: AOAM533eqbz80RSbErkzNF5OAD5FA3oX/5yZWy3/pRuuS9oU0cHEZ5Vq
        ZS3JCab7hbzu4gvdclbFo5liaUCOOf07P9l+xueqBw==
X-Google-Smtp-Source: ABdhPJyyxZR0vdPICLcBn9ebYI11LevZ6H4YnwJReT28W6Ih5uNxRUKbbPf7x2VVLulwwUN+FTqewxOK8HDRsuTdHXk=
X-Received: by 2002:a19:7e15:: with SMTP id z21mr2005869lfc.103.1590550640730;
 Tue, 26 May 2020 20:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200524045335.GA22938@nanopsycho> <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho> <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho> <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho> <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
In-Reply-To: <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 27 May 2020 09:07:09 +0530
Message-ID: <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 7:53 PM Vasundhara Volam
<vasundhara-v.volam@broadcom.com> wrote:
>
> On Tue, May 26, 2020 at 7:10 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Tue, May 26, 2020 at 08:42:28AM CEST, vasundhara-v.volam@broadcom.com wrote:
> > >On Tue, May 26, 2020 at 10:17 AM Jiri Pirko <jiri@resnulli.us> wrote:
> > >>
> > >> Tue, May 26, 2020 at 06:28:59AM CEST, vasundhara-v.volam@broadcom.com wrote:
> > >> >On Mon, May 25, 2020 at 10:56 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > >> >>
> > >> >> Sun, May 24, 2020 at 08:29:56AM CEST, vasundhara-v.volam@broadcom.com wrote:
> > >> >> >On Sun, May 24, 2020 at 10:23 AM Jiri Pirko <jiri@resnulli.us> wrote:
> > >> >> >>
> > >> >> >> Sat, May 23, 2020 at 08:08:22AM CEST, vasundhara-v.volam@broadcom.com wrote:
> > >> >> >> >Add a new "allow_fw_live_reset" generic device bool parameter. When
> > >> >> >> >parameter is set, user is allowed to reset the firmware in real time.
> > >> >> >> >
> > >> >> >> >This parameter is employed to communicate user consent or dissent for
> > >> >> >> >the live reset to happen. A separate command triggers the actual live
> > >> >> >> >reset.
> > >> >> >> >
> > >> >> >> >Cc: Jiri Pirko <jiri@mellanox.com>
> > >> >> >> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > >> >> >> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > >> >> >> >---
> > >> >> >> >v2: Rename param name to "allow_fw_live_reset" from
> > >> >> >> >"enable_hot_fw_reset".
> > >> >> >> >Update documentation for the param in devlink-params.rst file.
> > >> >> >> >---
> > >> >> >> > Documentation/networking/devlink/devlink-params.rst | 6 ++++++
> > >> >> >> > include/net/devlink.h                               | 4 ++++
> > >> >> >> > net/core/devlink.c                                  | 5 +++++
> > >> >> >> > 3 files changed, 15 insertions(+)
> > >> >> >> >
> > >> >> >> >diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
> > >> >> >> >index d075fd0..ad54dfb 100644
> > >> >> >> >--- a/Documentation/networking/devlink/devlink-params.rst
> > >> >> >> >+++ b/Documentation/networking/devlink/devlink-params.rst
> > >> >> >> >@@ -108,3 +108,9 @@ own name.
> > >> >> >> >    * - ``region_snapshot_enable``
> > >> >> >> >      - Boolean
> > >> >> >> >      - Enable capture of ``devlink-region`` snapshots.
> > >> >> >> >+   * - ``allow_fw_live_reset``
> > >> >> >> >+     - Boolean
> > >> >> >> >+     - Firmware live reset allows users to reset the firmware in real time.
> > >> >> >> >+       For example, after firmware upgrade, this feature can immediately reset
> > >> >> >> >+       to run the new firmware without reloading the driver or rebooting the
> > >> >> >>
> > >> >> >> This does not tell me anything about the reset being done on another
> > >> >> >> host. You need to emhasize that, in the name of the param too.
> > >> >> >I am not sure if I completely understand your query.
> > >> >> >
> > >> >> >Reset is actually initiated by one of the PF/host of the device, which
> > >> >> >resets the entire same device.
> > >> >> >
> > >> >> >Reset is not initiated by any other remote device/host.
> > >> >>
> > >> >> Well, in case of multihost system, it might be, right?
> > >> >>
> > >> >In case of multi-host system also, it is one of the host that triggers
> > >> >the reset, which resets the entire same device. I don't think this is
> > >> >remote.
> > >> >
> > >> >As the parameter is a device parameter, it is applicable to the entire
> > >> >device. When a user initiates the reset from any of the host in case
> > >> >of multi-host and any of the PF in case of stand-alone or smartNIC
> > >> >device, the entire device goes for a reset.
> > >> >
> > >> >I will be expanding the description to the following to make it more clear.
> > >> >
> > >> >------------------------
> > >> >- Firmware live reset allows users to reset the firmware in real time.
> > >> >For example, after firmware upgrade, this feature can immediately
> > >> >reset to run the new firmware without reloading the driver or
> > >> >rebooting the system.
> > >> >When a user initiates the reset from any of the host (in case of
> > >> >multi-host system) / PF (in case of stand-alone or smartNIC device),
> > >> >the entire device goes for a reset when the parameter is enabled.
> > >>
> > >> Sorry, this is still not clear. I think that you are mixing up two
> > >> different things:
> > >> 1) option of devlink reload to indicate that user is interested in "live
> > >>    reset" of firmware without reloading driver
> > >
> > >This is the option we are trying to add. If a user is interested in
> > >"live reset", he needs to enable the parameter to enable it in device
> > >capabilities, which is achieved by permanent configuration mode. When
> > >capability is enabled in the device, new firmware which is aware will
> > >allocate the resources and exposes the capability to host drivers.
> > >
> > >But firmware allows the "live reset" only when all the loaded drivers
> > >are aware of/supports the capability. For example, if any of the host
> > >is loaded with an old driver, "live reset" is not allowed until the
> > >driver is upgraded or unloaded. or if the host driver turns it off,
> > >then also "live reset" is not allowed.
> > >
> > >In case of runtime parameter cmode, if any of the host turns off the
> > >capability in the host driver, "live reset" is not allowed until the
> > >driver is unloaded or the user enables it again.
> > >
> > >To make it clear, I can add two parameters.
> > >
> > >1. enable_fw_live_reset - To indicate that the user is interested in
> > >"live reset". This will be a generic param.
> >
> > As I wrote above, I believe this should be an option
> > to "devlink dev reload", not a param.
> I think you are still confused with enabling feature in NVRAM
> configuration of the device and command to trigger reset. This param
> will enable the feature in the device NVRAM configuration and does not
> trigger the actual reset.
>
> Only when the param is set, feature will be enabled in the device and
> firmware supports the "live reset". When the param is disabled,
> firmware cannot support "live reset" and user needs to do PCIe reset
> after flashing the firmware for it to take effect..
>
> Once feature is enabled in NVRAM configuration, it will be persistent
> across reboots.
>
> User still needs to use "devlink dev reload" command to do the "live reset".
Here is a sample sequence of commands to do a "live reset" to get some
clear idea.
Note that I am providing the examples based on the current patchset.

1. FW live reset is disabled in the device/adapter. Here adapter has 2
physical ports.

$ devlink dev
pci/0000:3b:00.0
pci/0000:3b:00.1
pci/0000:af:00.0
$ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
pci/0000:3b:00.0:
  name allow_fw_live_reset type generic
    values:
      cmode runtime value false
      cmode permanent value false
$ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
pci/0000:3b:00.1:
  name allow_fw_live_reset type generic
    values:
      cmode runtime value false
      cmode permanent value false

2. If a user issues "ethtool --reset p1p1 all", the device cannot
perform "live reset" as capability is not enabled. User needs to do a
driver reload, for firmware to undergo reset.

$ ethtool --reset p1p1 all
ETHTOOL_RESET 0xffffffff
Components reset:     0xff0000
Components not reset: 0xff00ffff
$ dmesg
[  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
[  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset

3. Now enable the capability in the device and reboot for device to
enable the capability. Firmware does not get reset just by setting the
param to true.

$ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
value true cmode permanent

4. After reboot, values of param.

$ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
pci/0000:3b:00.1:
  name allow_fw_live_reset type generic
    values:
      cmode runtime value true
      cmode permanent value true
$ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
pci/0000:3b:00.0:
  name allow_fw_live_reset type generic
    values:
      cmode runtime value true
      cmode permanent value true

5. Now issue the "ethtool --reset p1p1 all" and device will undergo
the "live reset". Reloading the driver is not required.

$ ethtool --reset p1p1 all
ETHTOOL_RESET 0xffffffff
Components reset:     0xff0000
Components not reset: 0xff00ffff
$ dmesg
[  117.432013] bnxt_en 0000:3b:00.0 p1p1: Firmware non-fatal reset
event received, max wait time 4200 msec
[  117.432015] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
[  117.432032] bnxt_en 0000:3b:00.1 p1p2: Firmware non-fatal reset
event received, max wait time 4200 msec
$ devlink health show pci/0000:3b:00.0 reporter fw_reset
pci/0000:3b:00.0:
  reporter fw_reset
    state healthy error 1 recover 1 grace_period 0 auto_recover true

6. If one of the host/PF turns off runtime param to false, "ethtool
--reset p1p1 all" behaves similar to step 2, until it turns it back
on.

$ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
value false cmode runtime
$ ethtool --reset p1p1 all
ETHTOOL_RESET 0xffffffff
Components reset:     0xff0000
Components not reset: 0xff00ffff
$ dmesg
[  327.610814] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
[  327.610828] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset

Thanks.
> >
> >
> > >
> > >2. allow_fw_live_reset - To indicate, if any of the host/PF turns it
> > >off, "live reset" is not allowed. This serves the purpose of what we
> > >are trying to add in runtime cmode.
> >
> > Yeah.
> And this param will enable the feature in the driver for driver to
> allow the firmware to go for "live reset", where as above param will
> enable the feature in NVRAM configuration of the device.
> >
> > >Do you want me to keep it as a driver-specific param?
> >
> > There is nothing driver-specific about this.
> okay.
> >
> >
> > >
> > >Please let me know if this is clear and makes less confusion.
> > >
> > >Thanks,
> > >Vasundhara
> > >
> > >> 2) devlink param that would indicate "I am okay if someone else (not by
> > >>    my devlink instance) resets my firmware".
> > >>
> > >> Could you please split?
> > >>
> > >>
> > >> >------------------------
> > >> >
> > >> >Thanks,
> > >> >Vasundhara
> > >> >>
> > >> >> >
> > >> >> >Thanks,
> > >> >> >Vasundhara
> > >> >> >>
> > >> >> >>
> > >> >> >>
> > >> >> >> >+       system.
> > >> >> >> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> > >> >> >> >index 8ffc1b5c..488b61c 100644
> > >> >> >> >--- a/include/net/devlink.h
> > >> >> >> >+++ b/include/net/devlink.h
> > >> >> >> >@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
> > >> >> >> >       DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
> > >> >> >> >       DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
> > >> >> >> >       DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
> > >> >> >> >+      DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
> > >> >> >> >
> > >> >> >> >       /* add new param generic ids above here*/
> > >> >> >> >       __DEVLINK_PARAM_GENERIC_ID_MAX,
> > >> >> >> >@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
> > >> >> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
> > >> >> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
> > >> >> >> >
> > >> >> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
> > >> >> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
> > >> >> >> >+
> > >> >> >> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
> > >> >> >> > {                                                                     \
> > >> >> >> >       .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
> > >> >> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> > >> >> >> >index 7b76e5f..8544f23 100644
> > >> >> >> >--- a/net/core/devlink.c
> > >> >> >> >+++ b/net/core/devlink.c
> > >> >> >> >@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> > >> >> >> >               .name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
> > >> >> >> >               .type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
> > >> >> >> >       },
> > >> >> >> >+      {
> > >> >> >> >+              .id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
> > >> >> >> >+              .name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
> > >> >> >> >+              .type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
> > >> >> >> >+      },
> > >> >> >> > };
> > >> >> >> >
> > >> >> >> > static int devlink_param_generic_verify(const struct devlink_param *param)
> > >> >> >> >--
> > >> >> >> >1.8.3.1
> > >> >> >> >
