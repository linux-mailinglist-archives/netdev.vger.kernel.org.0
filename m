Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CF72C675A
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbgK0OBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 09:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730600AbgK0OBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 09:01:42 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DD8C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 06:01:42 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id 62so2334033qva.11
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 06:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c+sUfhvJ55gAEmd7Rcojp/OIxcow4g6K2srl7qbODOU=;
        b=hfg1aPduh9Ux5Nj2zxYoKBbZilTqyYr0nUEXUp/exmpgrNmHKXjlH98gxI6QkZ91zZ
         nA28XSDnObVyaCg8sDvYs/7BnPnEXwXMidTZmmMz6tsMTawpB19sMAp+e4J2UTbsqcQV
         9zKiI3N1gXphw7QT4QhTXQcwxBdmUxHz2t54PpiOK5T7jYhqL1HacEuDi6t/W+g5gR5K
         xhuFIC6CfHyyuKM6mGdHNv5Z7A07iPP27PGd6ku2wBoWhPhXN96y2kHigG7qGEJGb9XM
         dWxFT8OLEmgL1zS/B/niUARBSsK1OyYUZoYZPqe9ICIP+cA4+hwyHaFe07E+gszJXfJT
         Sm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+sUfhvJ55gAEmd7Rcojp/OIxcow4g6K2srl7qbODOU=;
        b=g6t7qPoZuMLrt0QzJ1naOM4J+aCLwVDLltfE5snssYE0VUfT45INLheYBWJEnLZDCp
         Xn/6WH8GPEqn/bfcg08gPR3SKtAL9jq+yz93cR0a1HaynbrOn2MUx7VXEVfH3ONHijUP
         aRrAlrtBy09lV6eY9SqGeKL1pMkho5ZLdmL1BFNDt5IBSrbGuwc9RrnIt+0k2QK0y47X
         h5p2Yg/L86R6TvIdRMi2UHzoqbb2ut8FiSWhWLpfS6STblJQDuVkGw/Cq2L+x3DleMCj
         Nq/XNIb7zUtgBuSvPEhCsLPCVfCkoJNCLxGOVJ/t4uUSDM7KF74pLhJlHS8FxKBgY/DX
         rD5Q==
X-Gm-Message-State: AOAM5312vMQzVrCD8m3xL8dN70eyyKc02dTteM4EjU9DMdi+O7XNgbeB
        cIpV15Sm5YUJQRcKkRPKiKw=
X-Google-Smtp-Source: ABdhPJwkxSi+pmDTDtBOV+zY+DyyPZl2TZDdInrHOpFuZUCjCE+6s/v2aD1YlD37plp+Quj7yZgQiQ==
X-Received: by 2002:a0c:e10c:: with SMTP id w12mr2031830qvk.28.1606485701455;
        Fri, 27 Nov 2020 06:01:41 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:a9aa:d5fd:a8e2:2c56:68bf])
        by smtp.gmail.com with ESMTPSA id u5sm6118569qka.106.2020.11.27.06.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 06:01:34 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id ABD9EC3B6C; Fri, 27 Nov 2020 11:01:28 -0300 (-03)
Date:   Fri, 27 Nov 2020 11:01:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [net-next V2 09/15] net/mlx5e: CT: Use the same counter for both
 directions
Message-ID: <20201127140128.GC3555@localhost.localdomain>
References: <20200923224824.67340-1-saeed@kernel.org>
 <20200923224824.67340-10-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923224824.67340-10-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 03:48:18PM -0700, saeed@kernel.org wrote:
> From: Oz Shlomo <ozsh@mellanox.com>

Sorry for reviving this one, but seemed better for the context.

> 
> A connection is represented by two 5-tuple entries, one for each direction.
> Currently, each direction allocates its own hw counter, which is
> inefficient as ct aging is managed per connection.
> 
> Share the counter that was allocated for the original direction with the
> reverse direction.

Yes, aging is done per connection, but the stats are not. With this
patch, with netperf TCP_RR test, I get this: (mangled for readability)

# grep 172.0.0.4 /proc/net/nf_conntrack
ipv4     2 tcp      6
  src=172.0.0.3 dst=172.0.0.4 sport=34018 dport=33396 packets=3941992 bytes=264113427
  src=172.0.0.4 dst=172.0.0.3 sport=33396 dport=34018 packets=4 bytes=218 [HW_OFFLOAD]
  mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=3

while without it (594e31bceb + act_ct patch to enable it posted
yesterday + revert), I get:

# grep 172.0.0.4 /proc/net/nf_conntrack
ipv4     2 tcp      6
  src=172.0.0.3 dst=172.0.0.4 sport=41856 dport=32776 packets=1876763 bytes=125743084
  src=172.0.0.4 dst=172.0.0.3 sport=32776 dport=41856 packets=1876761 bytes=125742951 [HW_OFFLOAD]
  mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=3

The same is visible on 'ovs-appctl dpctl/dump-conntrack -s' then.
Summing both directions in one like this is at least very misleading.
Seems this change was motivated only by hw resources constrains. That
said, I'm wondering, can this change be reverted somehow?

  Marcelo
