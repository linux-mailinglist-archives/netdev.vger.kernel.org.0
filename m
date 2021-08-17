Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70333EE1FA
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 03:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhHQBN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 21:13:29 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:36433 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhHQBN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 21:13:29 -0400
Received: by mail-lj1-f181.google.com with SMTP id y7so30218495ljp.3;
        Mon, 16 Aug 2021 18:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LcDb6cdiTT2+/+iDeVpLBBojjo/JZmuIoI4va9to8jg=;
        b=s7Q58AH41jtWNx+HjVRBO/yPdKIkPd0j99QDF+d1kLGH8a9WkIj8oN3uMfE6DysDdx
         i52epGrdR3laBwYJfWM12utUDbtC4bNo19N2OuEQOF+67kItMNKGgxUVtzU8oYS9tgov
         5zboQw/KvHzNBJ0Rl3S3jdB5UGyb46OVLYWl/oOXxD1k79wNcz2mRG9XO99aRKxuckOy
         zn/lbeUEvV2RhYqdl8YU3TRJ4wx61mlyORs60CcQxR0+IUcdf1lwDyqJO2h+jxGkeq6j
         HahxL+NfF4WgBjt5iyfBZ57HbggwJHI4RiG4KgDFQ+0aycthTKYoXmoZSwYlSdZp4Ekc
         SBjQ==
X-Gm-Message-State: AOAM532YFqDheKFndnegdYjOHI+XfeBzJluAcZgtyfwirV+TGCKalBfl
        FXh2Jya1WWU6ILGUtEdYpYvzH3RSZrelqyeDX7E=
X-Google-Smtp-Source: ABdhPJyB1qsxbqnkqQ5jHf1wNevftc7GdUwJ+dkza6fML2jtBsA6lk+NhNU6sw9pR3mYEq+Kk7Onv5EvynhAUIkvzns=
X-Received: by 2002:a2e:9182:: with SMTP id f2mr820778ljg.57.1629162775444;
 Mon, 16 Aug 2021 18:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de> <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <20210816134342.w3bc5zjczwowcjr4@pengutronix.de> <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
 <CAMZ6Rq+ZtN+=ppPEYYm0ykJWP8_LtPNBtOM6gwM1VrpM3idsyw@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+ZtN+=ppPEYYm0ykJWP8_LtPNBtOM6gwM1VrpM3idsyw@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 10:12:44 +0900
Message-ID: <CAMZ6Rq+kQ5+00p_-Pdk7v-h6_8oYA6MPP1SU-AdPH=ux++z-dQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

This patch fixes the bug you just encountered: having both TDC_AUTO
and TDC_MANUAL set at the same time. I also cleaned all garbage
data in struct can_tdc because that was trivial.

This patch is meant to be squashed into:
commit ca7200319a90 ("can: netlink: add interface for CAN-FD
Transmitter Delay Compensation (TDC)")

For now, I am just sharing it here so that you can continue your
testing. I will resend the full series after we finish current
ongoing discussion.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index f05745c96b9c..d8cefe7d354c 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -204,6 +204,7 @@ static int can_changelink(struct net_device *dev,
struct nlattr *tb[],
         }
     }

+    priv->ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
     if (data[IFLA_CAN_CTRLMODE]) {
         struct can_ctrlmode *cm;
         u32 ctrlstatic;
@@ -239,8 +240,6 @@ static int can_changelink(struct net_device *dev,
struct nlattr *tb[],
             dev->mtu = CAN_MTU;
             memset(&priv->data_bittiming, 0,
                    sizeof(priv->data_bittiming));
-            memset(&priv->tdc, 0, sizeof(priv->tdc));
-            priv->ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
         }

         tdc_mask = cm->mask & CAN_CTRLMODE_TDC_MASK;
@@ -326,6 +325,7 @@ static int can_changelink(struct net_device *dev,
struct nlattr *tb[],
         priv->termination = termval;
     }

+    memset(&priv->tdc, 0, sizeof(priv->tdc));
     if (data[IFLA_CAN_TDC]) {
         /* Use the provided TDC parameters */
         err = can_tdc_changelink(dev, data[IFLA_CAN_TDC], extack);
-- 
2.31.1
