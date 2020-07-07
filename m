Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46342167D8
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGGH6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:58:20 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:12335 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGGH6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 03:58:20 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2020 03:58:19 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594108698;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=qNfwcH9LfWaclr0Jyq7Q1GHfpiAsj+fNTGwreOU0xXU=;
        b=nzYPLzyrmsKg8B5hE00bdIpw6xizze0tGukTyRrEpOwp0EaoRWlqvpDNkXE2CKbSOf
        ujw4y3O0UhpOXyL4j+9VCbBXeRp/MidC9//66863YZ0eqgsltKUGS+ML6qTRCVZbdO41
        RIv7uyqJH5FQot94NxEz+5JIhp3d72dKn0XM6PexwBJhboolb2frL32nHD8hTL4J/vs3
        T9/+vPdrmPLV03Wwyceqpcvw+D29679YRYVjRE1VM3aCQBtbfEOUFjU+AEVb6eaJVWW5
        Jczkfb1Re0jsmcA1mwk7YhKBRac1IgPjHjnqjhvHPzf9P3vrxgPK/ExZDNqwFl/cfv0A
        DVgQ==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhSI1Vi9hdbute3wuvmUTfEdg9AyQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:15f9:f3ba:c3bc:6875]
        by smtp.strato.de (RZmta 46.10.5 AUTH)
        with ESMTPSA id 60686ew677qGleO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 7 Jul 2020 09:52:16 +0200 (CEST)
Subject: Re: FSL P5020/P5040: DPAA Ethernet issue with the latest Git kernel
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        mad skateman <madskateman@gmail.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        Darren Stevens <darren@stevens-zone.net>,
        Christian Zigotzky <info@xenosoft.de>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <56DB95B8-5F42-4837-ABA0-7E580FE04B73@xenosoft.de>
 <20200624082352.GA24934@oc3871087118.ibm.com>
 <004794fb-370c-c165-38e6-a451dc50c294@xenosoft.de>
 <20200625102223.GA3646@oc3871087118.ibm.com>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <4a08422d-86aa-ebb5-40a6-4e20467f5240@xenosoft.de>
Date:   Tue, 7 Jul 2020 09:52:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200625102223.GA3646@oc3871087118.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 June 2020 at 12:22 pm, Alexander Gordeev wrote:
> On Thu, Jun 25, 2020 at 01:01:52AM +0200, Christian Zigotzky wrote:
> [...]
>> I compiled a test kernel with the option "CONFIG_TEST_BITMAP=y"
>> yesterday. After that Skateman and I booted it and looked for the
>> bitmap tests with "dmesg | grep -i bitmap".
>>
>> Results:
>>
>> FSL P5020:
>>
>> [    0.297756] test_bitmap: loaded.
>> [    0.298113] test_bitmap: parselist: 14: input is '0-2047:128/256'
>> OK, Time: 562
>> [    0.298142] test_bitmap: parselist_user: 14: input is
>> '0-2047:128/256' OK, Time: 761
>> [    0.301553] test_bitmap: all 1663 tests passed
>>
>> FSL P5040:
>>
>> [    0.296563] test_bitmap: loaded.
>> [    0.296894] test_bitmap: parselist: 14: input is '0-2047:128/256'
>> OK, Time: 540
>> [    0.296920] test_bitmap: parselist_user: 14: input is
>> '0-2047:128/256' OK, Time: 680
>> [    0.299994] test_bitmap: all 1663 tests passed
> Thanks for the test! So it works as expected.
>
> I would suggest to compare what is going on on the device probing
> with and without the bisected commit.
>
> There seems to be MAC and PHY mode initialization issue that might
> resulted from the bitmap format change.
>
> I put Madalin and Sascha on CC as they have done some works on
> this part recently.
>
> Thanks!
>

Hi All,

The issue still exists [1] so we still need the dpaa patch [2]. Could 
you please check the problematic commit [3]?

Thanks,
Christian

[1] https://forum.hyperion-entertainment.com/viewtopic.php?p=50885#p50885
[2] https://forum.hyperion-entertainment.com/viewtopic.php?p=50982#p50982
[3] https://forum.hyperion-entertainment.com/viewtopic.php?p=50980#p50980
