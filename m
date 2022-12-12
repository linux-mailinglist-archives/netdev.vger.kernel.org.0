Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B286497D0
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 02:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiLLB5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 20:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiLLB5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 20:57:13 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E38D10C
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 17:57:11 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso14048334pjt.0
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 17:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gKxH5no78Aw3fUuIxx9FgLK2M2dw9VMtAOEtuM8aznQ=;
        b=hmaGj8PpDnrF2D160EemGtwJLJZO8mMN6GKRMTb0AfQgr1zRDcbULF7jvPZOu7/Zjs
         fBiMceEkephnBArfRW8qfXB5+IumP/9R7M3FMV+Bb+4gA4XgYF+yBZ58RPwnqoXql6xZ
         KrKLlDeLS4WIVVmTfXiEpxFTTaX238+UtZt4cT435LsmcfFHvnY9+a3lzV9WEBDLaehb
         YkWmGY+FhgsXGLtgxKQR3zqQEXR63ys2I8FimnG+8fLBsYQHWQXETfhqU0fKBNBVpMPZ
         kKgEcp9dA9/HmMzN8FOBon//W17ctlD/9y4hc24WkJr+WRgxcXqt83BOBaWC5MFpeKoB
         OwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKxH5no78Aw3fUuIxx9FgLK2M2dw9VMtAOEtuM8aznQ=;
        b=l9K5Dn+Qm58AX4frR7VPo5GkzINfFygO5VIOGDxBLwYOgdbWc0xHwPLGWTrXgzdEY3
         +bMWg340WLRv9xSDbRyxi+JE1XIZapj96ucvQbWiEP+gxSZOVlwfXQjqOVv4YbfTNaBB
         hTot2Q3QGFKAgYwnNjDad6x1Qugldm2xL8gcKaOsOpOQbJituriEoZPlf14lZf7ej5Zb
         hD9LIkzi35/pKS32dJRXIsOqttiNkzMqEw9ZOo7L2Srl+A0khvJgmqqlMpP9UNPzfHiI
         qboc7QQJqqGFpYljOqZLTXOw49q966a+oWSJM//sdQJPJNALpktZBtR1d5f9uic6BSIr
         lLgw==
X-Gm-Message-State: ANoB5pmPtxVuE9OqFlDPoq45y8IAUfq+4rla5w6El0iBs1KtCl8TXjwi
        J0y8CyISB04DXbJJmA3e7zk=
X-Google-Smtp-Source: AA0mqf42od8aw1NDglX1AsNVUw2zccBye9ojF11kycvcoPaEWOF2ZQDIdPiSVw3rTCF/A04LMIjOOQ==
X-Received: by 2002:a17:903:181:b0:189:9007:ecef with SMTP id z1-20020a170903018100b001899007ecefmr20808154plg.25.1670810231136;
        Sun, 11 Dec 2022 17:57:11 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902d50800b00174f61a7d09sm4950111plg.247.2022.12.11.17.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 17:57:09 -0800 (PST)
Date:   Mon, 12 Dec 2022 09:57:05 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, liali <liali@redhat.com>
Subject: Re: [PATCH net 1/3] bonding: access curr_active_slave with
 rtnl_dereference
Message-ID: <Y5aKcYFp9ounWJM1@Laptop-X1>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
 <20221209101305.713073-2-liuhangbin@gmail.com>
 <CANn89iK8TEtpZa67-FfR6KFKAj_HCdtn3573Z9Cd7PG26WP3iA@mail.gmail.com>
 <Y5R7ZDfKkZKZe9j1@Laptop-X1>
 <CANn89iKh3M+mL_Yh_oAX0T6b9mAu6_JZKZwunH377bJNusuTKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKh3M+mL_Yh_oAX0T6b9mAu6_JZKZwunH377bJNusuTKA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 06:41:01PM +0100, Eric Dumazet wrote:
> Now, you post a patch for bond_miimon_commit() which already has :
> 
> if (slave == rcu_access_pointer(bond->curr_active_slave))
>       goto do_failover;
> 
> So really it is a matter of consistency in _this_ function, which is
> run under RTNL for sure.

Ah, thanks for the explanation.

> It is also a patch for net-next tree, because it fixes no bug.
> 
> I would not add a Fixes: tag to avoid dealing with useless backports.

OK, I will do as your suggest.

Cheers
Hangbin
