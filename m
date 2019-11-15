Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B50DFD7E2
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 09:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKOI0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 03:26:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725829AbfKOI0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 03:26:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573806381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xt7ctRiywIG1tpU0cT26zCBUdn9q3E2Aseumqp8v+zU=;
        b=e9lHlgRWsugelA1gTvRfjNDi97koBCuKCS7h6udcuchMc2hT3n4TRgmeXI6p2JKgWUp1Y1
        k2lPeQzuOUfYTE9eFF+d0iflnZOljJKjQ6ninjUugw8o4Bi7lyGUnOb6Rzj4Ecme8uRCBI
        Gp4KmKKkqQ1sBV7wCuy4nNye4hvAxaQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-tVgLmihqOl6qPovIhZ0Tsw-1; Fri, 15 Nov 2019 03:26:20 -0500
Received: by mail-wr1-f71.google.com with SMTP id f8so7263042wrq.6
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 00:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RoXy81G7M/BfnHRZ4y2U2/JU3z4ekC5J7eZ1fYMw4CI=;
        b=CYsHgjK3CuiRWY3YWMNAti5+XpB8nT/M7hQKCPTLhAa1c2Un8fJNjqSzAXUQg09NES
         u4w46WIyAtlWv9GgYIqR456D9RFFIT8miPg/W6/tV0MHTKpUEzoW/jn/3j1QvvD0Rqiw
         ML62z4bIJFt1wLD46GAEsjVll3M8g6r5ft223uAPtNBJiT7B8TC5aF035HMgyIoypYuS
         yKoRuSlLgWbegXRQCengjcE/AYpyUJ7yxT0GGZQv5Sqgk0Erhuk6rQKA1mJl7aD9cP49
         HtwegHzUhgJefNzkAocoxBYP+k6GHCokkA65o1gWvayO+uT3GxzT6rORN+V6PQX8CZq+
         Kiug==
X-Gm-Message-State: APjAAAURDnmPQpH//DW0AoEERAF6Od7KEwKbmZAjAboO6EkmQmnzVczp
        zWn5NNnONBVBKnjQmvFJzsUAacv5oAlDwLfWvrPuELbtr2iPHHaHfd9QwjzIvvsfNm2H63LjwVk
        PvAb3I7reG+9dr8W8
X-Received: by 2002:adf:f78c:: with SMTP id q12mr13056407wrp.71.1573806379269;
        Fri, 15 Nov 2019 00:26:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvFtcZcCmdybEhREmfVJhjMJWYu5vgKjT2yNfXmAdZcdboUyo4lpokec2THBO5n/9IFhwgFw==
X-Received: by 2002:adf:f78c:: with SMTP id q12mr13056369wrp.71.1573806378928;
        Fri, 15 Nov 2019 00:26:18 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id 19sm12549850wrc.47.2019.11.15.00.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 00:26:18 -0800 (PST)
Date:   Fri, 15 Nov 2019 09:26:15 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, arnd@arndb.de,
        jhansen@vmware.com, jasowang@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, haiyangz@microsoft.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        sashal@kernel.org, kys@microsoft.com, decui@microsoft.com,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/15] vsock: add multi-transports support
Message-ID: <20191115082615.uouzvisaz27xny4e@steredhat>
References: <20191114095750.59106-1-sgarzare@redhat.com>
 <20191114.181251.451070581625618487.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20191114.181251.451070581625618487.davem@davemloft.net>
X-MC-Unique: tVgLmihqOl6qPovIhZ0Tsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 06:12:51PM -0800, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Thu, 14 Nov 2019 10:57:35 +0100
>=20
> > Most of the patches are reviewed by Dexuan, Stefan, and Jorgen.
> > The following patches need reviews:
> > - [11/15] vsock: add multi-transports support
> > - [12/15] vsock/vmci: register vmci_transport only when VMCI guest/host
> >           are active
> > - [15/15] vhost/vsock: refuse CID assigned to the guest->host transport
> >=20
> > RFC: https://patchwork.ozlabs.org/cover/1168442/
> > v1: https://patchwork.ozlabs.org/cover/1181986/
>=20
> I'm applying this as-is, if there is feedback changes required on 11,
> 12, and 15 please deal with this using follow-up patches.

Thank you very much,
Stefano

