Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA46EA5F91
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 05:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfICDNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 23:13:44 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:42816 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfICDNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 23:13:44 -0400
Received: by mail-qk1-f171.google.com with SMTP id f13so14272802qkm.9
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 20:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vCOtJHCH9cTZCv822fAyW+OPmayoCJ+PCQuotJNQybE=;
        b=UeuFaehLJlmabYDqViRekCg0Xf+0whuZSTGDfab8u4xlsuc/C3MNm1HOhb5hjdx1/T
         nNj018jCwzYpSPujmrjTGhwbWL+ih+eFWcP7+MQN54+yOc6FPDvOtHoPI3vbpgJgyt4N
         ToM4FRJUzT3HOF3k59oelxqCmiINd8myP6VKg4Y7pWgmYqn0vfZpH0UYt+1LjVXffdiE
         +hFjhhW3owfB+zeLzFm3B52KOSNLf27j9s5KvLGlkl6TQOEM0mMDDA2d4S+Cqnm5Nd/4
         lXhaBxXYucKiviODnzb6Wi6z/uD+O7M9gxAS1oidRxZgP/smfka3l52bkxD0qHKNLH3g
         7pHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vCOtJHCH9cTZCv822fAyW+OPmayoCJ+PCQuotJNQybE=;
        b=brcA7Uu5VRq4dvDqZgCOxrJm1gxI1MWA6nKlnMco7pGaPqThMzP2wNcfcvx4L+Urf1
         uoW2r85jvERifajh5yaNMnqY+79UiCsZGr3bCgKXvqE3MRimgkZAbterOh5LWkljgumI
         yVqTK7HJ5mR1tCj7kw4yOYB9SQcNFd95cDC+BVIki7QjJ1Xv0jWeO+7UBNFdzkXLffAJ
         lEdr4PiQ4XZD6kF6+RpXto0kjm3p2dXM+OMPsCgo7hNkRAYz5Ti0R9RTFvoZvlNeeYT7
         TE8fjfMub0fd17wL7n13dgWeHyXbLMIXlzx4LSHZsL5EHyRRlfQddMSJhEKe7cWASopp
         q9EA==
X-Gm-Message-State: APjAAAU7qdqivls91tGAlsG6eFH8cQxTMGQ61ljhiArpMxnQOplKMPFB
        FfscTrODZ8RJqRQWQ7LCoEr8vE20
X-Google-Smtp-Source: APXvYqzu5FiNqR2RxE68+7+K9k/xH6tU4k8KNMrKlVJn4tD2O9KvYUHADpUenjgm0HJVpI0bm/vlhQ==
X-Received: by 2002:a05:620a:685:: with SMTP id f5mr31168986qkh.238.1567480423270;
        Mon, 02 Sep 2019 20:13:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:fd80:6da7:da64:698e:698d])
        by smtp.googlemail.com with ESMTPSA id k21sm7644455qki.50.2019.09.02.20.13.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 20:13:42 -0700 (PDT)
Subject: Re: how to search for the best route from userspace in netlink?
To:     Dave Taht <dave.taht@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <CAA93jw73AJMwLL+6cNLB2R6oqA2DyMYc1ZUsrFPndESs0ZONng@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3e8fd488-1bd1-3213-6329-6baf8935a446@gmail.com>
Date:   Mon, 2 Sep 2019 21:13:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAA93jw73AJMwLL+6cNLB2R6oqA2DyMYc1ZUsrFPndESs0ZONng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/19 4:07 PM, Dave Taht wrote:
> Windows has the "RtmGetMostSpecificDestination" call:
> https://docs.microsoft.com/en-us/windows/win32/rras/search-for-the-best-route
> 
> In particular, I wanted to search for the best route, AND pick up the
> PMTU from that (if it existed)
> for older UDP applications like dnssec[1] and newer ones like QUIC[2].

RTM_GETROUTE with data for the route lookup. See iproute2 code as an
example.
