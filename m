Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8F697367
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjBOBUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 20:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjBOBUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:20:14 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1284783E5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 17:20:08 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id bd6so14554593oib.6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 17:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuJvfV0OAzz9kxw25r+GX6HaPf7wKgi9opbAeK1ezjs=;
        b=OT47T5A4cgo6pIV/swYDUH1TOozT6chtdyI1BKOt73Ouiij1RvY0C5uevdzFoPmcU0
         IIOTB4JsMPGWgJHR5M5JIJd0/CLgFXDBjTzx0pai4XNNQc3cAG6Wv+vvFHQqATsBwopk
         C/zTsJc4aYaCB+SlwnM/mYV1VPO+wI/4i2SvUJ7FSpPxTDG26Z4es8jIv61G3/P7Bq7s
         DOFBYnWsEwwGHd/BFyQqalWc1Wth1Px5AmSCtjp3dtkVDCqaYdsGoHKeSKiY74ZmuqUh
         fU8RzEO5dIUCOIHM2Tkyr+Q2bRDBt/G2MAuDQQ14uwlZwibZusmIcB1T50keuOL0UDej
         X5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uuJvfV0OAzz9kxw25r+GX6HaPf7wKgi9opbAeK1ezjs=;
        b=qRnlh7VmZI4DkJlril1yoXm8+CRcBb1iqJzaYijEoFfDd+7IZdgUqPVYI2nHzZjWoz
         FpEcC0lSpPzKhbfkeYcLvBkbWTuoavGP9f5zAcAqSfZ+13pFiQBLpsjHHvfIDde0SB2s
         aBKg6/4dvoiKz25zFlwrzJTocaG6etAKbrY1T+FNGKBStWHbG6zcmtqMz5xZ7uDcVwll
         f9tLOuXMLz8vHi/iuXaM/V5UYnuXpPEqXq5OB+y0RRfvsgTtDpdS0FRt9xr2y59P1h62
         alsAl5YwFG+PC7+JNlefl/OGq72Q/J7hVj3GV/VsOSXKcIA3RyYYWCjzJSv8F6JPLVIu
         xu+A==
X-Gm-Message-State: AO0yUKUvPpCLsrxQOCNt3kemu2y9eN7zt4Qhjl/epTdd/xQVZebxDLPq
        7WLjI7KCJxB5PTF8qFYAF3MREfRNmVS30r8cSZK7ww==
X-Google-Smtp-Source: AK7set/+8T/i6UqkGBhXs11DcqcY7XFEtJAL2eYwmATv/4zvzpzj+utuRMxrEMt6zEgk6SHj850fBSxdFijn+WCRy+k=
X-Received: by 2002:aca:3d56:0:b0:378:5f47:6cbf with SMTP id
 k83-20020aca3d56000000b003785f476cbfmr130149oia.44.1676424006866; Tue, 14 Feb
 2023 17:20:06 -0800 (PST)
MIME-Version: 1.0
References: <20230214145609.kernel.v1.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
 <CABBYNZKVVo4T_pbEdozhNvgiykC7NiLQKEnJi3q5gZpHunGrbA@mail.gmail.com>
 <CAB4PzUo+EuapOr+O7eWZH2xiVVAUd98m_DmEK-337=CvfUDeoA@mail.gmail.com> <CABBYNZJJhNTrH85VuqvAQbk6JyNhQ5atXzxb+rV7JcrhkgFWpQ@mail.gmail.com>
In-Reply-To: <CABBYNZJJhNTrH85VuqvAQbk6JyNhQ5atXzxb+rV7JcrhkgFWpQ@mail.gmail.com>
From:   Zhengping Jiang <jiangzp@google.com>
Date:   Tue, 14 Feb 2023 17:19:54 -0800
Message-ID: <CAB4PzUoj2=QNH0SqrSe8LbT74Z7DZr-K6Qw=b71k20a=1aLuSg@mail.gmail.com>
Subject: Re: [kernel PATCH v1] Bluetooth: hci_sync: Resume adv with no RPA
 when active scan
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

> Where is that mentioned?
It is just below the command on "7.8.44 LE Set Address Resolution
Enable command".

On "4.7 RESOLVING LIST", there is another note:
> Note: The Controller may generate Resolvable Private Addresses even when =
address resolution is disabled.

If this is the case, then the comment in the kernel
(hci_active_scan_sync) is not accurate.
> /* Pause advertising since active scanning disables address resolution
> * which advertising depend on in order to generate its RPAs.
> */

