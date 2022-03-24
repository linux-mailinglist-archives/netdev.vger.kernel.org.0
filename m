Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172E04E61C5
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 11:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbiCXKdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 06:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiCXKdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 06:33:45 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83D39E9CC;
        Thu, 24 Mar 2022 03:32:13 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 17so5519175ljw.8;
        Thu, 24 Mar 2022 03:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=yIGBhHdGmmA6wfhq/C+I/3lptUPuCRf9dLkGG/+jm/0=;
        b=UECv386z8DX2m17XrbzsWDtNOzryfJvtsSbyNTgODZ/baOrSAi26WyQodjOx/EVuTN
         i9gdHVYgFlKbM9Q1+/08aVpUWHklq+lG/ToDHtsZwCGIbpPEHAkKJwagSfcUXchYQejK
         CEImEFdTQxPQ1Jk2Gq5CPAcOGTEVQlzJT13oM8IuTCrtBQ5xUp1CLp/Ot0YOfOGJ578W
         Vjnyi9PMvGfFyTaOCvwUxNTPFE3UMKE8WF+xWZCJf92txuRqerdZCpuWlHA0tiW9mYZr
         cqBHnDx2AnoP/LKtZ6tYr5mbrEwS85AKdUkKcKL+QNtDieFCglv+4bovA/N8I6rA8S9r
         /6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yIGBhHdGmmA6wfhq/C+I/3lptUPuCRf9dLkGG/+jm/0=;
        b=0VFXeEwBL8RdeAvHfUDf7U/S4V6iP0ouyFiAv+ng+sgHZuYi0V9nwXb4Xy7vBe/qYB
         2vNVaPEAkkz9XpC3WgfppQaboDufeuVDG4xtA4f+juC08PTXQ95pIk321r/5g76oIxkX
         xmlHKhQUIUMJlEk4gqovgBZxFMYGIaIH4XBA89E8FKf3jzvudIzInJxbxHwlGZKBzR+f
         hC25gdnqw+WDKPS3DzCnEKgavQZdSy/phMhPquy8Odc1vK1gi2/gD1XGEiLlsovT147b
         WLoFuSztjhtWoQKQQsR67iqYXYACZ2JqJnZlIWuXJ7cAeCKuCiDjoG2Sie054LLTnHH9
         UqcQ==
X-Gm-Message-State: AOAM533Eup4wSGamh/0yasGXQ4Qk2b7zopa+qd+kipwO7/3xi8iVnX/r
        FQJTnbpiyU4HUsTbIZ1f77gmcmAMpl2HiWf2
X-Google-Smtp-Source: ABdhPJzCULThTsLuOBtIbhx5MseJh312jiRpFnwVxEIh8muMTtUjy8iMJZWGuKG5tjrjFK2IU8HUuA==
X-Received: by 2002:a2e:9904:0:b0:247:ec95:fdee with SMTP id v4-20020a2e9904000000b00247ec95fdeemr3684456lji.291.1648117931993;
        Thu, 24 Mar 2022 03:32:11 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id g27-20020a2eb5db000000b002498222c8dasm286633ljn.65.2022.03.24.03.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 03:32:11 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
In-Reply-To: <20220323144304.4uqst3hapvzg3ej6@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com> <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com> <20220323144304.4uqst3hapvzg3ej6@skbuf>
Date:   Thu, 24 Mar 2022 11:32:08 +0100
Message-ID: <86lewzej4n.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ons, mar 23, 2022 at 16:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 23, 2022 at 01:49:32PM +0100, Hans Schultz wrote:
>> >> Does someone have an idea why there at this point is no option to add a
>> >> dynamic fdb entry?
>> >> 
>> >> The fdb added entries here do not age out, while the ATU entries do
>> >> (after 5 min), resulting in unsynced ATU vs fdb.
>> >
>> > I think the expectation is to use br_fdb_external_learn_del() if the
>> > externally learned entry expires. The bridge should not age by itself
>> > FDB entries learned externally.
>> >
>> 
>> It seems to me that something is missing then?
>> My tests using trafgen that I gave a report on to Lunn generated massive
>> amounts of fdb entries, but after a while the ATU was clean and the fdb
>> was still full of random entries...
>
> I'm no longer sure where you are, sorry..
> I think we discussed that you need to enable ATU age interrupts in order
> to keep the ATU in sync with the bridge FDB? Which means either to
> delete the locked FDB entries from the bridge when they age out in the
> ATU, or to keep refreshing locked ATU entries.
> So it seems that you're doing neither of those 2 things if you end up
> with bridge FDB entries which are no longer in the ATU.

Any idea why G2 offset 5 ATUAgeIntEn (bit 10) is set? There is no define
for it, so I assume it is something default?
