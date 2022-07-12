Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AA9571C4D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiGLOWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiGLOWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:22:22 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0F23340A
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:22:20 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z12so11400353wrq.7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VzVyLq93v7Q1sxLTDDMDRjloIU59iqwzRVlFfkSnQsc=;
        b=of4p0Wgua6bZb2OZ/tCRo0c31uD/XMaPz16Q2FYXnqtLKxPmrfKbcNzkndTXsfSvcd
         f+4SnhrPS0LIxPq/u460O6F6/v4B1m/11a/bi4Wt4wD8hmikRP8WeoLyA/HiDv3eLKj7
         Z475vmwGY9mh12B5Momv3URNMVAxHfVvmLNpy3iMeieBbNr+Y9z0vZPDWBJIh1nJfbuu
         ezGp9+LMNWZBGBhXJ5OPwL4/upycNVYMRa81kx2EX6KwsT2gYL7BQcOyAFe5XVz4hV9x
         3HbR46bniAhb8bfVtqusDKno9Sxrr3W+4nyHzyIwU94g3pSOwycYBttk9MIED1E3DV/h
         +aUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VzVyLq93v7Q1sxLTDDMDRjloIU59iqwzRVlFfkSnQsc=;
        b=SOyUcoCdM20OICNHvH0hp1Rbg9TE2GTVfG7tfw9wQexTehFT9qPr3nqMUnswQaD3k6
         ISfDW9SBe2TT3apSP2OnTVVMIgV9ygIWC0lagoDRG1URbzZHBBw8R6azM7u+ZHubzsTt
         ufaR9EHbgohPYuiBqAbJwxpFaxguIX4doa1rN4KlBZp2+XdzlfC73u74CfSZPIgp588c
         egW99VwivDjCLfZ1tCmMLEaLfW6RzN+hG2hmWTX+FHg+Xht69IHgCnUchk1ug2onlg/e
         nHyW7wYZc54YBp3pMSFVuu7wESbAXrb4v9vGsFQovmHjz+cvJ0ywwopRhE1b64xYqIXn
         QO6A==
X-Gm-Message-State: AJIora9NdkzxVIsZ7Kq2ybE4D+0M8fVyypOkTBggBJrlQyxSJyX7dNG7
        6j4KiV5kPoWaurGuasV6wke1JQ==
X-Google-Smtp-Source: AGRyM1s0BZahYV3foKfdcHJHV6CPzd5TeU/Lqx2ZxDW0pLKHuorh4lkyyrrZsQhxr9p6DN1Q4b2LSQ==
X-Received: by 2002:a05:6000:1e01:b0:21d:94a2:750d with SMTP id bj1-20020a0560001e0100b0021d94a2750dmr18333159wrb.80.1657635739021;
        Tue, 12 Jul 2022 07:22:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c189-20020a1c35c6000000b003a046549a85sm13242207wma.37.2022.07.12.07.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:22:18 -0700 (PDT)
Date:   Tue, 12 Jul 2022 16:22:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: Re: [patch iproute2/net-next] devlink: add support for linecard show
 and type set
Message-ID: <Ys2DmcVlePRFDgCN@nanopsycho>
References: <20220712103154.2805695-1-jiri@resnulli.us>
 <Ys1sCNp0E0W86EGG@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys1sCNp0E0W86EGG@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 12, 2022 at 02:41:44PM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 12, 2022 at 12:31:54PM +0200, Jiri Pirko wrote:
>>  devlink/devlink.c     | 210 +++++++++++++++++++++++++++++++++++++++++-
>>  man/man8/devlink-lc.8 | 103 +++++++++++++++++++++
>>  2 files changed, 310 insertions(+), 3 deletions(-)
>>  create mode 100644 man/man8/devlink-lc.8
>
>Missing bash completion

Okay, will add. Thanks!
