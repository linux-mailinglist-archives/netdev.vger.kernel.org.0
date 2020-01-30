Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E637314E2C2
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgA3Sj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 13:39:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45778 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727945AbgA3Sj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 13:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580409595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w+IsZLk2QS34Oo7KTKmvIUSpjq3N05oYW9SD/Unr8w4=;
        b=RRiHr7bW11uB7kK8R2TAIxYNnlnxwUqmQ9qWSPX6r3sA5HEEhdPs+U1HEIrdrvy/QP4JMO
        ADkoLJaNOtcb7jqtcp/4nJBUvyNovOAu728VtWWbFJ7dWnBDsHsPnYbfnhnYQ3qdzLfr/B
        zrPJ8fw8par5GEVdDvHcjCH9ATNABeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-wb1VbVZAMMK-6Y2788fnkg-1; Thu, 30 Jan 2020 13:39:51 -0500
X-MC-Unique: wb1VbVZAMMK-6Y2788fnkg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8439B1800D41;
        Thu, 30 Jan 2020 18:39:49 +0000 (UTC)
Received: from ovpn-112-12.rdu2.redhat.com (ovpn-112-12.rdu2.redhat.com [10.10.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1658219E9C;
        Thu, 30 Jan 2020 18:39:47 +0000 (UTC)
Message-ID: <dec7cce5138d4cfeb5596d63048db7ec19a18c3c.camel@redhat.com>
Subject: Re: Redpine RS9116 M.2 module with NetworkManager
From:   Dan Williams <dcbw@redhat.com>
To:     Angus Ainslie <angus@akkea.ca>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 30 Jan 2020 12:39:52 -0600
In-Reply-To: <59789f30ee686338c7bcffe3c6cbc453@akkea.ca>
References: <59789f30ee686338c7bcffe3c6cbc453@akkea.ca>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-01-30 at 10:18 -0800, Angus Ainslie wrote:
> Hi,
> 
> I'm trying the get a Redpine RS9116 module working with
> networkmanager. 
> I've tried this on 5.3, 5.5 and next-20200128. I'm using the Redpine
> 1.5 
> "rs9116_wlan_bt_classic.rps" firmware.
> 
> If I configure the interface using iw, wpa_supplicant and dhclient
> all 
> works as expected.
> 
> If I try to configure the interface using nmtui most of the time no
> APs 
> show up to associate to. "iw dev wlan0 list" shows all of the APs in
> the 
> vicinity.
> 
> If I do manage to get an AP to show when I try to "Activate a 
> connection" I get the error below
> 
> Could not activate connection:
> Activation failed: No reason given
> 
> I suspect this is a driver bug rather than a NM bug as I saw similar 
> issues with an earlier Redpine proprietary driver that was fixed by 
> updating that driver. What rsi_dbg zone will help debug this ?

NM just uses wpa_supplicant underneath, so if you can get supplicant
debug logs showing the failure, that would help. But perhaps the driver
has a problem with scan MAC randomization that NM can be configured to
do by default; that's been an issue with proprietary and out-of-tree
drivers in the past. Just a thought.

https://blog.muench-johannes.de/networkmanager-disable-mac-randomization-314

Dan

