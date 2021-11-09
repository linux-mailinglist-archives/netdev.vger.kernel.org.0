Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D9544B463
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244834AbhKIVBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240544AbhKIVBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 16:01:24 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380C5C061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 12:58:38 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id bk22so416656qkb.6
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 12:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=uJLwi4hPqvjhVR79xyMVIuVqhjfSEa/IkEnpNp9BcHs=;
        b=Cf5+FgVYBN1h0oPCy7/8Q24+U8kRDQcPrG2zjilQj1N6VcLJFw1453Yn1AdnvgkdPC
         5oMMDimcrg4LlKZV7Z8iVoJ1olYq1kX+3Lf/j8sWRcyFI/SnbwiO+hUBR7UcVveG6jrm
         zolNGU0+YE+vY+Y4PptG0p4ezhbo4qXgNagnbUqFvOhbJ3kvk4Ra4z9O2GrS0i638jpM
         aofxHBhEasKdUl/GCKUW55PjD+/Edb5EU1hfvmbUD1cyyWhkttOXjnnLZdR6EPOhjuUu
         Lx2QKEsXSIA0k6mBxEcybzeN+rcCNaXKZeT8UK6lgjtD04p9Ar8g8RjkuPgqaBMMvuEm
         BrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=uJLwi4hPqvjhVR79xyMVIuVqhjfSEa/IkEnpNp9BcHs=;
        b=eHIpNAVe5lo3yJDuiCNbLs5eN3FAq87TkM3OUdHOGzaTz1mP6MNB8ajPGeQfzuqMx8
         LmQw5WonTyeqp28WUCY+5pwBlS1rcAVf9oNDZVFEGAIllir8rLZXJlbB7yLAdnu1VOEb
         v6GDNatTmkpVsEiktAw2rOPS7Aq+U9juc5xKD1nxf/o5Nf8R562jIh+cphV6e8jXdLNG
         z+yLhWByPGOI/nPKyNidL/5ghcEG4Ty4LFUxBhRcFbWp+ZMNCRNoQalUE2Ndx7oIEcRg
         AGN0Dp/I6H06HbpdV5fvocmu5Guhs3danxms+wSqdaIMT268x4ViRNVoJU0kCsdvwItT
         kDkA==
X-Gm-Message-State: AOAM532jXkMEIC+mqkSFW6wnkWTp7Tbf4RUOGQKjnRnm13X1xIGPXFAH
        caqZ0aU+Ca0koojo/cXpJxBa6qbz5gg=
X-Google-Smtp-Source: ABdhPJyDHglcAh5E+suJos5HImMiz6Rq31NHzKm4f2GFUCe4KJZOpHe5E1eQ0hMfX5UDqiMgKhOrgg==
X-Received: by 2002:a37:a64f:: with SMTP id p76mr8516069qke.154.1636491517118;
        Tue, 09 Nov 2021 12:58:37 -0800 (PST)
Received: from [10.50.24.244] (wsip-184-181-13-226.ph.ph.cox.net. [184.181.13.226])
        by smtp.gmail.com with ESMTPSA id e10sm12765359qte.57.2021.11.09.12.58.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 12:58:36 -0800 (PST)
To:     netdev@vger.kernel.org
From:   Johannes Lundberg <johalun0@gmail.com>
Subject: Suitable value for bonding module's tx_queues?
Message-ID: <948e62ad-2fe5-11e3-03a9-8382f7e8b6f1@gmail.com>
Date:   Tue, 9 Nov 2021 13:58:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Please cc me on reply since I'm not subscribed.

I'm wondering when you want to change tx_queues from default 16. Should 
this match the total number of queues of all the members of the bond? 
Let's say I got 2 interfaces, each with 24 queues on a 24 CPU system in 
a bond. Should I load bonding with 24 to match the number of CPUs or 48 
to match the total number of queues of the members, or leave at default 
because it's not relevant?

Thanks!

