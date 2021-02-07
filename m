Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63F931249C
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhBGOOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 09:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhBGONu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 09:13:50 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29978C061756
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 06:13:10 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b9so20444911ejy.12
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 06:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w6oegXIzIc0UwP/fg1twf7f1LMWXjODHbU1V0MHboc4=;
        b=Fgkk42D/h/KvLXiQkCCzsGy2s512RnstC9cnCW0vzDxwTyhkXkar870gdw0PJMDCsZ
         O2z2Qo7nOyxeEvfAb9me/3o/QL5WyeDZBYVbdDZel6H2QbvSxgGMHOIMEw3Etcti4IPD
         P52VdzjT7AmbdO1OKF3b5ExCBUW+goDx5XTfdZwY7NCaCBqxTB5nbFq/aHe0t7oid2oL
         PElKW1YzkGtqgsK59SIGRh14xEgZ6CUlUEgqU9GYAGLcML6ts6dPfs5Mn52A8FqP2ZLz
         RKE4JBOjj8OUucuPueCgOxGfh4vgC5NHrm8MO+rJxcrZg078vaYkyo80zAgk/Ck1OumA
         PVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w6oegXIzIc0UwP/fg1twf7f1LMWXjODHbU1V0MHboc4=;
        b=W4H4UEJUt1/0h4g1k+jj/CoThgnGNzJAeE32P0k2IZynXVwzm4N8HEKpaecRJiLnqy
         EhZOHQPZMdrSEBQbDlZsAD+m3Yu4I8fRcZhUxb1Fms/oNYqgpPghQ80M4u8iLq0lzJQG
         Vh6Ow1VF/+XY+PN3GgsW0jmzeyr7dsGhHo1KkZzOdUZUjliNhAxkFsba9KH+/YO+16zZ
         3O52WpxGyb8cw1m1lh9qbNgIhky4p4sz89L7h92RfZk999Gp+CnKyzM3JfPlTjyswNTS
         tslAXA1l8S8yrdmbU0LdGA7gSWE1W3fyr16dgTKDhU6fYK1Wgvq0ExPfJ8KpBOOHPhAj
         cLNg==
X-Gm-Message-State: AOAM530e1o+CGxeQ5D0USQCPELDDp6qM7mJw5yiaJQtfhp7wlot1G/r0
        09JrWyWEJWGJTQBf76C5xmE=
X-Google-Smtp-Source: ABdhPJwEHlfxYvZkRGE5qe9GbdKWUbzpreU6bUsiLHWYa+0DGCAdXcaaqYik4Hxv/gfbibM45Juzxg==
X-Received: by 2002:a17:906:1b11:: with SMTP id o17mr2265901ejg.295.1612707188971;
        Sun, 07 Feb 2021 06:13:08 -0800 (PST)
Received: from [132.68.43.187] ([132.68.43.187])
        by smtp.gmail.com with ESMTPSA id f22sm6872841eje.34.2021.02.07.06.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 06:13:08 -0800 (PST)
Subject: Re: [PATCH v3 net-next 01/21] iov_iter: Introduce new procedures for
 copy to iter/pages
To:     Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        Sagi Grimberg <sagi@grimberg.me>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        axboe@fb.com, Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
 <20210201100509.27351-2-borisp@mellanox.com> <20210201173548.GA12960@lst.de>
 <CAJ3xEMjLKoQe_OB_L+w2wwUGck74Gm6=GPA=CK73QpeFbXr7Bw@mail.gmail.com>
 <20210203165621.GB6691@lst.de>
 <20210203193434.GD3200985@iweiny-DESK2.sc.intel.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <e1eb7f7d-9a2a-f879-6fc9-4b929f2a4239@gmail.com>
Date:   Sun, 7 Feb 2021 16:13:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210203193434.GD3200985@iweiny-DESK2.sc.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/02/2021 21:34, Ira Weiny wrote:
> On Wed, Feb 03, 2021 at 05:56:21PM +0100, Christoph Hellwig wrote:
>> On Tue, Feb 02, 2021 at 08:00:51PM +0200, Or Gerlitz wrote:
>>> will look into this, any idea for a more suitable location?
>>
>> Maybe just a new file under lib/ for now?
>>
>>>> Overly long line.  But we're also looking into generic helpers for
>>>> this kind of things, not sure if they made it to linux-next in the
>>>> meantime, but please check.
>>>
>>> This is what I found in linux-next - note sure if you were referring to it
>>>
>>> commit 11432a3cc061c39475295be533c3674c4f8a6d0b
>>> Author: David Howells <dhowells@redhat.com>
>>>
>>>     iov_iter: Add ITER_XARRAY
>>
>> No, that's not it.  Ira, what is the status of the memcpy_{to,from}_page
>> helpers?
> 
> Converting the entire kernel tree in one series has become unwieldy so I've
> given up.
> 
> But I have a series to convert btrfs which I could release by the end of the
> week.  That should be good enough to push the memcpy_*_page() support in.
> 
> I'm get it formatted and submitted,
> Ira
> 

To conclude this discussion, there's nothing that we need to change here
as the relevant series is still WIP, right?
