Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F32242024
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 21:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKTO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 15:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 15:14:57 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1102EC06174A;
        Tue, 11 Aug 2020 12:14:57 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id a65so10986365otc.8;
        Tue, 11 Aug 2020 12:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OA8tghEF0M+1mPo3kQfRuuxmiSjkrfyHvTqZ6Feg5XQ=;
        b=Q1KyhRsFb0H2aoNJ5Fktl5NeI+ShyIo9oMHA22Ad6/dGMW1qrdh2oZv+3s/FOk9JE0
         WTmqhThYIp8hqsPYteIjnAJ1ZTyHhMxfZgO98xjoZgCCSHXI6+IYiZSehuCTfFbMV9Ba
         kr2pPYYwtC27qMNTnRaM8CagxEo+5wVl1pMhjze0dEQliaLgkGq25c66cnnc8F7E0oXw
         9ZWij8okN1ReNC6m5YrjO21Xv7o78DrnoWR51pt/KrD/KCVJVU8kKdBp/apaiS8/lieQ
         qcqqP5gbnDrvmUs94F1wSYChpIW1rtTpMobjxqTAA2kVX1QTKJmBFEnVi1CppfPKv5La
         2cbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OA8tghEF0M+1mPo3kQfRuuxmiSjkrfyHvTqZ6Feg5XQ=;
        b=oSLdZgYvkDazuXumCM9WvqleauANb0D+jUFMPKLNPvBmUvo/uFFOrjwJlFecCOerHK
         tS5RZVa9wUONlY+3fb2lf+n9E2hYf81afT2yT9sPEhc9MKDQ2kMZ1Dt6w//DdnsYKHtb
         4YWNBPZfpoqEZKpeYwgIK5fmmQESiwS1kmd0mVE0Ev7Q+bIbsPZtVlsSn6ZkXvumzlnj
         KjvR5+v772cXU/IsJGIOCKkdqd2tE6ZAp2K4CghtETb+u7H+pnL60qXixbyqqrEo6uKc
         W3fgAiElXvYtA1ZpA3Imi4euk6huhOVOvwf8aMc3DJU9bU0fhVTI/H1jdT05tQASd180
         dgfg==
X-Gm-Message-State: AOAM533Y9GZeKe4Zv1Hhgo+5EjLOmOA8Zy/N6/DEea70tWGuYESV57Ol
        ten4ZxeLh63FotpbvXa9C1Ls06Fz
X-Google-Smtp-Source: ABdhPJxMeHkDpk50vazkCw4XAFfZSGJAR6O000Qnp/a4JJChj1c+dEs4sE1AW1EEMmeoXcgIWyIxFQ==
X-Received: by 2002:a9d:5a8e:: with SMTP id w14mr6025994oth.214.1597173296308;
        Tue, 11 Aug 2020 12:14:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:1c6:4d6a:d533:5f8b])
        by smtp.googlemail.com with ESMTPSA id z189sm4543913oia.33.2020.08.11.12.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 12:14:55 -0700 (PDT)
Subject: Re: [PATCH] selftests: Add VRF icmp error route lookup test
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michael Jeanson <mjeanson@efficios.com>,
        David Ahern <dsahern@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <42cb74c8-9391-cf4c-9e57-7a1d464f8706@gmail.com>
 <20200806185121.19688-1-mjeanson@efficios.com>
 <20200811.102856.864544731521589077.davem@davemloft.net>
 <f43a9397-c506-9270-b423-efaf6f520a80@gmail.com>
 <699475546.4794.1597173063863.JavaMail.zimbra@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <511074db-a005-9b64-9b5a-6367d1ac0af6@gmail.com>
Date:   Tue, 11 Aug 2020 13:14:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <699475546.4794.1597173063863.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 1:11 PM, Mathieu Desnoyers wrote:
> One thing I am missing before this series can be considered for upstreaming
> is an Acked-by of the 2 fixes for ipv4 and ipv6 from you, as maintainer
> of l3mdev, if you think the approach I am taking with those fixes makes sense.

Send the set, and I will review as vrf/l3mdev maintainer. I need working
tests and patches to see the before and after.
