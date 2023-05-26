Return-Path: <netdev+bounces-5570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 760ED7122B9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FEA328171E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF1A101D5;
	Fri, 26 May 2023 08:53:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8075FA938
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:53:46 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E2A12F
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 01:53:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96f7bf29550so69285166b.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 01:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685091221; x=1687683221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pEafYUjIZrUO4/yDXDHbyeAc8RGK6mxLSw92ZDg0E98=;
        b=cMaoJe+KgkTkY8scYWODsK1cfdAgjLokEXgEdvth9Gq2Fv7ibPJ66QjIX4p3XzvwZq
         ngs0vd+RvVSzgRSOOSq7sP1SrZ4kbCcoHhU/R2f7OXBaXPEkuXwDOSZtB4Mvd7oFTgVa
         0uEfh4/eS58Dq5pFo3Fs8z1i0kJb53eiVepdypmkNs/mA0UmP594DvY/6EXBqs46c89Z
         8WNK8SZNQcbhAKoEms9WB+o/f9Sf3FcamCQYMo4nZJgcdC0SmxHq786wmxBt54n7HYSS
         eGoE8CWM7vOeOZb9FNba2tBoOEYVBHamIzGKgIcL72WfPUr3zDfnYSNTij4L9P4Rs+Zv
         yUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685091221; x=1687683221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEafYUjIZrUO4/yDXDHbyeAc8RGK6mxLSw92ZDg0E98=;
        b=SpvfomW90hZ7lSf/XMyllIbBrIlnCR3xJZizaR8kxxMHP0wMF1YWO3fmPzY87rcVOX
         E0BvFCG46Tcb3iPir4MMfp7QUhM/NZx89fCo9Ugwo9JSgyQm5tzL01/4IF5dReNlFRu4
         rBQCF9ObKyCKRJFaz2IQ7Je2AJmoBgSVJiTMOjCDz0MMGqxbHDkrfPoOqzBSj+TnPmvT
         hX0FHbp+UZMJlThL+j/9M9qLgLPWj6DLQl5VmMcEyMsSUpXh4ks332BCEpbTMkCVvLor
         8ne9C7Wso4AqrVwvZvngZuXlm2YqQfgtPKA2/VZMrcZFg84myHKWmc5rR3xfU9Sx60+3
         BWUQ==
X-Gm-Message-State: AC+VfDyeDgAxg12xFjFtb1lP/bxc6w1gW2JcdL0c3SqjjpbO81/WX9FJ
	NE7vyaMxzY1IqU5QgVSECYqQSA==
X-Google-Smtp-Source: ACHHUZ5dPombVYh4C/BNg/HcfceqIzVNxzZcO3dZsHh5kVLeqU+yy04KeI7l2S3WKILw1ovwPAZoMg==
X-Received: by 2002:a17:907:1c28:b0:92f:33ca:c9a3 with SMTP id nc40-20020a1709071c2800b0092f33cac9a3mr1313532ejc.71.1685091220841;
        Fri, 26 May 2023 01:53:40 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id pg27-20020a170907205b00b009662d0e637esm1852949ejb.155.2023.05.26.01.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 01:53:40 -0700 (PDT)
Date: Fri, 26 May 2023 10:53:39 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next 15/15] devlink: save devlink_port_ops into a
 variable in devlink_port_function_validate()
Message-ID: <ZHBzk9qVqM4lq2Jf@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-16-jiri@resnulli.us>
 <20230524215535.6382e750@kernel.org>
 <ZG748Wu7Wtcc1doj@nanopsycho>
 <20230525082933.5196ae3d@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525082933.5196ae3d@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 25, 2023 at 05:29:33PM CEST, kuba@kernel.org wrote:
>On Thu, 25 May 2023 07:58:09 +0200 Jiri Pirko wrote:
>> >I was kinda expected last patch will remove the !ops checks.
>> >Another series comes after this to convert more drivers?  
>> 
>> Well, there are still drivers that don't use the port at all ops. I can
>> have them register with empty struct if you like, no strong opinition. I
>> can do that as follow-up (this set has 15 patches already anyway). Let
>> me know.
>
>Hm. Or maybe we can hook in an empty ops struct in the core when driver
>passes NULL? No strong preference.

Okay, will check, thx!

