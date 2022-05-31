Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF6B538B2A
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 08:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbiEaGEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 02:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238360AbiEaGEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 02:04:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6215A915BE;
        Mon, 30 May 2022 23:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3CbF3u5gxI6nZsA0r6n4BrV1CPCofWtVl71+qUSAels=; b=qpAnrVzAgPZagunlQwv8l4h7wd
        2C5im6O+hHfn/TgEOmHVVP9OcuvueyToIsWpd+12VpgdJH7Ycz0Qj8Twm9iHtQQFpTqoOOkpEbSCd
        109aMzYNZRTbe/3bQZDNfEi3rRF2SqtSNWdQxdRLrWzWkG/Xq+uSqCvXSkHeAw9o3eBC3xpfIRnuc
        kiVcpoj82nAbXJHmAA07y7uVK1wJIhfh3SlH7DVXBlXT6fiAt1VBJJdyVQkZzXZtsYN5Wt/yucptF
        7ojaVgA3ql83Ey/tgbq2EI23KHcQ16zScKSzB+WWs8O8bmEX4/zFef4JzuOcAWhjkX4wqFwxvFu+L
        GqJQ81lA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvuzY-009UJb-7m; Tue, 31 May 2022 06:04:32 +0000
Date:   Mon, 30 May 2022 23:04:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC,net-next,x86 0/6] Nontemporal copies in unix socket write
 path
Message-ID: <YpWv8JACaqd5JuHN@infradead.org>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From the iov_iter point of view:  please follow the way how the inatomic
nocache helpers are implemented instead of adding costly funtion
pointers.
