Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9EB6236A9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiKIWjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKIWjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:39:20 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03CCD13D;
        Wed,  9 Nov 2022 14:39:19 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id r12so28357648lfp.1;
        Wed, 09 Nov 2022 14:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PvI/yUyITk/smf53vr38dj475/4tnk0u2sD458x+0bk=;
        b=U9CKhYkGzkPuA8fgmaTsHOtMCEYBcK3ZBV/j2sk1XUPtk3kvtalIepxmf/63m19aFg
         ucOZlFwpOoi0BU6HeUFYmRQ0HV5W3VYlzMdk6UrVCwa4rAdRiI+U37ss07D9WyIDDdlM
         3uryCU9NAHUH1MlEMW4hO2yaNBy0ZoQRIeKVW/m3z6O6pHiMAOfwTL5iDYMGnW0VHyED
         GOwdrSL6Xlauaok+1M/QFu0JR8sIiwr3P9JmAhGI/ySBd+ptbK2g8E7YtIw4VaLoRins
         Zwq4XI3ZBtlkRkwL6dloRhjR00l1OrzqSBGa8bdfr/13rRIbTr4bxhzuz69hetXjV7sb
         0Wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PvI/yUyITk/smf53vr38dj475/4tnk0u2sD458x+0bk=;
        b=e36Zhh9lI+SzuAyCEPZkOEFyUf2b1n5DnJuhx8Sk0RQpg7OocOxkuBxWeiO7oRkx80
         xXKa5TAd14+2XD0w+jgiJ3RpM0UeHgapiO9uIcD9XZPsUNBKDPaUvK7BqKgfIExgzzu3
         e3jcQEAtS43W/L83uxdIIIoZ/+yMRHcy8Yt3YUWI9bFO4xF4zoaMwRc7wE+FDyHWD03y
         Bo2csUSxIUOoDERiioUdtKeltygc8s6b1eemAcLBcUWz7FshcHKg9GVn/aOF/6gqosav
         JFEl0p0WsVOjJRZ3OBj1BjzMq9jRe7aJ4aUAbB6ZyN4ErdBmj9seXmqlPApSrVj1k6+G
         mtaw==
X-Gm-Message-State: ACrzQf0Skgn3YyGFq0Y9WMiga+xlctzHmt/bzsOK1DXICiORhFTTYJU3
        5tHf+mnAdZQMtk1ToyUL/B4b22eICEnfzq7P+EQ=
X-Google-Smtp-Source: AMsMyM5CigGd261vGZLuw3ULv9z8hB2jfeLYPV/I7RGWEIbz3eZDiiSzT5WUc1pN6UJ3OvaWAT4UGSqL2GbMeEFBBn8=
X-Received: by 2002:a05:6512:2242:b0:4a2:3890:5156 with SMTP id
 i2-20020a056512224200b004a238905156mr855357lfu.106.1668033557940; Wed, 09 Nov
 2022 14:39:17 -0800 (PST)
MIME-Version: 1.0
References: <20221029202454.25651-1-swyterzone@gmail.com> <20221029202454.25651-3-swyterzone@gmail.com>
 <CABBYNZKnw+b+KE2=M=gGV+rR_KBJLvrxRrtEc8x12W6PY=LKMw@mail.gmail.com> <ac1d556f-fe51-1644-0e49-f7b8cf628969@gmail.com>
In-Reply-To: <ac1d556f-fe51-1644-0e49-f7b8cf628969@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 9 Nov 2022 14:39:06 -0800
Message-ID: <CABBYNZJytVc8=A0_33EFRS_pMG6aUKnfFPsGii_2uKu7_zENtQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] Bluetooth: btusb: Add a parameter to let users
 disable the fake CSR force-suspend hack
To:     Swyter <swyterzone@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, luiz.von.dentz@intel.com,
        quic_zijuhu@quicinc.com, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, Jack <ostroffjh@users.sourceforge.net>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Swyter,

On Wed, Nov 9, 2022 at 1:30 PM Swyter <swyterzone@gmail.com> wrote:
>
> On 09/11/2022 21:49, Luiz Augusto von Dentz wrote:
> > Hi Ismael,
> >
> > On Sat, Oct 29, 2022 at 1:25 PM Ismael Ferreras Morezuelas
> > <swyterzone@gmail.com> wrote:
> >>
> >> A few users have reported that their cloned Chinese dongle doesn't
> >> work well with the hack Hans de Goede added, that tries this
> >> off-on mechanism as a way to unfreeze them.
> >>
> >> It's still more than worthwhile to have it, as in the vast majority
> >> of cases it either completely brings dongles to life or just resets
> >> them harmlessly as it already happens during normal USB operation.
> >>
> >> This is nothing new and the controllers are expected to behave
> >> correctly. But yeah, go figure. :)
> >>
> >> For that unhappy minority we can easily handle this edge case by letti=
ng
> >> users disable it via our =C2=ABbtusb.disable_fake_csr_forcesuspend_hac=
k=3D1=C2=BB kernel option.
> >
> > Don't really like the idea of adding module parameter for device
> > specific problem.
>
> It's not for a single device, it's for a whole class of unnamed devices
> that are currently screwed even after all this.
>
>
> >> -               ret =3D pm_runtime_suspend(&data->udev->dev);
> >> -               if (ret >=3D 0)
> >> -                       msleep(200);
> >> -               else
> >> -                       bt_dev_warn(hdev, "CSR: Couldn't suspend the d=
evice for our Barrot 8041a02 receive-issue workaround");
> >> +                       ret =3D pm_runtime_suspend(&data->udev->dev);
> >> +                       if (ret >=3D 0)
> >> +                               msleep(200);
> >> +                       else
> >> +                               bt_dev_warn(hdev, "CSR: Couldn't suspe=
nd the device for our Barrot 8041a02 receive-issue workaround");
> >
> > Is this specific to Barrot 8041a02? Why don't we add a quirk then?
> >
>
> We don't know how specific it is, we suspect the getting stuck thing happ=
ens with Barrot controllers,
> but in this world of lasered-out counterfeit chip IDs you can never be su=
re. Unless someone decaps them.
>
> Hans added that name because it's the closest thing we have, but this app=
lies to a lot of chips.
> So much that now we do the hack by default, for very good reasons.
>
> So please reconsider, this closes the gap.
>
> With this last patch we go from ~+90% to almost ~100%, as the rest of gen=
eric quirks we added
> don't really hurt; even if a particular dongle only needs a few of the zo=
o of quirks we set,
> it's alright if we vaccinate them against all of these, except some are "=
allergic"
> against this particular "vaccine". Let people skip this one. :-)
>
> You know how normal BT controllers are utterly and inconsistently broken,=
 now imagine you have a whole host
> of vendors reusing a VID/PID/version/subversion, masking as a CSR for biz=
arre reasons to avoid paying
> any USB-IF fees, or whatever. That's what we are fighting against here.

I see, but for suspend in particular, can't we actually handle it
somehow? I mean if we can detect the controller is getting stuck and
print some information and flip the quirk? Otherwise Im afraid this
parameter will end up always being set by distros to avoid suspend
problems.

--=20
Luiz Augusto von Dentz
