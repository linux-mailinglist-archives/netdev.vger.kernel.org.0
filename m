Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21B36A4D41
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjB0VeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjB0VeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:34:04 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643A4244BE
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 13:33:52 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so4685625wmq.2
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 13:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FCdn25CV8GDo6ZiXgTzmM3w/pIq1dlF5W0CjOEtKRUE=;
        b=XRQAyO5nXVQy1zDCDLbaU02j3HQEVLNFV/DFS00WMN18MsC1shhNM2WcgGrZqo50QD
         9IzD1N/y0IOAXCrajGFxEGOpbbuZ1RD02w3PDQsaYmMYic3Uu8dbK8XxH1KNcXG0M2wu
         xO3gvnX9mKTZZ7/6spcGqJAzasgw4K/YJwKybXlwXAhEzx+bimEdF1qqsA+dy8BFJm4E
         CDfBlITyAgILL3lJZfUWm8ckgeMpG+WitJd174H1kaw98w16NJGVO2UjE/SOq2UVr9wj
         wLkdR7N3xpd0E6AEG8BYJWNc9NDtpMlrD/TrSfPn2FevuvqevcNrYsww06o5zLF4+Dma
         SqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCdn25CV8GDo6ZiXgTzmM3w/pIq1dlF5W0CjOEtKRUE=;
        b=ZeaIXoz7u53CX5/rdKU7dowKLoh3W6ZKJgNAiMlaTMRMso+1W/kuIz23XeAb6WSNWP
         ZjxSqLg+rouu+6psMe+05WN2nd7o37KU7s/SQeT3VWUjFkYIG4akfhCMWi6yX2w0YmYi
         AZwpYm9+f3CcZrB8lzrmd0of5C4eeLgI46auecPfJux8Lny+kYqJ6gc969d8C/vUOFgq
         NriWbO57ZcbMOiajWLr4pD5vGdYcHO1HfEz1acn14Ew46xUapBhFzmjHXnWymwIhRirg
         avxW5REwkQeVq0Yv0IcAkCGllAHO97vKTk9JBfE+fKgLr4n+ej7HhllQ1y/hWAQBf/lr
         WApA==
X-Gm-Message-State: AO0yUKVHTqQbkvhmYocYT/T8/pnGQA80u1ZkDwtChPCC0f4oXJBcE9Zj
        p/eWkHzSzvdZj/3lofLolFo=
X-Google-Smtp-Source: AK7set8jwTlDHIJGrFytsuegvLGhiaIS0HWPNAc2Yr6pCl8u1fux/CvzR0OR/7Umcsv/cinupBlCnA==
X-Received: by 2002:a05:600c:3583:b0:3eb:399d:ab1d with SMTP id p3-20020a05600c358300b003eb399dab1dmr414722wmq.16.1677533630654;
        Mon, 27 Feb 2023 13:33:50 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id y7-20020a05600c364700b003e2096da239sm14017713wmq.7.2023.02.27.13.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 13:33:50 -0800 (PST)
Subject: Re: [RFC PATCH v2 net-next] sfc: support offloading TC VLAN push/pop
 actions to the MAE
To:     Simon Horman <simon.horman@corigine.com>, edward.cree@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        habetsm.xilinx@gmail.com, leon@kernel.org
References: <20230223235026.26066-1-edward.cree@amd.com>
 <Y/iMTcvQZ3uW8bgP@corigine.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a35e32a0-0520-ce60-5296-39f36b278b5a@gmail.com>
Date:   Mon, 27 Feb 2023 21:33:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Y/iMTcvQZ3uW8bgP@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 24/02/2023 10:07, Simon Horman wrote:
> On Thu, Feb 23, 2023 at 11:50:26PM +0000, edward.cree@amd.com wrote:
>> +				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pops, or action order violated");
> 
> nit: I'm not sure if there is anything to be done about it,
>      but checkpatch complains about ling lines here...

Yeah I don't think these can be helped.  Breaking up the
 containing function (to reduce indent depth) would be
 rather synthetic imho, most of it wouldn't even be able
 to be shared with the decap and conntrack versions when
 those get added.)

>> +			}
>> +			tci = fa->vlan.vid & 0x0fff;
>> +			tci |= fa->vlan.prio << 13;
> 
> nit: Maybe VLAN_PRIO_SHIFT and VLAN_VID_MASK can be used here.

Yep good suggestion, incorporated for v3.
Thanks for the review.

-ed
