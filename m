Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3462599746
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346554AbiHSI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243414AbiHSI1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:27:06 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6656E1A8B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:27:05 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e13so4752248edj.12
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=xyWqU7Wza97R784JPnPa5jsZp9N04J3JUlgewvl0vUg=;
        b=XgVsNiQFTx7gxP8ucwryyAIpPemE7Cvfv2u4IqUlT3yfhS+jPo8hIFSOzd68h4jlh9
         CsSikv2dfSdU9eFrMQGSsF3PX/fONhVpcVp1PsZFp4q9n8Mh0gdRUU+BLMt6HlwgWoit
         lZ0OjNtqmZjVFAOKGRQayaDnY7PqXeEqn8LE2B+MVnJyuW3J26amMGsqcFMHBlEZqWjs
         xTTySLHnMoFjZlI1x+3oRO3K1R9lPKbUVw1ndOGEDWEslE0/TUPiBKvVwPeLLQjQOuLP
         4pcyFKBQSxGCK6ppj9dAoXUvRxlTKjoNybjlmGLPS51YU0TlgLwUBzqH+SfcDao44t8Q
         Fg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=xyWqU7Wza97R784JPnPa5jsZp9N04J3JUlgewvl0vUg=;
        b=lEQ9W4P1WmSt++YsAA9W/sRDyb8mmQySCIWjPYas2MU/U9t/oI4GTfyaYkwxbPjb4Q
         5nr90GvtYqbtEaLTGeuzkYqn06iRRWAQt+I4pFDB03uwom7tOsbzmjI2Uhr8fLRaj6jK
         OYuliToybdV2Qry9+JbDX0V4stux3nyU5/k5LPXFetuxcKrF7CvKW8lNMAltl9TkHIQu
         3xCm3uW9vG2CEdjuPm9xX+oQEwV/JoQTGH6R9E6vpnY0OzzWnSbKwnljHEQLy+udPNPh
         bjOxIGlB5NXZ3XUE/mr1HrPiJ7VYi717G9oPtaPBUrydun4LouRbEWMWOoY7nsidRYra
         V1lg==
X-Gm-Message-State: ACgBeo0cHmWYALDUcWMouprsXO0KmvaGGs3fnN84lFY+jMk0aGXiHk0q
        7oAqixlB6GGZkHRXxcTMPNr9IA==
X-Google-Smtp-Source: AA6agR5dRuAy9X2hlCa7etChPfYWIo4j1H5fAJTU+xMJ8wDDSDum0ky9nJb4q9fRum+1/YAdtvs29g==
X-Received: by 2002:aa7:c14e:0:b0:43d:7bad:b53e with SMTP id r14-20020aa7c14e000000b0043d7badb53emr5183795edp.353.1660897625178;
        Fri, 19 Aug 2022 01:27:05 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p22-20020aa7cc96000000b0044631254c4fsm1296436edt.28.2022.08.19.01.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 01:27:04 -0700 (PDT)
Date:   Fri, 19 Aug 2022 10:27:03 +0200
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
Subject: Re: [iproute2-next 2/2] devlink: remove dl_argv_parse_put
Message-ID: <Yv9JV52+COsNcyVU@nanopsycho>
References: <20220818211521.169569-1-jacob.e.keller@intel.com>
 <20220818211521.169569-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818211521.169569-3-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 18, 2022 at 11:15:21PM CEST, jacob.e.keller@intel.com wrote:
>The dl_argv_parse_put function is used to extract arguments from the
>command line and convert them to the appropriate netlink attributes. This
>function is a combination of calling dl_argv_parse and dl_put_opts.
>
>A future change is going to refactor dl_argv_parse to check the kernel's
>netlink policy for the command. This requires issuing another netlink
>message which requires calling dl_argv_parse before
>mnlu_gen_socket_cmd_prepare. Otherwise, the get policy command issued in
>dl_argv_parse would overwrite the prepared buffer.
>
>This conflicts with dl_argv_parse_put which requires being called after
>mnlu_gen_socket_cmd_prepare.
>
>Remove dl_argv_parse_put and replace it with appropriate calls to
>dl_argv_parse and dl_put_opts. This allows us to ensure dl_argv_parse is
>called before mnlu_gen_socket_cmd_prepare while dl_put_opts is called
>afterwards.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
