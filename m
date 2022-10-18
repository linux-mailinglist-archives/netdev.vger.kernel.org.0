Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17321602DEF
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJROIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJROIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:08:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288E689AF8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:08:20 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b2so32480813eja.6
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fNb22b+ajPYVe1wCMCmgHMmIhLJdjAalDe9/OVaqEaA=;
        b=cD9EZXvhIWltEAPwO1TN7hpPF1A3XbkXXHY/qtSvfD4aNbbb7lc/8G80deb9l6d79K
         8fBSTMNLln5MlPig7gsI5LO7DEQj2vGEQ+IbvBLZyKf9Xrrcfq9z+iEpMiaGDoqNFusb
         c9VX7wTQt+H1GVlOSR/3hipot+TWz7l1uylvA3tcALW1X4Dx66se10Cf6HpQw4UkdQbl
         0u5xjxMyb7dAU8wr4fqni12VPTMzkSA1cVU2zYul+n29NBdGCmQztzarcdKTMrGCpU7a
         qsrAjqzNIpOLZtC2uNVeBna5M8th1+uDbpapbPqvu84323RsCxGZOEXsS0rNsmaeqweq
         63bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNb22b+ajPYVe1wCMCmgHMmIhLJdjAalDe9/OVaqEaA=;
        b=vOB3y8cc35KFZqO42o8K/dV8s2bQqaHS+oI6TyssHZ7ePDjhhiF8Y5GtMqufvfGvRe
         0K7IGY2cP7Rwch6TjGEfWue4JGsJWYNDbjoZH/dVbabR0dnnxhhAUrcb0W6+Cv5rBVFG
         rh4DBGFeVCXbQ2705c0wabe52f5webAceEeVShkQlT5+Vy0F/MnfYpDThgYEYATNlbTH
         kZcaxqnwUzFlvqv5B3bwdJCE/hVWU1vvioUpjVHlsEtv+gGirS4P+xsUddTLtq/CRpQ7
         p7eFoZfmOWmJyT5LOmE6K+MyZGI8LM6mMZZtJuNqXCGYS4WMrM/308DdV2scLcgsD7pt
         hRbA==
X-Gm-Message-State: ACrzQf3GJRPBs2q9OzBAmPazP3gxiuODJYg9mHG6IXU1UUAYzuXUZDqo
        A8N6XGrH65dQoRrJgtL1N59gLA==
X-Google-Smtp-Source: AMsMyM7qcZuf2PHpUrbntB0uMXvpXqB+mJPKxS9XUPjN8xJRnoGFkkSy7nxF2eYlnTPTvC9dIdI1sA==
X-Received: by 2002:a17:907:720b:b0:78e:c0e:a434 with SMTP id dr11-20020a170907720b00b0078e0c0ea434mr2572455ejc.741.1666102098636;
        Tue, 18 Oct 2022 07:08:18 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id la22-20020a170907781600b00779a605c777sm7645055ejc.192.2022.10.18.07.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:08:15 -0700 (PDT)
Date:   Tue, 18 Oct 2022 16:08:13 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v6 1/4] devlink: Extend devlink-rate api with
 export functions and new params
Message-ID: <Y06zTYTdNPJAKfcw@nanopsycho>
References: <20221018123543.1210217-1-michal.wilczynski@intel.com>
 <20221018123543.1210217-2-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018123543.1210217-2-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 18, 2022 at 02:35:39PM CEST, michal.wilczynski@intel.com wrote:
>ice driver needs an ability to create devlink-rate nodes from inside the
>driver. We have default Tx-scheduler tree that we would like to
>export as devlink-rate objects.
>
>There is also a need to support additional parameters, besides two that
>are supported currently:
>tx_priority - priority among siblings (0-7)
>tx_weight - weights for the WFQ algorithm (1-200)
>
>Allow creation of nodes from the driver, and introduce new argument
>to devl_rate_leaf_create, so the parent can be set during the creation
>of the leaf node.
>
>Implement new parameters - tx_priority, tx_weight.
>
>Allow modification of the priv field in the devlink_rate from parent_set
>callbacks. This is needed because creating nodes without parents doesn't
>make any sense in ice driver case. It's much more elegant to actually
>create a node when the parent is assigned.

This should be split into like 3-4 patches.
