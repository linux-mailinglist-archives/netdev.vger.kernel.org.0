Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156942DD2B3
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgLQOOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbgLQOOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 09:14:01 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0F3C0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 06:13:21 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id y15so20115578qtv.5
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 06:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1W7HWkK0e8ZwL+3YOI6wvH3/gtZCie/A8YszznlKKqQ=;
        b=ThogHRWEKye4fpcRYf7dv7q3xZ6EAM94Zcc5QuGiHJWgqemM+Y7xURVQBt1jHHkbMb
         HIWqg1pUj46gRuRmH9XLS1B30igGzL2MhLthey+MDDoGTMpFyhgnO41qegGFd96snQxq
         x+QuUmhLytuqfXQj5EZdQ405g5JjstytIRa1hFLvPfhNJMdbmFIvrMtL/MR/KZtakBrP
         5dDeBSKN/PzW1zP40CHlSjZ3d9eMDimVGJeuIRUjOxX6VJLk4IZGcpysSrvLh/RsMGBO
         OHA+30jGTYWV/z+1RKDXXXgY2vp6ZNPd3hXm2QrnicOC4ib25SOI3PehaIUipEIHTqif
         0jZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1W7HWkK0e8ZwL+3YOI6wvH3/gtZCie/A8YszznlKKqQ=;
        b=gJbc9VEWribQ+HpRN+H8aqY63OG6se5+PeeQPhsMzkK8vmM30dEhdQ7MViJbZH9UKH
         fz0OJMX3YfWZ2ixD1Oz25YrQgUYWYbZj+fBsoOzI8k5rPf+0w6WZ6wlPdZ+/wZ1PBxPo
         3za8Qvkce69sPyetZAC6bsQuQ4AT+5XAuTbYpLOKZM6bGMPw4g4BIpU79VctsegZdyhs
         +GRt2AM7uNAuT1IbB5Gip3v8AkMcqtPaFv/f1Jm5pmCVQxhYv9Vr1GQuA9iwW95SBQSf
         ChsPHr0VORzTaQlVcwSJevnG3lzom0r2TeSs02sAzjAjQTeeARMn0gjNYpff+7T/K4az
         H/CQ==
X-Gm-Message-State: AOAM533LSzoYJByly09xnNWdpPQiH6qzF4DgTzxej4CrJPaILN2xwDjM
        nPSXV3zaCH8g8E5XOTVoKOJg19uyQuI3jvAYWZsV9A==
X-Google-Smtp-Source: ABdhPJzlz11Oo4fcMwwilYwBQt9h0JX7y3PNSUMcfeLQ6XrWem8z95fVo4AFrEF6LRYZ5wDKA+5iVyasLJTDkCP1uus=
X-Received: by 2002:ac8:6f4f:: with SMTP id n15mr43951803qtv.216.1608214400055;
 Thu, 17 Dec 2020 06:13:20 -0800 (PST)
MIME-Version: 1.0
References: <1608198007-10143-1-git-send-email-stefanc@marvell.com>
 <1608198007-10143-2-git-send-email-stefanc@marvell.com> <CAPv3WKcwT9F3w=Ua-ktE=eorp0a-HPvoF2U-CwsHVtFw6GKOzQ@mail.gmail.com>
 <20201217140927.GA2981994@lunn.ch>
In-Reply-To: <20201217140927.GA2981994@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 17 Dec 2020 15:13:08 +0100
Message-ID: <CAPv3WKdFWgjun8uZ2=g5Mhg0tY1QXoDAqKApL5O5WALsfv3Pcw@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net: mvpp2: disable force link UP during port
 init procedure
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 17 gru 2020 o 15:09 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > Do you think it's a fix that should be backported to stable branches?
> > If yes, please add 'Fixes: <commit ID> ("commit title")' and it may be
> > good to add 'Cc: stable@vger.kernel.org' adjacent to the Signed-off-by
> > tag.
>
> netdev patches should not be Cc: stable@vger.kernel.org. David and
> Jakub handle stable patches directly.
>

Thanks for clarification.

Marcin
