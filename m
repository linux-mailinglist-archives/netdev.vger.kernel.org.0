Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63A84E3032
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352289AbiCUSob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349327AbiCUSoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:44:30 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176C9237E5
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:43:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bg10so31667776ejb.4
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UfGlKa97+IjPHQJ27HS8sYX9gpAo0pAQU6JZjDjy53w=;
        b=QZ5BF7JqV+/wXJE31fU0Sk8OiTj6syzTFmGgaWe6kN0W7TSwMIwPudp50udRfzIcMP
         5TpfgZjTyeZoGAWawueW3YkI3KtPDWWjWcax6BteTEhCZRoPfbA7pa8sCtf2OK5coeyT
         LNNR6H77+ayLsLqPVf778RnOWc4TXdWF8MU1RxqH572kv4kqGQLot+Ct6B8fSlzWIXRN
         mVDKDBpTSiXPy165BNUGnOb9wFp4Dd3kfHo38bxdnYfs8UuW1Pgu9tKViCJJGLSfaq2C
         8CFlJp5hUFSYI2hAllWWi2yopQX7XqpKuZs7fsbr6XGPX2nwVQ015Z9/gRJaf8Pk/W1k
         MrYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UfGlKa97+IjPHQJ27HS8sYX9gpAo0pAQU6JZjDjy53w=;
        b=aqaFyISSYJYOnZxWfRcp+WVVYA0AZMizwiqH3LL2XTxlwEJqIT2JhRFV3R6oxBLni8
         wL3HdJJc7H26DFpsVVIXyiuDLqixcAWfHbq1YhU3665lHNxFrxkz7N5Kq66TBc/UwXjO
         bbAx1n0XcHL5zmCIABHTPooDETl2X3Q07EIHUg9idzeQO/wJfNpfqsBf1rCdZ3+wL5US
         pf5GrbvnY/wOJtEHXl367MWunHS8Fl3qXEc9yRCtk7VyETyNfZnjDv1C/P6l5yMG9hTw
         U78SaWIzzuZV1v7hOPJmgUyU+Y0CsNBgyOJ/ZD9mkilOjdh/oufGxM2MCe7KmqTS252B
         8i1A==
X-Gm-Message-State: AOAM532+rLX4nNdhn07YF4zSw68JnjLODCE9iscmbpIhOjpfUofdyFqP
        nkug7yGYPN3WdkSL2PeehBk=
X-Google-Smtp-Source: ABdhPJwbFgBxk3c+uxZOcC7G9tkQvIVLO6Jy/CuYgQNA6ZSQLuvdydFyKwcgpF78NPpKq4yZtOxMzg==
X-Received: by 2002:a17:906:5cb:b0:6cf:954:d84d with SMTP id t11-20020a17090605cb00b006cf0954d84dmr22631028ejt.560.1647888181445;
        Mon, 21 Mar 2022 11:43:01 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id b8-20020a056402350800b00419407f0dd9sm1640990edd.0.2022.03.21.11.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:43:01 -0700 (PDT)
Date:   Mon, 21 Mar 2022 20:42:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Possible to use both dev_mc_sync and __dev_mc_sync?
Message-ID: <20220321184259.dxohcx6ae2txhqiy@skbuf>
References: <20220321163213.lrn5sk7m6grighbl@skbuf>
 <SA1PR15MB513713A75488DB88C7222C2DBD169@SA1PR15MB5137.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR15MB513713A75488DB88C7222C2DBD169@SA1PR15MB5137.namprd15.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 06:37:05PM +0000, Alexander Duyck wrote:
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Monday, March 21, 2022 9:32 AM
> > To: Alexander Duyck <alexanderduyck@fb.com>; Jakub Kicinski
> > <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Florian Fainelli
> > <f.fainelli@gmail.com>
> > Cc: netdev@vger.kernel.org
> > Subject: Possible to use both dev_mc_sync and __dev_mc_sync?
> I hadn't intended it to work this way. The expectation was that
> __dev_mc_sync would be used by hardware devices whereas dev_mc_sync
> was used by stacked devices such as vlan or macvlan.

Understood, thanks for confirming.

> Probably the easiest way to address it is to split things up so that
> you are using __dev_mc_sync if the switch supports mc filtering and
> have your dsa_slave_sync/unsync_mc call also push it down to the lower
> device, and then call dev_mc_sync after that so that if it hasn't
> already been pushed to the lower device it gets pushed.

Yes, I have a patch with that change, just wanted to make sure I'm not
missing something. It's less efficient because now we need to check
whether dsa_switch_supports_uc_filtering() for each address, whereas
before we checked only once, before calling __dev_uc_add(). Oh well.

> The assumption is that the lower device and the hardware would be
> synced in the same way. If we can't go that route we may have to look
> at implementing a different setup in terms of the reference counting
> such as what is done in __hw_addr_sync_multiple.

So as mentioned, I haven't really understood the internals of the
reference/sync counting schemes being used here. But why are there
different implementations for dev_mc_sync() and dev_mc_sync_multiple()?
