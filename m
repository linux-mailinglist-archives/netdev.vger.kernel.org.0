Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D9C13B29
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfEDQW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:22:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33906 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfEDQW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:22:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so4272238pgt.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 09:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TR9yp8pd9r5nhE1cHIl67bxYylHEM7a3WI+AI34K2gg=;
        b=BHR6sbiMrPiSrkENZFSsNyOW9myMGH9SB6cSpYIPBDgaqy4xSat2Fle+wQOuzB/UBJ
         +5IXjcCb0K4kOa5ehR8DvfaMog+LWn9Mo86TvzPRdk3oDwAtHnT7ZcFIZIKmrVuigIqs
         ORZaETiAi8RcCvTg48R0K3DqQmyrfACgeRz7mb/NBrWoA3fCEWMlonDecyblRjmAWcB7
         QQZ9JfSRKvkAAaCeTGy33VsK+sJInPP327+OEGPWK16MED+VTCH744SNn+tQZWtSyHO7
         wVlbloRs5XWbsh/+yONrEBwdkzOYqOWxxuaqmbRhsScpFw8XALN4sJIfdLl2PEvamKgs
         XuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TR9yp8pd9r5nhE1cHIl67bxYylHEM7a3WI+AI34K2gg=;
        b=IteomVcqHRmSR7nMY9l+5Z9dh6eQGKplcVZGXqrQdVhkZcRKYC2t+iV898iXPz2r7/
         LkNxhpqQzXbZoej07oNDqWJW0rukcIIW1V4VAL5H7OHTHzM+4dBNLOWuH3LsVIKpfQwD
         jgnR6t5RcJ6P5F4KC75DMRyrK4A7GM2cViqCt5i2STlu4n1fZyrFES3gbQRYusBovbfl
         3AImgeaZ8rOGOUAYgorujR08WLCH2U2hlX44Y3I52XTEndEkEwnMGvbqOcEGu9ulFxmt
         CqEd7r5cXrlqYCFFGXms4FpMWO8IOlJ5+gBiymTiAQ8Znet7IGMf8RzSmdyMVNHe0rSB
         /uog==
X-Gm-Message-State: APjAAAX6lTfFI/wsQzqavyEDS1DAEbw8k6EAExeKG3mwd2idTgjaBCcg
        SNJ4XRpTu8vT2w7Oa9t7K5U=
X-Google-Smtp-Source: APXvYqx4iOr5v4WN6sAu59QEV1qLjk94qG2UX0Kxu9Qfb+mFBJYmDzYOVJb60fPW4y41i0XEv6AA+g==
X-Received: by 2002:a65:62d2:: with SMTP id m18mr19565555pgv.122.1556986947406;
        Sat, 04 May 2019 09:22:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ad89:69d7:57b3:6a28? ([2601:282:800:fd80:ad89:69d7:57b3:6a28])
        by smtp.googlemail.com with ESMTPSA id m2sm7872478pfi.24.2019.05.04.09.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:22:26 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v1 2/3] taprio: Add support for changing
 schedules
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <20190429225219.18984-1-vinicius.gomes@intel.com>
 <20190429225219.18984-2-vinicius.gomes@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <40656b30-d38d-83c0-abb6-a18189ad22aa@gmail.com>
Date:   Sat, 4 May 2019 10:22:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190429225219.18984-2-vinicius.gomes@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/19 4:52 PM, Vinicius Costa Gomes wrote:
> This allows for a new schedule to be specified during runtime, without
> removing the current one.
> 
> For that, the semantics of the 'tc qdisc change' operation in the
> context of taprio is that if "change" is called and there is a running
> schedule, a new schedule is created and the base-time (let's call it
> X) of this new schedule is used so at instant X, it becomes the
> "current" schedule. So, in short, "change" doesn't change the current
> schedule, it creates a new one and sets it up to it becomes the
> current one at some point.
> 
> In IEEE 802.1Q terms, it means that we have support for the
> "Oper" (current and read-only) and "Admin" (future and mutable)
> schedules.
> 
...
> 
> It was necessary to fix a bug, so the clockid doesn't need to be
> specified when changing the schedule.

Does that bug fix need to be applied to master?

> 
> Most of the changes are related to make it easier to reuse the same
> function for printing the "admin" and "oper" schedules.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  tc/q_taprio.c | 42 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 33 insertions(+), 9 deletions(-)
> 

applied to iproute2-next.

