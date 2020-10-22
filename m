Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340862960B7
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894798AbgJVOLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439034AbgJVOLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:11:50 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EDEC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:11:49 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z5so1787605iob.1
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/ZEXAHRiSsbDNXxyCWI0WWEhqPVUdIb4dcbDNf0EVqU=;
        b=fuXedzVOa2YsfchGIHSkLn3gRqkkcp6GHxPE332ApvPuU15zIN/Df/a8qzCSZtuTRv
         EKdTdPMQr0ETqjaYp93QTY4JTgJIz8ovn/coXRHwnK8eG2iRbl43XfXjQkWBdclAVVKM
         C4CroeSd6PRX+5WU1AIEJUtfvZ5S6AK6+I8itwWhzh+sV47H0tWFtwGCZKJAHuqMngY3
         oQHIIWmt+vZFmEk7Ooe3qGWTUGC4oqUrbFAeO0/kj+d748qltDeN8x0OxpmdtSyTqiHs
         itPU/2+z/DZ+V5KpCl4HN6ZON2eRYW67hLaKbdaDc9qer+A2FzaY4+DidPEA8dmpsRYU
         QDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ZEXAHRiSsbDNXxyCWI0WWEhqPVUdIb4dcbDNf0EVqU=;
        b=JIzctPrjSRFzySlTgmdnw8xzH2RM7m7y3PfSTyN4RCu/JunsfBbTbuipV45J5aZ+tf
         mX2MG14mrhsn+kT6tqY6ZmAA/cijW0QvKA8Yb9JOqgFG9ARfAlGumbweSJy81Nt5gVwm
         IJhVEHUqVNGUY+mMOZJ0vPulwMKyWqkqBkzsceVYsNCCisNFLPKVpJKwEWx2tgSL+lFv
         kQa8F7Zoc5SEQfgj1vrQpiVVIBfe4NLTquOn300HW29SdsvDs4stNeAU88r9nQ2jrE/M
         n/2VB/EXzwHkQpsbXT1pw51uFKNQ3vc8Puq97UrX0IljySU+/tMreW13ZYSjhPaQIbLH
         n+DQ==
X-Gm-Message-State: AOAM530flJ6oRW9/QvzRcBBSL1dSUy12KfE9MSzj95tRmKMea6vy7CdM
        gjFt3Og90IFP0mJKkLGcy4T0iHf//Us=
X-Google-Smtp-Source: ABdhPJwy0JZFdOZWUYaMejMfniQlMiHF39BtYZYX9g+7LeKOD3XXZjMr9hpk/v+GxYHZLlYgKhiKAA==
X-Received: by 2002:a5d:8b4c:: with SMTP id c12mr1951029iot.167.1603375909222;
        Thu, 22 Oct 2020 07:11:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e8b3:f32:310b:8617])
        by smtp.googlemail.com with ESMTPSA id c3sm1383503ila.47.2020.10.22.07.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 07:11:48 -0700 (PDT)
Subject: Re: [PATCH v2 iproute2-next 1/2] m_vlan: add pop_eth and push_eth
 actions
To:     Guillaume Nault <gnault@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
References: <cover.1603120726.git.gnault@redhat.com>
 <a35ef5479e7a47f25d0f07e31d13b89256f4b4cc.1603120726.git.gnault@redhat.com>
 <20201021113234.56052cb2@hermes.local> <20201022083655.GA1728@pc-2.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4eca7616-96bd-9fab-bf15-b03717753440@gmail.com>
Date:   Thu, 22 Oct 2020 08:11:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201022083655.GA1728@pc-2.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/20 2:36 AM, Guillaume Nault wrote:
> 
>> Is it time to use full string compare for these options?
> 
> If there's consensus that matches() should be avoided for new options,
> I'll also follow up on this and replace it with strcmp(). However, that
> should be a clear project-wide policy IMHO.
> 

we can't change existing uses of 'matches'; it needs to be a policy
change going forward hence the discussion now.
