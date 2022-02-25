Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A894C4CE1
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiBYRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiBYRwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:52:30 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A96223110
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:51:58 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i21so5274001pfd.13
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLpWUun3lKpSiBMB61OgUcBmPu6Hi4PPxLrKX6S+IIY=;
        b=K3qz9S/3/IBh11vpuF3qldmxf8a7p8Gukqg8CV0G2zuIPnsVmJ/XD9FPbNLojam7Gn
         l6sxKaSmZOCBMl0qc/uQvUWvHous6S6klFvCaYx1VY1kccyACsG4KPBPrc5WFYhqPOOu
         lB7I630hPONG+vh+aqOXvZ7rOihFRjhzbNnK9mxfdz40Bod24YBg3WhDgv8gsRiQVWBs
         bQOKJmnQsSm69geNeUEJHcpxUDFnsvmzUcfosid93c7zsgV2NXuDDnmXQIzJpPlpZFAK
         lNp29JvCgO0iebZi11IDz54Ab9PxpK7/IpykLu7CIxxVkK6U21nwcuC77hNIxGcYj6FP
         9fAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLpWUun3lKpSiBMB61OgUcBmPu6Hi4PPxLrKX6S+IIY=;
        b=5aJt6whrrO10qH4ePpeDqEbmFIJ41h4O+er9RaNJDBDLfodXBerMPqnaZmuOTgx9Y/
         fXuBwVSLLYCcWN/161WdwR9dHpc5jWbGnORpDrqYZfJRZOvnlWRESQwJ8dRsurz0RY/b
         4PJj9eSwvkfeDcGkBogw1fpmbTOS1k3AlM0qm/LFR8gvOm1aKkPrjjlGwUZXi+Q9LwmF
         CfE/DNAfAvhvApnQjrb0JpWyt38GmMyWKZvNa3dCNmpNw9dyWg3LY3ynh1VP29uyQ1Pc
         Xx1bh8HAeUrms7EgZ4Uhw0mwcOtz7dr7TitijXpMb4tnD5raPHSpYZXlqzL9mfKmYgWX
         KxrA==
X-Gm-Message-State: AOAM530E8Bxonbz9nJJyMIw8AbBWn67UDRKSYNicpu/Kz7UT9voy3Fqq
        b9lXzbXyayPHZjqX92BAVvVLDisE5NgjxVNO
X-Google-Smtp-Source: ABdhPJwqyryOATo9ZLkT3wL8sL3TFjcG+eDbqM6wNC2sBmf83Sx+0i4FIoIk3AnNQTxstOgtx7D0zA==
X-Received: by 2002:a63:91c8:0:b0:372:ba54:7ec2 with SMTP id l191-20020a6391c8000000b00372ba547ec2mr6935850pge.131.1645811517488;
        Fri, 25 Feb 2022 09:51:57 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id v189-20020a6389c6000000b00372e3b6fe90sm3326723pgd.55.2022.02.25.09.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 09:51:56 -0800 (PST)
Date:   Fri, 25 Feb 2022 09:51:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH iproute2] dcb: fix broken "show default-prio"
Message-ID: <20220225095154.7232777b@hermes.local>
In-Reply-To: <20220225171258.931054-1-vladimir.oltean@nxp.com>
References: <20220225171258.931054-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 19:12:58 +0200
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Although "dcb app show dev eth0 default-prio" is documented as a valid
> command in the help text, it doesn't work because the parser for the
> "show" command doesn't parse "default-prio". Fix this by establishing
> the linkage between the sub-command parsing code and
> dcb_app_print_default_prio() - which was previously only called from
> dcb_app_print().
> 
> Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  dcb/dcb_app.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index 6bd64bbed0cc..c135e73acb76 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -646,6 +646,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
>  		if (matches(*argv, "help") == 0) {
>  			dcb_app_help_show_flush();
>  			goto out;
> +		} else if (matches(*argv, "default-prio") == 0) {
> +			dcb_app_print_default_prio(&tab);
>  		} else if (matches(*argv, "ethtype-prio") == 0) {
>  			dcb_app_print_ethtype_prio(&tab);
>  		} else if (matches(*argv, "dscp-prio") == 0) {

This is an example of why matches() sucks.
If we add this patch, then the result of command where *argv == "d"
will change.

All those argument handling should be using strcmp() instead.
Should have required that before merging dcb. David and I should
have caught that, too late now.
