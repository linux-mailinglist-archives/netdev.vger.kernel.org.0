Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74B850C161
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 00:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiDVWFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiDVWEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:04:47 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CDF1EF9BF
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:47:15 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 29161 invoked from network); 22 Apr 2022 21:47:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1650656832; bh=xN2TT2giRziTYzxkSRV3HAksGNGWVBKa+uXJBNXkzg8=;
          h=From:To:Cc:Subject;
          b=OaGiXdxuDtJlr6gXKJMqvpfHpw99AKST0JhzfU229DzbMl/J+krQWmDL0JaMn3wZ+
           nLYzvdrGHvHszYhPrBHs6aXhFXMAhayra5vhItjEqeLtXIx/Awutg9aHIuu0eIUDfd
           DolY4LgU+nV3ARsdp1tJC43865542AEiY+9HqATk=
Received: from unknown (HELO kicinski-fedora-PC1C0HJN) (kubakici@wp.pl@[163.114.132.6])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <zhaojunkui2008@126.com>; 22 Apr 2022 21:47:12 +0200
Date:   Fri, 22 Apr 2022 12:47:04 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Bernard Zhao <zhaojunkui2008@126.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re: [PATCH v2] mediatek/mt7601u: add debugfs exit function
Message-ID: <20220422124704.259244e7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220422080854.490379-1-zhaojunkui2008@126.com>
References: <20220422080854.490379-1-zhaojunkui2008@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 9321f50bc9e4db09d6c2149ef2c2edd3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [UYOE]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 01:08:54 -0700 Bernard Zhao wrote:
> When mt7601u loaded, there are two cases:
> First when mt7601u is loaded, in function mt7601u_probe, if
> function mt7601u_probe run into error lable err_hw,
> mt7601u_cleanup didn`t cleanup the debugfs node.
> Second when the module disconnect, in function mt7601u_disconnect,
> mt7601u_cleanup didn`t cleanup the debugfs node.
> This patch add debugfs exit function and try to cleanup debugfs
> node when mt7601u loaded fail or unloaded.
> 
> Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>

Ah, missed that there was a v2. My point stands, wiphy debugfs dir
should do the cleanup.

Do you encounter problems in practice or are you sending this patches
based on reading / static analysis of the code only.
