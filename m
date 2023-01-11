Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C9E6655DB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjAKITr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjAKITk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:19:40 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D32D5F99
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:19:38 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id jl4so15997649plb.8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XGrxh5RU1Q9X5xnd06++hlbzr5xDY2Wv8eguXMCmuQ8=;
        b=BorcWx8o+oTOqTKzgqgjnCr6QxuUNH80ocGTwKkMrgzdxxsO85cZLtVLDfq0KAUquO
         UpyT7BK9pVj+RFGaTAX7QIGZbUfFEC9rTG0ABk1Cp0pSYehAYz6hFTApsJcaTlZr5mFF
         QOMUtg+dGAVne2avL1kqxz1seqMMnui7rp12UrA/c9WPjRcUxGuy2Bht8+jNjofhTi7J
         EoX9LYnN2Uc4WBGBs4XqztUZ+UcjYNKGmrFHBJko7PfUJD5QHv9oxF+fshFqBV5etVVK
         jj7pNtYybJAbT+mNHSK/hX3pYvpU+clq1Gi5/DLnOi+RJbgwWBWFIeBhRv5dr3uzMR/5
         2t8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGrxh5RU1Q9X5xnd06++hlbzr5xDY2Wv8eguXMCmuQ8=;
        b=8M1WUUJswxpdvCuu6NlU0MUbwRAXwFRqUUA+ucFXohy7fXv807dfgdJ1J8ZjWqRy6S
         Spg/u6XhzoO60GIELIYvpmcJqDJowaYzqqq7JZYiGjjF/NzhYFDJ09ETV6xwFim2gO1U
         TQL9u+hTGGEQu7kUlLOEq6gxrR18UTS3wawN4F0/1b1PiRHTmZkK8RKNHCpVqFR/wYlz
         6cN/qPNUmRZ31QbvDvnqer+CTkNMWT47O0nkcpLhRql/RMJFHLgLh0NCK59ByiY/m3/r
         qmB7RLv5q6394fWLs27XC0KE+jPVoPu5LFdVv2qTWdPC/x5yuafEX+izdoNiTJQhSZM1
         prDA==
X-Gm-Message-State: AFqh2koe+iNtSuQxCAagHBVgK7v6CPnCiHJLuuqNNIM6PQMbHtz7LkYr
        lXXH3QzOK7XXzs6TlLfoD6hBvoLauHGlnolc98jc4Q==
X-Google-Smtp-Source: AMrXdXv8HEGTtHE38l6uIqkffBd2HJNr7lYLCc9XR2w8PzGrwGHjx8fKXytQGmrKPSCOQLMTsj6lrA==
X-Received: by 2002:a17:902:c94b:b0:189:76ef:e112 with SMTP id i11-20020a170902c94b00b0018976efe112mr95588728pla.41.1673425177760;
        Wed, 11 Jan 2023 00:19:37 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id v7-20020a1709028d8700b00186bc66d2cbsm9582949plo.73.2023.01.11.00.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 00:19:37 -0800 (PST)
Date:   Wed, 11 Jan 2023 09:19:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Maciek Machnikowski <maciek@machnikowski.net>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y75xFlEDCThGtMDq@nanopsycho>
References: <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org>
 <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230110120549.4d764609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110120549.4d764609@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 10, 2023 at 09:05:49PM CET, kuba@kernel.org wrote:
>On Mon, 9 Jan 2023 14:43:01 +0000 Kubalewski, Arkadiusz wrote:
>> This is a simplified network switch board example.
>> It has 2 synchronization channels, where each channel:
>> - provides clk to 8 PHYs driven by separated MAC chips,
>> - controls 2 DPLLs.
>> 
>> Basically only given FW has control over its PHYs, so also a control over it's
>> MUX inputs.
>> All external sources are shared between the channels.
>> 
>> This is why we believe it is not best idea to enclose multiple DPLLs with one
>> object:
>> - sources are shared even if DPLLs are not a single synchronizer chip,
>> - control over specific MUX type input shall be controllable from different
>> driver/firmware instances.
>> 
>> As we know the proposal of having multiple DPLLs in one object was a try to
>> simplify currently implemented shared pins. We fully support idea of having
>> interfaces as simple as possible, but at the same time they shall be flexible
>> enough to serve many use cases.
>
>I must be missing context from other discussions but what is this
>proposal trying to solve? Well implemented shared pins is all we need.

There is an entity containing the pins. The synchronizer chip. One
synchronizer chip contains 1-n DPLLs. The source pins are connected
to each DPLL (usually). What we missed in the original model was the
synchronizer entity. If we have it, we don't need any notion of somehow
floating pins as independent entities being attached to one or many
DPLL refcounted, etc. The synchronizer device holds them in
straightforward way.

Example of a synchronizer chip:
https://www.renesas.com/us/en/products/clocks-timing/jitter-attenuators-frequency-translation/8a34044-multichannel-dpll-dco-four-eight-channels#overview
