Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87003FACED
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 17:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhH2Pyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 11:54:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235764AbhH2Pyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 11:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630252431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/jaF7jZC8q/DpP5yyhldi4uUkfv/Q/aJYUDR7M+5EQ4=;
        b=KQ5pApz2n835EnrAHbjDNq7xPjwus8ZD101vYJNGvXRMLvulWiaf8mVeuPZMHq6+AQO5ch
        c9xoLFKy3bVcxgSodg644ttoFoCrDgdoJ1fNwMfRW9zJeJEJAiVxPv4Z6lcIcyxbfl1iwH
        mSghjA0MFslE7+6mWMMF7+gOQopzx6A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-Lgxn7rEKMOGTEXmMi3WgLg-1; Sun, 29 Aug 2021 11:53:50 -0400
X-MC-Unique: Lgxn7rEKMOGTEXmMi3WgLg-1
Received: by mail-ed1-f70.google.com with SMTP id g4-20020a056402180400b003c2e8da869bso5355586edy.13
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 08:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=/jaF7jZC8q/DpP5yyhldi4uUkfv/Q/aJYUDR7M+5EQ4=;
        b=fZqPYnfIDL7ES4QmOmDMGLmndwZYRpCytTUpHEVQpPpjVzgjGzKZMeRGUyjsW/Mh/Y
         vrH8r0arG+zkTpl8M6UrZ3DF7Vx3V+JFEay9sv/VgLrEjAyYJ26BEYVKDx6NTO/A33m4
         9dZKUFJWpTEbA4JnHvpNBst9UQk+EFuxJPvVKkauDUu9coeYRqIzg848YICKsn7A/Oee
         wZfxEdfb+nKeh1JOQIJGaxhtpvXyNkpQc4ccqjPE3ImzxkzUQBcKSBpDPCW7NaIFNPrz
         JIXa1n6dK1bvMCK2OnSE00upGIskLZF3ExUbJ6XoslaFMjRORWB7mEF4DEGDWcfyONFD
         shVg==
X-Gm-Message-State: AOAM533aiG9sPzypELieZFHqbBzt6VT/0Dz/KLnw14cnNagM7jfS7AVJ
        XsmuMxyY2UttO6etXIE3XhApmSW+EwpTtYg31tVkuivauwnXv0uT6zMolGCVvOklNlVcH+6HV0b
        ibCYhN/f6k22R3shv
X-Received: by 2002:a17:907:212e:: with SMTP id qo14mr19145561ejb.501.1630252427533;
        Sun, 29 Aug 2021 08:53:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzobXz3Ef1GROPF3oUnWQrRnebrjXnwnoH6TBBe6U6SyFAGgXQrD00rBwtykUugZTIDZOQ8Lw==
X-Received: by 2002:a17:907:212e:: with SMTP id qo14mr19145554ejb.501.1630252427363;
        Sun, 29 Aug 2021 08:53:47 -0700 (PDT)
Received: from redhat.com ([2.55.137.4])
        by smtp.gmail.com with ESMTPSA id s3sm5652608ejm.49.2021.08.29.08.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 08:53:46 -0700 (PDT)
Date:   Sun, 29 Aug 2021 11:53:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dan.carpenter@oracle.com,
        david@redhat.com, jasowang@redhat.com, mst@redhat.com,
        torvalds@linux-foundation.org
Subject: [GIT PULL] virtio: a last minute fix
Message-ID: <20210829115343-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Donnu if it's too late - was on vacation and this only arrived
Wednesday. Seems to be necessary to avoid introducing a regression
in virtio-mem.

The following changes since commit e22ce8eb631bdc47a4a4ea7ecf4e4ba499db4f93:

  Linux 5.14-rc7 (2021-08-22 14:24:56 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 816ff7595135948efde558221c8551bdd1869243:

  virtio-mem: fix sleeping in RCU read side section in virtio_mem_online_page_cb() (2021-08-29 11:50:04 -0400)

----------------------------------------------------------------
virtio: a last minute fix

Fix a regression in virtio-mem.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
David Hildenbrand (1):
      virtio-mem: fix sleeping in RCU read side section in virtio_mem_online_page_cb()

 drivers/virtio/virtio_mem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

