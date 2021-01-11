Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F42172F19AD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbhAKPbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbhAKPbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:31:16 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71692C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 07:30:36 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id b24so58151otj.0
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 07:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=izEoVrhhzUTfmhTNdUhJygiRJ4pa739lPJhKs99QBqc=;
        b=NmZ0/azz5AcX4cSdyLHwp4hV1zApSiTA/26RxFK9hN2zRTJMVl41yCFzZflGhgCbO3
         JHG6z4PKS7V8n2U+Fad5HKJGGD54GLcsrU5r3+rgX4E2at9h3XFGGYiU6t383BPd50fD
         0C6yCzdbmQjjoueVF1u88n2Rr1aatfKE3wXM7VQFuBx7xHxDjNZmrlz7FiNnVpr775nZ
         RPCx1U3n7HR2v8Z4Q1yqG92+aeAm8IvxYCqsmjphCpmiJZ1cfbtG/Jopc6akGSDN2mon
         FkQozN2Y91bo3q+dvw3onoS19GoFDc+nw47C4cMWn29kWWnR+yy52szH7v3LG0vd3RJT
         d1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=izEoVrhhzUTfmhTNdUhJygiRJ4pa739lPJhKs99QBqc=;
        b=rFwlbZ8dbFuI2CwD0VDXUOIiXWqyHFidL3y9p8iZ9EpNiiGYZGRymGfEp/CP6i80PS
         IPM43mnwfJFYAXhRKvsxGOjiohUNybJH8q/rYNW3Oe2hnDL1BTnGmZetteOSsPzTkhNT
         K+agi7IPYL14KrNxX+7JgiOWbcsWJL6Vl+kuEbWzE7zRd3/F2icbv3BC2spq34lUAmeR
         3jIHi/j8OcoL1FfcDo1YRgaaVcHzgq8rgH2oN7XWgseJJhpZm58ArjvAxM8gB6cAjq/G
         t6nb3IcKQ0Fq+snEEr2ZLcQGO9T/dWJu1uZQavoFjXFLz68eSsqu0DrdiiUpjBzxGrYw
         nN/Q==
X-Gm-Message-State: AOAM532CoiVH0hXXfUkAZiM34pLxuqz9WtBgh+g4rQFPmVBAutEnID1H
        Fsx2eg+byYB09WWAbCCZwBh4v0P+3yU=
X-Google-Smtp-Source: ABdhPJxUKq5TyYisvTDGLfazT3/EFJQ3mRhCyLzlcWlhrbvFzw8YqRUcY2yjhn3MmVs3QUP9EmktCw==
X-Received: by 2002:a9d:7846:: with SMTP id c6mr11307030otm.169.1610379035620;
        Mon, 11 Jan 2021 07:30:35 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id 31sm17497otd.24.2021.01.11.07.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 07:30:34 -0800 (PST)
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
 <20210107164856.GC17363@linux.home>
 <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <31cfb1dc-1e93-e3ed-12f4-f8c44adfd535@gmail.com>
 <20210111105744.GA13412@linux.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <68d32b59-4678-d862-c9c5-1d1620ad730a@gmail.com>
Date:   Mon, 11 Jan 2021 08:30:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111105744.GA13412@linux.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 3:57 AM, Guillaume Nault wrote:
> Okay, but, in the end, should I repost this patch?

I think your patches are covered, but you should check the repo to make
sure.
