Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800036D5A24
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 10:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbjDDIAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 04:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjDDIAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 04:00:30 -0400
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FE41984;
        Tue,  4 Apr 2023 01:00:27 -0700 (PDT)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1680595224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h5YSD0b6n1ur7Uw863f+KmXNdWrxPKy0G+svtitsFNQ=;
        b=doxk0rpPrOZfR2wNi0dfIIaGSuCKlD6shtLHnqIyjuntp7ml8T7Xg5wro39jqjtwsQTJsf
        +3MmjyPrZHPET9tYTKxZEVcTiRwGDPG6UDvB/ogi8RbvX70qTb5Ne4dGt+jg7yHuAqSqtp
        CjrMyaAfaRx/VutMFyinCEbg4Szow38=
To:     alexander.duyck@gmail.com
Cc:     arefev@swemel.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, trufanov@swemel.ru,
        vfh@swemel.ru
Subject: [PATCH] net: Added security socket
Date:   Tue,  4 Apr 2023 11:00:24 +0300
Message-Id: <20230404080024.31121-1-arefev@swemel.ru>
In-Reply-To: <30549453e8a40bb4f80f84e1a1427149b6b8b9e8.camel@gmail.com>
References: <30549453e8a40bb4f80f84e1a1427149b6b8b9e8.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander. I understand your concern. 
That's right kernel_connect is in kernel space,
but kernel_connect is used in RPC requests (/net/sunrpc/xprtsock.c),
and the RPC protocol is used by the NFS server.
Note kernel_sendmsg is already protected.
