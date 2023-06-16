Return-Path: <netdev+bounces-11362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 465F8732CA2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01CFF281499
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17770174CB;
	Fri, 16 Jun 2023 10:01:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6817AA9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:01:36 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E5F2D54;
	Fri, 16 Jun 2023 03:01:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-982b1a18daeso75107766b.2;
        Fri, 16 Jun 2023 03:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686909694; x=1689501694;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CTD9FM9Vp+btRQLrVajymg/zAFnLC/qJq3qRO1vQtsE=;
        b=p5uAOLuXx71MLpQNhpn4N0FFQkpI9/UNwpzCa9npQZiimQMI+dTK57ix5hFZ8pL0iT
         eM/jU6DLqslcFv9S5cRKyJ9DyVWLOZDOsZAJjclG0miP0XzxBdljxz8Qs9DT0KVGuV4Y
         hDovP96Nx4G7raTQV5C6TOMlOfhGf/8kfUdMhmnNfKxmL0Ztl3oKrW+hk5bGtznskvvt
         p7HID9ouqKpIcGhsKqjiSn1ewQgqCUuvnmBj9paMo59IT5jrcCml2vXZ59EwDBgF8l+d
         92iNKDZTIBfZENDuXm1n40jOV8d0uypVfXB1kp9BFqsdjwVJbTWwXGrjN46LD85/qiXN
         6how==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686909694; x=1689501694;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTD9FM9Vp+btRQLrVajymg/zAFnLC/qJq3qRO1vQtsE=;
        b=Hi0H+Z+b8dkZh5MIoM/s+8je4IpGWCOusalvjpF1Chog+u+yS5dnMi0faYQbmxxv39
         RWNj/OoJAzmC8Ft5wk0/4c8vLO9W9O1vTrEZAa4EvESdaFTIe1N7Kvbr3hQDRMQN8zmO
         IDRj5w6Ad1jCU0OQ/RY92+8ew0jsXD6G2BM3kPww5ODBcDzPFXeuSkXmTfxyKie4fQKe
         GPby8Vp/UbENiu9QOK0gYBMo5ThBscoAkJuEHhy1vtxVIBrZT+J/uRFwNsHPSTOdPixm
         zoiT+qyoIqFKRh2Bwg8Cbsl2kq0Mu7WJuL9Qk7CYB2ijlCW0nQ5FRnPtNu3xQUDo7d9g
         hZHA==
X-Gm-Message-State: AC+VfDw8op6Kpmqt5FjIHCD9uuMgMpB66NzgGxf5x0m/vnK6wZ3hKh0t
	ufikRDZGpN9bwghgSvgXlq0=
X-Google-Smtp-Source: ACHHUZ6AASGe9oOuSxFdSZcLgURQh/Q6I24jkt2GFQJgseqvnYOxE88CzRrIgflJ/3f+8NFpganRgg==
X-Received: by 2002:a17:906:8688:b0:97a:bd0f:ac74 with SMTP id g8-20020a170906868800b0097abd0fac74mr1180635ejx.26.1686909693612;
        Fri, 16 Jun 2023 03:01:33 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id h22-20020a170906111600b009828bb40444sm2647818eja.51.2023.06.16.03.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:01:33 -0700 (PDT)
Date: Fri, 16 Jun 2023 13:01:30 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 1/6] net: dsa: mt7530: set all CPU ports in
 MT7531_CPU_PMAP
Message-ID: <20230616100130.f7mjociopsgd6pe4@skbuf>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-2-arinc.unal@arinc9.com>
 <20230616025327.12652-2-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616025327.12652-2-arinc.unal@arinc9.com>
 <20230616025327.12652-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 05:53:22AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> MT7531_CPU_PMAP represents the destination port mask for trapped-to-CPU
> frames (further restricted by PCR_MATRIX).
> 
> Currently the driver sets the first CPU port as the single port in this bit
> mask, which works fine regardless of whether the device tree defines port
> 5, 6 or 5+6 as CPU ports. This is because the logic coincides with DSA's
> logic of picking the first CPU port as the CPU port that all user ports are
> affine to, by default.
> 
> An upcoming change would like to influence DSA's selection of the default
> CPU port to no longer be the first one, and in that case, this logic needs
> adaptation.
> 
> Since there is no observed leakage or duplication of frames if all CPU
> ports are defined in this bit mask, simply include them all.
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

