Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B985BB96
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfGAMey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:34:54 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34043 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbfGAMex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:34:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so14494015wmd.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 05:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U0+iQfhqZTmi+eMUqyf4aEvLRrml8zRgevAbFs0IHU0=;
        b=DAfBkrpnXaMHVNf23+fG8b0BrDC/iYTXE1GFARO7lK8bOvVE5HSKmFgh0leeGWn8pE
         jNYfp16AS7/MU2xO+6xLnQpINTBHVYGC1QtPoGt112qrzY2z/auhtSZY5mmsJ0OZ7t1r
         CDOi9GLfekS8Xlr2Bg52GnMNzqgCPKnZufTAGXwMFr9aiGd/c7WHokvrurz2/5I+z1NA
         xekRJbnat4EmsfQ7cGFchyKpqB3bh3NiBDamHnctAhVW6lPCcsBJYAW05eaUN0NveXQ7
         E5nkvJejGEEBRsVh66GBW/Y3EKAj0B8wrabjfulL4M0jS0lyRLe1Prtb0oBhTK1g97bJ
         cy3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=U0+iQfhqZTmi+eMUqyf4aEvLRrml8zRgevAbFs0IHU0=;
        b=WG/H/2XFrVKqWMRmNYd74a6JUOsu7MOrpvPb2vjBXRP8o8C2U3zlik4Py94UtZq3r+
         YyhDGladx8cmTV6ovvCLiBbaTVgBInKudipzbMIsvQPfZuJgiZO2xj7m/fmlSey2R4Yc
         c75Te6bdbitHhzUOlRTPRrRPaGvS/A1K/2h6QtkzfQ0srvvYu9A7a4Kgp1tPyij5vkPx
         eKx1iFlLa8bzgCRj/b9VHI2jjEHkwP5OvWe6yE9ECOXA/6wvh+WrtEPNj7C9NFzqyN1W
         JRYcgT/aIEQEHenEcsGVXeZv2ONJDGIzLY9GaNhqXzx2FIDK/ccA6zervNRegglsvS6Z
         3Dww==
X-Gm-Message-State: APjAAAUIvy1WbteDYOyMU2j5dGhMmUgAEFr0GQVQe6y3rORjq7hkEryw
        vb72c2pEXBxLFF+6iKtvhC0Jjw==
X-Google-Smtp-Source: APXvYqymJi6wwNS/8315/nLS2MyRZoePM0N1Fn/cUy6ismxAmIhMutlP7p48n24TtX7sY61emKdSpg==
X-Received: by 2002:a1c:5602:: with SMTP id k2mr15019398wmb.173.1561984491364;
        Mon, 01 Jul 2019 05:34:51 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:78cb:f345:e2db:cb5a? ([2a01:e35:8b63:dc30:78cb:f345:e2db:cb5a])
        by smtp.gmail.com with ESMTPSA id x8sm27867360wre.73.2019.07.01.05.34.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 05:34:50 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC iproute2 1/1] ip: netns: add mounted state file for each
 netns
To:     David Howells <dhowells@redhat.com>
Cc:     Alexander Aring <aring@mojatatu.com>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel@mojatatu.com
References: <293c9bd3-f530-d75e-c353-ddeabac27cf6@6wind.com>
 <20190626190343.22031-1-aring@mojatatu.com>
 <20190626190343.22031-2-aring@mojatatu.com>
 <18557.1561739215@warthog.procyon.org.uk>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <3c84e8b6-99ec-b348-268c-72dd51fbd5a8@6wind.com>
Date:   Mon, 1 Jul 2019 14:34:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <18557.1561739215@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 28/06/2019 à 18:26, David Howells a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> 
>> David Howells was working on a mount notification mechanism:
>> https://lwn.net/Articles/760714/
>> https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=notifications
>>
>> I don't know what is the status of this series.
> 
> It's still alive.  I just posted a new version on it.  I'm hoping, possibly
> futiley, to get it in in this merge window.
Nice to hear. It will help to properly solve this issue.


Thank you,
Nicolas
