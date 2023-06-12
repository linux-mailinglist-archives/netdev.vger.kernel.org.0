Return-Path: <netdev+bounces-10081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8F072C040
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F3242810DA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620C611CAD;
	Mon, 12 Jun 2023 10:51:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C3111C99
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:51:05 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF907DB0;
	Mon, 12 Jun 2023 03:50:59 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-977d0288fd2so706834866b.1;
        Mon, 12 Jun 2023 03:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686567058; x=1689159058;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XrJnAcQXaaKtEzxkhRkZVaQ+TNeCvbTHyVGe6/lX350=;
        b=ZX/zgdnjqLp5frWFF0tmhlrQaah5uP+E2/nKpuVuLRyU3dvU+9+tJt9RnDMzo9ZNM8
         KuHSt662s1ARIEposq65rWX/QbqddpAjkFg0q4mp+3pXqs4PZpOZxPPWf2//ZqLqHTOV
         k+xT1AWGSKR+MROAvQ+tFHJemt5OzLlkQwmR7E8M6m/CwlPxmoU+57zpDEHZt7N9KExM
         1dv8LfZyWFPxPq08yHV1CzIft2zOYkSHLRnAYrxlXQAXVuwHsYKDZJYdufLTTDD8F57R
         VGrMYibyu3WyB5dTp7MBKVMnAhJhAMh6YMrLa90HywEg4nAmlfYBULzgdf02rvTESf2X
         x2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686567058; x=1689159058;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XrJnAcQXaaKtEzxkhRkZVaQ+TNeCvbTHyVGe6/lX350=;
        b=PRBo7JUQf/ARVQGwzFP8p5C7tbhwD4jYJ/GHtGA1LrzhqU+0Yuaond2f21Z217PD/5
         mB+dGl91GTjboF/MDjbnDoA4Xn5r2jrv7+dhKm+b0XXNzVS1Qd+eJ8Ex+THKf5DNDVDf
         NppqMVptkNF4meHwlSZCovPF0yRHJIIMpnfnDOhGApaHhTOFosgzDrM+aIs8lWmaePZS
         UkL2PemEyNWgkSgwfcc4uWMiYqFi1/rRyIROMj3d6jCqKARENq0HC6WqWF3oFGvvXT27
         FN8yh6qyMg8HWNfyc8cAW1iEMdyPCzREftBWvCg23NK2w8hz+1EMAnzdjgqGXdkuApu0
         pn6w==
X-Gm-Message-State: AC+VfDxDPwBZ4YwmoU+Yu3FyKoCWgUNR6/yQ7eYYTFHS1D8oBCW0XSKu
	g+nOolmckMLBdUb23Hz8ruA=
X-Google-Smtp-Source: ACHHUZ7lljuQbOIokmQ75s0khk6c2hRSyrkERDFUFIGiWkYHqQiu5SAlW3DeI44y6F+AWXNzoFMuRA==
X-Received: by 2002:a17:906:fe4d:b0:973:93e3:bc9a with SMTP id wz13-20020a170906fe4d00b0097393e3bc9amr8904535ejb.6.1686567057749;
        Mon, 12 Jun 2023 03:50:57 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id t16-20020a1709066bd000b009596e7e0dbasm5025364ejs.162.2023.06.12.03.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 03:50:57 -0700 (PDT)
Date: Mon, 12 Jun 2023 13:50:54 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
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
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v2 1/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7531
Message-ID: <20230612105054.fqv46qpnpf2ktc3b@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <ZIXwc0V5Ye6xrpmn@shell.armlinux.org.uk>
 <9d571682-7271-2a5e-8079-900d14a5d7cd@arinc9.com>
 <ZIbuxohDqHA0S7QP@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZIbuxohDqHA0S7QP@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:09:10AM +0100, Russell King (Oracle) wrote:
> > Yes but it's not the affinity we set here. It's to enable the CPU port for
> > trapping.
> 
> In light of that, is the problem that we only enable one CPU port to
> receive trapped frames from their affine user ports?

The badly explained problem is that this driver is not coded up to handle
device trees with multiple CPU ports in the way that is desirable for Arınç.

Namely, when both CPU ports 5 and 6 are described in the device tree,
DSA currently chooses port 5 as the active and unchangeable CPU port.
That works, however it is not desirable for Arınç for performance reasons,
as explained in commit "net: dsa: introduce preferred_default_local_cpu_port
and use on MT7530" from this series.

So that change makes DSA choose port 6 as the active and unchangeable
CPU port. But as a preliminary change for that to work, one would need
to remove the current built-in assumption of the mt7530 driver: that the
active and unchangeable CPU port is also the first CPU port.

This change builds on the observation that there is no problem when all
CPU ports described in the device tree are set in the CPU port bitmap,
regardless of whether they are active or not. This is because packet
trapping on these switch sub-families follows the user to CPU port
affinity, and inactive CPU ports have no user ports affine to them.

