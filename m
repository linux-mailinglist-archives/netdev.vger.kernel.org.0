Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2A754256F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiFHCzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448157AbiFHCxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:53:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B06B1BF808
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 17:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654647996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=heXsD028htaJL34qTH2KR7HknWXjuOe5IQ5XBb4j4Eo=;
        b=Sjt9DMjJGDst5v/8uDoDvdEZgrFH6fyNKry0XkezM+cEAilzewOVNP6axc3qrq85uOqHeP
        F8UCCzbWml+3IckNBNeaApAUnkoB2pEupT4DALzc/X7FgpQtTa9QdLPIA8Q9TvgyIDTo4y
        WHN0Rwxt+2Uxcty+VyHSbBWixQna6kI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-SPJ5trl0NyC0S83ZwaszIA-1; Tue, 07 Jun 2022 20:23:25 -0400
X-MC-Unique: SPJ5trl0NyC0S83ZwaszIA-1
Received: by mail-qv1-f69.google.com with SMTP id e2-20020ad45582000000b00466c14d5700so10659405qvx.19
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 17:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=heXsD028htaJL34qTH2KR7HknWXjuOe5IQ5XBb4j4Eo=;
        b=jsHQnfp1Ijz0VxWqClF12U/9JMjUvLWATCqWTuhXW27iXcqRXyXwYtw21flwDr1I8p
         FRlYjUWRdm9+6os4WSkwevWVR+93/U603YMc91kEFvsdQr0xGgfD8PURW4vGab480XMA
         DErjla4oh45ALAmbH9TvobTjXwTW93r3TgtdceQtJdflRxFyoTuuc9TRxGymhLd5aT5t
         0epWg8Gl8mbFRAg7HwH387+PKS77nZ1eDB7jmsuaiYofzBuMG2XCwKdTxgjJJ384gkiH
         wG3ZyLBd5dhAYsVPriMPPN4dT3aOqP5JYnvFmBQz7qps5HagNzy6TM2Tc2msXlKkwS1D
         M7Gg==
X-Gm-Message-State: AOAM532X2KokshLp8xsBV8OibTALoA0JWCkb/SlVCpBwgOfDFbiSMrnK
        m61EnZkM/oZY2dYK2PBL9BnOp8JDOEQHE7Ty/0kA1h9VuXinH6MgekC+esXUCm1rNykht/cUnDH
        YSM2KOgEwJHtwKzdr
X-Received: by 2002:ac8:5bcb:0:b0:304:ff2f:459f with SMTP id b11-20020ac85bcb000000b00304ff2f459fmr2348851qtb.545.1654647805522;
        Tue, 07 Jun 2022 17:23:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIHuSZClxr2yO8JHNfpgL49r9yYKKOsVIAjccwnE/IxiAhcJzAOFAxsOfHcFFuyKjCzc1zlg==
X-Received: by 2002:ac8:5bcb:0:b0:304:ff2f:459f with SMTP id b11-20020ac85bcb000000b00304ff2f459fmr2348836qtb.545.1654647805327;
        Tue, 07 Jun 2022 17:23:25 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id i8-20020a05620a404800b006a69aba9f19sm12042819qko.80.2022.06.07.17.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 17:23:24 -0700 (PDT)
Message-ID: <8b94a750-dc64-d689-0553-eba55a51a484@redhat.com>
Date:   Tue, 7 Jun 2022 20:23:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [net-next 1/2] bonding: netlink error message support for options
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <cover.1654528729.git.jtoppins@redhat.com>
 <ac422216e35732c59ef8ca543fb4b381655da2bf.1654528729.git.jtoppins@redhat.com>
 <20220607171949.764e3286@kernel.org>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220607171949.764e3286@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/22 20:19, Jakub Kicinski wrote:
> On Mon,  6 Jun 2022 11:26:52 -0400 Jonathan Toppins wrote:
>> Add support for reporting errors via extack in both bond_newlink
>> and bond_changelink.
>>
>> Instead of having to look in the kernel log for why an option was not
>> correct just report the error to the user via the extack variable.
>>
>> What is currently reported today:
>>    ip link add bond0 type bond
>>    ip link set bond0 up
>>    ip link set bond0 type bond mode 4
>>   RTNETLINK answers: Device or resource busy
>>
>> After this change:
>>    ip link add bond0 type bond
>>    ip link set bond0 up
>>    ip link set bond0 type bond mode 4
>>   Error: unable to set option because the bond is up.
>>
>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>> ---
>>
>> Notes:
>>      Removed the printf support and just added static messages for various
>>      error events.
> 
> Thanks! nit, missing kdoc:
> 
> drivers/net/bonding/bond_options.c:729: warning: Function parameter or member 'bad_attr' not described in '__bond_opt_set'
> drivers/net/bonding/bond_options.c:729: warning: Function parameter or member 'extack' not described in '__bond_opt_set'
> 

Thanks, will post a v2 tomorrow. What tool was used to generate the 
errors? sparse? checkpatch reported zero errors.

