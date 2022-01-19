Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914934934AC
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 06:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351605AbiASF4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 00:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345127AbiASF4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 00:56:05 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225A2C061574;
        Tue, 18 Jan 2022 21:56:05 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id c19so1390414qtx.3;
        Tue, 18 Jan 2022 21:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6R4d6DNdMhT7VubSPtQNF7UbMoGlcSJRmj/aQMSIgOg=;
        b=XbSgMwxQ/JgliwKitI2lva3GJaWaGxLmwHDbL3JmSoe0m+aRto+fYPb0t3FVMdQ9E9
         mHMzvqrL4w3DLNN0xNb6Xcd5X8WYJq9+MNaoI/6i0POxeJO1IlM1BoHmw6glHGP13ZJq
         IvpRaH2AcEnHjJocKJ013oRR2TY4MalGkS2huGvrRAiaXu7qOSZJOZZY+eYw2U1k46J/
         12M77/Us/7UGdZf6ZSBNHI/lz8APFAlzNJymL6Sn63NaxqhKFw4kwAtrA3jvgn+1DUK2
         RZLTVslSm1aoWndzmIxXpGy5xcrMUB0I6qH+tx0zbN9TJz2P+Y8b2tJrQM8wXte6MWGO
         uhsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6R4d6DNdMhT7VubSPtQNF7UbMoGlcSJRmj/aQMSIgOg=;
        b=lMQd3ihvBhMDIFbSWw3WQtwLUFHONLIvz4O0vHXxpg+K++0cmZrezlYHNoLCyJ840Q
         xbOtuEXQi+2rgXF3MhQXyqHRWYfwq/lOdp77c06aruMtbEj+Fr7nMePxXJbvozM9P06n
         gjJRtRHkhte9qgoi4FHSPx0Iv0W6IbC+/GKmL+fAg+SpQOAuEI/sxsSxAavzZoNJ+jWl
         R8pFOK6lfjYKqLn4FXMHvk1j7u5fKvYtMwn8bXIwZDR77zPAZEAlHeJyfs/hauyxFCmh
         V9Y0Qj7VueNqKyI4G6B4fQqMN/sITER4yke8qAmKZb6Uu8c8V+xWTnaRqqxnQU3Cop9N
         b3nQ==
X-Gm-Message-State: AOAM533MT6CjV2JDUJRJd4Wsod+9O8ExpiV/DD8ZVv43Yi9uE0Q1joVi
        523T+rRLK8f0sfjkRkhXNdc=
X-Google-Smtp-Source: ABdhPJz2spbr9MqA774cO5sWeVSq5WtNjQ4H+IAaYhSVf3eAoUdZTRYUlu05JxUBBNGpGs6vcp9ksA==
X-Received: by 2002:a05:622a:60d:: with SMTP id z13mr23427409qta.399.1642571764236;
        Tue, 18 Jan 2022 21:56:04 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t21sm1829376qta.41.2022.01.18.21.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 21:56:03 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kuba@kernel.org
Cc:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net,
        dsahern@gmail.com, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, zealci@zte.com.cn
Subject: Re: [PATCH] net/ipv6: remove redundant err variable
Date:   Wed, 19 Jan 2022 05:55:57 +0000
Message-Id: <20220119055557.931265-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118192804.1032c172@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220118192804.1032c172@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are more than 3,000 numbers retrieved by the rules I wrote.
Of course, many of these 3,000 are false positives, and maybe 
there are 300 patches.I wrote this rule similar to returnvar.cocci.
