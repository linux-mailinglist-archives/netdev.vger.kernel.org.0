Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B423F65D05D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 11:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjADKHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 05:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbjADKGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 05:06:33 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9B8186C0
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 02:06:32 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d17so12673529wrs.2
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 02:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BgOjl0xJ4o0fXkxB+ybQjywGOos1sMXhG0ZMV7aqFkA=;
        b=ni7H2dX2wqwFfDPEbeMkZVOf0JaptQXpPb3WsCZNrIS2OMH82Y5SEzFTDXmEe7JG18
         4NcPYKbCassJCuvTo+4+0Z6wkKvxU4uCTLWM8jqGufnREhIsOMPFPRvV6wogoaAgnwAW
         pxUYCOKSVI/WmzS8L2TGwUakT40vWlxpGANQ8YjatAtlzwO5v8dl1zNrRUgL13EUSmnh
         jwXvblAQj/9wghS0EYRqKTEYeBa7VMtf8M4aPfIKZWkDXH9K/rXnGwl2CoS6JhMCrZrj
         9sS8bPKbub/nWOmymoXULi9r98yINdaWhldHf0I1kHEzxOpr4qexnp0h/E71nZVdTmYw
         gmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgOjl0xJ4o0fXkxB+ybQjywGOos1sMXhG0ZMV7aqFkA=;
        b=Ib8hXcrFYK4U4hzoXs2NPXEefzdPPtSJc0u5gUjYejMPEFxKHZBPWMIO5BlKZeRhZx
         mGoBvtv5rn6x0OnMVQxFwYsx9xY9QFo61C6p0iRUVg2PMhAJpOd9Xt7qJB26cHlF1JNZ
         IXRxsdB1Yl4/DSdJe08VTMfPvyfplqsvhLilGIvCOyZU8w6WyUnpL5S37cdj3sWvWO1l
         eKUDLFXwlbbp+lZ2oGsAsVENxryVhSKUhMZFW1awJzYc//lWbahxNHzsoU1W4uSLHBHm
         5AZt9Z05Ny9EYKyY7M4mgd668YizzHg39lI6ag7we/Wm4PzuxzSStN3Yl2PpQEtz7MVP
         NAeQ==
X-Gm-Message-State: AFqh2koCqBSR9ONhRBxcK8rCH/MFrgMML4awCrlLjT9tZF63fjD706pr
        kQoDBPdCP3nqPbqpFzfm9NkD5A==
X-Google-Smtp-Source: AMrXdXsC3MSPW+NM9R9+XEI7S3Qd29IQc3ryYx2QnqmsCI90amtIcUzbskVsloggodIs0VQI6LFj+Q==
X-Received: by 2002:adf:fc8d:0:b0:27b:7b34:5ca0 with SMTP id g13-20020adffc8d000000b0027b7b345ca0mr23514974wrr.44.1672826791080;
        Wed, 04 Jan 2023 02:06:31 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s8-20020a5d5108000000b0028f2fdadde2sm14627587wrt.34.2023.01.04.02.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 02:06:30 -0800 (PST)
Date:   Wed, 4 Jan 2023 11:06:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 08/14] devlink: health: combine loops in dump
Message-ID: <Y7VPpTEKYnBEx51+@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-9-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-9-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:30AM CET, kuba@kernel.org wrote:
>Walk devlink instances only once. Dump the instance reporters
>and port reporters before moving to the next instance.
>User space should not depend on ordering of messages.
>
>This will make improving stability of the walk easier.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
