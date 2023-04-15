Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4449A6E2ED8
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 05:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDODn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 23:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDODnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 23:43:23 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099FD5270
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 20:43:21 -0700 (PDT)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2C0CC3F19A
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 03:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681530197;
        bh=6ZHt2V6/8rabY9GdEMudRVGwciilpr0JArfWYlj6uzI=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=nkMiuB549C8i86cfBfUdWFWL+iMYmH4E60o3OyXP/arYk7HHL86y9kNuB9QRM1AKJ
         VRtHVw93GdAwujSgCPrh1hUBCPKqscqfbj/JVyKNpjHpLtUgScyJnetntYf2dXuxPO
         wgDHDC6ylH19dQUCWNpvcelvDugMG4AfytawnXSYNehks2O+PqCcH2SuKdqcXyrXhL
         F0Vk41goz4Ry8SPk4Bm3AVZP5y1BqqZmSBpKvvBvg7M6QH1YKlSBp+t/1ZBXG87WfL
         gQJgHaSfU3csGhy0hWnI/P3Njx/7BfCKTn6e2BynOUFZildVPmgQmdL5xMD57dPFeC
         UUmgiMvfMOSxw==
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-63b49e9d1e5so519742b3a.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 20:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681530195; x=1684122195;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZHt2V6/8rabY9GdEMudRVGwciilpr0JArfWYlj6uzI=;
        b=UhZm3Ch3BhzrPnx+2WIq6VlYZnvSIYektIqnWJrINJnPlLXTk8RUu5DjaZFEcokF3T
         uNcCmBGR0pH5Wjkk7mxsZBABEedBtDvEBB3Spr8/8gBlaT9MuIWI0LoWPNyOHLNrSP2P
         G14o6F6DzUTqKg0TZucK86+ljf4b7BOhqNZx7+Ji2a+jWvUqv/TS6mxyrPmU/awagmSB
         I9RoFDfpFL0rdvyuL8o8e10GenSQ5kny6P2eBSE/pTLuiwMUH2Qehz2GTMu6ZTy60BHh
         sfY/QmbHMKeGJc9mcCmiwSd/6BNvqnt1j0zLYXcrRcy6ni2UYI9Xjbb0W8toQ/KAzf+u
         eo8A==
X-Gm-Message-State: AAQBX9e18TeYFIfwnOJbWeFpa8J4KtXgnNOqatJMPr+yDtITeJCms/QM
        xDHXzhz4xSSDRXvydAmFAMKfo8rBkvxg72vAbkKZTxcEf2e+G2XGRW3ykO7Z8xBwXqCN3riNz+c
        zNpjweN9O7zquveZG3j1mmtA0eAV5YOwbvQ==
X-Received: by 2002:a05:6a00:228a:b0:63b:1708:10aa with SMTP id f10-20020a056a00228a00b0063b170810aamr12094530pfe.34.1681530195542;
        Fri, 14 Apr 2023 20:43:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZJsXoXKN5HIBnM2h1+bTmS3cYA5sY0FBBPeeKUdmSGBadFKocRg3tHJ1ScKTGQ+XqVxHaCag==
X-Received: by 2002:a05:6a00:228a:b0:63b:1708:10aa with SMTP id f10-20020a056a00228a00b0063b170810aamr12094508pfe.34.1681530195270;
        Fri, 14 Apr 2023 20:43:15 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id a22-20020a62e216000000b0063b642c5230sm2113236pfi.177.2023.04.14.20.43.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Apr 2023 20:43:14 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 520FD61E6E; Fri, 14 Apr 2023 20:43:14 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 49C309FB79;
        Fri, 14 Apr 2023 20:43:14 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv4 net-next] bonding: add software tx timestamping support
In-reply-to: <20230414180205.1220135d@kernel.org>
References: <20230414083526.1984362-1-liuhangbin@gmail.com> <20230414180205.1220135d@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Fri, 14 Apr 2023 18:02:05 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6104.1681530194.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 14 Apr 2023 20:43:14 -0700
Message-ID: <6105.1681530194@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Fri, 14 Apr 2023 16:35:26 +0800 Hangbin Liu wrote:
>> v4: add ASSERT_RTNL to make sure bond_ethtool_get_ts_info() called via
>>     RTNL. Only check _TX_SOFTWARE for the slaves.
>
>> +	ASSERT_RTNL();
>> +
>>  	rcu_read_lock();
>>  	real_dev =3D bond_option_active_slave_get_rcu(bond);
>>  	dev_hold(real_dev);
>> @@ -5707,10 +5713,36 @@ static int bond_ethtool_get_ts_info(struct net_=
device *bond_dev,
>>  			ret =3D ops->get_ts_info(real_dev, info);
>>  			goto out;
>>  		}
>> +	} else {
>> +		/* Check if all slaves support software tx timestamping */
>> +		rcu_read_lock();
>> +		bond_for_each_slave_rcu(bond, slave, iter) {
>
>> +			ret =3D -1;
>> +			ops =3D slave->dev->ethtool_ops;
>> +			phydev =3D slave->dev->phydev;
>> +
>> +			if (phy_has_tsinfo(phydev))
>> +				ret =3D phy_ts_info(phydev, &ts_info);
>> +			else if (ops->get_ts_info)
>> +				ret =3D ops->get_ts_info(slave->dev, &ts_info);
>
>My comment about this path being under rtnl was to point out that we
>don't need the RCU protection to iterate over the slaves. This is =

>a bit of a guess, I don't know bonding, but can we not use
>bond_for_each_slave() ?

	Ah, I missed that nuance.  And, yes, you're correct,
bond_for_each_slave() works with RTNL and we don't need RCU here if RTNL
is held.

>As a general rule we should let all driver callbacks sleep. Drivers =

>may need to consult the FW or read something over a slow asynchronous
>bus which requires process / non-atomic context. RCU lock puts us in =

>an atomic context. And ->get_ts_info() is a driver callback.

	Agreed.

>It's not a deal breaker if we can't avoid RCU, but if we can - we should
>let the drivers sleep. Sorry if I wasn't very clear previously.

	Understood; I should have remembered this, as it's been an issue
arising from the "in the middle" aspect of bonding in the past.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
