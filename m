Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2FD665FC9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbjAKPxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbjAKPx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:53:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D48265FC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673452355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ryrrVULoscZ1riSGOM9SabdXBEw/UV56TVFRHhdk8Hk=;
        b=Mg7V5IDeq1Iy9l42HeBRvKHdxhZ6GPpL6T3ZwOomFgWFTNZO0/fDwb0QLdbguleunoiq9R
        JjDGlLuqI3T05p/PZk4LvDmiFHGvAK/2h0dm0YaYsE2ojXFHdi9rItVp09ac1LPg6cEWcM
        Z+ElWaXniZAzIOZWwIR5nBA2FNS9YPU=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-66-G3162ZKNMna3yrkB1NRdVA-1; Wed, 11 Jan 2023 10:52:34 -0500
X-MC-Unique: G3162ZKNMna3yrkB1NRdVA-1
Received: by mail-yb1-f198.google.com with SMTP id v9-20020a259d89000000b007b515f139e0so16621910ybp.17
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:52:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ryrrVULoscZ1riSGOM9SabdXBEw/UV56TVFRHhdk8Hk=;
        b=cAv4+h55B1YuHURGEtkSL8HymPG4fKs4RQSEnoZyxRYvwzD2L8iPJ6JJ0iPZx41XH+
         QQcIWJ2en/7iX8S0tSIcXiTFUn2aM5AcsMskc0oxFFDmHPw/cDMbznMNiAS89Ivo4Cft
         TfEoXwVgSIkN71S7yVc8pcwQ1tjifehqjQSEcQ8/BeDOtSsMBnMR3BHZRS/+AR4jY8f1
         pnWxVq2j+gT7lBvODXuDK5gNWOI/9Imsc30t7CsT5WnsDIJu9dcFQo+V38q2Rub0WSji
         7fDcYi8jOIML6/L5G7vsdkfMwxG3QIkCYzPhK1aCp5NvrdYWBlzL2+l87LNxHhOsZlLy
         uQKg==
X-Gm-Message-State: AFqh2kpanOnHmeKKgFmbgdjzvzphpdPImjlhoQsjVctmJgQqU2q6Rl3m
        mjJ95BGE12LHLrnikHhr9qkyKG8WwuE030vFyk7GfqH1ZAoJvnFc+ADFZFpD+J/1Bzozb58MZDG
        f4T+gkpzdFu94cAR7A/UkDEByYohE4+JS
X-Received: by 2002:a05:690c:fd5:b0:4a4:7135:9214 with SMTP id dg21-20020a05690c0fd500b004a471359214mr6355350ywb.378.1673452352787;
        Wed, 11 Jan 2023 07:52:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtStWXR+38RfXxzFTVMcf7hzA0i9hXKSpLyfi0CZB2+pYusTRUJDWvXhu+YWgsAtexBs1T/Ku+QZ43JZuHtbu8=
X-Received: by 2002:a05:690c:fd5:b0:4a4:7135:9214 with SMTP id
 dg21-20020a05690c0fd500b004a471359214mr6355349ywb.378.1673452352610; Wed, 11
 Jan 2023 07:52:32 -0800 (PST)
MIME-Version: 1.0
From:   Paul Holzinger <pholzing@redhat.com>
Date:   Wed, 11 Jan 2023 16:52:21 +0100
Message-ID: <CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com>
Subject: [Regression] 6.0.16-6.0.18 kernel no longer return EADDRINUSE from bind
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Since updating to 6.0.16 the bind() system call no longer fails with
EADDRINUSE when the address is already in use.
Instead bind() returns 1 in such a case, which is not a valid return
value for this system call.

It works with the 6.0.15 kernel and earlier, 6.1.4 and 6.2-rc3 also
seem to work.

Fedora bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2159066

To reproduce you can just run `ncat -l 5000` two times, the second one
should fail. However it just uses a random port instead.

As far as I can tell this problem is caused by
https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
which did not backport commit 7a7160edf1bf properly.
The line `int ret = -EADDRINUSE, port = snum, l3mdev;` is missing in
net/ipv4/inet_connection_sock.c.
This is the working 6.1 patch:
https://lore.kernel.org/all/20221228144339.969733443@linuxfoundation.org/

Best regards,
Paul

