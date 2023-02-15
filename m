Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D269C69779B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbjBOHwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbjBOHwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:52:30 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2722364E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:52:28 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m10so9197735wrn.4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DI/eM+mylih4P7TdUBk/7bz36zNauZcXQeKy/j6tL1Y=;
        b=d3yGAgGYeLO28tPGYB2B6c6fj8H5Lf0AQsaIE5W3rIVM8SVO/3BBz+0aBw7aITcBjT
         LiAjdYTNB6eTdeNIVHwLAbIH5GFvdkxwYoLouPg/f5dkSpft6pX63GbUO4ewhvWnC39a
         ZnfhG22zw+s6ak6L0ZmHIZmyjjb8GHQ1vqS3N+pyff+VfXytrj9xzkeL5nLW5/aO/xeR
         ADY11Z1KGeIxffSdXZxlbE5VF1zWlyVMjd0fvwVidqtQbCqSTDMqiwtbgsoMp1BPLPnW
         +L6hLVBQyMJEWjvdCHsY94Xtih417zvqfClvydhNw7tMJeV8ImlrrEGgrTpQp7V2jfWq
         Z06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DI/eM+mylih4P7TdUBk/7bz36zNauZcXQeKy/j6tL1Y=;
        b=0rzmBvpq8EEdrcOekp5aHWHP0YT3pwvzqQt272hfVEXsxbMIL4UgE8zwYrOuaHh63w
         DGJ1/OeJVNDGUUzmsSTlOfbEy2r8XuRqI39RTX1sQTdyNA5OZIg5fZz/TQLKO2r0Jmh/
         XbVl2wiDOONw5i0R+MXsTeoymqd84eQjd/qeOyXss3cT1EUqhpInth3bhCM4U50RhOBU
         ILDgkK4WCGOY/+2U4VaTadCx57UZREm5XRBYbLoY6p8Kftq3OlkLNaBu1qK685mg2N43
         JxbxR2RY8BKGWcy09s5o5zBWf2M0Q2NVEe8lqGFtD/bui6jAe3Jne6N5Hg6KqMSvySbd
         iYbw==
X-Gm-Message-State: AO0yUKU0duNuu/+jioarumilEEZZt5zGAwER6q1YiUzvx45FMxRAN13M
        h08RyRda88aVyCRaDa09vr7uEA==
X-Google-Smtp-Source: AK7set9I6hQnh6uEeEMliojR3laj6mybWWIAbTkwnx0qgImYds7J4rM+sSGxTRPEpr0pfTBSTfqkhg==
X-Received: by 2002:adf:ef84:0:b0:2c5:6182:5f6b with SMTP id d4-20020adfef84000000b002c561825f6bmr825622wro.18.1676447547374;
        Tue, 14 Feb 2023 23:52:27 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d1-20020adffd81000000b002bfe08c566fsm14581701wrr.106.2023.02.14.23.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 23:52:26 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:52:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 10/10] devlink: Fix TP_STRUCT_entry in trace
 of devlink health report
Message-ID: <Y+yPOXoJaoMNoxUC@nanopsycho>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
 <1676392686-405892-11-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676392686-405892-11-git-send-email-moshe@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 05:38:06PM CET, moshe@nvidia.com wrote:
>Fix a bug in trace point definition for devlink health report, as
>TP_STRUCT_entry of reporter_name should get reporter_name and not msg.
>
>Note no fixes tag as this is a harmless bug as both reporter_name and
>msg are strings and TP_fast_assign for this entry is correct.
>
>Signed-off-by: Moshe Shemesh <moshe@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
