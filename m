Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795DF46D09
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfFNXzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:55:47 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42435 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFNXzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:55:47 -0400
Received: by mail-pl1-f194.google.com with SMTP id go2so1612837plb.9
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x7ZkjA9pvs4mXGJTNdXub8i+BsmlISKSAa0/7jTzzIs=;
        b=pIxg6LJisFcD6VhjW7VAseq9T3RuTIcvlh15HHg22rwQ3cj2nHOJ8AAtxdV0LeMti3
         hjaplFDLf7awKJ4GjbgBfaSeUbCADC18Bzi55P6gFwlBmfk1MwsA0RYl/mXDGdrZ+bTe
         UMC9ehSsf4GXSOrPDHCv3trhMsWQL5EYcYgNoVZxkqawXtVlgxH3It8VCUAT5SuAQsNI
         rYE0UNnPs+VXU1SApyU5f3Hkuyn2U+cgvYdwbYA58Vr17iTIK4ywfaUMbkhc5kzhOh9h
         TrBvgmMJE5nM/4F1Hjt7WOVafJlvpj7L+1cNJG8TfryA9b/Ll7fOlf/WkPomnEirVs4/
         3Q5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x7ZkjA9pvs4mXGJTNdXub8i+BsmlISKSAa0/7jTzzIs=;
        b=UkTNccBLfC14wSjtIVScry3dRPIQXH/IAu7Qx8/Nm+dUqp60JVoR9CiglESqUUgygE
         rNFuJRaVhJfqQcHApy7QBpqKoRkoYolIksDYOUacJ7SFoAujZ7+ZBQ5Ef0Ln37lY8kkt
         NGAXv+uKGIIEj5xPMFwZrrG4tBDuEiWlqpGmhsuNIZzdJriw2PWLEZDET2Kg5i+tNmsd
         TJekWvtpVfv4qIit4mqImpWM0ideosJsid1TbxpwN3nYTyoHf4ZDmmLLIrv8ghvIz2Uy
         sYsp+f5kEwVRkJhE3Px539AobEuLd7Re0ZD5SHLQosLKme1/YBWyuZiM51ZQDmOaNKLq
         Fdcw==
X-Gm-Message-State: APjAAAU6o/OglfzlQSd+m2+04snUWoMzFvumeF9N4LL8NbAemPgGHCdM
        UONK0I0+i0DSYBYEASbkHjc=
X-Google-Smtp-Source: APXvYqz44zWYSfOp+q2HSLlCrSeMSe7xZTp08VUy31Nf5gFgDyDz9IsYbXt25e80aPZWvildq5TV9A==
X-Received: by 2002:a17:902:7083:: with SMTP id z3mr31172172plk.205.1560556546986;
        Fri, 14 Jun 2019 16:55:46 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id b7sm3627672pgq.71.2019.06.14.16.55.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 16:55:45 -0700 (PDT)
Subject: Re: [PATCH net 1/4] sysctl: define proc_do_static_key()
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20190614232221.248392-1-edumazet@google.com>
 <20190614232221.248392-2-edumazet@google.com>
 <20190614234506.n3kuojutoaqxhyox@ast-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a98fd64c-48b4-d008-d563-24cea01822d2@gmail.com>
Date:   Fri, 14 Jun 2019 16:55:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614234506.n3kuojutoaqxhyox@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/19 4:45 PM, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 04:22:18PM -0700, Eric Dumazet wrote:

> maxlen is ignored by proc_do_static_key(), right?

That is right, I was not sure putting a zero or sizeof(int)
would make sense here.

Using sizeof(...key) is consistent with other sysctls,
even of proc_do_static_key() uses a temporary structure and
a temporary integer in its current implementation.

> 
> Great idea, btw. I like the series.
> 

Thanks :)
