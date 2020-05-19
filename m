Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A031D9BB3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgESPvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgESPvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 11:51:37 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C388AC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 08:51:37 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f13so15788278qkh.2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 08:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LZSIMROUlTiPIvlaGF12gFMJGOj6nIV+8uRglQrm0aA=;
        b=gDgIN+PUNJEho+pFyQLv85VED8vtKR54OEPLCOPpEP3cFwvKejfk10a3cETSV/cN5m
         4++XKTuXr/ovykPG7HSOG/aBQO06Pr+TDM3EyIdWsGDnwJhaqDzxO/DNNiR7lbbmAZXn
         IgPNcket1MhbeHSdcMYe0LGTgK/eWP4Viw5UDSWTxlgmXdAAoXmhNEbON8+SAEKGAqla
         TPUdtHLuaMyDzUplJ+8BwhialculaHnSTi9aXq9Tlo0kl/eLDHbAXilYrdKC2I1EuPzr
         8MK++ze0NmbbVm+2Q1TT9wj8ZpfDTcOfoEl1tAfqW/vQ1uNyfbLUpMHnqBxGWM5sc9hw
         iANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LZSIMROUlTiPIvlaGF12gFMJGOj6nIV+8uRglQrm0aA=;
        b=t/fu8UI13AuxszMcpdY1nOquihO6aLek9BIAaiBDudZ2w1OP4V1NE/9p2NUI5sm5mi
         SLBYkG7Qva+lp6eYgsarpztMmCWedNByQfGGtC4OHPz5HwgYM9B7IvlsZBo1EEC1JOsX
         /iIzdxdaCpPSBdWUSAJQRoSIHm35/Sr+JTg8eTyjctq8QNUv7gGRJYCU49xfsEcTLbRV
         clulE9LOwuWPa8B+L5bpnqyj25L5vl1FosyA34S4AeyktksGEOdt3IG5K7X12o3bVmDg
         4WxndotnqfpKAwjAUeHWx6Iz8SJHe6O2V9YtAUrBMwd8X3oaVyOM2iVqABouc+Kylg4g
         HfVw==
X-Gm-Message-State: AOAM533hoCHl5Zw2dxnKgXpXUHt27hbZf0hu8KI3pheZ8b1Yj62wIz6k
        Lo8Q1ZQ8QbyOopCc2b86NTZPplRk
X-Google-Smtp-Source: ABdhPJzJwf8XVyvq1ysBZwePNiarSRT9u0EGSJLAmEekWmYtg6qKlbQzY9y0HqIzqSDXUUzVf6O8Rw==
X-Received: by 2002:a05:620a:1512:: with SMTP id i18mr21847910qkk.81.1589903497029;
        Tue, 19 May 2020 08:51:37 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id x205sm3426926qka.12.2020.05.19.08.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 08:51:36 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: nexthop: dereference nh only once in
 nexthop_select_path
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com
References: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
 <20200519110424.2397623-2-nikolay@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <54c02cfa-00be-1379-1965-5ab833d3d5b1@gmail.com>
Date:   Tue, 19 May 2020 09:51:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519110424.2397623-2-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 5:04 AM, Nikolay Aleksandrov wrote:
> the ->nh pointer might become suddenly null while we're selecting the
> path and we may dereference it. Dereference it only once in the
> beginning and use that if it's not null, we rely on the refcounting and
> rcu to protect against use-after-free.

the num_nh is also affected. I think an rcu update of the entire nh_grp
is the better solution. Dataplane should always see a valid nh_grp via rcu.
