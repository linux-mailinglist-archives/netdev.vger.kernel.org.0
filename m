Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160CC6B78FF
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCMNbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCMNbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:31:07 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BD223138
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:30:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id x22so2527367wmj.3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678714218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tQxkkP15Psd1FOhh86G2dVN0PQVab9bvvNWAZ7fI2iQ=;
        b=lDLl1U9YgwrqOsnPNBfFXixZeGgzbGI5l8VVl7KDXXaxkrr2I9Jsh+1wtBzLzEfKIA
         Krt6s6rMFQGq1divgooE06dXvCe/oWb/DJmS/CQtjA9rJn3EtXM4qNKCRG8hZRZyubC9
         ZS+n6tn3QB0J1FJbzgLYCrP4lvm6A0kDF4d/29oz/sh7wT6/LiX/j0lDPRdUI576visi
         YJSnCU0cBsCbZqazhoHQI/JZw8GgWZT6bhUrsihhxbRcRtwY8VGe9LXi/mLR9GK4Lg2p
         EIZQh1LIQZFGS2aM5uUEoD6lONKsl/5Pl56IWgej7QBgH9sAIJFfZQ/FumgNjjL7kmhE
         r+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678714218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQxkkP15Psd1FOhh86G2dVN0PQVab9bvvNWAZ7fI2iQ=;
        b=uXBbSO0Ag6EjiaFRtEnzk48c4ZgD1x0qWPkatn9fJ5N4JX4Sr5YnJsovjmB6rL5pM+
         OEUaYcLCcqUZE9hpBZryX4Wzhh5oeqoantYRvXd/oM9jlLAtrFXOmP2z7okFeb2zDixG
         HWYuXifQbk9DFgSyig4melUba5t6sWaP0jPZQ9kccSJ+bCOF6+/qp6ZsvDFPpuVD1DFc
         xul4eC+JrYDWhPjgJj68c5Jc0hQHccNuOcJAFNo0wDuHdhySmbiZHJ3awD4x+c69Up6b
         +hhFov+9kCSU5WjBcYqNNriVyL1qZThOmtb8zGqzfuNpdeDaNJQJnxEfe2wJe29ZELyl
         Gz1A==
X-Gm-Message-State: AO0yUKWoLqwM6HRgQA1hjdcO+AU7ekZexghV8BkjrzWju09K+98onEd9
        j5L6T/8tGZO8cBPgAIt4Q4TvoIHRqHue4rfmMBg=
X-Google-Smtp-Source: AK7set+QnXwSJmLSr/t92yXDlBFqy8On5JB5cmTIcyNqKAyxc6tyQYDqQ9OSJk7i8kyWxm4Pe2N6Xw==
X-Received: by 2002:a05:600c:3baa:b0:3df:9858:c02e with SMTP id n42-20020a05600c3baa00b003df9858c02emr7620925wms.3.1678714218327;
        Mon, 13 Mar 2023 06:30:18 -0700 (PDT)
Received: from debil.. (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id o1-20020a05600c4fc100b003e2096da239sm10148274wmq.7.2023.03.13.06.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 06:30:18 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     syoshida@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net 0/2] bonding: properly restore flags when non-eth dev enslave fails
Date:   Mon, 13 Mar 2023 15:28:32 +0200
Message-Id: <20230313132834.946360-1-razor@blackwall.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
A bug was reported by syzbot[1] that causes a warning and a myriad of
other potential issues if a bond that is also a slave fails to enslave a
non-eth device. Patch 01 fixes the bug and patch 02 adds a selftest for
bond flags restoration in such cases. For more information please see
commit descriptions.

Thanks,
 Nik

[1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef

Nikolay Aleksandrov (2):
  bonding: restore bond's IFF_SLAVE flag if a non-eth dev
    enslave fails
  selftests: rtnetlink: add a bond test trying to enslave non-eth dev

 drivers/net/bonding/bond_main.c          |  8 +++++-
 tools/testing/selftests/net/rtnetlink.sh | 36 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

-- 
2.39.2

