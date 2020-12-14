Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8F2D9D47
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408289AbgLNRJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:09:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502175AbgLNRI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 12:08:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607965650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Azb2htRas8xw7ALEsczO2gUqGRQgmT58BISrepmg2Mo=;
        b=DGxTGHU8votTIwRrBtH+VxyBhPN15NfDRbeA1AGYhtUwcK4LZMU6jayae+1iblSG7BXbG+
        QwuRAAaJwGu1ngRl/mUHrYZyxgGPkfK+k+UfVTrBpV6AjTqUXhRr8yyAQKQc8J6JvQnAHY
        zbNRPHQf4tpipCO86wr9TF/vrOwc2q0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-0GL9LgufNwKqSC1Xar4ZXA-1; Mon, 14 Dec 2020 12:07:27 -0500
X-MC-Unique: 0GL9LgufNwKqSC1Xar4ZXA-1
Received: by mail-wr1-f70.google.com with SMTP id d2so6911272wrr.5
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:07:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Azb2htRas8xw7ALEsczO2gUqGRQgmT58BISrepmg2Mo=;
        b=jA3Ut2C+zIjZPHTT4Xh5Xuvfo46cd5jP+CtWrJb7e2W3g7qBs0SRFAkTBgkGcqBtSy
         mhUFsZf3CIensd/WinQYU6QoG1ETxrMQAymt2BQy6148gV+MxMrpRBIQ3I/W3mbt/umg
         MoJhPaZtIlXSQk3995wfh6LPY5KNyU9YTe41KeCM/Pvi7i7fqfh6T9I/cyUFsupWOGmf
         LmSQYYTU6Yi4YxFSmm1fmL/orUQPHrAoQhCuaBq8h8s1vAay7PSRDEa+X2bvqOn1VT6h
         CDRjs7Nc04NCOqwEQoRL7FUJugnt8RG3GS6mQ9+L10Vwixab/UGyZ4dTiiA/roLI9ZbY
         xqrQ==
X-Gm-Message-State: AOAM533/WsEUBsXSeoH43ytY5wGhdga9SY7FA+3TmphASM8nz2WoYPqq
        x0WFS8/IVAvE/n3zBIYepeut4ayQqXbwMAax70m4KEWkCLFn12hrVq2h2gkS5IypnRkhdaUQ7LE
        qclosHyiSpl3vbuik
X-Received: by 2002:a1c:7c19:: with SMTP id x25mr29307638wmc.94.1607965646720;
        Mon, 14 Dec 2020 09:07:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7I/rvdEHeRXqeMaWfQBBGfoNDRbexdnUYpm5DZwVRI2+hpzR31gY+6uQIurK6i2JelGwaVw==
X-Received: by 2002:a1c:7c19:: with SMTP id x25mr29307609wmc.94.1607965646430;
        Mon, 14 Dec 2020 09:07:26 -0800 (PST)
Received: from steredhat (host-79-13-204-15.retail.telecomitalia.it. [79.13.204.15])
        by smtp.gmail.com with ESMTPSA id m11sm16704991wmi.16.2020.12.14.09.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 09:07:25 -0800 (PST)
Date:   Mon, 14 Dec 2020 18:07:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v4 3/5] vsock_addr: Check for supported flag
 values
Message-ID: <20201214170722.hzv3lc3iqk2p6rsv@steredhat>
References: <20201214161122.37717-1-andraprs@amazon.com>
 <20201214161122.37717-4-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201214161122.37717-4-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 06:11:20PM +0200, Andra Paraschiv wrote:
>Check if the provided flags value from the vsock address data structure
>includes the supported flags in the corresponding kernel version.
>
>The first byte of the "svm_zero" field is used as "svm_flags", so add
>the flags check instead.
>
>Changelog
>
>v3 -> v4
>
>* New patch in v4.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> net/vmw_vsock/vsock_addr.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/vsock_addr.c b/net/vmw_vsock/vsock_addr.c
>index 909de26cb0e70..223b9660a759f 100644
>--- a/net/vmw_vsock/vsock_addr.c
>+++ b/net/vmw_vsock/vsock_addr.c
>@@ -22,13 +22,15 @@ EXPORT_SYMBOL_GPL(vsock_addr_init);
>
> int vsock_addr_validate(const struct sockaddr_vm *addr)
> {
>+	__u8 svm_valid_flags = VMADDR_FLAG_TO_HOST;
>+
> 	if (!addr)
> 		return -EFAULT;
>
> 	if (addr->svm_family != AF_VSOCK)
> 		return -EAFNOSUPPORT;
>
>-	if (addr->svm_zero[0] != 0)
>+	if (addr->svm_flags & ~svm_valid_flags)
> 		return -EINVAL;
>
> 	return 0;
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

