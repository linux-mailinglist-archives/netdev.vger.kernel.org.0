Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA617BC64
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCFMLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 07:11:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35151 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgCFMLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 07:11:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so795894plt.2;
        Fri, 06 Mar 2020 04:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mXgUVcT+I/w/zIJHOs7IG/O9ldpOSp4+EqBe0RI59H0=;
        b=OPZDZf5ayW3uA4vczPrtyJ8HqUlSoZxmNY0z+v/VPWbgqqHr/zBE1npidl/c6ktA7k
         v9BkCxp3wRNxuUJbhH9zcK0UyQWksDu1H53aVyr4uD/4N8evBOX4vRKZMNhD9bIsx74r
         ds9NK1Ri0cnWbw1Naj0901C3YvGzEMxdAaY7ySBRMBed7g4jqawyXxvdknzn5mB+Ik5Z
         4H0y9vBE/ubAQZ24gpH95yqYDa4Dh8G33dzF2eXPv75QQgc1qW+Ro0dro1wlggQfZ334
         IwdIMlNK1Uqo/iRH9GbxzvC0tYHB0rEN0UNh+GZxoDrgjBh1yZiV770pPXjmyZXZSHbT
         Ch+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mXgUVcT+I/w/zIJHOs7IG/O9ldpOSp4+EqBe0RI59H0=;
        b=rNHCtMxH5iUNeYWIpnu9+pbi+tSIALoOkhqNTDOD/dgtGmEKtBpPc0pt0UA/aTUEY4
         L2ik2yNCeJBpc24Cf0QByTT4HKuwYSWE/9paJDp47gkOIpghfrmJDHQj5u2dAg2yqDUI
         OXVyCaNjXMDhvHPKSJk6vMwXTAfXPF8x8e5XstxKXATpBepoBruSDoFmRnlNHzGDIk+p
         xt9yIAqJ1dPicljmRCguhjf2Cqx6BWSIi7FPZEk54Dl7OCwTxoT+6YFaejHXCleKjKSf
         67ScC4WVUElO0B0WvBMyRaPgfoqsCN/9wiz6OyrbYiUokJVZk6YYsLaHcDv0EGt2XDim
         nmNw==
X-Gm-Message-State: ANhLgQ1/+E4xVYYMgY+70GLVZot/bDjaxS4jzZgW7gbFRn51vdkiTxTQ
        YruXMckBFukNEWGth/d/tWgMlJOy
X-Google-Smtp-Source: ADFU+vtHrAd4USeZr2C40yP8o6eO/PMUCBl9Rln6YlTCRCc2QETTmig02b/CQ5YEY7fSSYtNIKsPqg==
X-Received: by 2002:a17:90a:9f93:: with SMTP id o19mr3346869pjp.76.1583496681613;
        Fri, 06 Mar 2020 04:11:21 -0800 (PST)
Received: from [0.0.0.0] ([2001:19f0:8001:1c6b:5400:2ff:fe92:fb44])
        by smtp.googlemail.com with ESMTPSA id l3sm9333308pjt.13.2020.03.06.04.11.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 04:11:20 -0800 (PST)
Subject: Re: Maybe a race condition in net/rds/rdma.c?
To:     santosh.shilimkar@oracle.com
Cc:     netdev <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        haakon.bugge@oracle.com
References: <afd9225d-5c43-8cc7-0eed-455837b53e10@gmail.com>
 <D8EB4A77-77D7-41EB-9021-EA7BB8C3FA5B@oracle.com>
 <94b20d30-1d7d-7a66-b943-d75a05bcb46e@oracle.com>
From:   zerons <sironhide0null@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e525ec74-b62f-6e7c-e6bc-aad93d349f65@gmail.com>
Date:   Fri, 6 Mar 2020 20:11:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <94b20d30-1d7d-7a66-b943-d75a05bcb46e@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/28/20 02:10, santosh.shilimkar@oracle.com wrote:
> 
>>> On 18 Feb 2020, at 14:13, zerons <sironhide0null@gmail.com> wrote:
>>>
>>> Hi, all
>>>
>>> In net/rds/rdma.c
>>> (https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/rds/rdma.c?h=v5.5.3*n419__;Iw!!GqivPVa7Brio!OwwQCLtjDsKmhaIz0sfaOVSuC4ai5t5_FgB7yqNExGOCBtACtIGLF61NNJyqSDtIAcGoPg$ ),
>>> there may be a race condition between rds_rdma_unuse() and rds_free_mr().
>>>
> Hmmm.. I didn't see email before in my inbox. Please post questions/patches on netdev in future which is the correct mailing list.
> 
>>> It seems that this one need some specific devices to run test,
>>> unfortunately, I don't have any of these.
>>> I've already sent two emails to the maintainer for help, no response yet,
>>> (the email address may not be in use).
>>>
>>> 0) in rds_recv_incoming_exthdrs(), it calls rds_rdma_unuse() when receive an
>>> extension header with force=0, if the victim mr does not have RDS_RDMA_USE_ONCE
>>> flag set, then the mr would stay in the rbtree. Without any lock, it tries to
>>> call mr->r_trans->sync_mr().
>>>
>>> 1) in rds_free_mr(), the same mr is found, and then freed. The mr->r_refcount
>>> doesn't change while rds_mr_tree_walk().
>>>
>>> 0) back in rds_rdma_unuse(), the victim mr get used again, call
>>> mr->r_trans->sync_mr().
>>>
>>> Could this race condition actually happen?
>>>
> force=0 is an interesting scenario. Let me think about it and get back.
> Thanks for report.
> 
> Regards,
> Santosh

Thanks for your attention.

Regards,
