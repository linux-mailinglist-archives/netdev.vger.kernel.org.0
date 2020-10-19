Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698BD2920E2
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 03:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgJSBkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 21:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgJSBkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 21:40:16 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E846CC061755;
        Sun, 18 Oct 2020 18:40:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z5so2597066iob.1;
        Sun, 18 Oct 2020 18:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IgnPizQJe3I7C3ovLWfCRTWuEYnqFRot96J4CmFs+E0=;
        b=H0AxscEVyJHlTPMrcnyX1Um1iKSDxvBr42Tr3afep1rtIfmj8WpjnhCql8JmUQkUbg
         uNI5MUJuUVFx5cH0KJ4IYCDNfrDgMtIUo+72T/MZTuC67nO/8qEG/ttBKYAanVkUW6Nf
         CDNtvuRkbbdR6gkqtek8Q/HitVcNyIFKJxn/IAN2UsRUNoy6KRjzovJg3+QkNWZDbDZK
         MpowM4qmbZFNdkxVxZIDsvBT35QAHj8GWtZdxh0u/e3LxgC4QysgjtrLrtzgXPXlylcg
         uPwSJCkoq9VdhG/mFQUpn/SPqzI+fEhfhsum9oH7exb4OYr56NB66+ZQB9phpnBKXpHH
         YvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IgnPizQJe3I7C3ovLWfCRTWuEYnqFRot96J4CmFs+E0=;
        b=NHKxqGeELdSSSSnpX9eS2GsIj93S2+ewUdxLsLYbhVxAiXv5zgGVQC0LO4cPQlXHzo
         iqdx0sJY3kw4b/DE2GasI3DhSHGoAgCkWD9qaGKZQRpUUmTwctgO+n5tp1x0cqxTyQqF
         1oGLKHtEvdqzd+VDEEMj61H6qNZj1v2jwplCU0QwkR2In9zxbSPQt5CudPPrNgfH7E7G
         0U2QLgsXhDHf1xqqBq1/kTKiqL/e+f8cwcFY+ufgmdZ85aXHo/fVnyvx15YJOu/0f5qs
         dS4IBNgNEZ/R5vRbxdKSiZZb2YcGWHRQJYuTT1AL8h/wuEzcD2D4Bw62Z1dy9x/EYAhk
         R08A==
X-Gm-Message-State: AOAM533RXRuD9bZKgy2ZnffaB0zz+CFjwu6/ZqWLgLBeDQag1FbxixeN
        BbiHongu+mYwF/yP6fEmUqJRY1DHaWg=
X-Google-Smtp-Source: ABdhPJyY2iaG0Mc+bbGuaBZA2Asn/xD5sfVzwNlurO4f3/y0XClFfDnVoH2F3YSyrMjhIFGVSfeYdA==
X-Received: by 2002:a05:6602:208c:: with SMTP id a12mr9221238ioa.55.1603071614146;
        Sun, 18 Oct 2020 18:40:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:d908:7fe8:cfc0:66e2])
        by smtp.googlemail.com with ESMTPSA id c11sm8602879ilh.22.2020.10.18.18.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 18:40:13 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.9 035/111] ipv6/icmp: l3mdev: Perform icmp error
 route lookup on source device routing table (v2)
To:     Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        netdev@vger.kernel.org
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-35-sashal@kernel.org>
 <20201018124004.5f8c50a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <842ae8c4-44ef-2005-18d5-80e00c140107@gmail.com>
Date:   Sun, 18 Oct 2020 19:40:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201018124004.5f8c50a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/20 1:40 PM, Jakub Kicinski wrote:
> This one got applied a few days ago, and the urgency is low so it may be
> worth letting it see at least one -rc release ;)

agreed
