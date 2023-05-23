Return-Path: <netdev+bounces-4580-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C0770D49A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 953101C20C7B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06441D2AB;
	Tue, 23 May 2023 07:13:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E5E1C747
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:13:13 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E56109;
	Tue, 23 May 2023 00:13:12 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ae85b71141so37690405ad.0;
        Tue, 23 May 2023 00:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684825991; x=1687417991;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=03EqkJXrRuiNBz5G1C16TV++ckfGe0uKcUGxtIlIN1c=;
        b=Zb4idYWQadrH3kXRI8U5kCNJ3Sacwsusl7jhhu33TFZ0+ov7vCD7mCuOd/+R4DU5FU
         aZwMZmkidkOGioKvsb3766ikx5iVJVQWuaaYF9HhbkUN85QNqyf16tlWazTu1gZj79ye
         7JbVySMAN5MdsI5jpu/XmFqt3/HtTXzYCWhvFCsSxqNRQULmm0A2Kc6Co/oesvZxV2zU
         F8fl1W7vJ238pK4bgcNj12NOCe/59tU+d4+WLvXHCMvQ+AEXeDD5uqXlQ4ZXKgkjojgu
         gCbnxUkBm16EBiGi4StNQl5rBolSWp7Otnik3XEmLKbtztIIiCCBczHGdJ/ti7AFYKjV
         2Pgg==
X-Gm-Message-State: AC+VfDz2vDwUF1eBqXiFoZ1s9CqJKE5InEtZS+zQZF8SITZ9k7jFatHy
	OItPP8iM5433v+cqWqijS/o+8K63urHWgxWY7GuM4TrySvo=
X-Google-Smtp-Source: ACHHUZ6ItpQuMW2CtPldc9cn7XBOWsBXE2AZtmcG775brwPZlyqtLqXHSVzRpJt9g7Btt+oQVp/stuHoKGIg57fxV+8=
X-Received: by 2002:a17:903:124b:b0:1ae:a44:841c with SMTP id
 u11-20020a170903124b00b001ae0a44841cmr14940907plh.42.1684825991089; Tue, 23
 May 2023 00:13:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230523065218.51227-1-mailhol.vincent@wanadoo.fr> <20230523065218.51227-4-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20230523065218.51227-4-mailhol.vincent@wanadoo.fr>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Tue, 23 May 2023 16:13:00 +0900
Message-ID: <CAMZ6Rq+EgMW4zLPVWP8e0DT2R0WO5swxxuc3qUAewAe6fgubOw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] can: length: refactor frame lengths definition to
 add size in bits
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org, 
	Thomas.Kopp@microchip.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org, marex@denx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sorry for the late reply, I wanted to have this completed earlier but
other imperatives and the time needed to debug decided differently.

On Tue. 23 May 2023 at 15:52, Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
> Introduce a method to calculate the exact size in bits of a CAN(-FD)
> frame with or without dynamic bitsuffing.
>
> These are all the possible combinations taken into account:
>
>   - Classical CAN or CAN-FD
>   - Standard or Extended frame format
>   - CAN-FD CRC17 or CRC21
>   - Include or not intermission
>
> Instead of doing several macro definitions, declare the
> can_frame_bits() static inline function. To this extend, do a full
                                                   ^^^^^^
Typo: extent
(I will not send a v3 just for that).

> refactoring of the length definitions.
>
> If given integer constant expressions as argument, can_frame_bits()
> folds into a compile time constant expression, giving no penalty over
> the use of macros.
>
> Also add the can_frame_bytes(). This function replaces the existing
> macro:
>
>   - CAN_FRAME_OVERHEAD_SFF: can_frame_bytes(false, false, 0)
>   - CAN_FRAME_OVERHEAD_EFF: can_frame_bytes(false, true, 0)
>   - CANFD_FRAME_OVERHEAD_SFF: can_frame_bytes(true, false, 0)
>   - CANFD_FRAME_OVERHEAD_EFF: can_frame_bytes(true, true, 0)
>
> The different frame lengths (including intermission) are as follow:
>
>    Frame type                           bits    bytes
>   ----------------------------------------------------------
>    Classic CAN SFF no-bitstuffing       111     14
>    Classic CAN EFF no-bitstuffing       131     17
>    Classic CAN SFF bitstuffing          135     17
>    Classic CAN EFF bitstuffing          160     20
>    CAN-FD SFF no-bitstuffing            579     73
>    CAN-FD EFF no-bitstuffing            598     75
>    CAN-FD SFF bitstuffing               712     89
>    CAN-FD EFF bitstuffing               736     92
>
> The macro CAN_FRAME_LEN_MAX and CANFD_FRAME_LEN_MAX are kept to be
> used in const struct declarations (folding of can_frame_bytes() occurs
> too late in the compilation to be used in struct declarations).

To be fair, I am not fully happy with that part. The fact that
can_frame_bits() and can_frame_bytes() can not be used in structure
declaration even if these are compile time constants is unfortunate.
But after reflection, I still see those inline functions as a better
compromise than a collection of macro definitions. Let me know your
thoughts.

(...)

Yours sincerely,
Vincent Mailhol

