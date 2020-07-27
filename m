Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C2722FA4D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgG0UrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgG0UrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 16:47:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A5C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 13:47:13 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b9so8784378plx.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 13:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cPiYU4ySGmd7ZgVVJkmwvg/21zub+FBLe3+M6dbFVdc=;
        b=eNk4DgXLJ8nCVHGDdjK/vwtNn1vCkWBhhWGOb1KfdDUWs1LvfEdcq24RWC+xEo/G9R
         2UZmk7uj/8Ma2WwoK+XMC/IY8TFXFJ3+Pu0P+JNc3vFjxD4jWKLaCHjM1Drtp3GlISn3
         0ajv/eV8Z1H33MtYEHaswm70TBczmvRrPQqoCD3aLc2oavQwt2StsSOTJSNSl1HmW6Rt
         Mv40ni7bQC/HLpWqsNXlTL2fhwLb8XbpgJ2GWNEBmPEMybt+8Y5WRJ7oyBgNnMYx3dlU
         TFhAo/a3BLZmW07+31i8lBeHFCKsJil0OsZ/uXo8UvBaJQuUQ2l6bWgqur1OaYNv7EA6
         3Wiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cPiYU4ySGmd7ZgVVJkmwvg/21zub+FBLe3+M6dbFVdc=;
        b=J94u/3Xh7se2aFFUA4FxtVx75mnzmQAvzXubBZw/QSJQQbSK97YsUI+XVlFTvOpT5v
         TmBU6GBQbb3oilCt/l0ZBD9+C7HywiF20/RVxOfqaYLD3uq+4UQc2gKbhr+ayh/WQ/Ud
         BhJMIKGizrYz2QOZfxCBrROj6I0drj5NNe3QGUQL+y4sd7hLnqrphgelguipaxk5sgW5
         E8PAgo5fCZ0m75K8k7jNzf6gWrZIJMz8/jmYAY9T/E5/TBgxTZlJiLLK2ScnUBrybBKf
         QSS8uTANvApCSZwGCPFFUfFfAgc80tPse/1hPhjg6FzybzI1//JzvOAySZmcUHZiCZzV
         jTwg==
X-Gm-Message-State: AOAM530an4NQBHsrnCwhwCplKJDOJaGoQJqw8ytaKouQf6+YkyW/Ob2s
        ZACdEYpejheqjJ+mVtVdy9jQ/w==
X-Google-Smtp-Source: ABdhPJxQVEnbE7jHvP5FmQMpTRv5T+ILNhAZDq4DGwQKV6S/eFI41NqS9+tA+fAzyJOdlBeopRI+rw==
X-Received: by 2002:a17:90b:138a:: with SMTP id hr10mr943992pjb.161.1595882832677;
        Mon, 27 Jul 2020 13:47:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g26sm15956118pfq.205.2020.07.27.13.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 13:47:12 -0700 (PDT)
Date:   Mon, 27 Jul 2020 13:47:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next] rtnetlink: add support for protodown reason
Message-ID: <20200727134703.4243db74@hermes.lan>
In-Reply-To: <1595877677-45849-1-git-send-email-roopa@cumulusnetworks.com>
References: <1595877677-45849-1-git-send-email-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 12:21:17 -0700
Roopa Prabhu <roopa@cumulusnetworks.com> wrote:

> -	       + nla_total_size(1)  /* IFLA_PROTO_DOWN */
> +	       + rtnl_proto_down_size(dev)  /* proto down */

Changing the size of a netlink field is an ABI change in the kernel.
This has the potential to break existing programs.

Wouldn't it be safer to add a new link attribute for the reason
rather than overloading the existing attribute?
