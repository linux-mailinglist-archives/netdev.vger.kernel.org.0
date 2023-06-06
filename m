Return-Path: <netdev+bounces-8446-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 945C372415E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5208828167D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9201416420;
	Tue,  6 Jun 2023 11:57:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC715ACE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:57:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B44101
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686052653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLtk2HvpwpYDgBBKTR9dXYab2V7jDjQFQZOuQJsuY5o=;
	b=ACL4FF8jET7pwrxp6fFxlbkdFCsiSKEfbR3F9lQ7kR8a1E7YMfsp3hehWRn3iAHg7VC0QK
	FCRWoqF7XqnrI1B60ERDMhs/JoKDRrkPW3L9KPn2bjkuFAip+VL2qUnTjdgHj3p47p7Z3t
	kQlb5S3JBkbv/YH7c99PUVZwm2UAWR4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-h5p2U4N3N3G2M8iQW5ru2w-1; Tue, 06 Jun 2023 07:57:30 -0400
X-MC-Unique: h5p2U4N3N3G2M8iQW5ru2w-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-514b2ee9af2so3873152a12.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686052649; x=1688644649;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kLtk2HvpwpYDgBBKTR9dXYab2V7jDjQFQZOuQJsuY5o=;
        b=LLO4DCwLyfHkbQPoAEYFbGKv6dGrXn5H35suYWa0DA9ckUJdIf8HwzzLT0VwYJN7z6
         4zgUagAT1+4nw1X9D+hDfZWFYOawUzoipyw3Ajal3afFulkZDfDNjo23q+nEvCpgdXQB
         McbxxOlEF2C9fFPOjXqqub3HLTNU4UnNf3xVRGULII1c29E4dwMOCEhEMHxQOnhXIaB1
         g0F6pd/ud6PuATKumeG+brt/qmY+aPaXeWij8B2MuPwfAOdTAD3x/C2I9yHz+Vc8V+Oh
         drVEf0MvUcx+2Mk6FtzzTLax1pQNHrsaz+g4FlNoPjcCMa/I0fV6YliS4liOvFBLc9Oj
         vz/w==
X-Gm-Message-State: AC+VfDwtVPeOtwWb88MKdroNV41XfFdt7w5KHvoZf86m3adHKRSYERUB
	FGSPIuWWnv6C6zJttLX/5Pl2wE3YRxfLMQ+552ZJ66Ix5lB2/d/wfBpbUfwXSo6TbvtC2YWZ5y8
	XB8B0lHxVvQopFdTT
X-Received: by 2002:a17:907:3da1:b0:94f:7edf:8fa1 with SMTP id he33-20020a1709073da100b0094f7edf8fa1mr3268618ejc.32.1686052649123;
        Tue, 06 Jun 2023 04:57:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UOLHzuRbDX9QfP3+EOU6AiQy7e6ImTh+SvqkfLP2znOghDVXZZvl905yPuPNKWE7vAhf2cA==
X-Received: by 2002:a17:907:3da1:b0:94f:7edf:8fa1 with SMTP id he33-20020a1709073da100b0094f7edf8fa1mr3268587ejc.32.1686052648791;
        Tue, 06 Jun 2023 04:57:28 -0700 (PDT)
Received: from [10.39.193.50] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id a1-20020a1709066d4100b00974564fa7easm5477979ejt.5.2023.06.06.04.57.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Jun 2023 04:57:27 -0700 (PDT)
From: Eelco Chaudron <echaudro@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>, Simon Horman <simon.horman@corigine.com>,
 dev@openvswitch.org, netdev@vger.kernel.org, edumazet@google.com,
 kuba@kernel.org, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: fix upcall counter access
 before allocation
Date: Tue, 06 Jun 2023 13:57:27 +0200
X-Mailer: MailMate (1.14r5964)
Message-ID: <A43D904A-FAF2-411E-8B81-FADF192A163A@redhat.com>
In-Reply-To: <21755d7f0d8bb51f748e65dde09986665c439341.camel@redhat.com>
References: <168595558535.1618839.4634246126873842766.stgit@ebuild>
 <ZH3X/lLNwfAIZfdq@corigine.com>
 <FD16AC44-E1DA-4E6A-AE3E-905D55AB1A7D@redhat.com>
 <ZH3eCENbZeSJ3MZS@corigine.com>
 <69E863E6-89C0-4AC7-85F1-022451CAD41A@redhat.com>
 <ZH3zUdkxvxgaYjxf@kernel.org>
 <21755d7f0d8bb51f748e65dde09986665c439341.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6 Jun 2023, at 13:43, Paolo Abeni wrote:

> On Mon, 2023-06-05 at 16:38 +0200, Simon Horman wrote:
>> On Mon, Jun 05, 2023 at 03:53:59PM +0200, Eelco Chaudron wrote:
>>>> Yeah, I see that. And I might have done the same thing.
>>>> But, OTOH, this change is making the error path more complex
>>>> (or at least more prone to error).
>>>>
>>>> In any case, the fix looks good.
>>>
>>> Thanks, just to clarify if we get no further feedback on this
>>> patch, do you prefer a v2 with the error path changes?
>>
>> Thanks Eelco,
>>
>> Yes, that is my preference.
>
> I concur with Simon: Eelco, please post a v2 including the error path
> changes.

Our mails crossed, patch should be in your inbox ;)

//Eelco


