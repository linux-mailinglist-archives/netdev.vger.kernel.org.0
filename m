Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5EE1E85DD
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgE2RzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:55:01 -0400
Received: from mout.web.de ([212.227.15.14]:56959 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2Ry6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590774870;
        bh=rXc/VlSgXGWP2A5hUEuGwiTD1zS1QauhL6++4oPFgHk=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=QlUbF2ystA5CCd39O3cPbV61lDW3jKMO0VeVliVHPhTKqfwEJjOVTwPG4y5OrJ1AS
         IlG6RITISB31XxEZmEGnkqTk1gttpSInEvqMdh/ZRM3WfnFQPWsM0UpHrX78OKWk6m
         kcUrn9dNN8N/+/KA9VMK08ApHktuufZhJINEz4Kk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.165.0]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MINMF-1jiIFW3sDf-0048iI; Fri, 29
 May 2020 19:54:30 +0200
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <snelson@pensando.io>,
        Wang Liang <wang.liang82@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>,
        Xue Zhihong <xue.zhihong@zte.com.cn>
Subject: Re: [PATCH] net: atm: Replace kmalloc with kzalloc in the error
 message
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Liao Pingfang <liao.pingfang@zte.com.cn>,
        netdev@vger.kernel.org
Message-ID: <5e2d3852-9b10-e918-c50a-2a11a46472d8@web.de>
Date:   Fri, 29 May 2020 19:54:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:/LQHpAcxfkyWwu3MAsBgwztjnH+riWwUaK4onnZJCgUSnc7NBiy
 u1cNbC1sj+42ibEfNuXxyDjbx1u4zcRFjL/nunRIEO+NrOjJ+3SHf/K3JT5aTI7zzLmCmID
 UHqbfXBnL10xLfQ3aTKzB79Bb2qDHJNYWqWUlCCLXzYm4XlF+VPV21A9w24Ja+gzMvll0wV
 VstattXEKimsAv5x1009w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YI9lEl6e8CI=:jw5CncXudb17Ga8gt9gkOx
 /K/WLCESrIq6Aijpd+uoaOG8uPvhM7NZMwncaekguJtwUB73W1DOuoP7p6o8znXvm+JTdUK3x
 uWWuBmZN2/qpNu7S9dmQrl9/Elc5xaZP3gHXxxUVNgvfn/n0TuwWVYUj5lx5CWR7G4U265HM9
 FIGPWQ78qxace+mURsbufGFf4NZ7GVwVYk6KdEhMbaggNKl2/+wcu1D45SmjEAeSCNcROGODS
 doWO4wE+bfctj+HC807Vl32GaVEj3vlEJSkSvOy76hPW4JVqtKBgnEPO3ZEmhA4oRCIq4YilU
 7wsFEjf0anFmdNaJ45sj/DPYd8ySRqC/t+5EYfhTkRMy8RY7XuW6GI/wfZSKdavirMvNgE5/y
 522YT7VTt/qWfIQwqZYKkoJUmy59xxtXHZYHZk8MNWRgGGO64gH/s1uVl28DXC8j6Hm4VA06x
 xkL7tqSW+QtgqwXDsUvIEkS7aIQWACRR7dZ4qkM9NNc5wV3K2LGcvDJcnap4JDsPo+T7O+s3x
 muWI+ZRsPX4+loewrBqAVLtaNENYHm9rz/OPZCql723tTLu+ReUPpPAyAagmMfSSzGq55xJIw
 WkhLL/HGr89OlI/SfneYP20m2nryh3FO9H2OOzVG6nV3p5vsig0njfpmROEBn6Imzo1mTLuxG
 w2jzzTnBzhza389KWxgpvYDCsCpvjfT2jDxS4FqcgbfxuXHOWQM2W1twu80GbOOGf6IPLdBOf
 VlFSY7f9Hr7C3AhyGtgjODrwZ9H0oTA91wKc5BS8gxYuGsZ3P1EQkG/XYe1uslgW5VrZU0k8K
 eyMO+pZZswF9WVoBKfc/QTI3mjIEHN8hWPx1p2RGnbqMsE24Xcqh7cB8ETTUOCu0on2f1RhPK
 U7/cJEaXtQzVMEpqCI80JY7NoL4qY25IxyySQISYLdZazdwS+dnnP1UzU23gbDreIHJdsHqj+
 z6amK597/GXuliS9YmhKjn2/2R86KX4Ha6KUNxVfZuU2d7MlZD1gA/8/RIB13s/MoHNWibknc
 +AQOzw3NhACamARFrlziR8yadgnTRVvcLNJH/pAR2/+s0FUb0OgstAhz6mPFK3rT1pOpSJH+z
 XtdR6cYnE59ArifPXbGg8HXx5s50/hP+p/qyIPUYdscU2WUED6NoZNmRYW+ZYyws9c2G1FfzR
 MXZAbSFeK50DW0+a9K5QI8S0eI4YTF4gPQICZbS8R636hH/QE7Qqub1uQ8laW5PjTQGNpzGv+
 1GI2Wa9dhPcKHP+C+
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Looking into the context (atomic!) and error message itself I would rather drop
> message completely.

How do you think about to take another look at a previous update suggestion
like the following?

net/atm: Delete an error message for a failed memory allocation in five functions
https://patchwork.ozlabs.org/project/netdev/patch/5270f15b-5e97-0c3e-3e55-fbded48ae07d@users.sourceforge.net/
https://lore.kernel.org/lkml/5270f15b-5e97-0c3e-3e55-fbded48ae07d@users.sourceforge.net/
https://lore.kernel.org/patchwork/patch/838867/
https://lkml.org/lkml/2017/10/9/1009

Regards,
Markus
