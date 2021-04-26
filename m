Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8690236B17E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhDZKUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhDZKUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:20:54 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65315C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 03:20:13 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id w9so3603299lfr.12
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 03:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codilime.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=WxYWwA6mEw0KJTNBuUofOdthE/VY20C4OhSk4uI2arc=;
        b=PO1YmaoDYrmmfBHZ87vyRz1Qp8Mb2BDYvze7Sy/UiziGsAlmDd6UjvnwdZWTIbcFhh
         qjS7DwpuT+e8wHByeFC5SUcA1fbp0gV7GfOqoGcMry3YdzmZcT2lKX79GkYjeaKOjoyM
         vSc0H6+xk1JREdGMjlB9A9vwTKjbZmlEbYunnfJt4XjhWb3vBBCPnha+PbNyuD6m6XdS
         66msNI6pPuaGYJHgHSsXhwT3mwjxV9Ukv5Y0OfLQuZV+jAiknhrEpw3/58Pz1LnCtwsh
         LP1fr2j0RE+fVTozN2wgq3iNMxvCIriOhn5fCz0Ge/bUb1xaBCXPgQu/bzvwkxClrpJP
         lYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=WxYWwA6mEw0KJTNBuUofOdthE/VY20C4OhSk4uI2arc=;
        b=UcILw1WB4BNJDRvaFQbKZkp0N48dMVluevGCPLrIQq19TkLk/ftKo6ACw24G3Crub/
         w9mniLRJR2inWiI1v88W6dMX5KvKMzQvob6oeBDJjkgltsygZqcWAEunY6c0HiffXXUm
         KlS4N7vt/IcXlfpOO/x30FxiOgzrM9WLvIAK1IaYR/FDwDw/podPOEkLkXTwhCcW2qXG
         bQ/iwtvfJv8Tzx9QOlQMVyiowUAmSiqbz2BCrXoBZhgYhNX7I4zHt8+Gmy5PsAzI2n0E
         nXe0ObAh+56xW8T4dZsOE6HVsg2+vmPTdXza8Xrh+K5mkCdD3C2wCXlvakRO3Y4uqAF3
         DUCA==
X-Gm-Message-State: AOAM531t2bLTLGGI15Ke/FdLC6LyYfYB8n9h7A8zPawQ0TvAVqCTsOcu
        IoDhBOdrxsE2tzMjicZXnW22NT1wTSrQgvfBxajKCzewpa3WXqF91V3Zw4lu+OW0F73CW/0pHcj
        gj0aqWzRW9A==
X-Google-Smtp-Source: ABdhPJzyzUuUAFTFnZSJzbsaG/OEH73aHx+UC2ukR4nb0NITIXocB7ghkbMRyrXdJgxZruYnUJoVAQ==
X-Received: by 2002:a05:6512:3b92:: with SMTP id g18mr12161689lfv.646.1619432411932;
        Mon, 26 Apr 2021 03:20:11 -0700 (PDT)
Received: from ak-snic-codilime.intra.codilime.com (195191163011.dynamic-2-waw-k-1-3-0.vectranet.pl. [195.191.163.11])
        by smtp.googlemail.com with ESMTPSA id p15sm1408212lft.60.2021.04.26.03.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 03:20:11 -0700 (PDT)
From:   Arkadiusz Kudan <arkadiusz.kudan@codilime.com>
To:     virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, jasowang@redhat.com, netdev@vger.kernel.org,
        Arkadiusz Kudan <arkadiusz.kudan@codilime.com>,
        Miroslaw Walukiewicz <Miroslaw.Walukiewicz@intel.com>
Subject: [PATCH] virtio-net: enable SRIOV
Date:   Mon, 26 Apr 2021 12:21:35 +0200
Message-Id: <20210426102135.227802-1-arkadiusz.kudan@codilime.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With increasing interest for virtio, NIC have appeared that provide
SRIOV with PF appearing in the host as a virtio network device
and probably more similiar NICs will emerge.
igb_uio of DPDK or pci-pf-stub can be used to provide SRIOV,
however there are hypervisors/VMMs that require VFs, which are
to be PCI passthrued to a VM, to have its PF with network
representation in the kernel. For virtio-net based PFs,
virtio-net could do that by providing both SRIOV interface and
netdev representation.

Enable SRIOV via VIRTIO_F_SR_IOV feature bit if the device
supports it.

Signed-off-by: Arkadiusz Kudan <arkadiusz.kudan@codilime.com>
Signed-off-by: Miroslaw Walukiewicz <Miroslaw.Walukiewicz@intel.com>
---
 drivers/net/virtio_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0824e6999e49..a03aa7e99689 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3249,6 +3249,7 @@ static struct virtio_device_id id_table[] = {
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
+	VIRTIO_F_SR_IOV,
 };
 
 static unsigned int features_legacy[] = {
-- 
2.31.1


-- 


-------------------------------
This document contains material that is 
confidential in CodiLime Sp. z o.o. DO NOT PRINT. DO NOT COPY. DO NOT 
DISTRIBUTE. If you are not the intended recipient of this document, be 
aware that any use, review, retransmission, distribution, reproduction or 
any action taken in reliance upon this message is strictly prohibited. If 
you received this in error, please contact the sender and help@codilime.com 
<mailto:help@codilime.com>. Return the paper copy, delete the material from 
all computers and storage media.
