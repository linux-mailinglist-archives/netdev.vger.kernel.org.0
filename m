Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0FB2A82F2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbgKEQCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgKEQCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 11:02:18 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E718C0613CF;
        Thu,  5 Nov 2020 08:02:18 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u62so2291069iod.8;
        Thu, 05 Nov 2020 08:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MAHLshw60eEwdm37ATqaQRT7lcxyOw4IoZI+r9s+npo=;
        b=Val3pzDUUT5h643nG0XfwDd2Cuq87OCzVWCY57vXYfe29bMYLitJ2W+4aM43gSWOJz
         OADVNuuZ/PGARZR93yMcQyVUvvzKnoLiuRJ5RYA3wuEP/VlV0zjzr2wQkH9zJlY7Wfw/
         CrJQFjIPr9YNdEhALNWzyPfYy9380REU0odePPmow9r3iRfES1koiKfqwkzVrvne26zF
         M+VH93f3yRKPkwBKYh7cljowVFRle/CCaEGqsp7e7RZ5XoLCMhuMLtaLUnPVf42l+Dl7
         nNN8FHbO9s/qAyKslfBbI1mO1XHbUvOKe/8vRCgBTiXibuADKCL/8u3cfrA4TMGYGpvh
         IspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MAHLshw60eEwdm37ATqaQRT7lcxyOw4IoZI+r9s+npo=;
        b=tDSTfeg+F1eDKVfh65eYqmhvrylMpf7tNefe+NotzghXNxMfCUITngBoPXihHtJEKZ
         KysSfmEQB6tdxHYGfHFeZPa+KMu6LSAKQ1SNHKp7QVKauebaaTbSn/hKBMpDCzKN/prU
         txsADWZTqTbUpreS5OLTMnG09xiSeCVXwLJwchgqEiQROhh4UB052A0ByF47nsu/7xQg
         Lbio4M+RVIFGWQwfdnuH+61gkt6rzi41SirGeB+32mVS+FZWzAd6NUER8r7i1raCfjLl
         LZ4ufYQ9e+HSvtDq0G6FGsrDs0mow/VeUiFnH3uMH/rzv5igdO68xutJz08FlmxRXlZ6
         uLfQ==
X-Gm-Message-State: AOAM531g14Ho/HrYcejwHavHCF4fgyyTWexrMDZl6TaHdnOc7KKScS68
        x0VdS7+7L8jm5Jdv/sL9PO8KRQ4phds=
X-Google-Smtp-Source: ABdhPJx2BG6R6fonv2lCeZzkQrFoeMk8Xmc+gJoeNIFTIcUwi3K6iXLxTxeajzGrbsA92B115uFy6g==
X-Received: by 2002:a6b:dc0f:: with SMTP id s15mr2182871ioc.180.1604592137899;
        Thu, 05 Nov 2020 08:02:17 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:291c:9506:5e60:11ce])
        by smtp.googlemail.com with ESMTPSA id j3sm1343072ilq.85.2020.11.05.08.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 08:02:17 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
 <20201104082203.GP2408@dhcp-12-153.nay.redhat.com>
 <61a678ce-e4bc-021b-ab4e-feb90e76a66c@gmail.com>
 <20201105075121.GV2408@dhcp-12-153.nay.redhat.com>
 <3c3f892a-6137-d176-0006-e5ddaeeed2b5@gmail.com> <87sg9nssn0.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9cd3ed2a-48e2-8d2a-3223-51f47c4f6cbc@gmail.com>
Date:   Thu, 5 Nov 2020 09:02:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87sg9nssn0.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/20 8:57 AM, Toke Høiland-Jørgensen wrote:
> I guess we could split it further into lib/bpf_{libbpf,legacy,glue}.c
> and have the two former ones be completely devoid of ifdefs and
> conditionally included based on whether or not libbpf support is
> enabled?

that sounds reasonable.