> I think it may be related to the fact that it only affects the addr
> resolution of remote devices, that said if you are active scanning
> that probably means the user wants to setup a new device thus why we
> don't enable any filtering like accept list, etc, so it is not really
> useful to keep address resolution active either way.
That makes sense. When the local privacy is enabled, I assume the host
RPA will change
when advertising. I haven't tested that scenario, but if RPA
generation is not related to disable/enable
address resolution, why should the advertising be paused when active scan?

Thanks,
Zhengping

>
> > Thanks,
> > Zhengping
> >
> > On Tue, Feb 14, 2023 at 4:09 PM Luiz Augusto von Dentz
> > <luiz.dentz@gmail.com> wrote:
> > >
> > > Hi Zhengping,
> > >
> > > On Tue, Feb 14, 2023 at 2:56 PM Zhengping Jiang <jiangzp@google.com> =
wrote:
> > > >
> > > > The address resolution should be disabled during the active scan,
> > > > so all the advertisements can reach the host. The advertising
> > > > has to be paused before disabling the address resolution,
> > > > because the advertising will prevent any changes to the resolving
> > > > list and the address resolution status. Skipping this will cause
> > > > the hci error and the discovery failure.
> > >
> > > It is probably a good idea to quote the spec saying:
> > >
> > > 7.8.44 LE Set Address Resolution Enable command
> > >
> > > This command shall not be used when:
> > > =E2=80=A2 Advertising (other than periodic advertising) is enabled,
> > >
> > > > If the host is using RPA, the controller needs to generate RPA for
> > > > the advertising, so the advertising must remain paused during the
> > > > active scan.
> > > >
> > > > If the host is not using RPA, the advertising can be resumed after
> > > > disabling the address resolution.
> > > >
> > > > Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when sca=
n without RPA")
> > > > Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> > > > ---
> > > >
> > > > Changes in v1:
> > > > - Always pause advertising when active scan, but resume the adverti=
sing if the host is not using RPA
> > > >
> > > >  net/bluetooth/hci_sync.c | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > > > index 117eedb6f709..edbf9faf7fa1 100644
> > > > --- a/net/bluetooth/hci_sync.c
> > > > +++ b/net/bluetooth/hci_sync.c
> > > > @@ -2402,7 +2402,7 @@ static u8 hci_update_accept_list_sync(struct =
hci_dev *hdev)
> > > >         u8 filter_policy;
> > > >         int err;
> > > >
> > > > -       /* Pause advertising if resolving list can be used as contr=
ollers are
> > > > +       /* Pause advertising if resolving list can be used as contr=
ollers
> > > >          * cannot accept resolving list modifications while adverti=
sing.
> > > >          */
> > > >         if (use_ll_privacy(hdev)) {
> > > > @@ -5397,7 +5397,7 @@ static int hci_active_scan_sync(struct hci_de=
v *hdev, uint16_t interval)
> > > >         /* Pause advertising since active scanning disables address=
 resolution
> > > >          * which advertising depend on in order to generate its RPA=
s.
> > > >          */
> > > > -       if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRI=
VACY)) {
> > > > +       if (use_ll_privacy(hdev)) {
> > > >                 err =3D hci_pause_advertising_sync(hdev);
> > > >                 if (err) {
> > > >                         bt_dev_err(hdev, "pause advertising failed:=
 %d", err);
> > > > @@ -5416,6 +5416,10 @@ static int hci_active_scan_sync(struct hci_d=
ev *hdev, uint16_t interval)
> > > >                 goto failed;
> > > >         }
> > > >
> > > > +       // Resume paused advertising if the host is not using RPA
> > > > +       if (use_ll_privacy(hdev) && !hci_dev_test_flag(hdev, HCI_PR=
IVACY))
> > > > +               hci_resume_advertising_sync(hdev);
> > > > +
> > > >         /* All active scans will be done with either a resolvable p=
rivate
> > > >          * address (when privacy feature has been enabled) or non-r=
esolvable
> > > >          * private address.
> > > > --
> > > > 2.39.1.581.gbfd45094c4-goog
> > >
> > > I think it is better that we add something like
> > > hci_pause_addr_resolution so we can make it check all the conditions,
> > > such as pausing advertising and resuming if needed. Btw, we do seem t=
o
> > > have proper checks for these conditions on the emulator:
> > >
> > > https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/emulator/btde=
v.c#n4090
> > >
> > > But perhaps there is no test which attempts to enable LL Privacy
> > > without enabling Local Privacy, so it would be great if you could
> > > update mgmt-tester adding a test that emulates such behavior.
> > >
> > > --
> > > Luiz Augusto von Dentz
>
>
>
> --
> Luiz Augusto von Dentz
