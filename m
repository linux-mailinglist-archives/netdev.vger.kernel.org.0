Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB2C570D44
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 00:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiGKWXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 18:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGKWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 18:23:14 -0400
X-Greylist: delayed 397 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jul 2022 15:23:11 PDT
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEAF2A977
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 15:23:11 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 39402 invoked from network); 12 Jul 2022 00:16:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1657577790; bh=FgTwvTq1JSrz7mNIp0oVdLzTuHaPTbJ115CWdvj3IsY=;
          h=From:To:Cc:Subject;
          b=dGF+JIvhtiNwRtOLhAFoU3bdxIOTiLFqUQqRJ0hYY9kTH2XXPLelltdRlzWJh77Gw
           g0yfU8HALnN7CZ05qIMYHo+BahPsPC3/dRrjUjAAT1x0JJ2pcphq2zLY4+RcY9fBhA
           xxdN+wh4Ifh0/3RF7rWZd2iR5iq/kpSCYRAAzxiU=
Received: from unknown (HELO kicinski-fedora-PC1C0HJN) (kubakici@wp.pl@[163.114.132.128])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <justinstitt@google.com>; 12 Jul 2022 00:16:29 +0200
Date:   Mon, 11 Jul 2022 15:16:11 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] mediatek: mt7601u: fix clang -Wformat warning
Message-ID: <20220711151611.573190f5@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220711212932.1501592-1-justinstitt@google.com>
References: <20220711212932.1501592-1-justinstitt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 2595572855169aaa33be638c199b8625
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [wVN0]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 14:29:32 -0700 Justin Stitt wrote:
> When building with Clang we encounter this warning:
> | drivers/net/wireless/mediatek/mt7601u/debugfs.c:92:6: error: format
> | specifies type 'unsigned char' but the argument has type 'int'
> | [-Werror,-Wformat] dev->ee->reg.start + dev->ee->reg.num - 1);
> 
> The format specifier used is `%hhu` which describes a u8. Both
> `dev->ee->reg.start` and `.num` are u8 as well. However, the expression
> as a whole is promoted to an int as you cannot get smaller-than-int from
> addition. Therefore, to fix the warning, use the promoted-to-type's
> format specifier -- in this case `%d`.

Acked-by: Jakub Kicinski <kubakici@wp.pl>
