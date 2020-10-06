Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16662851EC
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgJFSxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgJFSxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 14:53:18 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F199C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 11:53:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so8481430pgm.11
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 11:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6LnJQb6SFUk0QHP9b1BAak/eeY2fLSfwl5wJ5GeVUGk=;
        b=ue49t4Us56IbY7sgjyVRUxbaadOAssx+RLhA0VPcD/frrCW7cfvIjMg1UYj/Y/Tzi8
         R+7FuUTBwEyX90CcMIGOM1oENYVBbyiXf1Rc1cNfnQ193ko+kVpfRivW/Bq5thyhqtOX
         KQ3aQwpQ7bqdrYoezryK2RUP9ccXjtG9gmwHknzakcJxFKTxWMdI1Y40Al9CKbsxbU/D
         9R22UVu73mTfibCIlaafE5dLSlAlAtf5nhSYaXkSDbjMR0mIujL9flBos+2N65GCdFK7
         /rNp8d3oSLW442oyE3V+pVgwVS1FKQjjl+Z40xSnCwLXVJ5qFWnEnrmsMbHz1dIYpyrG
         F5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6LnJQb6SFUk0QHP9b1BAak/eeY2fLSfwl5wJ5GeVUGk=;
        b=Z30nDrxeu5VU+qmafwaFCNZ6n0LXzbfHdAkUOFj5G6MfbMHJzzERXUs/VS9DrMw/Vw
         2xryoh4gR9uf5ArmoEippHJSbPuebkeASZFVwT02PalLvkkRBAwES4J8pimWNgQssCfx
         ZnXwvsWb8QKXRsMiPVlz1dwRen6eRyaI7zyY5tcV4C8kn8xwXQcH0iAdLg0PjOYccrCm
         fHcowRTSnyFnzCXcZeR2rTQygqlgNeezEvZXIwvg1GxvOXLvNuOR8rBUiUYZVm7MpUOI
         FzEXzbPsjopP7q0pz6YCbiUIWnRCR4qc2LfAXA+4FNttX+gHPNoJJMRf2oI6sJnEnFqd
         BIxw==
X-Gm-Message-State: AOAM5308yDCT57FbvUAfN9lVzxAQ/cQYjmnBWjiDr/tsMwo/laDNJJmw
        eS57v9vDxZ1nSKLSCQeoFkDNcpF7ze9Qng==
X-Google-Smtp-Source: ABdhPJxtwFn9STJJeRBhHGs7nMk8Ba+uxc0RKb9NWFsqXFh+foj/IbtDtG/umiCmCrw7ClbsF8Cqow==
X-Received: by 2002:aa7:9e4a:0:b029:152:54d1:bffa with SMTP id z10-20020aa79e4a0000b029015254d1bffamr5728764pfq.6.1602010397634;
        Tue, 06 Oct 2020 11:53:17 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.184.170])
        by smtp.gmail.com with ESMTPSA id k206sm5409304pfd.126.2020.10.06.11.53.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 11:53:17 -0700 (PDT)
To:     Netdev <netdev@vger.kernel.org>
From:   Gregory Rose <gvrose8192@gmail.com>
Subject:  net: Initialize return value in gro_cells_receive
Message-ID: <e595fd44-cf8a-ce14-8cc8-e3ecd4e8922a@gmail.com>
Date:   Tue, 6 Oct 2020 11:53:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'res' return value is uninitalized and may be returned with
some random value.  Initialize to NET_RX_DROP as the default
return value.

Signed-off-by: Greg Rose <gvrose8192@gmail.com>

diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index e095fb871d91..4e835960db07 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -13,7 +13,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct 
sk_buff *skb)
  {
         struct net_device *dev = skb->dev;
         struct gro_cell *cell;
-       int res;
+       int res = NET_RX_DROP;

         rcu_read_lock();
         if (unlikely(!(dev->flags & IFF_UP)))
