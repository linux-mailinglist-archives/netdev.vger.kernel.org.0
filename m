Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4591978441
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 06:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfG2Emr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 00:42:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43727 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfG2Emr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 00:42:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so19997692pld.10
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 21:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=l92voTIZEyekIch5SAn07z8owJJ0AY4RSH8j88UGsQY=;
        b=EgI7tgjtQE8yUhxXAyVwkKNWHwNX7a55Hc6LVsWrk090s+9jmw5GYHYiHl6VrX+Wbs
         CYnktHVRr3WVk1fWJpB0YlfqR3MrOYIQJ7PxyebBweNuDL/86ILJYebFlcwRd+CfUt4A
         i8KUCRHuBcpN1VbY/HWBusK+vNfvierZZcIJJ4oESJdCRJVC42cQ7i6H+R2GkkT/ZszB
         TCcRsRkTVE/omKK4Uh4MBfkyX+bVgb4tVOWyH8L9yfgyC76g/UFgV/NjZih8ySK1RVG+
         ukR24VuewPjwXyExiI6+egl4bwFkXOgBabKBesJUroKnGlNNcPPMOpYqmRW4HynJucDL
         XWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=l92voTIZEyekIch5SAn07z8owJJ0AY4RSH8j88UGsQY=;
        b=TAE+dDFHMAW8iHA4Ee2V8ZF65H9R35SIIE/1vABBrwJ6OnwzoiPMDOP7titUUEkTrg
         np4F419sF0bkR7xs7HOI7Re9p7bbEkGaCb82p4X1ZOANp0l9OVkbG3MvoKQ14XyAhF6n
         BHbaBsKwa8T6xEb4bdshxecOfKEoXC/moUTBqUNh+cFPR0Q2Eryx1fswzNzrmgf74P4o
         5VE4exlIp7sA6idcXOjv7GP1HwR0AquEruHWza9+QzTcAFjId20srXfbbyLkqZ+ZKmn6
         JmsBtjIDoCcpBHEi18Wpe4Ff+SSp43q388b1zEHcgO/dNJkeFbTh8BJyAYSGqRMUim4a
         Hjdw==
X-Gm-Message-State: APjAAAV16+UNn9ooFI2NH8FBPFqKNZYD6j4sWmLemKgdF9t12RJkfU1h
        ATPQfFMZnk+AsMKEmBHDjTK97YmNg1A=
X-Google-Smtp-Source: APXvYqx8ZF3Tm6npsTxWEJVnTfZuXsgkJ+7nkec8proE/fymVNYurnzUJ2SETiDP0IkOexKMOSP5cQ==
X-Received: by 2002:a17:902:a607:: with SMTP id u7mr108807346plq.43.1564375366836;
        Sun, 28 Jul 2019 21:42:46 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id w16sm72704191pfj.85.2019.07.28.21.42.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 21:42:46 -0700 (PDT)
Date:   Sun, 28 Jul 2019 21:42:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
Message-ID: <20190728214237.2c0687db@cakuba.netronome.com>
In-Reply-To: <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
        <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
        <20190728131653.6af72a87@cakuba.netronome.com>
        <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 10:43:56 +0800, wenxu wrote:
> On 7/29/2019 4:16 AM, Jakub Kicinski wrote:
> > I don't know the nft code, but it seems unlikely it wouldn't have the
> > same problem/need.. =20
>=20
> nft don't have the same problem.=C2=A0 The offload rule can only attached
> to offload base chain.
>=20
> Th=C2=A0 offload base chain is created after the device driver loaded (the
> device exist).

For indirect blocks the block is on the tunnel device and the offload
target is another device. E.g. you offload rules from a VXLAN device
onto the ASIC. The ASICs driver does not have to be loaded when VXLAN
device is created.

So I feel like either the chain somehow directly references the offload
target (in which case the indirect infrastructure with hash lookup etc
is not needed for nft), or indirect infra is needed, and we need to take
care of replays.
