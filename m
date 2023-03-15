Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4996BAB6E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjCOJCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjCOJCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:02:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753B273AF6;
        Wed, 15 Mar 2023 02:01:52 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id fd25so11272873pfb.1;
        Wed, 15 Mar 2023 02:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678870912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edwNrUkG8Z1dURZMltw+SGhc2MepuRLhhGK+wNS8X9M=;
        b=TwGV/nwTo3AMauBgkhh2TtKZO6uFMJopYrPuVM33BSLkCBFxxhG2OE3hvjKgRTulMf
         0ThDJ4rTYrxPEYQLgYxf6K8JcF0GMBd8kP+Tmb8CugJYEvFm9+Wjz5hPVHMoklQ746J5
         JCL/GNOd0saqdG2TYkdyYFYgdc1bScXe1oI1EPuNuWHmf5qEA+778LJJt+pEVf1wzKLd
         fBFxc60OeNYCLK4Yi0G5ZkXa5feE0vJn2d7stuSgITw1UJy9QDg94D35RHvSaYu9x272
         9vFY9sGKERRLo691UsAI/FVctyo/BzIa2Am931iLRjXkyqBSuRhhIFfwbPd5Tk06lDiT
         z5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678870912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edwNrUkG8Z1dURZMltw+SGhc2MepuRLhhGK+wNS8X9M=;
        b=wilCDSdQHnhtRpisKIf1eKoFCtfEP8KEyLyIBziEZfam+wgm38yTuwsfCtl0IzCXWs
         XKPVRHCGJV8Swn8Kk1DJ4LD30sbtclQ+ceFzOSNYvXWtMGAIHRfHcxV9qDoS/fMMYObM
         sT81rDQv4X5oNcJ6lYkC7d01KhSXXHFDTOmUfThAsvrUXgGP3kNeZ2dDJxtNAFnimOi0
         8VgaJ/dWJbdaTHKmYbGQyokXhG4ftjRjIYwqa8vRTczUP5uQS3aVcFRKqRxNr+e9Kp92
         PAZKzon9JH9qHCYjbAZNCSz0R6QP6+A6ODcAxWMSFFdLr2ID1k448O6TTaxYxMVLVdAT
         Stng==
X-Gm-Message-State: AO0yUKVZhp/YMkiJXRNdfysl6TaFvMGK8mW2SnEGU783qNxNYpotOQow
        E+1jmLIa7Ibp2gTPFdm5hkrXQ0RnNEGRMb+p/3c=
X-Google-Smtp-Source: AK7set8vtgeDhDK48IZ7Wz2S0KcvCOk/TZaGPh5G5qO7pV2iRCi75BDYPBeUAi7AQLFzoIN6WLjQQazbM9GnhAVdVlY=
X-Received: by 2002:a63:9f09:0:b0:50b:18ac:fbea with SMTP id
 g9-20020a639f09000000b0050b18acfbeamr3345941pge.9.1678870911853; Wed, 15 Mar
 2023 02:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230217100223.702330-1-zyytlz.wz@163.com> <CAJedcCxUNBWOpkcaN2aLbwNs_xvqi=LC8mhFWh-jWeh6q-cBCQ@mail.gmail.com>
 <ZBCNY8NoNkrA2nyN@corigine.com> <ZBCRRL8+EtTBH2tl@corigine.com>
In-Reply-To: <ZBCRRL8+EtTBH2tl@corigine.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Wed, 15 Mar 2023 17:01:40 +0800
Message-ID: <CAJedcCxuaoB8gA5eEnmEdFcxnc4ObrMhvPzu0Ki0SumqrDLz7w@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: hci_core: Fix poential Use-after-Free bug
 in hci_remove_adv_monitor
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, marcel@holtmann.org,
        alex000young@gmail.com, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pmenzel@molgen.mpg.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon Horman <simon.horman@corigine.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8814=
=E6=97=A5=E5=91=A8=E4=BA=8C 23:22=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Mar 14, 2023 at 04:06:11PM +0100, Simon Horman wrote:
> > On Mon, Mar 13, 2023 at 05:55:35PM +0800, Zheng Hacker wrote:
> > > friendly ping
> > >
> > > Zheng Wang <zyytlz.wz@163.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=8817=E6=
=97=A5=E5=91=A8=E4=BA=94 18:05=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT=
 case,
> > > > the function will free the monitor and print its handle after that.
> > > > Fix it by removing the logging into msft_le_cancel_monitor_advertis=
ement_cb
> > > > before calling hci_free_adv_monitor.
> > > >
> > > > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > > > ---
> > > > v2:
> > > > - move the logging inside msft_remove_monitor suggested by Luiz
> > > > ---
> > > >  net/bluetooth/hci_core.c | 2 --
> > > >  net/bluetooth/msft.c     | 2 ++
> > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > > index b65c3aabcd53..69b82c2907ff 100644
> > > > --- a/net/bluetooth/hci_core.c
> > > > +++ b/net/bluetooth/hci_core.c
> > > > @@ -1981,8 +1981,6 @@ static int hci_remove_adv_monitor(struct hci_=
dev *hdev,
> > > >
> > > >         case HCI_ADV_MONITOR_EXT_MSFT:
> > > >                 status =3D msft_remove_monitor(hdev, monitor);
> > > > -               bt_dev_dbg(hdev, "%s remove monitor %d msft status =
%d",
> > > > -                          hdev->name, monitor->handle, status);
> > > >                 break;
> >
> > I'm probably missing something obvious.
> > But from my perspective a simpler fix would be to
> > move the msft_remove_monitor() call to below the bt_dev_dbg() call.
>
> The obvious thing I was missing is that was what was done in v1
> but Luiz suggested moving the logging to
> msft_le_cancel_monitor_advertisement_cb().
> Sorry for the noise.

Hi Simon,

Thanks for your reply and detailed review :)

Best regards,
Zheng

>
> Link: https://lore.kernel.org/all/CABBYNZL_gZ+kr_OEqjYgMmt+=3D91=3DjC88g3=
10F-ScMC=3DkLh0xdw@mail.gmail.com/
>
> >
> > > >         }
> > > >
> > > > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> > > > index bee6a4c656be..4b35f0ed1360 100644
> > > > --- a/net/bluetooth/msft.c
> > > > +++ b/net/bluetooth/msft.c
> > > > @@ -286,6 +286,8 @@ static int msft_le_cancel_monitor_advertisement=
_cb(struct hci_dev *hdev,
> > > >                  * suspend. It will be re-monitored on resume.
> > > >                  */
> > > >                 if (!msft->suspending) {
> > > > +                       bt_dev_dbg(hdev, "%s remove monitor %d stat=
us %d", hdev->name,
> > > > +                                  monitor->handle, status);
> > > >                         hci_free_adv_monitor(hdev, monitor);
> > > >
> > > >                         /* Clear any monitored devices by this Adv =
Monitor */
> > > > --
> > > > 2.25.1
> > > >
> > >
