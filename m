Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB9A523D41
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 21:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346710AbiEKTQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 15:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiEKTQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 15:16:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9475124BFE;
        Wed, 11 May 2022 12:16:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 7so2592173pga.12;
        Wed, 11 May 2022 12:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=NlpSIY55/vhhSMAXUY8HjSp2cIpRawXhaXbZ3jqbOFs=;
        b=dh52RZQkMA5F04yXcqzHA2XBKBrix5ERquN2TGlqCi1JycSfnM5xRFkhKiGKpCUdeJ
         DVCC4jPsPyT+qutdbb8F6KjQ0cqgNftgL+BbjG7zUHWPlsPTmr+za32ZRGAOUvLUYmNO
         n7gi0VLW3uPqiyOqPmUid38RjKrJjPps18Z6l1tOUxPQ1xyJxyrmf69owWKDOf3wVFnY
         q7mHusvTOq9htahS0RjoeB/Ewzfshqt92QfLHVjcxIT9mst5QZIXXs9iWECf3936jI6Z
         IplzkRTzxH9k0j+/7rJqq27qpq/zT9z+rCR0rd/L92ew2EE6qeq+tPcTBViWgU/cqZkL
         aJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NlpSIY55/vhhSMAXUY8HjSp2cIpRawXhaXbZ3jqbOFs=;
        b=XCJ8i9yI7aLHkFPIor/o7DgIvrWCg2sgHwXcnYM+VThteSw0VqEqZo53jyxV9zchs/
         GtcAQMLarSMyn6YSu/yUZY+SEpd7q7WAWiIwmP4rwjxoMGtzAd1M8oYoT7e7jI4KAtm7
         aHVG3Y+0SKtqxjcyjx57fSpEZzbxdyDoVS2SQBJM0zy/M/bN2ZHcSvRm44Ukiodterb8
         /8DxglPYFAofY9TY1nnOmAJLluQ821Wa80CvVwb98ixxKmh2Tcg+hwf7zFrNLDiCs6qA
         1E4Bdmh3ok7kSh99DWBt9SzeofmHneEkCUjJLuQAYDq9+mkLiT/4WNYkqWh+L6/aLqHP
         deIQ==
X-Gm-Message-State: AOAM530S0V7wBANYLS6L2bSqPY5hPLMgjW8HsAPSBRBZFzKZGSKGtjA5
        +pPWcdGrP35ZhjIga4L0crg=
X-Google-Smtp-Source: ABdhPJw7cfLquMFIpOP2v6T5a0S18OkdeoZczUfSnRCGQ0YVWeC8TV8HBNOI/1R/kNTf8UemtnziSA==
X-Received: by 2002:a62:a211:0:b0:50d:cdb2:87f4 with SMTP id m17-20020a62a211000000b0050dcdb287f4mr26527957pff.63.1652296564123;
        Wed, 11 May 2022 12:16:04 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:3e8a:bf9a:d0b0:e550? ([2620:15c:2c1:200:3e8a:bf9a:d0b0:e550])
        by smtp.gmail.com with ESMTPSA id c19-20020a170902c2d300b0015eee3ab203sm2281176pla.49.2022.05.11.12.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 12:16:03 -0700 (PDT)
Message-ID: <990f83d5-f684-9160-b90e-14d6069fba1e@gmail.com>
Date:   Wed, 11 May 2022 12:16:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] WARNING in mroute_clean_tables
Content-Language: en-US
To:     syzbot <syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, erdnetdev@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
References: <000000000000e0d41905debf1844@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <000000000000e0d41905debf1844@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/11/22 09:40, syzbot wrote:
> This bug is marked as fixed by commit:
> ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table()
> But I can't find it in any tested tree for more than 90 days.
> Is it a correct commit? Please update it by replying:
> #syz fix: exact-commit-title
> Until then the bug is still considered open and
> new crashes with the same signature are ignored.


#syz fix: ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() 
on failure path


