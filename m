Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A4559973C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347053AbiHSI1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346724AbiHSI05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:26:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44D8E727F
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:26:54 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e13so4751749edj.12
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=O9hOyIHMWywc7Gv/HRPZ3o2Jx6nVva9MLQuseyXi60U=;
        b=6Dd0qV4wjYjvZ3l7WKqpQHwc1opMGdROIvuO+dvlse64Y3CHdvVSJN4IxFdbDvEnQ9
         fJY3XMBhlRJaEHh6Tsf7LOzlzxK+wYviKb2ztnVYzWZxNbv2+ZealNHO+N9oKdtk2uht
         4Cl69djb2OXRWyO//jPGcaDY2XC28NGzxP22sJvHl4wGDsU2631osHhhcO8I5bDZkduY
         NRuy2Y2N1+v6GO6McGWCmFErM63VbZpUYMJdWSb3ns3D8HmtZ4FLw3v3GwqExkmwC6OO
         ubHXpchZ4pMFyH+GOu4PB1cdGV8EaB4fuRIp+SvBOG8Kq8Gm3WrGAytpFQ4Y6k4omrAm
         j4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=O9hOyIHMWywc7Gv/HRPZ3o2Jx6nVva9MLQuseyXi60U=;
        b=COBiWR4Zd4gcRswBNabhYHtzwwdI9q9OU2HcnJdUVFjPmHoHfyTRYb/XLPa2ogZd95
         +pTig9RdR+3JbRLutQaP+XmDRxUCd782PMWD9o1EmjDlCRilteklvydoq/lDMmcb7Kll
         6iA1fxaFvdQI8WTvjVs0BzztQrYQwrgCe8GHbeacLea4B8LprL6Txkzn0JsAP+QzlmkV
         KxGD4hNGXugpgBidCe+b/iNY51k6wFaiVDqzFOlTC7+TYzw6NjMysx/rb3tenLZ8yruF
         KG/Ag31FJcUTQFlbmDWWamw/CsL0a591JsyFl4b2OkCsME5FXUlwX3dVyR3YvebbQFLQ
         qgmg==
X-Gm-Message-State: ACgBeo2Dv4uychXGGoHHCZnLH4TL0n7vo572qbFkzeQODGlvpR7uYrPD
        Elde0kzPYuf7d0LzwdeM7AxLCQ==
X-Google-Smtp-Source: AA6agR6Ma/A/yhBZDro9ePWAxMrAyL5gCqF33c+dK7lV3NQYrZ5Zoesn8fTx5x91G0uCKyMBinAWxw==
X-Received: by 2002:a05:6402:14c7:b0:445:bb86:3f15 with SMTP id f7-20020a05640214c700b00445bb863f15mr5332107edx.68.1660897613018;
        Fri, 19 Aug 2022 01:26:53 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l9-20020a056402124900b00435a62d35b5sm2636529edw.45.2022.08.19.01.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 01:26:52 -0700 (PDT)
Date:   Fri, 19 Aug 2022 10:26:51 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [iproute2-next 1/2] devlink: use dl_no_arg instead of checking
 dl_argc == 0
Message-ID: <Yv9JSwIyD65q0T+B@nanopsycho>
References: <20220818211521.169569-1-jacob.e.keller@intel.com>
 <20220818211521.169569-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818211521.169569-2-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 18, 2022 at 11:15:20PM CEST, jacob.e.keller@intel.com wrote:
>Use the helper dl_no_arg function to check for whether the command has any
>arguments.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
