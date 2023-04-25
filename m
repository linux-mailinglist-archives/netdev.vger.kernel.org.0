Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD496EE417
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjDYOlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjDYOlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:41:18 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA4740EC
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:41:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-506b2a08877so10116586a12.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682433659; x=1685025659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g/aUo41spGkQIfQe1YL9i8hALGxoj0cii7JIOMlBmec=;
        b=GupKDRWMY1HZ1RdENYiWrMXVT57kW5X0ThFLX2hrncxxxW4BNNiYuhjE/cSGgjdMSS
         Ts0E/bPxbPTDnHE9G6F0yfaMwT/9jwkmM1nESGUfXukfqKjJj+PT5JRCMCdvzbghfoNe
         6edkojFJEEVypCCqOfiPhcLHN8tAUDI5x5FG1L0AnwRKAzjidOq07PDyVJQLySLLljMm
         NrAhrc86D9k8UvmnhaYilj/pKsGUeRBDD6IZML4xKHqcYExvIqWYdS6GYGR9ll2F9sm+
         YBA58SPqCHGvmMVLG0qTYBD0eJGqxkJJkaS6uP+MOJTZd6xX5yuI90yuTQ0y5LeqkNLV
         6rHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682433659; x=1685025659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/aUo41spGkQIfQe1YL9i8hALGxoj0cii7JIOMlBmec=;
        b=d0Z+9Vs1vJdr3z/TqG9E10RBfX7k0RLRpAZUbqRKV4XVy7EQxsWodAJV5ALoWNxfwu
         KSlJi2SZOEM/eUmbvx8444K/Rotg54h67h7js7B4u1KiDBVzoZgZtyIviybHQNtF1lxO
         jl58dhQlgJU0E4oxWciYwBD1pLetyZ2K6HDWxdqFPggf3MkAqDlubtsubIbtG1cODVx5
         4FFvN/w+vbF83sqO3IOvxp3+nXC6WLllj0gZ7Yz/VhksetKP00hTyQOX/IUJMIiGGP2w
         jtthtct1pFxDUOKbAtTZv5BD0GIaBpGsF/lcvbDQNqf6o4NTbpZeK9Q2B7/5RycIyo/N
         2CHg==
X-Gm-Message-State: AAQBX9cKStRlqhkEEZ6adIxxbhUaeiwVXplI4pmWmmBjtErXo6FHFiy0
        RjwM/ccX9iAcXD0vIf+VmnL2MJm2OYeSt/nCfgA=
X-Google-Smtp-Source: AKy350Z0WNqeL4BZmPbe+j5EoXeCwB7TZ2vn7b0309zekX04y+T7aTAMhu9R2U4buqQ+lyjpg5Vk6A==
X-Received: by 2002:aa7:d054:0:b0:504:77ed:ac87 with SMTP id n20-20020aa7d054000000b0050477edac87mr15182312edo.5.1682433659137;
        Tue, 25 Apr 2023 07:40:59 -0700 (PDT)
Received: from gvm01 (net-93-146-11-7.cust.vodafonedsl.it. [93.146.11.7])
        by smtp.gmail.com with ESMTPSA id be9-20020a0564021a2900b00506a2e645f6sm5720442edb.71.2023.04.25.07.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 07:40:58 -0700 (PDT)
Date:   Tue, 25 Apr 2023 16:40:57 +0200
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] netlink: settings: fix netlink support when PLCA
 is not present
Message-ID: <ZEfmecrilOyvyGi2@gvm01>
References: <20230425000742.130480-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425000742.130480-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 05:07:42PM -0700, Jakub Kicinski wrote:
> PLCA support threw the PLCA commands as required into the initial
> support check at the start of nl_gset(). That's not correct.
> The initial check (AFAIU) queries for the base support in the kernel
> i.e. support for the commands which correspond to ioctls.
> If those are not available (presumably very old kernel or kernel
> without ethtool-netlink) we're better off using the ioctl.
> 
> For new functionality, however, falling back to ioctl
> is counterproductive. New functionality (like PLCA) isn't
> supported via the ioctl, anyway, and we're losing all the other
> netlink-only functionality (I noticed that the link down statistics
> are gone).
> 
> After much deliberation I decided to add a second check for
> command support in gset_request(). Seems cleanest and if any
> of the non-required commands narrows the capabilities (e.g.
> does not support dump) we should just skip it too. Falling
> back to ioctl would again be a regression.
Hi Jackub,
please ignore my previous reply, the segmentation fault I saw was
actually triggered by a different problem I had on my reference
platform.

I've successfully tested this patch with and without netlink.
Please, add me as reviewer and tester.

Kind Regards,
Piergiorgio
