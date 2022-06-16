Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62E954E18B
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376837AbiFPNMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiFPNMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:12:02 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2125E2654D
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:12:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z7so2109437edm.13
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Wk+LjndJzS2qMOB7T0o89BUJo7NsGn6GUWS01TejcM=;
        b=nwwIq1NrnraBH1f4gLAb+xtcJvUVELlQOqbI8ebinIeurjQ81UX2wqjvpT2agHrpUl
         d6I2xmJ0mRQltX3K+WhV7FGd3LJ4fsj0q/LCs9EvjH3QYGEHK0s9webYB+eXB8btqnKb
         GeSXa6KDATZrGyeHxOv4k6Ts5AfLCn2zrVvGDlZjCquAOvYcYp1XULbGdnkuD+OAA303
         O4KgU26De7nJFlUMRDZTGN0soDB1+s/U/FZXZJB8qqsJ4JBd5MFmnRI5iexxStRvAEMg
         oRjQMGsSheiqM/ZA9IioJi6U8hnEVd098LcUYadUknnlnAm7xEC2FUSE/pH2DWtZGPQF
         aaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Wk+LjndJzS2qMOB7T0o89BUJo7NsGn6GUWS01TejcM=;
        b=T3fUcvqREeuZmGNODmxN9XUTO67GodWVqd/IJOoOZgfNrItf5NnhD5s/DEgXExy3go
         CQ8NnpwgxaLr5FenIuu49MU1UHlSdz21x6FqsR4I+HpZ+I4iu2s6nvEY9CrT9XWJeYTK
         mc9UaSqXkNBA/EkFMkRZZo4m3s5PGPH79nI+zG9aosCqIGROekTM3nwi8ArK9fTyQnmc
         Bp6Ahb1H/H6JiKmmRAR5KO0SGKpdnnklpIPA5VC6g+02jFWr3s7UCw0PfOv+Omj0WrrN
         66VbsL6viJAyQjbBRPjhQ6Ct+oQ6wgPKl8eeF4TpVQR41AMb89KEMyW3jWG53H05g/zF
         7tFg==
X-Gm-Message-State: AJIora8DCVyYnaqAbTd14PcebeeTF06TsuxcbhlJPP08LsSuwy7oCxLo
        EzZtV/GIpU9DXN7eUquaDl1xGw==
X-Google-Smtp-Source: AGRyM1tCnmPqIbqVUJLPPGZwvdw8zDTp1vVY2D/vrFwZdMORkCCARJgek73wB5E2iE8nqIYdsvTo/A==
X-Received: by 2002:aa7:db02:0:b0:42d:c3ba:9c86 with SMTP id t2-20020aa7db02000000b0042dc3ba9c86mr6367887eds.337.1655385118592;
        Thu, 16 Jun 2022 06:11:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w20-20020aa7da54000000b0042617ba6389sm1781773eds.19.2022.06.16.06.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 06:11:58 -0700 (PDT)
Date:   Thu, 16 Jun 2022 15:11:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>, f@nanopsycho
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <YqssHTDDLsiE8UfH@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder>
 <YqoZkqwBPoX5lGrR@nanopsycho>
 <YqrV2LB244XukMAw@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqrV2LB244XukMAw@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 16, 2022 at 09:03:52AM CEST, idosch@nvidia.com wrote:
>On Wed, Jun 15, 2022 at 07:40:34PM +0200, Jiri Pirko wrote:
>> Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
>> >On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
>> >> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>> >
>> >How is this firmware activated? It is usually done after reload, but I
>> >don't see reload implementation for the line card devlink instance.
>> 
>> Currently, only devlink dev reload of the whole mlxsw instance or
>> unprovision/provision of a line card.
>
>OK, please at least mention it in the commit message that adds flashing
>support.
>
>What about implementing reload support as unprovision/provision?

Yes, that can be done eventually. I was thinking about that as well.
