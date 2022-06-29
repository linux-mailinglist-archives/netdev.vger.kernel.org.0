Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DB655FE74
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 13:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiF2L00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiF2L0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 07:26:25 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43032366A6;
        Wed, 29 Jun 2022 04:26:23 -0700 (PDT)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25TBPrmA028405;
        Wed, 29 Jun 2022 13:25:58 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 6D12D12007D;
        Wed, 29 Jun 2022 13:25:49 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1656501949; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WHNvNMh0qy4/2nFNj4xXiPVw5E4I7VYRnMjX23AAHE=;
        b=etyKLL1sKgShp8uJfjy7chg5QA9x0ftdTu5NY184fw+nQnHXwGBZtTSdzDmjVliz2Ln+j0
        KBlnhVBkyD5WCACw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1656501949; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WHNvNMh0qy4/2nFNj4xXiPVw5E4I7VYRnMjX23AAHE=;
        b=YA+rzY8kK+Brre3mbdKrbt0sOsdSi769PYPR+MccHSiZqkpnmncZSVAoH83H19bA6Fnxkn
        4uIFQCafVM01K2VFY++E+0dZ6C/q1ZT48xfyrHY2SrmecfiO55GTCLtmpNpYtv1ico7K3n
        pskxxxu4poKROj1K3AbTE8flVNBopXHruZcCkYad4Cx6WvmB6Y7DCb/pfk6ZyzmFFDNdUl
        fmHcy4XxWd/tE0biWVvZJ2U3AK+qL0jcUmln+ej3YH9QrWZwVgkJLVxu/0rLvES40XFyDk
        gBHJzWkGDFUW7gG5xBKEyCIr1b3yOZHW0kLRf/NEElTT/isrbLwegskBaGbS9g==
Date:   Wed, 29 Jun 2022 13:25:48 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v3 0/4] seg6: add support for SRv6 Headend Reduced
 Encapsulation
Message-Id: <20220629132548.60b564b132d151cbf750ded5@uniroma2.it>
In-Reply-To: <20220628221056.48b5028f@kernel.org>
References: <20220628113642.3223-1-andrea.mayer@uniroma2.it>
        <20220628221056.48b5028f@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
please see below, thanks.

On Tue, 28 Jun 2022 22:10:56 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 28 Jun 2022 13:36:38 +0200 Andrea Mayer wrote:
> >  - patch 2/4: add selftest for SRv6 H.Encaps.Red behavior;
> >  - patch 3/4: add selftest for SRv6 H.L2Encaps.Red behavior.
> 
> Always great to see selftests. Should they be added to the Makefile?
> Otherwise they won't run unless someone manually executes them.

Yes, you are absolutely right. I will send a v4 with the correction shortly.

Andrea
