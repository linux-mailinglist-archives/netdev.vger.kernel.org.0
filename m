Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D4B36517A
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhDTE1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhDTE1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 00:27:49 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78748C061763
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 21:27:17 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso20640929otm.4
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 21:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a6ri1YBEsbxl4sCS/8ACK27mxPbtgmS0w+6VGuB6PD4=;
        b=F737NdZhHiHZWR+h5TCxK/UBSVO1FgSc4EVLzNlW98bMTw7y0T53ZTCZZRL6yO48qT
         MBkK14hRUP1dxQ3MYNQT+XAWjkk+c64YYuAMSqDBiAm4vTBuBGmQvi3SqNgUtmNrkC2A
         VIeMthluKhIDoT7tqbnihgqcxHeUa8GQMY7l+xgeb4ff229nP2GeMxeJzUVyRI2QTyjG
         XppAyoPr638vD/VdzCKqyDG79Y+Vl28LPH7H1c+1VjNZzDdBKReMYQcYcqnyRI7kxyIQ
         YQrvDlpyt/3mE6H2NaYFUSbnDYA0Z5atrpOtIydLnVgQVKZOmSYmLiVYk3pxZ6xENOoa
         +Yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a6ri1YBEsbxl4sCS/8ACK27mxPbtgmS0w+6VGuB6PD4=;
        b=pu4qhRZUQy4RjEAX+okvf6p/+yMBfrpCGk4h4DYrQLBcHSEtAfkCAM0MDRY4hLSzSy
         zirzyKdEwAZgoiN4xsRlcd6kSod+xoYTygP3C+ZLFoUjANUtI62Ur3jRjpFdHbaV93Xn
         hF2dKhehaHQleEEFkXDa69UOA6xcKD4k57mci65KkypKTJIPYRHlIEugRkL3NZHYBVeh
         M3lDSHbHUHkbnsYp1BcuVp+csCavh7zyiNKTMo9dpHZsuo9aBwsZOAHIo5KFgC1XOXrc
         poOyswyFxkJnM78kaWv7v9V9hmoSryQkrT+oNEvNhWXCkJp18RuhZi4ujHbTViLqVwmn
         Fj3w==
X-Gm-Message-State: AOAM532sdNiktEjiSj3DUw280EGpo0+0NRekubwIez5oMDgJtKEe/V4n
        1Y8awTWxA3YSnYJhKUP3B6m/maKwYOg=
X-Google-Smtp-Source: ABdhPJzQePJ9GUntN+GABu4o2yGyk1KSmIEOQ0QK9yV5WdOVz0PbUX3Hx4Vbeb5zN7vsWSgmwaUK7A==
X-Received: by 2002:a9d:3a3:: with SMTP id f32mr9577381otf.205.1618892836930;
        Mon, 19 Apr 2021 21:27:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.15])
        by smtp.googlemail.com with ESMTPSA id c65sm3648083oia.47.2021.04.19.21.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 21:27:16 -0700 (PDT)
Subject: Re: [PATCH 2/2] neighbour: allow NUD_NOARP entries to be forced GCed
To:     Kasper Dupont <kasperd@gczfm.28.feb.2009.kasperd.net>
Cc:     netdev@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
References: <20210317185320.1561608-1-cascardo@canonical.com>
 <20210317185320.1561608-2-cascardo@canonical.com>
 <20210419164429.GA2295190@sniper.kasperd.net>
 <0b502406-1a86-faec-ff46-c530145b90cf@gmail.com>
 <20210419175205.GA2375672@sniper.kasperd.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <71ea409d-7065-821a-f958-1736d015e4ff@gmail.com>
Date:   Mon, 19 Apr 2021 21:27:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419175205.GA2375672@sniper.kasperd.net>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/21 10:52 AM, Kasper Dupont wrote:
> On 19/04/21 10.10, David Ahern wrote:
>> On 4/19/21 9:44 AM, Kasper Dupont wrote:
>>>
>>> Is there any update regarding this change?
>>>
>>> I noticed this regression when it was used in a DoS attack on one of
>>> my servers which I had upgraded from Ubuntu 18.04 to 20.04.
>>>
>>> I have verified that Ubuntu 18.04 is not subject to this attack and
>>> Ubuntu 20.04 is vulnerable. I have also verified that the one-line
>>> change which Cascardo has provided fixes the vulnerability on Ubuntu
>>> 20.04.
>>>
>>
>> your testing included both patches or just this one?
> 
> I applied only this one line change on top of the kernel in Ubuntu
> 20.04. The behavior I observed was that without the patch the kernel
> was vulnerable and with that patch I was unable to reproduce the
> problem.

This patch should be re-submitted standalone for -net

> 
> The other longer patch is for a different issue which Cascardo
> discovered while working on the one I had reported. I don't have an
> environment set up where I can reproduce the issue addressed by that
> larger patch.
> 

The first patch is the one I have concerns about.
