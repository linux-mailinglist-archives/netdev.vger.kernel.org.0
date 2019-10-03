Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6847BCB243
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 01:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbfJCXXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 19:23:21 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:42206 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfJCXXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 19:23:21 -0400
Received: by mail-qk1-f178.google.com with SMTP id f16so4115381qkl.9
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 16:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Ha+uxYH/1CCIKar6ByBUKp7m4PjybSMAHmqsGfdJHG8=;
        b=FDhKadzZdVa+C4em/YVPUoQzWpTZwguaAzEwveWWreCooWDCfMQV/5RSI4FDO6H9Ok
         iBZGkUxRbB16s6PbKudsIO5BP5rAbA9CNylvaB5//LSms7xaIdSS30CrnMMC8WXg40+X
         zIfXpQp7qj5ert4WQtaQBMS2wzkPl99kjuxVot7EujR06gx7B9fQwhN+gzySC1n4RqX7
         TGX3wud1uhLUOwX9sfiElVyXY8O1ZoyX69BO9P+Kz3xZo1zJWD84JEXUEnHHBeGq1q/i
         nakTIEu0wPL2+xeVK4cnv/MSD+ARk4XS2pVTUMnKgP7V0qnRezPtdtKdxHzXVkpjjcjQ
         Rw2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ha+uxYH/1CCIKar6ByBUKp7m4PjybSMAHmqsGfdJHG8=;
        b=HeY7UgZ3bShZwQh3JptujtsfRN8rqX5aCZDn9dmQ9y0JypLYbcHP2VGZdx3fEcEse6
         or/2LZrZ2OniehgPqiiWyFThRhdAe9mFUKkElORWbzDdlf7AVV4ObhZLJsBfaG/b6N9A
         ASN2TXhupzdCt6Jyn9/zglH5iUf6uXRvEf2R4n63YVhePfd2AtW+oEWiSI5iFeKeZuyM
         UmQ+DX/Kk59x3Q41vtm0OG4JYKD2x390ZvURevZVmCFD9FEZu9ohE9hUQhoKS9w4c+ik
         5VqgEyMlZsYUTaaqh3uVmTNxf/pmcc2U1HqabOaS+4ONXqn05hzyZy70hieWmesMe9U4
         Fq/Q==
X-Gm-Message-State: APjAAAUCBHP0i8Z1GJTznjLFsnZd8vGGpkXoIzNrJ4AV2AolIzzYWTko
        iigT4UuQeJSBWeATwMQ8UmAC9Q==
X-Google-Smtp-Source: APXvYqzvN/1YyTDgsgLQikM50OqWt0Ks0iAlnvCsJSxNmOmq2vgdojaK3kpmYWJjQOCGz6FZUInXYg==
X-Received: by 2002:a37:82c1:: with SMTP id e184mr7547761qkd.206.1570145000643;
        Thu, 03 Oct 2019 16:23:20 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t63sm2111861qkf.48.2019.10.03.16.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 16:23:20 -0700 (PDT)
Date:   Thu, 3 Oct 2019 16:23:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 14/15] net: devlink: allow to change
 namespaces during reload
Message-ID: <20191003162314.159fab59@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191003094940.9797-15-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
        <20191003094940.9797-15-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Oct 2019 11:49:39 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> All devlink instances are created in init_net and stay there for a
> lifetime. Allow user to be able to move devlink instances into
> namespaces during devlink reload operation. That ensures proper
> re-instantiation of driver objects, including netdevices.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
