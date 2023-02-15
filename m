Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444B169779A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjBOHwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbjBOHwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:52:20 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B10C32CD0
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:52:17 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id k3so10481362wrv.5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xTshWe1e29cgPwRFw0d7po+oTsrr9m0vzGqgtQdj2Bw=;
        b=3U+JVYU+oPUvd+iiO8i6kREe0GhYTUSxzhHx7i083cyW15gN83yfVV9nDjIUPdUJGV
         symr2nxmDZQXiioKdOFOr0elAr7SBuhwkXwH1NfIfh586zy+IeAvNmX77NtIz6G4SQ5s
         x574f78MkgR4Qzr2VJk69bJ1Mt4HMD2QR2BIuiwIBCAvRm0fA6gOoiP/lfrE8BfdpkRb
         y7evyARjX0hxJQcimM3+PYb+YGXaNVKbRkbmipU8zppAt9FXLzEmnrwnu3undfhwsO2y
         y7UPTinhz46pytUp09lbU2xEYwzJBcdIqgwg3++QbxQtlZHYnKCjrLFuHnMguGmEqxrw
         y4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xTshWe1e29cgPwRFw0d7po+oTsrr9m0vzGqgtQdj2Bw=;
        b=Mx0SAdLhwIRMCQ/krwa/Po1DwihpXNMedRqNdzzAbMlVhBuq0z5IlaiwACDOqoRYu4
         m+vfqOh/gVYdfozkppIpJLPQBU1QDQ71dSVpjigv5ChH4VMi5ZouMUHBinHPw6yAG7RO
         zKJYR8+fKQx3Q9M8Iptl/ldwHPyvMH8QdlVQ7sTwsgtpWNE9po+oMsGdbZ2xXVJQOLNo
         2HKT6hWgDqpGkU3fQa5ad2w3/0sy+HAs9Wwh61GiG3dg/lsxw4Av0oI0LVpy24pCBdr5
         9hsrpTyVdd31fXyxHoO7MbsqNz/1yc60FMfXyx+ZPsEH3fFbE///YaQHOdi6+eQHAT2a
         3YEQ==
X-Gm-Message-State: AO0yUKVgWiFr0LfYZEp//OL5TQsx+brE0mvyY7DZnfSGjRnAFFY9/uL5
        nYb4kXNFwsqS0PqR2TcNANbmAw==
X-Google-Smtp-Source: AK7set9R5+omIdI92hLFKTHaZzLcSZa8Qw5hlqm/4fyeVNXFrFOgM2xN+0jdFXRFfnr8Gpjg6NQL4w==
X-Received: by 2002:adf:f1c5:0:b0:2c5:6456:3799 with SMTP id z5-20020adff1c5000000b002c564563799mr778661wro.32.1676447536192;
        Tue, 14 Feb 2023 23:52:16 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c9-20020a7bc009000000b003dc4a47605fsm1278843wmb.8.2023.02.14.23.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 23:52:15 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:52:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/10] devlink: Split out health reporter
 create code
Message-ID: <Y+yPLrgqa0fKeewC@nanopsycho>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
 <1676392686-405892-2-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676392686-405892-2-git-send-email-moshe@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 05:37:57PM CET, moshe@nvidia.com wrote:
>Move devlink health reporter create/destroy and related dev code to new
>file health.c. This file shall include all callbacks and functionality
>that are related to devlink health.
>
>In addition, fix kdoc indentation and make reporter create/destroy kdoc
>more clear. No functional change in this patch.
>
>Signed-off-by: Moshe Shemesh <moshe@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
