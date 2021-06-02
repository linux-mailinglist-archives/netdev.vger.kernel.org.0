Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCD6398ED3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhFBPkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhFBPko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 11:40:44 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05671C061574;
        Wed,  2 Jun 2021 08:39:01 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso2775656otu.10;
        Wed, 02 Jun 2021 08:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RspDkee90yUUBxRu5qM7EKFWbFArMFdC6jUFJ1rxZY4=;
        b=roEjTXLG72sH1Wu0DdDEvcvn+Wo/eRNO80rtIe0VjfIUcONGD0ie8YhM9ijfsZMSYh
         q1UoONM9qKk74syckh8BIgYtVUrZB6gcCZ0r3HBGdU4BmPkdh4PPWBqd7ncISUzFQ4Lv
         H03XY03lC0c5YBSdhgcOID2Wz+9b86HTVQkMghyW76XZENlZj785ZK5ALxUXTsPVbCjF
         OJmA3j0tNkyIqFHXXmidyegjmU4XG4HQk4ouVDLJjfxwsBAys2wnFs9N6P31jtjQnQIy
         QAnmwvaqUaMbEVry/t5KuQnxr5/UCgQ9JjG1wm9HkE/khFMsmP9mZ5MzAjytHVwpdpT5
         K/9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RspDkee90yUUBxRu5qM7EKFWbFArMFdC6jUFJ1rxZY4=;
        b=kOWf+tj4e23vwIE5o0qiW1pPyNpoSV+/hB4fIVLT3xtytwKk3wYZdcE/OZ1+rgD/o8
         ebXSLNLvhtecYcF2AK4egYHkblCZ8NENN/9igDXvVL+WkMEcg9WyIuHlsfDLZ3VoQEqR
         +nCs8kTo2r+pFOR8FvIsKe7r4COV0wXqkcDhyBWOo1eTNcmfDjYW4zYniFF9M0d5BusZ
         A69Rnqu6UQEtpuhZ+TBlCeW9hD7O6vqZFcrbipboqdFK0nWWet0AN1P9OqbzGjHUIGi8
         TVWmBamrGMyFxFr0/jANSt8BQGXs5/u6RK9rmTKYUzHbotLhvXDNM8xy5RBfW9u46Oo9
         NiHQ==
X-Gm-Message-State: AOAM531Z8RCOpdeQzWzUB1mcHizE7Q/0mZbDKhkqNGIuV3I0d4ecpUAa
        GHTAsFdUeeJpjShcKAFkRWAgyMftjRTQoilJKaY=
X-Google-Smtp-Source: ABdhPJyTYYAF2pcziCdoIpfOwUVcbVioPbp5S3hoJAq09LWQw7ISN5n1xy7cuaTQ5Hg0uzZR8NnUC52jlIzZfp3HoqY=
X-Received: by 2002:a9d:7a5:: with SMTP id 34mr2406484oto.371.1622648340438;
 Wed, 02 Jun 2021 08:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210601080538.71036-1-johannes@sipsolutions.net>
 <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
 <CAHNKnsRv3r=Y7fTR-kUNVXyqeKiugXwAmzryBPvwYpxgjgBeBA@mail.gmail.com>
 <15e467334b2162728de22d393860d7c01e26ea97.camel@sipsolutions.net>
 <CAHNKnsQh7ikP4MCB0LhjpdqkMTjWq2ByWG4wToaXgzteYjUQaQ@mail.gmail.com> <2dbf474b0a0358627d12b1949ff98b9022943d76.camel@sipsolutions.net>
In-Reply-To: <2dbf474b0a0358627d12b1949ff98b9022943d76.camel@sipsolutions.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 2 Jun 2021 18:38:49 +0300
Message-ID: <CAHNKnsQW_s6vJu2Otb91WaFebP1-wt7ZB7drxCTvnwFkPVk0SA@mail.gmail.com>
Subject: Re: [RFC 3/4] wwan: add interface creation support
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 3:56 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>>> The only thing I'd be worried about is that different implementations
>>> use it for different meanings, but I guess that's not that big a deal?
>>
>> The spectrum of sane use of the IFLA_PARENT_DEV_NAME attribute by
>> various subsystems and (or) drivers will be quite narrow. It should do
>> exactly what its name says - identify a parent device.
>
> Sure, I was more worried there could be multiple interpretations as to
> what "a parent device" is, since userspace does nothing but pass a
> string in. But we can say it should be a 'struct device' in the kernel.
>
>> We can not handle the attribute in the common rtnetlink code since
>> rtnetlink does not know the HW configuration details. That is why
>> IFLA_PARENT_DEV_NAME should be handled by the RTNL ->newlink()
>> callback. But after all the processing, the device that is identified
>> by the IFLA_PARENT_DEV_NAME attribute should appear in the
>> netdev->dev.parent field with help of SET_NETDEV_DEV(). Eventually
>> RTNL will be able to fill IFLA_PARENT_DEV_NAME during the netdevs dump
>> on its own, taking data from netdev->dev.parent.
>
> I didn't do that second part, but I guess that makes sense.
>
> Want to send a follow-up patch to my other patch? I guess you should've
> gotten it, but if not the new series is here:
>
> https://lore.kernel.org/netdev/20210602082840.85828-1-johannes@sipsolutions.net/T/#t

Yes, I saw the second version of your RFC and even attempted to
provide a full picture of why this attribute should be generic.

I will send a follow-up series tonight with parent device exporting
support and with some usage examples.

>> I assume that IFLA_PARENT_DEV_NAME could replace the IFLA_LINK
>> attribute usage in such drivers as MBIM and RMNET. But the best way to
>> evolve these drivers is to make them WWAN-subsystem-aware using the
>> WWAN interface configuration API from your proposal, IMHO.
>
> Right.

-- 
Sergey
