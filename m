Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70F557DA22
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiGVGP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiGVGP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:15:59 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6285E193F0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:15:58 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id j22so6908679ejs.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8N8Izyhyoniu6wTpZv2RmdqiTQu5pTGXcExtMuykMtE=;
        b=Sd6ciAZQI+3OjHjT94IsbCQ/NdlEswLk74P82/OyTGrjLxNRQRNYBXbVsbScwqX5nF
         zkVvuN9amJd0IwF2KRTmob3eFMFB6nvy40ufUJzcdoUnIfJf7L70/g+ZcAkPo7G4DGIU
         mdX3VnK6z1mJvTedN20yZP7xHkNMZnxU2ABrxjOGT7n6yLY2pI/mXuH2kEZQP9OuIB08
         2ME4Luc69QBytadUirXcdw6Hw1gGzeRxzIMXPiG+itK+wQzLKyCgP1MDTD9BqD7frF7K
         5L7j//8UsDc+/mnbUwOtKYPetgR7ZANJfgErYK7DgN1vNnalQgq4Qr/3tkw3OUgJnO7I
         1hdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8N8Izyhyoniu6wTpZv2RmdqiTQu5pTGXcExtMuykMtE=;
        b=XjWM58xXTkqevkGOWr1J8Diru7vdfdYMvQt/uIWZOv4uJqTfeITUL0/29OOMf7qunr
         1x4DaKDRPe9gB/uIHylExG2ceB7jvxQHeDpNUlfgbQy+O3jv8Qc+79Sv+qwY9OKZ56Qd
         PJEKT8YXD8Ge1dDitFjvjE0kbx/8pDUY4HE5LBcDe80IKrJHBXH9Cj8O78wvdLWQd+YD
         DsJtqqjN78YkmvBGG9R54YH58wA+YuE5wcflLBmMLJnka9rEgNjYyhst35bCrZHfIZF6
         ilpXXLee3ufBdUlX9hmAEooJoPE93gmu19OIDZN+SsEdtbPv8Oc3q/C0NiyT358LCHDV
         qfqg==
X-Gm-Message-State: AJIora8rNgN756HASkKh4dJ0aPIDKZdfLbP3SanFZeNSrF37ypO3hGcC
        GGXiBuZUn6er6Bd7EwTh4wueEw==
X-Google-Smtp-Source: AGRyM1s+qQtqDRI+mnN9AvHNyiwFRu8khdftjtaG/Hh5tVh37lNwyZMu7T9k7lzkCks9YO2n6zoGXA==
X-Received: by 2002:a17:907:2c78:b0:72b:64f5:11ea with SMTP id ib24-20020a1709072c7800b0072b64f511eamr1922496ejc.68.1658470556767;
        Thu, 21 Jul 2022 23:15:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id en21-20020a17090728d500b0072b342ad997sm1630098ejc.199.2022.07.21.23.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:15:56 -0700 (PDT)
Date:   Fri, 22 Jul 2022 08:15:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "snelson@pensando.io" <snelson@pensando.io>
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtpAm245yK9pfQ+d@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <SA2PR11MB510087EB439262BA6DE1E62AD68E9@SA2PR11MB5100.namprd11.prod.outlook.com>
 <Ytjn3H9JsxLsPQ0Z@nanopsycho>
 <SA2PR11MB5100CD9D0CBCDB2D0F76271CD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA2PR11MB5100CD9D0CBCDB2D0F76271CD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 08:55:04PM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Wednesday, July 20, 2022 10:45 PM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
>> idosch@nvidia.com; petrm@nvidia.com; pabeni@redhat.com;
>> edumazet@google.com; mlxsw@nvidia.com; saeedm@nvidia.com;
>> snelson@pensando.io
>> Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
>> devlink_try_get() works with valid pointer during xarray iteration
>> 
>> >Is it safe to rcu_read_unlock here while we're still in the middle of the array
>> processing? What happens if something else updates the xarray? is the
>> for_each_marked safe?
>> 
>> Sure, you don't need to hold rcu_read_lock during call to xa_for_each_marked.
>> The consistency of xarray is itself guaranteed. The only reason to take
>> rcu_read_lock outside is that the devlink pointer which is
>> rcu_dereference_check()'ed inside xa_for_each_marked() is still valid
>> once we devlink_try_get() it.
>> 
>
>Excellent, ok. Basically we need the RCU for protecting just the pointer until we get a reference to it separately.

Yep.


>
>Thanks!
>
>In that case:
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks. I will send v4 soon wrapping this up into helper as Jakub
requested.

