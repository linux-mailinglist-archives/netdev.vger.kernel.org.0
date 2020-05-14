Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ABB1D337A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgENOtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgENOtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:49:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B69EC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 07:49:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k12so30696431wmj.3
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 07:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mTghoz4t1DWomROPVYjA/f/fO6qVYdYge1Tj/mRAnYQ=;
        b=A70q6tUqRk2fE78dXbatACSLw6SfSJnvk49Pw1joTy42Vpjs+wxfs5tup3kODhEwJQ
         uT4jBMyFNsqLJe2Ko1csRNBKUBbE2WshWY6ChtmxtqEHkYADvw/lY1gAfYfjNuoa2z2O
         YcO1Te2XkfqgAFQ97ABEho7Wokp8kwhoQbAlq2LnrAUic2Vnl/jUKBddHnhdHYCAmeSU
         Sv/m7ozLhWsMfF8icz9yiw8dAZeR2l9SnO8ht8eCkX3sVSfyNSepBQX22SbPmSwduEPj
         WGZU3o/rFt573gbXqvpfbbbrqR77Ig4xIcNf/AARv2kJczsBGmC07kNjZSHAMQj4VuSe
         /W/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mTghoz4t1DWomROPVYjA/f/fO6qVYdYge1Tj/mRAnYQ=;
        b=F4+A/MQ5xlkqWpxxDXAu1m8KAWBX6uBLu0nJVIFKYSn2vxpCGyNcje1434AyCNpwpl
         tiPmQ1/6rft2rWu4C1Zv6EhltmnRcsY1DHt0tR0vDH+8EF9bpkVd+SGmzDmZQe783HAK
         XSBQnYqsoOBPzJEOgvm9RT0crD8bJW2bXyMKlauX5/pirmpDaWHHVBS1YX/xI9YLlMYg
         4fDKeM68N4bI68TnhsIKoytzcRNDANcXFusdUaXechQolvrZj7EyiEjGBDowSzKOvA+w
         ozlJnW2dfXZ0lfyoD5pDYvPm6dBVdpTSkd/mqWL5UnA57WZ9Flav7OqPf6Q/WmAzAxqo
         GUrg==
X-Gm-Message-State: AGi0PuaLZD8/udxFAFfOwDqvFmb4j0hAm9LVt6pJvB+gbuemAnbw4NsR
        kvwgDMGRNwcqOmj8pZoCagkbkw==
X-Google-Smtp-Source: APiQypLIR/gdHhSENJQnZxf+6GQn+bfJWBOhkB6Afa/n5rWxjxl3bua5ZyInqlSPAU+Cb9u+L5+wcw==
X-Received: by 2002:a1c:2b46:: with SMTP id r67mr51473155wmr.160.1589467780272;
        Thu, 14 May 2020 07:49:40 -0700 (PDT)
Received: from localhost (ip-94-113-116-82.net.upcbroadband.cz. [94.113.116.82])
        by smtp.gmail.com with ESMTPSA id z10sm21632723wmi.2.2020.05.14.07.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 07:49:39 -0700 (PDT)
Date:   Thu, 14 May 2020 16:49:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
Message-ID: <20200514144938.GD2676@nanopsycho>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
 <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 14, 2020 at 04:04:02PM CEST, ecree@solarflare.com wrote:
>On 14/05/2020 14:48, Paul Blakey wrote:
>> To avoid conflicting policies, the policy is applied per zone on the first
>> act ct instance for that zone, and must be repeated in all further act ct
>> instances of the same zone.
>Is the scope of this the entire zone, or just offload of that zone to a
> specific device?
>Either way, the need to repeat the policy on every tc command suggests
> that there really ought to instead be a separate API for configuring
> conntrack offload policy, either per zone or per (zone, device) pair,
> as appropriate.

You don't have to repeat. You specify it in the first one, in the rest
you omit it.


>
>-ed
