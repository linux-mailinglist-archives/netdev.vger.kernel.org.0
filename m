Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EEF9F924
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfH1ETh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:19:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42601 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfH1ETg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:19:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so665495pgb.9
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 21:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/I/Thq/zbCuqhNtW0mJ3x2CAl+PXjC3U/HhaAbrm7qw=;
        b=DxUS8ZMch6eeigJ9Tbh/m6RKrNb/qdbOI9bhI//WeHL7nP9pC0cVTBXow3VoU2ls+p
         Znk14wWf5B9eIKA/xJcCztHGlEL8fQQsxpspnwmpfPhKau3zAmjlomp/BP8cq0pZLqlT
         Y2dRrwgX/4YSfP6bPqo+HiqEI7OLOVxil5PYWC+U7YzzvDQa6dX62oiHaFHg4duz2XpU
         8JS9Z3/hT3jigTK/ZKybznGN8R2etnIHQVXIJAbDS5oWGGizcu//VMiZ4mSrbhQ73gMd
         fzjcr4NepmOnaDg8e+lnbOi9HvaWOfJ9PuSPJITm/9MgBTHMrNyrzpyyXisN8OUDU7SA
         j1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/I/Thq/zbCuqhNtW0mJ3x2CAl+PXjC3U/HhaAbrm7qw=;
        b=eYAT2X2WWupOhQDK/0vGFGuP70FS82b9OXMtpcyqLtMvxbUXb54t097C+GYGi7fhzg
         LAL3it/1+1Z/7TZeVuBVEDUDlxU79ncL/8cScKaYPY4auqqi7m4qYe1FfcLcUSmVkgWR
         oJrjB5RDaK3DkqazEIOnvutth0bETCDAqLkGHYTjejV+b6o1ZChBo+wjA0PCjphzm3bT
         aYUi7GbK1KFTb2hpuqfDF9WY+gbyHL2cWXCo97vFX1l0vbz9m7jakp52H9GK4hP2snIJ
         LR8Ky8EOsfLoPFVic7JIxGZpFKzvAAl/yYE5RnsyuOSHqUFJalRnWnwAJ0k2sQVSF9IX
         ET1g==
X-Gm-Message-State: APjAAAVLKH2+VWw2W9RBxpDHrUtVz3FAGyQ8VY/PqxdqsjG88vJJm1hM
        G5UF5//e6j9y/4NldpMZIOY=
X-Google-Smtp-Source: APXvYqy3vSI9/nPQIxys3ZkxTRydhF9jCsVBKJo6+VlF8EgRmbNLdYPG0iPtcPUiQOBVTKcB1FkXTA==
X-Received: by 2002:a65:5188:: with SMTP id h8mr1716512pgq.294.1566965975864;
        Tue, 27 Aug 2019 21:19:35 -0700 (PDT)
Received: from [192.168.0.16] (97-115-90-227.ptld.qwest.net. [97.115.90.227])
        by smtp.gmail.com with ESMTPSA id n10sm825420pgv.67.2019.08.27.21.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 21:19:35 -0700 (PDT)
Subject: Re: [PATCH V3 net 1/2] openvswitch: Properly set L4 keys on "later"
 IP fragments
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
References: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
 <CAOrHB_DXXSoe9rjamp_OSxDonsqTADrbV4GdUdct=uq_eOXN-Q@mail.gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <cd167c27-11d2-a0e3-b7f2-abcbc029e77c@gmail.com>
Date:   Tue, 27 Aug 2019 21:19:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_DXXSoe9rjamp_OSxDonsqTADrbV4GdUdct=uq_eOXN-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/27/2019 5:33 PM, Pravin Shelar wrote:
> On Tue, Aug 27, 2019 at 7:58 AM Greg Rose <gvrose8192@gmail.com> wrote:
>> When IP fragments are reassembled before being sent to conntrack, the
>> key from the last fragment is used.  Unless there are reordering
>> issues, the last fragment received will not contain the L4 ports, so the
>> key for the reassembled datagram won't contain them.  This patch updates
>> the key once we have a reassembled datagram.
>>
>> The handle_fragments() function works on L3 headers so we pull the L3/L4
>> flow key update code from key_extract into a new function
>> 'key_extract_l3l4'.  Then we add a another new function
>> ovs_flow_key_update_l3l4() and export it so that it is accessible by
>> handle_fragments() for conntrack packet reassembly.
>>
>> Co-authored by: Justin Pettit <jpettit@ovn.org>
>> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
>>
> Looks good to me.
>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>
> Thanks,
> Pravin.

Thanks Pravin.

I missed a dash in the Co-authored-by line.  If that could be fixed up 
on commit then good, otherwise I can resend.

- Greg
