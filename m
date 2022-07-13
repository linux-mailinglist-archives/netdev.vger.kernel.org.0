Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1A5731BF
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbiGMI6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiGMI5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:57:40 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDE4D215F;
        Wed, 13 Jul 2022 01:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657702628; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=KNaYsDeveHlOzBv1GjxVNi/T4WsP63SF/SZK6FNfjlNQmWf8NHhba1qz8OuDSMDZ3n7y383AtUFE1A0cScoUfMpeVeWPQhbV2QgrLI5LktErurgojbesbASkusDLxmFAQAkVDqhZ0+EhcY90pEjobYHyWGRjNMk6k1xTJrVCl4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1657702628; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=; 
        b=Z9lb8al4lnUqDjINI+ufYyTwadNmckwd3Uh9fiZxJpKlVx2eDqSfFMYYmtphYgkUQeuXXb+/S+GQ6bPsWWhPqIKkvFGNWvW8DiyhYTqcJD36i+2bMLdEafWB1YLoqV4G4wZTrqNa6IJog74aEXCw04z2yQ013Du4IIkKiDFCxWw=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657702628;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=BnR6M2bsB9joSRee+nJmsq+INg5DPuVgdHgoSpQIb4mXnSDekY1EOY9UkRQTxX0C
        cHPuRRz5VtrnhRrg8PDrsJGimTWBMwnN+mbPOcL8GHmdw6K7A2m9xrIQVPb/5eMsCkK
        SOlpmXGZ9t+RjbzR4UQ0jEeqTdIpHzA9WBQQscO4=
Received: from localhost.localdomain (43.241.144.124 [43.241.144.124]) by mx.zoho.in
        with SMTPS id 1657702626310445.2710759486872; Wed, 13 Jul 2022 14:27:06 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com
Cc:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Message-ID: <20220713085643.9148-1-code@siddh.me>
Subject: Re: [syzbot] memory leak in cfg80211_inform_single_bss_frame_data
Date:   Wed, 13 Jul 2022 14:26:43 +0530
X-Mailer: git-send-email 2.35.1
In-Reply-To: <000000000000f632ba05c3cb12c2@google.com>
References: <000000000000f632ba05c3cb12c2@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,URIBL_RED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


