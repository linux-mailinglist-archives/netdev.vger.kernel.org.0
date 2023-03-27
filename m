Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE616CA9EF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjC0QFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjC0QFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:05:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A74271D;
        Mon, 27 Mar 2023 09:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RGwHI36+26alMOPcJARCf4i+u/nuff7mObHUT3LcJRU=; b=LPLf/jCvgk6BbAdu2sWsjs0oNX
        30l+yYDMt7lIPUZlX1xLPKvd+VVVQITd3MBjp55UXnh0lC27yas9PjZ1X8/Ke/FN2w5Z7mgrMqRNS
        NMe2iIKVClT29RE+YYzmxZbB3MjqVTlPCvQNedD6+P2DTM3qoHKrTsXd9k/l+Z6LWIlrLqO0i0LPP
        WcUrCoUENmgBRd1TwHHhU6kKgkRvL9EW+Kwg4gKazSQbHimCznogGlrnIrlhrYbEsmEYHmZgBhRO2
        txegvcMIwswcdkNGLcJijBEGxeQVIVJr1oRDPP6IWPp68b1YWWkcPAIa7dwiPZZpdkAy2Plhs+eAH
        tVStJIQg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pgpLM-00Beeh-0e;
        Mon, 27 Mar 2023 16:05:12 +0000
Date:   Mon, 27 Mar 2023 09:05:12 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Minchan Kim <minchan@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russ Weight <russell.h.weight@intel.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-cifs@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] driver core: class: mark the struct class for sysfs
 callbacks as constant
Message-ID: <ZCG+uH4Dh16Gwonj@bombadil.infradead.org>
References: <20230325084537.3622280-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325084537.3622280-1-gregkh@linuxfoundation.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 09:45:37AM +0100, Greg Kroah-Hartman wrote:
> struct class should never be modified in a sysfs callback as there is
> nothing in the structure to modify, and frankly, the structure is almost
> never used in a sysfs callback, so mark it as constant to allow struct
> class to be moved to read-only memory.
> 
> While we are touching all class sysfs callbacks also mark the attribute
> as constant as it can not be modified.  The bonding code still uses this
> structure so it can not be removed from the function callbacks.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
