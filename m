Return-Path: <netdev+bounces-11113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE80731923
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60EB4281768
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925A87486;
	Thu, 15 Jun 2023 12:46:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864A71FDA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:46:06 +0000 (UTC)
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA132126
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:46:04 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6b251ef7b77so488278a34.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=constell8-be.20221208.gappssmtp.com; s=20221208; t=1686833164; x=1689425164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iAhWnlZBkdO91/8vFM8fT8F4do+BSFxNrVt41AXDoto=;
        b=OxwFv1wf21aNqoyzeQWxzGh1yDdqEy8dF3pZ5ObtQbwejbO9PTFPJ7RwGKPQupeYRc
         iD1V6K+bKXJxYkDS3sq9W03vJuZZFgqMwv2cfE1IK3pEWwaZ/1mfhgzEGJww9F0RzLyv
         NSikgR5Lwu6qBtnn/TqBN27BchJAUI4BztNPWj3YCZAfGBfMMq+Eac23GpZWstY58Uso
         AaHfiPeylY+ncnIxua+4lhBjzp7MvVW3CFM4J4yP8y8jLrRBtJ+DrUDA270nnDE69Tlp
         Rk8oN8LezCh+pGBwD+NQGfTdc/qiXkq1Bnf3X7unq/li7ZLTO4CtOatrpf0/nZAPM5eL
         /MSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686833164; x=1689425164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iAhWnlZBkdO91/8vFM8fT8F4do+BSFxNrVt41AXDoto=;
        b=a4af0U72gRlNM0TN4XWAcmTSztIFpcSVakZAIUFSSjQ/yFSSClZUVA8YTvY0lKQOzf
         gJmFI2JvZAY49WKwvodGRd2tBem5Wxq582e+JhrC6BgTdqO6n1IOXqUseoWPqud3BRzl
         y4LbNtoAJcwLWU6xgJolU86df91cQCDhpX6keHTU+a2xU+5PRNChPbJ0E4PjrgReoK7a
         C7mss05t0Y9Wl3atRuVxLx6vTJLQSEbHdu7RQq3UC2/bDUQ92OKIW17r+OYunwPYZ/x0
         k7VP/TiyKEdN0navc5B5v/rGTHJKb1B1TmHzq/JJXH7oPlYOuu1rJHuKMYAEVhzUmC5/
         5qow==
X-Gm-Message-State: AC+VfDx6dlJ+vwhchrQDQCh4huyDtQxDlz6sdws4bFliH0gorlSPJtTh
	93itw/oCCFpK1U9Smg9OtCw8faxRMMHZv9GHmcAOFw==
X-Google-Smtp-Source: ACHHUZ7hMuZ4EaQdJXL2G/QFjU2ZncPgCI4wxW+vxAf1U6DMzIAq5Pd8M+JW8k6L4F1bvWMz0pEL/dJVAoF2PB2lIKQ=
X-Received: by 2002:a05:6870:148b:b0:1a6:8911:61a9 with SMTP id
 k11-20020a056870148b00b001a6891161a9mr2695495oab.29.1686833163860; Thu, 15
 Jun 2023 05:46:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612075945.16330-1-arinc.unal@arinc9.com> <20230612075945.16330-6-arinc.unal@arinc9.com>
 <ZInt8mmrZ6tCGy1N@shell.armlinux.org.uk>
In-Reply-To: <ZInt8mmrZ6tCGy1N@shell.armlinux.org.uk>
From: Bartel Eerdekens <bartel.eerdekens@constell8.be>
Date: Thu, 15 Jun 2023 14:45:27 +0200
Message-ID: <CABRLg09hXm3=mca70TdZLuxA1d8YzOcWj31NvFG0ZWoStn_w9Q@mail.gmail.com>
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: arinc9.unal@gmail.com, =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>, 
	Daniel Golle <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>, 
	DENG Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>, 
	Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Frank Wunderlich <frank-w@public-files.de>, mithat.guner@xeront.com, erkin.bozoglu@xeront.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 6:42=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9.unal@gmail.com wrote:
> > From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> >
> > LLDP frames are link-local frames, therefore they must be trapped to th=
e
> > CPU port. Currently, the MT753X switches treat LLDP frames as regular
> > multicast frames, therefore flooding them to user ports. To fix this, s=
et
> > LLDP frames to be trapped to the CPU port(s).
> >
> > The mt753x_bpdu_port_fw enum is universally used for trapping frames,
> > therefore rename it and the values in it to mt753x_port_fw.
> >
> > For MT7530, LLDP frames received from a user port will be trapped to th=
e
> > numerically smallest CPU port which is affine to the DSA conduit interf=
ace
> > that is up.
> >
> > For MT7531 and the switch on the MT7988 SoC, LLDP frames received from =
a
> > user port will be trapped to the CPU port that is affine to the user po=
rt
> > from which the frames are received.
> >
> > The bit for R0E_MANG_FR is 27. When set, the switch regards the frames =
with
> > :0E MAC DA as management (LLDP) frames. This bit is set to 1 after rese=
t on
> > MT7530 and MT7531 according to the documents MT7620 Programming Guide v=
1.0
> > and MT7531 Reference Manual for Development Board v1.0, so there's no n=
eed
> > to deal with this bit. Since there's currently no public document for t=
he
> > switch on the MT7988 SoC, I assume this is also the case for this switc=
h.
> >
> > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT753=
0 switch")
>
>
> Patch 4 claims to be a fix for this commit, and introduces one of these
> modifications to MT753X_BPC, which this patch then changes.

Let me chime in on this one, as mentioned by Arin=C3=A7, I am one of the
requesters of having this patch (and patch 4).
Patch 4 enables the trapping of BPDU's to the CPU, being STP (Spanning
Tree) frames. Maybe that should be mentioned, to be clear.

>
> On the face of it, it seems this patch is actually a fix to patch 4 as
> well as the original patch, so does that mean that patch 4 only half
> fixes a problem?

This patch then also adds trapping for LLDP frames (Link Layer
Discovery Protocol) which is a completely different protocol.
But both rely on trapping frames, instead of forwarding them. So
that's why the enum was changed, to be named generic.


> And I just can't be bothered trying to parse the commit messages
> anymore.
>

I do agree some parts of the commit message could be omitted.
Especially the part of the R0E_MANG_FR, as it just describes a default
reset state of a register.
But it adds confusion mentioning it, as it is not even used in the patch it=
self.


Bartel

