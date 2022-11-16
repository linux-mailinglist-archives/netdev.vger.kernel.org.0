Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A63C62C5A0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiKPQ7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKPQ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:58:59 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC9A12D28
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:58:58 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 62so8869380pgb.13
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oav747i3GRsguS4wCnG5uBx2CB13Ewgza/UrWGIDGEM=;
        b=SjV0vjqZPnGNekA+waOKZGWgGrSes2Q99NDxdluuF8EUJ6991vf1htcGBfNmPLgLs7
         afjooF8PXwQ7FVolKh6fgHbrQ84UcWJ2bocTtF7No3b2xqDolEZLgRAIWOA3L/NLfSUb
         zBk15wh86x5IfTc8mHAyLV2Vy/YaFoVA3S4hUweWWjzddzI+BllH952tWsIpytJsvN0/
         qo3xFvUWvPqR0XIYGHEf4k1LzmEWmGt/5lXQieFidScxXcfetDzDM14A6EOZEZ6IxX0g
         PwZaq4nidToWXlx+jmxqdyWHSb6I2VohblSacMIKEWNsAyKzP+SAOvzusJKVj+9W9g1o
         HkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oav747i3GRsguS4wCnG5uBx2CB13Ewgza/UrWGIDGEM=;
        b=0IvEsrosQeT8ZMICcJeA+WHTpliqiMk9crGwx5ohlNqz89u7QRj5sugJoBwEDKHII5
         AG4N5L6xggvYPirtYsaGPTJIzjIB+967rCsQMlLRMP1oZ/iLNl5N3o66NYd+ycy1GuY/
         gZRPS3pUeG/FNJOURs9G0UWpo080GyQ40OBtsKNZYdh5afQuK5hqUpFCVJcoB8MwahrA
         f8kyzJ1f5XbTriwaaqUnkSxSIHj0gJl+jDmOEB4GNvhrR1wZhrGeV3669Z6w5HdUVM1X
         Lh3+vVyZSQAMODZnOeAxx+3XMCG4SkLBB6MCEMJy9pbshlwOLgjojQNeMfKScwi7nFWk
         KLeA==
X-Gm-Message-State: ANoB5pmO8w6JqKyCeMQcorfyd1vofAmRAx7lg3ezQ8p0B5cNkRK23Uou
        /L6upcYxTrhnOMFAT5EFk34tU6lXellgtA==
X-Google-Smtp-Source: AA0mqf41nCc5L6QBM7nvEDRvNj52SrSsmJwQGyrg8rFh1uS/N2iIv5Nf9jkhVOmfWZsgshBnG85dlA==
X-Received: by 2002:a63:134c:0:b0:45f:bf96:771c with SMTP id 12-20020a63134c000000b0045fbf96771cmr21705272pgt.131.1668617937147;
        Wed, 16 Nov 2022 08:58:57 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f18-20020aa79d92000000b0056e5bce5b7asm11026665pfq.201.2022.11.16.08.58.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 08:58:56 -0800 (PST)
Date:   Wed, 16 Nov 2022 08:58:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216694] New: [Syzkaller & bisect] There is
 inet_csk_get_port WARNING in v6.1-rc4 kernel
Message-ID: <20221116085854.0dcfa44d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 16 Nov 2022 08:44:26 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216694] New: [Syzkaller & bisect] There is inet_csk_get_port WARNING in v6.1-rc4 kernel


https://bugzilla.kernel.org/show_bug.cgi?id=216694

            Bug ID: 216694
           Summary: [Syzkaller & bisect] There is inet_csk_get_port
                    WARNING in v6.1-rc4 kernel
           Product: Networking
           Version: 2.5
    Kernel Version: v6.1-rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: pengfei.xu@intel.com
        Regression: No

"WARNING inet_csk_get_port" is found in v6.1-rc4 kernel.

And first bad commit is: 28044fc1d4953b07acec0da4d2fc4784c57ea6fb
"net: Add a bhash2 table hashed by port and address"

Reproduced code from syzkaller, kconfig and full information is in the link:
https://github.com/xupengfe/syzkaller_logs/tree/main/221108_215733_inet_csk_get_port


Related discusstion link in LKML community:
https://lore.kernel.org/lkml/Y2xyHM1fcCkh9AKU@xpf.sh.intel.com/ 

Thanks!

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
