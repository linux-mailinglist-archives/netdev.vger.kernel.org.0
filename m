Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5F4DC172
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiCQIjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiCQIjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:39:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3B02711
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:37:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gb39so9151445ejc.1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IFPHeQmfbxtnmqSf24rcU4k06iHQfkREKrLRep1YmfM=;
        b=nSIHTwOOCs0K8GDql6D61gg39i/Oe4bj53WAkzDICZH9sUKrpLm7dN2RP79CJSr8wq
         GomGqjPRcSgTmwZe/X7n9qRSYYvk7lKyS0aISJ62jzbgw4v2Sbbtc/2aF529LHVv+zWg
         QoSyrGeA6bm+AB6yvTIdQSUnywr3mlnIgD/OEvs2N7KgztagdW9l/hgsTmrLMwWCQHd5
         V1xmJ6ZIJSPJ7/ddW4pYcisKN9usYta/6X5ECri6Qx1zHyPfCPbRWG/8TuEwsNQE+yH/
         ndYGZXuEfY8bkaRz6OvutOY4G40LR/cV7VnmTS/dUIAcjRYmgW5ezBjMpi2WcNwGNd5A
         YEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IFPHeQmfbxtnmqSf24rcU4k06iHQfkREKrLRep1YmfM=;
        b=EKAxD1Vh4TR0mDPbetUnpOB75zB//Dm9bPbEJjGMSxGGNxx3ogXdPMn/KZScFQxAv2
         +UPkECLpk0Sm/agvkHJ8peWuhQAoJ/aRe3bQ+g7FoStMyo+OxO4ujL8dWWWOwwd6+fZr
         ULqgv8NzkTrsahPWmzbZT7da9dyzM54hE69TwPCvg+sKv7fwvGxYtPWRz9Se7nkFk85d
         mFydcAwjAs7O4t5e3kIDqHGWupD0PsOfK/2fYnixkkjTaoQrBNiAloWi1sR6pQSPJMhn
         R56RRuHHj8k5R7CWS9mX7I60NSRdZe8V6vtN5nVR3crcx8geUuSEzaJrP82XhvJhMBbv
         t2Eg==
X-Gm-Message-State: AOAM530M9TmXcrm/pFgET9JB3iEezSY0TcakYaYHV1qLjmsPiGP55SK3
        YGiDJyjsQNji5vudSFNHG7u4ZA==
X-Google-Smtp-Source: ABdhPJy0K5h6ACQl1Z3dLBExvsQC6tZOgEsDBypJg8DmPqduKnja92ducnttQKub63wDbOX5G5CoKg==
X-Received: by 2002:a17:906:1656:b0:6cf:571c:f91d with SMTP id n22-20020a170906165600b006cf571cf91dmr3246874ejd.377.1647506271290;
        Thu, 17 Mar 2022 01:37:51 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id dn4-20020a17090794c400b006dbec4f4acbsm2036332ejc.6.2022.03.17.01.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:37:50 -0700 (PDT)
Date:   Thu, 17 Mar 2022 09:37:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next 5/5] devlink: hold the instance lock during
 eswitch_mode callbacks
Message-ID: <YjLzXulddetxUuVd@nanopsycho>
References: <20220317042023.1470039-1-kuba@kernel.org>
 <20220317042023.1470039-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317042023.1470039-6-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 17, 2022 at 05:20:23AM CET, kuba@kernel.org wrote:
>Make the devlink core hold the instance lock during eswitch_mode
>callbacks. Cheat in case of mlx5 (see the cover letter).
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Looks fine.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

I agree with Leon that it would be better to have the "TODO" comment
elsewhere.
