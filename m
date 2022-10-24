Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3D609E10
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJXJbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiJXJbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:31:38 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC7960519
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:31:11 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id q5so2268744ilt.13
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vUlUUGoJnQ7g2LC8QuezYDhUG0fdMvocBfT6skXTjsI=;
        b=Pfg7Jt0WWpz7Eis6P+ENGI7IFG5pdh4rUXkqi6bjdIdAUbtNXR0j9DL5zQX8bgrXSy
         wlA5RsWja1UdJO3hc/Kgmwa2oVNBIkKGQWfgrFLxrvy0JUVpA234seGOeNhMFUtpJA2M
         EsRNH62C7LiH8NsqZxNWMioJITnvTTbqHIruvzx7vUlYhllFo0T0Mn7x7wp6gU4PqkV4
         QjSM6uD1ztLuNzgunmBYZytI2c4ODNMUMXfWhZ9g7vfdBBsYrRPeAT0kOGuw2ysEB2Vp
         REesogsXY5o1ggcjjY/59orSs+u93BruK5r5RlFnZ7NRhi+U9ROdTQaZFucPmZnaDo+E
         A4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vUlUUGoJnQ7g2LC8QuezYDhUG0fdMvocBfT6skXTjsI=;
        b=SWHnp4niH6ALYK2we8JjaoZb/KOR/bvv0Jrl7v7/vTjNkAk1SftHXZz58nnO9NN0Lo
         1qWsw+W7AHOhpR1zZRC6/4VcAG+5Uz1SGmNcpy09Xjzu/Nh7lZuAsaK63SM0j7gTPvku
         8e94mAmtPXZ9rq+Oek2I/OPE5oa7L+x5UCUEA0EqGPlGqsZlG9RbhrqzlHhAT4vIhK5x
         u2IliwGoJB7tEWHXEHQCSDtxYNpscEA0r69hDhBE1/lAMF8QdgStFEptKU1Uwc3Mgrq6
         hdjunEWwCT25DE4J6nd8SRcH4IWTk6PKLETxXt1U7sdTdc43XVbm7Dn08TGeise6EH2G
         x/Rw==
X-Gm-Message-State: ACrzQf0IPEkdPuBbvdleov/zGs+Dbk5p4JURYQXSND0MZCxU6EZL1sV0
        ceH1EWLo40ml1baxA7cLghufOKNuXpY9g3hACE8=
X-Google-Smtp-Source: AMsMyM6FOD3ZZLvVX370JqdMg3MqKgOrewBJM/g8ZEvKg1A0oKGFRyFvqKwS/YViLltq6LPiga8H5PsaCa1gfLOAAso=
X-Received: by 2002:a92:d5c4:0:b0:2ff:c073:5cb4 with SMTP id
 d4-20020a92d5c4000000b002ffc0735cb4mr5005429ilq.82.1666603862903; Mon, 24 Oct
 2022 02:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20221014093632.8487-1-hdegoede@redhat.com> <CAHNKnsSvvM3_JEdr1znAWTup-LG-A=cuO8h-A8G6Cwf=h_rjNQ@mail.gmail.com>
 <ea022df4-2baf-48ae-e5ed-85a6242a5774@redhat.com> <CAHNKnsSaNuU3xcnRpnP2CM8ycOqomaaeT9Tz40FLJbbKFXgTzw@mail.gmail.com>
 <e78222b2-947f-b922-a8a7-e04f6a1d868e@redhat.com>
In-Reply-To: <e78222b2-947f-b922-a8a7-e04f6a1d868e@redhat.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 24 Oct 2022 13:31:01 +0400
Message-ID: <CAHNKnsTV0FjqQiaTiayPPwaJ-nkt7-LAczBh3vnXOXn==ZVKnw@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: iosm: initialize pc_wwan->if_mutex earlier
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 1:17 PM Hans de Goede <hdegoede@redhat.com> wrote:
> On 10/24/22 11:14, Sergey Ryazanov wrote:
>> On Mon, Oct 24, 2022 at 12:04 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>> On 10/15/22 09:55, Sergey Ryazanov wrote:
>>>> On Fri, Oct 14, 2022 at 1:36 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>>>> wwan_register_ops() ends up calls ipc_wwan_newlink() before it returns.
>>>>>
>>>>> ipc_wwan_newlink() uses pc_wwan->if_mutex, so we must initialize it
>>>>> before calling wwan_register_ops(). This fixes the following WARN()
>>>>> when lock-debugging is enabled:
>>>>>
>>>>> [skipped]
>>>>>
>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>
>>>> Should we add a Fixes: tag for this change? Besides this:
>>>
>>> This issue was present already in the driver as originally introduced, so:
>>>
>>> Fixes: 2a54f2c77934 ("net: iosm: net driver")
>>>
>>> I guess?
>>
>> The wwan_register_ops() call has been here since the driver
>> introduction. But at that time, this call did not create any
>> interfaces. The issue was most probably introduced by my change:
>>
>> 83068395bbfc ("net: iosm: create default link via WWAN core")
>>
>> after which the wwan_register_ops() call was modified in such a way
>> that it started calling ipc_wwan_newlink() internally.
>
> Ok, lets go with:
>
> Fixes: 83068395bbfc ("net: iosm: create default link via WWAN core")
>
> Shall I send a v2 with this ? or is this just going to get added
> in while merging this?

Yes. Send the v2 with Fixes and Reviewed-by tags please. This will
make the work of the netdev maintainer more productive.

-- 
Sergey
