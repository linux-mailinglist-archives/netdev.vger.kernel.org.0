Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DFA6916B0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjBJCbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBJCbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:31:51 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB5A7A8F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:31:50 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id f10so4459566qtv.1
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 18:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kI90D/0A9HX85L3205L74BUdxB0Cx9bdYqw6nr4PZAA=;
        b=i2StyoIW61vPOsfc5HcZPr4gbHtNjnim0Ku8vaqr9SyLogfrGUW6JK77mTNNb7GilG
         HT8s9aOxxE0mOc9SyqhlG0KA6wh6vqSu1/hYNgM/xlqn9JPQHcxO1Fwbv93ehw7Dl1D9
         dH2EHKlThVoccbz8sARxu/ixvOtCJre9j7NJK7C4zmQeqjG+sM3AA/K+m/m+4dWohgs9
         IuNFYMbPwDbsIGT0umpn+N8WzE66rTiRvgc5Up6RDRb+PAbzji0o4Sg6hVw3+dUpijqv
         PtmVR+x/cBwvTMrS8imQh+iQoDn+kC4R7XQupBlerDWZwen+c+iMo6mB+pNE5QzWGOcW
         RWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI90D/0A9HX85L3205L74BUdxB0Cx9bdYqw6nr4PZAA=;
        b=PEqCJ3KMYHLAWhr/uTrfML/2ygj/TViajcwThFThK2WN8SqejRLbVahZmmvfVlbN2U
         6uQXm4A8JasgQTom9u0Gr2b0NH4zxFnte5tvopFXQF0aBO3l5z3yw8LNRNafqu02az+J
         a5zNBkKPADK3BYX1G4lWBRHmt4nGqcJVNS/JW56cFUIAU+vnMr4udTZ+7604DjWVtQXS
         PGXfzQoAbGMZ5aUc+YrkZd3XfcHfQco35VVK0yrabSGD0+tV+BI51RhRqKlfRVaMGCp1
         ju8YX7nLs6pUgoBqXWNi5svH1gI22ZvK/8vxjqbSRFB+X4z645Zdf49u/z8kFX1ra+8V
         AV1A==
X-Gm-Message-State: AO0yUKU/+Qcv85lbV1gs0TW9z4qw80ez2PyPx4GEfk8fe97KJ/SPZoLF
        eUfFMJq188BXUXk0wO/MD6s=
X-Google-Smtp-Source: AK7set/A8CpTKWjt3Qv95lAxWof2Yfeth2FSrZBLKHV6qv15cCZP+LHar8bsEwSAlUuvdCAj+QVZSA==
X-Received: by 2002:a05:622a:b:b0:3b9:e2a6:cb0b with SMTP id x11-20020a05622a000b00b003b9e2a6cb0bmr22850579qtw.12.1675996309059;
        Thu, 09 Feb 2023 18:31:49 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id c20-20020ae9ed14000000b00720ae160601sm2607515qkg.22.2023.02.09.18.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:31:48 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id B186B4C1EC7; Thu,  9 Feb 2023 18:31:47 -0800 (PST)
Date:   Thu, 9 Feb 2023 18:31:47 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 2/9] net/sched: act_pedit, setup offload
 action for action stats query
Message-ID: <20230210023147.slq2lfxxzr6uwljs@t14s.localdomain>
References: <20230206135442.15671-1-ozsh@nvidia.com>
 <20230206135442.15671-3-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135442.15671-3-ozsh@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:54:35PM +0200, Oz Shlomo wrote:
> A single tc pedit action may be translated to multiple flow_offload
> actions.
> Offload only actions that translate to a single pedit command value.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
