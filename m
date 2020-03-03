Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FF5177B48
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgCCP6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:58:14 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44195 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbgCCP6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:58:14 -0500
Received: by mail-qt1-f195.google.com with SMTP id j23so3139225qtr.11
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 07:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tbwMv4Xp4XqdEk9sc7xpkVwh+bKFmbVfoNyUEBVbagE=;
        b=Det3bp2vvitZXfoRY7vgTjGeX8L3qrkMiGoGOU6KKN9uPbU74JME07VCxtxQVKy1Iu
         /FZ8gDcOWfQBeg0Cze5uXXBlLNAi03CC1C27c7zgE9mOn9XmVBzQVOBv1AG2SD2CbQC7
         Tpe4cu9b9yp0yvKLQVlgcHD+Hurf80A6c3k80GcYV7RxAU2hh3hJUVnxG6KKarCxQcFk
         c9mrRrRuMuiFW2dNMmj7arDycp6YAWY16NG60FX/OuT7bstupjQyrM723AvzKdYnb2gE
         ouFjsDTZxlvKD+Fc1S/BvjQ5wniDoLTNjuKyB0uEcTKuVPovmjzAYRiburbbJ+qlnN9o
         nB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tbwMv4Xp4XqdEk9sc7xpkVwh+bKFmbVfoNyUEBVbagE=;
        b=SCyK222JJDQDp/WdmRN8etO5IK+DALV8/Yfor8LKdY2AA6/UoKw7OiJYwcLTIkRgP5
         KA47N8VD2pi9v+hpQPu3BX0/14sCPEn8EHdjwWleTIG9bunIcebZHymQzgDLHDI4hoZs
         o66oZxQdJR4G27TpxIPIn6ENslkBvHhaGplj+Myn0nFph7s73Bujtoe6t3QL2hnMlgHt
         +q78H4LxJxDi12mfHM4+ex0ZvjhzP65HuclXgtzmiKPrSgMebldVDT+3upDIy0nmMTZ2
         hAQK4qiUpulKsFcfz6V+jWNcVp8zJzJGZj/QS6c8xhq0ePKKD2lCAX/GgGHUsZlcIbGR
         5Xww==
X-Gm-Message-State: ANhLgQ3QCoIfcwMsNThVB1gvtguVNAq4igOgUIvh8wBdG2dBpoQKdhD9
        JS90vOtSTSlnm/s4OCZo/sI=
X-Google-Smtp-Source: ADFU+vsz8wKFjagT0jnDD9QV3R45HtDSeeWv9sxUqf54kIT3rjSkEqO/ze6KXUV5Ic3q0hkI7qgiKA==
X-Received: by 2002:aed:2667:: with SMTP id z94mr4769419qtc.96.1583251092847;
        Tue, 03 Mar 2020 07:58:12 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29f0:2f5d:cfa7:1ce8? ([2601:282:803:7700:29f0:2f5d:cfa7:1ce8])
        by smtp.googlemail.com with ESMTPSA id o4sm12066793qki.26.2020.03.03.07.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:58:12 -0800 (PST)
Subject: Re: [PATCH net 1/3] net/ipv6: need update peer route when modify
 metric
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>
References: <20200303063736.4904-1-liuhangbin@gmail.com>
 <20200303063736.4904-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33683c53-d188-de9b-5bf6-794b8eede898@gmail.com>
Date:   Tue, 3 Mar 2020 08:58:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303063736.4904-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 11:37 PM, Hangbin Liu wrote:
> When we modify the route metric, the peer address's route need also
> be updated. Before the fix:
> 
> + ip addr add dev dummy1 2001:db8::1 peer 2001:db8::2 metric 60
> + ip -6 route show dev dummy1
> 2001:db8::1 proto kernel metric 60 pref medium
> 2001:db8::2 proto kernel metric 60 pref medium
> + ip addr change dev dummy1 2001:db8::1 peer 2001:db8::2 metric 61
> + ip -6 route show dev dummy1
> 2001:db8::1 proto kernel metric 61 pref medium
> 2001:db8::2 proto kernel metric 60 pref medium
> 
> After the fix:
> + ip addr change dev dummy1 2001:db8::1 peer 2001:db8::2 metric 61
> + ip -6 route show dev dummy1
> 2001:db8::1 proto kernel metric 61 pref medium
> 2001:db8::2 proto kernel metric 61 pref medium
> 
> Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv6/addrconf.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


