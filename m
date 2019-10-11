Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B666AD4AB6
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfJKXKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:10:40 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:41398 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJKXKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:10:40 -0400
Received: by mail-pg1-f174.google.com with SMTP id t3so6603849pga.8
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 16:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xEJH2gl5cxrVrDLezlRqga3pxzJNbjj6AIpbXqfXcs8=;
        b=fQfyFxOihRduLBYlEj83v3WGaLarfxggJPycculkjD5/QQ4JYK64EiTNh+iE75M7rz
         5TLHn0N/4x1H47qmFsvjLOo+8Ro8uFoR7Qxv/1TPnDr7Uaqh+SAuuBZ9hOE6+n0WL4CW
         teAKyF1Y9SHSzqjDhMFIkjOc7whN0D2XJVjpI6IcMVzid1g1Hv/fGi1AnVy9q3jINR7+
         mfFGONOKmI3BIhBYnvhrDq59Na5WXR2ZIvGEnUzPY/VYHjhizTpH+vVgUPPKqY7ZtYJm
         Hf9oBbjgDnzbjkw4GVRS4h8M1bCJ6BOC4MtNLUeuunIFtZiQpr1S6fNUvOrqANOi7ulb
         b/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xEJH2gl5cxrVrDLezlRqga3pxzJNbjj6AIpbXqfXcs8=;
        b=Bixf7dg7BZGSdA244A0Eh8VtJ6Ehcp0pCK+L+hJcgSiLJcuBR0fb68qzoL0bUvjzH6
         OIvpeRkkKIj8x5sHJMhSQ1RdRDcYOIr0weGRoWTX15/RKqNu8mqJzDHnkF7cvuOZ+FpP
         suDpN97mZh2jXds0A3EwmHJPCMDz23Yk0pwXedHXGs89pBBGjJo73A5qJ1BkGLK2+HRY
         15P5Kx2PT1OvYgA7h2Z00OvJ4kKME0fDJS3ez/FWAInU14OaMvOKGbb3IQbU1Xck3ko8
         XbfqVC/xRjgFWQ3VCQw8q5ZxvIYTSaMfPfXpXcqjJ4o58Q4rP3+kTK5W/d8xhPd24cRc
         Hmyw==
X-Gm-Message-State: APjAAAXXGMOBXR7lbKM4U7jbu8vosj9GFKI7H4S1uDpZYW0YYkmWLEDb
        l+wiZYWPlqaNP/HmxiIwzzk=
X-Google-Smtp-Source: APXvYqyWwi7hMXOGDpdsWVyYeVfkPRLIlzxI//2fB3OJhRNkKulfyB5HsJmMQMEYFewxBvPFxqTztQ==
X-Received: by 2002:a17:90a:23b0:: with SMTP id g45mr19481802pje.127.1570835439951;
        Fri, 11 Oct 2019 16:10:39 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d0e9:88fb:a643:fda7])
        by smtp.googlemail.com with ESMTPSA id h186sm15804343pfb.63.2019.10.11.16.10.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 16:10:38 -0700 (PDT)
Subject: Re: [patch net-next v2 2/4] devlink: propagate extack down to health
 reporter ops
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        "dsahern@gmail.com" <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        eranbe@mellanox.com, mlxsw@mellanox.com
References: <20191010131851.21438-1-jiri@resnulli.us>
 <20191010131851.21438-3-jiri@resnulli.us>
 <20191010190429.4511a8de@cakuba.netronome.com>
 <4aba888eb7ae08b446aa1140df729bca93cb0d33.camel@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7889db74-817c-9558-f86f-a4e4c829c1fb@gmail.com>
Date:   Fri, 11 Oct 2019 17:10:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4aba888eb7ae08b446aa1140df729bca93cb0d33.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/19 12:45 AM, Johannes Berg wrote:
> So to me this looks fine.
> 
> I don't really share the concern about extack being netlink specific and
> then using it here - it ultimately doesn't matter whether this thing is
> called "netlink_extack" or "extended_error_reporting", IMHO.

+1
