Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CD63F2186
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 22:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhHSUZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 16:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhHSUZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 16:25:19 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20F1C061575;
        Thu, 19 Aug 2021 13:24:42 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id y7so13557599ljp.3;
        Thu, 19 Aug 2021 13:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pQEUb2DpSBf+f30qooNYEBTyFa02jgUYpst1ze2YdmQ=;
        b=mScAo9wzg1B/1Dc0eVI2p9I+HxaQZyTzqEwEtNZkX8GPoaW0mHgk79XX67udH7mdY+
         qEAZ4m0ptx/VYkOPWP2jNRVIYIB9C0xO20fEqH2UJnaoazyNqDxQUMcW98tfNnTQC3HQ
         PWtq82LrRcuCCOjTJNg3rXJskHHMV3VVDIuCUtYuYhRzFw69ldNAc9SdGxfX+aCsRUIB
         gVAN0gKcmVr8lYvkVj8ZfV+s2nal1uoRKmYrox6KfIR5d8xrVM6DhlmbAWn94WEpOtVQ
         pFfaZ7tY80kUReKegp4GkbVgcoa1FWNvNO1dU8eG5bWYk/mRIwdGAGbltusfOZmn9Gjt
         Llaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pQEUb2DpSBf+f30qooNYEBTyFa02jgUYpst1ze2YdmQ=;
        b=DFsAgfQh9AV6KmSvd4kGu2kGDzsTQNttTrqN5g80X2f/E/2fjM2GpcHoyQDvU9OJiJ
         tPoygyz7BkL7QF+20C4O47qW5xaAamE967R0k3ZI273c/5ulOKH7Mc0h2O2QzKYxfuTn
         Mx65NqlfTL6Iz93ZfLUHepC69aGIOaEbYUfZOcPEyG3ubVDKzAvFNFRPyXK1tHa7pvXF
         xxX/JRwveBBiFxBFCPqnpSqsEZyXNHEIyiTM+oi2Zxla8IKYdlBURC0lWjPXpbSyLQ+s
         pDPYYRu6u5KOuxOMm23rw7W+EJ41QyXsfL7OJCdvhGxupXevt8ZvkmFa3COt8Ga+5AMN
         Yodw==
X-Gm-Message-State: AOAM5311PnSV9AdEqYycwgY4EauH9rv/w/am++VY5u4UoYjFv+3S4VDS
        n16PKF7ymip9Pc9abbN6VA0=
X-Google-Smtp-Source: ABdhPJxEVttIB4XM6G8FYfmBdcUGSHrfI0LCt/O/ko6BfzWqWyVkW3+E7NjCAQYJCRI+G+DK4efI9g==
X-Received: by 2002:a2e:9b0a:: with SMTP id u10mr13490321lji.280.1629404680997;
        Thu, 19 Aug 2021 13:24:40 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id k20sm350898ljc.2.2021.08.19.13.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 13:24:40 -0700 (PDT)
Subject: Re: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        butt3rflyh4ck <butterflyhhuangxx@gmail.com>,
        bjorn.andersson@linaro.org
References: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
 <20210819121630.1223327f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a5aef93-fafb-5076-4133-690928b8644a@gmail.com>
 <CAFcO6XMTiEmAfVJ4rwdeB6QQ7s3B-1hx3LJpa-StCb-WJwasPg@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <763a3f4d-9edc-bb0d-539c-c97309a4975d@gmail.com>
Date:   Thu, 19 Aug 2021 23:24:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAFcO6XMTiEmAfVJ4rwdeB6QQ7s3B-1hx3LJpa-StCb-WJwasPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 11:06 PM, butt3rflyh4ck wrote:
> Yes, this bug can be triggered without your change. The reason why I
> point to your commit is to make it easier for everyone to understand
> this bug.
> 

As I understand, purpose of Fixes: tag is to point to commit where the 
bug was introduced. I could be wrong, so it's up to maintainer to decide 
is this Fixes: tag is needed or not :)




With regards,
Pavel Skripkin
