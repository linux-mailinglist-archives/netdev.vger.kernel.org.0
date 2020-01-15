Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023A513D05C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgAOWx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:53:58 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:37497 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgAOWx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:53:57 -0500
Received: by mail-qt1-f171.google.com with SMTP id w47so17301433qtk.4
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 14:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a6/bagT1rLVSTy7DlRmwiRUIjb1i+qsGP5gPF1CasUM=;
        b=OYsAt9yP5OLoOlsp0GONDU1OptRfcCps1u+f9NH2CklukFjL01AaXP+Mdh31j98upR
         JolRtkMk9QFuYVo+QjoHN7c9DvI4mjdjNAUXTcJxdqRUzMJAABq99JJBEFTk9cBMjWIy
         oaL9f/3KST2upfeotaIDYqR7fslus9QGuqbC051IrZ/KdYHzp/gzCPccTEKHruz/yl33
         6f/vnfsRZ1xlCrah8jzp9UoXpe+A8pyieuEZxrZpVX815euzayM9DHtNvS68lI/c/KI5
         OY5qqLm4dtgO/YqQEIazRoD1H+gsmOijjJdJcRnI0AL7BXdGseMLJlI91jopGfS4oEbZ
         I4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a6/bagT1rLVSTy7DlRmwiRUIjb1i+qsGP5gPF1CasUM=;
        b=FN9872aLrYjcgOjI/iAmDYy3YkFU8ZrMPdO5GsEwnzyUpIxyvUht9OpURiHY7IAEc/
         8ucbvehULOkyX2fGL6gBUuV8ZcY34i+kuZHtG9N4NMUdTBf6GbQWpWQqOgDlZWYg8ofv
         giIYLh7xxjyAP9qlZFBfJZxpczbstMtFqkv4quIB2X+aFZ7fNWzRTBvjNIY/WXBz3T9s
         yAWIzBer4PyhfZp474vh/WYbk0Kp4YVfjvP6d5NoRYZwX+wNFUaP461ONKffWAr+7fms
         HWgR8i3xUtqm3YCTUEvm93u898vRvwxBIsFmYoEZlY1/c/iRmj8YJjR6Xf/+ZAn/kbSu
         laCQ==
X-Gm-Message-State: APjAAAWb1pz4bZWHgx4iSRjNgQ1bo6eVdsZQPPjBDEuy1UPM+qT+Npb8
        xGmfMEMepgRwDsf1ygm/loeEExh1
X-Google-Smtp-Source: APXvYqwqW3LF6ayDSlLv0sIswE/eqAoSNi4iIYCEg5jOwfx/U54dDTV4FXnTylWJSnyhQxSVAkjkng==
X-Received: by 2002:ac8:32ec:: with SMTP id a41mr934181qtb.235.1579128836318;
        Wed, 15 Jan 2020 14:53:56 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b4a4:d30b:b000:b744? ([2601:282:800:7a:b4a4:d30b:b000:b744])
        by smtp.googlemail.com with ESMTPSA id c24sm10413994qtk.40.2020.01.15.14.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 14:53:55 -0800 (PST)
Subject: Re: vrf and multicast is broken in some cases
To:     Ben Greear <greearb@candelatech.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
 <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
 <20200115191920.GA1490933@splinter>
 <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
 <20200115202354.GB1513116@splinter>
 <9ed604cd-19de-337a-e112-96e05dad1073@gmail.com>
 <127f1b9d-0bbe-5a1b-f322-a467d3f7d764@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fe89273d-106b-f02b-2a13-a819b234f086@gmail.com>
Date:   Wed, 15 Jan 2020 15:53:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <127f1b9d-0bbe-5a1b-f322-a467d3f7d764@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 2:09 PM, Ben Greear wrote:
> For the vrf.txt referenced above, it would be nice if it mentioned that
> if you do NOT add the default route, it will skip to the main table
> and use it's gateway.  I was visualizing VRF as a self contained thing
> that would not do such a thing.

The in-tree documentation needs an update.

Every tutorial I have given on VRF mentions that it is implemented as
policy routing meaning FIB lookups follow the FIB rules. You say 'main'
table but really it leaves the l3mdev rule and drops to the next rule
which in your case is the main table.
