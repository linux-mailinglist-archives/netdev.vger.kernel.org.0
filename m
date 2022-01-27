Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D5649E894
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244399AbiA0RLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244396AbiA0RLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:11:48 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C61C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:11:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id om4-20020a17090b3a8400b001b633bebd2dso263163pjb.4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FHGDX9WlSQJ2CslDhwU8bcKoNzoWRt9/hXVcVaFZm80=;
        b=mUiiRlVsCU52G0qFFT9DqCaGY8BVlOJkTUz1t4liW/A5E96QXhfOXRRf5RFKZmbOMl
         Vp6mi/qY1Ypbig3k4JMJEY01fiSlnwfhOaakOeoAg6QnS+2CwNUH4Box/2OKOTvHFTj/
         WwkILEkY5nvfgnLnrt78Wk1/6OFrH2kgK/Tbk4YsO3IdJJUygUT4dGx3xDQtZEbAEOFn
         4WUco6xMj4cGVnmMF9eVWSHKnJQv9eAtk7qUpyRNzEfYSdqtSLoYS/BmAZglKgBul2BZ
         MEPzsFhy02HDoNKrUMEOU/Xrn5kiAHHtvMy9lSe55c0p7kN1Bbv0HbJ1p0PNG4XddUYB
         rKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FHGDX9WlSQJ2CslDhwU8bcKoNzoWRt9/hXVcVaFZm80=;
        b=vPkd83Ggmr2QqWdwvW0ld6C++mRBVJcoYkpjsC5xMFqtsVfu4AscL+VG414LGBOuF4
         9BjB1vfIaUtJzgKGLNu1Aq0vFxqIRrrsqgWOhNPVxHxw+J02JuikGmqqGQQS+3vzkiyW
         ZDF1LCARA35K72175bqcNl4qDoKwh1yQ6ShZLqstDXleQrVYll4gSeXSmRdVlJ1Vfevh
         Cgr5uSA/WkDK9Uk6vAMD0mNF2ZAqD0vC5s/dtmUIXaDiJM0VyMoZyuHFFViGUmmLPUQl
         33DcpGO39JJy87ZQQPAZTT1pKnrkaXhSKpIu0zcTfGHlrnZ/IBMYlXguOG+uUlEYh85v
         /pgg==
X-Gm-Message-State: AOAM530JfCw1KRHslBGSAj2cg2eLdLlwdeoyf6sxk+NG1QVfG6U4QiwN
        rRT4iuvO1jfGmR0JGebe5bl3qYH7YOHz7Q==
X-Google-Smtp-Source: ABdhPJx3Hsr5dFAhql7+vnCPK7OHfczxzrWavCinv5cC7SCic2rQ3QmudgSZj7QE3pROlLIVsXJ/QA==
X-Received: by 2002:a17:902:d50a:: with SMTP id b10mr4548582plg.9.1643303507216;
        Thu, 27 Jan 2022 09:11:47 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id on5sm3594577pjb.26.2022.01.27.09.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:11:46 -0800 (PST)
Date:   Thu, 27 Jan 2022 09:11:44 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: Re: [PATCH iproute2-next 1/2] ip: GTP support in ip link
Message-ID: <20220127091144.08f3048d@hermes.local>
In-Reply-To: <20220127131355.126824-2-wojciech.drewek@intel.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
        <20220127131355.126824-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 14:13:54 +0100
Wojciech Drewek <wojciech.drewek@intel.com> wrote:

> +/*
> + * iplink_gtp.c	GTP device support
> + *
> + *		This program is free software; you can redistribute it and/or
> + *		modify it under the terms of the GNU General Public License
> + *		as published by the Free Software Foundation; either version
> + *		2 of the License, or (at your option) any later version.
> + *
> + * Authors:	Wojciech Drewek <wojciech.drewek@intel.com>
> + */

Please just us SPDX tag instead of boilerplate for all new code.
