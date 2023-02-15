Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9EC6972AB
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 01:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjBOA2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 19:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjBOA2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 19:28:24 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F544234F6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 16:28:22 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id t5so14487367oiw.1
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 16:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sp80czwOhma7dov00LFmjFY+/xV7ov2dV4s/yjc86+M=;
        b=UQrOimRQ30iWMdLTqmrdd83TI0YqAiGR+5ghO80v/HfGuyq+LLp1EC9K8C6a8MqV8u
         LK+E7ZcIyw/wJjn8mxxD4t/qtX96LpAs18md0goD/adKLlUIwahMn9JC73J/bq1qbv26
         kbiIEZI3A2xx/aGoTZAN3l6S2X7vj/e3x4AIFGHAcVBOvRsTt+HV4Muaqsuq3Aq0NxoJ
         Irx5hOX0ION3aSBTve65s04H9bcKW9aLFLexs4/oyV0wUjy/sXf7Y9I5cJk0o3UgO0oT
         CQ3TVOnqdXtdslGz/3QIxGjdGSjc3lElHyjgKm7Hu83JCDD7yy8GQnEMxfiQhmxJKz/e
         7TpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sp80czwOhma7dov00LFmjFY+/xV7ov2dV4s/yjc86+M=;
        b=mpFktz6quJN6xefeeGEuOi/Nl2AfV61TDa/mkY069FYcJX+xxoQypIOjZTnhSy8Gez
         PlXDtLi3NWFrKgIsV5AS0Z0d6pTws7aczSW9xzx5Np/agOq10i5dP8stQ6ko4rCoRJXw
         cBnTuRmSH95VgV8HlxXDLe8IAUzrH4L82MVaKkxfA66ygtisIOO99fINaOFjhA4/1iG3
         MT0/fcsjwnr8lCQqftsS9jrf5hgI8DyFd0Y7fAWZJ33oTjiRXmzr1xlJJy/tWueJwokI
         A8uFNSOvW2FFRyL4+lWatIjSNxQyXeuUjwy62KFJKtFVVivwNrE+kpUhwK2LBZ/0W20f
         mXGQ==
X-Gm-Message-State: AO0yUKXP4/5ouMwBmDR+TSS7vYKLaW8kR3CiE6qabWXxNnlHJsYQc+Y/
        Nu3BWYsvYzLJ0HqIZVf5anKmgh/JQWdvkxE4Ztd2BA==
X-Google-Smtp-Source: AK7set8X/RBY86D7efIziwS+i2S491zUsQBQ1hSzpuZBLKL2OhWjJkpHLCG0igAEouDOJ7ypWcguu0TCCtKDOvbn6Us=
X-Received: by 2002:aca:3d56:0:b0:378:5f47:6cbf with SMTP id
 k83-20020aca3d56000000b003785f476cbfmr120530oia.44.1676420901527; Tue, 14 Feb
 2023 16:28:21 -0800 (PST)
MIME-Version: 1.0
References: <20230214145609.kernel.v1.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
 <CABBYNZKVVo4T_pbEdozhNvgiykC7NiLQKEnJi3q5gZpHunGrbA@mail.gmail.com>
In-Reply-To: <CABBYNZKVVo4T_pbEdozhNvgiykC7NiLQKEnJi3q5gZpHunGrbA@mail.gmail.com>
From:   Zhengping Jiang <jiangzp@google.com>
Date:   Tue, 14 Feb 2023 16:28:09 -0800
Message-ID: <CAB4PzUo+EuapOr+O7eWZH2xiVVAUd98m_DmEK-337=CvfUDeoA@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

Thanks for the comment. I will submit a new patch to address that.

I notice in the spec, it is mentioned
> Note: This command does not affect the generation of Resolvable Private A=
ddresses.
How should I understand this note? Does it mean even if the address
resolution is disabled, the controller can still generate RPA for
advertising?  Does it mean the advertising can always be resumed
during active scan?

Thanks,
Zhengping

On Tue, Feb 14, 2023 at 4:09 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Zhengping,
>
> On Tue, Feb 14, 2023 at 2:56 PM Zhengping Jiang <jiangzp@google.com> wrot=
e:
> >
> > The address resolution should be disabled during the active scan,
> > so all the advertisements can reach the host. The advertising
> > has to be paused before disabling the address resolution,
> > because the advertising will prevent any changes to the resolving
> > list and the address resolution status. Skipping this will cause
> > the hci error and the discovery failure.
>
> It is probably a good idea to quote the spec saying:
>
> 7.8.44 LE Set Address Resolution Enable command
>
> This command shall not be used when:
> =E2=80=A2 Advertising (other than periodic advertising) is enabled,
>
> > If the host is using RPA, the controller needs to generate RPA for
> > the advertising, so the advertising must remain paused during the
> > active scan.
> >
> > If the host is not using RPA, the advertising can be resumed after
> > disabling the address resolution.
> >
> > Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when scan wi=
thout RPA")
> > Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> > ---
> >
> > Changes in v1:
> > - Always pause advertising when active scan, but resume the advertising=
 if the host is not using RPA
> >
> >  net/bluetooth/hci_sync.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > index 117eedb6f709..edbf9faf7fa1 100644
> > --- a/net/bluetooth/hci_sync.c
> > +++ b/net/bluetooth/hci_sync.c
> > @@ -2402,7 +2402,7 @@ static u8 hci_update_accept_list_sync(struct hci_=
dev *hdev)
> >         u8 filter_policy;
> >         int err;
> >
> > -       /* Pause advertising if resolving list can be used as controlle=
rs are
> > +       /* Pause advertising if resolving list can be used as controlle=
rs
> >          * cannot accept resolving list modifications while advertising=
.
> >          */
> >         if (use_ll_privacy(hdev)) {
> > @@ -5397,7 +5397,7 @@ static int hci_active_scan_sync(struct hci_dev *h=
dev, uint16_t interval)
> >         /* Pause advertising since active scanning disables address res=
olution
> >          * which advertising depend on in order to generate its RPAs.
> >          */
> > -       if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVACY=
)) {
> > +       if (use_ll_privacy(hdev)) {
> >                 err =3D hci_pause_advertising_sync(hdev);
> >                 if (err) {
> >                         bt_dev_err(hdev, "pause advertising failed: %d"=
, err);
> > @@ -5416,6 +5416,10 @@ static int hci_active_scan_sync(struct hci_dev *=
hdev, uint16_t interval)
> >                 goto failed;
> >         }
> >
> > +       // Resume paused advertising if the host is not using RPA
> > +       if (use_ll_privacy(hdev) && !hci_dev_test_flag(hdev, HCI_PRIVAC=
Y))
> > +               hci_resume_advertising_sync(hdev);
> > +
> >         /* All active scans will be done with either a resolvable priva=
te
> >          * address (when privacy feature has been enabled) or non-resol=
vable
> >          * private address.
> > --
> > 2.39.1.581.gbfd45094c4-goog
>
> I think it is better that we add something like
> hci_pause_addr_resolution so we can make it check all the conditions,
> such as pausing advertising and resuming if needed. Btw, we do seem to
> have proper checks for these conditions on the emulator:
>
> https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/emulator/btdev.c#=
n4090
>
> But perhaps there is no test which attempts to enable LL Privacy
> without enabling Local Privacy, so it would be great if you could
> update mgmt-tester adding a test that emulates such behavior.
>
> --
> Luiz Augusto von Dentz
