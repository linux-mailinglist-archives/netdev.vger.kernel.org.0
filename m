Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBBF4FE5F0
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351070AbiDLQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357715AbiDLQgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:36:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21C65E779
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:33:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so3468880pjn.3
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v10xJ+RRHChFNCYwkKyT1kGj5etFDNkFVbTehEuJs2E=;
        b=gSAF8YUHePFxFZKOAFT2CbQiXFEsvVADvY0jn/FdteoRf5l8yMilaUj4xxBnae18pc
         hwEgHVtG7TyfSgzmSWIf/J1Vv9YPtDBGBW14eqY+1SBrs7myt+AX/o3eXpp1bMldDOeN
         BXxJx7ctGLTxCxoX6wZA4nXsXaSOx2vfHPl4ny3H7FNyZiNHyRZtaTw2WrUNHms0RNEf
         yXNXFqtW2Z482MHyBUDfwPUS2rNtoiD40pV+M7aVBAbNbYZkJ1UE97yBEfP8gln58W/i
         Dse7QsPRJb0X6hjouxFGNWkF1MKFyVopTL2F8tSG8iw994zznmho+PZsARwWOxh7wHcD
         sXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v10xJ+RRHChFNCYwkKyT1kGj5etFDNkFVbTehEuJs2E=;
        b=5fr8+GA4WEju/hY/SMSm5d2x6NoidLEAVgGoYVc2US83sV7khNAKixzAFgFd4nxx8a
         sAU1mgNExJBMdZH3XAmyvhAiyPbK4njXx6tyifMwDspN2e5wx5K82CopyvG2POJOjFhe
         u0QU9J5Uf0v0Kj4723Ui+Fze91nQ1sAi5LlAaGb0yL3a9uzf49cGklIdMAQWxlHsc+e7
         x2rpo205kuZ4u7PZs7Mdh74HztzRAgbx3r+DHztAHNVqk9UNZN0juJSBPCn1CpFh9S12
         +DyVEiCsWfkZYsZo3Wb6MdlssZtSRMKWdeKTAY5LxrKx9cYUm7xegRAWxOLIxIz2NUAU
         vFNw==
X-Gm-Message-State: AOAM531w7cUMic05LDON7BY5mauGWYHJRCMLg7jnw8hwJM0VYGcO3np4
        VrAQuQfqUnaevkPJf4dMREgRiIcRCaw=
X-Google-Smtp-Source: ABdhPJx9qFIJBJxI6YXO+hlaU7ekKTwqvXVXRcWxXierQyQwFTyNNNdSdIt4qUIGD6Dg5KzbUkENig==
X-Received: by 2002:a17:902:7610:b0:158:89a5:fc5a with SMTP id k16-20020a170902761000b0015889a5fc5amr3755467pll.116.1649781239387;
        Tue, 12 Apr 2022 09:33:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p34-20020a056a000a2200b004cd49fc15e5sm42006349pfh.59.2022.04.12.09.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 09:33:58 -0700 (PDT)
Message-ID: <345b77f6-1b03-1493-fb6d-2d5c2194bc26@gmail.com>
Date:   Tue, 12 Apr 2022 09:33:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] rxrpc: fix a race in rxrpc_exit_net()
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, syzbot <syzkaller@googlegroups.com>
References: <20220404183439.3537837-1-eric.dumazet@gmail.com>
 <1313754.1649750767@warthog.procyon.org.uk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1313754.1649750767@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/12/22 01:06, David Howells wrote:
> Do you have a syzbot ref for this?

Try: https://syzkaller.appspot.com/bug?extid=724378c4bb58f703b09a


> David
>
