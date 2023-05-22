Return-Path: <netdev+bounces-4338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69EBF70C204
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DB051C20AEF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACE314A89;
	Mon, 22 May 2023 15:11:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF31E14298
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:11:13 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D233CF;
	Mon, 22 May 2023 08:11:09 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-96fab30d1e1so429966866b.0;
        Mon, 22 May 2023 08:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684768268; x=1687360268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AuMCsYagdD2B/btsXGbofl0+XgpZ3eLWhBM9dBSN1BU=;
        b=l8EQCQ6aP9jjTJ1kFJzKfzj8Z2JbVk1oGkneZEKJeLLgLNGO7LfVpfJexmI32g4WL6
         XhskzOPBUB7natb3F/i8CS5rF/12fNvmcUTrbTk83zJbl30eN/CktXteHHWpjsVZ4kVp
         SfpuqqveVlG2XDE5ZnlPv8WdSxQDUGIdq564Ra8R680cuBTnh3i285hCx2m9wxI08tku
         mEyS2UBAayNgHc8hvhp8CRTlyl7JxsOT/T6AY1mqZ0Ofi+YwoHTGc1+7pCD74x+6jnbU
         EHVYB7oqIKOUIh0p2wTyu9XgmFeHfEGA766xxszCI3tVhgLi1zZVWVZRGq0KeKrLnuH6
         DXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684768268; x=1687360268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AuMCsYagdD2B/btsXGbofl0+XgpZ3eLWhBM9dBSN1BU=;
        b=hWQwgM6HX8mWwyJBUnsb1B1LEOf+T08UfZ9aMS+Ux4QXFkytnjBV9gnaTZzTa7nM5p
         jUtjfmX49VfMcKdcvEd4MUOaj/wsxWuNeBRlW5rqyzzqFsWFHiURGgu1PMT8TR8rniCq
         gwOsGjKVU+AXVmHdWAEMPNkU204/QVY6iSa0YNVqmumufHNKH34uOJjj2YpNwzuqYnyo
         Wc86vEVrJAkwNW5m5lGCXWebs5fwkSnOsvd2uXEUFi22gMXbqXjB2f8UO2E69dFyOTzI
         PbGWk9L+o7V5qLOFdohf0miNVX8AdfptDdmKuNgOyitGMHbCrWDhZW/qDAIwj+JdYgK0
         viDQ==
X-Gm-Message-State: AC+VfDyAP+KVZGae0/cJVd2mZRKhr+zhy9TT/8DAWpv8MeFGEy3S5a2F
	OCl4po/W/hBA5UuYDWHi0RE=
X-Google-Smtp-Source: ACHHUZ66MlsS0CQtuX/rYHx1VKny3lDZ8SAZIa69pLaoWdN3wlKu5qbE8MzmrB5TXN45H9L2kFOO2g==
X-Received: by 2002:a17:907:3fa8:b0:969:e993:6ff0 with SMTP id hr40-20020a1709073fa800b00969e9936ff0mr11293240ejc.25.1684768267290;
        Mon, 22 May 2023 08:11:07 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qx15-20020a170906fccf00b00965f98eefc1sm3211620ejb.116.2023.05.22.08.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 08:11:07 -0700 (PDT)
Date: Mon, 22 May 2023 18:11:04 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <20230522151104.clf3lmsqdndihsvo@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521134356.ar3itavhdypnvasc@skbuf>
 <20230521161650.GC2208@nucnuc.mle>
 <20230522095833.otk2nv24plmvarpt@skbuf>
 <20230522140057.GB18381@nucnuc.mle>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522140057.GB18381@nucnuc.mle>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 04:00:57PM +0200, David Epping wrote:
> On Mon, May 22, 2023 at 12:58:33PM +0300, Vladimir Oltean wrote:
> > If you still prefer to write twice in a row to the same paged register
> > instead of combining the changes, then fine by me, it's not a huge deal.
> 
> Since the clock enablement now happens in all modes the existing rgmii
> function name seems misleading to me.

To be fair, it's only as misleading as the datasheet name for the register
that holds this field, "RGMII CONTROL". Anyway, the function could be
renamed as necessary to be less confusing: vsc85xx_update_rgmii_ctrl()
or something along those lines.

MDIO reads and writes are not exactly the quickest I/O in the world, and
having 2 read-modify-write consecutive accesses to the same paged
register (which in turn implies indirect access) just because readability
seems like the type of thing that can play its part in deteriorating
boot time latency. Maybe we can deal with the readability some other way.

> Also we don't want to enable for
> all PHY types, and the differentiation is already available at the
> caller. I would thus opt for a separate function and fewer conditional
> statements.

I don't understand this. We don't? For what PHY types don't we want to
enable the RX_CLK?

> Its my first patch re-submission, so sorry for the noob question:
> Should I include your "pw-bot: changes-requested" tag with the third
> patch? Probably not.

Nope.

