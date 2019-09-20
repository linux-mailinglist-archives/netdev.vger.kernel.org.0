Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B76B9AFC
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407278AbfITX7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 19:59:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:47100 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407171AbfITX7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 19:59:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so10592185qtq.13
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 16:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MmQoXn1ppUt6tBlun+jsY8GfzDlX1YEW76k+uO1iBX8=;
        b=A1/nl07UHOqnDdD7baQQLAHk5qJZVugwCfL30htDpi0zArYLmUagVCe2YUrmQDz6xv
         W6JAum2bCTlevDzim1XBkj2TwXIjTagBxv8ddpWW90nnfNTGEMBTf0ZIhcJapEoVzHME
         Ms5tLS/ejGf3qWK4WWsUu+oRmeKRWrplsM8cxyIdb6egLcFmuzhD6KKRi/jouZh8rxaC
         EE0bLysXbkdbtW7V3KddkIuw4mFGYo0eZGdFc8kpUtgOMjUtLE2cgGFLEq/TL08T8flm
         3CHmervg6nI4kSg2/8R9IjG9pPgz5Ie1ZKSOd5RfeGcJ50KtrFbOqDZTWsq6yyHKHxdn
         Qu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MmQoXn1ppUt6tBlun+jsY8GfzDlX1YEW76k+uO1iBX8=;
        b=Av5KQlOOovvFYGQ0Uw54HroOuicGLNU5oWfvvds/sKSUecxrHuCJ5YLMxOPFynr+VT
         iVeGqfc3kGoemiu4UK/gRe9PNVy04BWbhruf3I9oJspz5Jz8fSUEWXMIt1wxiNqojDAX
         qkZEEngu53UNq/jNCsiQvyO68MmZurt5vBe+45WfFW7YhfyMHxgSoJCeuD6eXw8TDZT1
         wzn7MMY968z9Rz7YbOwpPMrQiJjBBWPtg2vpw6rvqyCxuHak0hAzMCXNrgmLtjLSjSpj
         fHvmOJbon+nG2aIvDH20p0kIDsdv+GkFZ7AZnkeuotz7M4Ibk7R5Ip3TByOR3HenKlgM
         Hg6w==
X-Gm-Message-State: APjAAAUUErfsj14aTbicVTywpzKyc0AJzrH2NxOC7qxUuaIXWwGgDqW+
        kvpbKZc01O6eLn+B6YSmniISbw==
X-Google-Smtp-Source: APXvYqzFy627Qoo8QfGm5ippCGvvEzVdk3qIQJIoTOhITTbKkwT2Gr4YgvB99C7FK1afQnGOAl8AiA==
X-Received: by 2002:ac8:444e:: with SMTP id m14mr6224826qtn.19.1569023986984;
        Fri, 20 Sep 2019 16:59:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p56sm2304890qtp.81.2019.09.20.16.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 16:59:46 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:59:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Subject: Re: [PATCH net v3 00/11] net: fix nested device bugs
Message-ID: <20190920165942.7e0d6235@cakuba.netronome.com>
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Sep 2019 22:47:51 +0900, Taehee Yoo wrote:
> This patchset fixes several bugs that are related to nesting
> device infrastructure.
> Current nesting infrastructure code doesn't limit the depth level of
> devices. nested devices could be handled recursively. at that moment,
> it needs huge memory and stack overflow could occur.
> Below devices type have same bug.
> VLAN, BONDING, TEAM, MACSEC, MACVLAN and VXLAN.

Is this list exhaustive? Looks like qmi_wwan.c perhaps could also have
similar problem? Or virt_wifi? Perhaps worth CCing the authors of those
drivers and mentioning that?

Thank you for working on this!
