Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414DA59D15E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 08:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbiHWGfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 02:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiHWGfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 02:35:12 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF485C96E
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 23:35:08 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id vw19so11803208ejb.1
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 23:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=VRLk0mX9Jrz/OShZwVOO/H+ZC51UZFTvvmALnix6+ko=;
        b=teNrqXC8ZlcNHacEeOVnYIjwKc0OlZK43x12BfU6CKo/Rox4YaVVMBtM/IdmEEH72e
         j+DTjEXFB/SW163p4rAKWkVxFtnufOQcvq1ngcVC7x36eAy5toYT1UixhJo8dua+5J5b
         pkxSKtX4KDEVxrgZUBJnJ5CdXVCBfKuQYFUTw0VA9hDno5X4anBLpKlbADgSZDAHsa+t
         OO6UeF0uP4ZTTdf+h4AOjhiLmXIHaJsO13az8XXUTpNLxTSyCrFaRBhDaHc2RI0aIwKT
         OU63Y3STrN3/JvbEJO+HnGamTsMaD+FILZsuhVUcTqTkpxRyqb1CI/5PabzhsdTw2HQw
         JK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=VRLk0mX9Jrz/OShZwVOO/H+ZC51UZFTvvmALnix6+ko=;
        b=U1dJgf8RtG2a+g+iorWEcwj9wnM0mlLDLnMww1YiZ6+8Zchehmi1gloh6dooD8eyAV
         Lix3cTx0LaMZCuKgO7z/5tITDZg0v50u1iepttg0NBvIlT3k3Z2jcA6MK4L4g68Na43g
         3/JRcSknR4Cvh2igRT0fDEz5vZ3mgACEDROnSXb7eEKKNkc9cxaLNBHXRg8EXnSoZv3c
         r9dxPqHZIePCFyxGBTwTA8af9Z7TwQ4ATD0P5wcqiKeyzOkojlbxYGt9ZMn061OIrO1+
         VZAIexL3SwFDNo03xy1gOcNX7g0S/CmWxBSdxGlP4BAtmEH0ra71F5S2u4OkuMOuPKpY
         qfFg==
X-Gm-Message-State: ACgBeo105bkeKMGX5/6KkoJojJvzLEqraIE3TZ1g6E9d391IyIHXhIxa
        tZnTfMbRFczam2FeQjyAuaJ4hc0jizYQOAcD
X-Google-Smtp-Source: AA6agR7ibSOl+k9UXZQz10tmOFz2l1HJ3isc/lvs4/mwtp1p0BW8ifSECSjJx403sSPvfTP5ACTPnA==
X-Received: by 2002:a17:907:2849:b0:732:fd61:5a31 with SMTP id el9-20020a170907284900b00732fd615a31mr14371485ejc.627.1661236506619;
        Mon, 22 Aug 2022 23:35:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e14-20020a170906314e00b0072b85a735afsm7019748eje.113.2022.08.22.23.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 23:35:05 -0700 (PDT)
Date:   Tue, 23 Aug 2022 08:35:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 1/4] net: devlink: extend info_get() version
 put to indicate a flash component
Message-ID: <YwR1GCPCKuK4WJRA@nanopsycho>
References: <20220822170247.974743-1-jiri@resnulli.us>
 <20220822170247.974743-2-jiri@resnulli.us>
 <20220822200026.12bdfbf9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822200026.12bdfbf9@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 23, 2022 at 05:00:26AM CEST, kuba@kernel.org wrote:
>On Mon, 22 Aug 2022 19:02:44 +0200 Jiri Pirko wrote:
>> +int devlink_info_version_running_put_ext(struct devlink_info_req *req,
>> +					 const char *version_name,
>> +					 const char *version_value,
>> +					 enum devlink_info_version_type version_type);
>
>Why are we hooking into running, wouldn't stored make more sense?

I think eventually this should be in both. Netdevsim and mlxsw (which I
did this originally for) does not have "stored".

