Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B51D308DB6
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhA2Tsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbhA2Tsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:48:36 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F249C061573;
        Fri, 29 Jan 2021 11:47:46 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id u14so7696454wml.4;
        Fri, 29 Jan 2021 11:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9dmdnOm0YcJZLaqfcKfMkfwJx2NUZg9AHMzP76dBb28=;
        b=NTIQb6BKcItdDnjPZHfihBuHtA8lhKGd6Lva7UAlYC47hu6+elNobKPp1celmyaYWG
         Ln+sPNXyTt92BbIhVDT71YJjTzSMJ5xUvblgclSa//4AEbBjp0LB969YzBVHLJ4/RM8m
         LIBHOmPBArF19+P7tYB+gyH+pEiaq4oqX+ehNka9HWpQ95ZeHJ+VxbuTMzIoXfBlJw6l
         kOJEeXvzFwietubaUdWt4+EH5R987uKqOf+USBeBOKQrWq0oaweSOLMe28f4kAEoaBR6
         POCYEuOD8GRUbuNQD7Uq1js1LI7UOSN83OSLZMknyvR8zhLqNaeUKMtHmExdv+rycWwB
         /uXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9dmdnOm0YcJZLaqfcKfMkfwJx2NUZg9AHMzP76dBb28=;
        b=YYShOkhOghJSJFDiPmgrTnIYuyPgRkAaQdKU4HXSkrpEv0FdBTLvyq0PfpPt09Xnmd
         /HliKB0XqSk6asELP9J+AQQWF6mZHOgCBY5G/ECjoD71Nnj8m2ya3GkrHPAKq44Ho2sL
         AsOWUyExzSzjJ/Osg4RESU3Vg88nSpaPReqopCmEVMSQrOf6Tbg9bxVaeP6707+6shUK
         aer9SitN7T04Tle7FKpsBwZ3jSshIV7R7uQu6WKsWrpiwt249bI8JUzkKUwhCkR+DlO2
         /gwOz9VU/LPuR4SHt0JvEZBWoGxIKZXFohAJmX9lr4YdC5laGT3y3J+Ok2uQAos44khR
         Fydg==
X-Gm-Message-State: AOAM532CnzT0MbQQsOfYR+2qWjyZiZzKTAk4rs0YxiBYLglkYbzgBzW1
        oSuL5kbQgXs+qUJJHp2f/B4=
X-Google-Smtp-Source: ABdhPJy0tOE8ZkVIwf7EHOIsVDGo3dxBUbXrvZ3zi1LAUPYZELOirjD3m4sHjghlns7+SshJqqxY0Q==
X-Received: by 2002:a1c:27c3:: with SMTP id n186mr5301112wmn.96.1611949664301;
        Fri, 29 Jan 2021 11:47:44 -0800 (PST)
Received: from [192.168.1.101] ([37.170.0.234])
        by smtp.gmail.com with ESMTPSA id u142sm11735432wmu.3.2021.01.29.11.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jan 2021 11:47:43 -0800 (PST)
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline
 usage
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
 <2836dccc-faa9-3bb6-c4d5-dd60c75b275a@gmail.com>
 <20210129085808.4e023d3f@carbon> <20210129114642.139cb7dc@carbon>
 <20210129113555.6d361580@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <28a12f2b-3c46-c428-ddc2-de702ef33d3f@gmail.com>
Date:   Fri, 29 Jan 2021 20:47:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210129113555.6d361580@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/21 8:35 PM, Jakub Kicinski wrote:

> kdoc didn't complain, and as you say it's already a mess, plus it's
> two screen-fulls of scrolling away... 
> 
> I think converting to inline kdoc of members would be an improvement,
> if you want to sign up for that? Otherwise -EDIDNTCARE on my side :)
> 

What about removing this kdoc ?

kdoc for a huge structure is mostly useless...

