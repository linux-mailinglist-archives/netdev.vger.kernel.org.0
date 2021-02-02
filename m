Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F304E30C3EE
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbhBBPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:35:26 -0500
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:22447 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbhBBPcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:32:46 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 10:32:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1612279966;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Ff0ODS3QBH1c9Z92pXmSGi2ISsoawY8OQVKLEOisOdI=;
  b=AlIWjYGiPo/Ba/sCiDaBeEurUVa29SgQFaEW5LDX6VQ7gkpLjKaPA/bA
   +MbDNhxXarP6uwEkeAck9sLAdhyuME8sE8uEEk0sQhXY71S3JgcspXDmI
   nvnBvhiMv3KoXU+odPjFoYw+batTOQnR7dcjC4Gf0XJWwDj4KTVy5Xme6
   U=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: 3AsF6jWq0gMIIKS1cdsb7GcLWobd5iEgdpRkCEPFI/T0bE6dBMaAKwJkpHPCPlXUy/8L47yPoS
 Ir3YOcLKU9ZljJFLU9/qevKmpLia6n5Sxb07p+ObyagjNGHumtyIZpHjAB0tR0r07ONc+/1ISv
 Y/yNHDRdozIUNz423FFx0RtDiWaEYE7Z+3VKZeSybNrBBmiYxvZ+3HsAZ4L4yRPYIRHnnTsW/6
 cTW7rS0ki5wDxJAo3EjtAadZ0L0c7NDOMnO0zRsJkKSOCADBCbV1BvOZQjU+vQUfMDL/QbE5Y6
 NdU=
X-SBRS: 5.1
X-MesageID: 36576887
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,395,1602561600"; 
   d="scan'208";a="36576887"
Subject: Re: [PATCH] xen/netback: avoid race in
 xenvif_rx_ring_slots_available()
To:     Juergen Gross <jgross@suse.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <stable@vger.kernel.org>
References: <20210202070938.7863-1-jgross@suse.com>
From:   Igor Druzhinin <igor.druzhinin@citrix.com>
Message-ID: <c17d4e45-cad1-510d-0e7b-9d95af89ff01@citrix.com>
Date:   Tue, 2 Feb 2021 15:26:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202070938.7863-1-jgross@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2021 07:09, Juergen Gross wrote:
> Since commit 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> xenvif_rx_ring_slots_available() is no longer called only from the rx
> queue kernel thread, so it needs to access the rx queue with the
> associated queue held.
> 
> Reported-by: Igor Druzhinin <igor.druzhinin@citrix.com>
> Fixes: 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>

Appreciate a quick fix! Is this the only place that sort of race could
happen now?

Igor
