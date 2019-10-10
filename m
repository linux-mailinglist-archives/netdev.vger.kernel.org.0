Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6D1D32AF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 22:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfJJUnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 16:43:46 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40108 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJJUnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 16:43:45 -0400
Received: by mail-qt1-f194.google.com with SMTP id m61so10692525qte.7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 13:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Qnm/xOF1axoKltic9wOhlDvxehnhsqO9AK9SKyqjBMQ=;
        b=GtW/+rLPRQ8fSLH9IHSYXTdJDHRrh5NBGuGJCy8vNyG0Mm89yc5AVLhmyStQ64cL/a
         HnbJh2FlMxKowpSAcTU1qA2cV8F4fax78oYTI9G7GzFHIFJIjjmCiyF45F069J8xtBsq
         FTzcvoIoyKK8FrDmi1rF+IXznTcxHJKy2/Q9TJNTuHivI/SDXajuoRwTtaJzdIzFvaG4
         fgKB/n9Uxu7Jn2HtGg6CpYx+2exCRXupYtm5QePgFMVgAPnmShQIy7ow0axRMe2CloPK
         OYUKC8qU82as3jECbuuKO8JzSDFSZ0wQalyI3uEmGxxUx4WX2LT6IbP5c4KM4r+7IqtP
         xrlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Qnm/xOF1axoKltic9wOhlDvxehnhsqO9AK9SKyqjBMQ=;
        b=YZ+MgXm+cJrw6niJH1smI2ZnDgn92DJIN7bYcFqcr/T2VcvwwxnOCwqQEktAOq5hcy
         O9B0ldy8kbbbHX52h/ORzbonkqc4qrhrjmmaKLxQUP5A6Bo0YVOmoO7q5Ecr+92dsQu0
         elnudTTFirEpZ5FyQIa+OMSZlKoE1OjGbRRzf1MUSntWv4an9t2OB541H6YSXcD/iuVO
         jZemf65+R+F7RJwyYSe890EI2w3UctoLpacKqaINxmrENaQ/cw1yhRfTxPGKOmTtDgxq
         yeeHicqGi6J8CshXiDRDnz2tN6Vhvwwrlfrqwg+8SA0yen3Q4VrcGoWqbPm5sG+BuwIN
         5gAQ==
X-Gm-Message-State: APjAAAVSrpRYWIFDaTZqyP03K/a7J4igz5vrRqqGsTlJO9enddOaTh+e
        5iwCY5FtnhicQk9zESK4Sha3SA==
X-Google-Smtp-Source: APXvYqyZrdHLApmMF/CBgXhn6HNdqvblVZ4R6rAbfwsXZm+T2cz+AV0njLlD4/0JZCQok6LgXNieSg==
X-Received: by 2002:ac8:4311:: with SMTP id z17mr12075001qtm.213.1570740224747;
        Thu, 10 Oct 2019 13:43:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p22sm3133129qkk.92.2019.10.10.13.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 13:43:44 -0700 (PDT)
Date:   Thu, 10 Oct 2019 13:43:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Michael Kelley <mikelley@microsoft.com>, davem@davemloft.net,
        Himadri Pandya <himadrispandya@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "himadri18.07" <himadri18.07@gmail.com>
Subject: Re: [PATCH] hv_sock: use HV_HYP_PAGE_SIZE instead of PAGE_SIZE_4K
Message-ID: <20191010134326.608d363d@cakuba.netronome.com>
In-Reply-To: <20191010170606.GA1396@sasha-vm>
References: <20190725051125.10605-1-himadri18.07@gmail.com>
        <MWHPR21MB078479F82BBA6D3E6527ECECD7DF0@MWHPR21MB0784.namprd21.prod.outlook.com>
        <20191004154817.GL17454@sasha-vm>
        <20191010170606.GA1396@sasha-vm>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 13:06:06 -0400, Sasha Levin wrote:
> On Fri, Oct 04, 2019 at 11:48:17AM -0400, Sasha Levin wrote:
> >On Wed, Jul 31, 2019 at 01:02:03AM +0000, Michael Kelley wrote:  
> >>From: Himadri Pandya <himadrispandya@gmail.com> Sent: Wednesday, July 24, 2019 10:11 PM  
> >>>
> >>>Older windows hosts require the hv_sock ring buffer to be defined
> >>>using 4K pages. This was achieved by using the symbol PAGE_SIZE_4K
> >>>defined specifically for this purpose. But now we have a new symbol
> >>>HV_HYP_PAGE_SIZE defined in hyperv-tlfs which can be used for this.
> >>>
> >>>This patch removes the definition of symbol PAGE_SIZE_4K and replaces
> >>>its usage with the symbol HV_HYP_PAGE_SIZE. This patch also aligns
> >>>sndbuf and rcvbuf to hyper-v specific page size using HV_HYP_PAGE_SIZE
> >>>instead of the guest page size(PAGE_SIZE) as hyper-v expects the page
> >>>size to be 4K and it might not be the case on ARM64 architecture.
> >>>
> >>>Signed-off-by: Himadri Pandya <himadri18.07@gmail.com>
> >>>---
> >>> net/vmw_vsock/hyperv_transport.c | 21 +++++++++++----------
> >>> 1 file changed, 11 insertions(+), 10 deletions(-)
> >>>
> >>>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> >>>index f2084e3f7aa4..ecb5d72d8010 100644
> >>>--- a/net/vmw_vsock/hyperv_transport.c
> >>>+++ b/net/vmw_vsock/hyperv_transport.c
> >>>@@ -13,15 +13,16 @@
> >>> #include <linux/hyperv.h>
> >>> #include <net/sock.h>
> >>> #include <net/af_vsock.h>
> >>>+#include <asm/hyperv-tlfs.h>
> >>>  
> >>
> >>Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
> >>
> >>This patch depends on a prerequisite patch in
> >>
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/hyperv
> >>
> >>that defines HV_HYP_PAGE_SIZE.  
> >
> >David, the above prerequisite patch is now upstream, so this patch
> >should be good to go. Would you take it through the net tree or should I
> >do it via the hyperv tree?  
> 
> Ping?

Is this a fix? It's slightly unclear from the description of the patch.
I think the best course of action would be reposting it again, with
either [PATCH net] in the subject and a Fixes tag if it's a fix, or
[PATCH net-next] otherwise.
