Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483296473D9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiLHQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLHQE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:04:28 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842EC9D2E6
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:04:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f7so2403878edc.6
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rxFY2SqmXS3BBtynzgX2txocwSHKa/pjC84kRsuKrkw=;
        b=4t9r7MDIG36wyIqs0jIz7jLnIoXadT5vHjrBBPqHEyDiodimOThhfjrYEpTRdMkbEu
         hCk/U/258wNMCVz+D6T44OLbmrcrBzBfGcm1tr/up0mNDcgCldAx/rqQSQ4v+66UdiuZ
         wzemVL/DCVNvqsjoezJUzgLuhTYpQZFeqLWpXxe4NVDZaxG1w5XNUX7CGHSu4nloPf0y
         IKiJe2t+VvbMd70EIv1Mqnj1qcIk8I1kwrx6RNKJpU1NCfUe3io4BtcxMbIr3EQgcbwj
         agR1+cuCl+PDeSqcQnDkMmD0HUdK//6tg571mSx816NQ7Vn3BbWcLUJGNmpNddM09q2y
         s0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxFY2SqmXS3BBtynzgX2txocwSHKa/pjC84kRsuKrkw=;
        b=3AF0wltIQbWkxakMtUCroSllxqhUv0KIcpv6atti9pHCAzTbZNJ/zpaGog/rhgXmlC
         Cu9X1dB7cB0FTU/pRDV2ax8keUuhGzKfP+rLW+MZGGWk4E2R4Wx7dFmS8w3l5/2qAbBw
         y1sFkZSrDfnYih/3k0m+Djz1Kuz+FYhZOsiOFStu7TqB9Qm9BeM3fiiQ1Hth4D0oNp3R
         iLe5UVTykXDUSEVjRrgX9mpQrcNWr29wo//ozuPDjbhFFlul0RxGgW93HL+ua9IkHdsy
         YNEdogCc2kZt5ERP+rZOU+i/av9HGMbLiQzlcH0LPiECVEeqY1879f5DN3YXKSJoRMne
         K55w==
X-Gm-Message-State: ANoB5plnLERIvSGmuvsC9TaoUaZZIw+uiixbFyPupTOm124nB50chTt5
        PFAFqaJDddmhCKEZYNvD+4SnaQ==
X-Google-Smtp-Source: AA0mqf7RLvKqVIriegXd1OE3LdlJdqqXJq4Hij5m0Pr2o4CFvqAq2nFlCA+Zi9sMxGXCDlHmRDjsNw==
X-Received: by 2002:a05:6402:4011:b0:46c:b2a7:1e03 with SMTP id d17-20020a056402401100b0046cb2a71e03mr2794389eda.36.1670515466074;
        Thu, 08 Dec 2022 08:04:26 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f8-20020a056402150800b0046146c730easm3522959edw.75.2022.12.08.08.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:04:25 -0800 (PST)
Date:   Thu, 8 Dec 2022 17:04:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, mlxsw@nvidia.com
Subject: Re: [PATCH iproute2-next] libnetlink: Fix wrong netlink header
 placement
Message-ID: <Y5ILA8F2TQwnncfZ@nanopsycho>
References: <20221208143816.936498-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208143816.936498-1-idosch@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 03:38:16PM CET, idosch@nvidia.com wrote:
>The netlink header must be first in the netlink message, so move it
>there.
>
>Fixes: fee4a56f0191 ("Update kernel headers")
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Interesing.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
