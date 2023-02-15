Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36356972D4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 01:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjBOAr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 19:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBOAr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 19:47:26 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D31F10CD;
        Tue, 14 Feb 2023 16:47:24 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id bp15so25683005lfb.13;
        Tue, 14 Feb 2023 16:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzQJrxV9hAF5ihxylBRNbkixrbyb52d0rp9YwNTslCw=;
        b=A7JyLvMOImFCUL290Z8V2a+5sc+ao/PrIdPp4n8a9PZVagi/qZu0gYhJnTwDSxMgXQ
         +V84MdCu6OTtyhh1iE2+oimqa1Pxn34om6FwSQaNU5AqQFghbEiY3RyHp6/YpNiDgvNI
         JROWe/EX9bE+FsX4l0TnEotqI5BL5sPYqSXLr/gPNX9Gl9GQaYgilkoabLZEzEP7aNa1
         fTafQobxxnQ0Bf6wgXhpiV0dJn2qizc38CK1Esi/7/OyL9/eZolEJSpqYvmpHeBua4DT
         iBen2WUDCcEtaF1WFHsZlDlhgEy/syiCiZJQ+jGXeFGjXjOHchG6O20Cdy1/2qsMTur1
         Ys+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzQJrxV9hAF5ihxylBRNbkixrbyb52d0rp9YwNTslCw=;
        b=Maev5tHPH0lghylHSYTfTG0n6PboG/KF+nGJFCSy6MIf+3VVDZax75hYr/tbVCfwi+
         DmXKg1p4ogkbBtnxXQjCa3SEoyY0jJMchIKBsj6cBvxHAGAYn3QHyMSAllfUwUNVtEtj
         uV1PHK7NgjTfGf3f/KoWbSWx05taSi7dpEE41yHdLnNZ3lXlEddnQh56DY5AyU2MVnvQ
         z896OOztBbco6Cn7eYpIXACcuP3I1F1QiC7phH1srq90Z8Ke0Y/LRzYVUD7SDbPIW1BL
         XfqMu0LQdMu82sANvlq/ujdwFKzyaIxL7oVGA4sbGI9OqWzwF/ScAQo2mFKVr4L7MmbF
         kP/Q==
X-Gm-Message-State: AO0yUKWkkSdxkweAhFfuAZjGgXHZjBbubb5zOSzlQLA1PZYaatarvt1e
        aUG28j1RZspaxMrppsZSbPcz+nQ2jZ1MwMyKyfE=
X-Google-Smtp-Source: AK7set80eJ6UNldrMO85CNQOxNqPJ8L3pt3b+MYJR8qDiF8+xp8PXUJYpnHHPjRu4+TzmPoAGvI7gpigYzlFm8wc2fY=
X-Received: by 2002:a05:6512:3b0d:b0:4db:173e:812a with SMTP id
 f13-20020a0565123b0d00b004db173e812amr940307lfv.8.1676422042336; Tue, 14 Feb
 2023 16:47:22 -0800 (PST)
MIME-Version: 1.0
References: <20230214145609.kernel.v1.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
 <CABBYNZKVVo4T_pbEdozhNvgiykC7NiLQKEnJi3q5gZpHunGrbA@mail.gmail.com> <CAB4PzUo+EuapOr+O7eWZH2xiVVAUd98m_DmEK-337=CvfUDeoA@mail.gmail.com>
In-Reply-To: <CAB4PzUo+EuapOr+O7eWZH2xiVVAUd98m_DmEK-337=CvfUDeoA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 14 Feb 2023 16:47:10 -0800
Message-ID: <CABBYNZJJhNTrH85VuqvAQbk6JyNhQ5atXzxb+rV7JcrhkgFWpQ@mail.gmail.com>
Subject: Re: [kernel PATCH v1] Bluetooth: hci_sync: Resume adv with no RPA
 when active scan
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

Hi Zhengping,

On Tue, Feb 14, 2023 at 4:28 PM Zhengping Jiang <jiangzp@google.com> wrote:
>
> Hi Luiz,
>
> Thanks for the comment. I will submit a new patch to address that.
>
> I notice in the spec, it is mentioned
> > Note: This command does not affect the generation of Resolvable Private=
 Addresses.

