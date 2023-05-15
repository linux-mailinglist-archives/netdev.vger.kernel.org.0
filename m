Return-Path: <netdev+bounces-2679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC1B703103
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5FED28137F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6041DD516;
	Mon, 15 May 2023 15:07:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F98DC8E5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:07:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F672137
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684163247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jqAunJggVfMk8DVsWWYkCIQsfbXlahXMSDO8JBjiKzE=;
	b=W8SGczOTxqx7AlFLKkDrWcLea6O7FflZEgKN9/OsGbSp+4WDkK5/HDq10Dt0hDAd0rUuAB
	AViVexbfrBou4la1PaMVmA7ca+pr2PNW7HhHwiypmleiE5TGiTqrtaXwK+7XW4Z2RoEpMK
	vRrYJuM/Qkg0aPKEUpL53wjrXRdOTfM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-RQK420pFNUivajiie0VzMQ-1; Mon, 15 May 2023 11:07:23 -0400
X-MC-Unique: RQK420pFNUivajiie0VzMQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a348facbbso1607738366b.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:07:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684163242; x=1686755242;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqAunJggVfMk8DVsWWYkCIQsfbXlahXMSDO8JBjiKzE=;
        b=Zqw2KHFiZEofxkfsjHQ8LkXL9jst9dX44YUkEoNh5BVKUtOe7CATn51GDxDI6P9h4V
         E0NAEGZ0oXjyjlDspoiotm3AVFsUp0RXo5DW/NsKGtwcZ02bqHi1y4jQ/r3SSOX8H/ap
         W3Hrhp0n95j2tv5tvFmkm3R+bsYBikeV9F1/4erkuT/wlQYDYCkoIUUxM+s11pT6K22H
         uHF19QWigdUr6rOBeNkQIzPxaQWN87cBLhSMyfRquH9yxgFEtNqdar6WKyVt7VM65and
         DsCBPUIaTL2F4gBDf0bC8xSjlOFsJM8GMjFpLH+6JWPJqe/l4TSxJh3BILf+vLoSvcv1
         ISbw==
X-Gm-Message-State: AC+VfDzimDjORZnIk/0c277YNUgp9fMJTwZnazpnrfwwBYNbVNW+2qJN
	KUAgYiDIenuv7ydk+8scW9vV9lWQEYKl8SG2FcdJUWkgX3si1OkaWqRWFFNTD3H5GyiBlLm7dbF
	fNwISv/pCCNC0YExY
X-Received: by 2002:a17:907:d91:b0:933:4d37:82b2 with SMTP id go17-20020a1709070d9100b009334d3782b2mr31485025ejc.57.1684163242608;
        Mon, 15 May 2023 08:07:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4KJfmiDaL9BJh3jJxYB1OG8NuTPCjYqSvJHsOpWGNg4A0jTsW7kReLmT9LoGqXUg8hKEYa+Q==
X-Received: by 2002:a17:907:d91:b0:933:4d37:82b2 with SMTP id go17-20020a1709070d9100b009334d3782b2mr31484980ejc.57.1684163242248;
        Mon, 15 May 2023 08:07:22 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id l17-20020a170907915100b0095004c87676sm9682583ejs.199.2023.05.15.08.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 08:07:21 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e4a9fa43-06f7-5271-effc-20cac59b0e64@redhat.com>
Date: Mon, 15 May 2023 17:07:19 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, bpf@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>,
 KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Anatoly Burakov <anatoly.burakov@intel.com>,
 Alexander Lobakin <alexandr.lobakin@intel.com>,
 Magnus Karlsson <magnus.karlsson@gmail.com>,
 Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
 netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND bpf-next 10/15] ice: Implement VLAN tag hint
To: Larysa Zaremba <larysa.zaremba@intel.com>,
 Stanislav Fomichev <sdf@google.com>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-11-larysa.zaremba@intel.com>
 <ZF6F+UQlXA9REqag@google.com> <ZGI2oDcWX+o9Ea0T@lincoln>
Content-Language: en-US
In-Reply-To: <ZGI2oDcWX+o9Ea0T@lincoln>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 15/05/2023 15.41, Larysa Zaremba wrote:
>>> +	*vlan_tag = ice_get_vlan_tag_from_rx_desc(xdp_ext->eop_desc);
>> Should we also do the following:
>>
>> if (!*vlan_tag)
>> 	return -ENODATA;
>>
>> ?
> Oh, returning VLAN tag with zero value really made sense to me at the beginning,
> but after playing with different kinds of packets, I think returning error makes
> more sense. Will change.
> 

IIRC then VLAN tag zero is also a valid id, right?

--Jesper


