Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D11F3D3C1B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbhGWOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbhGWOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:19:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D25BC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:59:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j17-20020a17090aeb11b029017613554465so4059891pjz.4
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GrAHyFnPN5lRQcXgFGOH4xe1n0J5US2FyNlcIVm8HcI=;
        b=QM7k1MDMlZyzIoeYIq1eb4bbWgEwfSjwu7VdZ/odZLhB2W15V3aDC+iclMmP+mS2dZ
         LZ4OnXi8WNPWeX4FAugcWdBfIRM7gCMZbLQDKiDCEMbcVu70c1fP0PC/Frrmarbc2Atn
         Pe3+mH08GgHhhWg6enz07HmkmsQV0wakxSVgjeBhT3wKC+c2mxStmL0jzTd+iyrnFgcC
         BfT2QoXVw8OUDRc05OZFU7Tb/PpPuK/wG89QR5GVYAthzewd6jTiew8BNrfgwXeCMmS4
         Z7Y8HsMTVEHk2afHjJ1eVJdT8k+GoE8VaX/M5LZXcT9RceN0Z1odjukoFV3e5MYzEDIe
         AC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GrAHyFnPN5lRQcXgFGOH4xe1n0J5US2FyNlcIVm8HcI=;
        b=Oh1MGM8tFKgxMrL/UhO/jVZjrmHeVbgpX0uoTodmuVSUbu0/W/+Ru2uMYxk9LTGRiC
         QlYJlAf/Z67MKG/CsVUAxpbkPLGYB5Hv/eiNfGts11xIEVJdKJLwLSJboBgtRyLCvnUs
         WRzAac3WwknKfLzYc1TACAacs+2idNEZP1hVBsOstbB846S1MqBNS4YFMKS/qX4OVv8Q
         8deWrD1ifEj8ohWxIgq51HNuIml8z3z9E9bw2Kp0R+bc1fk/o7xU4CAt9wIt53+Vl+qi
         pIQt8bzb+UqVN4TDk/9C1mDzeHiaQcD+EVP1M06iq2wxtmSsOkbtiNgHmuQS0/pAt09r
         cuqg==
X-Gm-Message-State: AOAM533R9bIGsBF7u5rwTJZLngXrti0H6cnQTfWO2Ud3HDgcSRQdnxQv
        qqjfeLrewb8629Gut/9XSvjuCg==
X-Google-Smtp-Source: ABdhPJw8Ecs+WqSYmGhyhl4vqPw4qPG+zPJt2tQnyEU3t7CBB0zomJ1WxrThG8As84PQwX3j15u8CQ==
X-Received: by 2002:aa7:8154:0:b029:310:70d:a516 with SMTP id d20-20020aa781540000b0290310070da516mr5112940pfn.63.1627052373732;
        Fri, 23 Jul 2021 07:59:33 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id o134sm35421398pfg.62.2021.07.23.07.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 07:59:33 -0700 (PDT)
Date:   Fri, 23 Jul 2021 07:59:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/3] Add, show, link, remove IOAM
 namespaces and schemas
Message-ID: <20210723075931.722b859f@hermes.local>
In-Reply-To: <20210723144802.14380-2-justin.iurman@uliege.be>
References: <20210723144802.14380-1-justin.iurman@uliege.be>
        <20210723144802.14380-2-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 16:48:00 +0200
Justin Iurman <justin.iurman@uliege.be> wrote:

> This patch provides support for adding, listing and removing IOAM namespaces
> and schemas with iproute2. When adding an IOAM namespace, both "data" (=u32)
> and "wide" (=u64) are optional. Therefore, you can either have none, one of
> them, or both at the same time. When adding an IOAM schema, there is no
> restriction on "DATA" except its size (see IOAM6_MAX_SCHEMA_DATA_LEN). By
> default, an IOAM namespace has no active IOAM schema (meaning an IOAM namespace
> is not linked to an IOAM schema), and an IOAM schema is not considered
> as "active" (meaning an IOAM schema is not linked to an IOAM namespace). It is
> possible to link an IOAM namespace with an IOAM schema, thanks to the last
> command below (meaning the IOAM schema will be considered as "active" for the
> specific IOAM namespace).
> 
> $ ip ioam
> Usage:	ip ioam { COMMAND | help }
> 	ip ioam namespace show
> 	ip ioam namespace add ID [ data DATA32 ] [ wide DATA64 ]
> 	ip ioam namespace del ID
> 	ip ioam schema show
> 	ip ioam schema add ID DATA
> 	ip ioam schema del ID
> 	ip ioam namespace set ID schema { ID | none }
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  include/uapi/linux/ioam6_genl.h |  52 +++++
>  ip/Makefile                     |   2 +-
>  ip/ip.c                         |   3 +-
>  ip/ip_common.h                  |   1 +
>  ip/ipioam6.c                    | 351 ++++++++++++++++++++++++++++++++
>  5 files changed, 407 insertions(+), 2 deletions(-)
>  create mode 100644 include/uapi/linux/ioam6_genl.h
>  create mode 100644 ip/ipioam6.c

Please update the man pages as well
