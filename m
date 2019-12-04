Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237051135CB
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfLDTgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:36:21 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32804 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbfLDTgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:36:21 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so534143lfl.0
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8YzffI6BTbDDQcKipmBH3epvQxf1I8mA0zvypaeoYk0=;
        b=jjvcrGPCuHTHOGJJrH8U0Iyx3nsiiJlWtNPChRrPmX8N5u9p2MMFCXAOFPLEY8M4gs
         RPtpg7yVp62/m5iFVQ01HaJPE6lPmyWLHI0C+LYBjNe1+MmgJseGa85LoFRhZXBGVwv1
         IdyOohDBo/audQdOUMqjm7q3eJld7sprvONff0oMmdTq/d/cTSI761ZhBXPKrqrdmCXJ
         eyGbAgMD7fpi/wUB2Dgu5U2MjpFfuN5SXsEkFHuxRD1mx1MOAYSxBjIjM7g82faeE/+A
         iwwhT+PtByDqNf6hghXKTDPZxrEl30mrp8gkdTyKOyTqQ6RMveZrGCGRpBoWeKbp2TPQ
         dAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8YzffI6BTbDDQcKipmBH3epvQxf1I8mA0zvypaeoYk0=;
        b=C8ZehhgM0EI8pKpm0GZVLMtDdE2XKyhXIXPJD3SwAhSIwWQRYvYm/tRmBianFcSh7/
         ekGE3IhnhyjvSXq3xfnafpro7VOg+klHi9Ic6bE3iMkR78t5WJYgBNI0nhbzbuaEO+/R
         VK59szFKoW2eJpL92qZJ0EwSPIOhaoxKk6h30RHCq3W2pdfMre10mdceScYU888RjaB/
         3lcBL6c3uo1bhXUuU2JeJXLdIp31UwXABZAXzOPJ3GlvA3GIHb6QEgt45QbmRzDp4/Nw
         QkEY8W26vFKrP+QM9gYlwnaQaRa6jCErYkHoRATMUj3TKA8ZBu07uC984uQdGvLsNrU/
         3MEQ==
X-Gm-Message-State: APjAAAUO3cu52NWu61uvRiUmnt3Br+XbzNpuY8cRAwN2sU7kHFxJrYFK
        5tNSi2LpVVmMH7ZnA6qI43F/tA==
X-Google-Smtp-Source: APXvYqzyT+LlrXJABBe8zZizq0/fO5fzzGnRLyqd7XLv6psgjGcvazOPITeCmnZQiQ/QgOw7b3YOLQ==
X-Received: by 2002:ac2:5473:: with SMTP id e19mr3155384lfn.108.1575488178400;
        Wed, 04 Dec 2019 11:36:18 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 140sm1872100lfk.78.2019.12.04.11.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:36:17 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:35:44 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/tls: Fix return values for setsockopt
Message-ID: <20191204113544.2d537bf7@cakuba.netronome.com>
In-Reply-To: <CA+FuTSdcDW1oJU=BK-rifxm1n4kh0tkj0qQQfOGSoUOkkBKrFg@mail.gmail.com>
References: <20191203224458.24338-1-vvidic@valentin-vidic.from.hr>
        <20191203145535.5a416ef3@cakuba.netronome.com>
        <CA+FuTSdcDW1oJU=BK-rifxm1n4kh0tkj0qQQfOGSoUOkkBKrFg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(there is a v2, in case you missed)

On Wed, 4 Dec 2019 14:22:55 -0500, Willem de Bruijn wrote:
> On Tue, Dec 3, 2019 at 6:08 PM Jakub Kicinski wrote:
> > On Tue,  3 Dec 2019 23:44:58 +0100, Valentin Vidic wrote:  
> > > ENOTSUPP is not available in userspace:
> > >
> > >   setsockopt failed, 524, Unknown error 524
> > >
> > > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>  
> >
> > I'm not 100% clear on whether we can change the return codes after they
> > had been exposed to user space for numerous releases..  
> 
> This has also come up in the context of SO_ZEROCOPY in the past. In my
> opinion the answer is no. A quick grep | wc -l in net/ shows 99
> matches for this error code. Only a fraction of those probably make it
> to userspace, but definitely more than this single case.
> 
> If anything, it may be time to define it in uapi?

No opinion but FWIW I'm toying with some CI for netdev, I've added a
check for use of ENOTSUPP, apparently checkpatch already sniffs out
uses of ENOSYS, so seems appropriate to add this one.

> > But if we can - please fix the tools/testing/selftests/net/tls.c test
> > as well, because it expects ENOTSUPP.  
> 
> Even if changing the error code, EOPNOTSUPP is arguably a better
> replacement. The request itself is valid. Also considering forward
> compatibility.

For the case TLS version case?
