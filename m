Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19C820BC1A
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFZWDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:03:15 -0400
Received: from neo-zeon.de ([96.90.244.226]:51983 "EHLO neo-zeon.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgFZWDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:03:15 -0400
Received: from [192.168.0.2] (amuro.nerv.lan [192.168.0.2])
        (authenticated bits=0)
        by neo-zeon.de (8.15.2/8.15.2) with ESMTPSA id 05QM3EKH031791
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 26 Jun 2020 15:03:14 -0700 (PDT)
        (envelope-from cam@neo-zeon.de)
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
 <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
From:   Cameron Berkenpas <cam@neo-zeon.de>
Message-ID: <ec45c883-b811-1580-c678-73a490fe8a0c@neo-zeon.de>
Date:   Fri, 26 Jun 2020 15:03:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Box has been up for 25 minutes without issue. Probably the patch works, 
but I can further confirm by tomorrow.

On 6/26/2020 10:58 AM, Cong Wang wrote:
> On Thu, Jun 25, 2020 at 10:23 PM Cameron Berkenpas <cam@neo-zeon.de> wrote:
>> Hello,
>>
>> Somewhere along the way I got the impression that it generally takes
>> those affected hours before their systems lock up. I'm (generally) able
>> to reproduce this issue much faster than that. Regardless, I can help test.
>>
>> Are there any patches that need testing or is this all still pending
>> discussion around the  best way to resolve the issue?
> Yes. I come up with a (hopefully) much better patch in the attachment.
> Can you help to test it? You need to unapply the previous patch before
> applying this one.
>
> (Just in case of any confusion: I still believe we should check NULL on
> top of this refcnt fix. But it should be a separate patch.)
>
> Thank you!

