Return-Path: <netdev+bounces-4675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D55F70DD22
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0AB728130B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83FD1D2BA;
	Tue, 23 May 2023 13:03:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD6C4A84C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:03:26 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3037E109
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:03:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-96f5685f902so779828766b.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684847001; x=1687439001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MtuLbrEh7BlwROWf1pslTcmB5/eMhxKXbbO35Rej/2A=;
        b=BSWx4ZvSHeFN3DVRK4aPNDwO3q2sJVjboIeFA/r8O6w07EFv30YTG8Ynp68+I/WQkf
         Gx4xRUGOb+SO4u1QHszLxatyHvrZD438hI4gXE7lcpVAm2BI5LbyNcZatltsTqYW+jcq
         oWoMSihVGsRBUobDkxJDyscUSCJEyoW/9SP50bOwqwpmTa9WIKDBQnezE7aRfBysAtP1
         NQit3JYQOZZW9DCgm1dcH+o5QGEr7MnfXFPTU/B5uymQhfnZjNu3JrjTQnLOCX8R+Q6V
         GaCb0fz4aJT5gXbJ5kF/EfYQXqbLT976Fmt6x7g1x/cXO0T7yhxyr5gra9vpcTrsGtyt
         kgsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684847001; x=1687439001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MtuLbrEh7BlwROWf1pslTcmB5/eMhxKXbbO35Rej/2A=;
        b=eoQ56o2fzaCvASx+vU9DSqRPFFms6JvNU4oc+USqHm1l9iJoW8rLjkrd4q4AFEeL7N
         m/5SSF4bofjpKmbihrFwBSRAWgZWRfzb5YOYD6GfyR/0IMgTMOupK5G2xcrwlmax/2E2
         yRvBCUIMd00FqKGYBr9Hz/dDFa0AfDveTl5XNHbl8r4SlEziKdlyU76NBtXaxcAJehIH
         1+0LrAe70Ni9H5b7i4aDOi/j+B3pSYRijyOUOTPISihCY2f8cJzabYuM5EpJyglbEgRh
         gIv65epdPrzU6q6qKG723QvBpvRi4jd0fQW4vudRzNbcp84bRhFwykO92i3yLKO13dr8
         Gz/A==
X-Gm-Message-State: AC+VfDxvN4BMuxdOeOXG2WEnatoKSJbYhAHoxiWIoU2/7WdCGEvD9qE1
	jeb3GtcrRvXKm7xZKzXXMf/vVQ==
X-Google-Smtp-Source: ACHHUZ4TM2+jJWPiQWnVqP6sHyysYTXw5utnGRNkKZNR7bYEokjBnoKce0h6jbNMYg5uPTwtgkq0Vw==
X-Received: by 2002:a17:906:eec8:b0:94f:8605:3f31 with SMTP id wu8-20020a170906eec800b0094f86053f31mr14251281ejb.42.1684847001390;
        Tue, 23 May 2023 06:03:21 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id gx1-20020a1709068a4100b0096ae4451c65sm4362589ejc.157.2023.05.23.06.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 06:03:20 -0700 (PDT)
Message-ID: <af356b89-ff7f-a562-2859-e8edeae5f23c@blackwall.org>
Date: Tue, 23 May 2023 16:03:19 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/5] skbuff: bridge: Add layer 2 miss indication
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 roopa@nvidia.com, taras.chornyi@plvision.eu, saeedm@nvidia.com,
 leon@kernel.org, petrm@nvidia.com, vladimir.oltean@nxp.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
 UNGLinuxDriver@microchip.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, taspelund@nvidia.com
References: <20230518113328.1952135-1-idosch@nvidia.com>
 <20230518113328.1952135-2-idosch@nvidia.com>
 <1ed139d5-6cb9-90c7-323c-22cf916e96a0@blackwall.org>
 <ZGd+9CUBM+eWG5FR@shredder> <20230519145218.659b0104@kernel.org>
 <ZGx0/hwPmFFN2ivS@shredder>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZGx0/hwPmFFN2ivS@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 23/05/2023 11:10, Ido Schimmel wrote:
> On Fri, May 19, 2023 at 02:52:18PM -0700, Jakub Kicinski wrote:
>> On Fri, 19 May 2023 16:51:48 +0300 Ido Schimmel wrote:
>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>> index fc17b9fd93e6..274e55455b15 100644
>>> --- a/net/bridge/br_input.c
>>> +++ b/net/bridge/br_input.c
>>> @@ -46,6 +46,8 @@ static int br_pass_frame_up(struct sk_buff *skb)
>>>          */
>>>         br_switchdev_frame_unmark(skb);
>>>  
>>> +       skb->l2_miss = BR_INPUT_SKB_CB(skb)->miss;
>>> +
>>>         /* Bridge is just like any other port.  Make sure the
>>>          * packet is allowed except in promisc mode when someone
>>>          * may be running packet capture.
>>>
>>> Ran these changes through the selftest and it seems to work.
>>
>> Can we possibly put the new field at the end of the CB and then have TC
>> look at it in the CB? We already do a bit of such CB juggling in strp
>> (first member of struct sk_skb_cb).
> 
> Using the CB between different layers is very fragile and I would like
> to avoid it. Note that the skb can pass various layers until hitting the
> classifier, each of which can decide to memset() the CB.
> 
> Anyway, I think I have a better alternative. I added the 'l2_miss' bit
> to the tc skb extension and adjusted the bridge to mark packets via this
> extension. The entire thing is protected by the existing 'tc_skb_ext_tc'
> static key, so overhead is kept to a minimum when feature is disabled.
> Extended flower to enable / disable this key when filters that match on
> 'l2_miss' are added / removed.
> 
> bridge change to mark the packet:
> https://github.com/idosch/linux/commit/3fab206492fcad9177f2340680f02ced1b9a0dec.patch
> 
> flow_dissector change to dissect the info from the extension:
> https://github.com/idosch/linux/commit/1533c078b02586547817a4e63989a0db62aa5315.patch
> 
> flower change to enable / disable the key:
> https://github.com/idosch/linux/commit/cf84b277511ec80fe565c41271abc6b2e2f629af.patch
> 
> Advantages compared to the previous approach are that we do not need a
> new bit in the skb and that overhead is kept to a minimum when feature
> is disabled. Disadvantage is that overhead is higher when feature is
> enabled.
> 
> WDYT?
> 
> To be clear, merely asking for feedback on the general approach, not
> code review.
> 
> Thanks

TBH, I like this approach much better for obvious reasons. :)
Thanks for working on it.

