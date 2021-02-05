Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635C231043F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBEE6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhBEE6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 23:58:15 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CE8C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 20:57:35 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id d1so5713455otl.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 20:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ss2sx2Novs0BCmPcW3vl+QFvdoPK2Z/lCC1NQojZm/M=;
        b=a+GPXBellKQk6KGAgmmEXHEVJA3HEH6fkQMqlZzeIuexL2J2rltlrGqXcuZb3ixHy2
         2GaJTuFvf5nDoyOtPURmbXUDg6DtVfFZVeQKD0v5xTbQMNF834jyI0sfeFtcmDGR4JaJ
         XhFQWeztFs+4oY4FCgcr9Snp8nrvKN0IWwTXXtr5rlYOZcWMWoftlxS9mQ73A4z7w8S7
         iJHRO3s6r4bjkvNH7LrBEuP0+/58jHDK6Yt6nElbPjyzzeomQIr9a2dd5GYyhcUp8pTX
         24G74SgAbKEyGhUxrqWgjZsvqDaOGZycD27ULcJBELJ0emxTSq83hCwHXcWJSkHNzKUO
         lTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ss2sx2Novs0BCmPcW3vl+QFvdoPK2Z/lCC1NQojZm/M=;
        b=eguwEK3qyy37mg8ELUG5OyjlZo2WtIiMHuo8bMGuO83BiEguiLxQULd+U/Jf6+QrLO
         6mJRgoncBOUnTnSOEkm3Tu/A1gUO0Etmi4Zwt6RuXzEhrGOtxSu6+PJtt5vEjFkcUBP6
         A76iOrRwiSP4HIFtyITC6kzLp4IpFVWpYEvgwAeai+iTTjn2W+v8wSs0Le+pghlLnlSx
         joHm2ULfKevllFSh/vn00aluyTW4JCVsNI63QJiXSRgqmDjKe4xHeQ4Wp46axYfwMLkL
         iSZYQ4HQk5Ns4pItyw20Ze4u/hBCzGHO//Ujh19kemlLlHPmFj0tGYa+P+kjbjoFSB+m
         NuXw==
X-Gm-Message-State: AOAM533UJ3+kJchsyMb6ai4shhryU9DOn8783ULg86imfKdHg9rTGHXk
        +amv/lBGEpMFyp6JFL3SD+0AhQsjJSQ=
X-Google-Smtp-Source: ABdhPJwZBh+TzLfpr/PPvfPs55zc8tKMPsng3N3tqptJbv3P0epOTF6jkjZzRumoTgJCHx7UJqVoig==
X-Received: by 2002:a05:6830:1d45:: with SMTP id p5mr2158046oth.272.1612501054553;
        Thu, 04 Feb 2021 20:57:34 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id n27sm1615347oij.36.2021.02.04.20.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 20:57:34 -0800 (PST)
Subject: Re: [PATCH ip-route2-next v2] ss: always prefer family as part of
 host condition to default family
To:     Thayne McCombs <astrothayne@gmail.com>
Cc:     netdev@vger.kernel.org
References: <6d0eff35-b982-7d8d-d3c7-742411e93046@gmail.com>
 <20210202033210.2863-1-astrothayne@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <87e796a8-2011-96f4-9ae6-9a668f71d0d9@gmail.com>
Date:   Thu, 4 Feb 2021 21:57:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202033210.2863-1-astrothayne@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 8:32 PM, Thayne McCombs wrote:
> I've fixed the indentation to use tabs instead of spaces. 
> 
> -- >8 --
> ss accepts an address family both with the -f option and as part of a
> host condition. However, if the family in the host condition is
> different than the the last -f option, then which family is actually
> used depends on the order that different families are checked.
> 
> This changes parse_hostcond to check all family prefixes before parsing
> the rest of the address, so that the host condition's family always has
> a higher priority than the "preferred" family.
> 
> Signed-off-by: Thayne McCombs <astrothayne@gmail.com>
> ---
>  misc/ss.c | 50 ++++++++++++++++++++++++--------------------------
>  1 file changed, 24 insertions(+), 26 deletions(-)
> 
>

applied to iproute2-next. Thanks


