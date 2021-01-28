Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6C4306A61
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhA1BbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhA1BbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:31:12 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D477C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:30:31 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id hs11so5439166ejc.1
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O93nDuwi0sHDq1zfGslQOfVW2mgps/9mxxTp8mPOWRQ=;
        b=OGZZgcnPSxpgRFMMzQAnTSFYEZtYDu8DIQIx8kPGBdeNCZ2rYF4qe0HKKbLIfNseGU
         qLoOYCJ1EuKBQVpMi9QBaPZ1Jc8c/Dl4F2LaZ+FhF+95VcxN/Iu7lxg2TJT8Mlnvhpr9
         YwV38WribWcSt7PIXbuH77KdZ4k3lTiTw+Or3a53Q8KXGYhNnHVN27Y7B6zByoykBCUz
         ezghT6RtiUVIN+o9tH3EYU+PVTj5DcepL4Lt/eBy+KJDdVcYbNYEVnnZiqK8zsZ+Fa0Z
         4Syjl7c9hWch4zW2UaTpLhowhlMKpxn8gyyF5TRLM129WX54FXGSl3dGFHwE7S67Y9xA
         c66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O93nDuwi0sHDq1zfGslQOfVW2mgps/9mxxTp8mPOWRQ=;
        b=f24Dh8NAPl03QuYrIN5A7VTeU/pouojaQ59k6l/Mya3Du585VwyqjBLwjZi2jQGMJ7
         VbXdSJpvnPg/QP/eRr1nMiQZGKNEfvx5+h41fYczZ0eCVjwEI4YPmA9MZtZQnt2HLgDo
         oaGtHRmWG8yTfGkerwnIOx5eqnCFo8UMkE7tATNo6DInF28276CFW9kN8rPNkO8LtWLY
         nqYIiYvTbPdOid2Y+cD0R03KIqxdPYhZFFo96ugXH9Q3t4No766hehx9XbC+Dtzhb/e0
         tPmM3/0IRv8OYLfKKa8wty9+hSJP3VYx8u7HF66qek0Mytlgq4SefRhk11r3Ix1gXWp6
         yFkg==
X-Gm-Message-State: AOAM5335ApFQnZUdclpbYlXFCnJ0fwgZRum7I+4paI+sM1CMWKNv58EB
        ac1lIE/rj9G8Uf9ET5QQ+xM=
X-Google-Smtp-Source: ABdhPJwC3ze1e4Ho4oFleK2uQZbfIlsBcq2qGXtQroYDUEOYEU1QbuM0YIJsuwDxHViAb5/8z6GFEQ==
X-Received: by 2002:a17:906:a851:: with SMTP id dx17mr8453955ejb.537.1611797430035;
        Wed, 27 Jan 2021 17:30:30 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m20sm2386251edj.43.2021.01.27.17.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 17:30:29 -0800 (PST)
Date:   Thu, 28 Jan 2021 03:30:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 0/4] Automatically manage DSA master interface
 state
Message-ID: <20210128013028.kr6jx4xjcm3irllo@skbuf>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <99d4c608-d821-7f87-48c1-aa1898441194@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99d4c608-d821-7f87-48c1-aa1898441194@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 05:03:23PM -0800, Florian Fainelli wrote:
> I really like all patches but number #2, though I don't believe there
> are existing use cases besides you one you described where it makes
> sense to keep a switch in an unmanaged mode being "headless" with its
> CPU port down, while the user-facing ports are up.

So what should I do with #2? Every other stacked interface goes down
when its lowers go down, if that brings any consolation.
