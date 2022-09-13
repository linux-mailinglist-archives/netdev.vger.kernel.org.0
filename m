Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CFB5B76BE
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 18:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiIMQuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 12:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiIMQue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 12:50:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20472861D2
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 08:44:18 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o5so5698807wms.1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 08:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=zof+mp13EAfmnpFsK9Eco3V3Cmb3NggImWCyhng1tgI=;
        b=q6VuR/8N1VM2WwELruNYSzHgejoUeKM2BlHnMA88QNt8ijPt50x2suDtQRHGgSvzyF
         YHmmfPDsoN+1f5b4tBhYnRjtEpsb02/ffA63xnjcxEUm9oob+XRckOkvG0Io86UaYmI4
         iMKKlAsq0Dvpyhb3tC0yHKSHB+qBC3Y/xuHQo9jCmN0Tq//GjB4GfvoPpmzMvWIb7OqB
         FvqPC8aSspQ7ss+8fPCNAj7ZYMJheh0uSgvvhEUFu40O0Uui/AXMlbhEWe+qMQOOTllO
         /gtDc4a5X4MF/vz6MSdRQksygutu42PmooemQqwIGdLEgzWX/O2cWrieCHNgzqi7fQhY
         xxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=zof+mp13EAfmnpFsK9Eco3V3Cmb3NggImWCyhng1tgI=;
        b=qfpBdMEbLsjU9e1utr1C8usGpaMzA3XjvKPfHAcYxa+V/hk6IJ9Q4chA7XTB2WiFoD
         xosY9AgnuSpqOoDOkO8RtS9ryg2NWYasMKjDTngbnPritqh+fO8lMHlKhillstY91g+I
         hkC0Mp6TfHRqQDVtDPGTR1em/WOIqVIzyRAkHNFo7HokRZdcjNX9PqWtHjhMrolSul9a
         KSsXYkO2TTLBpGzscwplWVBZ5TyK0x4KkWIWAJeomM6NL7L6aK8rAD5qVHqx+pZkwGpV
         as6FDcpqIicZHaoRJlCp07mzn5hNMSxVua5drolLNBV0FEkppcbqgA2p7T+5MBeGrRFq
         BgFQ==
X-Gm-Message-State: ACgBeo2st2teASX4UyYXHRb3xgPe1jFNO3afiR4DMDFLv/QFxOMClhqV
        n0UL1i3aPJXoaLlPIZ0O65PyQ3D6PFpRI3uWa8l65cbd8RXLpA==
X-Google-Smtp-Source: AA6agR4DNToeKpApZ4CX8A6IRunZiDiLM/7ttFFbk3rYdOm/t0thj1wwha4czz5JtQir5dsudcuBndTSzA5KyA5yNgc=
X-Received: by 2002:a05:600c:19d1:b0:3a6:14e5:4725 with SMTP id
 u17-20020a05600c19d100b003a614e54725mr2889786wmq.141.1663083784660; Tue, 13
 Sep 2022 08:43:04 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Yang <richard.weiyang@gmail.com>
Date:   Tue, 13 Sep 2022 23:42:51 +0800
Message-ID: <CADZGycYUH=j80zmJVr7dfVtoJ+BrbAEPJE8Nvf3HR5oimJR+UQ@mail.gmail.com>
Subject: [Q] packet truncated after enabling ip_forward for virtio-net in guest
To:     "Michael S. Tsirkin" <mst@redhat.com>, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, I am running a guest with vhost-net as backend. After I enable
ip_forward, the packet received is truncated.

Host runs a 5.10 kernel, while guest kernel is v5.11 which doesn't
include this commit:

  virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO

After applying this commit, the issue is gone. I guess the reason is
this device doesn't have NETIF_F_GRO_HW set, so
virtnet_set_guest_offloads is not called.

I am wondering why packet is truncated without this fix. I follow
virtnet_set_guest_offloads and just see virtio_net_handle_ctrl in qemu
handles VIRTIO_NET_CTRL_GUEST_OFFLOADS. Since we use a tap dev, then I
follow tap_fd_set_offload to ioctl(fd, TUNSETOFFLOAD, offload).

But I am lost here. tap_ioctl -> set_offload(). Since we use a normal
tap device instead of ipvtap/macvtap, update_features is empty. So I
don't get how the device's behavior is changed after set LRO.

Do I follow the wrong path? Any suggestions on investigation?

I'd appreciate it if someone could give a hint :-)
