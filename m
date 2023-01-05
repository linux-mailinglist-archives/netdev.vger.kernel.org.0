Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12ACB65E742
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjAEJEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbjAEJEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:04:00 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D4750E41
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:03:56 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bs20so33341791wrb.3
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8DK5n35g6oFdbbF8RC/yMlCO4WIVT2pppc9FBF6r6uw=;
        b=IP0aNWak/QTyTeExI6eaKYDVuczDhHkmpbIMY/imSmpDyWM76S6iF3AM9h7D4NWOmu
         Q2cpyAb1QEP3GxdnvDkGZue2YOGE2vWwqWu0lh6ZJ1afkP+dOzFT8H28XUQRkF1aDX7L
         Eb4RJ6NaOL0BjMCDt7eYeapZs6FcqGKvMyIL2zUJJk/wLI3EQsbF1SdiKzCqF3kIVSBG
         d8vv+VXt1U4IfAP30V6AAETa02fnH0Mm5V1kLIwsD+SH46r5BIoRX5hvAINxFwzSklPc
         uq03bUWDtQOFA4me73A0yWDkOnDsrHuy9PWj85nJYktJ7yNmY3hFBnuDkpcE+ly9kiCS
         rNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DK5n35g6oFdbbF8RC/yMlCO4WIVT2pppc9FBF6r6uw=;
        b=1WddmOtx8FFaidyS5gKaLFiBiQGx4hsEaIyWezFkh2Mu2Bj6QrSItAEjnvHE+4Svzl
         Mq0K4NPd4mK+dVwrodi0h/3j6NZvXk5rOMiH5J3hwFEkzWcIhivj24bwo6uXRy4zu9dx
         FQQ+3/cr36aQfaRicxUXbnytdCHcu4pRYZwomGf7+qSZ6GF9mw4t0L07odCFSh4MtgOx
         BDQenbf1F74O5AoVxAHWgkQbhw4srF9wejNZjthYeNEuf9PtDw2Mdo+c0Ktp2slS+syb
         BEhWoWkZmTxD7Rht4SuKxxFYhJD6l5FtIQVVqPQTSdt44FT/S4fHx6iLpxNWcioGd8uc
         pL5A==
X-Gm-Message-State: AFqh2koYShtEwucQ/SFhs8kyGDjKy1EvRlqWuRyAU1Nx05it5THa1kDX
        53nBS4U4vftkwIicfcqsEKaBTdGlnlLHpdwytmg=
X-Google-Smtp-Source: AMrXdXv/lkbkrsuOAxt0WIyFVn25fQGIiQlkOkgpLCyP+yoP4E85YkqGKHlZlS7+o87K1+J6R7bh3w==
X-Received: by 2002:a5d:484f:0:b0:293:ffe0:9d15 with SMTP id n15-20020a5d484f000000b00293ffe09d15mr11435883wrs.67.1672909434737;
        Thu, 05 Jan 2023 01:03:54 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056000081200b002368f6b56desm4212425wrb.18.2023.01.05.01.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:03:54 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:03:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 03/14] devlink: split out netlink code
Message-ID: <Y7aSeZqr9MYYgeoU@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-4-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:25AM CET, kuba@kernel.org wrote:
>Move out the netlink glue into a separate file.
>Leave the ops in the old file because we'd have to export a ton
>of functions. Going forward we should switch to split ops which

What do you mean by "split ops"?


>will let us to put the new ops in the netlink.c file.
>
>Pure code move, no functional changes.

[...]
