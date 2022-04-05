Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A9D4F4384
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354422AbiDEUDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572959AbiDER2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:28:04 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0FC18378
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 10:26:05 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b15so84401pfm.5
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 10:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=FZGfm+e76GgU9w1YHU4QJswMXDu1nDn/YLb5QsnkFXs=;
        b=sb7O6lz8839TY4aLmmwn5fi7xXJXdrJ+i6/7AtHKyG25Cxu81oOvMrOMP0gBMMQSy0
         K8ZoX/TteMwZD/75TRxJ3VWj6erEFO485kO2UO+q65/R0IjOBVnv24xupANJ0Fy9oOdQ
         QiywganFVnc14aOC9CmVoeAO7HPaYap1hcMeLXDsr56PT1wfbPEEd/HCmyGfOZ8we6hm
         3sjg+ZQVtXmbzJO/ELZTGLttugpNrWpc03YNNgopO4N7knGD7xh6X5gUZ3IM8oW6epjA
         uRrWJFi+h7Df1PbI7wHn5HmuuImbYZJzhdYKpjOhRqc9uAk0hfmxD0oi3u5r7wcWr4BG
         JMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=FZGfm+e76GgU9w1YHU4QJswMXDu1nDn/YLb5QsnkFXs=;
        b=lr8yq45tkJ+lBPogWDYu5iksFdLv+cEBi3IaDqySoPfABkM7Xu/yLZQHa6cXrwRXn6
         LQL+7TKIiJweVmd+FifwC7QZkTYGZUfYxcakUfuAlvQ1c6vpbkrzqTR2hvTFvF1tY/EN
         q97Lkyt8CIxEUiAWBMMUko2lT1E01i0ZMRWTl554GjYyyS7s8rdqoevhwaXU6+a6HiIV
         0NkVUCAslpcUf8UXvtPGLZTRxub5AuTfOqaE6F0QeiVra3qxvDzdpcASdTxI6M7l2wMq
         kfvN07xVNcGfxWHebwzV2VXOhTCit7WUCIhn7JBfGvVUvIhIKxQHzoXIqEG3oWjf8BFB
         QXiA==
X-Gm-Message-State: AOAM533cN2VQOB9xJ0als0NzXjD6tbIiwUW1cdIp9XyS5avKlzOEymIN
        RsxmWTT0ZOVX0nsP9UhJhi/pIjvQ48KMKw==
X-Google-Smtp-Source: ABdhPJyJp7im4en6VmOchruqzJrDFLplfI5Fx2i2TEkotaft/gIWjdFW8ZtAAjRWYQASf1jlsaDVLw==
X-Received: by 2002:a63:520c:0:b0:382:2953:a338 with SMTP id g12-20020a63520c000000b003822953a338mr3728443pgb.610.1649179564298;
        Tue, 05 Apr 2022 10:26:04 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a000ccd00b004fadb6f0299sm16614726pfv.191.2022.04.05.10.26.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 10:26:03 -0700 (PDT)
Date:   Tue, 5 Apr 2022 10:26:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215806] New: bridge can not receive self send igmp query
 if multicast_query_use_ifaddr set to 1,no firewall
Message-ID: <20220405102601.1270a028@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 05 Apr 2022 10:12:56 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215806] New: bridge can not receive self send igmp query if multicast_query_use_ifaddr set to 1,no firewall


https://bugzilla.kernel.org/show_bug.cgi?id=215806

            Bug ID: 215806
           Summary: bridge can not receive self send igmp query if
                    multicast_query_use_ifaddr set to 1,no firewall
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15.32
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: shixudong@163.com
        Regression: No

no firewall 
bridge can not receive self send igmp query if 
echo 1 > /sys/class/net/br0/bridge/multicast_querier
echo 1 > /sys/class/net/br0/bridge/multicast_query_use_ifaddr

bridge can receive self send igmp query if
echo 1 > /sys/class/net/br0/bridge/multicast_querier
echo 0 > /sys/class/net/br0/bridge/multicast_query_use_ifaddr

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
