Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4FB62EC82
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiKRDwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbiKRDwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:52:38 -0500
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF93B8F3EE;
        Thu, 17 Nov 2022 19:52:36 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id l12so6224504lfp.6;
        Thu, 17 Nov 2022 19:52:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=240kn03GT6YjtHcyHthMPHCmJ35FvTMvfiM7fDZi1UY=;
        b=HXB5p2gSHUHjSuEBF3tHIhzrTxo5W9omwZmVeg4rdcPQZZjDE7Wbddh7Na+I2fv8U/
         uThoB0nYlvWmADbGepx+4QA5jkWMsFkeNZBUotwA/wuOFN8XORd1p7EMmTk48hB01LPz
         2LmFnNiQSVdI0KEAbcFnKcAUf3cg0L8tq8egyvGqVCeQmb5wgj/Hv+DmPB9tm41JcUWi
         nz+4lA6W8BnDAPoA0NVK9faMlV4btC8fs/QlIU+F5qPiU3VmUIPWveKjy9Sc0EvzMt+b
         IPIy7yFzVGUs1HkBviKm+95WIesS7Cdv1qme4XjtNI7EDj1yYJLoXCH/1D0rccaXDvzD
         Ep7A==
X-Gm-Message-State: ANoB5pmnMSNvk5Qp86g6u2BJ4F9rIbMqP8JTptB03kQ8ll9HxBtjmoZv
        x3uViv/1oqsULvrF6l8Fwpjthumk7oyz4aul
X-Google-Smtp-Source: AA0mqf6L3yaV/1VwfYXVwaJwiqckSx7UcHkCUYhu8In5dDqNNzEKlCgyCsFxPTa1Wu22MIOysULQmA==
X-Received: by 2002:a05:6512:298f:b0:4a2:4365:7da7 with SMTP id du15-20020a056512298f00b004a243657da7mr2099814lfb.639.1668743555021;
        Thu, 17 Nov 2022 19:52:35 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id a25-20020a056512201900b00492dbf809e8sm470572lfb.118.2022.11.17.19.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 19:52:34 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id j4so6291383lfk.0;
        Thu, 17 Nov 2022 19:52:34 -0800 (PST)
X-Received: by 2002:a05:6512:3ca4:b0:4b4:b5c2:647c with SMTP id
 h36-20020a0565123ca400b004b4b5c2647cmr1797642lfv.42.1668743554314; Thu, 17
 Nov 2022 19:52:34 -0800 (PST)
MIME-Version: 1.0
From:   Sungwoo Kim <iam@sung-woo.kim>
Date:   Thu, 17 Nov 2022 22:52:08 -0500
X-Gmail-Original-Message-ID: <CAJNyHpKpDdps4=QHZ77zu4jfY-NNBcGUrw6UwjuBKfpuSuE__g@mail.gmail.com>
Message-ID: <CAJNyHpKpDdps4=QHZ77zu4jfY-NNBcGUrw6UwjuBKfpuSuE__g@mail.gmail.com>
Subject: [BUG 0 / 6] L2cap: Spec violations
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
Our fuzzer found six spec violations, illegal state transition.

1. BT_CONNECT2 -> BT_CONFIG by L2CAP_CONN_RSP
2. BT_CONNECT2 -> BT_CONNECTED by L2CAP_CONF_RSP
3. BT_CONNECT2 -> BT_DISCONN by L2CAP_CONF_RSP
4. BT_CONNECTED -> BT_CONFIG by L2CAP_CONN_RSP
5. BT_DISCONN -> BT_CONFIG by L2CAP_CONN_RSP
6. BT_DISCONN -> BT_CONNECTED by L2CAP_CONN_RSP

All expected behaviors are ignoring incoming packets as described in
the spec v5.3 | Vol 3, Part A 6. STATE MACHINE.
Also, I assumed BT_CONNECT2 is corresponding to WAIT_CONNECT in the spec.
