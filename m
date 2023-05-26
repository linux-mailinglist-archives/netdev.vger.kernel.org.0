Return-Path: <netdev+bounces-5700-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C1BC7127D1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94EEC1C21063
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53AE1EA6F;
	Fri, 26 May 2023 13:52:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43361E534
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:52:47 +0000 (UTC)
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27D9F2
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:52:44 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6af6df840ffso645945a34.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685109163; x=1687701163;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HAWXcjREogzZp4uVk0/uG3AVAfpECwa+WB6lIXmcvxA=;
        b=wts0YuDCg0c7SfdYzXSjq1eaLgyBfL6XShwDM6+Y+sTQRda/6H3JcOLpdPguWjhkLB
         C1cSPBBnEnlW+w5zLfTlEs32pWjUQ/0dOJ+h241UREHT/JgWrm6bpOKeHKyjDeov/2q/
         +VBR9u+6x/4jQu+27rccojuxbNQiJaH+JtW6Dj9UxNgw7/6KaOqu6U9hwl6GCX+MNY9I
         HcPoFIMJjmchEsUFArxB6P0VDppM2upiSTM2yf/Fc4KlY1k1CYD2ZFjDJvE6c6O1eHFn
         rIheBrZLrKOVeoEdpncMM268R+IC9eqPaRJu0i/jlu0mIDJHjrc5Q76XTXpfCBixqgt/
         yWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685109163; x=1687701163;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HAWXcjREogzZp4uVk0/uG3AVAfpECwa+WB6lIXmcvxA=;
        b=cFCewQLO0LlGo52yXpzg/KjdRW1VmOCs8Ae1KDlff/ybV0MvXQz2ustr6Db5e/0yL8
         aihozj7aBNVzfSg1vldLuQ4GAFoJg542S+La9MMD1PpRsabIpVKPezwZmp/xMTxtpY+1
         lIsBrqhfRxEKrEdHs6eFUSwT3FF68CLNR87meAOY9lW84aVFYlqWoc5kh13NL4CtJZ8D
         nLc8zVmEjAX5xeaVhYJw1phb2xoyaZSGZWoSZhire0/ovePfVXNUp2NY8cMyCQHAlfbi
         rsPBH8AUBsC/4OgPy1GwaHe/dW7MK8nKBZtJSwgz4JZqZzAUoB6RwLB5uLDw26+qq1Ed
         tphA==
X-Gm-Message-State: AC+VfDyiFkP9hUbcgB8ZnMtlQcVHycu7kHE2b/ig8lPpiP7qwJQpibYF
	gVZRc3NhWsBHLSz4A950/LALrRiGQokv3bitfWM=
X-Google-Smtp-Source: ACHHUZ5uEmdvKs81Mw8ALfVyl9hn+vfKkbTp97+De8cPBBnTDt9NIDwJaGgIOP3GjoLUlo+nA+HGig==
X-Received: by 2002:a05:6830:1e6b:b0:6af:970b:e358 with SMTP id m11-20020a0568301e6b00b006af970be358mr870516otr.15.1685109163656;
        Fri, 26 May 2023 06:52:43 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:2f26:80da:f713:69d3? ([2804:14d:5c5e:44fb:2f26:80da:f713:69d3])
        by smtp.gmail.com with ESMTPSA id v23-20020a9d69d7000000b006ac98aae2d3sm1764250oto.40.2023.05.26.06.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 06:52:43 -0700 (PDT)
Message-ID: <cc593ec6-ad9b-d035-2572-a063576dac58@mojatatu.com>
Date: Fri, 26 May 2023 10:52:38 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] net/sched: act_pedit: Parse L3 Header for L4 offset
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
To: Max Tottenham <mtottenh@akamai.com>, netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Amir Vadai <amir@vadai.me>, Josh Hunt <johunt@akamai.com>,
 kernel test robot <lkp@intel.com>
References: <20230526095810.280474-1-mtottenh@akamai.com>
 <5587e78a-acfe-edfa-6b6b-c35bea34f5a3@mojatatu.com>
