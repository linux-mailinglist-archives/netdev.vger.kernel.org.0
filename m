Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83181643F17
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiLFIxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiLFIxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:53:03 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5221410FB
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:53:02 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c66so13012328edf.5
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 00:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQsCFVaGUIiADpt33GUZb22DeArRcvyp9Ac9n42XtDA=;
        b=EG2a5tZTO8qesnXAqNVTzYDVvDOpLb+g0h1yjjXQw9sXE27lSdWswGQYpwjozQSvcG
         13598chKxx0En/Qz7l7Isa2WCRBPNSxKupUmf0uNQSZkcSVgB2Gl2QBffVP9VzRkCaAU
         CKs1b/81XVy7EhkveFz1RNxUddLCy3vvsRVsCNajXN/w8SgSx/OlJ1UB04oOqsistDt/
         z2MAqq3QanCr5dab8t2RbOrUk84MVUd8AVbtkiBYCQngfHuOG4KzBFTMtvCSxZcwJeXW
         UjZAhFiwIpvCxPuhDWJm3iRSZwdAR/gHfEtgFo0Kcvxr9GBBjQUPuXVVzCNuy8kk3IOM
         /pQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQsCFVaGUIiADpt33GUZb22DeArRcvyp9Ac9n42XtDA=;
        b=yuaCvFvWfrJvlFkNDiu3IpTzDcHD0NG8lmqjBS1ziVYy20Fue41sTUvB2bwPhXCiay
         pLbNiQAzL01151ytG0lmTmTpobOvMze0KhtKKW85SP7igHpwHO44KTWDKjjDjoEtAJEt
         uSFExWOkN/ycxjU5EyyamFx97NyX1LnC1hbB57Rontdhg73v2JYJtxJk8BYDTWwUDmV9
         cjH7LhP7uC5snr7FBqf/o6ZgB2GuKZv0STmN+WQQZdr6mfe3Sxu88WDE6ElVIHW6iG8H
         b/b1Yzlx0TZ4YqfveQyGhB3C3ZgFvqvLiy2HQ7BN5awK6SwvAbixgGRsdTtL3fhaoO7z
         9cmw==
X-Gm-Message-State: ANoB5pm3KQobkwGjlPs+AY3sKmHUavKqBuLqsV1b6NvI6iis+6t2WKx5
        feu2jM+hkD7FolpxqXvJd9FP0w==
X-Google-Smtp-Source: AA0mqf75vJH2aD7n6HP4/s18NypbrSWwf77X/8RLQHLSc0s4zn80rivGFmCy8JUctM+F+JO3IV+RBg==
X-Received: by 2002:aa7:c256:0:b0:46c:a1f7:d9b9 with SMTP id y22-20020aa7c256000000b0046ca1f7d9b9mr7902135edo.168.1670316780881;
        Tue, 06 Dec 2022 00:53:00 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kq7-20020a170906abc700b0077f20a722dfsm1451083ejb.165.2022.12.06.00.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:53:00 -0800 (PST)
Date:   Tue, 6 Dec 2022 09:52:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <shnelson@amd.com>, Shay Drory <shayd@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, danielj@nvidia.com,
        yishaih@nvidia.com, jiri@nvidia.com, saeedm@nvidia.com,
        parav@nvidia.com
Subject: Re: [PATCH net-next V3 4/8] devlink: Expose port function commands
 to control RoCE
Message-ID: <Y48C699Lx3J9LDkI@nanopsycho>
References: <20221204141632.201932-1-shayd@nvidia.com>
 <20221204141632.201932-5-shayd@nvidia.com>
 <34381666-a7b5-9507-211a-162827b86153@amd.com>
 <20221205180234.2a8a5423@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205180234.2a8a5423@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 03:02:34AM CET, kuba@kernel.org wrote:
>On Mon, 5 Dec 2022 15:37:26 -0800 Shannon Nelson wrote:
>> >   enum devlink_port_function_attr {
>> >          DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
>> >          DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,     /* binary */
>> >          DEVLINK_PORT_FN_ATTR_STATE,     /* u8 */
>> >          DEVLINK_PORT_FN_ATTR_OPSTATE,   /* u8 */
>> > +       DEVLINK_PORT_FN_ATTR_CAPS,      /* bitfield32 */  
>> 
>> Will 32 bits be enough, or should we start off with u64?  It will 
>> probably be fine, but since we're setting a uapi thing here we probably 
>> want to be sure we won't need to change it in the future.
>
>Ah, if only variable size integer types from Olek were ready :(

Or, if the bitfield was variable length from the beginning (as I asked
for :)).


>
>Unfortunately there is no bf64 today, so we'd either have to add soon
>to be deprecated bf64 or hold off waiting for Olek...
>I reckon the dumb thing of merging bf32 may be the best choice right
>now :(

+1
