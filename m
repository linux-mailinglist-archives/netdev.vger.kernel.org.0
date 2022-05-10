Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C2520EA8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiEJHhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241433AbiEJHcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:32:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66E4245C75;
        Tue, 10 May 2022 00:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3Hrh/oFhXE1F4xFjCTQdwxSdFdLuAyp8OrT/z6Ubir0=; b=4pMjvkt+lUTr+xgL+mPbWT3Sj1
        liDBnYW/9eKfGfccW/xHqL9rIY9PAaDNi48/PqUECoryiZrCjC4xpiZ6wIgTZ0JOWPSFJ2CW/WKyQ
        d5+hEYbs4SAmyBXfwSuvmmMyy22dODkerOi4I1ZS310PmOGgjzmFLHpruDAVTVIBet4VPZOFZR7H4
        LH+MAdOrSRdfppTNHQFZVA9lCDeeQ4V2anQ2+rb6x42fcdRl255QP5eoYvSnLDqVKNmIkT8mW8FiJ
        M+f1PKQExzGGWhU3ZiIJvY3CT6Shrtvm+r9YfXC0Kc7aphrsVWGpRpQGVwcOv+LOufEL+sTrz0S+w
        wUpNFQQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noKHh-000M5X-Uc; Tue, 10 May 2022 07:27:53 +0000
Date:   Tue, 10 May 2022 00:27:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Du Cheng <ducheng2@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vlastimil Babka <vbabka@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] niu: Add "overloaded" struct page union member
Message-ID: <YnoT+cBTNnPzzg8H@infradead.org>
References: <20220509222334.3544344-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509222334.3544344-1-keescook@chromium.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:23:33PM -0700, Kees Cook wrote:
> The randstruct GCC plugin gets upset when it sees struct addresspace
> (which is randomized) being assigned to a struct page (which is not
> randomized):

Well, the right fix here is to remove this abuse from the driver, not
to legitimize it as part of a "driver" patch touching a core mm header
that doesn't even cc the mm list.
