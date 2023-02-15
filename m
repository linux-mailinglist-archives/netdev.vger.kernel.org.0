Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9A16975A6
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 06:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjBOFCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 00:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBOFCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 00:02:22 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39078311C0;
        Tue, 14 Feb 2023 21:02:21 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id cf42so26243959lfb.1;
        Tue, 14 Feb 2023 21:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GeaJqufhmy9QgQgSZ33BN67SU9mWacH0/5IjeAGMXn4=;
        b=mkBoQYSksZHKDjEDNvYMr8NREnKdWL7Sibk9YYA6BndLWeJTaS6JTFRYOe7FpUz9+M
         lAHfrnLYU7EJh8S74Q6Idf9g8wF57+SFuIf9ckScaquDCnkFBASl7g5g/uElGCWpEkn4
         oe6OpDsd1MIWTuY8TGxmiSEVDqcL0C2eSHSncDm/4yxZjIcAi2QnT8n2qPcHd90WSAln
         V+xDmBzJDyJI+cAhr85Af+MBFbsLbvowcWGGybqi6ZjF/EAM55VwVCeBMxibo7n+JnXb
         ZkVqJancHKtL1p80aHB4YH+2zCth2DtXweuisigxTfEcORWU8Ji1/cbJRB3onsJSkE7F
         CvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GeaJqufhmy9QgQgSZ33BN67SU9mWacH0/5IjeAGMXn4=;
        b=5+EGVMU+i7bpOsANUR+Wyoz3yrSgT471ypE3b+yDa2Drn7Reb7ahmKAD5jNPG5xEoa
         wYXYgdfHtv25eypBLv1AIoE06zvJg9zpk5G8Ql5bGf1rUZaT+/1eTBbCu0EOaan4SwI3
         2xtYC0/kwDBtZ2qb7kqtHmT884qnixIgvkJXRjsotPRQ10nvS9IjE/7HxYje4q7NNkJZ
         awIlOraCT4T8u5Igg3+jc3OCxZAPzLmwdRddvS4JbjLLXNOFJpY0CsPHa4XjZSqYc81a
         UB2KreTzpCD/jMArxVadDOjK21PH+3hBGc5zPHdbUxuFxWaMRLSbw7rf9NoDnoI7mZqz
         2fEQ==
X-Gm-Message-State: AO0yUKWnF72RJkmJFGFr2y6a6DnZVzipX6SENlEq8qjDOpkLoa+77NI7
        xl58MlGuTPho2pYvJ1CO8Xx9ur8kSOCsj1v1zRM=
X-Google-Smtp-Source: AK7set8EApSOAPW/4VymXLYMIIA+arjPDSytC7zllvXbUKQ4BfJi2HZnktlL65J+PKRtah86SrfGu8Yvzf4ZiRostwM=
X-Received: by 2002:ac2:53bc:0:b0:4d5:ca43:7045 with SMTP id
 j28-20020ac253bc000000b004d5ca437045mr149021lfh.8.1676437339265; Tue, 14 Feb
 2023 21:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20230214145609.kernel.v1.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
 <CABBYNZKVVo4T_pbEdozhNvgiykC7NiLQKEnJi3q5gZpHunGrbA@mail.gmail.com>
 <CAB4PzUo+EuapOr+O7eWZH2xiVVAUd98m_DmEK-337=CvfUDeoA@mail.gmail.com>
 <CABBYNZJJhNTrH85VuqvAQbk6JyNhQ5atXzxb+rV7JcrhkgFWpQ@mail.gmail.com> <CAB4PzUoj2=QNH0SqrSe8LbT74Z7DZr-K6Qw=b71k20a=1aLuSg@mail.gmail.com>
In-Reply-To: <CAB4PzUoj2=QNH0SqrSe8LbT74Z7DZr-K6Qw=b71k20a=1aLuSg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 14 Feb 2023 21:02:08 -0800
Message-ID: <CABBYNZLL7F7o66UrpKJeF+RnviFV_DJd7AwYV0kY8CuhapZpVg@mail.gmail.com>
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

On Tue, Feb 14, 2023 at 5:20 PM Zhengping Jiang <jiangzp@google.com> wrote:
>
> Hi Luiz,
>
> > Where is that mentioned?
> It is just below the command on "7.8.44 LE Set Address Resolution
> Enable command".
>
> On "4.7 RESOLVING LIST", there is another note:
> > Note: The Controller may generate Resolvable Private Addresses even whe=
n address resolution is disabled.

Note that the term used here is 'may' not 'shall' so I don't think we
can take for granted that the controller will keep generating a new
RPA while address resolution is disabled, in fact I think this is sort
of a bad idea since as part of the resolving list is the actual IRK
and the procedures to update those entries requires address resolution
to be stopped, in fact I think the spec is sort of responsible for
creating this confusion when it mixed up remote IRK with local IRK in
the same list.

