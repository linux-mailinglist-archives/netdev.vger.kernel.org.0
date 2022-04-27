Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5BC512588
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiD0WwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiD0WwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:52:00 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0D289CEA
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:48:46 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x17so5563844lfa.10
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SQk+uPdXjus9l+tZCRcT7jspmYgklYtunIPDK1R0FPo=;
        b=4be664J+OKOeBO0o8b8/lSmk7jn8HmLIxoeRFfTKVZp/qfcuXsj0nn0H7AsnMzYhl1
         ES/5EofZCQG+lU25D5qAXkc8AWQpCGUfz9nDBy6CFgdN3kWmzPKWPX3ouImm0xjv8Hot
         Q1nLzcRXHoGKjZZq2Ugu0RFU8yN4C0APkgUeDUB6KrZ1trEszX9xLoTyIm2bJLDwMNdk
         N7W3FgisFjh7vg/mDxMWbdPH84tzDYTOBZqlPWxH+fPixhU1X26YGN658TZN77CaspzE
         6acX8xvHwftaEXxYqp5UMxc8oAGQBmwZm+vxqUqGmkQKqvGDa+d8noiqD3E455dFClQ1
         3Wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SQk+uPdXjus9l+tZCRcT7jspmYgklYtunIPDK1R0FPo=;
        b=qK5LzIiVvPAPZRbkUwjISb2N61/umNR4Fv9mB/Sjl27HbW3FXN/Hkw+BUb8epifXkx
         +s8EA35xxOWKtx8eF4+WmN2SKfCLpSy3Xc7mnooikYb5YrNEvcpe+aXhFJklZah4EtDa
         d3n/bxH2VXYLDBM2XLNiTtKTGrvksaB1uHS0G+4Gl0rngi7vPLei37WAbf86RMO7eUoW
         YazwyV1HxNiWduCfZNmXXQ+RR2ExHkPj+nYgze689I5SnebgJHIUWLtHfsxDJmiPtzfQ
         fHsNHiqDTHNQ4PiNDJcsc3GrFXN2vWOUwOayspb/do8gYKZ5aHFG2p8Kt+dhCyELMa1m
         0GMg==
X-Gm-Message-State: AOAM531ju9kOX8sg9lDpCJ2sqfXs06EaqOqgvKuks03k46tQU96yPbFr
        XLR/hxaL52RaTDy40SzuetKl4A==
X-Google-Smtp-Source: ABdhPJz73JY3yLDUY6xr/jjV4y8SsKN6H0NWeoiwZQ6xAk04KGa1rAljireM7SzoraFwJvt6CG+IFw==
X-Received: by 2002:a19:4f10:0:b0:471:fb4e:bf28 with SMTP id d16-20020a194f10000000b00471fb4ebf28mr16129205lfb.274.1651099725237;
        Wed, 27 Apr 2022 15:48:45 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id h10-20020ac24daa000000b00471f8c681fdsm1740502lfe.233.2022.04.27.15.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 15:48:44 -0700 (PDT)
Message-ID: <9600b84a-8590-4e7b-c74d-3f52fe905e7f@openvz.org>
Date:   Thu, 28 Apr 2022 01:48:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] memcg: enable accounting for veth queues
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>, kernel@openvz.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <1c338b99-8133-6126-2ff2-94a4d3f26451@openvz.org>
 <20220427095854.79554fab@kernel.org>
From:   Vasily Averin <vvs@openvz.org>
In-Reply-To: <20220427095854.79554fab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/22 19:58, Jakub Kicinski wrote:
> On Wed, 27 Apr 2022 13:34:29 +0300 Vasily Averin wrote:
>> Subject: [PATCH] memcg: enable accounting for veth queues
> 
> This is a pure networking patch, right? The prefix should be "net: ",
> I think.
Thank you for the remark, I'll fix it.

Initially it was a part of the patch accounted resources accounted 
when creating a new netdevice, but then I moved this piece to
a separate patch, because unlike other cases, it is specific to veth.
 
Thank you,
	Vasily Averin
