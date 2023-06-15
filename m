Return-Path: <netdev+bounces-11184-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D33D1731E13
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 118C21C204F0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1240E2E0C8;
	Thu, 15 Jun 2023 16:44:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40F92E0C3
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:44:23 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD172D4D
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:44:21 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f8d176396bso20351995e9.2
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686847460; x=1689439460;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iTvO1ofEFZkX2L+3srAV8TMv0rP6MBqsvVOXrpHnSKY=;
        b=R8lVsIzLO9gqTPBYp/l+9Q9fAAWEhY9EtvEGC+VDTc5Ei4EWf+aBOZmFiuNm4kZxIN
         XL+49s098/IoyDeQ5JuoegUSZ7fnqycK+CZOmPhBC9MYJdba4++T6Wp4Ty8ZyypQveB+
         CKgrG+QGaMDdyk7uCZ0mftS/EQPRlShRNxk7d3m1saSEXTPGwunTVO8n9kIEjy9lHdKD
         eYUnQB2ckQBiCMJgqxsLcWzoVnnoHItuTm9WzWZUuQmWoVowHMvj2RPE414YscH7zgrP
         stbcHGtObM8rSya1L+tZokTTHo2czXBvPPJNr8TvyLxcszbt95l2V+CD0fBnDpx46kVI
         TNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686847460; x=1689439460;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTvO1ofEFZkX2L+3srAV8TMv0rP6MBqsvVOXrpHnSKY=;
        b=FFDK1dMCfM2bFuYWnTEPq2rrS44uv2AyAHPzD2EFCUM9NTIdmU0HdUdrLWheHADKNH
         55GpmDXnRE5wIiW1fqrNskKdEIt2d8ir0TdWCDOVEL6SdueuMK2g0ZkTVp1f5+1VW6u0
         AXPEByfENhfeLiMGctsZZU8JdoGLxpPX2mpGHOrm+wbxTgs1Lz+uJwGnlLaa24GVcysp
         jCaWE8O9nA2TvA4Yt1tr2/OoFOk5jNv67nI8D/5bQwc+V4eoUuCrng1Bro43eDDjqR7m
         RAwg8lgon2IkfhpQWfVw8HTPvx0mwpOH4fstqTEIW4z9ZBw5o7GaCg0cJ8ggiMcfgpSU
         +FLw==
X-Gm-Message-State: AC+VfDyGfCzslQIBiZjF1IhlYS/TrmpubTYYuiJpOU2BqLqOvdQI9TbQ
	FNRHxctjJAMRiyp37PmhmEy9Zg==
X-Google-Smtp-Source: ACHHUZ7QMm+aLr1Tu/oeq1u2EFkDxx5DyPS9TS7lcx8zc3pb6NWiLVw+vXm/m+r9DTKwdS1hnHNG9g==
X-Received: by 2002:a05:600c:24c:b0:3f8:c8d1:b6de with SMTP id 12-20020a05600c024c00b003f8c8d1b6demr6520693wmj.15.1686847459649;
        Thu, 15 Jun 2023 09:44:19 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id z8-20020a05600c220800b003f8db429095sm4739944wml.28.2023.06.15.09.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 09:44:18 -0700 (PDT)
Message-ID: <21845b01-a915-d80a-8b87-85c6987c7691@arista.com>
Date: Thu, 15 Jun 2023 17:44:17 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v7 01/22] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Content-Language: en-US
To: Steen Hegelund <steen.hegelund@microchip.com>
Cc: David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, Ard Biesheuvel <ardb@kernel.org>,
 Bob Gilligan <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>,
 David Laight <David.Laight@aculab.com>, Dmitry Safonov
 <0x7f454c46@gmail.com>, Donald Cassidy <dcassidy@redhat.com>,
 Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman"
 <ebiederm@xmission.com>, Francesco Ruggeri <fruggeri05@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>,
 Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
References: <20230614230947.3954084-1-dima@arista.com>
 <20230614230947.3954084-2-dima@arista.com>
 <255b4de132365501c6e1e97246c30d9729860546.camel@microchip.com>
From: Dmitry Safonov <dima@arista.com>
In-Reply-To: <255b4de132365501c6e1e97246c30d9729860546.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Steen,

On 6/15/23 11:45, Steen Hegelund wrote:
> Hi Dmitry,
> 
> On Thu, 2023-06-15 at 00:09 +0100, Dmitry Safonov wrote:
[..]
>> +/**
>> + * tcp_sigpool_alloc_ahash - allocates pool for ahash requests
>> + * @alg: name of async hash algorithm
>> + * @scratch_size: reserve a tcp_sigpool::scratch buffer of this size
>> + */
>> +int tcp_sigpool_alloc_ahash(const char *alg, size_t scratch_size)
>> +{
>> +       int i, ret;
>> +
>> +       /* slow-path */
>> +       mutex_lock(&cpool_mutex);
>> +       ret = sigpool_reserve_scratch(scratch_size);
>> +       if (ret)
>> +               goto out;
>> +       for (i = 0; i < cpool_populated; i++) {
>> +               if (!cpool[i].alg)
>> +                       continue;
>> +               if (strcmp(cpool[i].alg, alg))
>> +                       continue;
>> +
>> +               if (kref_read(&cpool[i].kref) > 0)
>> +                       kref_get(&cpool[i].kref);
>> +               else
>> +                       kref_init(&cpool[i].kref);
>> +               ret = i;
>> +               goto out;
>> +       }
> 
> Here it looks to me like you will never get to this part of the code since you
> always end up going to the out label in the previous loop.

Well, not exactly: this part is looking if the crypto algorithm is
already in this pool, so that it can increment refcounter rather than
initialize a new tfm. In case strcmp(cpool[i].alg, alg) fails, this loop
will never goto out.

I.e., you issued previously setsockopt()s for TCP-MD5 and TCP-AO with
HMAC-SHA1, so in this pool there'll be two algorithms: "md5" and
"hmac(sha1)". Now if you want to use TCP-AO with "cmac(aes128)" or
"hmac(sha256)", you won't find them in the pool yet.

> 
>> +
>> +       for (i = 0; i < cpool_populated; i++) {
>> +               if (!cpool[i].alg)
>> +                       break;
>> +       }
>> +       if (i >= CPOOL_SIZE) {
>> +               ret = -ENOSPC;
>> +               goto out;
>> +       }
>> +
>> +       ret = __cpool_alloc_ahash(&cpool[i], alg);
>> +       if (!ret) {
>> +               ret = i;
>> +               if (i == cpool_populated)
>> +                       cpool_populated++;
>> +       }
>> +out:
>> +       mutex_unlock(&cpool_mutex);
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(tcp_sigpool_alloc_ahash);
>> +
> 
> ... snip ...
> 
> 
>>  clear_hash:
>> -       tcp_put_md5sig_pool();
>> -clear_hash_noput:
>> +       tcp_sigpool_end(&hp);
>> +clear_hash_nostart:
>>         memset(md5_hash, 0, 16);
>>         return 1;
>>  }
Thanks,
            Dmitry


