Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9006CCC15
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjC1VZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjC1VZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:25:27 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6707AB
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:25:26 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id k14-20020a9d700e000000b0069faa923e7eso7152184otj.10
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680038726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2f8hucDit7h7FBloP40BZWlgu1O9b6k0F5rMuLUKMs4=;
        b=n1RheqOA6mDA3uj2qB9QjA1SNm5LDXUv8sAVj4YYNQd+fLLm+diA1pd3gnpbBlQ8Po
         gegMYd5G7KOJj06XjmVIoolzJEFesznBlAM16Z2RqnDzEVsvKSlHtFOcZ99YLfT4kNr3
         CO2D3mr5P9m7HFCiXrgPZRYOR4vUOw8cx+skv7HzCQYvYP0ts0Eb4O4tQ+mB8sxCyfS9
         2e9/w9s5WYcUjEYHV7us6TaHW9Vm0vzba5g/25VkgA2R3xKEhHHHedgoVT5PByDnqrmi
         A/vMSyMtG5a03+ynwxuB2kHWI2GmzWk7ZWBuOmcIU3KtWnA8MDyZXrvnbuRmVTiI1n0Y
         j/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680038726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2f8hucDit7h7FBloP40BZWlgu1O9b6k0F5rMuLUKMs4=;
        b=OBcfxgh5UvhSJD3EfqyVhoa7+/1Hz/0p2XB5OEK4SdId1z9Im7/0bpFE1u9nEdadnU
         R/tyQvpu3IL05Z5ZSE/UzgdEoqKRKwOBioLGcIGGsHrwzgzVdMVDyC2UTBOi/qMw3mv9
         DKkTAMpZHISgIQqVK0H0WI8Xl6DIs6vSJwEcnt5S0VdSrFE/Ggq5u2CKPJrMv+4S1Rs7
         t5GT0uD7Q26oacoFYILPFj08Igt+zeir9BiMvvF0fRDJIahdplv3zLoeGTcxZUbCONS/
         sjbMO1RgQ2RkDd3fgeIYVzFNWwbPoQqslkrj/XxGU3z3HHUgWZGPi+ZrCaf2tCQx7Y6g
         GYzw==
X-Gm-Message-State: AO0yUKU8H++o2lP4CsgKa/iNc2whyHtdb0i1/OCp9GutveDrVuZGsdid
        vaF+aiZR9fUlsEEVsBhxMUi6vAnAsyZGTJaLXkg=
X-Google-Smtp-Source: AK7set/lm35ArUSSy/2TOhTUMKNZRMsiLyuPaUOSjSXeS/4q4Qco3bNqmnguKd3W3oDE0CUhgNJj6Q==
X-Received: by 2002:a9d:740f:0:b0:69f:8f09:ed44 with SMTP id n15-20020a9d740f000000b0069f8f09ed44mr8304513otk.37.1680038726137;
        Tue, 28 Mar 2023 14:25:26 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:7010:5bd:70ea:a1f8? ([2804:14d:5c5e:4698:7010:5bd:70ea:a1f8])
        by smtp.gmail.com with ESMTPSA id j1-20020a9d7381000000b006a1287ccce6sm3853883otk.31.2023.03.28.14.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 14:25:25 -0700 (PDT)
Message-ID: <b98879d1-f9d1-e552-8fb7-ef2b3e7f8443@mojatatu.com>
Date:   Tue, 28 Mar 2023 18:25:22 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 1/4] net/sched: act_tunnel_key: add support
 for "don't fragment"
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1680021219.git.dcaratti@redhat.com>
 <579a1d30c2d8b417dcc19784cc27b87bab631b27.1680021219.git.dcaratti@redhat.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <579a1d30c2d8b417dcc19784cc27b87bab631b27.1680021219.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2023 13:45, Davide Caratti wrote:
> extend "act_tunnel_key" to allow specifying TUNNEL_DONT_FRAGMENT.
> 
> Suggested-by: Ilya Maximets <i.maximets@ovn.org>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>   include/uapi/linux/tc_act/tc_tunnel_key.h | 1 +
>   net/sched/act_tunnel_key.c                | 5 +++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
> index 49ad4033951b..37c6f612f161 100644
> --- a/include/uapi/linux/tc_act/tc_tunnel_key.h
> +++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
> @@ -34,6 +34,7 @@ enum {
>   					 */
>   	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
>   	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
> +	TCA_TUNNEL_KEY_NO_FRAG,		/* flag */
>   	__TCA_TUNNEL_KEY_MAX,
>   };
>   
> diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
> index 2d12d2626415..0c8aa7e686ea 100644
> --- a/net/sched/act_tunnel_key.c
> +++ b/net/sched/act_tunnel_key.c
> @@ -420,6 +420,9 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
>   		    nla_get_u8(tb[TCA_TUNNEL_KEY_NO_CSUM]))
>   			flags &= ~TUNNEL_CSUM;
>   
> +		if (nla_get_flag(tb[TCA_TUNNEL_KEY_NO_FRAG]))
> +			flags |= TUNNEL_DONT_FRAGMENT;
> +
>   		if (tb[TCA_TUNNEL_KEY_ENC_DST_PORT])
>   			dst_port = nla_get_be16(tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
>   
> @@ -747,6 +750,8 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
>   				   key->tp_dst)) ||
>   		    nla_put_u8(skb, TCA_TUNNEL_KEY_NO_CSUM,
>   			       !(key->tun_flags & TUNNEL_CSUM)) ||
> +		    ((key->tun_flags & TUNNEL_DONT_FRAGMENT) &&
> +		     nla_put_flag(skb, TCA_TUNNEL_KEY_NO_FRAG)) ||
>   		    tunnel_key_opts_dump(skb, info))
>   			goto nla_put_failure;
>   

LGTM,

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
