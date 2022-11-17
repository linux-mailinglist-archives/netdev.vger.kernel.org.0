Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F78E62E9A6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiKQXe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiKQXeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:34:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67319E7F
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668728005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VfjgXktDNIsriZUy3qQp2VW197YAsfQhb1luHaLnsYc=;
        b=CvJ6i3l+/MUj58X3U4mfwlzGpBn6A6wnR4cwEqe7fJxbpdc7DOBdi+ZWztCKU/XnMn6Aqi
        9fEvNdn0MKi1yzp8Xg6uzzqfJr7/svxdRJMrxUV7WyGMIUIBR+lLugrmNzcrvI+26SOLsO
        GdB8XT29DqZt9QvIADTBJfLk+oEtAN0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-1050pNlNMI66Z5noaLMCLA-1; Thu, 17 Nov 2022 18:33:23 -0500
X-MC-Unique: 1050pNlNMI66Z5noaLMCLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9769D3806703;
        Thu, 17 Nov 2022 23:33:23 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB462C158CF;
        Thu, 17 Nov 2022 23:33:22 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Heng Qi <henqqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Subject: [PATCH net-next 0/2] veth: a couple of fixes
Date:   Fri, 18 Nov 2022 00:33:09 +0100
Message-Id: <cover.1668727939.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes in the veth driver caused a few regressions
this series addresses a couple of them, causing oops.

Paolo Abeni (2):
  veth: fix uninitialized napi disable
  veth: fix double napi enable

 drivers/net/veth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.38.1

