Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519354C9034
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbiCAQW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiCAQW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:22:27 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F771AD9E;
        Tue,  1 Mar 2022 08:21:46 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id gb39so32562636ejc.1;
        Tue, 01 Mar 2022 08:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jx8eZ/jgrSE5jtq/IeRwHlPFovNus3LfRlDhg1AW13A=;
        b=en9t2M3R/YDinK1EfneMzgv5fnKSDbV2GexbGi8qUVmwTSDoEp15UHwZA/M2o65vTS
         1amV/o9IYHjiDxmjxen42QPAkYKpPfbSgHnHpSavW1XfsTw58PopoiG6cKAbBHAUIh80
         Z9vXf90FSFzOih7QWrwZWVuvpsy21CRZGjywUCXNukoL5p8tTEzXYMkVKhBYpK7eeQp1
         iB71j6/AwNLOcWKUYtR2hDgFxCZC/LqpqjPme7lTy8Lh7Q6qlP0sr34zBSPk7aMnM/gD
         TaZi52W9EXR5i0OekbRJVPsXfV+ELpeg9leOt1TkHdfXLGOy0pvBzQ4B3q69dCXgfx6T
         Y+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jx8eZ/jgrSE5jtq/IeRwHlPFovNus3LfRlDhg1AW13A=;
        b=UH+lNVu3OhqkCZKYJwtLSSNPUdJX8WbISSLiMP2WuNKn+vyjB1H1yWRW7WdNw236Y5
         VgR0nNOhBBAAY4Hp4lqjsaGbIeNsE0sCAu8Jfb+WXaUQdLNFWdzIOXf2nu80KjO6nA5L
         stKJJODVhAX5kxQ2Fclxtvrs58HFZPmrzCS/A+Y/1K6v7lyBCMhgmq8CFSKvZjUKubE3
         Ma8fDg9IET0qk6NC5ZcfTPw23NWRvbeFttvL1d6Vfe4XzKXZzJ6htI/4YEJW9RFVYiNJ
         xvaO7wOv4n+EBrlktUJGs136gOV6GulOtKr/esZRUU5syuL/cBYiAn6B/V1/Wuv/qSPd
         kqKg==
X-Gm-Message-State: AOAM5302IOmnJ8do9msrMHVzFBf8EyuRpbvrWlNG8Z59iwNvPkcv1Wvn
        2ufeijIs7J62HKhEbv8M5Qk=
X-Google-Smtp-Source: ABdhPJxGtOTYdS7L0n3Cy3fp114D1jiHE3zZ+VjSMi5+/5L86y6D2puo9eWWttxwjz7E6uhYGujEWA==
X-Received: by 2002:a17:906:3ac6:b0:6cb:6808:95f9 with SMTP id z6-20020a1709063ac600b006cb680895f9mr19934324ejd.375.1646151704776;
        Tue, 01 Mar 2022 08:21:44 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id ey10-20020a1709070b8a00b006cee56b87b9sm5486818ejc.141.2022.03.01.08.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:21:44 -0800 (PST)
Date:   Tue, 1 Mar 2022 18:21:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 00/10] net: bridge: Multiple Spanning Trees
Message-ID: <20220301162142.2rv23g4cyd2yacbs@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301100321.951175-1-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Tue, Mar 01, 2022 at 11:03:11AM +0100, Tobias Waldekranz wrote:
> A proposal for the corresponding iproute2 interface is available here:
> 
> https://github.com/wkz/iproute2/tree/mst

Please pardon my ignorance. Is there a user-mode STP protocol application
that supports MSTP, and that you've tested these patches with?
I'd like to give it a try.
