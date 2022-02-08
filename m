Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB74AD8A7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbiBHNPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350334AbiBHMPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:15:34 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1482BC03FEC0;
        Tue,  8 Feb 2022 04:15:34 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id q22so24150047ljh.7;
        Tue, 08 Feb 2022 04:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=2GE6Q0D3nEM9QK+CkQht2Y4pLl2s1etXJlLVBzJ5ih8=;
        b=H9rZ/I0jxjWtcDngwgYUkZB6+c1jgkoSzx9diPClqzk+qipqU+CoO0jeNarTTOJraD
         yAwmr+aMt5Vy0D48+IURaOm7+iDdS0+W2lsYhnb6eLdFA8ftUVmDzVwzUfRV46b8R0+a
         RZHqw35+wt1DytW8nYBPCqAb8B1T4MJxadEKK9E0lLS2MIsS3eAAOjniDMEvpSOHQIh4
         l+H2PhcKlbB0Ui9rIoOVoJbMyzp7uvQJPo37lwvOUd4k7BndLHNbZ4fSXFAxfmbEQWTa
         kepuJ05xembxMUoo23fki4pciZ2kUwasuFqPZP2orQ3FlUBLSP3UVqoreXvntpQ864sH
         z71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2GE6Q0D3nEM9QK+CkQht2Y4pLl2s1etXJlLVBzJ5ih8=;
        b=zqks/ZNrkzhRLUEZk9JIgYCVseHlMmKjc3wT5kVzwTPlqzpHb1pN8O7Wko12oOPn8v
         1/Qou5Gz6WACzCSaIIzyvAQWrPmopN+5s0Gsc3Gpe7M8aTeoXWZq6FbK5gDR1KQ+pRGC
         0mdFok1bFtxXYpN0MKUG5eI37BHD3Eb15CyZ6d2t6dJgVLsegE9sgMUY/3CQM2O8RE07
         FkuWV/d5kedHwimIOdG8Lt36lgHZ31tk3PP2z0yP2fY7LrHsN61ZIYn6JM9ZL5uWRa3J
         d1OT7uERpTzsNzQbgvXPJvhEHgha/AInpIqcBCLgmyrIJhH3TvEGGSreI4ldy74y7nXd
         siZQ==
X-Gm-Message-State: AOAM532GsDG3qKiSDRfldYpfQeeh6ZnmN6ptKTmEn91fezZf7xeBf95Y
        yDwJ5iFQNz3yNdH3s4WkW+LEzGDc+3NvVdzHJER0GQ==
X-Google-Smtp-Source: ABdhPJxy+YHcTtW7eNm2n7wF2SdFfO6lhPQN2ERdYd7UGp81hbU2MelLgL0YFXjHURFBHBGD0NHRqw==
X-Received: by 2002:a2e:9f4a:: with SMTP id v10mr2598113ljk.79.1644322532310;
        Tue, 08 Feb 2022 04:15:32 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id m26sm1900240lfp.45.2022.02.08.04.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 04:15:31 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: dsa: mv88e6xxx: Add support for
 bridge port locked feature
In-Reply-To: <YgEnIksFSHaRZtK7@lunn.ch>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
 <20220207100742.15087-4-schultz.hans+netdev@gmail.com>
 <YgEnIksFSHaRZtK7@lunn.ch>
Date:   Tue, 08 Feb 2022 13:14:45 +0100
Message-ID: <86mtj1lfm2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On m=C3=A5n, feb 07, 2022 at 15:05, Andrew Lunn <andrew@lunn.ch> wrote:
> On Mon, Feb 07, 2022 at 11:07:41AM +0100, Hans Schultz wrote:
>> Supporting bridge port locked mode using the 802.1X mode in Marvell
>> mv88e6xxx switchcores is described in the '88E6096/88E6097/88E6097F
>> Datasheet', sections 4.4.6, 4.4.7 and 5.1.2.1 (Drop on Lock).
>
> This implementation seems to be incorrect for 6390X, and maybe
> others. I just picked a modern devices at random, and it is different,
> so didn't check any other devices.  The 6390X uses bits 14 and 15, not
> just bit 14.
>
> So either you need to narrow down support to just those devices this
> actually works for, or you need to add implementations for all
> generations, via an op in mv88e6xxx_ops.
>
>     Andrew

The 6096 and 6097 also use both bits 15 and 14, with '01' being Drop On
Lock and the default being '00' No SA filtering. '11' is drop to CPU, which
can also be used for 801.1X, so 'x1' should suffice for these devices,
thus setting bit 14 seems appropriate.
