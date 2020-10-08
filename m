Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF93287662
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgJHOt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbgJHOtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:49:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDC2C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 07:49:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so6929438wrx.7
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 07:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jGlbTogp+WWEle49cNhFz/LxvohiBJco8eMH2L/Io9E=;
        b=ilsRDRrpJobEMCVTH1EydtxzXLHWWLVUYV4bj6keRoVDd73UpWDHeNnjQ84Pdh35k2
         U7S/LLkFI7Qcbzx9FiM1CYzQQNug6OLIrexU0VFzu25EAq0vDVTvYGuBQbM8+Zu1ObT7
         8GILqQzJ6D4xhGfFuANDS7lXoTuBTISmqASQqbnX0cfDp5U1jXTBU5OhK0QuObkVHhlx
         jz7ZhC9E2onKAayyHcQ0RKPo0Npypz7u/bOuL2qCy+reC/umH2fXNtVR9KHD94oxD0Ap
         dPAqgYtiJaUhqB6jkhpicfL7vfEdj6RgLY4znPkvqPmCIHQYJv4RW7w8BBWqoUNJdT31
         JFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jGlbTogp+WWEle49cNhFz/LxvohiBJco8eMH2L/Io9E=;
        b=Qzz30/qyuIGhM/HV2gv3Hex8BaMcYGEDVyNg9MKlstocJ2YJOpF+Ql6DjfNYxdu33W
         dARl+tkED3tFUnvmGTj69dq/0CVeFpnBnqZC9F3Kvgme0RIewlQrKG3Jik6N48yThPLe
         hup61A7JcO7YcDbOiyEuLheTYeCz0hlcMeK+FpuzB/gZ7dZMlAUP3zrvG5dVZQxzl16Z
         ylvv32WPBSC1tI3gL5LvSG5BYVdYGmRzgkMwKVFCgtw8jLkvHvl5NpdaeL21LUa0MxdA
         hnF2/ljYnBpm2NMuEbC3YltNmc6ZHidwRu4KZiRTCfCAgfvTL4csZ5mc8VOP6O+Qkcwx
         ezBQ==
X-Gm-Message-State: AOAM530cUOKZBgpTMoMTQK+BZUqVZs67cHR3mHUXMx09w9sPrOsUdfo8
        3xytzUk3FOd+nxZ8h2vozND+lPyKRQE1Ta7n
X-Google-Smtp-Source: ABdhPJw5kcnBuqSPZYlOUyMa2tDcmsk+z5Gd06P+wRR3LP4+1DdQ0wp2+fqYDCK1HZ3p/kOBBksfTA==
X-Received: by 2002:adf:c5c3:: with SMTP id v3mr10070288wrg.205.1602168593573;
        Thu, 08 Oct 2020 07:49:53 -0700 (PDT)
Received: from [10.4.59.129] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id o129sm7635463wmb.25.2020.10.08.07.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 07:49:53 -0700 (PDT)
Subject: Re: [PATCH net-next] neigh: add netlink filtering based on LLADDR for
 dump
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <20201008105911.28350-1-florent.fourcot@wifirst.fr>
 <710c74d0-61f8-a1ae-e979-4143f26dfe75@gmail.com>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
Message-ID: <92170809-c45e-4b39-09b7-37b28b05d479@wifirst.fr>
Date:   Thu, 8 Oct 2020 16:49:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <710c74d0-61f8-a1ae-e979-4143f26dfe75@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Éric,


>> +	if (memcmp(lladdr, neigh->ha, neigh->dev->addr_len) != 0)
> 
> Where do you check that lladdr contains exactly neigh->dev->addr_len bytes ?

True, I do not check. I had some doubt about the best implementation, 
since we could do:
  * exact matching
  * prefix matching (with a memcmp on length of lladdr)

Do you may have an opinion on the best choice?


>> +		case NDA_LLADDR:
>> +			filter->lladdr = nla_data(tb[i]);
> 
> This comes from user space, and could contains an arbitrary amount of bytes, like 0 byte.
> 
> You probably have to store the full attribute, so that you can use nla_len() and nla_data()
> 

I will send a v2.

By the way, it looks like neigh_add() function never check if NDA_LLADDR 
length is greater than dev->addr_len (it only rejects smaller values). 
Should we add a check on it? I do not see any impact today, except than 
user does not receive an error on invalid data, it will configure an 
entry anyway.

Thanks,

-- 
Florent.
