Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19E664ADE0
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiLMCnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLMCnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:43:06 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADD320E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:43:06 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 4so8174004plj.3
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2STqmQxfNYsmd1vTSGGXb3ybqNfgzW9zyynrq1LISOQ=;
        b=N1Hn8P1ixeFFcTqZT/KcSKuwhh56TQNlaHxKk8nxlfffUktGoG29iDzKS2hZhA8llX
         TfPADdYl8SwQDbMR8MUgq76/1PrBTNlYLIWAw6vq8VkDZd9MhI3/uc6aJPK5eGvYimUn
         ns4Q/iO7/gS7/pt1r0s0Ze/DsEjdutFhHJQPu7G+jlFOzP5GPvtCYluVbfMHe5VQWXdy
         rZUfc9smaadUwTPHdN0p43IVpHlPN4pwrt8YRBwyZZTB5GVt3xDP5BiciaSLzedSVC7S
         bI5BPYDBcXP3ZwJK3757SQBybB4vSvwRBnR9lKIAOfkxeEH7Y1Pu0fIp1OzZESHa4aYL
         kZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2STqmQxfNYsmd1vTSGGXb3ybqNfgzW9zyynrq1LISOQ=;
        b=KvX+oPAc0yATtphn3fCfAYqv+/v5G04qFyGEyJrO1AFFQzuyvtgUZwzhoHZspuwx/C
         tNUeV1oPDwTTovZWlDKvw5PCjmn6LPlGSZOylA9ujNK0jJRdL54H2JDOV1I7wpHdDX8n
         xwXadltY94aSzwvAIo4e8FabqNHe2HN8xoJEqeDxiSrESdiQ7irVJIWCYq0ZO1uF/B8c
         crJ/2uGwc1oLgVNGNJphXeQUu/ujOi+DfkRnehma37hSnCny7qi1C9E+B8WvD3tpfPML
         ckiZH2ONNE33S3oU3QUfYCq2V/g0mPfR5XB7CSmgtZ8NGbmwVLFRh5uBG2y041lvigic
         yRzA==
X-Gm-Message-State: ANoB5pmHZK9WANZKaf34mP7XSHMHhP5eOEyX+Bl5cK5pdWmQzgU9uoGd
        d+pWS+5+5e8O3DW7ogw5hwc=
X-Google-Smtp-Source: AA0mqf7YrTcjLzABnqnuPI8Gt36tBmUv6mvBwjJDp5QWXuOH9V03b6uYrN8HtriV1Hd4ewdqqGv4CA==
X-Received: by 2002:a17:902:9349:b0:189:b0ff:e318 with SMTP id g9-20020a170902934900b00189b0ffe318mr18744615plp.1.1670899385639;
        Mon, 12 Dec 2022 18:43:05 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i4-20020a170902e48400b001891b01addfsm7056484ple.274.2022.12.12.18.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 18:43:04 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:43:02 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Kolacinski, Karol" <karol.kolacinski@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net 1/4] ice: Create a separate kthread to handle ptp
 extts work
Message-ID: <Y5fmtn+HfX5xYYKL@hoboy.vegasvil.org>
References: <MW4PR11MB58009DD3EAA0A235BB8F347986E29@MW4PR11MB5800.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB58009DD3EAA0A235BB8F347986E29@MW4PR11MB5800.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 11:24:22PM +0000, Kolacinski, Karol wrote:

> According to do_aux_work description, it is used to do 'auxiliary (periodic)
> operations'.
> ice_ptp_extts_work is not exactly periodic as the work is queued only when the
> interrupt comes.

You can use it in any way that you like, periodic or not.  The return
value from the driver callback determines if and when the next
callback occurs.

Thanks,
Richard




