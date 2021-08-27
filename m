Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F993F9D6F
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhH0RQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237387AbhH0RQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:16:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CEBC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:15:45 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q21so4349211plq.3
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qlHQKrZrlrdOKH5lRNg1YxSMawB11Qn4VlveNJPWGZ8=;
        b=eNs2rHu2TatDPVXH6UW43VP5Yd0+/X9nmoRCI8oJ2PE7DMxXduFVuO6fQ2rqqK27P4
         Qmk59sJaGHVHKt6AOaWeHI7bD7X5VB+1Wv9BX/97xmDnPjYHANSYA/lh3ioO7v6asmQ5
         P4ua6BrSIaOgfcwcDeFYhalushFzxohqbY156JtNqW/Q3oPRswGwu0UrjuMM1P9Vh0SW
         2UKn1bqSN9uTRaOwbC3c7vjjeMHOrNROG18ul9H7mK5Tj7agKMdzwz/d3Ydx53PNlLhJ
         fjldxi0vKwFoF4Bwvz//F5NpHOO11gzytjXo0begkxfQXV06p8mnCPdq9hxRAn9Elz9s
         fPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qlHQKrZrlrdOKH5lRNg1YxSMawB11Qn4VlveNJPWGZ8=;
        b=VHD82Tv23Uko/wEEKgNNLyn8fN6rxnkOoownsAGAk+2KlGwSSm14CJ/NLwgGTYpHEX
         UNg04JfBN90peHUH7JQAYYMRLyK/K1NkYxoH4raxvsZDyxuN2+bbe5Tk1IUdBOadep9P
         u817DUZMHgTVj4DCZDrJpf7ECEGRnd43EO58ryefl+rth4B9Bt7F+RHXSTRCLhED8zgs
         x9ZTDsTA1oRZUhRCZBUVQ5AGdnSZ9LtvgboY/Nsa6aqQ2BgD6tbeJQ6MMPiflM9F3zi3
         FDdS5q7f/Ah/lYiVygU+XtumpFbrx1UwoctOP0OAkRbZz1OXWrMeXKpFCv+z2xcxCgN8
         81xA==
X-Gm-Message-State: AOAM532y8hlMFelrJuJe9xBNjeMp9akjG7zUA/XV6zKTh2+byQszSpTk
        sfxT8hJY4ej+PRv/D6xAwd4=
X-Google-Smtp-Source: ABdhPJyRBdWp4/8uSZJEmf2O7poqLZJovzZtnBbuGb7wHXgSyFtE+NRmWabHzkL35CSJqfgKf4AqLQ==
X-Received: by 2002:a17:90a:5147:: with SMTP id k7mr11954755pjm.204.1630084545260;
        Fri, 27 Aug 2021 10:15:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id j6sm6731556pfn.107.2021.08.27.10.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 10:15:44 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 10/17] bridge: vlan: add global
 mcast_last_member_interval option
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210826130533.149111-1-razor@blackwall.org>
 <20210826130533.149111-11-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bbcd47f3-f1a9-5167-0007-ed91802e8a46@gmail.com>
Date:   Fri, 27 Aug 2021 10:15:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826130533.149111-11-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/21 6:05 AM, Nikolay Aleksandrov wrote:
> @@ -42,6 +42,7 @@ static void usage(void)
>  		"                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
>  		"                                                      [ mcast_mld_version MLD_VERSION ]\n"
>  		"                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
> +		"                                                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
>  		"                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
>  		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
>  	exit(-1);

line lengths are too long. The LAST_MEMBER_INTERVAL is at 107 characters
wide just in what is displayed to the user. Let's keep those under 100.
