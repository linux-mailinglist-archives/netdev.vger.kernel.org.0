Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DE254E769
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiFPQhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiFPQhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:37:32 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C68BD3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:37:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z7so2940623edm.13
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0wpj0w4G3JLFAoTdn3DiI8IZT4Kct11we2ObWkrAW9s=;
        b=oaZYq/b+PAX5pTzylbbndtWJAk90oGjbB3NwPVJ5Z3PALtquogtxwgE481pL0aWCzX
         ByntjTw0fttyzsgnKtdCjyapA/0teIUDguFQlXwCtBRXNSuLfEB5vlMMmEvIiFFmalne
         3E7Fl5nx9hqGeGPI7iVcwFCZ1F0uJf4r2aFFLvyh6QI0VF1rNvXITqTOGWna+g7cH3iu
         OAOe+8SIKfBfeHJxC7gi1H+wmDc4g8jsTVY84Zwpjy/V1DmtMn3D9flEYlHBx8g0XWEX
         j+3kj1GMEYvwZbX87H/RucTuREK3LXCnTYWRGZ4AWcUJYLFDHSxsDE5hfnnCvQqlIvXX
         JA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0wpj0w4G3JLFAoTdn3DiI8IZT4Kct11we2ObWkrAW9s=;
        b=rWEJro54K41wYelaUCL6rS3pvVD//PSPuo6iWXjwV8D4NVm6WRJJQA42bQJZYM4q+l
         miocSy1ICc2i2cWl6Ln8+1r5NLsF2eKfVTWUdPHk/TxePRkBwibyeCs26aC+x4YWNX9L
         +5PSx2Q98k5HZ6NcqgN+a1XUMxYDkVfnIbRavtILDI1lxwKmqRqfe9Xv0kPORTtzLDSk
         7I/wYPr3Pmup41LMuZPtWBsB5uQRmi1EJ0JXetaPfiW47EqDCdL6phAGV9jnLJImTpgc
         x2XRRi5RV+vOXhDhIdLVEUSnTLad1+WFBdwLTNYaugbZ6OJtWkWw/6LU/PIP59xJMEwr
         qWgQ==
X-Gm-Message-State: AJIora/TDRfbeacDVqOU1wxmQFtrtNajqAwSNQcr1MEDD84yiYj89BCh
        PCj5RGPWGnyUbKD3KJ8eTtUNYQ==
X-Google-Smtp-Source: AGRyM1v9/RvQj0A3iNpPLyHBGivadJjYkNXElnO8MFVpYW7rHgV0EQcSU/1cuVn6kif8N0EbGslcmA==
X-Received: by 2002:a05:6402:13cc:b0:435:557e:6325 with SMTP id a12-20020a05640213cc00b00435557e6325mr2936771edx.83.1655397449015;
        Thu, 16 Jun 2022 09:37:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fm18-20020a1709072ad200b006f3ef214e63sm936639ejc.201.2022.06.16.09.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:37:28 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:37:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <YqtcR8rY44c42Nu7@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder>
 <YqoZkqwBPoX5lGrR@nanopsycho>
 <YqrV2LB244XukMAw@shredder>
 <YqssHTDDLsiE8UfH@nanopsycho>
 <YqtClpfUqQ0m+zVi@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqtClpfUqQ0m+zVi@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 16, 2022 at 04:47:50PM CEST, idosch@nvidia.com wrote:
>On Thu, Jun 16, 2022 at 03:11:57PM +0200, Jiri Pirko wrote:
>> Thu, Jun 16, 2022 at 09:03:52AM CEST, idosch@nvidia.com wrote:
>> >On Wed, Jun 15, 2022 at 07:40:34PM +0200, Jiri Pirko wrote:
>> >> Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
>> >> >On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
>> >> >> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>> >> >
>> >> >How is this firmware activated? It is usually done after reload, but I
>> >> >don't see reload implementation for the line card devlink instance.
>> >> 
>> >> Currently, only devlink dev reload of the whole mlxsw instance or
>> >> unprovision/provision of a line card.
>> >
>> >OK, please at least mention it in the commit message that adds flashing
>> >support.
>> >
>> >What about implementing reload support as unprovision/provision?
>> 
>> Yes, that can be done eventually. I was thinking about that as well.
>
>This patch should come before the one that adds flashing. Then both the
>primary and nested devlink instances maintain the same semantics with
>regards to firmware flashing / activation.

Ok.
