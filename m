Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C1635780C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDGW4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhDGW4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 18:56:45 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BA8C061765;
        Wed,  7 Apr 2021 15:56:35 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so438998otk.5;
        Wed, 07 Apr 2021 15:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Wv6tbKjF28yj9/5QE+CjLVG6ST1YqVRqQtxyTlKXFY=;
        b=X57aSODsuVV9kNBWYNKot3RY0SB92DuqSPkoYtoRLtsS4KuV2No28WQ7LaeGJ5Ox0T
         5m+R1uL9Jr6nvbN61fJrU5TWQI8FxTmGGBZTyt39DaJXmllijvhFADMk8qAi7/2pti9Q
         hdnroHvh+4ckIijUff6QkSYC4SY+7YvZE1Hxj18tvhylGf9wYjiRqyGW1hrus8fviRBe
         JA5iq+xr/4ZZNjYaNpmQhrvT5pi9+VxXv0x5LHbUpswZiSOPdrUlSbE6hRS+BGJBRHMR
         SAqNv42O80tLXrr6NUDN4T8bXXTNMK1XNU42sT6VK4hJfmm9mCez/0bg5ElGUhSR3kAX
         Bueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Wv6tbKjF28yj9/5QE+CjLVG6ST1YqVRqQtxyTlKXFY=;
        b=WJekNbRrSWI1FmkmCF15FQiOZSqZaxwg4C25mv8h21mkSiTeWHPiPz2xLsYyj3+JIv
         d7dIXcLWrhtP9VeGf0kOKWrwpUyHEWgUj3kZCGNDp8zIjb1JaHyg40DH8oCROAVS0+uY
         9RtNj28tp5Fli2ChxANVVGPBqeacm2FCbnnuwPyl/6gq89SXHje4Tm63JVCK22oFUIMK
         dJNvirZc47+8q2uLIDalElBnwfPVffl+ClYE9XV4pySYHM3mc4vLUzmsaixbs0ShUEkI
         6c049HAAHGrtvyd4mOKZhxjpiIogvWgmxESWhDAX2fEYEHIzY2FqopomCkHWF34uZDqt
         +Q/A==
X-Gm-Message-State: AOAM532BsBbdsFjI1/5tRpkCqoKu0N+SMMmBLxOt/C7yDiTAMSsRTHyK
        4c3X7Kb+o1Ru7bSNJzoxMjo=
X-Google-Smtp-Source: ABdhPJwf0U6nUGcp7O+fZ8iG65N/XKnKO5msuHT1WKzPvG6xbdKYMbhqegMDg734i25W3QmrHV0OKQ==
X-Received: by 2002:a9d:6ad6:: with SMTP id m22mr4747018otq.160.1617836195040;
        Wed, 07 Apr 2021 15:56:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id a7sm5051669ooo.30.2021.04.07.15.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 15:56:34 -0700 (PDT)
Subject: Re: [RFC net-next 0/1] seg6: Counters for SRv6 Behaviors
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <10c2aa0d-b273-a75b-4c07-c1ccbe858aaf@gmail.com>
Date:   Wed, 7 Apr 2021 16:56:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this is a single patch set, just put this good cover letter
content as the message in the patch.
