Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549EA26B4E3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgIOXdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbgIOXd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:33:29 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED16C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:33:27 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id n2so5960161oij.1
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0FqQEGnXegF6KpN/SWNhyU7nEtXpuNZUS2lt+ndow1Y=;
        b=aPUEdtzAZYIimqJDeU/Pzk0yR14rWcqumUoppaM7+qHIVGQ8lLCJeO32K9QxnCunmh
         bJXUyl85w3h896eHyfzkvCbTC9FmRus/BGNVO8rmWLAwDtCjolFAqReTaCfSfULYC5h2
         Zn8cYTdOi0tEopTp3Aet6PUV+1E4+tX4Zme7O4thSHgLcru27WC7Nf4HBMVXSWcsb3fy
         RIP/4Es4ZOLsghbvg79khE3oQkf+y3iRP7DlESuw2HAsoWokGH5mnL/yUKK9wnDUQQkl
         r8Rc/9wZlzrbBndeYqH1w+Jj96nY+q/mDaQRuAbuuABDkQXKSs/WWbqUn/hVxRLHSsLl
         yjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0FqQEGnXegF6KpN/SWNhyU7nEtXpuNZUS2lt+ndow1Y=;
        b=aA/9CbdUNB8QXywxUbKO4KpSVXd6C7ScOfbvXvtrS7s+kTMJGJYXdrtLuqC2tP2cw2
         BFRN7aOCAZtv+3xRC8MQuamgt5h9BEvclfOtbZ67UBRzQB+6m05iU5OIzgnocYZ9y0WU
         XIvoEp7rWjDVgjVFN9h0GHRBSVIksk8hCluoY02xR/wGehze27srxGVX+boRGzuirLha
         2EuvLDoXKttdYMtjyzhd2eUQEj0ZxdasdAdbqiVK7stZ0EyhnmPFRfJoEul5/pEnr0Lr
         F+edJSzeiwVjgcitAUUNGdDjr7lepqBIt+JI9x38b/wRvttbie7B4dTGvPxlGzpVqBmP
         RTiA==
X-Gm-Message-State: AOAM530Ag8tnYj6dQn7yCfS7e7a51fGMndnS4gGd9VWykmlr0dwbT6iW
        ms3USX7FQD9HahoLoyMmlTc=
X-Google-Smtp-Source: ABdhPJwAZUXOjqjMTCaQsKEVXPvtQpIjPdMiVZCqK1Npivn+pfDDzsQ9t4oTJ2ct/k4zMYRSd408qA==
X-Received: by 2002:aca:af94:: with SMTP id y142mr1186013oie.89.1600212807272;
        Tue, 15 Sep 2020 16:33:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4c3d:9381:7bce:9ed8])
        by smtp.googlemail.com with ESMTPSA id 34sm6886437otg.23.2020.09.15.16.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 16:33:26 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: Update exception handling for multipath routes
 via same device
To:     David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mastertheknife@gmail.com
References: <20200915030354.38468-1-dsahern@kernel.org>
 <20200915.154618.670584666009270972.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4d49256a-a968-55a7-0af9-27d4ef696374@gmail.com>
Date:   Tue, 15 Sep 2020 17:33:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915.154618.670584666009270972.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/20 4:46 PM, David Miller wrote:
> 
> The example topology and commands look like a good addition for
> selftests perhaps?
> 

Definitely. I plan to integrate it into pmtu.sh.
