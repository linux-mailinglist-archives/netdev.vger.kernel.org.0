Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9221C3B312C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhFXOYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhFXOYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:24:35 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF00C061574;
        Thu, 24 Jun 2021 07:22:15 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id f10so8386887iok.6;
        Thu, 24 Jun 2021 07:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6GE62bgff7a+dR9Zc6QlX7Y4x5Q+uKl8kjHV8UVzYss=;
        b=aqNA/pdIc8G+llo0k0hDB8kNcc+hLMu0WPtQACFgXo2dRniACuv7t7PNMpXQge/422
         LgtuYzAcvXiA4aT3Ppobedm1sTkEWT/AKhJECQVThwbz1Nj0Bg6E59BwVJClH3hAKo14
         n15VLG+WTGNc01FALWkl4++XjJGA69ZlgQh2hhtb7/+d0dEAzLDEzQYAP7KTvezq/wxM
         N7PUCnH0Fa2knDsZL4HzfbC485ZE8TuQxv+3Z0mpMjAb/uaE+do2Lvie2pZgCDmUE8WY
         XnqFYkabnRwWy9bZ2BTK8spaeaH8QnIEkXH3hRF+4weFw2OgzChmHQUi+fDVAPtzIoV4
         kCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6GE62bgff7a+dR9Zc6QlX7Y4x5Q+uKl8kjHV8UVzYss=;
        b=dou3yU5yMTL+H9rRIFHUbJHgEQCYIvK2rCCsglgCkbYMyLUixZo4vdlP862492HmAY
         iB7UDVnbd7hrpCArJTNSMBn7kAQ0/B/gS5Zh5HfXxrrkkRuNJwsjtGezsprEXZS/EZ5p
         N71ixPMnxdWLxosauZGK2zO74fXRNHcp3tBHmsi5j7aZQIX1T3amVor1qdGLFS+y1CWs
         N4KRQWtuprIoCz3oVG8LHVEUlD29l54nLHdR8n1GMZK1k2qZ0jNSMiUO6OuwiHk2pQW9
         gdJCsxQNTVEhiSrfnC3hldAI9UkqJ31VktE/0gCefK1JJSpuywNDyVFBkSCjsBYfTitp
         x6eg==
X-Gm-Message-State: AOAM533dCYH5Y0awLN2IltO9C/wq6/D8zDQnvF69DwhBdGQFnf18YDvt
        Y8lR6FdlRFEzLnQPUvJHsgs=
X-Google-Smtp-Source: ABdhPJxZNWTsTO5Ylrq26lJWqAVkLcLjABHE0DBZBTPNYCsiM54CKZEPzhKfrHKqbh6oZ7BmPEn2aQ==
X-Received: by 2002:a6b:8bd3:: with SMTP id n202mr1978151iod.128.1624544534627;
        Thu, 24 Jun 2021 07:22:14 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id 186sm1106731ioc.3.2021.06.24.07.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:22:13 -0700 (PDT)
Date:   Thu, 24 Jun 2021 07:22:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Message-ID: <60d4950e9d51d_2e84a2086c@john-XPS-13-9370.notmuch>
In-Reply-To: <9710dfc6-94f6-b0bd-5ac8-4e7dbfa54e7e@gmail.com>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <60d26fcdbd5c7_1342e208f6@john-XPS-13-9370.notmuch>
 <efe4fcfa-087b-e025-a371-269ef36a3e86@gmail.com>
 <60d2cb1fd2bf9_2052b20886@john-XPS-13-9370.notmuch>
 <9710dfc6-94f6-b0bd-5ac8-4e7dbfa54e7e@gmail.com>
Subject: Re: [PATCH v9 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> On 6/22/21 11:48 PM, John Fastabend wrote:
> > David Ahern wrote:
> >> On 6/22/21 5:18 PM, John Fastabend wrote:
> >>> At this point I don't think we can have a partial implementation. At
> >>> the moment we have packet capture applications and protocol parsers
> >>> running in production. If we allow this to go in staged we are going
> >>> to break those applications that make the fundamental assumption they
> >>> have access to all the data in the packet.
> >>
> >> What about cases like netgpu where headers are accessible but data is
> >> not (e.g., gpu memory)? If the API indicates limited buffer access, is
> >> that sufficient?
> > 
> > I never consider netgpus and I guess I don't fully understand the
> > architecture to say. But, I would try to argue that an XDP API
> > should allow XDP to reach into the payload of these GPU packets as well.
> > Of course it might be slow.
> 
> AIUI S/W on the host can not access gpu memory, so that is not a
> possibility at all.

interesting.

> 
> Another use case is DDP and ZC. Mellanox has a proposal for NVME (with
> intentions to extend to iscsi) to do direct data placement. This is
> really just an example of zerocopy (and netgpu has morphed into zctap
> with current prototype working for host memory) which will become more
> prominent. XDP programs accessing memory already mapped to user space
> will be racy.

Its racy in the sense that if the application is reading data before
the driver flips some bit to tell the application new data is available
XDP could write old data or read application changed data? I think
it would still "work" same as AF_XDP? If you allow DDP then you lose
ability to l7 security as far as I can tell. But, thats a general
comment not specific to XDP.

> 
> To me these proposals suggest a trend and one that XDP APIs should be
> ready to handle - like indicating limited access or specifying length
> that can be accessed.

I still think the only case is this net-gpu which we don't have in
kernel at the moment right? I think a bit or size or ... would make
sense if we had this hardware. And then for the other  DDP/ZC case
the system owner would need to know what they are doing when they
turn on DDP or whatever.

.John
