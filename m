Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3304A6EE1D3
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjDYM1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjDYM1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:27:38 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFEF133
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:27:37 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-38de3338abeso3313984b6e.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682425656; x=1685017656;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y55UlQfR1rdVFGaOotIL1WtS+MLyLJ+rsLk45gMJmmM=;
        b=ENSBXmmUEVGJnYJ96DttQErJv+t5j9VWhHU+CGunnjwaC/92SBo3T/57O+4hPCiymt
         S4ZK0/ILJJjS2rbu98uROv6913b+zCZJPIYetXroVP4hZDl2vEvAGMxMTGFA8w4qgcNq
         ESOvVQmFQn3ODvUBUyZpddGyrvOD2gXc38GRr0P1CkhgllhEynyEae3/pYKMn0FDfDdS
         a+MsUtJbez/lKCUGgjNZd8o4gXpfMsnjR/FQvXDl1AeWIIclSaTQT2xJuY1pAJIvI8oo
         9i5Ald+jekYqCbtWfa5vRxMnj+pOi4yjfr5YyosiQLERR98NUIcUn+lT9N2jNnw7yTpF
         AArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682425656; x=1685017656;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y55UlQfR1rdVFGaOotIL1WtS+MLyLJ+rsLk45gMJmmM=;
        b=LzamGeluEzUxtAcptyh5mmVjbSH/U3l/HO48Ybi8vxcPnhdKzVHi6XA92LErRdM3fU
         fRQH+Rvd+AVcfInps0z/Vd+z2vTJl1Qxq93lCL1jyNNo/tTAKz03n4raDssz5P/WoIon
         1bQNjqAK0wpCfSb5ypkMuEtOuWEw6FCMQvYusB+k+j00hWiZfeiXmSDfDmU2BUUAPoUU
         HtP65lctGJdQ3I720e/28j8Zv83sdBu0kHLM5txljL2HI+0g8QgvRCDEMC7Ywhm+DTCA
         2U28FeUxd8OrsroYv7P52idkF3V6Lmavmbw8fTZlQ9rHYPtLpFNZNwRFdAVmgB85oMrE
         Dmhw==
X-Gm-Message-State: AAQBX9fKo/zgKkGHPEh776WypslqiArWoixmGB6rkflKT+hUcs1Y0FtP
        4ls/XgBfBCbRbL3451ZDE6v7cw==
X-Google-Smtp-Source: AKy350bJ2Xu7CoBFJw5h/daaCJ7CCSJlUQk22nCl/eu4JcILJEBSbzhhJ6JIZslZ5DWaLYam898+tQ==
X-Received: by 2002:a05:6808:1885:b0:38b:6c2c:3168 with SMTP id bi5-20020a056808188500b0038b6c2c3168mr9457542oib.35.1682425656559;
        Tue, 25 Apr 2023 05:27:36 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:71a4:9f74:aa07:6d81? ([2804:14d:5c5e:44fb:71a4:9f74:aa07:6d81])
        by smtp.gmail.com with ESMTPSA id y64-20020acae143000000b0038bb2f60064sm5585496oig.30.2023.04.25.05.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 05:27:36 -0700 (PDT)
Message-ID: <f331c935-85b6-5e1a-d01b-57041aa12419@mojatatu.com>
Date:   Tue, 25 Apr 2023 09:27:32 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v5 3/5] net/sched: act_pedit: check static
 offsets a priori
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com
References: <20230421212516.406726-1-pctammela@mojatatu.com>
 <20230421212516.406726-4-pctammela@mojatatu.com> <ZEfD5e1MI+LUZVau@shredder>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZEfD5e1MI+LUZVau@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/2023 09:13, Ido Schimmel wrote:
> On Fri, Apr 21, 2023 at 06:25:15PM -0300, Pedro Tammela wrote:
>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>> index 24976cd4e4a2..cc4dfb01c6c7 100644
>> --- a/net/sched/act_pedit.c
>> +++ b/net/sched/act_pedit.c
>> @@ -251,8 +251,16 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   	memcpy(nparms->tcfp_keys, parm->keys, ksize);
>>   
>>   	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
>> +		u32 offmask = nparms->tcfp_keys[i].offmask;
>>   		u32 cur = nparms->tcfp_keys[i].off;
>>   
>> +		/* The AT option can be added to static offsets in the datapath */
>> +		if (!offmask && cur % 4) {
>> +			NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 32bit boundaries");
>> +			ret = -EINVAL;
>> +			goto put_chain;
> 
> I think this leaks 'nparms->tcfp_keys'. See full syzkaller report here
> [1].
> 


Hi Ido,

Indeed! Thanks for the report.
Can you run the syzkaller corpus with the following patch?

---

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index fb93d4c1faca..fc945c7e4123 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -258,7 +258,7 @@ static int tcf_pedit_init(struct net *net, struct 
nlattr *nla,
                 if (!offmask && cur % 4) {
                         NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 
32bit boundaries");
                         ret = -EINVAL;
-                       goto put_chain;
+                       goto out_free_keys;
                 }

                 /* sanitize the shift value for any later use */
@@ -291,6 +291,8 @@ static int tcf_pedit_init(struct net *net, struct 
nlattr *nla,

         return ret;

+out_free_keys:
+       kfree(nparms->tcfp_keys);
  put_chain:
         if (goto_ch)
                 tcf_chain_put_by_act(goto_ch);

