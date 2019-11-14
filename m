Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F313FCD45
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfKNSUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:20:47 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34522 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfKNSUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:20:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id z188so4313866pgb.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NnowgaVtzXN+2SDh7SBK0OGWcMTJWvDrtiftwUkFFMg=;
        b=cEbo2lEClxcR5/YAWeMNCJ98pDiM1PNUFCqmz7y/IK7Q9MICAqSpu6l9ikvV2WpBvO
         IJxyz7XP5YAqSCZ93uVaaKRorGzy87vgvOD6hRN0Wugf2xm8t/Iqw6OHhrZsfTkJO7EJ
         y26d0YFWKnOSUtME8wWHTjWr5yZWUASFUgvrm5Dmj5FMxJaot0qM/qajKKEiZVscimMC
         j7SSyqbv6u8SETJqy/Rs0iG2gJNukg6rm5LZ4sce5jBoUlXg/HOR3x9HQCT27hoee2W0
         dcORVcDiNRLvJuaI5KR+A5aRg2QAsX9ywRJv/1S9SwgVDjPK3PlGR6g+L2KL5haY+4pW
         KaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NnowgaVtzXN+2SDh7SBK0OGWcMTJWvDrtiftwUkFFMg=;
        b=guPJ+YU3NT70b42Gp9278bIXPbtdJsD5qYqgwAaXav+xC/XD0eB7GLWMPFBAaIVaKt
         dOAJ1omKs2ftsvBrqcOlCoOaiTfvgZErZnd8V+k2++7+7MfPkAEEj3u9cK4Oqj+0VMtU
         Zr7qmOO4pCfpI11WdWUZl+ThkkbiSdiDJwBQvBUVj+ReHcXYmTt84BeiGnDy6vs3SzvS
         KQOQTuUttsVkg5hOpil076DC9RRLxgENMi+0iJAetmZahVGs99ChAvbkPaFPaYC4S2lT
         WqtAvSh68DTJds0xv1/SJ7ogI5f91Whbb30NyO1R4NoQ7nX04E3sg2VWTla7X/wjynMm
         VXpA==
X-Gm-Message-State: APjAAAUuxXq/jW2oh1U+1z140iR2ifVVfmWZRe9VBFvbtZ3Dw3ul7kOb
        pVbjIWwJX8X5CT/+CIwvEjmuQut5KZ4=
X-Google-Smtp-Source: APXvYqy2qsE6NV0IdabXVRO7y/iXEav6zWKynOXfwQUmhWnd1mL7v3ZGOZzo6MPjLwVsZWtIirmSxg==
X-Received: by 2002:a63:6c4:: with SMTP id 187mr11838925pgg.421.1573755645324;
        Thu, 14 Nov 2019 10:20:45 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id o15sm12056545pgf.2.2019.11.14.10.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:20:45 -0800 (PST)
Date:   Thu, 14 Nov 2019 10:20:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v2 2/2] cxgb4: add TC-MATCHALL classifier
 ingress offload
Message-ID: <20191114102037.6df3aa23@cakuba.netronome.com>
In-Reply-To: <90842f5408ecb616c7be1912f803f1689b612172.1573738924.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573738924.git.rahul.lakkireddy@chelsio.com>
        <90842f5408ecb616c7be1912f803f1689b612172.1573738924.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 21:04:05 +0530, Rahul Lakkireddy wrote:
> Add TC-MATCHALL classifier ingress offload support. The same actions
> supported by existing TC-FLOWER offload can be applied to all incoming
> traffic on the underlying interface.
> 
> Only 1 ingress matchall rule can be active at a time on the underlying
> interface.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> ---
> v2:
> - Removed logic to fetch free index from end of TCAM. Must maintain
>   same ordering as in kernel.

The ordering in the kernel is by filter priority/pref. Not the order of
addition (which AFAIK you're intending to preserve here?).

Since you're only offloading the policer presumably you want to limit
the port speed. The simplest way to make sure the rule ordering is right
is to only accept the policer as the highest prio rule. I believe OvS
installs it always with prio 1.
