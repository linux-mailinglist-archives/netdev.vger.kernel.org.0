Return-Path: <netdev+bounces-274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF65D6F6AB6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 180A31C210DE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550EFFC09;
	Thu,  4 May 2023 12:01:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4783CFBE9
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:01:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9F6186
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 05:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683201678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIKjcXbXt4J8uhPw59CYqy1sDmbjD4HLo3LB8qW0Zt4=;
	b=eol87j54zstNM5djt8y1LI/tenxLO8KWiaYiuYQmiysRKihyezp7QRULIYaC3wMnnV8uQs
	X08JPFMAN1r503svR2HXsJ8iGfMrrcHpgFNcX/rfXdUrgNKsVORVX/LBbMsUNuoj/yjTJ0
	7+GJR4BYZyCszVGGzx+Yu6nkibJOJqU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-QqVwdRLkM8eBCEU-UPmPlg-1; Thu, 04 May 2023 08:01:16 -0400
X-MC-Unique: QqVwdRLkM8eBCEU-UPmPlg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-61b5af37298so2475826d6.2
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 05:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683201676; x=1685793676;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gIKjcXbXt4J8uhPw59CYqy1sDmbjD4HLo3LB8qW0Zt4=;
        b=VndxTuwBGWdJrjhKtmG43PnSUCHizWXY/k1Xvtk2YBi4nWIYajfYKdQfAthxSu9XTy
         U1eYhHqpLNa7TlHljASdddUjvw9rcsFmFPrZZhfO8oJMZduoHMn5RAU1xvJsCPoBflyo
         C0ag0Tdc8rBf0YqMmFSXmDQWi68o7FpAs9xOxb/Sw30kl48zGBc+CQA30DnCXcK6ZVdK
         nCbqiqOM1l5lxMLqmhOtYIxn9ZCZ4nImyYmEbk+0inDpTKuYFbzz3sTY14I0bp5Z7tCe
         DMRyDFQcF3HIuBtw+u9lH/Iv+aKoJwHo+mp7CXX164Sra/1MNKTZuzvqGqHK1VIiyZab
         FrTw==
X-Gm-Message-State: AC+VfDzrghs6lfEiMu/Nj8XA0mihMEboiWx9A6r7C+1WzCgQLu2jkrp0
	wdzEAx930Slldj/TcWPkYeLDlEWCsXSh2+lUyC5af41tImhtYEAYg2s4Z8CCeL8r4Od/cCXNyrI
	t+pheaIJLU3cPUVcE
X-Received: by 2002:a05:6214:246a:b0:5e0:ad80:6846 with SMTP id im10-20020a056214246a00b005e0ad806846mr15121478qvb.0.1683201675944;
        Thu, 04 May 2023 05:01:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6zCd37cGrYnqLsDvIDNom+W3hrB0fw7HXsoSUmBoJMxEocsUb+eLYvdoPE0p7kosvipZum3Q==
X-Received: by 2002:a05:6214:246a:b0:5e0:ad80:6846 with SMTP id im10-20020a056214246a00b005e0ad806846mr15121443qvb.0.1683201675672;
        Thu, 04 May 2023 05:01:15 -0700 (PDT)
Received: from [192.168.2.12] (bras-base-toroon01zb3-grc-50-142-115-133-205.dsl.bell.ca. [142.115.133.205])
        by smtp.gmail.com with ESMTPSA id w14-20020a0ce10e000000b005e37909a7fcsm11396142qvk.13.2023.05.04.05.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 05:01:15 -0700 (PDT)
Message-ID: <3486407a-a357-5194-300d-d646c2fc5bf8@redhat.com>
Date: Thu, 4 May 2023 08:01:13 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2-next] rdma: Report device protocol
Content-Language: en-US
To: Leon Romanovsky <leonro@nvidia.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20230503210342.66155-1-kheib@redhat.com>
 <20230504074842.GR525452@unreal>
From: Kamal Heib <kheib@redhat.com>
In-Reply-To: <20230504074842.GR525452@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-04 03:48, Leon Romanovsky wrote:
> On Wed, May 03, 2023 at 05:03:42PM -0400, Kamal Heib wrote:
>> Add support for reporting the device protocol.
>>
>> $ rdma dev
>> 11: mlx5_0: node_type ca proto roce fw 12.28.2006
>>      node_guid 248a:0703:004b:f094 sys_image_guid 248a:0703:004b:f094
>> 12: mlx5_1: node_type ca proto ib fw 12.28.2006
>>      node_guid 248a:0703:0049:d4f0 sys_image_guid 248a:0703:0049:d4f0
>> 13: mlx5_2: node_type ca proto ib fw 12.28.2006
>>      node_guid 248a:0703:0049:d4f1 sys_image_guid 248a:0703:0049:d4f0
>> 17: siw0: node_type rnic proto iw node_guid
>>      0200:00ff:fe00:0000 sys_image_guid 0200:00ff:fe00:0000
>>
>> Signed-off-by: Kamal Heib <kheib@redhat.com>
>> ---
>>   rdma/dev.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/rdma/dev.c b/rdma/dev.c
>> index c684dde4a56f..04c2a574405c 100644
>> --- a/rdma/dev.c
>> +++ b/rdma/dev.c
>> @@ -189,6 +189,16 @@ static void dev_print_node_type(struct rd *rd, struct nlattr **tb)
>>   			   node_str);
>>   }
>>   
>> +static void dev_print_dev_proto(struct rd *rd, struct nlattr **tb)
>> +{
>> +       const char *str;
>> +       if (!tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL])
>> +               return;
>> +
>> +       str = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL]);
>> +       print_color_string(PRINT_ANY, COLOR_NONE, "proto", "proto %s ", str);
> 
> Please, let's use full word "protocol" and not "proto".
> 
> Other than that,
> Acked-by: Leon Romanovsky <leonro@nvidia.com>
> 

Thank you for reviewing the patch, I'll fix it in v2.


