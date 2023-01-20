Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA4B674ECA
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 08:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjATH5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 02:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjATH5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 02:57:49 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9669D9ED5
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 23:57:45 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30K7v56v2364893
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 07:57:07 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30K7uv2T4020554
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 08:56:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674201420; bh=O/EiTftPeHR2I5AYjumz9TQhZSfxID3xbJ1T4v6gsS0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Ke5TbmbRu9FSujhv7hlxS4V9TQ6vL6yBng1WvWexrUJKSClJDimyHkvjzHGWrx9Vz
         yc5lXrEZpNa/GPxkADPwy1vaIDr4veQdscRwIq4EGBChO0a0J/AmbUjIpW0tsDYaZg
         n/bKMz9w8iaIRh+Uezhsk8EdxOD+S6Bex+WEuryM=
Received: (nullmailer pid 527046 invoked by uid 1000);
        Fri, 20 Jan 2023 07:56:57 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net 2/3] net: mediatek: sgmii: autonegotiation is required
Organization: m
References: <20230119171248.3882021-1-bjorn@mork.no>
        <20230119171248.3882021-3-bjorn@mork.no>
        <Y8l8NRmFfm/a8LFv@shell.armlinux.org.uk>
        <87v8l2uxoi.fsf@miraculix.mork.no>
        <Y8m75N5//L+PHo8f@shell.armlinux.org.uk>
Date:   Fri, 20 Jan 2023 08:56:57 +0100
In-Reply-To: <Y8m75N5//L+PHo8f@shell.armlinux.org.uk> (Russell King's message
        of "Thu, 19 Jan 2023 21:53:40 +0000")
Message-ID: <87pmb9vdti.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> If you have 'managed =3D "in-band-status";' in your DT, that will set
> "mode" to be MLO_AN_INBAND, and phylink_autoneg_inband(mode) will be
> true - which should result in the link being programmed for in-band
> mode. You should also find that mtk_pcs_get_state() gets called.
>
> Hmm, it looks like setting ss->pcs[i].pcs.poll to true was missed
> when support for inband was properly added, so that might be the
> issue there - as the mtk ethernet driver doesn't make use of
> phylink_mac_change().

OK, this doesn't just work as-is either. But I guess that's something
else.  Will try to debug some more.

But I wonder:  Why would I want to use "in-band-status" here? Is that
the preferred mode?  Probably stupid question.  But shouldn't we also
make this link work without it, whatever that takes?

Note that I don't have to care about unknown phys.  No SFP cage on this
board.


Bj=C3=B8rn
