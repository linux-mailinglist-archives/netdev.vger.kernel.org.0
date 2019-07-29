Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C8279176
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfG2QvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:51:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32963 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbfG2QvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:51:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so27667408plo.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PZ4zdSXRjhVVczI0hnigI3cAI+Gv8l4oPfWHJOpfRNw=;
        b=XcXC2jFtR8VKPsPPv5LVAqaP0fS39y2ORYmiTgMo4YgxmN/ThBrUMerqNHdvVbk6/e
         9OxGtSEwN8LoZMfNWi6AeKQTZe4AndCSgbWWwBz/v1amP1d8tWwDyu/BKJZSNMtgLZOI
         zBlSc4HyRf3lSK4NnO7xghmK0Tymf4XSWEZEEJfwGdQ8uF+Aj9oevhfiy16QDhmQI630
         iYD0YfeEOW/hPDrnaF2DnrXZ4m1yv0PWmqTsDBb5j3/rP1tWu90hGz6mTBw6q1Y4D7iZ
         5gWnM2XpzyB9xgmpy5v612br0hQhnoN6e+vb+KHBEco8whUSEYaAj68dN7gfsESF7AP0
         V8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PZ4zdSXRjhVVczI0hnigI3cAI+Gv8l4oPfWHJOpfRNw=;
        b=aExLk/qy6llyhBzoqqPhnme2lmUO7Lje6TbQwIaKz8rjPuduY0txNV++uacF3TUk1K
         Bth5TNcoc8ZSgO7qT4YlnKT8CjcN/2T1oxzkkocTQEZnm3REt+0ilfo1GXoagDK+sVCH
         mzdD6VZgjsC+Tgv0EdMyH9v1ftW+iHQYyrptiTShKicxhlMvMBCmukNrwMh5DYL3fNZ2
         GNBSSj8bJx2AyodhBRDhPASy3jlG0lcTZxFCR2ZfHUMo2HlumIH0mCER+w9IWBOvqGOy
         kzCT0P1RgGpAX9PHmWn2giDSfor3hDY+bk1BGUZLNV5dJjlQzYNlnAS9seiDLp7qRyMY
         cQ9A==
X-Gm-Message-State: APjAAAUPtEx/Itkk7J0KZxnw5AdI8aUvxALPEVK1zNCAU0zCso1rzQF4
        PZEo3SougeFQlv8sYxgyNXyHXOvK2sE=
X-Google-Smtp-Source: APXvYqwXLY8i6VZ1vyAcN34jmpHxHou3rK2owBAG7SGsSd9d7yXF87SUmWGN+c5iDQp1wrELpuTwwg==
X-Received: by 2002:a17:902:2be8:: with SMTP id l95mr103118749plb.231.1564419070126;
        Mon, 29 Jul 2019 09:51:10 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id u69sm80063511pgu.77.2019.07.29.09.51.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:51:09 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:51:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
Message-ID: <20190729095100.5d03a521@cakuba.netronome.com>
In-Reply-To: <c405ff42-dfc5-6f3f-061c-7788e1204afa@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
        <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
        <20190728131653.6af72a87@cakuba.netronome.com>
        <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
        <20190728214237.2c0687db@cakuba.netronome.com>
        <c405ff42-dfc5-6f3f-061c-7788e1204afa@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 15:05:34 +0800, wenxu wrote:
> On 7/29/2019 12:42 PM, Jakub Kicinski wrote:
> > On Mon, 29 Jul 2019 10:43:56 +0800, wenxu wrote: =20
> >> On 7/29/2019 4:16 AM, Jakub Kicinski wrote: =20
> >>> I don't know the nft code, but it seems unlikely it wouldn't have the
> >>> same problem/need..   =20
> >> nft don't have the same problem.=C2=A0 The offload rule can only attac=
hed
> >> to offload base chain.
> >>
> >> Th=C2=A0 offload base chain is created after the device driver loaded =
(the
> >> device exist). =20
> > For indirect blocks the block is on the tunnel device and the offload
> > target is another device. E.g. you offload rules from a VXLAN device
> > onto the ASIC. The ASICs driver does not have to be loaded when VXLAN
> > device is created.
> >
> > So I feel like either the chain somehow directly references the offload
> > target (in which case the indirect infrastructure with hash lookup etc
> > is not needed for nft), or indirect infra is needed, and we need to take
> > care of replays. =20
>=20
> So you mean the case is there are two card A and B both can offload vxlan.
>=20
> First vxlan device offload with A.=C2=A0 And then the B driver loaded, So=
 the rules
> should replay to B device?

That'd be one example, yes.
