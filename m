Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EF92DB681
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 23:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbgLOW1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 17:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731458AbgLOW1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 17:27:37 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE6EC0613D6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 14:26:57 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t37so16192306pga.7
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 14:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ifcco6PX76YQ45tKe2inJrTYkvhCiuEFvk/GLF6t8GA=;
        b=audUKUjpjL1xOWFsdnHuf+NEn7nNffaFm0l75KCHXdEJkz8gosVrIKngDgDjPhh7wR
         DD3lhn6RuqN34t5U71QxX/NOpZd093GP3P9Ocz9IT/obrn5RgiE69wRNInleDE0bbqDa
         db7EN6M6qIFoajU1tMsJoO9z6bnYxyVCJceNft1bC3u8iIzkgEc6RHggz2yeZAbpmZVI
         tXBBxunYl9TbUWsQfXRettZMuKKkTVCS13XQsN9QwBZPuBGUGcti1yq6op4U5KIkbdIW
         k79m3JxwPqlGboqm7R+mJmtGi10yIugVI5lTPb5qtx4KtFnEkWBB+iwarLGplMbQUb2D
         T3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ifcco6PX76YQ45tKe2inJrTYkvhCiuEFvk/GLF6t8GA=;
        b=fGpYL1OhlDOpd8V6oor2np7bgliJ24z8vXKPT+WVYG9CLTJ5YesDaL506Wy+fJ7Tl/
         9PosITwWHL3FrEIP+XFeasMXpZFYPOtzMTNorhnGio/tVGLKTz4CK2VlA8/et79mZpdk
         VHUDbnat9v7t3ApeSw5c7GR+91EqJwrgmz5N65waxmQhkEZDYs37Kl4J2jYQs6WPc/Rp
         0KEhHxjCEsDPyu3c+CcsHVhpccmDcemVzvHlg3fSvrHcGg45/SBc6lk2cZWAVzQh1uBp
         J5ig0pxiNHINf4q2kH3E2/WkCa7JV+9fegOyVekMCpfHLuidLNL3SPotqgM0AJf+/mei
         964g==
X-Gm-Message-State: AOAM5309a6s201ZUUpoIJDwFyued6UguNgH6K6la45meSLJ8DM4JBlz/
        0o4rZ5IcdBX+WRZhrWYrmR7PYA==
X-Google-Smtp-Source: ABdhPJzIzxRVOR9BpmwQ0FHqr2Aua3g74/CMP05BJ3Iroxe2pxYIkgsVVZJI8Dg9nthEOzOG2C0ENw==
X-Received: by 2002:a62:19cc:0:b029:19e:321b:a22e with SMTP id 195-20020a6219cc0000b029019e321ba22emr22973030pfz.73.1608071217090;
        Tue, 15 Dec 2020 14:26:57 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a17sm131174pgw.80.2020.12.15.14.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:26:56 -0800 (PST)
Date:   Tue, 15 Dec 2020 14:26:53 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc/htb: Hierarchical QoS hardware offload
Message-ID: <20201215142653.2a16e888@hermes.local>
In-Reply-To: <20201215074213.32652-1-maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 09:42:08 +0200
Maxim Mikityanskiy <maximmi@mellanox.com> wrote:

> +	print_uint(PRINT_ANY, "offload", " offload %d", !!tb[TCA_HTB_OFFLOAD]);

This is not the best way to represent a boolean flag in JSON.
Also it breaks the "output should be the same as command line" mantra.


My preference is json_null to indicate presence of a flag.
Something like:

        if (tb[TCA_HTB_OFFLOAD])
		print_null(PRINT_ANY, "offload", "offload", NULL);

