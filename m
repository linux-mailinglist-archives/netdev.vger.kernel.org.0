Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6150957B136
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiGTGsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGTGsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:48:05 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CF8D62A45;
        Tue, 19 Jul 2022 23:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=7IqeY
        uiLu6+Xuav08/swOcov34IkuSOZgPxCRgHgF1A=; b=FxNyee6WML4OsTzd9/Bav
        YkF2XGxxYGMO20FVE4+wovbolVsO4ZtLsynzzatF2CQ2KYpDKx3RltZ5TQhV/G+w
        1FOQjWwP4WkP+v0Mvb8oYA5/JTDf9a3C9flBdh0mw+Nr8PBUZIswoFrI/gKm7sKx
        y5LMJvjx+/A0XrkMacC3u4=
Received: from localhost.localdomain (unknown [112.95.163.118])
        by smtp4 (Coremail) with SMTP id HNxpCgCHFb7wpNdiB5iyPg--.76S2;
        Wed, 20 Jul 2022 14:47:33 +0800 (CST)
From:   LemmyHuang <hlm3280@163.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        hlm3280@163.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] tcp: fix condition for increasing pingpong count
Date:   Wed, 20 Jul 2022 14:47:11 +0800
Message-Id: <20220720064711.16037-1-hlm3280@163.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220719174915.48f830b4@kernel.org>
References: <20220719174915.48f830b4@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgCHFb7wpNdiB5iyPg--.76S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRvtC7DUUUU
X-Originating-IP: [112.95.163.118]
X-CM-SenderInfo: pkopjjiyq6il2tof0z/1tbiSAVE+V+Fe-UYrwAAsT
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At 2022-07-20 08:49:15, "Jakub Kicinski" <kuba@kernel.org> wrote:
> On Tue, 19 Jul 2022 21:01:37 +0800 LemmyHuang wrote:
>> -	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
>> +	if ((tp->lsndtime <= icsk->icsk_ack.lrcvtime) &&
>
> Are you sure you don't need to take care of the values wrapping?
> before() does that. You may want !after() if you want to allow equal.

Yeap, I will switch to that in v2.
Thank you!

