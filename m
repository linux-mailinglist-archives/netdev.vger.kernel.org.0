Return-Path: <netdev+bounces-10520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3638972ED47
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 912C4280F5B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0084422E5A;
	Tue, 13 Jun 2023 20:47:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8849174FA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:47:02 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E968810E6;
	Tue, 13 Jun 2023 13:47:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5187ae34127so998816a12.2;
        Tue, 13 Jun 2023 13:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686689219; x=1689281219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fSNOwltAQrxAVV68XPYGPjq5L/bIYHyNYEji3sovMB8=;
        b=Ls9NCRlivmPC49auVyJHDRF+h04dMXwMGmh110SKXer2GYxSqLJ9P1EGp0FjvkdV5Y
         ZT59hga7BfF3nhKADgA++VIjISbHOXjbarrE22ZfAE111jgQ3jK7jtShuQEjePBTdLis
         yciak/fmFmqGLf0kPVtaE83SgyEUNf4EYJ8t+BcD70N9SeDplDhhnv21ndbgohUjIo3Q
         qoIFrDRIjD3zlcF+yzNquVLT03HQips/sNO/bgOKLbcYVEkAQUc21wT7i4P3CHKfFH3E
         JBqhJVUG2DsUf/DTTO0WW993S6gOxx5pmwiBMHSV5JbAOZ/Gt2Ydgt6O9rNJJ0aBuvZC
         X8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686689219; x=1689281219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSNOwltAQrxAVV68XPYGPjq5L/bIYHyNYEji3sovMB8=;
        b=MffYQCu4czD09SAUosdYpiNxpsxYXR3J+9M9YE6C1B+ksGn5tQMyzruG1aML0Zzc/j
         4hdEEl4KNXHfASprcRdrLE8I4CQ+bLsQvp87NHBzIaIrVEnY8FCmuG3dumGw1WuW4NMt
         hUKgXpjT1OuUiWNi7S3GfaoED3pwtTHvZIRKmGqKRXX8GEQcSJNPNeTJGxP3rvu2TAKm
         qfJaksbdK0NnAsuwdmvsLdVzmemsnh4YGZJUJP2CWoFbE7O5h3ivrT9FUFp0Sz466oGg
         iCZNYufsgegeT+EIcG9M+ukxpjLFfKdk8ClX+0nhg0JYQXLGwK+jLoeCjCv/yfMh5dqB
         JHww==
X-Gm-Message-State: AC+VfDxdrQxW9NsNUrc2+cR9g++J54Epp/yzfBjqvGnBbiAaCYIqrG0D
	KyOIlAeXNW3L2/dphYRF6f4=
X-Google-Smtp-Source: ACHHUZ5x08A9ldgu+vaqcgdfWvL3xxuzZM1dqATv5NQNkKaCgRk/Z49H2tvIClpjTgNoxcUIajTGMw==
X-Received: by 2002:a05:6402:2055:b0:514:9df0:e3f3 with SMTP id bc21-20020a056402205500b005149df0e3f3mr9203260edb.0.1686689219118;
        Tue, 13 Jun 2023 13:46:59 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b14-20020aa7c6ce000000b00506987c5c71sm6802283eds.70.2023.06.13.13.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 13:46:58 -0700 (PDT)
Date: Tue, 13 Jun 2023 23:46:55 +0300
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
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613204655.7dk5f5pbcyrquva5@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
 <ZIi1fixnNqj9Gfcg@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIi1fixnNqj9Gfcg@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 07:29:18PM +0100, Russell King (Oracle) wrote:
> Maybe it's just me being dumb, but I keep finding things difficult to
> understand, such as the above paragraph.
> 
> It sounds like you're saying that _before_ this patch, port 5 is the
> active CPU port, but the CPU_PORT *FIELD* NOT BITS are set such that
> port 6 is the active CPU port. Therefore, things are broken, and this
> patch fixes it.
> 
> Or are you saying that after this patch is applied, port 5 is the
> active CPU port, but the CPU_PORT *FIELD* is set to port 6. If that's
> true, then I've no idea what the hell is going on here because it
> seems to be senseless.

There are 2 distinct patches at play. I'll be showing some tables below.
Their legend is that patch (1) affects only the second column and patch
(2) affects only the third column.

Patch (1): net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7530
----------------------------------------------------------------------------------

What you need to know looking at the current code in net-next is that
mt753x_cpu_port_enable() always overwrites the CPU_MASK field of MT7530_MFC,
because that contains a single port. So when operating on a device tree
with multiple CPU ports defined, only the last CPU port will be recorded
in that register, and this will affect the destination port for
trapped-to-CPU frames.

However, DSA, when operating on a DT with multiple CPU ports, makes the
dp->cpu_dp pointer of all user ports equal to the first CPU port. That
affects which DSA master is automatically brought up when user ports are
brought up. Minor issue, TBH, because it is sufficient for the user to
manually bring up the DSA master corresponding to the second CPU port,
and then trapped frames would be processed just fine. Prior to ~2021/v5.12,
that facility wasn't even a thing - the user always had to bring that
interface up manually.

That means that without patch (1) we have:

CPU ports in the    Trapping CPU port        Default CPU port
device tree         (MT7530_MFC:CPU_MASK)    (all dp->cpu_dp point to it)
-------------------------------------------------------------------------
5                   5                        5
6                   6                        6
5 and 6             6                        5

The semi-problem is that the DSA master of the trapping port (6) is not
automatically brought up by the dsa_slave_open() logic, because no slave
has port 6 (the trapping port) as a master.

All that this patch is doing is that it moves around the trapping CPU
port towards one of the DSA masters that is up, so that the user doesn't
really need to care. The table becomes:

CPU ports in the    Trapping CPU port        Default CPU port
device tree         (MT7530_MFC:CPU_MASK)    (all dp->cpu_dp point to it)
--------------------------------------------------------------------------
5                   5                        5
6                   6                        6
5 and 6             5                        5


Patch (2) net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
--------------------------------------------------------------------------------

This patch influences the choice that DSA makes when it comes to the
dp->cpu_dp assignments of user ports, when fed a device tree with
multiple CPU ports.

The preference of the mt7530 driver is: if port 6 is defined in the DT
as a CPU port, choose that. Otherwise don't care (which implicitly means:
let DSA pick the first CPU port that is defined there, be it 5 or 6).

The effect of this patch taken in isolation is (showing only "after",
because "before" is the same as the "before" of patch 1):

CPU ports in the    Trapping CPU port        Default CPU port
device tree         (MT7530_MFC:CPU_MASK)    (all dp->cpu_dp point to it)
-------------------------------------------------------------------------
5                   5                        5
6                   6                        6
5 and 6             6                        6

As you can see, patch (2) resolves the same semi-problem even in
isolation because it makes the trapping port coincide with the default
CPU port in a different way.

> 
> I think at this point I just give up trying to understand what the
> hell these patches are trying to do - in my opinion, the commit
> messages are worded attrociously and incomprehensively.

+1, could have been better..

