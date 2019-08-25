Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CF79C4DC
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfHYQXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:23:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38873 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHYQXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 12:23:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id o70so9998146pfg.5
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 09:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+I14yRj9I5iBjMH5AiGZvI2z2LteuJz7GfXzQRd9/xE=;
        b=Dw9KZlthSiAloxPxVE8y1SqSaFgEabn6rDerf3kQptNr3eSjvvrv4woNTcXy61qSQ6
         8VWf6jcF306BNCk2Uv059b7Jzwy8h2v2DXUaeXHxq4/qt1g3vcGjlIMwV+o+gf/DruPO
         1ZzFQ88w67wZ11g/HhK8lN0Wei1LNWJzodP3AUS28Wjgz8x6kyqSciby168mwNEYJdl2
         2vn2ktKBRBEC1oovpQ2bT4tjrPwj2K/Wj/e+zsyC/B9joj+vhFP7d+3PjG9bxiIvFHse
         SJ6bL/sBgb5HxNdLbvuXlAiQ03HsAD/F4UGU+U/M/x6MtD1VjSXMZ0N6bSkZeGzvPNi+
         fguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+I14yRj9I5iBjMH5AiGZvI2z2LteuJz7GfXzQRd9/xE=;
        b=p9bO62jvrrZk9S5afj74ziyD6GTSyPdy2yOEwXJokdr2rdKdFNpz8IlJDb4EJR5cWD
         hUOLW7trXo6JIkPkE+I0v2iIZi1+6P1O+YEuEuyl5z4lvYspGrO7rdxkZF8Anp+o/4gY
         1bUVNfTMAKJq9YhfkDAEpIpAaivQBhQNpeIbAlIIbRHdiGN3vSq9IN9rVWd/g6XURbMw
         77YIY7wtHorqE3WQUM4aCXNTtLswxcpuVkeXF2CZ+kYWP522qy1yiCytnBrcCwwGi4xl
         op4IHaKgdvkI/1VeIeiQ6Wp6O6KwTVr3tNAEnplW8ltXYBcvhPpHnGBgWM5GZhTuV39J
         GInA==
X-Gm-Message-State: APjAAAV62zazKDXIn46/kWgDZXpmQ97A2THx9WI7CAXyO402Xe6c4eiV
        ekf9MbPtMJnk36nMfO/hnk0=
X-Google-Smtp-Source: APXvYqzeTs+pCb06e/MJSE0uXvYvOdfqj8WNxyOJKzdC3i3nSi9o1QaMLKeQiMTebzM0saRLwGLaSg==
X-Received: by 2002:a63:101b:: with SMTP id f27mr12199360pgl.291.1566750192734;
        Sun, 25 Aug 2019 09:23:12 -0700 (PDT)
Received: from [172.27.227.228] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id z6sm9880142pgk.18.2019.08.25.09.23.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 09:23:11 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: mpls: fix mpls_xmit for iptunnel
To:     Alexey Kodanev <alexey.kodanev@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <99662602-8125-a400-fa36-178b01dcc824@gmail.com>
Date:   Sun, 25 Aug 2019 10:23:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 11:51 AM, Alexey Kodanev wrote:
> When using mpls over gre/gre6 setup, rt->rt_gw4 address is not set, the
> same for rt->rt_gw_family.  Therefore, when rt->rt_gw_family is checked
> in mpls_xmit(), neigh_xmit() call is skipped. As a result, such setup
> doesn't work anymore.
> 
> This issue was found with LTP mpls03 tests.
> 
> Fixes: 1550c171935d ("ipv4: Prepare rtable for IPv6 gateway")
> Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
> ---
>  net/mpls/mpls_iptunnel.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

ok, I see now. This is a device only route with MPLS encap:

10.23.0.1  encap mpls  60 dev ltp_v0 scope link

and the change reverts to 5.1 behavior unless the gateway is IPv6 (new
behavior). Thanks for the patch.

Reviewed-by: David Ahern <dsahern@gmail.com>
