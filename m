Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB29493346
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 04:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351144AbiASDAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 22:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345120AbiASDAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 22:00:10 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A487DC061574;
        Tue, 18 Jan 2022 19:00:10 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id 14so1074053qty.2;
        Tue, 18 Jan 2022 19:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CEGpD33dNgyVgYyBhAy9sQEe0I48q0p4Z2j3w+H5EHA=;
        b=TTpIx4MBdA1s7H1mhOfLV1AmjrhGv3YMDsyqV6b++rhphMHvlipr4pnvu3sCpZ1A+H
         6mh1AVCUi9eYuOqTsnkS5BmiQIUkQGuKVqMRWjo3hBYTCa31XGbiuamLWzQlJD28CG9/
         iA2CYi0dAU4YPBuyv+24a2cXAel2latG7MY4NKoFa63+3x7eoavcbugSGd0Es7FmXWVK
         viVJDtpO89c1xiZKIa6sjVPl752klrpQZ/dsqC79bqaWV9GHXCwOPmzouIldCIWhQ24B
         S0GLjFhP/9oDmWjHNIuidfLxdJp4720RZrrC/t6LYulR2KsD/WY3cURrdn3/rfuKf7oU
         eZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CEGpD33dNgyVgYyBhAy9sQEe0I48q0p4Z2j3w+H5EHA=;
        b=M2e7xfUDR1WSMOdFQmZjsts+LIUtPyF8jD5EMTkr4ko7R1aodY1xuvNJ3tEF48WDc0
         1rDDt385HzbV4+X2el0SYjFwt0eyNC5Q/3I0LFkQJyU+jrXuengJidnxlJF8mIZBcZJw
         kZh7kNLKWfkG3NZ0weu60A2QBLlth+kXi101X6LY/lo2kt1gwnqm976N0QNHe5F7jW5x
         u+gl9QisRcEj4giJHHeGp5o01kvEFQe+CYZ304eN0lhIlQp0clPTk9Txf6ylKW04Yrp/
         f8WHQrf2O1fhK471rdCQ3uQIxy+/TAqyOS4zSAH3mkgIxfmTf82XqTnQtVSlLVkPvDUm
         McdQ==
X-Gm-Message-State: AOAM532sbUGOtSniMMbqI6TZYI0uqjwQXtZAvtCd9G7zvAIU3srph5pN
        VDF0TRbjRnNHNlX99zy5crA=
X-Google-Smtp-Source: ABdhPJzZDUoUvr2QXKGu4pUpL34TEwBkXtSMHGhpr5FqBdnk2UTdsRulNSyg4f0/lvFni0ycjUrzhA==
X-Received: by 2002:a05:622a:c3:: with SMTP id p3mr8754755qtw.21.1642561209774;
        Tue, 18 Jan 2022 19:00:09 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t6sm9164951qtr.28.2022.01.18.19.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 19:00:09 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kuba@kernel.org
Cc:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net,
        dsahern@gmail.com, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, zealci@zte.com.cn
Subject: Re: [PATCH] net/ipv6: remove redundant err variable
Date:   Wed, 19 Jan 2022 03:00:03 +0000
Message-Id: <20220119030003.929798-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112083942.391fd0d7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220112083942.391fd0d7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the bot, I wrote a coccinelle rule myself to search for such problems,
maybe use the rules to scan before submitting the patch.
