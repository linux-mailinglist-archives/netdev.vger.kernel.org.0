Return-Path: <netdev+bounces-6499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E57716AF6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 945FA281268
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07EC21069;
	Tue, 30 May 2023 17:30:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56F3200BF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:30:15 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BD89C;
	Tue, 30 May 2023 10:29:55 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-52cb8e5e9f5so34254a12.0;
        Tue, 30 May 2023 10:29:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685467795; x=1688059795;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVRaZG2eM/gohyhY2fboQdC7q4wdMVSPr7qxCPkqPm8=;
        b=Ibqwv9ArAqbL9+kZoGxmE8qDprx+l8vtVBDwhCAQ7kvJsL6VZKNzhKDzUIgytYbHhg
         C8L61hLHsmzsZ0BgrflxV8MXYu9g9ZijXNP5zbS1+TC+yYar0C6vlGNu3ZUhdPlBFIr9
         nfsFru0HKaeRsIeyGleeFhxS9XTg6cvHVFO94dUVm1+ZA6fNcBLUIGkAberioJwMSikA
         PzuCGx12K/c/MzckJJnAYwNz0bxv5qonjvijlvWEqcPmWk3JLNbP9lHgtlqF3z7kQ5WA
         lRDprzc/d6nY/RopgO2B1m+Tlz6kqy8SdT4zOboUKcJOWW2ulGluOVFXIAVk5mljNHPm
         bpow==
X-Gm-Message-State: AC+VfDwT4SF5IbX3/MzkqORDMz1z8H6zZejd1e/vvTqQ+bB/zdozggXt
	HkRN/TL3smWXDKxgkIzGJjJYNiTxZK6YGL2G7Cs=
X-Google-Smtp-Source: ACHHUZ5A4A3O+7txlbeFTK3FPQBbhzfelt3pPcztJKmBPhBSbQJ/44iVbEwp9i8wHQpP8t5FZ/ddJ0htHD9ZXwIBdiQ=
X-Received: by 2002:a17:90b:1190:b0:256:6462:e399 with SMTP id
 gk16-20020a17090b119000b002566462e399mr9840472pjb.5.1685467794923; Tue, 30
 May 2023 10:29:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230530144637.4746-1-mailhol.vincent@wanadoo.fr> <20230530144637.4746-4-mailhol.vincent@wanadoo.fr>
 <ZHYbaYWeIaDcUhhw@corigine.com>
In-Reply-To: <ZHYbaYWeIaDcUhhw@corigine.com>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Wed, 31 May 2023 02:29:43 +0900
Message-ID: <CAMZ6RqK2vr0KRq76UNOSKzHMEfhz1YPFdg7CdQJqq4pBH3hj5w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] can: length: refactor frame lengths definition to
 add size in bits
To: Simon Horman <simon.horman@corigine.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org, 
	Thomas.Kopp@microchip.com, Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org, 
	marex@denx.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed. 31 May 2023 at 00:56, Simon Horman <simon.horman@corigine.com> wrote:
> On Tue, May 30, 2023 at 11:46:37PM +0900, Vincent Mailhol wrote:
> > Introduce a method to calculate the exact size in bits of a CAN(-FD)
> > frame with or without dynamic bitsuffing.
> >
> > These are all the possible combinations taken into account:
> >
> >   - Classical CAN or CAN-FD
> >   - Standard or Extended frame format
> >   - CAN-FD CRC17 or CRC21
> >   - Include or not intermission
> >
> > Instead of doing several individual macro definitions, declare the
> > can_frame_bits() function-like macro. To this extent, do a full
> > refactoring of the length definitions.
> >
> > In addition add the can_frame_bytes(). This function-like macro
> > replaces the existing macro:
> >
> >   - CAN_FRAME_OVERHEAD_SFF: can_frame_bytes(false, false, 0)
> >   - CAN_FRAME_OVERHEAD_EFF: can_frame_bytes(false, true, 0)
> >   - CANFD_FRAME_OVERHEAD_SFF: can_frame_bytes(true, false, 0)
> >   - CANFD_FRAME_OVERHEAD_EFF: can_frame_bytes(true, true, 0)
> >
> > The different maximum frame lengths (maximum data length, including
> > intermission) are as follow:
> >
> >    Frame type                         bits    bytes
> >   -------------------------------------------------------
> >    Classic CAN SFF no-bitstuffing     111     14
> >    Classic CAN EFF no-bitstuffing     131     17
> >    Classic CAN SFF bitstuffing                135     17
> >    Classic CAN EFF bitstuffing                160     20
> >    CAN-FD SFF no-bitstuffing          579     73
> >    CAN-FD EFF no-bitstuffing          598     75
> >    CAN-FD SFF bitstuffing             712     89
> >    CAN-FD EFF bitstuffing             736     92
> >
> > The macro CAN_FRAME_LEN_MAX and CANFD_FRAME_LEN_MAX are kept as an
> > alias to, respectively, can_frame_bytes(false, true, CAN_MAX_DLEN) and
> > can_frame_bytes(true, true, CANFD_MAX_DLEN).
> >
> > In addition to the above:
> >
> >  - Use ISO 11898-1:2015 definitions for the name of the CAN frame
> >    fields.
> >  - Include linux/bits.h for use of BITS_PER_BYTE.
> >  - Include linux/math.h for use of mult_frac() and
> >    DIV_ROUND_UP(). N.B: the use of DIV_ROUND_UP() is not new to this
> >    patch, but the include was previously omitted.
> >  - Add copyright 2023 for myself.
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> ...
>
> > +/**
> > + * can_bitstuffing_len() - Calculate the maximum length with bitsuffing
> > + * @bitstream_len: length of a destuffed bit stream
>
> Hi Vincent,
>
> it looks like an editing error has crept in here:
>
>         s/bitstream_len/destuffed_len/

Doh! Thanks for picking this up.

I already prepared a v4 locally. Before sending it, I will wait one
day to see if there are other comments.

> > + *
> > + * The worst bit stuffing case is a sequence in which dominant and
> > + * recessive bits alternate every four bits:
> > + *
> > + *   Destuffed: 1 1111  0000  1111  0000  1111
> > + *   Stuffed:   1 1111o 0000i 1111o 0000i 1111o
> > + *
> > + * Nomenclature
> > + *
> > + *  - "0": dominant bit
> > + *  - "o": dominant stuff bit
> > + *  - "1": recessive bit
> > + *  - "i": recessive stuff bit
> > + *
> > + * Aside of the first bit, one stuff bit is added every four bits.
> > + *
> > + * Return: length of the stuffed bit stream in the worst case scenario.
> > + */
> > +#define can_bitstuffing_len(destuffed_len)                   \
> > +     (destuffed_len + (destuffed_len - 1) / 4)

