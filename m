Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFA45C2C5
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfGASUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:20:11 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37431 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGASUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:20:11 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so30987042iok.4;
        Mon, 01 Jul 2019 11:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hsjfJFtXIc876oA6kbyjhF6TaAGhe5n/zUVcDCGFCBA=;
        b=MbbSSbaZuJ4ZksgU1YmbHop1HrlARCU+BRELQFsae+Da/z+8Cyk8LOHDXiBrbcc0I2
         xdJphRwekKsFouuPzwmXTQrtGeDleRLUDeoDuGhuOJ3uFZg1W+nW4WKrXXnMOjGY8NVU
         59u07k+5rq9mLpNc9P5JkESuM/px1EImjv/EiGLh5qZcMtsEZXfrKZzq3t2cZU0aooEx
         bflZlMadd45a1vyhdL6hFe8RHwpfBSga1FwCevz7bXCgTPMLKA3qEE31+85rZdzLOal0
         w1lcZyxKGEFzCo5KoIq0F4eL4tX4v1nmEiQTGEBsPFg2k/VQrM7Va67Y/vTubuzV6RuC
         0qug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hsjfJFtXIc876oA6kbyjhF6TaAGhe5n/zUVcDCGFCBA=;
        b=cL6OEQVRBKpTxfCBIiZCxgQf4boHJiOInTmW+6jn8OpED5WWQcFx3I+JE9wcBpy1UL
         VFZDbugM/9g9yjEeKf/iiDTY78b3WT66RIcXFdKH0xWAmhFHGG1Dk0htc61tRvd/JQZT
         /j5Z0+6XeI6sD0o3i8Y92/GlQuCxzzYOtcvj0BEWwXvhw2x3wijsM6uEeP7Q+nA1iWqt
         2DK+fv1F//r4M69Fs4yacVlcEYkMkXZJUofeRcWdBz31SSm/kErYH2TS3kWQ1vHIO20n
         mDv4YtxIW3d7c3b7R4DseAuxvA3D3+k8+OYB+ui0ByzcAfX+llebohNn4xYpEr0Tl85u
         ybUg==
X-Gm-Message-State: APjAAAX0w/OQbCs0IXiTGia4QYHsTfwdEeGZNbxgOMifAoJz7qrfRGt8
        sz5lNnqNGQVUxsJuZ51v4xk=
X-Google-Smtp-Source: APXvYqw3Din4wvxfk4QaVEIEM27/5WZC4/u2nLVeZAhuBD6dLmBFItt4JO4en3d51uvHf+IEXQDZBw==
X-Received: by 2002:a5e:c241:: with SMTP id w1mr6151368iop.58.1562005210771;
        Mon, 01 Jul 2019 11:20:10 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f191:fe61:9293:d1ca? ([2601:282:800:fd80:f191:fe61:9293:d1ca])
        by smtp.googlemail.com with ESMTPSA id j23sm12048683ioo.6.2019.07.01.11.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 11:20:10 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv4: don't set IPv6 only flags to IPv4 addresses
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20190701170155.1967-1-mcroce@redhat.com>
 <c8fac6db-6455-b138-aca9-2f54d782a0b6@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6bd2b840-41eb-c3c5-2405-adc104066617@gmail.com>
Date:   Mon, 1 Jul 2019 12:20:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <c8fac6db-6455-b138-aca9-2f54d782a0b6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 11:19 AM, David Ahern wrote:
> I guess at this point we can fail the address add, so this is the best
> option. 

bleh, that should be 'can not'
