Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD80633F00
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiKVOed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiKVOeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:34:15 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AEE167DC;
        Tue, 22 Nov 2022 06:34:14 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y4so13831870plb.2;
        Tue, 22 Nov 2022 06:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mFEnTv9c9Q40q8O7fLPV6jtytr9SomEYWLWfoLZ4D+U=;
        b=iQAIGqRGzHGVUP9Wb7fe+NkV2rNeEFNeD5y6U6QG0LJ6DJhA8prJT7V9N3wRaJxl7B
         6cNIpxxROBS2IINzngB1Lmoj2+stJmI/fVH+OlTsk8YOQiJyhu+OWZmULtb2fLW4tCpj
         13CqmJuLeRUkQ8Vdww4Z0ffJksEWx3cnG3djb2ELcVE8s/rYxLdvrQilZqzpnlC6w1Xw
         PtuoCsdOTiDaV9a0VLeQBKOOeu+gNKo4saWhvPdJ0HX2cb96Kgxncbm7soZsnzv5fMKj
         9mxBsJZkYF7KbQ0ngljDdJH5wJ0q3Eb3n41EL25GIr7wS/rE6yMsgAx+3pqtDhe+IFgT
         Av/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFEnTv9c9Q40q8O7fLPV6jtytr9SomEYWLWfoLZ4D+U=;
        b=2tNI5Hxyyyx115wqEqkoG4mYowdQTE7ApJkZQ/uFY88vCe1kepUWHNiczkkAK5MuqB
         ZB5mvEdIXquhfnKW4gVlO6efheodx2DRpHlU+mRvgA1fxELOqSAiWfRR8u54z4k2P7DI
         59yRMenYVfp8iA54bugxiJxosBuHTtdXJes1zxsBdTqBP0tKGR0Ugaz/di1Om5RAXcf4
         QoYQ8+x1+0edpGciLS9FGnLY0c2c9YaUdu2bjr/cUEFNz6yIqJRl8pErokd4Ec3fh36H
         ekLvgde372eCCfqZ6FnR5N1uqTWrexn+07AmMJLoWN3abTdiKo8k3BIkTqv/rjtMErsV
         9mBQ==
X-Gm-Message-State: ANoB5pmNYMubJtIW0vg+RPXAjRTcN9lO5OXiWANY1J1YJKzjkqy9nlLG
        Ep/X2q+TUi/kJ7T0FCk5XHM=
X-Google-Smtp-Source: AA0mqf4X8oAb91GZ15iilh8E0ouZ5f9SsasBuPnHAYnBZKa7xoboYsji9ArGf40Tbxax+O6ErjqzRA==
X-Received: by 2002:a17:903:1311:b0:189:1e5:8422 with SMTP id iy17-20020a170903131100b0018901e58422mr4223794plb.17.1669127653840;
        Tue, 22 Nov 2022 06:34:13 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y129-20020a62ce87000000b0056bd737fdf3sm10745546pfg.123.2022.11.22.06.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:34:12 -0800 (PST)
Date:   Tue, 22 Nov 2022 06:34:10 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com
Subject: Re: [RFC Patch net-next v2 1/8] net: ptp: add helper for one-step
 P2P clocks
Message-ID: <Y3zd4s7c3TPKd/Rb@hoboy.vegasvil.org>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121154150.9573-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 09:11:43PM +0530, Arun Ramadoss wrote:
> +/**
> + * ptp_header_update_correction - Update PTP header's correction field
> + * @skb: packet buffer
> + * @type: type of the packet (see ptp_classify_raw())
> + * @hdr: ptp header
> + * @correction: new correction value
> + *
> + * This updates the correction field of a PTP header and updates the UDP
> + * checksum (if UDP is used as transport). It is needed for hardware capable of
> + * one-step P2P that does not already modify the correction field of Pdelay_Req
> + * event messages on ingress.
> + */

Does this really belong in the common PTP header?

Seems more like a driver/hardware specific workaround to me.

Thanks,
Richard