Where is that mentioned?

> How should I understand this note? Does it mean even if the address
> resolution is disabled, the controller can still generate RPA for
> advertising?  Does it mean the advertising can always be resumed
> during active scan?

I think it may be related to the fact that it only affects the addr
resolution of remote devices, that said if you are active scanning
that probably means the user wants to setup a new device thus why we
don't enable any filtering like accept list, etc, so it is not really
useful to keep address resolution active either way.

> Thanks,
> Zhengping
>
> On Tue, Feb 14, 2023 at 4:09 PM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Zhengping,
> >
> > On Tue, Feb 14, 2023 at 2:56 PM Zhengping Jiang <jiangzp@google.com> wr=
ote:
> > >
> > > The address resolution should be disabled during the active scan,
> > > so all the advertisements can reach the host. The advertising
> > > has to be paused before disabling the address resolution,
> > > because the advertising will prevent any changes to the resolving
> > > list and the address resolution status. Skipping this will cause
> > > the hci error and the discovery failure.
> >
> > It is probably a good idea to quote the spec saying:
> >
> > 7.8.44 LE Set Address Resolution Enable command
> >
> > This command shall not be used when:
> > =E2=80=A2 Advertising (other than periodic advertising) is enabled,
> >
> > > If the host is using RPA, the controller needs to generate RPA for
> > > the advertising, so the advertising must remain paused during the
> > > active scan.
> > >
> > > If the host is not using RPA, the advertising can be resumed after
> > > disabling the address resolution.
> > >
> > > Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when scan =
without RPA")
> > > Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> > > ---
> > >
> > > Changes in v1:
> > > - Always pause advertising when active scan, but resume the advertisi=
ng if the host is not using RPA
> > >
> > >  net/bluetooth/hci_sync.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > > index 117eedb6f709..edbf9faf7fa1 100644
> > > --- a/net/bluetooth/hci_sync.c
> > > +++ b/net/bluetooth/hci_sync.c
> > > @@ -2402,7 +2402,7 @@ static u8 hci_update_accept_list_sync(struct hc=
i_dev *hdev)
> > >         u8 filter_policy;
> > >         int err;
> > >
> > > -       /* Pause advertising if resolving list can be used as control=
lers are
> > > +       /* Pause advertising if resolving list can be used as control=
lers
> > >          * cannot accept resolving list modifications while advertisi=
ng.
> > >          */
> > >         if (use_ll_privacy(hdev)) {
> > > @@ -5397,7 +5397,7 @@ static int hci_active_scan_sync(struct hci_dev =
*hdev, uint16_t interval)
> > >         /* Pause advertising since active scanning disables address r=
esolution
> > >          * which advertising depend on in order to generate its RPAs.
> > >          */
> > > -       if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVA=
CY)) {
> > > +       if (use_ll_privacy(hdev)) {
> > >                 err =3D hci_pause_advertising_sync(hdev);
> > >                 if (err) {
> > >                         bt_dev_err(hdev, "pause advertising failed: %=
d", err);
> > > @@ -5416,6 +5416,10 @@ static int hci_active_scan_sync(struct hci_dev=
 *hdev, uint16_t interval)
> > >                 goto failed;
> > >         }
> > >
> > > +       // Resume paused advertising if the host is not using RPA
> > > +       if (use_ll_privacy(hdev) && !hci_dev_test_flag(hdev, HCI_PRIV=
ACY))
> > > +               hci_resume_advertising_sync(hdev);
> > > +
> > >         /* All active scans will be done with either a resolvable pri=
vate
> > >          * address (when privacy feature has been enabled) or non-res=
olvable
> > >          * private address.
> > > --
> > > 2.39.1.581.gbfd45094c4-goog
> >
> > I think it is better that we add something like
> > hci_pause_addr_resolution so we can make it check all the conditions,
> > such as pausing advertising and resuming if needed. Btw, we do seem to
> > have proper checks for these conditions on the emulator:
> >
> > https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/emulator/btdev.=
c#n4090
> >
> > But perhaps there is no test which attempts to enable LL Privacy
> > without enabling Local Privacy, so it would be great if you could
> > update mgmt-tester adding a test that emulates such behavior.
> >
> > --
> > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
