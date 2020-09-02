Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA325A2CA
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 03:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIBBzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 21:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgIBByz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 21:54:55 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4FCC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 18:54:55 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r9so4169691ioa.2
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 18:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2rOcLQjub2Kz8isiNIQlB/qpjw+kM0ryysaivhmGUf4=;
        b=BjlQaTR/w6a81cC6tT6xbTegv6cyE3TBJ0bnWgDlUnh00CJJVHYYTWhE8j/pJu8dao
         mNL6llpCy6Cs4U+tpl/+bY7jHQInGHRHoqmnH7haEsenJG4qJ8gNGPK/VeNdxrXApAHb
         Zzy+THwVvEEX9RW/Fjj5Huw+l22zBRkeGd3lLagI5lrHNAnT2ySfSM+aVH1vewMA/QSl
         wY7/ul7SFvubXCA8VtznPsilMVxy/ZdcK66oAyEqWH+At+mGZloK4X9S974e4CstuHsV
         B1YFe1DPcIfubOVai+FFdjzM9k9DDzoytig4838qYX2bo4YxC4jJGywcO4veg8z9jEon
         eJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2rOcLQjub2Kz8isiNIQlB/qpjw+kM0ryysaivhmGUf4=;
        b=oGwZ+z7wccYa9fvXBcBSpes/AzSGd/m3MGNR53nan/DvUrl0nsktpFuQ5yYwItEjLt
         gzvzeW9amprJMxqwxXgXO1Ner5oSI3WAh66c081mSuWqyoP74U2Him+cj229jEDOrhjt
         BfBrZoKBp6POnEh9j7mOppMspMlLQOW3FkYkJe1yWmWZ1Fm18yVx70fQerlj1CDZSFeS
         IMOIfFlZ+RMeYW7SN2xXsnnpcV22docnRZXcPcJBgufiyNuYy6NTxf4QmiCkHXVSr0Rt
         msCuCzBE9NkIw0qfVea9y4lYFGGjRb8UKeHY6sc0kVaBwAu/C0gkphx1Uqozy5NqXXtz
         /yLg==
X-Gm-Message-State: AOAM532zgDTuMtiEcjvFX/kuSYVsWJ6WKAVSpf+nw9CuDf7HchQ6x4Yw
        82vzZsrDM54laS+TWDlWitc=
X-Google-Smtp-Source: ABdhPJxaYTZ70pUkRoTTnvt9WwuQKwTad0U3tacdS/Rm8zHQiucqvn9OG/Hs1CZqdWDrYhON8ef2dw==
X-Received: by 2002:a6b:2c44:: with SMTP id s65mr1621433ios.185.1599011694913;
        Tue, 01 Sep 2020 18:54:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:883e:eb9e:60a1:7cfb])
        by smtp.googlemail.com with ESMTPSA id d23sm143481ioh.22.2020.09.01.18.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 18:54:54 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v2] iplink: add support for protodown
 reason
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
References: <20200829034256.47225-1-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bbb1ce0c-c5e5-bdfd-57e4-80e6ccf6d3b3@gmail.com>
Date:   Tue, 1 Sep 2020 19:54:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829034256.47225-1-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 9:42 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> This patch adds support for recently
> added link IFLA_PROTO_DOWN_REASON attribute.
> IFLA_PROTO_DOWN_REASON enumerates reasons
> for the already existing IFLA_PROTO_DOWN link
> attribute.
> 
> $ cat /etc/iproute2/protodown_reasons.d/r.conf
> 0 mlag
> 1 evpn
> 2 vrrp
> 3 psecurity
> 

none of these are standardized right? Or perhaps they are through FRR?

Would be worth mentioning in the man page that the reasons are localized
if so.

> 
> Note: for somereason the json and non-json key for protodown
> are different (protodown and proto_down). I have kept the
> same for protodown reason for consistency (protodown_reason and
> proto_down_reason).
> 
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
> v2 - address comments from David Ahern
> 

applied to iproute2-next. Thanks


