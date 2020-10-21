Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F02295247
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439112AbgJUScj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410398AbgJUScj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:32:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E501C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 11:32:38 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b6so2406334pju.1
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 11:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bfHwI2AVSXHj8IUaZpxYPyiCPLoesYLnXt2GLEYNYE=;
        b=NcbND7nxFrye9cftNEno2Qkw3lxcRrHCCGFtXfsDczULrfXxS7ntEqF2QYYpixVlO8
         GQqL8ZnoYnBBgM+rEJajMf5u5lgW5908ncbLq2tIJKm7zQPFiTLLVhjPuRUsOSacupK5
         1wF4D8+kuRMY4IvQYgMs0mxzlL0T3pEVCjnTW3QfMos3zsyHme3i0jDPs3ZeCRRSLfk9
         1Erdg65VzNgaO7Mrs5dXyMTJb68Z/pzxVSGMk2mxLoFo4i+ny4A8J71wCPOx9wbDurrJ
         Ukps1U/7ozxYAjYXRlKRlCkG77FtH8nuildQWxgaieu7iW3A6y7N8MoviqQg52c+vCDX
         XC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bfHwI2AVSXHj8IUaZpxYPyiCPLoesYLnXt2GLEYNYE=;
        b=e7MaJgSoQo4sn8v14vHDiaa3yJd4b07Vweh3N3U0EFNOqq8ny1CiAF0TWvVuIajzXI
         TyvnzCoZp77gEzJKZcoQhRsbUkVHFU1VtJuCnn9G+Kfof2pM7yl1X04K/S4YUvTfhnRq
         hfz4WuMdXZGjhmzKfemU7lasuIl/EZO0wYIzMo+fe7RquPqara576hjn+G74z79+Fo/0
         SSHbhV0XA/trqMaMPJGGHd2Apmud1NRiqs8AypH5zPLRHM/HFyWxPj6/VG+lBtuTqdPR
         NZ7poYbVWbXBaKoWRlxOaabyEFPBtM14tT5TVIOoGbbdHjJAaZlWMgkpb5LWkM659/Nb
         fKVw==
X-Gm-Message-State: AOAM532z3Ogz7GYesf3EN2DPQN5zd1OcmSL8CXxFBZeXtNmylmlLpYc3
        zYryEYVyHjboYCstFauI79DpHA==
X-Google-Smtp-Source: ABdhPJxc/GGad5sQQ4AhiTXsko92jDlJ+PnEgRCz4qFwxEzemjPIqZ7Y9y9vfg8x81SmD0HKwrQXLA==
X-Received: by 2002:a17:90a:7303:: with SMTP id m3mr4851741pjk.190.1603305158031;
        Wed, 21 Oct 2020 11:32:38 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h6sm3104761pfk.212.2020.10.21.11.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 11:32:37 -0700 (PDT)
Date:   Wed, 21 Oct 2020 11:32:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        martin.varghese@nokia.com
Subject: Re: [PATCH v2 iproute2-next 1/2] m_vlan: add pop_eth and push_eth
 actions
Message-ID: <20201021113234.56052cb2@hermes.local>
In-Reply-To: <a35ef5479e7a47f25d0f07e31d13b89256f4b4cc.1603120726.git.gnault@redhat.com>
References: <cover.1603120726.git.gnault@redhat.com>
        <a35ef5479e7a47f25d0f07e31d13b89256f4b4cc.1603120726.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 17:23:01 +0200
Guillaume Nault <gnault@redhat.com> wrote:

> +		} else if (matches(*argv, "pop_eth") == 0) {

Using matches allows for shorter command lines but can be make
for bad user experience if strings overlap.

For example 'p' here will match the pop_eth and not the push_eth.

Is it time to use full string compare for these options?
