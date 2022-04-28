Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957575134F2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbiD1N0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiD1N0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:26:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 155DAAC913
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651152167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8PQduM8Cm6+v2eU6zkUJYKtrg0KGSwBOax3SMcC5NWw=;
        b=W6WWe3E6U8AXsgmry9eTJVCRhKqg2UXp835zoD2Du3l9nN2UoP/+OADPC8hNv+gH+Gwgvd
        ROcH+tYlTpIVQtL6B4FXF56/v5/euKG6hufu+/uClXHgheDLAzV3EJn+4+pn0YwP/OmywQ
        L641Gv985pk0XxHYfXx521d1AHc6Kw0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-rJFme31COCKaB72Lew8jMA-1; Thu, 28 Apr 2022 09:22:46 -0400
X-MC-Unique: rJFme31COCKaB72Lew8jMA-1
Received: by mail-wr1-f72.google.com with SMTP id p18-20020adf9592000000b00207bc12decbso1922029wrp.21
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8PQduM8Cm6+v2eU6zkUJYKtrg0KGSwBOax3SMcC5NWw=;
        b=ox0gE+L39XtonqY/btPT23RQE8e7q4ppiZIEQIWbPUWdBzRIQjgKH3SRKbh8tmPV8z
         qv48fTnIETwI7AdLaCMT7J3evbh9HcJgfcMvh3iWgjF5crfAxNt07OyR8M7yGKEK0RCW
         oWCRCJ7fd/l9aB0ZwkKijx3ZfqErq/WSy0uc2NWbTy1o9H8KdmyygZSH5TOJdwMvlnIW
         RcqEZdlGEoTBafqYzXExhofarVqE6hNjgHi/c0BQ9cpY2ciz3uf3cYDlsw83GtTV7Olk
         GCVjBjz04UX8FgVnbsT+U2jmqDZ5zWoApRLbeiEhyYhvp5fmGALwzRqXerLjrJ9qoy6m
         VYRg==
X-Gm-Message-State: AOAM5315+PoZzMnOhQ3cp+v83q4rgUX00K9TBluKg3VfwflmFF/2Toco
        u9cjCpXFY0dAK6kEj4Y02mzB9foKBSf00rc/mxMRE5of7NwPuL4hsp23vg3/hiW7uUcTeuSUR8D
        vsK0skCT6U+pcNjPuc/LueZTPWbWiekucP9qXORUrybuuYSMN8RxEc+Wox1q8gmm0Y09L
X-Received: by 2002:a1c:2185:0:b0:38f:f4ed:f964 with SMTP id h127-20020a1c2185000000b0038ff4edf964mr31065717wmh.115.1651152164665;
        Thu, 28 Apr 2022 06:22:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyh0SQ9LojN8eIegKUo+h+ntmqGzG2tJdfRq4/rRAMPBONENZjji/VGZxEgoBORxb2iYpBK1g==
X-Received: by 2002:a1c:2185:0:b0:38f:f4ed:f964 with SMTP id h127-20020a1c2185000000b0038ff4edf964mr31065683wmh.115.1651152164320;
        Thu, 28 Apr 2022 06:22:44 -0700 (PDT)
Received: from step1.redhat.com (host-87-11-6-234.retail.telecomitalia.it. [87.11.6.234])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c4e8700b00393f1393abfsm4680978wmq.41.2022.04.28.06.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:22:43 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vilas R K <vilas.r.k@intel.com>,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH net-next 0/2] vsock/virtio: add support for device suspend/resume
Date:   Thu, 28 Apr 2022 15:22:39 +0200
Message-Id: <20220428132241.152679-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vilas reported that virtio-vsock no longer worked properly after
suspend/resume (echo mem >/sys/power/state).
It was impossible to connect to the host and vice versa.

Indeed, the support has never been implemented.

This series implement .freeze and .restore callbacks of struct virtio_driver
to support device suspend/resume.

The first patch factors our the code to initialize and delete VQs.
The second patch uses that code to support device suspend/resume.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Stefano Garzarella (2):
  vsock/virtio: factor our the code to initialize and delete VQs
  vsock/virtio: add support for device suspend/resume

 net/vmw_vsock/virtio_transport.c | 197 ++++++++++++++++++++-----------
 1 file changed, 131 insertions(+), 66 deletions(-)

-- 
2.35.1

