Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B8795474
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbfHTCeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:34:01 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:37859 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHTCeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 22:34:01 -0400
Received: by mail-qk1-f178.google.com with SMTP id s14so3294426qkm.4
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 19:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wAPOK+OfAhI9yE7x3fHtODXTVMkOVu9eyiQj304MG5M=;
        b=Vomr9/BiiHwJef+euzIOf+mJY2BC5ChHU910BmI5Z130IV4gjy0Q7/pTU/6FgDGeyx
         4O71hXPTUWdmcaAJdn5NMeC6X9/SajJjYd7cbqeVYRQsvoC0qJMqPSqMqvW7Pw5kMHlP
         l+UTGX5fVHKK+Uf1QLk2+InTK2wQihkhuaa+qGYBkVlt3GcZHITvQc64rUyMZmYgtU6U
         RL9E+5lKi0TYLMj5GHb/7lM/j63loJAJvd9JMDHLn2j09Md0lmqZbkcaNw0CKr0DjbM+
         PH2p7F+ILmBffduISTwSd/cNZmCxo2CoGOgtLJVaz/FFrJt1VPeq70/HD7UnKDrVXeq7
         fqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wAPOK+OfAhI9yE7x3fHtODXTVMkOVu9eyiQj304MG5M=;
        b=MVQAxIyZrLsr+Xrt0y4LREceBnHXBQFMGt4/faPfDqkqVkFyI00/XwIgSU9Opo+K7K
         8DTiiESjOs2AjuztRVZIC+fSjnKYuwvsXTIhyHkM+O1dUYLb0ql7/z8+807dMfVgdTwU
         ZqCA0L6pkIxEQxViFQZkBZh/1OL1wMfQ2M9sbhAxqkozSsSqIhxrjsNqDD9zyGzrNCKs
         o/o7OlcTgu6RtKchrLU8p5+d8GNW/P3Kdj2PnUBkgTvSFYzCBTC4MZpKb+YVoVNZG0TN
         gn4ZL43w5J4DuZ4QZUq6cbEDiqrkvb2mAzpe/EpANnOcM2GBuELdPuVHFw63E+YBpB5d
         iLBQ==
X-Gm-Message-State: APjAAAUiDVXFESh531OeyOWZlOXkUwe1mMbZtGqIwuH/jjzkVIT8022d
        U4b9v3DqMyGOR7HWYNGaO98=
X-Google-Smtp-Source: APXvYqxNSKGTmiIW+S2Gmkb+mKIIiqfjndjUtLEybfH9VHMw8asSnfRDmza/vm1UtjccUIO32mlHRg==
X-Received: by 2002:ae9:e207:: with SMTP id c7mr23017728qkc.262.1566268440389;
        Mon, 19 Aug 2019 19:34:00 -0700 (PDT)
Received: from dsa-mb.local ([2604:2000:e8c5:d400:50b8:a11e:7dc7:a1e4])
        by smtp.googlemail.com with ESMTPSA id w24sm9269877qtb.35.2019.08.19.19.33.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 19:33:59 -0700 (PDT)
Subject: Re: [PATCHv2 net] ipv6/addrconf: allow adding multicast addr if
 IFA_F_MCAUTOJOIN is set
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Madhu Challa <challa@noironetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>
References: <20190813135232.27146-1-liuhangbin@gmail.com>
 <20190820021947.22718-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4306235d-db31-bf06-9d26-ce19319feae3@gmail.com>
Date:   Mon, 19 Aug 2019 22:33:58 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190820021947.22718-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/19 10:19 PM, Hangbin Liu wrote:
> But in ipv6_add_addr() it will check the address type and reject multicast
> address directly. So this feature is never worked for IPv6.

If true, that is really disappointing.

We need to get a functional test script started for various address cases.
