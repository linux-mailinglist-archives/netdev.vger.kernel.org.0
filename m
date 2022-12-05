Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0236642EAC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiLER1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiLER1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:27:07 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF181D67F
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:27:06 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1447c7aa004so6117098fac.11
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O0l2jgBkbcFWZC+mwoHMx/KNkyrPcTHDbXUqYzNW8PA=;
        b=kbalZZMb9U9grHe3sfOPIrit8IG2pbIIL6EmcH45Z6oE6J56au/LKsNXWaLjy+fwDj
         +usZu7sedvbRcBd5uEp67TF+ygAjPFJSDKelb3gTtsx5SUH1Irbsx6HtCmjEE23usrLn
         4GnQFoFJi/uCQQhjWNl2rEMBMPRclgvAqWOXDK0C26Kwh8YoYQoc8gUwvNhRUYVyAifN
         zR27EWT6ms3v2aV7c1QFGW27yAckuCKrAJFC5jLew+6s0FxgxLVf060GTrkl9uKptOoZ
         nA9codh7W9vopiiT87+yL6aXS8t7wUOCxhEMLVN2bwzQRzJZpXbCJS/QprohFDST/rJh
         +5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O0l2jgBkbcFWZC+mwoHMx/KNkyrPcTHDbXUqYzNW8PA=;
        b=xLwbsArQH95WhwaEsUnCTpztDzXmi3+Mzv0fZiGYpxZedYfXKCJeLotmDpAs4h+exL
         nmf9/0mmm8pMuoYN3Bx5cWKFMbTG3YuLBEFXF0v5i+Za53cfL2QzcM4Qr1tOgFtAFtyf
         XaF/bYjSFGpr+QTV2qPp476EAfzZz67aaxJ0ZjZCRlMlxIHvMbj7Qg6M5eUkCW8wryqH
         JGlYlgCTLmoJEXVY39t6UYVWECXqKsqoyFIIBM0aMnPbJOc1H6HQghoYagFne2WlkggK
         aNTPZTDkuBhLRM4YPXP9LCyeFVPvJEdLN41qtEY7v/fqMz7LTsupNJNjcjY+vJwvc0ib
         w66Q==
X-Gm-Message-State: ANoB5pnf7q7FAbBAfDrz4knITqBCuN9ZTcM5Gk0unfhFlo64ghh/sS3o
        zDaVRUbZI3eEup1dIEQwl799SA==
X-Google-Smtp-Source: AA0mqf6R2dHRhwcazhn04LrV12mQvSH7W2u6niBCzcyWeVA7velxifXm6+7Zo7/EykYCyOWyAVtP1Q==
X-Received: by 2002:a05:6870:c694:b0:13c:d5bd:6faa with SMTP id cv20-20020a056870c69400b0013cd5bd6faamr36444619oab.275.1670261225614;
        Mon, 05 Dec 2022 09:27:05 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc? ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id h19-20020a9d6f93000000b006619f38a686sm7829545otq.56.2022.12.05.09.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 09:27:05 -0800 (PST)
Message-ID: <7da8bfc1-cb91-7864-9e55-470c94084bf2@mojatatu.com>
Date:   Mon, 5 Dec 2022 14:27:01 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3 2/4] net/sched: add retpoline wrapper for tc
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Victor Nogueira <victor@mojatatu.com>
References: <20221205171520.1731689-1-pctammela@mojatatu.com>
 <20221205171520.1731689-3-pctammela@mojatatu.com>
 <CANn89iKdd74NMuJgzy+Hd22RNBuYVxyw9Tw4JOMY8nMVUhD8CA@mail.gmail.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <CANn89iKdd74NMuJgzy+Hd22RNBuYVxyw9Tw4JOMY8nMVUhD8CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2022 14:23, Eric Dumazet wrote:
> On Mon, Dec 5, 2022 at 6:16 PM Pedro Tammela <pctammela@mojatatu.com> wrote:
>>
>> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
>> optimize actions and filters that are compiled as built-ins into a direct call.
>> The calls are ordered according to relevance. Testing data shows that
>> the pps difference between first and last is between 0.5%-1.0%.
>>
>> On subsequent patches we expose the classifiers and actions functions
>> and wire up the wrapper into tc.
>>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
>> ---
>>   include/net/tc_wrapper.h | 226 +++++++++++++++++++++++++++++++++++++++
>>   net/sched/Kconfig        |  13 +++
>>   2 files changed, 239 insertions(+)
>>   create mode 100644 include/net/tc_wrapper.h
>>
>> diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
>> new file mode 100644
>> index 000000000000..3bdebbfdf9d2
>> --- /dev/null
>> +++ b/include/net/tc_wrapper.h
>> @@ -0,0 +1,226 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __NET_TC_WRAPPER_H
>> +#define __NET_TC_WRAPPER_H
>> +
>> +#include <linux/indirect_call_wrapper.h>
>> +#include <net/pkt_cls.h>
>> +
>> +#if IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
>> +
>> +#define TC_INDIRECT_SCOPE
>> +
>> +/* TC Actions */
>> +#ifdef CONFIG_NET_CLS_ACT
>> +
>> +#define TC_INDIRECT_ACTION_DECLARE(fname)                              \
>> +       INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,       \
>> +                                           const struct tc_action *a, \
>> +                                           struct tcf_result *res))
>> +
>> +TC_INDIRECT_ACTION_DECLARE(tcf_bpf_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_connmark_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_csum_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ct_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ctinfo_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_gact_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_gate_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ife_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ipt_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_mirred_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_mpls_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_nat_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_pedit_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_police_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_sample_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_simp_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_skbedit_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_skbmod_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_vlan_act);
>> +TC_INDIRECT_ACTION_DECLARE(tunnel_key_act);
>> +
>> +static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
>> +                          struct tcf_result *res)
>> +{
> 
> Perhaps you could add a static key to enable this retpoline avoidance only
> on cpus without hardware support.  (IBRS enabled cpus would basically
> use a jump to
> directly go to the
> 
> return a->ops->act(skb, a, res);

Makes sense, and then we drop the Kconfig option?
