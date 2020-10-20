Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D26293A13
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393157AbgJTLdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392324AbgJTLdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 07:33:37 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D39C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 04:33:37 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p15so2688780ioh.0
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 04:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=31M9r4MpsEBS65Ty40jYoAr9fmOGjpA6iUmyeE8Lv8o=;
        b=uNWuGgUtLGLTq2Q0u4srwMpURB6OCLkx69j3DRYjpesbN9LwUtF8RjqJ1aMmrDaREe
         kLo6Q0rk78BNYWeWMogDi+yN4pxM8Il0HcQsRh8VgiiVAlcxH4xnIvz3hGM2tgYqyP1P
         SG5/UOsN+HsT9XEhGbXleU9z1/9qcT8ygg5dJxmqkpbjWojHnoAtj93RopCvQ6+I93QA
         MH56jqoEsZHmtXUqvJDvOH+9bqimGTe7a7eEhfzn3QCICEXDM0Le7o0BkpCAUxb6jt1Z
         helJmZmoZna/X4RB8wHXOFc1pMeCpjs+0BKfH2nKgYdkdIKOciqXPE3YKXHdVD7KAfBQ
         6hBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=31M9r4MpsEBS65Ty40jYoAr9fmOGjpA6iUmyeE8Lv8o=;
        b=QwD/6Vxf0nFctz7S1p6e5k0ZcU8sxDcDNo4EFbpXo7d89GXx6kNJbWyumVJC6kdaqt
         5n4jYpWgr1ff8e7FQw7Ue+cAHlb3S3D0AuQM0vn0WGkqovwaNifmUCdr08NYIMZb/JVn
         TizPW4lG46c37PO6UzyrWd6h0LZEIltMf2BGVxHm1+D3TAQL2p2vp4JZmiUfc5dEjf4C
         b7s5yf8JMidPYgtxCL/2AclY6UgMWwbtjHWu2uDRUDHbzTvTE3A1td4/l83UlWG/ulvx
         b0LzK/Tab0IHc+ZBZ24Z7jpvnKDw3gXOy6mK1TMEmtFSDlaH8Ua6k/mtRiDyaA5vdb8F
         KklQ==
X-Gm-Message-State: AOAM530OV4885H8gmOhV1oLZhaWNTaeC92FzmgbuThWZdNJtfF47rwIl
        0fMbR4BPfZxjaaGAYLnvuHoTTA==
X-Google-Smtp-Source: ABdhPJxQDBGFsNLX2OO38QQF0nXQI3+eXMvRQIv/EZ/HYs0nv98sw2IabrXL3J+87yory1rAYvAbEA==
X-Received: by 2002:a6b:6610:: with SMTP id a16mr1739626ioc.108.1603193616597;
        Tue, 20 Oct 2020 04:33:36 -0700 (PDT)
Received: from sevai ([74.127.202.111])
        by smtp.gmail.com with ESMTPSA id p12sm1844208ili.14.2020.10.20.04.33.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Oct 2020 04:33:35 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 11/15] lib: Extract from iplink_vlan a helper to parse key:value arrays
References: <cover.1603154867.git.me@pmachata.org>
        <233147e872018f538306e5f8dad3f3be07540d81.1603154867.git.me@pmachata.org>
Date:   Tue, 20 Oct 2020 07:33:23 -0400
In-Reply-To: <233147e872018f538306e5f8dad3f3be07540d81.1603154867.git.me@pmachata.org>
        (Petr Machata's message of "Tue, 20 Oct 2020 02:58:19 +0200")
Message-ID: <851rht9loc.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata <me@pmachata.org> writes:


[...]

> +static int parse_qos_mapping(__u32 key, char *value, void *data)
> +{
> +	struct nlmsghdr *n = data;
> +	struct ifla_vlan_qos_mapping m = {
> +		.from = key,
> +	};
> +
> +	if (get_u32(&m.to, value, 0))
> +		return 1;
> +
> +	addattr_l(n, 1024, IFLA_VLAN_QOS_MAPPING, &m, sizeof(m));
> +	return 0;
> +}

addatr_l() may fail if netlink buffer size is not sufficient, may be:

return addattr_l(...);

would be better.
