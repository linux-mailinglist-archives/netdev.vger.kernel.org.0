Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B59A7E38F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388817AbfHATv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:51:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38958 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388633AbfHATv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 15:51:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so34776368pgi.6
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 12:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vt28EcxxBo2EnWu4rBDgHlsTPZ+2ZNh4vId1YX1INoU=;
        b=W5jF4sqskJuwd7g/oDi1Uvwfk6b/AJQHZ8zFTtpYQtt6QO8XtzIEJDC7u854ksyn2X
         bJPuRo9xuPzsAdfgVPIcJU33fhdbfQuB4M/SG9gc0Rl0Cq9Tbud4dkMDiI5GZ6Kx4AUA
         KtGJLNG5fupQGO0wh0+MI618WtFCRoPb28e6beks4/lmjMjBKT2cFyhz7ISpts94kEfU
         UfUaTBTUUVLnWq11ItCoAlM8GgT8CFWTTG2TFR3fPYJWC9Rxu523IiWNxoYeDjQsik67
         8JEPU2Ss+mcBTleI/tvnno8NL11k3IEt3VbnMdZ3Tm8jrceUYRJM+NN4Fi8VHS33g9fQ
         peIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vt28EcxxBo2EnWu4rBDgHlsTPZ+2ZNh4vId1YX1INoU=;
        b=LNP4rEk+ASZhD/Fljjmxm/nORLq4G87AVJ/LBR0F/ia98MaLi9I8Oqolo8qP0kmoN9
         bSC240+eTBtzPPX7Xn1GJxtDyYIuQn7Ci2IdGSZb2jXd4P88e758wau+Lrwl3h6Reu9u
         BlOAhVP9qjPbYfra5R0nISMMUDSE0VwFxfP+NcDvvMy6IPyUGbLoCSBPXdDaMGoY1AHy
         EjskadBih5GEon7F5dbqft1fdNGstJJA9KeXdZUHkQMyRIhVSb/PdBa04TBZv8z8wxSm
         xWgHjn0/3suqlxO1yORXOXsAjHwGXM1gsiu6GGyQIU2lT3HUSavHawSwsEAIZK0hpBDu
         bLVw==
X-Gm-Message-State: APjAAAWavaHfBXW7VTFLwNYzGysm3Slc2JocOAMRRG+QPO5CadhjZAlH
        N+h4wu50QG2KrVqJMrbBPOw=
X-Google-Smtp-Source: APXvYqwUa+1xMhBFHgI0Rgl6vDR4C/iEsC7uI8T+JHL/sXk0HYNG9yZIXLwJ/LfUjGtpkn63V2m/gg==
X-Received: by 2002:a63:f456:: with SMTP id p22mr45391934pgk.45.1564689088659;
        Thu, 01 Aug 2019 12:51:28 -0700 (PDT)
Received: from [172.27.227.186] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l4sm73969909pff.50.2019.08.01.12.51.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 12:51:27 -0700 (PDT)
Subject: Re: [PATCH net] ipv4/route: do not check saddr dev if iif is
 LOOPBACK_IFINDEX
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190801082900.27216-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
Date:   Thu, 1 Aug 2019 13:51:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190801082900.27216-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 2:29 AM, Hangbin Liu wrote:
> Jianlin reported a bug that for IPv4, ip route get from src_addr would fail
> if src_addr is not an address on local system.
> 
> \# ip route get 1.1.1.1 from 2.2.2.2
> RTNETLINK answers: Invalid argument

so this is a forwarding lookup in which case iif should be set. Based on
the above 'route get' inet_rtm_getroute is doing a lookup as if it is
locally generated traffic.