> If this is the case, then the comment in the kernel
> (hci_active_scan_sync) is not accurate.
> > /* Pause advertising since active scanning disables address resolution
> > * which advertising depend on in order to generate its RPAs.
> > */
>
> > I think it may be related to the fact that it only affects the addr
> > resolution of remote devices, that said if you are active scanning
> > that probably means the user wants to setup a new device thus why we
> > don't enable any filtering like accept list, etc, so it is not really
> > useful to keep address resolution active either way.
> That makes sense. When the local privacy is enabled, I assume the host
> RPA will change
> when advertising. I haven't tested that scenario, but if RPA
> generation is not related to disable/enable
> address resolution, why should the advertising be paused when active scan=
?

Initially it was because we wanted to disable address resolution which
requires both scan and advertising to be disabled to begin with, then
there is the fact that there is no fine control over how the
controller would priority the scanning and advertising states, and
there is also the situation where a incoming connection may come in
when advertising is enabled then we have a connection competing with
scanning which creates even more problems, not to mention not all
controllers do support scanning and advertising simultaneously.

> Thanks,
> Zhengping
>
> >
> > > Thanks,
> > > Zhengping
> > >
> > > On Tue, Feb 14, 2023 at 4:09 PM Luiz Augusto von Dentz
> > > <luiz.dentz@gmail.com> wrote:
> > > >
> > > > Hi Zhengping,
> > > >
> > > > On Tue, Feb 14, 2023 at 2:56 PM Zhengping Jiang <jiangzp@google.com=
> wrote:
> > > > >
> > > > > The address resolution should be disabled during the active scan,
> > > > > so all the advertisements can reach the host. The advertising
> > > > > has to be paused before disabling the address resolution,
> > > > > because the advertising will prevent any changes to the resolving
> > > > > list and the address resolution status. Skipping this will cause
> > > > > the hci error and the discovery failure.
> > > >
> > > > It is probably a good idea to quote the spec saying:
> > > >
> > > > 7.8.44 LE Set Address Resolution Enable command
> > > >
> > > > This command shall not be used when:
> > > > =E2=80=A2 Advertising (other than periodic advertising) is enabled,
> > > >
> > > > > If the host is using RPA, the controller needs to generate RPA fo=
r
> > > > > the advertising, so the advertising must remain paused during the
> > > > > active scan.
> > > > >
> > > > > If the host is not using RPA, the advertising can be resumed afte=
r
> > > > > disabling the address resolution.
> > > > >
> > > > > Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when s=
can without RPA")
> > > > > Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> > > > > ---
> > > > >
> > > > > Changes in v1:
> > > > > - Always pause advertising when active scan, but resume the adver=
tising if the host is not using RPA
> > > > >
> > > > >  net/bluetooth/hci_sync.c | 8 ++++++--
> > > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > > > > index 117eedb6f709..edbf9faf7fa1 100644
> > > > > --- a/net/bluetooth/hci_sync.c
> > > > > +++ b/net/bluetooth/hci_sync.c
> > > > > @@ -2402,7 +2402,7 @@ static u8 hci_update_accept_list_sync(struc=
t hci_dev *hdev)
> > > > >         u8 filter_policy;
> > > > >         int err;
> > > > >
> > > > > -       /* Pause advertising if resolving list can be used as con=
trollers are
> > > > > +       /* Pause advertising if resolving list can be used as con=
trollers
> > > > >          * cannot accept resolving list modifications while adver=
tising.
> > > > >          */
> > > > >         if (use_ll_privacy(hdev)) {
> > > > > @@ -5397,7 +5397,7 @@ static int hci_active_scan_sync(struct hci_=
dev *hdev, uint16_t interval)
> > > > >         /* Pause advertising since active scanning disables addre=
ss resolution
> > > > >          * which advertising depend on in order to generate its R=
PAs.
> > > > >          */
> > > > > -       if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_P=
RIVACY)) {
> > > > > +       if (use_ll_privacy(hdev)) {
> > > > >                 err =3D hci_pause_advertising_sync(hdev);
> > > > >                 if (err) {
> > > > >                         bt_dev_err(hdev, "pause advertising faile=
d: %d", err);
> > > > > @@ -5416,6 +5416,10 @@ static int hci_active_scan_sync(struct hci=
_dev *hdev, uint16_t interval)
> > > > >                 goto failed;
> > > > >         }
> > > > >
> > > > > +       // Resume paused advertising if the host is not using RPA
> > > > > +       if (use_ll_privacy(hdev) && !hci_dev_test_flag(hdev, HCI_=
PRIVACY))
> > > > > +               hci_resume_advertising_sync(hdev);
> > > > > +
> > > > >         /* All active scans will be done with either a resolvable=
 private
> > > > >          * address (when privacy feature has been enabled) or non=
-resolvable
> > > > >          * private address.
> > > > > --
> > > > > 2.39.1.581.gbfd45094c4-goog
> > > >
> > > > I think it is better that we add something like
> > > > hci_pause_addr_resolution so we can make it check all the condition=
s,
> > > > such as pausing advertising and resuming if needed. Btw, we do seem=
 to
> > > > have proper checks for these conditions on the emulator:
> > > >
> > > > https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/emulator/bt=
dev.c#n4090
> > > >
> > > > But perhaps there is no test which attempts to enable LL Privacy
> > > > without enabling Local Privacy, so it would be great if you could
> > > > update mgmt-tester adding a test that emulates such behavior.
> > > >
> > > > --
> > > > Luiz Augusto von Dentz
> >
> >
> >
> > --
> > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
