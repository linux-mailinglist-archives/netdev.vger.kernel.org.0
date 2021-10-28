Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A0743E6C8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 19:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhJ1RIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 13:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhJ1RIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 13:08:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B438C061767
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 10:05:43 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g184so7004924pgc.6
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 10:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P80mWq2efO7XNCPQKx5I/JRul+ReO+lrit056BshLOU=;
        b=WpQkvKk5Ru499rQbS/sHb4b84nH7IRWLutEhLHBXj/xLRKRroM/w8LttZPbmgxmICn
         aQu/+ckx0cWg7SyQUuNyo3IxmIirfUyrsNocmcSyadVqkbjxV/bnYbaCrsf6sCACWL6u
         bGFtXmRccE73HBFwBN+QS0t+5g+UhoY6XCFpchsjLvasgQYaQqoz5ZJcgngJDlD8uzwK
         dX9DMOjR7zPvQZxQUQJ67AwtGu+i7Lfk4BAnyU+BrJd5AXZMFkdbno6C2Dcki4fwgbqq
         h4U/6qGBtxIwyZrM9izZ5TDCX5dxejxIUPgHcG1yvcQ78BhVhyt9pvdPDPWyi8SZ1Xai
         RWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P80mWq2efO7XNCPQKx5I/JRul+ReO+lrit056BshLOU=;
        b=J7tFBqH4IV4JJ/MGZLI9HyNvcl+T3u0PwPpGeArjps8CRvIJR4YjN9tUuXSS8N5ryu
         BSMcX35Xsz3trHU1A5B2fe0AAELtB+RkbFpyPXbUQW84X7lWJWci6sI6OhPwnNOOQBQT
         FJ9mFZkUdo4M7xi1egg0ng92nTOiSoKuIEoVcj8uExyPvVRugzqCW+eSAK/oUBrXP0YL
         ySYTIIVTUmDleGxipE/d6koouKXrtVhLzls6b6v09xc+hdbmmqVk2qTwPw1vCimXRhlU
         iEI+7ldAmutgq9uek4PFft57Cgc5CokrD+KqxMxiNcbm5jk5lPyD6k5LPvQKcsqmiqYv
         7B8A==
X-Gm-Message-State: AOAM5332BnkFeRjI5GSwxIcWfS2bWjKheqXYdR4hgdiO7fv99MeMlWCv
        8OL3p4IT/b1FU/HiWL6KvpUXxMAplks=
X-Google-Smtp-Source: ABdhPJwpRf8V+iU+LV24sh7kbC2zPqVmNnp+NuYx3V7+m+W4OsLhG6c6s7Nwp4gJPDtjO+RbrKFOSw==
X-Received: by 2002:a05:6a00:10c3:b0:47c:305f:b318 with SMTP id d3-20020a056a0010c300b0047c305fb318mr5688833pfu.8.1635440742615;
        Thu, 28 Oct 2021 10:05:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n9sm9530606pjk.3.2021.10.28.10.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 10:05:42 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: populate supported_interfaces member
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <E1mg8lC-0020Yn-DA@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <75ed3a04-30dc-6df9-d336-1d908ec5316e@gmail.com>
Date:   Thu, 28 Oct 2021 10:05:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <E1mg8lC-0020Yn-DA@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/21 10:00 AM, Russell King (Oracle) wrote:
> From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
> 
> Add a new DSA switch operation, phylink_get_interfaces, which should
> fill in which PHY_INTERFACE_MODE_* are supported by given port.
> 
> Use this before phylink_create() to fill phylinks supported_interfaces
> member, allowing phylink to determine which PHY_INTERFACE_MODEs are
> supported.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> [tweaked patch and description to add more complete support -- rmk]
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

No objection per-se, but don't we want to see a companion patch in the
same series that make at least one driver implement phylink_get_interfaces?
-- 
Florian
