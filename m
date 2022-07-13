Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AF05731C2
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiGMI66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbiGMI64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:58:56 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EA42AC79;
        Wed, 13 Jul 2022 01:58:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657702718; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=KSE9rX+6s1NM/wQkA/Q5L1JMp6dgNudMlxphCAGCMsSo9IbU68YG329KkgXj+WMO/hfQyzgbYQyALnOuzQB4L0r2RB/Qp+IYmw2xMrPadNhIT0pEpakCRrCtnlkpnhjyReXboDyosAWHh0n/RcdQG0BvSvLffr1sjH90cHIC/QY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1657702718; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=AC/hjKF1VPu1YX1L60ydQLw3GJ+ZgbFwpNxSQpnhjbk=; 
        b=ZSc9lddKjWGjjMW2uH46gRy/iS5s+a6YiZtsQNs59uWQbDAy230xvtabnBsAVD0ieTptXLswhZvRAvXqbxL6rXPxIeCpYt7icCx9cj6UuzpAb1E0wYLGDOdSrW87WTrM49/Vd84wI/jr+VDqa/sBc6kkyhiI6MfDDVF2Ea0hoBg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657702718;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=AC/hjKF1VPu1YX1L60ydQLw3GJ+ZgbFwpNxSQpnhjbk=;
        b=Bda0A+xwDEXGKcMHm0ENk6vBhR+RhC9Ta20GvHekEg5yNM4Jc4q1OYfDnv/oFKZg
        8JClN7nx58b9CEg4q98VsafEjtBmo8abMENMwId4J6x+X/Lo0lr8Cc3D7xuheKXVt+L
        VJ++pApq5PhnG8KoCiolXwImTYCJqdT9yTaZVZy0=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1657702706807202.27227209622697; Wed, 13 Jul 2022 14:28:26 +0530 (IST)
Date:   Wed, 13 Jul 2022 14:28:26 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "syzbot+7a942657a255a9d9b18a" 
        <syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com>
Cc:     "davem" <davem@davemloft.net>,
        "johannes" <johannes@sipsolutions.net>, "kuba" <kuba@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "syzkaller-bugs" <syzkaller-bugs@googlegroups.com>
Message-ID: <181f6c7ee61.6fd1462c198214.9029235269763018181@siddh.me>
In-Reply-To: <20220713085643.9148-1-code@siddh.me>
References: <000000000000f632ba05c3cb12c2@google.com> <20220713085643.9148-1-code@siddh.me>
Subject: Re: [syzbot] memory leak in cfg80211_inform_single_bss_frame_data
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,
        T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