In-Reply-To: <5587e78a-acfe-edfa-6b6b-c35bea34f5a3@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26/05/2023 10:47, Pedro Tammela wrote:
> On 26/05/2023 06:58, Max Tottenham wrote:
>> Instead of relying on skb->transport_header being set correctly, opt
>> instead to parse the L3 header length out of the L3 headers for both
>> IPv4/IPv6 when the Extended Layer Op for tcp/udp is used. This fixes a
>> bug if GRO is disabled, when GRO is disabled skb->transport_header is
>> set by __netif_receive_skb_core() to point to the L3 header, it's later
>> fixed by the upper protocol layers, but act_pedit will receive the SKB
>> before the fixups are completed. The existing behavior causes the
>> following to edit the L3 header if GRO is disabled instead of the UDP
>> header:
>>
>>      tc filter add dev eth0 ingress protocol ip flower ip_proto udp \
>>   dst_ip 192.168.1.3 action pedit ex munge udp set dport 18053
>>
>> Also re-introduce a rate-limited warning if we were unable to extract
>> the header offset when using the 'ex' interface.
>>
>> Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to
>> the conventional network headers")
> 
> Just a FYI: the automatic back port will probably fail because of a 
> recent cleanup in this code
> 
>> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
>> Reviewed-by: Josh Hunt <johunt@akamai.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: 
>> https://lore.kernel.org/oe-kbuild-all/202305261541.N165u9TZ-lkp@intel.com/
>> ---
>> V1 -> V2:
>>    * Fix minor bug reported by kernel test bot.
>>
>> ---
>>   net/sched/act_pedit.c | 48 ++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 43 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>> index fc945c7e4123..d28335519459 100644
>> --- a/net/sched/act_pedit.c
>> +++ b/net/sched/act_pedit.c
>> @@ -13,7 +13,10 @@
>>   #include <linux/rtnetlink.h>
>>   #include <linux/module.h>
>>   #include <linux/init.h>
>> +#include <linux/ip.h>
>> +#include <linux/ipv6.h>
>>   #include <linux/slab.h>
>> +#include <net/ipv6.h>
>>   #include <net/netlink.h>
>>   #include <net/pkt_sched.h>
>>   #include <linux/tc_act/tc_pedit.h>
>> @@ -327,28 +330,58 @@ static bool offset_valid(struct sk_buff *skb, 
>> int offset)
>>       return true;
>>   }
>> -static void pedit_skb_hdr_offset(struct sk_buff *skb,
>> +static int pedit_l4_skb_offset(struct sk_buff *skb, int *hoffset, 
>> const int header_type)
>> +{
>> +    int noff = skb_network_offset(skb);
>> +    struct iphdr *iph = NULL;
>> +    int ret = -EINVAL;
> 
> nit: Should be in reverse Christmas tree
> 

Sorry, I forgot to delete this comment. It's clearly in reverse 
Christmas tree.

>> +
>> +    switch (skb->protocol) {
>> +    case htons(ETH_P_IP):
>> +        if (!pskb_may_pull(skb, sizeof(*iph) + noff))
>> +            goto out;
> 
> I might have missed something but is this really needed?
> https://elixir.bootlin.com/linux/latest/source/net/ipv4/ip_input.c#L456
> 
>> +        iph = ip_hdr(skb);
>> +        *hoffset = noff + iph->ihl *  > +        ret = 0;
>> +        break;
>> +    case htons(ETH_P_IPV6):
>> +        *hoffset = 0;
> nit: Not needed
> 
>> +        ret = ipv6_find_hdr(skb, hoffset, header_type, NULL, NULL) == 
>> header_type ? 0 : -EINVAL;
>> +        break;
>> +    }
>> +out:
>> +    return ret;
>> +}
>> +
>> +static int pedit_skb_hdr_offset(struct sk_buff *skb,
>>                    enum pedit_header_type htype, int *hoffset)
>>   {
>> +    int ret = -EINVAL;
>>       /* 'htype' is validated in the netlink parsing */
>>       switch (htype) {
>>       case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
>> -        if (skb_mac_header_was_set(skb))
>> +        if (skb_mac_header_was_set(skb)) {
>>               *hoffset = skb_mac_offset(skb);
>> +            ret = 0;
>> +        }
>>           break;
>>       case TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK:
>>       case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
>>       case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
>>           *hoffset = skb_network_offset(skb);
>> +        ret = 0;
>>           break;
>>       case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
>> +        ret = pedit_l4_skb_offset(skb, hoffset, IPPROTO_TCP);
>> +        break;
>>       case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
>> -        if (skb_transport_header_was_set(skb))
>> -            *hoffset = skb_transport_offset(skb);
>> +        ret = pedit_l4_skb_offset(skb, hoffset, IPPROTO_UDP);
>>           break;
>>       default:
>> +        ret = -EINVAL;
> 
> nit: Not needed
> 
>>           break;
>>       }
>> +    return ret;
>>   }
>>   TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>> @@ -384,6 +417,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff 
>> *skb,
>>           int hoffset = 0;
>>           u32 *ptr, hdata;
>>           u32 val;
>> +        int rc;
>>           if (tkey_ex) {
>>               htype = tkey_ex->htype;
>> @@ -392,7 +426,11 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct 
>> sk_buff *skb,
>>               tkey_ex++;
>>           }
>> -        pedit_skb_hdr_offset(skb, htype, &hoffset);
>> +        rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
>> +        if (rc) {
>> +            pr_info_ratelimited("tc action pedit unable to extract 
>> header offset for header type (0x%x)\n", htype);
>> +            goto bad;
>> +        }
>>           if (tkey->offmask) {
>>               u8 *d, _d;
> 


