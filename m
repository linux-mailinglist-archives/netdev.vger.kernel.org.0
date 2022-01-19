Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64754941E6
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 21:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiASUhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 15:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiASUhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 15:37:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4B3C061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 12:37:00 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d12-20020a17090a628c00b001b4f47e2f51so4596048pjj.3
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 12:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ibvSbH4WJjct5OBbWq1TzGg3kgQA/nzW1blslubO8sc=;
        b=bWA6Uy/wFgGkumfgvfn72mB/tjOeB3DPQ/idtdDk7j6VVOy+HFA3lZRX/lj8XmFtP9
         We+ySMQ4TurNSBF9clDB4d6zz5TrWm1NzSNt0rmT8oBt1twlVmsU5VkEKdHSQDZ2Od6r
         XqmqmW0bUBLj82g+aYs/2J2LGeYejk7bMAH2sTeq8KthgI9iUyHYB0c8utUA10hUp+Lr
         mpKaR2J01dXEIed/KaAzCPQhxf31I9L+FtpCGEHmf0J+5fISGE3ocGhqJhL8g7cudSyh
         KE1AxqkjQYMAtI6BlkloJAhURcg3z3x6DTIneeXHO9MwIqXnwX/Mk8QlONEab7kC8oJA
         HcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ibvSbH4WJjct5OBbWq1TzGg3kgQA/nzW1blslubO8sc=;
        b=zsSdIMpjFkxKdPIYE4UnVTPkExG8iPbwkRdmDMkEEUg0Kbhdy82BOYP8OJlCQBJD+2
         11PI21KTWtt6zGgEJRsknpXxplpQD5gVD+gyBFkmEQ48gvl6t7mRSU3EDJDLGONobwoj
         Cvuhx7RdjFko2MKzwT4pBx3zz4WYtOMXHP7myOf8IaFuNNtFY5mzFwBViYpj8VeIDRZQ
         lNS0hXNp5wsGlcUmBHde5UGQWlzIscl2/msXdIAv6em6OI+JzUuJuBp88ojJxCZNa/Ty
         4XSL8gfwoKqChDiKx6Ui2MLHusnWJkKmbVRrChFs2qFPMFieuehLJNqW3TSECWp6L//r
         lkrg==
X-Gm-Message-State: AOAM532inVwcMLp4dE2edjpRonsJAebRe60bjRL8jUuiXL8wyYZW98wt
        ks3lGMqlGf1kE7eFk6AaWofukw==
X-Google-Smtp-Source: ABdhPJzYO7TwiFnyzcSlfALw7bdCxW9vLRYOP3UivgU8PUtLLqQ1pKJYcMZ/cimbl3ZorVrFgCj+rg==
X-Received: by 2002:a17:902:c40a:b0:14a:7fef:981a with SMTP id k10-20020a170902c40a00b0014a7fef981amr31918504plk.156.1642624619768;
        Wed, 19 Jan 2022 12:36:59 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id nn1sm7146482pjb.16.2022.01.19.12.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 12:36:59 -0800 (PST)
Date:   Wed, 19 Jan 2022 12:36:57 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        "Maksym Yaremchuk" <maksymy@nvidia.com>
Subject: Re: [PATCH iproute2] dcb: app: Add missing "dcb app show dev X
 default-prio"
Message-ID: <20220119123657.51d3e027@hermes.local>
In-Reply-To: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
References: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 12:36:44 +0100
Petr Machata <petrm@nvidia.com> wrote:

> +		} else if (matches(*argv, "default-prio") == 0) {
> +			dcb_app_print_default_prio(&tab);
>  		} else if (matches(*argv, "dscp-prio") == 0) {
>  			dcb_app_print_dscp_prio(dcb, &tab);

This is an example of why matches() sucks.

Existing users using:
   dcp app show dev X d
will now get different behavior.

You need to redo this patch and put the new argument after "dscp-pri"
