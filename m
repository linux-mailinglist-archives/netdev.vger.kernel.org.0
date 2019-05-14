Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAEF1C0EE
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfENDfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:35:43 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:39232 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfENDfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 23:35:42 -0400
Received: by mail-pg1-f182.google.com with SMTP id w22so7844950pgi.6
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 20:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Lqed7W8QDcfIkr4UuHMcYpYAJbflY9YIuisJ/CS+qEM=;
        b=o4PU0fm+66BeMkhUHnkntdnoaZmBqOjLRnCwV77sRAwvwvb+cml5nPb46+r81MRmHF
         WPP7wxvBFaYpprJHrRnE8Xk3kvjHMSLdqcWUZVYeHyC7CNyWP3jD00TwGO/Fzi6NsQ5p
         ceuGKeElYWqylBhhp7+o1RwGnlj0knhU4/2frwTCS/DazoR4sXHrOuyAR+1YBVr8Tzdi
         rKw6xg1himNv3d+6JTTPAwc27X7tjdRwGMY96grvCe+ZXxvYA42zCH+YJO0hIETIo/A7
         bqoyS8EfGoVXQUnKFdnvDJ0FInlYVcz5ggU7cS8s94UVdMawF01UCC5pdXvJIy6/4YOp
         uvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lqed7W8QDcfIkr4UuHMcYpYAJbflY9YIuisJ/CS+qEM=;
        b=oSZLdXmuhisjfTAlaXVNPJMzhNrUZCPJoc+B4Y6Qytp+tLmXdg/pF7RQVIQNCSWM4z
         MM7WGKi0M3mBRmMHQRuplucfHt37LzxcwpYlM6uBZVuwFbyY+prD1wHwpJD4XRad9+h4
         O/6kXBrbaINUUDMV21w5ACnKbViJ+w3E3JhDIsky0SIJzTAeQX9BLf76s2LExKN3Pb/T
         BfqUncCvQaKQHYFsfv8WKvjnjxSpPa1yXHww08wl3DxsFhZm0jJ5wP3iuOFNLoX4ODbH
         vuyqGLLkWcWBCMNgPShc+EIUmsF88OE/eCxez3yQ/xrUyr/gQbNeK537PECpRwpEQpSP
         KzCQ==
X-Gm-Message-State: APjAAAX2ssKnCJaWh/yt4BqILJNJCbF5sTIui/ztpJBlUalcMA8ee4dQ
        hIQWugGCzoeaquMtqu3xLtk=
X-Google-Smtp-Source: APXvYqwye0N4Tj35BsoHYE+iKcrhhfWUGV07oeZCVRJAsJ9LHOiyA34gnXgJjFCXgEHWXzHJK1V0hg==
X-Received: by 2002:aa7:9104:: with SMTP id 4mr7592424pfh.66.1557804941789;
        Mon, 13 May 2019 20:35:41 -0700 (PDT)
Received: from [172.27.227.184] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id e16sm21135331pfj.77.2019.05.13.20.35.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 20:35:40 -0700 (PDT)
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
To:     Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Wei Wang <weiwan@google.com>
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com>
Date:   Mon, 13 May 2019 21:35:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/19 1:22 PM, Mikael Magnusson wrote:
> Hello list,
> 
> I think I have found a regression in 4.15+ kernels. IPv6 PMTU discovery
> doesn't seem to work with source-specific routing (AKA source-address
> dependent routing, SADR).
> 
> I made a test script (see attachment). It sets up a test environment
> with three network namespaces (a, b and c) using SADR. The link between
> b and c is configured with MTU 1280. It then runs a ping test with large
> packets.
> 
> I have tested a couple of kernels on Ubuntu 19.04 with the following
> results.
> 
> mainline 4.14.117-0414117-generic SUCCESS
> ubuntu   4.15.0-1036-oem          FAIL
> mainline 5.1.0-050100-generic     FAIL
> 

git bisect shows

good: 38fbeeeeccdb38d0635398e8e344d245f6d8dc52
bad:  2b760fcf5cfb34e8610df56d83745b2b74ae1379

Those are back to back commits so
    2b760fcf5cfb ipv6: hook up exception table to store dst cache

has to be the bad commit.

Your patch may work, but does not seem logical relative to code at the
time of 4.15 and the commit that caused the failure. cc'ing authors of
the changes referenced above.
