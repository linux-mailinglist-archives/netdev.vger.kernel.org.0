Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B476F2EAA92
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbhAEMXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:23:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728359AbhAEMXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:23:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609849312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=U39k5ipMHANWOJWrOXSYV59iZX09Ei6dL9ebZb8Ogeg=;
        b=h0lLt4/Tksg6sI88+7rwPMzNQCYPJcQNpokcL+CsnYogR/Knm6EeB1j/rMH0Xv7n/UlUQX
        LlkU39FznW/EwWqgsRi0jFX8bk+O+VXF0sqjFU3xTMPuUBN4p4SuN8NmJrzE+D7PpMZsIo
        x0Aay4OYfwQIX3GQJGqZpcZNh9OuCUg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-Bc4e3jsPPCyO-I4YyOaa2w-1; Tue, 05 Jan 2021 07:21:50 -0500
X-MC-Unique: Bc4e3jsPPCyO-I4YyOaa2w-1
Received: by mail-wm1-f69.google.com with SMTP id w204so1185183wmb.1
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:21:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=U39k5ipMHANWOJWrOXSYV59iZX09Ei6dL9ebZb8Ogeg=;
        b=mNtA8mvJFQ56A16cg53qJrNfr/+hQOMPltM5JIfJWqlnelsiu4rIVy6bUd6s/MRuIl
         vNlQ/MlJyHxP0493/lCUjROQ5bs/Xx/RahSoudl/v8cjpXvrMqET5Gb8fc7FcIgGkPQM
         qIqkNnplqm8Jc21BiPgy3aDxRFiErVwB+0NVdT8aMkF8sGZzOeQO1NLN8vdFG/YOlmfW
         dFlDNwl/5XmQRWRS+m2oWRW/dSvTXsF7at4PuHis2asnvoT1hsZBKzMC7SpR4sP8+5h2
         zIlN3Qbo/87N2EWicoucceI2fWHnTHYAsARZ2X1xZbR/vfnmzCBuUWUI07+F7tj4xSPK
         Fqdw==
X-Gm-Message-State: AOAM532pdzzpiOqfr5uYedHcxxffGZuJLBWaE7OJErWRoAgxauq5uw7M
        eV3ses14nhrq/bKonkPIzxn108i5lRJYX9+iYVDbHJVInNcM8ya73lJbCBn6ysRYD25n1gPwYqs
        pLwym8PCSEKJw+BsK
X-Received: by 2002:adf:bb0e:: with SMTP id r14mr85949739wrg.159.1609849309287;
        Tue, 05 Jan 2021 04:21:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRxC04NYGeb6WaL98Uxtwkp2M43zTcBL2qoRpI0IP4stOIB1HKct8R0XtAhgJEy1jrpROFhg==
X-Received: by 2002:adf:bb0e:: with SMTP id r14mr85949711wrg.159.1609849308953;
        Tue, 05 Jan 2021 04:21:48 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id y7sm3716921wmb.37.2021.01.05.04.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 04:21:48 -0800 (PST)
Date:   Tue, 5 Jan 2021 07:21:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com
Subject: [GIT PULL] vhost: bugfix
Message-ID: <20210105072145-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 418eddef050d5f6393c303a94e3173847ab85466:

  vdpa: Use simpler version of ida allocation (2020-12-18 16:14:31 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to e13a6915a03ffc3ce332d28c141a335e25187fa3:

  vhost/vsock: add IOTLB API support (2020-12-27 05:49:01 -0500)

----------------------------------------------------------------
vhost: bugfix

This fixes configs with vhost vsock behind a viommu.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Stefano Garzarella (1):
      vhost/vsock: add IOTLB API support

 drivers/vhost/vsock.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 3 deletions(-)

