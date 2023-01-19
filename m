Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC5673DBD
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjASPlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 10:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjASPlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:41:10 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A982D49
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:41:06 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id v6so1355569ilq.3
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gSSOQskD/AkpH0uPrIu2pRrWtcPSEV9Ia7pug4zz08o=;
        b=RJUcwFEb9Wi94yy7SE8xTVfLtxlJWYwPISVs5GSShQ3KQ19lcF+fi5VJo+owS28HLM
         EovhhVCMqiqCnKnJF1F9nMpHuTN5cUuJtxA+T34nMo/6pS/WI3gmTc9klNWw+ncOM/9x
         H26bcrZo876cHBGhng5IGrjKVVOab4IMQiiJXwOTSRSz716VrzHRxSdzHgOWiHdhLic4
         V7nMDKsv6TKFUrDb5xVxim0Ti/rw4/AODrP0XQlX2zsGCicAup5b5e4JTyA/dmRqTA/p
         DsD8zB5UzJdEby8Yg3i8KIWuhf8fXRJCGDFX/S7eEgdviX3PpSteC3Szb+phz3Qw4800
         Qw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSSOQskD/AkpH0uPrIu2pRrWtcPSEV9Ia7pug4zz08o=;
        b=jwfaWOvrZSfcT28VD1m4M+nrC1wScvtrxXEkvlgAeF5vmqrG4rBsHKhWneVDciUq0O
         zrc3TjHoya6LELbmFe9+MgIeqEvEEsWN7uQyiSz+lpCUVBxgFBmzt183h8clmvepmIBw
         /A6ngE5o0VG/m/hFY7zVPQtPoe4xQNeoSEDrIp8U5/NiaXovtRahYu4hzez5B6K/+6g1
         uyI0tuOuV6j+5gKTLqaQhV4BV0fUE99KrcmMuw0d1ot5Dssiit6yE9WAGMKAdBQ8j99t
         P0TMvCD/xtGyzK2Wj1aN1HItmN/O/D2vGA2d4TUS9BU2f03vopuJmnR5BBRfGKXi99OV
         X2lA==
X-Gm-Message-State: AFqh2kqyv+7Q5xKX71K0HQD8mCZn8BGKvPlnPjV/Qb2S4y4m60rvSY7/
        Vf6Ckikv7rMzhdyqyvDWWcU=
X-Google-Smtp-Source: AMrXdXuin1mrHmajHEUaJ4hLXTaoBWERsKB8PcPMy+rqLpKw8mwjp7t1siBn4gy1fY6TbAf5YBmdaA==
X-Received: by 2002:a92:4a06:0:b0:30e:f03e:a764 with SMTP id m6-20020a924a06000000b0030ef03ea764mr9049582ilf.6.1674142866174;
        Thu, 19 Jan 2023 07:41:06 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:699e:d9ba:5690:9eaa? ([2601:282:800:7ed0:699e:d9ba:5690:9eaa])
        by smtp.googlemail.com with ESMTPSA id c14-20020a92d3ce000000b0030dbef81995sm7306646ilh.57.2023.01.19.07.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 07:41:05 -0800 (PST)
Message-ID: <65c32f21-ab74-5863-4d65-b87543f8aa89@gmail.com>
Date:   Thu, 19 Jan 2023 08:41:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in
 length_mt6
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>, Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
 <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com>
 <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com>
 <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
 <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
 <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com>
 <CADvbK_emHO8NjNxJdBueED9pAkoTo1girB5myyt-c1SjYxEtrQ@mail.gmail.com>
 <CADvbK_dQUpDa5oCo-o5DkKNY498gWwsan+RTpb9yTrg7DNRc+g@mail.gmail.com>
 <CANn89i++s3jhHqsyJT50FePT=icx3_FiYGqJNwQ73a1wt2+m+Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89i++s3jhHqsyJT50FePT=icx3_FiYGqJNwQ73a1wt2+m+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/23 8:13 PM, Eric Dumazet wrote:
> On Thu, Jan 19, 2023 at 2:19 AM Xin Long <lucien.xin@gmail.com> wrote:
> 
>> I think that IPv6 BIG TCP has a similar problem, below is the tcpdump in
>> my env (RHEL-8), and it breaks too:
>>
>> 19:43:59.964272 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
>> 19:43:59.964282 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
>> 19:43:59.964292 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
>> 19:43:59.964300 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
>> 19:43:59.964308 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
>>
> 
> Please make sure to use a not too old tcpdump.
> 
>> it doesn't show what we want from the TCP header either.
>>
>> For the latest tcpdump on upstream, it can display headers well for
>> IPv6 BIG TCP. But we can't expect all systems to use the tcpdump
>> that supports HBH parsing.
> 
> User error. If an admin wants to diagnose TCP potential issues, it should use
> a correct version.

Both of those just fall under "if you want a new feature, update your
tools."


> 
>>
>> For IPv4 BIG TCP, it's just a CFLAGS change to support it in "tcpdump,"
>> and 'tshark' even supports it by default.
> 
> Not with privacy _requirements_, where only the headers are captured.
> 
> I am keeping a NACK, until you make sure you do not break this
> important feature.

I think the request here is to keep the snaplen in place (e.g., to make
only headers visible to userspace) while also returning the >64kB packet
length as meta data.

My last pass on the packet socket code suggests this is possible;
someone (Xin) needs to work through the details.

