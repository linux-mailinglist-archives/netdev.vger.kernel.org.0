Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EE86BD732
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCPRfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCPRfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:35:10 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBBE5ADEE;
        Thu, 16 Mar 2023 10:35:06 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id o8so3377100lfo.0;
        Thu, 16 Mar 2023 10:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678988104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnhFCQhBNxfLhUrYhX259W+4mdZ7p8Vvsqy+MR+7n/U=;
        b=ojufyz2wPgU7klZNadkuIRAtRj+sPBF8DiwQapaEF2zGkxSa8XQOWQCNavWRqXwviX
         ufB4uRP7uqTVLYCAMxM9DjPCqi5fdzP6oNVEoLKxgXtKr8hoU68vBDheiTpwAcWWhntR
         X4EexODXJsYWsjrWPSSWoJTCVsa6EJkaLWgnmREY5fJ0TO49z8Rp1Y4DNJn9ThDXz4jd
         zrw953BAai9eKmGTsIG11hq0dvwzQlFBaFQxLitPt88o2wkc9HGr1hsBHd7Df7KdgHZ9
         JmQX8mUsO7pymWfhfG9FFTG1RAMPV0gAgsPg06lPYmS8X/xNm3pAc7x//vQJgGDarlqa
         JhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678988104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnhFCQhBNxfLhUrYhX259W+4mdZ7p8Vvsqy+MR+7n/U=;
        b=DPFesosEkISqFN7u46EbWIzou+60cP7UOIOgKNxde9U8d8jjj7eeCjAp4tvmMB0sF4
         4mBwbYt9DLFKdK+8SCddPNklBffVdqvrxLZXXrqb+6gVFOdLN+GhI+sVGZxZBbujbc9n
         o6p64pWWi4Bk8Qv7Qk6ct0/Or8SMNtYJ1ZyrlS6FSvPHv3eJckuOHHHJbpBJorldwnPe
         ca7ToelxJSQbdlWRcHI5Mt5mVF2gDdZEFfZ7joJzvXd6FNMotpZ1zS0EZ8MIdcbT+XqR
         mLQfKCS2R+/wt1Sjm7pKLHY99nE1MmiUk73KV0LEJbWJKdzQ6ruLqiTpO/D69HqXuBYc
         W9oQ==
X-Gm-Message-State: AO0yUKUYgAlKowRWuPGe37j+p0j9gyq1gkyXX+Ub3tV/VwgGmDNrEJw9
        fxiOHzfXucr8zQj/d0k1vR7GAQiGu6uZgqy9394=
X-Google-Smtp-Source: AK7set/p69kqiC2JsEgTO7TwDmd3Ef1XvI/Jqx9vnW/ks51avK/hr2HElJf/qngwANy64A4E0MhMK3gzE13ySovjC1Q=
X-Received: by 2002:ac2:5508:0:b0:4d5:ca32:6aea with SMTP id
 j8-20020ac25508000000b004d5ca326aeamr3493440lfk.10.1678988104085; Thu, 16 Mar
 2023 10:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230316181112.v3.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
In-Reply-To: <20230316181112.v3.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 16 Mar 2023 10:34:52 -0700
Message-ID: <CABBYNZKwHtoSfTOb+1A-NGqePzkP-LD1A3Fyb32xTrF4Qzj-Jg@mail.gmail.com>
Subject: Re: [PATCH v3] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
To:     Howard Chung <howardchung@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Archie Pusaka <apusaka@chromium.org>,
        Brian Gix <brian.gix@intel.com>,
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

Hi Howard,

On Thu, Mar 16, 2023 at 3:11=E2=80=AFAM Howard Chung <howardchung@google.co=
m> wrote:
>
> The MGMT command: MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI uses variable
> length argument. This causes host not able to register advmon with rssi.

There is a way to prevent these regression, which would be to actually
implement tests for these commands in the likes of mgmt-tester so we
can catch regressions via CI, so I hope to see some work in this
direction.

> This patch has been locally tested by adding monitor with rssi via
> btmgmt on a kernel 6.1 machine.
>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
>
> Changes in v3:
> - Moved commit-notes to commit message
> - Fixed a typo
>
> Changes in v2:
> - Fixed git user name
> - Included commit notes for the test step.
>
>  net/bluetooth/mgmt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 39589f864ea7..249dc6777fb4 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -9357,7 +9357,8 @@ static const struct hci_mgmt_handler mgmt_handlers[=
] =3D {
>         { add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
>                                                 HCI_MGMT_VAR_LEN },
>         { add_adv_patterns_monitor_rssi,
> -                                  MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZ=
E },
> +                                  MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZ=
E,
> +                                               HCI_MGMT_VAR_LEN },
>         { set_mesh,                MGMT_SET_MESH_RECEIVER_SIZE,
>                                                 HCI_MGMT_VAR_LEN },
>         { mesh_features,           MGMT_MESH_READ_FEATURES_SIZE },
> --
> 2.40.0.rc2.332.ga46443480c-goog
>


--=20
Luiz Augusto von Dentz
