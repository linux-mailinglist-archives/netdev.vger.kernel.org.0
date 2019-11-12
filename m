Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C07F8829
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLFmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:42:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53923 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726385AbfKLFmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:42:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573537359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1TMP4uqYhBdYz1qbxiA0vr3ZcDt18atvBmRb2zJk6A=;
        b=OT/J/0jV8cWHKX/ZmtO0KJHsPjGbQ8LSRr9KyMpOC6rRIY346w8bsLqxB1/9wuFqqeNRVy
        BOUGvM4Y6tZ6WOCN1i4XNMyJuyyXn9ux7YbbMuI5DOwDNYDwbx9OrZ45bwLKjzGOg512li
        pTdy3ycl4rCfFmLvB+VK4l58G3cOBHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-7gqBuUzaNcS3P6Fjl93nmw-1; Tue, 12 Nov 2019 00:42:36 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F150800C61;
        Tue, 12 Nov 2019 05:42:34 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8699261073;
        Tue, 12 Nov 2019 05:42:31 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:42:30 -0800 (PST)
Message-Id: <20191111.214230.2088708531448206161.davem@redhat.com>
To:     stephan@gerhold.net
Cc:     clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        sedat.dilek@credativ.de
Subject: Re: [PATCH] NFC: nxp-nci: Fix NULL pointer dereference after I2C
 communication error
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191110161915.11059-1-stephan@gerhold.net>
References: <20191110161915.11059-1-stephan@gerhold.net>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 7gqBuUzaNcS3P6Fjl93nmw-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>
Date: Sun, 10 Nov 2019 17:19:15 +0100

> I2C communication errors (-EREMOTEIO) during the IRQ handler of nxp-nci
> result in a NULL pointer dereference at the moment:
 ...
> Change the code to call only nxp_nci_fw_recv_frame() in case of an error.
> Make sure to log it so it is obvious that a communication error occurred.
> The error above then becomes:
>=20
>     nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121
>     nci: __nci_request: wait_for_completion_interruptible_timeout failed =
0
>     nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121
>=20
> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver=
")
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>

Applied and queued up for -stable.

