Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE98CDFC03
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 04:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbfJVCrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 22:47:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41205 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVCrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 22:47:24 -0400
Received: by mail-qt1-f195.google.com with SMTP id c17so21541300qtn.8;
        Mon, 21 Oct 2019 19:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WySvzBCFBCFgH/1a9rHbbdy4QdPGhs9C/obzdvRJ4F8=;
        b=bajvseEbSZD8pigLhE6CKu+zTmKT8LcvjqpD0pPHTveHvRHMeiC/dyJD59iv1SyKUS
         ySdHAM8olzWEAAG47lXhtbIA8+HZIkdHG4f2TrDBk+dn08BmsDqogomAvxdM7GP0/SHm
         SpJUr2A2wbwy8Wpd6jD3u59SS7WQgmOmMhFL0BYBvyN+6nvfvumZ8AIjulldN+l2lGvb
         ZjFIz5MN8wc6el4ZWvRs9ea3wWvM2wQ8po9v6+rK6bAeNnlAhtj16qsjxjZWhJAJaoiQ
         d2Zl5U8VUrix7rdJv9zGeqEEpZYwgZqL4WlXR0et1bWPcBC4psFFwfab1fR3p+NNrfOj
         E3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WySvzBCFBCFgH/1a9rHbbdy4QdPGhs9C/obzdvRJ4F8=;
        b=SIT9dXZx94sz22zNAvSqE3QeYv832MQmGd8wbj3hVv7n6gDoM6T6JAfUQsPticN1EZ
         hh6UVThtyn0YGdnTLzfBvJoIzZIvRXJ85qQEAMAwS+0o4GX4rw4MvDYwWNYkFivVHHF3
         W5Zk2mAvKxZj4rMkhGqL1/ZDZ3ApBUVQuD61n9tCQiW3bUSwdaqlGDvv1QEAyIfnQ1YH
         bfYJc3kxyZCKYMJEsQGWj6HTr872YNNBnaPohUG1koVmWYz8H69jAV8ZrEISJoxgqNxe
         rxL3/Na7V91oKThiaEOpybgQvDRVYKfV+5wshc8BKyPd4Gd6yiWyIcqJ43ybH20LbZ2l
         eDBQ==
X-Gm-Message-State: APjAAAUuVqEMGTpTMVIdOQjyO8bqplY/tAt9DUepE/rfyb4tbBgk4hVJ
        mm1bif+1WvcXyxTxvski2v5k4dz1
X-Google-Smtp-Source: APXvYqzwIQTymyXYjfJ8y3Y79B0B6+mp6XzYeRvdVEK8KHjz1tRCly/2dnIIW5lIZCK6geyHbo/GGw==
X-Received: by 2002:ac8:359d:: with SMTP id k29mr1043887qtb.96.1571712442839;
        Mon, 21 Oct 2019 19:47:22 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b912:7de9:ffc9:d1c])
        by smtp.googlemail.com with ESMTPSA id r1sm9780610qti.4.2019.10.21.19.47.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 19:47:20 -0700 (PDT)
Subject: Re: [PATCH RFC] net: vlan: reverse 4 bytes of vlan header when
 setting initial MTU
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, jiri@mellanox.com, allison@lohutok.net,
        mmanning@vyatta.att-mail.com, petrm@mellanox.com,
        dcaratti@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1571660763-117936-1-git-send-email-linyunsheng@huawei.com>
 <20191021162751.1ccb251e@hermes.lan>
 <b9567cd4-8fea-497a-5d32-b797425e7854@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3c79d203-33e9-11dc-939d-3cecd707eb40@gmail.com>
Date:   Mon, 21 Oct 2019 20:47:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b9567cd4-8fea-497a-5d32-b797425e7854@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 7:31 PM, Yunsheng Lin wrote:
> Or we just leave it as it is, and expect user to manually configure the MTU
> of vlan netdev to the MTU of thelower device minus vlan header when the
> performace in the above case is a concern to user?
> 

for now, I would think so. vlan on a vxlan device ... you are going
after q-in-q'ish with vxlan? that can not be a common deployment.
