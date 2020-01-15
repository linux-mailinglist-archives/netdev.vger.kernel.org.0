Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC00C13CC71
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgAOSqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:46:05 -0500
Received: from mail-qk1-f175.google.com ([209.85.222.175]:47093 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgAOSqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:46:04 -0500
Received: by mail-qk1-f175.google.com with SMTP id r14so16610256qke.13
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BbB7MOpyYjrB+/IIeifGANJzaRFxF53ozM2I7mFRGPI=;
        b=tgH5fkp2vA4dag4nU9VUlxDRStj6Cch4gpsQmX2ru1pMa9gHewKH+G34pEqHnUb4sH
         HuLgQHOhX1KYl9VCh9LJ69ZxrH+BbDwImKE9eyHpKmC4ZUlJVtH3PaqK3qVKN0tM5Dv6
         DOMDu4Lot5GvylTj9BG3gYuDe6QDbtrpJWRF3OHOswbZdYX7NwtiOJOFnySdUP02EIya
         vRiJorG8M4pzBZZpnBjXeiLBO7U+6NkvGK4mHuZlwvwcwdIDdM+wk2ojg93WJJ7QTr+R
         Z5g9TQNHz68Tk/4iJgek6Tb9fwGInjVyFHxeOkTwCX46oVXo7bjXdhDVXkN+fTlrCl6v
         itqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BbB7MOpyYjrB+/IIeifGANJzaRFxF53ozM2I7mFRGPI=;
        b=ELpIW6yuz3HjF2Jsbl3IN/BZz2X4hO5zoVAFcV2O4FmFzfcL4fqQEntp0BF93qXeMH
         sCsEUGdnM66tyYligRsrjW90t/KXMdRWsK+Ag4nmhmv53x98pQurCjQMfK+lQo1Cb8CV
         Oy8igai7T8z09J9tx0f0+pOfq75z7P8RokwbIUhNmPwZsjEeqABbJurXxwsEegQgkbgo
         1kwoNXDk5VAMRAnVCo1qkhcEOz+pE292vstTV0J89CSXDnBu6ilGropbtLx+GiSAudze
         8QUewIndgdC6CSgokfWGJAUYfX6wnVy+L7gaY9XYGn+4bSNIIDkd3obtvOcZ1VOuil7o
         ikzg==
X-Gm-Message-State: APjAAAUUD70ekK8zE/EeNdENMKGvOFJ/H1jjFr9w1lcMDcxPRSA5xspa
        t14s5HSoEaUbyTjJ6RN1xVdr7arr
X-Google-Smtp-Source: APXvYqwgv/yLhe/j2IymLFnC8+z7uz4zHxYrRoF/m4l9meIPC4ktVXP4yInJhSIBOXFEgamfF6ISlg==
X-Received: by 2002:a37:4047:: with SMTP id n68mr29349285qka.258.1579113963082;
        Wed, 15 Jan 2020 10:46:03 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b4a4:d30b:b000:b744? ([2601:282:800:7a:b4a4:d30b:b000:b744])
        by smtp.googlemail.com with ESMTPSA id x34sm9899777qtd.20.2020.01.15.10.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:46:02 -0800 (PST)
Subject: Re: vrf and multicast is broken in some cases
To:     Ben Greear <greearb@candelatech.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
Date:   Wed, 15 Jan 2020 11:45:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 10:57 AM, Ben Greear wrote:
> Hello,
> 
> We put two different ports into their own VRF, and then tried to run a
> multicast
> sender on one and receiver on the other.  The receiver does not receive
> anything.
> 
> Is this a known problem?
> 
> If we do a similar setup with policy based routing rules instead of VRF,
> then the multicast
> test works.
> 

It works for OSPF for example. I have lost track of FRR features that
use it, so you will need to specify more details.

Are the sender / receiver on the same host?
