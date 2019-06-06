Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD2138136
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFFWsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:48:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38599 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfFFWsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:48:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id a186so12449pfa.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KPtRFNrk6HUAM0PVfP3hw48l+Xm6FdVvkVTlCsVfwGs=;
        b=cKx5ryUysQlef9KswAR0GDh8r3oDdoMSmjaNBKAM5uWCBIVSZKB84GStGhCEGcdIYC
         V9Zbikeu6UZlynvG1wmlenZQYnlzoW1KTGQXxia/FdGYi0ZnFZJpP57wp7mLQH9scF+0
         AX488kf956fQWhnwSg5ZW5ie2zEaKw/eLpzu6OtL4ENfn88eU/Ja7vPGn9NpG6MLQqsr
         JylvyU6MwYfygPfljgBKL5WJoKoZWyg2Uipk/SFVyKEirD6yT/Ho8EcesN8NLm7Kv6P2
         ZQfw2laDqSvyN/9e+c8d7oct/xn/AtK/anDkSgaS67zf37675OD6AKSw5j130AE0WXKT
         JPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KPtRFNrk6HUAM0PVfP3hw48l+Xm6FdVvkVTlCsVfwGs=;
        b=M8BMEPa5ovtME+Mj0oDTyt4HOA+v+pdvEZBQitJMd+ZsTfSQOxlTCWBVxYnLuh9bsQ
         KrYz9FtC6W2XtXrGR6dDVM32k0gVNMEZBg0N3kxACjOjlytCF2dJlBHC2I+dIviq/p6Y
         o1aOcEUVNnqyGB5EQ/Wf1Py69SVds/UFQ7CAG5+9wGQ4o6pTBoVdaY1fd+8Hp5Cept6I
         OXWfcoSn/LzagCZCPomb4jjdObmIf1dpcnL2j5lb3+FAO6is8P02KNck76w8a5Z17EZQ
         hgAKNWEnCVUtL+YQ3roL5tHP4+IySronMyS9E0X0Bv3WtooFI3s4Fw9CIBcPNxGLJWqz
         qmdA==
X-Gm-Message-State: APjAAAUuKoWmP9aIT7a/ikEUrEBSPr6sy6SQkDrPZ5YueO0PeNF+Zz33
        Xe9T81y/am6IkaYywhA4nX944CQoWyk=
X-Google-Smtp-Source: APXvYqwVzSxm7sS8OPRdArHqpOiLH/PQofI4Q8nEco6Yoy2CjcrKqPSpRLnoeCDafRSy2RQdN3UWkQ==
X-Received: by 2002:a17:90a:8409:: with SMTP id j9mr2335576pjn.2.1559861334149;
        Thu, 06 Jun 2019 15:48:54 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id t11sm192871pgp.1.2019.06.06.15.48.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 15:48:53 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
To:     Martin Lau <kafai@fb.com>, Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <20190606214456.orxy6274xryxyfww@kafai-mbp.dhcp.thefacebook.com>
 <20190607001747.4ced02c7@redhat.com>
 <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b77803b0-3d9e-6d1e-54a3-8c4eac49ca2c@gmail.com>
Date:   Thu, 6 Jun 2019 16:48:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 4:37 PM, Martin Lau wrote:
>> I don't think that can happen in practice, or at least I haven't found a
>> way to create enough valid exceptions for the same node.
> That I am not sure.  It is not unusual to have many pmtu exceptions in
> a gateway node.
> 

yes.

Stefano: you could generalize this test script
   http://patchwork.ozlabs.org/patch/1110802/
to have N-remote hosts
