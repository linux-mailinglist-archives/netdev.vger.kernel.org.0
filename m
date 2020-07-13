Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62A521D702
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgGMNZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729822AbgGMNZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:25:16 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B87C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 06:25:16 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 72so9485235otc.3
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 06:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x0ikcgnusApPQmzUkIF+WMrteE9Av9ac297tKpys05I=;
        b=IG99CwznfBbGq5WPbt3f3tHpJyAvjk2PVHxVtSnEgtEAOpclYjNyyMEsCTvN6dEkR+
         iD1jW26LAk98k1+Lj+ZUzBMIf+fvdOwQvyMs9om6bW504mUAdFYztIZj/eP+kkIuqV4j
         LQX++XhJCqibhI4W7CZgWYtxv1MXxGigCXlEh3Jt53Vt76p0O3r9EET7b8Vuvd8mXjkL
         llar8ERA80n3uQ9bzfQAe5idjaFPgcuLcHFTtMFJUE2Db10Kufe6eVBHRdIjPPtQE80x
         nFnEj8vphTAkwNJ3ehsPL2Z8IQpAQSfXinRiCu8MyZqvQzv1pO97s0DiGcPHROfRdGQq
         CaTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x0ikcgnusApPQmzUkIF+WMrteE9Av9ac297tKpys05I=;
        b=Vkq8Oq29mTjd+A0PShC9RHFhPI8tGXoz5Y4t9r71l9HyL2uKENdnU8vz1xf8Ecb8JR
         hEkbWp3h4C321YoY0Xw4HiyYHqhuLU8vuT0aHHeXAUHS/cQb6/e0Mrqqd6OFLMACGo2W
         nMS+amMBy/Qqp4z7IoEVcfXsGRM4SUOAi/qOkeoxoPm21BV7xhrAh3/axvZJhPamFoc5
         uOz4CQdjyTuD/n/zJoDs5H/aJBQMi6A28zfQspv3MrAL6azLX71LntWHHEWl9iLSH+mX
         3m/Yh0NICuUXgZkZo8rpR2mAI0dDSEJUWBjXMB1RAqM2qrVKpCDouA+r5R/4p8k5htVK
         b3pA==
X-Gm-Message-State: AOAM532C1NII/pBHIlQWTIc3wyWvtUDg45H0FIXY3fJ//I5lx2V0fHs0
        fL+wn2a5S0YgqHzQjW0NJZo=
X-Google-Smtp-Source: ABdhPJy8LUnU5vlfTn7CLLWOg4pbBLKIgHJfjkwH/rTL1tjGrZKcuu5vKtV7xTZYHc57L9fU9H0X9Q==
X-Received: by 2002:a05:6830:2306:: with SMTP id u6mr71956999ote.104.1594646715780;
        Mon, 13 Jul 2020 06:25:15 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:a406:dd0d:c1f5:683e? ([2601:284:8202:10b0:a406:dd0d:c1f5:683e])
        by smtp.googlemail.com with ESMTPSA id l18sm1883107ooh.5.2020.07.13.06.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 06:25:14 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
To:     Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>
Cc:     netdev@vger.kernel.org, aconole@redhat.com
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de> <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
Date:   Mon, 13 Jul 2020 07:25:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713080413.GL32005@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/20 2:04 AM, Florian Westphal wrote:
>> As PMTU discovery happens, we have a route exception on the lower
>> layer for the given path, and we know that VXLAN will use that path,
>> so we also know there's no point in having a higher MTU on the VXLAN
>> device, it's really the maximum packet size we can use.
> No, in the setup that prompted this series the route exception is wrong.

Why is the exception wrong and why can't the exception code be fixed to
include tunnel headers?
