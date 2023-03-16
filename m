Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6F76BCB97
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCPJzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCPJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:55:19 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1205B857F
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:54:51 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id w22-20020a9d77d6000000b0069d2032f98aso541152otl.12
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678960489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyPonuJpZPidvHoqyiiruN24ythJvcvhCRR+oFRBUQo=;
        b=WyWOmRYmWcARaQCKIPx+a6QDZPLHID9oiKEAMY+tiT94N8XaE2hCNwpz6cthuoqsIC
         ZAktAfvp1rs4auNQ3CUVx1jJm4azn+SV6VKXrpqxM0kO/Xm/msc058zKrLNtBeuB8Sme
         fkhw0vzc3NE3W/dene1RTv5OEQgLg0EV9JiPBCNC2pNg9Klwf2bDAdeCWeSraWx8dJ23
         cSjTxL7kDc4N80/SrzIuSVD48LcyzpRDkGvOUNCm2/Uul7QVm3K+G4LkVBn7K7uo23ay
         f6Rrf/77JRtZ/vH2zoQRyr4Fm9wYGEqByxWv8Ux+L80WogoaxMQ2cuwGSLsWw0lIZoYF
         BF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678960489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VyPonuJpZPidvHoqyiiruN24ythJvcvhCRR+oFRBUQo=;
        b=dF7T6FAZn1vEXb5RDAyUcxxDUVNJ/9V2ZaPYqjlGdNjVoboZ7UtiMhDVhsLFdJ1CEr
         d0uucBt58xZyDJMlwph2K43/gu0BzNAM3Ba898N9yKgoSwbJdc3BKLoRqEtyTE1UdMfF
         Q/fN56C9+WlcG8OKISjybaC58rtI7aO2yMalYtm+z+vI2nma8pSZNvQeCQhVwelLGSD4
         1SooXOgBnqCbbNM4NCHMWg8iai2H04zqLVZuOCUDUkrKYvCtLUObxlSuKkfOt5fPrsjt
         g+5oyNs6pMQCBJ5UHB3XBXFEdTzk7nLIbVrRxS9jhnKyPB7Xs/YpXt92i7o/4OG4MOb9
         Y6Gw==
X-Gm-Message-State: AO0yUKW5eSrkqQk3SbscTA4sN0GqPrErT6GOnouqTBhpp6rNLEsqM87G
        69pAbkYIYle8pyobmClKXAOmbbvWy4bGat/eDlVWLQ==
X-Google-Smtp-Source: AK7set8ESZuKFscSM5ferhiXnh130+wa+CzR5SXyFtwgeeEzFZ+4AkmMqxD1bMJYgiKOMVTt9xBpvcWhDnsBF8JYhpU=
X-Received: by 2002:a9d:12e9:0:b0:698:f988:7c37 with SMTP id
 g96-20020a9d12e9000000b00698f9887c37mr2280261otg.3.1678960488957; Thu, 16 Mar
 2023 02:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230316151018.v1.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
 <116b1db5-bf75-9fbf-c37b-2fe1028ddaeb@molgen.mpg.de>
In-Reply-To: <116b1db5-bf75-9fbf-c37b-2fe1028ddaeb@molgen.mpg.de>
From:   Yun-hao Chung <howardchung@google.com>
Date:   Thu, 16 Mar 2023 17:54:37 +0800
Message-ID: <CAPHZWUffEUY_OpW+zzpGWe7L5GfOgfgpOqHrJ8Ov2jhBum9ceg@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Archie Pusaka <apusaka@chromium.org>,
        Brian Gix <brian.gix@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
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

Thanks for the reply!
A new patch has been sent.
Please take a look when available.

Thanks,
Howard


On Thu, Mar 16, 2023 at 5:47=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Howard,
>
>
> Thank you for your patch.
>
> Am 16.03.23 um 08:10 schrieb Howard Chung:
> > From: howardchung <howardchung@google.com>
>
> Please configure your full name:
>
>      git config --global user.name "Howard Chung"
>      git commit -s --amend --author=3D"Howard Chung <howardchung@google.c=
om>"
>
> > The MGMT command: MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI uses variable
> > length argumenent. This patch adds right the field.
>
> argument
>
> Were you seeing actual problems? If so, please describe the test setup.
>
> > Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> > Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
> > Signed-off-by: howardchung <howardchung@google.com>
> > ---
> >
> >   net/bluetooth/mgmt.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > index 39589f864ea7..249dc6777fb4 100644
> > --- a/net/bluetooth/mgmt.c
> > +++ b/net/bluetooth/mgmt.c
> > @@ -9357,7 +9357,8 @@ static const struct hci_mgmt_handler mgmt_handler=
s[] =3D {
> >       { add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
> >                                               HCI_MGMT_VAR_LEN },
> >       { add_adv_patterns_monitor_rssi,
> > -                                MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZ=
E },
> > +                                MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZ=
E,
> > +                                             HCI_MGMT_VAR_LEN },
> >       { set_mesh,                MGMT_SET_MESH_RECEIVER_SIZE,
> >                                               HCI_MGMT_VAR_LEN },
> >       { mesh_features,           MGMT_MESH_READ_FEATURES_SIZE },
>
> Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
>
> Kind regards,
>
> Paul
