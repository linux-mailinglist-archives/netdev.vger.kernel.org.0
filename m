Return-Path: <netdev+bounces-11379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A49732D48
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 052701C20F97
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D267B18008;
	Fri, 16 Jun 2023 10:17:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C262A17FE7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:17:56 +0000 (UTC)
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCD130EA
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:17:52 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-570654fadf8so3953317b3.1
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686910672; x=1689502672;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ns2zKP2aKaHEiBKMq9rzFIhcIscoMwnFbCndVzO919w=;
        b=Ph8dMPXxjEWsEQyJCQuhwRQcAk0/3Sd3odAu4ZWnMRWlIjOfilfuFhmWrPUPoerKnq
         8ipcqBttf/+O805mZD++qK2xKqj+NpGb7IZyx+XXq/OoHv1Ome6xoX2pWi6XOU791ExR
         CZbRLJxZyNjS9Gce/PPTHmi2gOEu+2fUCgRL2ci90reDKSz1ocR1vWlQR7446z8jVqId
         JQVro8GPChoCFguGE/l3rjxhsqV7HuIpB4U/OiBHbexTG7uc8Kh7sIHltLjQTj9gOFAU
         ZoSfpYsxxgN7EqHzCfxeIM/fKy3J3ku2B7D4MYjOLj0vy4UP+tUGeIw7HOnUHnp6e9bi
         /tgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686910672; x=1689502672;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ns2zKP2aKaHEiBKMq9rzFIhcIscoMwnFbCndVzO919w=;
        b=FSYGPgO6MU6JQL4gKICE7U7p0Cv3Ez9NAT/A9sUUsaevnRVXd4AHM713EQq1dYFBGA
         g6Q24bcH1K1fIFsi4jUYHFzu7qWaA0nVM325DaBSe5NkBZ2ZPHicC8Z1u5rzCtLGpM7c
         l2htN6XFNzw47+EsFT7qSMOx8RQL7K9gRC+EXmszLgDwDbit1+JIOuE468f6cYXGyVne
         K8yxcfiixn2cI59iPNJd9CqwcUqvM7X22i497na7svv8BfOvzkPyCX4HYt+7fmJFpyTc
         rJe0c8aPhFnyuMfM0hJzTNJPIm6rIyJUX+9TcqkD1GC+1/DvXtriXCtoAo+TzS0JjUdP
         1NbQ==
X-Gm-Message-State: AC+VfDzeXtuLMxtvfpafrZ0X7JhvJQn31+NMJgB4aeRoRNsOVXwiA46Y
	LBM/kGPUu0GzQ5NTcPo5J5o=
X-Google-Smtp-Source: ACHHUZ7ERjNFprx3Hr19YGzwWeZN+MxLmPCJb3cxTvnam4CSKB3iwG5GPoqpIA46ypDpB9vPwcQTcQ==
X-Received: by 2002:a0d:d48b:0:b0:56d:2750:7c69 with SMTP id w133-20020a0dd48b000000b0056d27507c69mr1058372ywd.52.1686910671469;
        Fri, 16 Jun 2023 03:17:51 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:e5ff:b5f:79c3:16ef])
        by smtp.gmail.com with ESMTPSA id x189-20020a81a0c6000000b0055a92559260sm489708ywg.34.2023.06.16.03.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:17:51 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,
  donald.hunter@redhat.com
Subject: Re: [RFC net-next v1] tools: ynl: Add an strace rendering mode to
 ynl-gen
In-Reply-To: <20230615200036.393179ae@kernel.org> (Jakub Kicinski's message of
	"Thu, 15 Jun 2023 20:00:36 -0700")
Date: Fri, 16 Jun 2023 11:17:25 +0100
Message-ID: <m2o7lfhft6.fsf@gmail.com>
References: <20230615151336.77589-1-donald.hunter@gmail.com>
	<20230615200036.393179ae@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 15 Jun 2023 16:13:36 +0100 Donald Hunter wrote:
>> Add --mode strace to ynl-gen-c.py to generate source files for strace
>> that teach it to understand how to decode genetlink messages defined
>> in the spec. I successfully used this to add openvswitch message
>> decoding to strace as I described in:
>> 
>> https://donaldh.wtf/2023/06/teaching-strace-new-tricks/
>> 
>> It successfully generated ovs_datapath and ovs_vport but ovs_flow
>> needed manual fixes to fix code ordering and forward declarations.
>> 
>> Limitations:
>> 
>> - Uses a crude mechanism to try and emit functions in the right order
>>   which fails for ovs_flow
>
> What's the dependency? I pushed some stuff recently to try to order
> types more intelligently but for normal C netlink it still won't deal
> with cycles :(

For strace I need to emit attr decoder functions before referencing them
in dispatch tables. The crude mechanism I used was to emit decoders for
nested attributes first, which worked okay for e.g. ovs_vport. But
ovs_flow has I think at least 1 cycle.

> Actually I think that you're using raw family info rather than the
> codegen-focused structs, maybe that's why?

Yes, that's a fair point. I'm just walking through the declared
attribute-sets in the order defined in the schema. I can take a look at
what the codegen-focused structs provide.

>> - Outputs all strace sources to stdout or a single file
>> - Does not use the right semantic strace decoders for e.g. IP or MAC
>>   addresses because there is no schema information to say what the
>>   domain type is.
>
> The interpretation depends on another attribute or we expose things 
> as binary with no machine-readable indication if its IP addr or MAC etc?

Yeah, it's the lack of machine-readable indication. I'd suggest adding
something like 'format: ipv4-address' to the schema.

>> This seems like a useful tool to have as part of the ynl suite since
>> it lowers the cost of getting good strace support for new netlink
>> families. But I realise that the generated format is dependent on an
>> out of tree project. If there is interest in having this in-tree then
>> I can clean it up and address some of the limitations before
>> submission.
>
> I think it's fine, we'll have to cross this bridge sooner or later.
> I suspect we'll need to split ynl-gen-c once again (like the
> tools/net/ynl/lib/nlspec.py, maybe we need another layer for code 
> generators? nlcodegen or some such?) before we add codegen for more
> languages. I'm not sure you actually need that yet, maybe the strace
> generator needs just nlspec.py and it can be a separate script?

The strace generator uses CodeWriter and makes partial use of the Type*
classes as well. If we split those out of ynl-gen-c then it could be a
separate script. A first step could be to move all but main() into a
lib?

