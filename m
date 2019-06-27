Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB186586C4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfF0QOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:14:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46814 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0QOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:14:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so3207386wrw.13
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=euNd2+3p95Ak48CHAzHYJQ+RLT760N4oNX4lTZJk3Po=;
        b=Ybpcm+ROhx53wOzc7eNKtLf5yX5rXCj3IatUf+Mb72wTmikB7jfJ0fThUVV7ZNd1+1
         9qi3gUSz7k4awanKuCOyS5p0EqJOzaUPmn6nbabMe8hagj0fPmHzL+0GbjwuI3fmKPjM
         7qu6nxYKys5jYDn0aRHS+lsUyrVsINxt3o3Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=euNd2+3p95Ak48CHAzHYJQ+RLT760N4oNX4lTZJk3Po=;
        b=NIMRw8INrDFO+AyCMdWs2BTdhSXhT8eMnDvWf0T+7sV10Rci8A20dCxcwjSFqGvsUP
         aziTJ9CEAv2+c8DP3irkaSX30dC1VivMTBZ3QAO93Vs4RYxdjaerlAAwUyxUzm3zGbsV
         wA7enYVZjA7vWMtTWlcmOEtTDYerX9gxxzCG/1gxtMJFDNPpNNXRSh3OfNz775ATHM9y
         v/z99/pAzIzy7WPMXR7Ya4E0JWuBU0OvsT1a61ahDX62EsPiZUPlDnCO9WdfE44VLyxM
         3zYik3yy/hmOcy3P1/hqH3VLc5FROiDsPPysKSfXddhC14fVxQetqbQLismXN1PMYX6T
         Byeg==
X-Gm-Message-State: APjAAAWqf+3gi8pyvyAArx/bpei6cFh5oTWuqL3QhegQWyiHVWxYjlqu
        MPNjMoUx4PdJhPUhiabjvxSuh5csUwk=
X-Google-Smtp-Source: APXvYqxG3wDGdGFfLkPJspO55873+pJaY+mou8AA4FfwKFMHsDMphVDJuGEL60a1YXzh9zJW0EpTMw==
X-Received: by 2002:a5d:618d:: with SMTP id j13mr3917094wru.195.1561652038185;
        Thu, 27 Jun 2019 09:13:58 -0700 (PDT)
Received: from localhost ([149.62.205.250])
        by smtp.gmail.com with ESMTPSA id i11sm6985149wmi.33.2019.06.27.09.13.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 09:13:57 -0700 (PDT)
Date:   Thu, 27 Jun 2019 19:13:49 +0300
In-Reply-To: <20190627190237.0a08a4a2@jimi>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com> <20190627081047.24537-2-nikolay@cumulusnetworks.com> <20190627190237.0a08a4a2@jimi>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next v3 1/4] net: sched: em_ipt: match only on ip/ipv6 traffic
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, pablo@netfilter.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, jhs@mojatatu.com
From:   nikolay@cumulusnetworks.com
Message-ID: <77B4535F-0086-447B-B77A-F8D2348DC1AC@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 June 2019 19:02:37 EEST, Eyal Birger <eyal=2Ebirger@gmail=2Ecom> wrot=
e:
>Hi Nik,
>
>On Thu, 27 Jun 2019 11:10:44 +0300
>Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom> wrote:
>
>> Restrict matching only to ip/ipv6 traffic and make sure we can use
>the
>> headers, otherwise matches will be attempted on any protocol which
>can
>> be unexpected by the xt matches=2E Currently policy supports only
>> ipv4/6=2E
>>=20
>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom>
>> ---
>> v3: no change
>> v2: no change
>>=20
>>  net/sched/em_ipt=2Ec | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>=20
>> diff --git a/net/sched/em_ipt=2Ec b/net/sched/em_ipt=2Ec
>> index 243fd22f2248=2E=2E64dbafe4e94c 100644
>> --- a/net/sched/em_ipt=2Ec
>> +++ b/net/sched/em_ipt=2Ec
>> @@ -185,6 +185,19 @@ static int em_ipt_match(struct sk_buff *skb,
>> struct tcf_ematch *em, struct nf_hook_state state;
>>  	int ret;
>> =20
>> +	switch (tc_skb_protocol(skb)) {
>> +	case htons(ETH_P_IP):
>> +		if (!pskb_network_may_pull(skb, sizeof(struct
>> iphdr)))
>> +			return 0;
>> +		break;
>> +	case htons(ETH_P_IPV6):
>> +		if (!pskb_network_may_pull(skb, sizeof(struct
>> ipv6hdr)))
>> +			return 0;
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +
>
>I just realized that I didn't consider the egress direction in my
>review=2E
>Don't we need an skb_pull() in that direction to make the skb->data
>point
>to L3? I see this is done e=2Eg=2E in em_ipset=2E
>
>Eyal=2E

Hi Eyal,
Not for addrtype, it doesn't have such expectations=2E
I also tested it, everything matches properly=2E

Cheers,
  Nik
